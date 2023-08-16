unit Unit1;

{$mode objfpc}{$H+}

interface


{
///////////////////////NOTIZEN///////////////////////
////////////////////HALF-LIFE////////////////////////
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


//////////////////OPPOSING FORCE/////////////////////
------
      opfor.dll+5A177 - 48                    - dec eax              Pistol 9mm
      opfor.dll+B2234 - 48                    - dec eax              357 Magnum
      opfor.dll+2D875 - 4F                    - dec edi              357 Eagle
      opfor.dll+73548 - 4A                    - dec edx              SMG
      opfor.dll+737D3 - 49                    - dec ecx              SMG Grenade
      opfor.dll+C407B - 48                    - dec eax              Shotgun Primary
      opfor.dll+C42FF - 83 C0 FE              - add eax,-02          Shotgun Secondary
      opfor.dll+247A0 - 48                    - dec eax              Crossbow
      opfor.dll+B9338 - 48                    - dec eax              RPG
      opfor.dll+40E7A - 83 C1 FE              - add ecx,-02          Gauss Primary
      opfor.dll+40FED - 49                    - dec ecx              Gauss Secondary A
      opfor.dll+4117B - 49                    - dec ecx              Gauss Secondary B
      opfor.dll+32CDA - 2B C2                 - sub eax,edx          Egon
      opfor.dll+5B95F - 49                    - dec ecx              Hornet Primary
      opfor.dll+5C2E8 - 49                    - dec ecx              Hornet Secondary
      opfor.dll+4E185 - 4A                    - dec edx              Grenade
      opfor.dll+BA2AA - 49                    - dec ecx              Satchel
      opfor.dll+DB1FC - 49                    - dec ecx              Mine
      opfor.dll+CD3A2 - 49                    - dec ecx              Snark
      opfor.dll+65356 - 4A                    - dec edx              M249
      opfor.dll+299C9 - 83 C1 EC              - add ecx,-14          Displacer
      opfor.dll+C525C - 4B                    - dec ebx              Sniper
      opfor.dll+C8F77 - 48                    - dec eax              Spore Launcher Primary
      opfor.dll+C9208 - 48                    - dec eax              Spore Launcher Secondary
      opfor.dll+C02E1 - 49                    - dec ecx              Shock Roach

//////////////////BLUE SHIFT/////////////////////
------
      hl.dll+3A425 - 48                    - dec eax                 Pistol 9mm
      hl.dll+6D6C3 - 4A                    - dec edx                 357 Magnum
      hl.dll+4BB80 - 4A                    - dec edx                 SMG
      hl.dll+4BDD2 - 4F                    - dec edi                 SMG Grenade
      hl.dll+775A6 - 4A                    - dec edx                 Shotgun Primary
      hl.dll+777E9 - 83 C2 FE              - add edx,-02             Shotgun Secondary
      hl.dll+1DB8A - 48                    - dec eax                 Crossbow
      hl.dll+70A8A - 48                    - dec eax                 RPG
      hl.dll+2FB80 - 83 C1 FE              - add ecx,-02             Gauss Primary
      hl.dll+2FCB4 - 49                    - dec ecx                 Gauss Secondary A
      hl.dll+2FE03 - 49                    - dec ecx                 Gauss Secondary B
      hl.dll+2597A - 2B C2                 - sub eax,edx             Egon
      hl.dll+3BB43 - 4A                    - dec edx                 Hornet Primary
      hl.dll+3C44C - 49                    - dec ecx                 Hornet Secodary
      hl.dll+350D6 - 4F                    - dec edi                 Grenade
      hl.dll+718E8 - FF 08                 - dec [eax]               Satchel
      hl.dll+87871 - 49                    - dec ecx                 Mine
      hl.dll+7D31E - 49                    - dec ecx                 Snark

}


uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ComCtrls,
  StdCtrls, ExtCtrls, jwatlhelp32, Windows,LCLIntf, Menus, strutils;

