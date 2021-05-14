unit Unit1;

{$mode objfpc}{$H+}

interface


{
///////////////////////NOTIZEN///////////////////////
-------
       hl.dll+6D5F3 - 4A                    - dec edx //DEC 357 AMMO X          BROKEN fixed
       hl.dll+3A616 - 48                    - dec eax //DEC Pistol AMMO
       hl.dll+4B990 - 4A                    - dec edx //DEC SMG AMMO
       hl.dll+76297 - 4A                    - dec edx //DEC Shotgun AMMO        BROKEN fixed
       hl.dll+764DA - 83 C2 FE              - add edx,-02 // Shotgun doppelschuss fixed
       hl.dll+1DF4A - 48                    - dec eax //DEC Crossbow AMMO
       hl.dll+6F77A - 49                    - dec ecx //DEC Rocket AMMO         CRASH fixed
       hl.dll+25DDA - 2B C2                 - sub eax,edx //DEC Egon
       hl.dll+3BD33 - 4F                    - dec edi //DEC Hornet AMMO
       hl.dll+352C7 - 4F                    - dec edi //DEC Nades
       hl.dll+705DF - 49                    - dec ecx //DEC Satchel             CRASH fixed
       hl.dll+863A1 - 49                    - dec ecx //DEC Mines               BROKEN fixed
       hl.dll+7C022 - 49                    - dec ecx //DEC Snarks              BROKEN fixed
       hl.dll+4BBE2 - 4F                    - dec edi //DEC SMG Launcher
       hl.dll+2FFE1 - 83 C1 FE              - add ecx,-02//DEC Gauss            RIGHT CLICK BROKEN fixed
       hl.dll+30115 - 49                    - dec ecx //DEC Gauss               RIGHT CLICK BROKEN fixed
       hl.dll+30264 - 49                    - dec ecx //DEC Gauss Right click   RIGHT CLICK BROKEN fixed
       hl.dll+63318 - 74 08                 - je hl.dll+63322 //inf firerate
       hl.dll+3C63C - 49                    - dec ecx //Hornet gun rechtsklick  BROKEN
       hl.dll+4BCE3 - D8 05 A035A20A        - fadd dword ptr [hl.dll+A35A0]//smgnade
       client.dll+1BF86 - 89 97 90000000        - mov [edi+00000090],edx//smgnade


}


uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ComCtrls,
  StdCtrls, ExtCtrls, jwatlhelp32, Windows,LCLIntf, strutils;

