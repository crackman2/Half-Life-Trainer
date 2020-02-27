unit Unit1;

{$mode objfpc}{$H+}

interface


{
///////////////////////NOTIZEN///////////////////////
-------
       hl.dll+6D5C3 - 4A                    - dec edx //DEC 357 AMMO X
       hl.dll+3A616 - 48                    - dec eax //DEC Pistol AMMO X
       hl.dll+4B990 - 4A                    - dec edx //DEC SMG AMMO   X
       hl.dll+76267 - 4A                    - dec edx //DEC Shotgun AMMO X
       hl.dll+1DF4A - 48                    - dec eax //DEC Crossbow AMMO X
       hl.dll+6F74A - 49                    - dec ecx //DEC Rocket AMMO   X
       hl.dll+25DDA - 2B C2                 - sub eax,edx //DEC Egon  X
       hl.dll+3BD33 - 4F                    - dec edi //DEC Hornet AMMO  X
       hl.dll+352C7 - 4F                    - dec edi //DEC Nades  X
       hl.dll+705AF - 49                    - dec ecx //DEC Satchel  X
       hl.dll+86371 - 49                    - dec ecx //DEC Mines X
       hl.dll+7BFF2 - 49                    - dec ecx //DEC Snarks  X
       hl.dll+4BBE2 - 4F                    - dec edi //DEC SMG Launcher X
       hl.dll+2FFE1 - 83 C1 FE              - add ecx,-02//DEC Gauss  X
       hl.dll+30115 - 49                    - dec ecx //DEC Gauss   X
       hl.dll+30264 - 49                    - dec ecx //DEC Gauss
       hl.dll+632E8 - 74 08                 - je hl.dll+632F2 //inf firerate  X
       hl.dll+3C59C - 49                    - dec ecx //Hornet gun rechtsklick
       hl.dll+4BCE3 - D8 05 A035A20A        - fadd dword ptr [hl.dll+A35A0]//smgnade X
       client.dll+1BF66 - 89 97 90000000        - mov [edi+00000090],edx//smgnade


}


uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ComCtrls,
  StdCtrls, ExtCtrls, jwatlhelp32, Windows;

type

  { TForm1 }

  TForm1 = class(TForm)
    ButtonHelp: TButton;
    ButtonReInit: TButton;
    CheckBoxProperRapidfire: TCheckBox;
    CheckBoxInfAmmo: TCheckBox;
    CheckBoxEnableAPRegen: TCheckBox;
    CheckBoxEnableHPRegen: TCheckBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    LabelAPRate: TLabel;
    LabelMaxHP: TLabel;
    LabelMaxAP: TLabel;
    Label5: TLabel;
    LabelHPRate: TLabel;
    TimerGetRapidFireAddress: TTimer;
    TimerRegen: TTimer;
    TrackBarAPRate: TTrackBar;
    TrackBarMaxHP: TTrackBar;
    TrackBarMaxAP: TTrackBar;
    TrackBarHPRate: TTrackBar;
    procedure ButtonHelpClick(Sender: TObject);
    procedure ButtonReInitClick(Sender: TObject);

    procedure CheckBoxInfAmmoChange(Sender: TObject);
    procedure CheckBoxProperRapidfireChange(Sender: TObject);

    procedure FormCreate(Sender: TObject);
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
    dwAddMidair: DWORD;
    dwAddRapidfire: DWORD;
    fHP: single;
    fAP: single;
    fMaxHP: single;
    fMaxAP: single;
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




{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);// ENTRYYYYYYYYY
var
  ModBase: DWORD;
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
      ShowMessage('Waiting for game...');
      GameFound := True;
    end;
    Sleep(100);
  end;

  //===HP and AP Addresses===
  ModBase := DWORD(GetModuleBaseAddress(dwProcessId, 'hw.dll'));
  ReadProcessMemory(hProcess, Pointer(ModBase + $658480), @Brendan.dwAddHP,   // X
    sizeof(Brendan.dwAddHP), nil);
  Brendan.dwAddHP := Brendan.dwAddHP + $1E0; //X
  Brendan.dwAddAP := Brendan.dwAddHP + $5C;  //X


  //===Bhop midair check===
  //"hw.dll"+007E6478// Midair Value
  temp := ReadDword(ModBase + $7E6478) + $6BC;
  temp := ReadDword(temp) + $274;
  temp := ReadDword(temp) + $7e4;
  temp := ReadDword(temp) + $3a0;
  //Brendan.dwAddMidair := ReadDword(temp) + $5c;
  Brendan.dwAddMidair := $18D424;

  //===Rapid fire===
  Brendan.dwAddRapidfire := GetRapidFireAddress(ModBase);
  {
  temp := 0;
  temp := ReadDword(ModBase + $A20A4C) + $EC;
  temp := ReadDword(temp) + $78;
  temp := ReadDword(temp) + $6A8;
  temp := ReadDword(temp) + $4C8;
  Brendan.dwAddRapidfire := ReadDword(temp) + $8C;
  }

  //unnötig aber gerade kb das besser zu machen
  dwHWBase := ModBase;


  //Infammo in HL.dll
  dwHLBase := DWORD(GetModuleBaseAddress(dwProcessId, 'hl.dll'));
  dwCLIENTBase := DWORD(GetModuleBaseAddress(dwProcessId, 'client.dll'));

  if ReIniter then
  begin
    ShowMessage('Done.');
  end;