type

  { TForm1 }

  TForm1 = class(TForm)
    ButtonEnableAll: TButton;
    ButtonHelp: TButton;
    ButtonReInit: TButton;
    CheckBoxAutoBhop: TCheckBox;
    CheckBoxProperRapidfire: TCheckBox;
    CheckBoxInfAmmo: TCheckBox;
    CheckBoxEnableAPRegen: TCheckBox;
    CheckBoxEnableHPRegen: TCheckBox;
    EditMaxHP: TEdit;
    EditMaxAP: TEdit;
    EditHPRate: TEdit;
    EditAPRate: TEdit;
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
    MainMenuBar: TMainMenu;
    MenuItemMore: TMenuItem;
    MenuItemInject: TMenuItem;
    TimerBhop: TTimer;
    TimerGameStatus: TTimer;
    TimerEditRegenCheck: TTimer;
    TimerRegen: TTimer;
    TrackBarAPRate: TTrackBar;
    TrackBarMaxHP: TTrackBar;
    TrackBarMaxAP: TTrackBar;
    TrackBarHPRate: TTrackBar;
    procedure ButtonEnableAllClick(Sender: TObject);
    procedure ButtonHelpClick(Sender: TObject);
    procedure ButtonReInitClick(Sender: TObject);
    procedure CheckBoxAutoBhopChange(Sender: TObject);
    procedure CheckBoxEnableAPRegenChange(Sender: TObject);
    procedure CheckBoxEnableHPRegenChange(Sender: TObject);

    procedure CheckBoxInfAmmoChange(Sender: TObject);
    procedure CheckBoxProperRapidfireChange(Sender: TObject);
    procedure EditMaxHPChange(Sender: TObject);

    procedure FormCreate(Sender: TObject);
    procedure Image1Click(Sender: TObject);
    procedure Image2Click(Sender: TObject);
    procedure Image3Click(Sender: TObject);
    procedure LabelMaxHPClick(Sender: TObject);
    procedure TimerBhopTimer(Sender: TObject);
    procedure TimerGameStatusTimer(Sender: TObject);
    procedure TimerEditRegenCheckTimer(Sender: TObject);
    procedure TimerRegenTimer(Sender: TObject);
    procedure TrackBarAPRateChange(Sender: TObject);
    procedure TrackBarHPRateChange(Sender: TObject);
    procedure TrackBarMaxAPChange(Sender: TObject);
    procedure TrackBarMaxHPChange(Sender: TObject);

    procedure MenuItemInjectClick(Sender: TObject);
    function IsDllLoadedInProcess(const DllName: string; ProcessID: DWORD): Boolean;
    function InjectDll(): Boolean;

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
  LocalPlayer: TLocalPlayer;
  hFenster: HWND;
  ReIniter: boolean = False;
  dwHWBase: DWORD;
  dwHLBase: DWORD;
  dwOPFORBase: DWORD;
  dwCLIENTBase: DWORD;
  dwSDLBase: DWORD;
  bSMGNadeOriginalCode:array[0..5] of Byte;
  i:integer; //for loop indexer
  KeyWord:PWord;
  KeyStr:PChar;
  CurrentGame:AnsiString; //Identifies game, 'h' for Half-Life, 'o' for opposing force, 'b' for blueshift
  IsInGame:Boolean=false;




implementation

{$R *.lfm}



function GetModuleBaseAddress(hProcID: cardinal; lpModName: PChar): Pointer;
var
  hSnap: cardinal;
  tm: TModuleEntry32;
begin
  Result := 0;
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
begin
    /// PATCH: "hw.dll"+007F6304  {   1E0 }
  dwHWBase := DWORD(GetModuleBaseAddress(dwProcessId, 'hw.dll'));
  dwCLIENTBase := DWORD(GetModuleBaseAddress(dwProcessId, 'client.dll'));
  dwSDLBase := DWORD(GetModuleBaseAddress(dwProcessId, 'SDL2.dll'));


  if (CurrentGame = 'h') or (CurrentGame = 'b') then
    begin
      dwHLBase := DWORD(GetModuleBaseAddress(dwProcessId, 'hl.dll'));
    end
  else if  CurrentGame = 'o' then
    begin
      dwOPFORBase := DWORD(GetModuleBaseAddress(dwProcessId, 'opfor.dll'));
    end;

  ReadProcessMemory(hProcess, Pointer(dwHWBase + $7F6304), @LocalPlayer.dwAddHP, sizeof(LocalPlayer.dwAddHP), nil);
  LocalPlayer.dwJValue:= LocalPlayer.dwAddHP + $A8;
  LocalPlayer.dwAddHP := LocalPlayer.dwAddHP + $1E0; //X
  LocalPlayer.dwAddAP := LocalPlayer.dwAddHP + $5C;  //X
  LocalPlayer.dwOnGround:=dwHWBase + $122E2D4;
end;

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);// ENTRYYYYYYYYY
var
  GameFound: boolean = False;
  GameList:array[0..2] of AnsiString = ('Half-Life', 'Opposing Force', 'Blue Shift');
  GameListCount:Integer=2;
  GameListLength:Integer=0;