type

  { TForm1 }

  TForm1 = class(TForm)
    ButtonHelp: TButton;
    ButtonReInit: TButton;
    CheckBoxAutoBhop: TCheckBox;
    CheckBoxProperRapidfire: TCheckBox;
    CheckBoxInfAmmo: TCheckBox;
    CheckBoxEnableAPRegen: TCheckBox;
    CheckBoxEnableHPRegen: TCheckBox;
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    LabelStatus: TLabel;
    LabelAPRate: TLabel;
    LabelMaxHP: TLabel;
    LabelMaxAP: TLabel;
    Label5: TLabel;
    LabelHPRate: TLabel;
    TimerBhop: TTimer;
    TimerGameStatus: TTimer;
    TimerGetRapidFireAddress: TTimer;
    TimerRegen: TTimer;
    TrackBarAPRate: TTrackBar;
    TrackBarMaxHP: TTrackBar;
    TrackBarMaxAP: TTrackBar;
    TrackBarHPRate: TTrackBar;
    procedure ButtonHelpClick(Sender: TObject);
    procedure ButtonReInitClick(Sender: TObject);
    procedure CheckBoxAutoBhopChange(Sender: TObject);
    procedure CheckBoxEnableAPRegenChange(Sender: TObject);
    procedure CheckBoxEnableHPRegenChange(Sender: TObject);

    procedure CheckBoxInfAmmoChange(Sender: TObject);
    procedure CheckBoxProperRapidfireChange(Sender: TObject);

    procedure FormCreate(Sender: TObject);
    procedure Image1Click(Sender: TObject);
    procedure Image2Click(Sender: TObject);
    procedure Image3Click(Sender: TObject);
    procedure TimerBhopTimer(Sender: TObject);
    procedure TimerGameStatusTimer(Sender: TObject);
    procedure TimerRegenTimer(Sender: TObject);
    procedure TrackBarAPRateChange(Sender: TObject);
    procedure TrackBarHPRateChange(Sender: TObject);
    procedure TrackBarMaxAPChange(Sender: TObject);
    procedure TrackBarMaxHPChange(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;


  //AU3_API void WINAPI AU3_Send(LPCWSTR szSendText, int nMode = 0);



  TLocalPlayer = record
    dwAddHP: DWORD;
    dwAddAP: DWORD;
    dwJValue:DWORD;
    dwOnGround:DWORD;
    dwAddMidair: DWORD;
    dwAddRapidfire: DWORD;
    bOnGround:BYTE;
    fHP: single;
    fAP: single;
    fMaxHP: single;
    fMaxAP: single;
    fJValue:single;
    fHPRate: single;
    fAPRate: single;
    fMidair: single;
    fRapidfire: single;
  end;

var
  Form1: TForm1;
  hProcess: HANDLE;
  dwProcessId: DWORD;
  Brendan: TLocalPlayer;
  hFenster: HWND;
  ReIniter: boolean = False;
  dwHWBase: DWORD;
  dwHLBase: DWORD;
  dwCLIENTBase: DWORD;
  bSMGNadeOriginalCode:array[0..5] of Byte;
  i:integer; //for loop indexer
  KeyWord:PWord;
  KeyStr:AnsiString;




implementation

{$R *.lfm}



function GetModuleBaseAddress(hProcID: cardinal; lpModName: PChar): Pointer;
var
  hSnap: cardinal;
  tm: TModuleEntry32;
begin
  //result := 0;
  hSnap := CreateToolHelp32Snapshot(TH32CS_SNAPMODULE, hProcID);
  if hSnap <> 0 then
  begin
    tm.dwSize := sizeof(TModuleEntry32);
    if Module32First(hSnap, tm) = True then
    begin
      while Module32Next(hSnap, tm) = True do
      begin
        if lstrcmpi(tm.szModule, lpModName) = 0 then
        begin
          Result := Pointer(tm.modBaseAddr);
          break;
        end;
      end;
    end;
    CloseHandle(hSnap);
  end;
end;

procedure WriteFloat(Value: single; Address: DWORD);
begin
  WriteProcessMemory(hProcess, Pointer(Address), @Value, sizeof(Value), nil);
end;

procedure WriteByte(Value: byte; Address: DWORD);
begin
  WriteProcessMemory(hProcess, Pointer(Address), @Value, sizeof(Value), nil);
end;

function ReadByte(Address: DWORD):Byte;
begin
  ReadProcessMemory(hProcess, Pointer(Address), @Result, sizeof(Result), nil);
end;

procedure WriteWord(Value: Word; Address: DWORD);
begin
  WriteProcessMemory(hProcess, Pointer(Address), @Value, sizeof(Value), nil);
end;

function ReadWord(Address: DWORD):Word;
begin
  ReadProcessMemory(hProcess, Pointer(Address), @Result, sizeof(Result), nil);
end;

function ReadFloat(Address: DWORD): single;
begin
  ReadProcessMemory(hProcess, Pointer(Address), @Result, sizeof(Result), nil);
end;

function ReadDword(Address: DWORD): DWORD;
begin
  ReadProcessMemory(hProcess, Pointer(Address), @Result, sizeof(Result), nil);
end;




function GetRapidFireAddress(ModBase: DWORD): DWORD;
var
  temp: DWORD = 0;
begin
  temp := 0;
  temp := ReadDword(ModBase + $A20A4C) + $EC;
  temp := ReadDword(temp) + $78;
  temp := ReadDword(temp) + $6A8;
  temp := ReadDword(temp) + $4C8;
  Result := ReadDword(temp) + $8C;
end;


 function GetProcId(ProcName:PChar):DWORD;
 var pe32:PROCESSENTRY32;
     hSnapshot:HANDLE=0;
 begin
      pe32.dwSize:= sizeof(PROCESSENTRY32);
      hSnapshot:= CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS,0);

      if(Process32First(hSnapshot,pe32)) then
      begin
          repeat
               if lstrcmpi(pe32.szExeFile,ProcName) = 0 then Break;
          until  not (Process32Next( hSnapshot, &pe32 ))  ;
      end;

      if(hSnapshot <> INVALID_HANDLE_VALUE) then CloseHandle(hSnapshot);

     Result:= pe32.th32ProcessID;
 end;