end;









procedure TForm1.CheckBoxInfAmmoChange(Sender: TObject);
begin
  if CheckBoxInfAmmo.Checked then
  begin
    //NOPping dec opcode (or sub for the egon)
    WriteByte($90, dwHLBase + $6D5C3); //357 X
    WriteByte($90, dwHLBase + $3A616); //Pistol X
    WriteByte($90, dwHLBase + $4B990); //SMG X
    WriteByte($90, dwHLBase + $76267); //Shotgun X
    WriteByte($90, dwHLBase + $1DF4A); //Crossbow X
    WriteByte($90, dwHLBase + $6F74A); //Rockets X
    WriteByte($90, dwHLBase + $25DDA); //Egon 1 X
    WriteByte($90, dwHLBase + $25DDB); //Egon 2 X
    // hl.dll+3C59C - 49                    - dec ecx //Hornet gun rechtsklick
    WriteByte($90, dwHLBase + $3BD33); //Hornet 2 X
    //WriteByte($90, dwHLBase + $3C59C); //Hornet rechtsklick
    WriteByte($90, dwHLBase + $352C7); //Nades   X
    WriteByte($90, dwHLBase + $705AF); //Satchel X
    WriteByte($90, dwHLBase + $86371); //Mines X
    WriteByte($90, dwHLBase + $7BFF2); //Snarks X
    WriteByte($90, dwHLBase + $4BBE2); //SMG Launcher
    WriteByte($90, dwHLBase + $2FFE1); //Gauss
    WriteByte($90, dwHLBase + $2FFE2); //Gauss
    WriteByte($90, dwHLBase + $2FFE3); //Gauss
    WriteByte($90, dwHLBase + $30115); //Gauss
    //WriteByte($90, dwHLBase + $301B4); //Gauss
  end
  else
  begin
    WriteByte($4A, dwHLBase + $6D5C3); //357 X
    WriteByte($48, dwHLBase + $3A616); //Pistol X
    WriteByte($4A, dwHLBase + $4B990); //SMG  X
    WriteByte($4A, dwHLBase + $76267); //Shotgun X
    WriteByte($48, dwHLBase + $1DF4A); //Crossbow X
    WriteByte($49, dwHLBase + $6F74A); //Rockets X
    WriteByte($2B, dwHLBase + $25DDA); //Egon 1 X
    WriteByte($C2, dwHLBase + $25DDB); //Egon 2 X
    WriteByte($4F, dwHLBase + $3BD33); //Hornet 2 X
    //WriteByte($49, dwHLBase + $3C59C);  Hornet Rightclick
    WriteByte($4F, dwHLBase + $352C7); //Nades X
    WriteByte($49, dwHLBase + $705AF); //Satchel X
    WriteByte($49, dwHLBase + $86371); //Mines X
    WriteByte($49, dwHLBase + $7BFF2); //Snarks X
    WriteByte($4F, dwHLBase + $4BBE2); //SMG Launcher X
    WriteByte($83, dwHLBase + $2FFE1); //Gauss X
    WriteByte($C1, dwHLBase + $2FFE2); //Gauss X
    WriteByte($FE, dwHLBase + $2FFE3); //Gauss X
    WriteByte($49, dwHLBase + $30115); //Gauss X
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
    WriteByte($90, dwHLBase + $632E8);
    WriteByte($90, dwHLBase + $632E9);
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
    WriteByte($74, dwHLBase + $632E8);
    WriteByte($08, dwHLBase + $632E9);

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

procedure TForm1.ButtonHelpClick(Sender: TObject);
begin
  ShowMessage(  'Half-Life Trainer v1.1' + sLineBreak +
                'by pombenenge (on YouTube)' + sLineBreak +
                'Last Updated: 2020-02-27' + sLineBreak +
                'hl.exe version: 1.1.1.1' + sLineBreak + sLineBreak +
                'WARNING: The Trainer may cause crashes. Save often' + sLineBreak + sLineBreak +
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
                '   4. The hack may be outdated. (If you have confirmed that everything else is not the cause' + sLineBreak +
                '       contact me)' + sLineBreak + sLineBreak +
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