begin
  //Initialization
  LabelMaxHP.Caption := IntToStr(TrackBarMaxHP.Position - 1);
  LabelMaxAP.Caption := IntToStr(TrackBarMaxAP.Position - 1);
  LabelHPRate.Caption := floatToStr(TrackBarHPRate.Position / 10) + '%';
  LabelAPRate.Caption := floatToStr(TrackBarAPRate.Position / 10) + '%';
  LocalPlayer.fHPRate := TrackBarHPRate.Position / 1000;
  LocalPlayer.fAPRate := TrackBarAPRate.Position / 1000;

  //ShowMessage('GameList Length: ' + IntToStr(Length(GameList)));
  GameListLength:=Length(GameList)-1;
  //Fenster Handle , ProcessId, OpenProcess-Handle..
  TimerGameStatus.Enabled:=false;
  dwProcessId:=0;
  hProcess := 0;
  while hProcess = 0 do
  begin
    if GameListCount >= GameListLength then
       GameListCount:=0
    else
       Inc(GameListCount);

    hFenster := FindWindow(nil,PChar(GameList[GameListCount]));
    GetWindowThreadProcessId(hFenster, @dwProcessId);
    //dwProcessId:= GetProcId('hl.exe');    //unreliable
    hProcess := OpenProcess(PROCESS_ALL_ACCESS, False, dwProcessId);
    if (hProcess = $0000) and (GameFound = False) and (GameListCount >= GameListLength)then
    begin

      Form1.LabelStatus.Caption:= 'Status: Game not found. Start Half-life or Opposing Force or Blue Shift!';
      Form1.LabelStatus.Font.Color:= $0000DD;
      ShowMessage('Waiting for game...' + LineEnding +
                  'Click "OK" and start Half-Life or Opposing Force or Blue Shift' + LineEnding +
                  'Half-Life Trainer will keep running and waiting for a game');
      //ShowMessage('GameList Length is: ' + IntToStr(GameListLength) + ' GameListCount was: ' + IntToStr(GameListCount));
      GameFound := True;
    end;
    Sleep(100);
  end;
  //ShowMessage('ProcID: ' + IntToStr(dwProcessId) + LineEnding + 'Process Handle: ' + IntToHex(hProcess,8));

  TimerGameStatus.Enabled:=true;


  if GameListCount = 0 then
  begin
    //set current game to either hl or opfor
     CurrentGame:='h';
     ShowMessage('Half-Life found!');
     Form1.LabelStatus.Caption:= 'Status: Game found! Half-Life';
  end
  else if GameListCount = 1 then
  begin
      CurrentGame:='o';
      ShowMessage('Opposing Force found!');
      Form1.LabelStatus.Caption:= 'Status: Game found! Opposing Force';
  end
  else if GameListCount = 2 then
  begin
      CurrentGame:='b';
      ShowMessage('Blue Shift found!');
      Form1.LabelStatus.Caption:= 'Status: Game found! Blue Shift';
  end;

  Form1.LabelStatus.Font.Color:= $00DD00;
  //TimerGameStatus.Enabled:=true;

  //ShowMessage('ProcessID: ' + IntToStr(dwProcessId) + LineEnding +
  //             'CurrentGame: ' + CurrentGame);




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

procedure TForm1.LabelMaxHPClick(Sender: TObject);
begin

end;

procedure TForm1.MenuItemInjectClick(Sender: TObject);
begin
  if not IsDllLoadedInProcess('HLpMod.dll',dwProcessId) then begin
    if FileExists(GetCurrentDir + '\\HLpMod.dll') then begin
      if InjectDll() then begin   //Injects HLpMod.dll specifically
        ShowMessage('Injection successful!');
      end else begin
        ShowMessage('Error: Injection failed');
      end;
    end else begin
      ShowMessage('Error: HLpMod.dll is missing');
    end;
  end else begin
    ShowMessage('Error: HLpMod is already injected');
  end;
end;

procedure TForm1.TimerBhopTimer(Sender: TObject);
begin
  KeyStr:=PChar(IntToBin(ReadByte(dwHWBase+$9CF548),8));

  LocalPlayer.bOnGround:=ReadByte(LocalPlayer.dwOnGround);
  LocalPlayer.fJValue:=ReadFloat(LocalPlayer.dwJValue);

  if (KeyStr[6] = '1')  and (LocalPlayer.fJValue <= 0) and (LocalPlayer.bOnGround=1) then
  begin
    WriteFloat(237.0,LocalPlayer.dwJValue);
  end;
end;

procedure TForm1.TimerGameStatusTimer(Sender: TObject);
var WinTitle:PChar='';
    HWCheck:Pointer=nil;
begin
  if CurrentGame = 'h' then
     WinTitle:='Half-Life'
  else if CurrentGame = 'o'then
     WinTitle:='Opposing Force'
  else if CurrentGame = 'b' then
     WinTitle:='Blue Shift';


  HWCheck:= GetModuleBaseAddress(dwProcessId,'hw.dll');

  //ShowMessage('HWCheck: ' + IntToStr(Integer(HWCheck)));

  if (FindWindow(nil,WinTitle) = 0) or (HWCheck = Pointer(1)) then
  begin
     Form1.LabelStatus.Caption:='Status: Game not running!' + LineEnding + 'Click ''Reinitialize''';
     Form1.LabelStatus.Font.Color := $0000DD;
  end
  else
  begin
    InitAddresses();
  end;
end;


function Clamp(Value:Integer; vMin:Integer; vMax:Integer):Integer;
begin
     if Value >= vMax then
        Result:=vMax
     else if Value <= vMin then
        Result:=vMin
     else
        Result:=Value;
end;

procedure TForm1.TimerEditRegenCheckTimer(Sender: TObject);
begin
  if EditMaxHP.Text <> '' then
     TrackBarMaxHP.Position:= Clamp(StrToInt(EditMaxHP.Text),0,1000)
  else
     TrackBarMaxHP.Position:=1;

  if EditMaxAP.Text <> '' then
     TrackBarMaxAP.Position:= Clamp(StrToInt(EditMaxAP.Text),0,1000)
  else
     TrackBarMaxAP.Position:=1;

  if EditAPRate.Text <> '' then
     TrackBarAPRate.Position:= Clamp(StrToInt(EditAPRate.Text),0,1000)
  else
     TrackBarAPRate.Position:=1;

  if EditHPRate.Text <> '' then
     TrackBarHPRate.Position:= Clamp(StrToInt(EditHPRate.Text),0,1000)
  else
     TrackBarHPRate.Position:=1;
end;