procedure InitAddresses();
var
      ModBase: DWORD;
begin
    /// PATCH: "hw.dll"+007F6304  {   1E0 }
  ModBase := DWORD(GetModuleBaseAddress(dwProcessId, 'hw.dll'));
  ReadProcessMemory(hProcess, Pointer(ModBase + $7F6304), @Brendan.dwAddHP,   // X
    sizeof(Brendan.dwAddHP), nil);
  Brendan.dwJValue:= Brendan.dwAddHP + $A8;
  Brendan.dwAddHP := Brendan.dwAddHP + $1E0; //X
  Brendan.dwAddAP := Brendan.dwAddHP + $5C;  //X
  Brendan.dwOnGround:=ModBase + $122E2D4;




  //unnötig aber gerade kb das besser zu machen
  dwHWBase := ModBase;
  //Infammo in HL.dll
  dwHLBase := DWORD(GetModuleBaseAddress(dwProcessId, 'hl.dll'));
  dwCLIENTBase := DWORD(GetModuleBaseAddress(dwProcessId, 'client.dll'));
end;

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);// ENTRYYYYYYYYY
var
  GameFound: boolean = False;
  temp: DWORD;
begin
  //Initialization
  LabelMaxHP.Caption := IntToStr(TrackBarMaxHP.Position - 1);
  LabelMaxAP.Caption := IntToStr(TrackBarMaxAP.Position - 1);
  LabelHPRate.Caption := floatToStr(TrackBarHPRate.Position / 10);
  LabelAPRate.Caption := floatToStr(TrackBarAPRate.Position / 10);
  Brendan.fHPRate := TrackBarHPRate.Position / 1000;
  Brendan.fAPRate := TrackBarAPRate.Position / 1000;



  //Fenster Handle , ProcessId, OpenProcess-Handle..
  hProcess := 0;
  while hProcess = 0 do
  begin
    //hFenster := FindWindow(nil, 'Half-Life');
    //GetWindowThreadProcessId(hFenster, @dwProcessId);
    dwProcessId:= GetProcId('hl.exe');
    hProcess := OpenProcess(PROCESS_ALL_ACCESS, False, dwProcessId);
    if (hProcess = $0000) and (GameFound = False) then
    begin
      Form1.LabelStatus.Caption:= 'Status: Game not found. Start Half-life!';
      Form1.LabelStatus.Font.Color:= $0000DD;
      ShowMessage('Waiting for game...');
      GameFound := True;
    end;
    Sleep(100);
  end;
  Form1.LabelStatus.Caption:= 'Status: Game found!';
  Form1.LabelStatus.Font.Color:= $00DD00;

  Form1.TimerGameStatus.Enabled:=true;

  //===HP and AP Addresses===
  InitAddresses();

  if ReIniter then
  begin
    ShowMessage('Done.');
  end;

end;

procedure TForm1.Image1Click(Sender: TObject);
begin
  OpenURL('https://github.com/crackman2/Half-Life-Trainer');
end;

procedure TForm1.Image2Click(Sender: TObject);
begin
  OpenURL('https://www.youtube.com/user/pombenenge');
end;

procedure TForm1.Image3Click(Sender: TObject);
begin
  OpenURL('https://www.paypal.com/donate?hosted_button_id=24RWVGKZGRVMW');
end;

procedure TForm1.TimerBhopTimer(Sender: TObject);
var
  OnGround:BYTE=0;
begin
  KeyStr:=ReverseString(IntToBin(ReadWord(dwHWBase+$9CF548),16));

  Brendan.bOnGround:=ReadByte(Brendan.dwOnGround);
  Brendan.fJValue:=ReadFloat(Brendan.dwJValue);


  //JValue:=PSingle(hwBaseAndBaseOffset^ + $A8);


  if (KeyStr[2] = '1') and (Brendan.fJValue <= 0) and (Brendan.bOnGround=1) then
  begin
    WriteFloat(237.0,Brendan.dwJValue);
  end;


end;

procedure TForm1.TimerGameStatusTimer(Sender: TObject);
begin
  dwProcessId:= GetProcId('hl.exe');
  //Form1.LabelStatus.Caption:= 'ID: ' + IntToStr(dwProcessId);
  if dwProcessId = 6619182 then
  begin
     Form1.LabelStatus.Caption:='Status: Game not running anymore!';
     Form1.LabelStatus.Font.Color := $0000DD;
  end
  else
  begin
    InitAddresses();
  end;
end;









procedure TForm1.CheckBoxInfAmmoChange(Sender: TObject);
begin
  if CheckBoxInfAmmo.Checked then
  begin
    //NOPping dec opcode (or sub for the egon)

    WriteByte($90, dwHLBase + $6D5F3); //357 X  FIXED
    WriteByte($90, dwHLBase + $3A616); //Pistol X
    WriteByte($90, dwHLBase + $4B990); //SMG X
    WriteByte($90, dwHLBase + $76297); //Shotgun X FIXED 764DA
    WriteByte($90, dwHLBase + $764DA); //Shotgun Doppelschuss  FIXED
    WriteByte($90, dwHLBase + $764DA+1); //Shotgun Doppelschuss
    WriteByte($90, dwHLBase + $764DA+2); //Shotgun Doppelschuss
    WriteByte($90, dwHLBase + $1DF4A); //Crossbow X
    WriteByte($90, dwHLBase + $6F77A); //Rockets X
    WriteByte($90, dwHLBase + $25DDA); //Egon 1 X
    WriteByte($90, dwHLBase + $25DDB); //Egon 2 X
    // hl.dll+3C59C - 49                    - dec ecx //Hornet gun rechtsklick
    WriteByte($90, dwHLBase + $3BD33); //Hornet 2 X
    WriteByte($90, dwHLBase + $3C63C); //Hornet rechtsklick
    WriteByte($90, dwHLBase + $352C7); //Nades   X
    WriteByte($90, dwHLBase + $705DF); //Satchel X
    WriteByte($90, dwHLBase + $863A1); //Mines X
    WriteByte($90, dwHLBase + $7C022); //Snarks X
    WriteByte($90, dwHLBase + $4BBE2); //SMG Launcher
    WriteByte($90, dwHLBase + $2FFE1); //Gauss
    WriteByte($90, dwHLBase + $2FFE2); //Gauss
    WriteByte($90, dwHLBase + $2FFE3); //Gauss
    WriteByte($90, dwHLBase + $30115); //Gauss
    WriteByte($90, dwHLBase + $30264); //Gauss Right Click
    //WriteByte($90, dwHLBase + $301B4); //Gauss
  end
  else
  begin
    WriteByte($4A, dwHLBase + $6D5F3); //357 X
    WriteByte($48, dwHLBase + $3A616); //Pistol X
    WriteByte($4A, dwHLBase + $4B990); //SMG  X
    WriteByte($4A, dwHLBase + $76297); //Shotgun X
    WriteByte($83, dwHLBase + $764DA); //Shotgun Doppelschuss  83 C2 FE
    WriteByte($C2, dwHLBase + $764DA+1); //Shotgun Doppelschuss
    WriteByte($FE, dwHLBase + $764DA+2); //Shotgun Doppelschuss
    WriteByte($48, dwHLBase + $1DF4A); //Crossbow X
    WriteByte($49, dwHLBase + $6F77A ); //Rockets X
    WriteByte($2B, dwHLBase + $25DDA); //Egon 1 X
    WriteByte($C2, dwHLBase + $25DDB); //Egon 2 X
    WriteByte($4F, dwHLBase + $3BD33); //Hornet 2 X
    WriteByte($49, dwHLBase + $3C63C);  //Hornet Rightclick
    WriteByte($4F, dwHLBase + $352C7); //Nades X
    WriteByte($49, dwHLBase + $705DF); //Satchel X
    WriteByte($49, dwHLBase + $863A1); //Mines X
    WriteByte($49, dwHLBase + $7C022); //Snarks X
    WriteByte($4F, dwHLBase + $4BBE2); //SMG Launcher X
    WriteByte($83, dwHLBase + $2FFE1); //Gauss X
    WriteByte($C1, dwHLBase + $2FFE2); //Gauss X
    WriteByte($FE, dwHLBase + $2FFE3); //Gauss X
    WriteByte($49, dwHLBase + $30115); //Gauss X
    WriteByte($49, dwHLBase + $30264); //Gauss Right click
    //WriteByte($49, dwHLBase + $301B4); //Gauss
  end;

end;