procedure TForm1.CheckBoxInfAmmoChange(Sender: TObject);
begin
  if CheckBoxInfAmmo.Checked then
  begin
    //NOPping dec opcode (or sub for the egon)
    if CurrentGame = 'h' then
    begin
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
    else if CurrentGame = 'o' then
    begin
         //Opfor code goes here (ACTIVATE)
      WriteByte($90, dwOPFORBase + $5A177); //Pistol 9mm
      WriteByte($90, dwOPFORBase + $B2234); //357 Magnum
      WriteByte($90, dwOPFORBase + $2D875); //Eagle
      WriteByte($90, dwOPFORBase + $73548); //SMG
      WriteByte($90, dwOPFORBase + $737D3); //SMG Grenade
      WriteByte($90, dwOPFORBase + $C407B); //Shotgun Primary
      WriteByte($90, dwOPFORBase + $C42FF); //Shotgun Secondary
         WriteByte($90, dwOPFORBase + $C42FF + 1);
         WriteByte($90, dwOPFORBase + $C42FF + 2);
      WriteByte($90, dwOPFORBase + $247A0); //Crossbow
      WriteByte($90, dwOPFORBase + $B9338); //RPG
      WriteByte($90, dwOPFORBase + $40E7A); //Gauss Primary
         WriteByte($90, dwOPFORBase + $40E7A + 1);
         WriteByte($90, dwOPFORBase + $40E7A + 2);
      WriteByte($90, dwOPFORBase + $40FED); //Gauss Secondary A
      WriteByte($90, dwOPFORBase + $4117B); //Gauss Secondary B
      WriteByte($90, dwOPFORBase + $32CDA); //Egon
         WriteByte($90, dwOPFORBase + $32CDA + 1);
      WriteByte($90, dwOPFORBase + $5B95F); //Hornet Primary
      WriteByte($90, dwOPFORBase + $5C2E8); //Hornet Secondary
      WriteByte($90, dwOPFORBase + $4E185); //Grenade
      WriteByte($90, dwOPFORBase + $BA2AA); //Satchel
      WriteByte($90, dwOPFORBase + $DB1FC); //Mine
      WriteByte($90, dwOPFORBase + $CD3A2); //Snark
      WriteByte($90, dwOPFORBase + $65356); //M249
      WriteByte($90, dwOPFORBase + $299C9); //Displacer
         WriteByte($90, dwOPFORBase + $299C9 + 1);
         WriteByte($90, dwOPFORBase + $299C9 + 2);
      WriteByte($90, dwOPFORBase + $C525C); //Sniper
      WriteByte($90, dwOPFORBase + $C8F77); //Spore Launcher Primary
      WriteByte($90, dwOPFORBase + $C9208); //Spore Launcher Secondary
      WriteByte($90, dwOPFORBase + $C02E1); //Shock Roach
    end
    else if CurrentGame = 'b' then
    begin
       //Blue Shit code goes here (ACTIVATE)
      WriteByte($90, dwHLBase+$3A425);//Pistol 9mm
      WriteByte($90, dwHLBase+$6D6C3);//357 Magnum
      WriteByte($90, dwHLBase+$4BB80);//SMG
      WriteByte($90, dwHLBase+$4BDD2);//SMG Grenade
      WriteByte($90, dwHLBase+$775A6);//Shotgun Primary
      WriteByte($90, dwHLBase+$777E9);//Shotgun Secondary
         WriteByte($90, dwHLBase+$777E9 + 1);
         WriteByte($90, dwHLBase+$777E9 + 2);
      WriteByte($90, dwHLBase+$1DB8A);//Crossbow
      WriteByte($90, dwHLBase+$70A8A);//RPG
      WriteByte($90, dwHLBase+$2FB80);//Gauss Primary
         WriteByte($90, dwHLBase+$2FB80 + 1);
         WriteByte($90, dwHLBase+$2FB80 + 2);
      WriteByte($90, dwHLBase+$2FCB4);//Gauss Secondary A
      WriteByte($90, dwHLBase+$2FE03);//Gauss Secondary B
      WriteByte($90, dwHLBase+$2597A);//Egon
         WriteByte($90, dwHLBase+$2597A+1);
      WriteByte($90, dwHLBase+$3BB43);//Hornet Primary
      WriteByte($90, dwHLBase+$3C44C);//Hornet Secondary
      WriteByte($90, dwHLBase+$350D6);//Grenade
      WriteByte($90, dwHLBase+$718E8);//Satchel
         WriteByte($90, dwHLBase+$718E8+1);
      WriteByte($90, dwHLBase+$87871);//Mine
      WriteByte($90, dwHLBase+$7D31E);//Snark
    end;





  end
  else
  begin
    if CurrentGame = 'h' then
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
    end
    else if CurrentGame = 'o' then
    begin
         //Opfor code goes here (DEACTIVATE)
         WriteByte($48, dwOPFORBase + $5A177); //Pistol 9mm
      WriteByte($48, dwOPFORBase + $B2234); //357 Magnum
      WriteByte($4F, dwOPFORBase + $2D875); //Eagle
      WriteByte($4A, dwOPFORBase + $73548); //SMG
      WriteByte($49, dwOPFORBase + $737D3); //SMG Grenade
      WriteByte($48, dwOPFORBase + $C407B); //Shotgun Primary
      WriteByte($83, dwOPFORBase + $C42FF); //Shotgun Secondary
         WriteByte($C0, dwOPFORBase + $C42FF + 1);
         WriteByte($FE, dwOPFORBase + $C42FF + 2);
      WriteByte($48, dwOPFORBase + $247A0); //Crossbow
      WriteByte($48, dwOPFORBase + $B9338); //RPG
      WriteByte($83, dwOPFORBase + $40E7A); //Gauss Primary
         WriteByte($C1, dwOPFORBase + $40E7A + 1);
         WriteByte($FE, dwOPFORBase + $40E7A + 2);
      WriteByte($49, dwOPFORBase + $40FED); //Gauss Secondary A
      WriteByte($49, dwOPFORBase + $4117B); //Gauss Secondary B
      WriteByte($2B, dwOPFORBase + $32CDA); //Egon
         WriteByte($C2, dwOPFORBase + $32CDA + 1);
      WriteByte($49, dwOPFORBase + $5B95F); //Hornet Primary
      WriteByte($49, dwOPFORBase + $5C2E8); //Hornet Secondary
      WriteByte($4A, dwOPFORBase + $4E185); //Grenade
      WriteByte($49, dwOPFORBase + $BA2AA); //Satchel
      WriteByte($49, dwOPFORBase + $DB1FC); //Mine
      WriteByte($49, dwOPFORBase + $CD3A2); //Snark
      WriteByte($4A, dwOPFORBase + $65356); //M249
      WriteByte($83, dwOPFORBase + $299C9); //Displacer
         WriteByte($C1, dwOPFORBase + $299C9 + 1);
         WriteByte($EC, dwOPFORBase + $299C9 + 2);
      WriteByte($4B, dwOPFORBase + $C525C); //Sniper
      WriteByte($48, dwOPFORBase + $C8F77); //Spore Launcher Primary
      WriteByte($48, dwOPFORBase + $C9208); //Spore Launcher Secondary
      WriteByte($49, dwOPFORBase + $C02E1); //Shock Roach

    end
    else if CurrentGame = 'b' then
    begin
      //to do (deactivate)
      WriteByte($48, dwHLBase+$3A425);//Pistol 9mm
      WriteByte($4A, dwHLBase+$6D6C3);//357 Magnum
      WriteByte($4A, dwHLBase+$4BB80);//SMG
      WriteByte($4F, dwHLBase+$4BDD2);//SMG Grenade
      WriteByte($4A, dwHLBase+$775A6);//Shotgun Primary
      WriteByte($83, dwHLBase+$777E9);//Shotgun Secondary
         WriteByte($C2, dwHLBase+$777E9 + 1);
         WriteByte($FE, dwHLBase+$777E9 + 2);
      WriteByte($48, dwHLBase+$1DB8A);//Crossbow
      WriteByte($48, dwHLBase+$70A8A);//RPG
      WriteByte($83, dwHLBase+$2FB80);//Gauss Primary
         WriteByte($C1, dwHLBase+$2FB80 + 1);
         WriteByte($FE, dwHLBase+$2FB80 + 2);
      WriteByte($49, dwHLBase+$2FCB4);//Gauss Secondary A
      WriteByte($49, dwHLBase+$2FE03);//Gauss Secondary B
      WriteByte($2B, dwHLBase+$2597A);//Egon
         WriteByte($C2, dwHLBase+$2597A+1);
      WriteByte($4A, dwHLBase+$3BB43);//Hornet Primary
      WriteByte($49, dwHLBase+$3C44C);//Hornet Secondary
      WriteByte($4F, dwHLBase+$350D6);//Grenade
      WriteByte($FF, dwHLBase+$718E8);//Satchel
         WriteByte($08, dwHLBase+$718E8+1);
      WriteByte($49, dwHLBase+$87871);//Mine
      WriteByte($49, dwHLBase+$7D31E);//Snark
    end;
  end;
end;


{      ///////// Notes for Half-Life //////////
       hl.dll+632E8 - 74 08                 - je hl.dll+632F2 //rapid fire Primary
       hl.dll+63344 - 74 08                 - je hl.dll+6334E //rapid fire Secondary

       hl.dll+3C59C - 49                    - dec ecx //Hornet gun rechtsklick (AMMO ONLY)
       hl.dll+4BCE3 - D8 05 A035A20A        - fadd dword ptr [hl.dll+A35A0]//smgnade X
       client.dll+1BF66 - 89 97 90000000        - mov [edi+00000090],edx//smgnade (probably wrong, unused)


}



{
       //////// Notes for OpFor ///////////

       Copied from HL (to find the ones in OpFor)
               ------- infinite firerate ------
               hl.dll+632F4 - 85 C0                 - test eax,eax
               hl.dll+632F6 - 0F84 C9000000         - je hl.dll+633C5
               hl.dll+632FC - 8B 0D 8CE04C27        - mov ecx,[hl.dll+DE08C] { (043B7620) }
               hl.dll+63302 - D9 86 8C000000        - fld dword ptr [esi+0000008C]
               hl.dll+63308 - D8 61 04              - fsub dword ptr [ecx+04]
               hl.dll+6330B - DC 15 B8034A27        - fcom qword ptr [hl.dll+B03B8] { (-1.00) }
               hl.dll+63311 - DFE0                  - fnstsw ax
               hl.dll+63313 - 25 00410000           - and eax,00004100 { 16640 }
               hl.dll+63318 - 74 08                 - je hl.dll+63322 { RAPIDFIRE NOP THIS ONE} <----------------------
               hl.dll+6331A - DDD8                  - fstp st(0)
               hl.dll+6331C - DD 05 B8034A27        - fld qword ptr [hl.dll+B03B8] { (-1.00) }
               hl.dll+63322 - D9 9E 8C000000        - fstp dword ptr [esi+0000008C]
               hl.dll+63328 - 8B 15 8CE04C27        - mov edx,[hl.dll+DE08C] { (043B7620) }
               hl.dll+6332E - D9 86 90000000        - fld dword ptr [esi+00000090]
               hl.dll+63334 - D8 62 04              - fsub dword ptr [edx+04]
               hl.dll+63337 - DC 15 885E4927        - fcom qword ptr [hl.dll+A5E88] { (0.00) }
               hl.dll+6333D - DFE0                  - fnstsw ax
               hl.dll+6333F - 25 00410000           - and eax,00004100 { 16640 }

               ------- infinite smg nade firerate -------
               hl.dll+4BCC1 - 6A 01                 - push 01 { 1 }
               hl.dll+4BCC3 - FF 15 FCDF4C27        - call dword ptr [hl.dll+DDFFC] { ->hw.dll+6EB50 }
               hl.dll+4BCC9 - 83 C4 4C              - add esp,4C { 76 }
               hl.dll+4BCCC - 8B CE                 - mov ecx,esi
               hl.dll+4BCCE - 68 0000803F           - push 3F800000 { 1.00 }
               hl.dll+4BCD3 - E8 A8250400           - call hl.dll+8E280
               hl.dll+4BCD8 - D9 9E 8C000000        - fstp dword ptr [esi+0000008C]
               hl.dll+4BCDE - E8 5DCF0300           - call hl.dll+88C40
               hl.dll+4BCE3 - D8 05 A0354927        - fadd dword ptr [hl.dll+A35A0] { RAPID SMG NADES - COPY CODE TO RESTORE LATER, NOP ALL}
               hl.dll+4BCE9 - D9 9E 90000000        - fstp dword ptr [esi+00000090]
               hl.dll+4BCEF - E8 4CCF0300           - call hl.dll+88C40
               hl.dll+4BCF4 - D8 05 64354927        - fadd dword ptr [hl.dll+A3564] { (5.00) }
               hl.dll+4BCFA - 8B 4E 70              - mov ecx,[esi+70]
               hl.dll+4BCFD - 8B 96 9C000000        - mov edx,[esi+0000009C]
               hl.dll+4BD03 - D9 9E 94000000        - fstp dword ptr [esi+00000094]
               hl.dll+4BD09 - 8B 84 91 D8040000     - mov eax,[ecx+edx*4+000004D8]
               hl.dll+4BD10 - 85 C0                 - test eax,eax


       Actual Opcodes from Opposing Force
               ------- infinite firerate -------
               opfor.dll+A67F6 - 74 08                 - je opfor.dll+A6800

               ------- infinite secondary firerate ------
               opfor.dll+A6822 - 74 08                 - je opfor.dll+A682C
       Blue Shift Firerate
               hl.dll+63488 - 74 08                 - je hl.dll+63492 //Primary
               hl.dll+634B4 - 74 08                 - je hl.dll+634BE //Secondary





}
procedure TForm1.CheckBoxProperRapidfireChange(Sender: TObject);
begin
  if (CheckBoxProperRapidfire.Checked) then
  begin
    if CurrentGame = 'h' then
    begin
      //Rapid fire all guns
      WriteByte($90, dwHLBase + $63318);   //Primary Fire
      WriteByte($90, dwHLBase + $63319);

      WriteByte($90, dwHLBase + $63344);   //Secondary Fire
      WriteByte($90, dwHLBase + $63345);
    end                                                    //LocalPlayer
    else if CurrentGame = 'o' then
    begin
      //Opfor code goes here
      WriteByte($90, dwOPFORBase + $A67F6);//Primary Fire
      WriteByte($90, dwOPFORBase + $A67F6 + 1);

      WriteByte($90, dwOPFORBase + $A6822);//Secondary Fire
      WriteByte($90, dwOPFORBase + $A6822 + 1);
    end
    else if CurrentGame = 'b' then
    begin
      //Blue Shift
      WriteByte($90, dwHLBase + $63488);   //Primary Fire
      WriteByte($90, dwHLBase + $63489);

      WriteByte($90, dwHLBase + $634B4);   //Secondary Fire
      WriteByte($90, dwHLBase + $634B5);
    end;
  end
  else
  begin
    if CurrentGame = 'h' then
    begin
      WriteByte($74, dwHLBase + $63318);   //Primary Fire
      WriteByte($08, dwHLBase + $63319);

      WriteByte($74, dwHLBase + $63344);   //Secondary Fire
      WriteByte($08, dwHLBase + $63345);

    end
    else if CurrentGame = 'o' then
    begin
        //Opfor code goes here
        WriteByte($74, dwOPFORBase + $A67F6);//Primary Fire
        WriteByte($08, dwOPFORBase + $A67F6 + 1);

        WriteByte($74, dwOPFORBase + $A6822);//Secondary Fire
        WriteByte($08, dwOPFORBase + $A6822 + 1);
    end
    else if CurrentGame = 'b' then
    begin
        //Blue Shift
        WriteByte($74, dwHLBase + $63488);   //Primary Fire
        WriteByte($08, dwHLBase + $63489);

        WriteByte($74, dwHLBase + $634B4);   //Secondary Fire
        WriteByte($08, dwHLBase + $634B5);
    end;
  end;