{
       hl.dll+632E8 - 74 08                 - je hl.dll+632F2 //inf firerate  X
       hl.dll+3C59C - 49                    - dec ecx //Hornet gun rechtsklick
       hl.dll+4BCE3 - D8 05 A035A20A        - fadd dword ptr [hl.dll+A35A0]//smgnade X
       client.dll+1BF66 - 89 97 90000000        - mov [edi+00000090],edx//smgnade
}
procedure TForm1.CheckBoxProperRapidfireChange(Sender: TObject);
begin

  if (CheckBoxProperRapidfire.Checked) then
  begin
    //Rapid fire all guns  X
    WriteByte($90, dwHLBase + $63318);
    WriteByte($90, dwHLBase + $63319);
    //rapid smg nades  X

    for i:= 0 to 5 do
    begin
      bSMGNadeOriginalCode[i] := ReadByte(dwHLBase + $4BCE3 + i);
    end;

    WriteByte($90, dwHLBase + $4BCE3);
    WriteByte($90, dwHLBase + $4BCE4);
    WriteByte($90, dwHLBase + $4BCE5);
    WriteByte($90, dwHLBase + $4BCE6);
    WriteByte($90, dwHLBase + $4BCE7);
    WriteByte($90, dwHLBase + $4BCE8);
    //rapid smg nades
    //WriteByte($90, dwCLIENTBase + $1BF66);
    //WriteByte($90, dwCLIENTBase + $1BF67);
    //WriteByte($90, dwCLIENTBase + $1BF68);
    //WriteByte($90, dwCLIENTBase + $1BF69);
   // WriteByte($90, dwCLIENTBase + $1BF6A);
   // WriteByte($90, dwCLIENTBase + $1BF6B);

  end
  else
  begin
    //hl.dll+4BB43 - D8 05 A035A20A        - fadd dword ptr [hl.dll+A35A0]//smgnade
    //client.dll+1BF66 - 89 97 90000000        - mov [edi+00000090],edx//smgnade
    WriteByte($74, dwHLBase + $63318);
    WriteByte($08, dwHLBase + $63319);

    {
    WriteByte($D8, dwHLBase + $4BCE3);
    WriteByte($05, dwHLBase + $4BCE4);
    WriteByte($A0, dwHLBase + $4BCE5);
    WriteByte($35, dwHLBase + $4BCE6);
    WriteByte($F1, dwHLBase + $4BCE7);
    WriteByte($07, dwHLBase + $4BCE9);
    }

    for i:= 0 to 5 do
    begin
      WriteByte(bSMGNadeOriginalCode[i], dwHLBase + $4BCE3 + i)
    end;

    //WriteByte($89, dwCLIENTBase + $1BF66);
    //WriteByte($97, dwCLIENTBase + $1BF67);
    //WriteByte($90, dwCLIENTBase + $1BF68);
    //WriteByte($00, dwCLIENTBase + $1BF69);
    //WriteByte($00, dwCLIENTBase + $1BF6A);
    //WriteByte($00, dwCLIENTBase + $1BF6B);
  end;

end;



procedure TForm1.ButtonReInitClick(Sender: TObject);
begin
  //reinitialisieren

  CheckBoxProperRapidfire.Checked := False;
  CheckBoxInfAmmo.Checked := False;
  ReIniter := True;
  FormCreate(nil);
end;

procedure TForm1.CheckBoxAutoBhopChange(Sender: TObject);
begin
  if CheckBoxAutoBhop.Checked then
     TimerBhop.Enabled:=True
     else
     TimerBhop.Enabled:=False;
end;

procedure TForm1.CheckBoxEnableAPRegenChange(Sender: TObject);
begin

end;

procedure TForm1.CheckBoxEnableHPRegenChange(Sender: TObject);
begin

end;