end;

procedure TForm1.EditMaxHPChange(Sender: TObject);
begin

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
  ShowMessage(  'Half-Life Trainer v1.3.5' + sLineBreak +
                'by pombenenge (on YouTube)' + sLineBreak +
                'Last Updated: 2023-08-16'
                + sLineBreak + sLineBreak +

                'Features: Health and Armor regeneration, Rapidfire, Infinite Ammo, AutoBhop'
                + sLineBreak + sLineBreak +

                'WARNING: The trainer may cause crashes. Save often.'
                + sLineBreak + sLineBreak +

                '-- How to use --' + sLineBreak +
                '1. Start Half-life, Opposing Force or Blue Shift (Tested on Steam version, other versions probably don''t work)' + sLineBreak +
                '2. Start the trainer (If the trainer is already running, click on "Reinitialize")' + sLineBreak +
                '3. Adjust trainer settings to your liking.'
                + sLineBreak + sLineBreak +

                '-- FAQ --' + sLineBreak +
                'Q: Does it work in multiplayer?' + sLineBreak +
                'A: No. If you try you will get VAC banned. Seriously, do NOT do it.'
                + sLineBreak + sLineBreak +

                'Q: Nothing happens? Why?' + sLineBreak +
                'A: There can be multiple reasons why it does not work.' + sLineBreak +
                '   1. You probably need the Steam version of Half-Life. (Cracked or WON version do not work)' + sLineBreak +
                '   2. Run the trainer as administrator.' + sLineBreak +
                '   3. Check the instructions above and make sure you are doing it right.' + sLineBreak +
                '   4. The trainer may be outdated. (If you have confirmed that everything else is not the cause' + sLineBreak +
                '       contact me on YouTube)'
                + sLineBreak + sLineBreak +

                'Q: Why do I explode when I spam SMG grenades' + sLineBreak +
                'A: When you are in the main menu type "fps_max 100" into the console. In-Game try walking backwards or' + sLineBreak +
                '     moving your mouse left or right while shooting grenades.' + sLineBreak +
                '     The grenades must not collide in mid air!'
                + sLineBreak + sLineBreak +

                'Q: What is HLpMod.dll?' + sLineBreak +
                'A: HLpMod is an OpenGL overlay I made which provides some extra information. It is inteded mainly for bunnyhopping' + sLineBreak +
                '     and includes it''s own frame perfect AutoBhop, which is always on,' + sLineBreak +
                '     and a speedometer (and max speed since last quickload) The source code is also on my GitHub'
                + sLineBreak + sLineBreak +

                'Q: My pirated version of the game won''t work with this trainer!' + sLineBreak +
                'A: Buy the damn game! It''s like 10 bucks jfc..' + sLineBreak +
                '     If you''re too poor, here is your answer: Cracked versions are not supported.'
                + sLineBreak + sLineBreak +

                'Click on the icons for GitHub and YouTube links'
                + sLineBreak + sLineBreak +

                'Have fun!'
                );
end;

procedure TForm1.ButtonEnableAllClick(Sender: TObject);
begin

  TrackBarMaxHP.Position:=1000;
  TrackBarMaxAP.Position:=1000;
  TrackBarHPRate.Position:=1000;
  TrackBarAPRate.Position:=1000;
  CheckBoxEnableHPRegen.Checked:=True;
  CheckBoxEnableAPRegen.Checked:=True;
  CheckBoxProperRapidfire.Checked:=True;
  CheckBoxAutoBhop.Checked:=True;
  CheckBoxInfAmmo.Checked:=True;

  //CheckBoxInfAmmoChange(nil);
  //CheckBoxAutoBhopChange(nil);
  //CheckBoxProperRapidfireChange(nil);

end;


procedure TForm1.TimerRegenTimer(Sender: TObject);
begin
  //Read HP & AP
  LocalPlayer.fHP := ReadFloat(LocalPlayer.dwAddHP);
  LocalPlayer.fAP := ReadFloat(LocalPlayer.dwAddAP);

  // Regenerate HP
  {ShowMessage('fHP: ' + FloatToStr(LocalPlayer.fHP) + LineEnding +
              'fHPRate: ' + FloatToStr(LocalPlayer.fHPRate) + LineEnding +
              'TrackBarMaxHP.Position: ' + FloatToStr(TrackBarMaxHP.Position)
              );
   }
  if CheckBoxEnableHPRegen.Checked and (LocalPlayer.fHP <> StrToInt(EditMaxHP.Text)) then
    if ((LocalPlayer.fHP + (LocalPlayer.fHPRate)) <= Single(TrackBarMaxHP.Position+1)) then
    begin
      LocalPlayer.fHP := LocalPlayer.fHP + LocalPlayer.fHPRate;
      WriteFloat(LocalPlayer.fHP, LocalPlayer.dwAddHP);
    end
    else if ((LocalPlayer.fHP - (LocalPlayer.fHPRate)) >= Single(TrackBarMaxHP.Position)) then
    begin
      LocalPlayer.fHP := LocalPlayer.fHP - LocalPlayer.fHPRate;
      WriteFloat(LocalPlayer.fHP, LocalPlayer.dwAddHP);
    end;


  //Regenerate AP
  if CheckBoxEnableAPRegen.Checked and (LocalPlayer.fAP <> StrToInt(EditMaxAP.Text)) then
    if ((LocalPlayer.fAP + (LocalPlayer.fAPRate)) <= Single(TrackBarMaxAP.Position+1)) then
    begin
      LocalPlayer.fAP := LocalPlayer.fAP + LocalPlayer.fAPRate;
      WriteFloat(LocalPlayer.fAP, LocalPlayer.dwAddAP);
    end
    else if ((LocalPlayer.fAP - (LocalPlayer.fAPRate)) >= Single(TrackBarMaxAP.Position)) then
    begin
      LocalPlayer.fAP := LocalPlayer.fAP - LocalPlayer.fAPRate;
      WriteFloat(LocalPlayer.fAP, LocalPlayer.dwAddAP);
    end;