procedure TForm1.ButtonHelpClick(Sender: TObject);
begin
  ShowMessage(  'Half-Life Trainer v1.2.1' + sLineBreak +
                'by pombenenge (on YouTube)' + sLineBreak +
                'Last Updated: 2021-05-14' + sLineBreak +
                'hl.exe version: 1.1.1.1 (Doesn''t mean much in terms of compatibility)' + sLineBreak + sLineBreak +
                'Features: Health and Armor regeneration, Rapidfire, Infinite Ammo' + sLineBreak + sLineBreak +
                'WARNING: The Trainer may cause crashes. Save often.' + sLineBreak + sLineBreak +
                '-- How to use --' + sLineBreak +
                '1. Start Half-life (Tested on Steam version, other versions may or may not work)' + sLineBreak +
                '2. Start the Trainer (If the trainer is already running, click on "Reinitialize")' + sLineBreak +
                '3. Adjust Trainer settings to your liking.' + sLineBreak + sLineBreak +
                '-- FAQ --' + sLineBreak +
                'Q: Does it work in multiplayer?' + sLineBreak +
                'A: No. If you try you will get VAC banned. Seriously, do NOT do it.' + sLineBreak + sLineBreak +
                'Q: Nothing happens? Why?' + sLineBreak +
                'A: There can be multiple reasons why it does not work.' + sLineBreak +
                '   1. You probably need the Steam version of Half-Life.' + sLineBreak +
                '   2. Run the Trainer as administrator.' + sLineBreak +
                '   3. Check the instructions above and make sure you are doing it right.' + sLineBreak +
                '   4. The Trainer may be outdated. (If you have confirmed that everything else is not the cause' + sLineBreak +
                '       contact me on YouTube)' + sLineBreak + sLineBreak +
                'Q: Why do I explode when I spam SMG grenades' + sLineBreak +
                'A: When you are in the main menu type "fps_max 100". In-Game try walking backwards or' + sLineBreak +
                '     moving your mouse left or right while shooting grenades.' + sLineBreak +
                '     The grenades must not collide in mid air!' + sLineBreak + sLineBreak +
                'Q: My pirated version of the game won''t work with this trainer!' + sLineBreak +
                'A: Buy the damn game! It''s like 10 bucks jfc..' + sLineBreak +
                '     If you''re too poor, here is your answer: Cracked versions are not supported.' + sLineBreak + sLineBreak +
                'Click on the icons for GitHub and Youtube links' + sLineBreak + sLineBreak +
                'Have fun!'
                );
end;


procedure TForm1.TimerRegenTimer(Sender: TObject);
begin
  //Read HP & AP
  Brendan.fHP := ReadFloat(Brendan.dwAddHP);
  Brendan.fAP := ReadFloat(Brendan.dwAddAP);

  // Regenerate HP
  if CheckBoxEnableHPRegen.Checked then
    if (Brendan.fHP + (Brendan.fHPRate) < TrackBarMaxHP.Position) then
    begin
      Brendan.fHP := Brendan.fHP + Brendan.fHPRate;
      WriteFloat(Brendan.fHP, Brendan.dwAddHP);
    end
    else if (Brendan.fHP - (Brendan.fHPRate) > TrackBarMaxHP.Position) then
    begin
      Brendan.fHP := Brendan.fHP - Brendan.fHPRate;
      WriteFloat(Brendan.fHP, Brendan.dwAddHP);
    end;


  //Regenerate AP
  if CheckBoxEnableAPRegen.Checked then
    if (Brendan.fAP + (Brendan.fAPRate) < TrackBarMaxAP.Position) then
    begin
      Brendan.fAP := Brendan.fAP + Brendan.fAPRate;
      WriteFloat(Brendan.fAP, Brendan.dwAddAP);
    end
    else if (Brendan.fAP - (Brendan.fAPRate) > TrackBarMaxAP.Position) then
    begin
      Brendan.fAP := Brendan.fAP - Brendan.fAPRate;
      WriteFloat(Brendan.fAP, Brendan.dwAddAP);
    end;
end;

procedure TForm1.TrackBarAPRateChange(Sender: TObject);
begin
  LabelAPRate.Caption := floatToStr((TrackBarAPRate.Position - 1) / 10);
  Brendan.fAPRate := TrackBarAPRate.Position / 1000;
end;

procedure TForm1.TrackBarHPRateChange(Sender: TObject);
begin
  LabelHPRate.Caption := floatToStr((TrackBarHPRate.Position - 1) / 10);
  Brendan.fHPRate := TrackBarHPRate.Position / 1000;
end;

procedure TForm1.TrackBarMaxAPChange(Sender: TObject);
begin
  Brendan.fMaxAP := TrackBarMaxAP.Position;
  LabelMaxAP.Caption := IntToStr(TrackBarMaxAP.Position - 1);
end;

procedure TForm1.TrackBarMaxHPChange(Sender: TObject);
begin
  Brendan.fMaxHP := TrackBarMaxHP.Position;
  LabelMaxHP.Caption := IntToStr(TrackBarMaxHP.Position - 1);

end;



end.