end;

procedure TForm1.TrackBarAPRateChange(Sender: TObject);
begin
  LabelAPRate.Caption := floatToStr((TrackBarAPRate.Position) / 10) + '%';
  LocalPlayer.fAPRate := TrackBarAPRate.Position / 1000;
  if EditAPRate.Text<>'' then
     EditAPRate.Text:=IntToStr(TrackBarAPRate.Position);
end;

procedure TForm1.TrackBarHPRateChange(Sender: TObject);
begin
  LabelHPRate.Caption := floatToStr((TrackBarHPRate.Position) / 10) + '%';
  LocalPlayer.fHPRate := TrackBarHPRate.Position / 1000;
  if EditHPRate.Text<>'' then
     EditHPRate.Text:=IntToStr(TrackBarHPRate.Position);
end;

procedure TForm1.TrackBarMaxAPChange(Sender: TObject);
begin
  LocalPlayer.fMaxAP := TrackBarMaxAP.Position;
  LabelMaxAP.Caption := IntToStr(TrackBarMaxAP.Position);
  if EditMaxAP.Text<>'' then
     EditMaxAP.Text:=IntToStr(TrackBarMaxAP.Position);
end;

procedure TForm1.TrackBarMaxHPChange(Sender: TObject);
begin
  LocalPlayer.fMaxHP := TrackBarMaxHP.Position;
  LabelMaxHP.Caption := IntToStr(TrackBarMaxHP.Position);
  if EditMaxHP.Text<>'' then
     EditMaxHP.Text:=IntToStr(TrackBarMaxHP.Position);
end;

function TForm1.IsDllLoadedInProcess(const DllName: string; ProcessID: DWORD): Boolean;
var
  hSnapshot: THandle;
  me32: TModuleEntry32;
begin
  Result := False;

  hSnapshot := CreateToolhelp32Snapshot(TH32CS_SNAPMODULE, ProcessID);
  if hSnapshot = INVALID_HANDLE_VALUE then
    Exit;

  me32.dwSize := SizeOf(TModuleEntry32);
  if Module32First(hSnapshot, me32) then
  begin
    repeat
      if CompareText(DllName, me32.szModule) = 0 then
      begin
        Result := True;
        Break;
      end;
    until not Module32Next(hSnapshot, me32);
  end;

  CloseHandle(hSnapshot);
end;

function TForm1.InjectDll(): Boolean;
var
  remoteThread: THandle;
  hModule: Pointer;
  dllPath: string;
  bytesWritten: SIZE_T = SIZE_T(0);
begin
  Result := False;

  // Open the target process with appropriate access rights
  //hProcess := OpenProcess(PROCESS_ALL_ACCESS, False, ProcessID);
  if hProcess = 0 then
  begin
    ShowMessage('Failed to open the target process: ' + SysErrorMessage(GetLastError));
    Exit;
  end;

  try
    // Get the path to the DLL
    dllPath := GetCurrentDir + '\HLpMod.dll';

    // Allocate memory in the target process for the DLL path
    hModule := VirtualAllocEx(hProcess, nil, Length(dllPath) + 1, MEM_COMMIT, PAGE_READWRITE);
    if hModule = nil then
    begin
      ShowMessage('VirtualAllocEx failed: ' + SysErrorMessage(GetLastError));
      Exit;
    end;

    try
      // Write the DLL path to the target process
      if not WriteProcessMemory(hProcess, hModule, PChar(dllPath), Length(dllPath) + 1, bytesWritten) then
      begin
        ShowMessage('WriteProcessMemory failed: ' + SysErrorMessage(GetLastError));
        Exit;
      end;

      // Create a remote thread to load the DLL into the target process
      remoteThread := CreateRemoteThread(hProcess, nil, 0, GetProcAddress(GetModuleHandle('kernel32.dll'), 'LoadLibraryA'), hModule, 0, bytesWritten);
      if remoteThread = 0 then
      begin
        ShowMessage('CreateRemoteThread failed: ' + SysErrorMessage(GetLastError));
        Exit;
      end;

      WaitForSingleObject(remoteThread, INFINITE);

      Result := True;

    finally
      VirtualFreeEx(hProcess, hModule, 0, MEM_RELEASE);
    end;

  finally
    //CloseHandle(hProcess);
  end;
end;


end.
