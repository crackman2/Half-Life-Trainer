unit Main;

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
  StdCtrls, ExtCtrls, Windows, LCLIntf, Menus, strutils,

  { custom }
  CProcMem;

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
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    LabelStatus: TLabel;
    LabelAPRate: TLabel;
    LabelMaxHP: TLabel;
    LabelMaxAP: TLabel;
    Label5: TLabel;
    LabelHPRate: TLabel;
    ListBoxLog: TListBox;
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

    procedure CheckBoxInfAmmoChange(Sender: TObject);
    procedure CheckBoxProperRapidfireChange(Sender: TObject);

    procedure FormCreate(Sender: TObject);
    procedure Image1Click(Sender: TObject);
    procedure Image2Click(Sender: TObject);
    procedure TimerBhopTimer(Sender: TObject);
    procedure TimerGameStatusTimer(Sender: TObject);
    procedure TimerEditRegenCheckTimer(Sender: TObject);
    procedure TimerRegenTimer(Sender: TObject);
    procedure TrackBarAPRateChange(Sender: TObject);
    procedure TrackBarHPRateChange(Sender: TObject);
    procedure TrackBarMaxAPChange(Sender: TObject);
    procedure TrackBarMaxHPChange(Sender: TObject);

    procedure MenuItemInjectClick(Sender: TObject);

    procedure Log(LogText: string);

  private
    { private declarations }
  public
    { public declarations }
  end;

  TLocalPlayer = record
    dwAddHP: DWORD;
    dwAddAP: DWORD;
    dwJValue: DWORD;
    dwOnGround: DWORD;
    dwAddMidair: DWORD;
    dwAddRapidfire: DWORD;
    bOnGround: byte;
    fHP: single;
    fAP: single;
    fMaxHP: single;
    fMaxAP: single;
    fJValue: single;
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
  bSMGNadeOriginalCode: array[0..5] of byte;
  i: integer; //for loop indexer
  KeyWord: PWord;
  KeyStr: PChar;
  CurrentGame: ansistring;
  //Identifies game, 'h' for Half-Life, 'o' for opposing force, 'b' for blueshift
  IsInGame: boolean = False;
  g_ProcMem:TProcMem;




implementation

{$R *.lfm}


function GetRapidFireAddress(ModBase: DWORD): DWORD;
var
  temp: DWORD = 0;
begin
  temp := 0;
  temp := g_ProcMem.ReadDword(ModBase + $A20A4C) + $EC;
  temp := g_ProcMem.ReadDword(temp) + $78;
  temp := g_ProcMem.ReadDword(temp) + $6A8;
  temp := g_ProcMem.ReadDword(temp) + $4C8;
  Result := g_ProcMem.ReadDword(temp) + $8C;
end;




procedure InitAddresses();
begin
  /// PATCH: "hw.dll"+007F6304  {   1E0 }
  dwHWBase := DWORD(g_ProcMem.GetModuleBaseAddress(dwProcessId, 'hw.dll'));
  dwCLIENTBase := DWORD(g_ProcMem.GetModuleBaseAddress(dwProcessId, 'client.dll'));
  dwSDLBase := DWORD(g_ProcMem.GetModuleBaseAddress(dwProcessId, 'SDL2.dll'));


  if (CurrentGame = 'h') or (CurrentGame = 'b') then
  begin
    dwHLBase := DWORD(g_ProcMem.GetModuleBaseAddress(dwProcessId, 'hl.dll'));
  end
  else if CurrentGame = 'o' then
  begin
    dwOPFORBase := DWORD(g_ProcMem.GetModuleBaseAddress(dwProcessId, 'opfor.dll'));
  end;

  ReadProcessMemory(g_ProcMem.hProcess, Pointer(dwHWBase + $7F6304), @LocalPlayer.dwAddHP,
    sizeof(LocalPlayer.dwAddHP), nil);
  LocalPlayer.dwJValue := LocalPlayer.dwAddHP + $A8;
  LocalPlayer.dwAddHP := LocalPlayer.dwAddHP + $1E0; //X
  LocalPlayer.dwAddAP := LocalPlayer.dwAddHP + $5C;  //X
  LocalPlayer.dwOnGround := dwHWBase + $122E2D4;
end;

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);// ENTRYYYYYYYYY
var
  GameFound: boolean = False;
  GameList: array[0..2] of ansistring = ('Half-Life', 'Opposing Force', 'Blue Shift');
  GameListCount: integer = 2;
  GameListLength: integer = 0;
  hProcessNonZero:Boolean=False;

begin
  //Initialization
  LabelMaxHP.Caption := IntToStr(TrackBarMaxHP.Position - 1);
  LabelMaxAP.Caption := IntToStr(TrackBarMaxAP.Position - 1);
  LabelHPRate.Caption := floatToStr(TrackBarHPRate.Position / 10) + '%';
  LabelAPRate.Caption := floatToStr(TrackBarAPRate.Position / 10) + '%';
  LocalPlayer.fHPRate := TrackBarHPRate.Position / 1000;
  LocalPlayer.fAPRate := TrackBarAPRate.Position / 1000;

  //ShowMessage('GameList Length: ' + IntToStr(Length(GameList)));
  GameListLength := Length(GameList) - 1;
  //Fenster Handle , ProcessId, OpenProcess-Handle..
  TimerGameStatus.Enabled := False;



  while not hProcessNonZero do
  begin
    if GameListCount >= GameListLength then
      GameListCount := 0
    else
      Inc(GameListCount);

    //ShowMessage('Win:'  + GameList[GameListCount]);
    hFenster := 0;
    dwProcessId:=0;
    hFenster := FindWindow(nil, PChar(GameList[GameListCount]));
    GetWindowThreadProcessId(hFenster, @dwProcessId);


    if dwProcessId <> 0 then begin
       if Assigned(g_ProcMem) then g_ProcMem.Free;
       g_ProcMem:=TProcMem.Create(dwProcessId);
       if g_ProcMem.hProcess <> 0 then hProcessNonZero:=True;
    end;
    //ShowMessage('g_ProcMem.hProcess is: '  + IntToHex(g_ProcMem.hProcess,8));

    if not Assigned(g_ProcMem) and (GameFound = False) and
      (GameListCount >= GameListLength) then
    begin

      Form1.LabelStatus.Caption :=
        'Status: Game not found. Start Half-life or Opposing Force or Blue Shift!';
      Form1.LabelStatus.Font.Color := $0000DD;
      ShowMessage('Waiting for game...' + LineEnding +
        'Click "OK" and start Half-Life or Opposing Force or Blue Shift' +
        LineEnding +
        'Half-Life Trainer will keep running and waiting for a game');
      //ShowMessage('GameList Length is: ' + IntToStr(GameListLength) + ' GameListCount was: ' + IntToStr(GameListCount));
      GameFound := True;
    end;

    Sleep(100);
  end;
  //ShowMessage('ProcID: ' + IntToStr(dwProcessId) + LineEnding + 'Process Handle: ' + IntToHex(hProcess,8));

  TimerGameStatus.Enabled := True;


  if GameListCount = 0 then
  begin
    //set current game to either hl or opfor
    CurrentGame := 'h';
    //ShowMessage('Half-Life found!');
    Log('Half-Life found!');
    Form1.LabelStatus.Caption := 'Status: Game found! Half-Life';
  end
  else if GameListCount = 1 then
  begin
    CurrentGame := 'o';
    //ShowMessage('Opposing Force found!');
    Log('Opposing Force found!');
    Form1.LabelStatus.Caption := 'Status: Game found! Opposing Force';
  end
  else if GameListCount = 2 then
  begin
    CurrentGame := 'b';
    ShowMessage('Blue Shift found!');
    Log('Blue Shift found!');
    Form1.LabelStatus.Caption := 'Status: Game found! Blue Shift';
  end;

  Form1.LabelStatus.Font.Color := $00DD00;

  //===HP and AP Addresses===
  InitAddresses();

  if ReIniter then
  begin
    //ShowMessage('Done.');
    Log('Reinitialize done.');
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


{ --------------------------- MenuItemInjectClick -------------------------- }
{ -> injects HLpMod if it wasn't already                                     }
{ -> unchecks and disables the AutoBhop checkbox because HLpMod uses its own }
procedure TForm1.MenuItemInjectClick(Sender: TObject);
begin
  if not g_ProcMem.IsDllLoadedInProcess('HLpMod.dll') then
  begin
    if FileExists(GetCurrentDir + '\\HLpMod.dll') then
    begin
      if g_ProcMem.InjectDll(GetCurrentDir + '\\HLpMod.dll') then
      begin   //Injects HLpMod.dll specifically
        //ShowMessage('Injection successful!');
        Log('Injection successful!');
        TimerBhop.Enabled := False;
        CheckBoxAutoBhop.Checked := False;
        CheckBoxAutoBhop.Enabled := False;
      end
      else
      begin
        ShowMessage('Error: Injection failed');
      end;
    end
    else
    begin
      ShowMessage('Error: HLpMod.dll is missing');
    end;
  end
  else
  begin
    ShowMessage('Error: HLpMod is already injected');
  end;
end;



{ ----------------------------- TimerBhopTimer ----------------------------- }
{ -> main timer for AutoBhop execution                                       }
{ -> Checks key inputs (using the KeyStr from in-game values) and pushes the }
{    player in the air when appropriate                                      }
procedure TForm1.TimerBhopTimer(Sender: TObject);
begin
  if Assigned(g_ProcMem) then begin
    KeyStr := PChar(IntToBin(g_ProcMem.ReadByte(dwHWBase + $9CF548), 8));

    LocalPlayer.bOnGround := g_ProcMem.ReadByte(LocalPlayer.dwOnGround);
    LocalPlayer.fJValue := g_ProcMem.ReadFloat(LocalPlayer.dwJValue);

    if (KeyStr[6] = '1') and (LocalPlayer.fJValue <= 0) and (LocalPlayer.bOnGround = 1) then
    begin
      g_ProcMem.WriteFloat(237.0, LocalPlayer.dwJValue);
    end;
  end;
end;



{ -------------------------- TimerGameStatusTimer -------------------------- }
{ -> checks if the game is still running and changes the label if it is not  }
procedure TForm1.TimerGameStatusTimer(Sender: TObject);
var
  WinTitle: PChar = '';
  HWCheck: Pointer = nil;
begin
  if CurrentGame = 'h' then
    WinTitle := 'Half-Life'
  else if CurrentGame = 'o' then
    WinTitle := 'Opposing Force'
  else if CurrentGame = 'b' then
    WinTitle := 'Blue Shift';


  HWCheck := g_ProcMem.GetModuleBaseAddress(dwProcessId, 'hw.dll');

  if (FindWindow(nil, WinTitle) = 0) or (HWCheck = Pointer(1)) then
  begin
    Form1.LabelStatus.Caption := 'Status: Game not running!' +
      LineEnding + 'Click ''Reinitialize''';
    Form1.LabelStatus.Font.Color := $0000DD;
  end
  else
  begin
    InitAddresses();
  end;
end;


function Clamp(Value: integer; vMin: integer; vMax: integer): integer;
begin
  if Value >= vMax then
    Result := vMax
  else if Value <= vMin then
    Result := vMin
  else
    Result := Value;
end;



{ ------------------------ TimerEditRegenCheckTimer ------------------------ }
{ -> sets trackbar positions when the edit field is changed                  }
procedure TForm1.TimerEditRegenCheckTimer(Sender: TObject);
begin
  if EditMaxHP.Text <> '' then
    TrackBarMaxHP.Position := Clamp(StrToInt(EditMaxHP.Text), 0, 1000)
  else
    TrackBarMaxHP.Position := 1;

  if EditMaxAP.Text <> '' then
    TrackBarMaxAP.Position := Clamp(StrToInt(EditMaxAP.Text), 0, 1000)
  else
    TrackBarMaxAP.Position := 1;

  if EditAPRate.Text <> '' then
    TrackBarAPRate.Position := Clamp(StrToInt(EditAPRate.Text), 0, 1000)
  else
    TrackBarAPRate.Position := 1;

  if EditHPRate.Text <> '' then
    TrackBarHPRate.Position := Clamp(StrToInt(EditHPRate.Text), 0, 1000)
  else
    TrackBarHPRate.Position := 1;
end;



{ -------------------------- CheckBoxInfAmmoChange ------------------------- }
{ -> there is nothing but pain to be found here, turn back                   }
procedure TForm1.CheckBoxInfAmmoChange(Sender: TObject);
begin
  if CheckBoxInfAmmo.Checked then
  begin
    //NOPping dec opcode (or sub for the egon)
    if CurrentGame = 'h' then
    begin
      g_ProcMem.WriteByte($90, dwHLBase + $6D5F3); //357 X  FIXED
      g_ProcMem.WriteByte($90, dwHLBase + $3A616); //Pistol X
      g_ProcMem.WriteByte($90, dwHLBase + $4B990); //SMG X
      g_ProcMem.WriteByte($90, dwHLBase + $76297); //Shotgun X FIXED 764DA
      g_ProcMem.WriteByte($90, dwHLBase + $764DA); //Shotgun Doppelschuss  FIXED
      g_ProcMem.WriteByte($90, dwHLBase + $764DA + 1); //Shotgun Doppelschuss
      g_ProcMem.WriteByte($90, dwHLBase + $764DA + 2); //Shotgun Doppelschuss
      g_ProcMem.WriteByte($90, dwHLBase + $1DF4A); //Crossbow X
      g_ProcMem.WriteByte($90, dwHLBase + $6F77A); //Rockets X
      g_ProcMem.WriteByte($90, dwHLBase + $25DDA); //Egon 1 X
      g_ProcMem.WriteByte($90, dwHLBase + $25DDB); //Egon 2 X
      // hl.dll+3C59C - 49                    - dec ecx //Hornet gun rechtsklick
      g_ProcMem.WriteByte($90, dwHLBase + $3BD33); //Hornet 2 X
      g_ProcMem.WriteByte($90, dwHLBase + $3C63C); //Hornet rechtsklick
      g_ProcMem.WriteByte($90, dwHLBase + $352C7); //Nades   X
      g_ProcMem.WriteByte($90, dwHLBase + $705DF); //Satchel X
      g_ProcMem.WriteByte($90, dwHLBase + $863A1); //Mines X
      g_ProcMem.WriteByte($90, dwHLBase + $7C022); //Snarks X
      g_ProcMem.WriteByte($90, dwHLBase + $4BBE2); //SMG Launcher
      g_ProcMem.WriteByte($90, dwHLBase + $2FFE1); //Gauss
      g_ProcMem.WriteByte($90, dwHLBase + $2FFE2); //Gauss
      g_ProcMem.WriteByte($90, dwHLBase + $2FFE3); //Gauss
      g_ProcMem.WriteByte($90, dwHLBase + $30115); //Gauss
      g_ProcMem.WriteByte($90, dwHLBase + $30264); //Gauss Right Click
      //WriteByte($90, dwHLBase + $301B4); //Gauss
    end
    else if CurrentGame = 'o' then
    begin
      //Opfor code goes here (ACTIVATE)
      g_ProcMem.WriteByte($90, dwOPFORBase + $5A177); //Pistol 9mm
      g_ProcMem.WriteByte($90, dwOPFORBase + $B2234); //357 Magnum
      g_ProcMem.WriteByte($90, dwOPFORBase + $2D875); //Eagle
      g_ProcMem.WriteByte($90, dwOPFORBase + $73548); //SMG
      g_ProcMem.WriteByte($90, dwOPFORBase + $737D3); //SMG Grenade
      g_ProcMem.WriteByte($90, dwOPFORBase + $C407B); //Shotgun Primary
      g_ProcMem.WriteByte($90, dwOPFORBase + $C42FF); //Shotgun Secondary
      g_ProcMem.WriteByte($90, dwOPFORBase + $C42FF + 1);
      g_ProcMem.WriteByte($90, dwOPFORBase + $C42FF + 2);
      g_ProcMem.WriteByte($90, dwOPFORBase + $247A0); //Crossbow
      g_ProcMem.WriteByte($90, dwOPFORBase + $B9338); //RPG
      g_ProcMem.WriteByte($90, dwOPFORBase + $40E7A); //Gauss Primary
      g_ProcMem.WriteByte($90, dwOPFORBase + $40E7A + 1);
      g_ProcMem.WriteByte($90, dwOPFORBase + $40E7A + 2);
      g_ProcMem.WriteByte($90, dwOPFORBase + $40FED); //Gauss Secondary A
      g_ProcMem.WriteByte($90, dwOPFORBase + $4117B); //Gauss Secondary B
      g_ProcMem.WriteByte($90, dwOPFORBase + $32CDA); //Egon
      g_ProcMem.WriteByte($90, dwOPFORBase + $32CDA + 1);
      g_ProcMem.WriteByte($90, dwOPFORBase + $5B95F); //Hornet Primary
      g_ProcMem.WriteByte($90, dwOPFORBase + $5C2E8); //Hornet Secondary
      g_ProcMem.WriteByte($90, dwOPFORBase + $4E185); //Grenade
      g_ProcMem.WriteByte($90, dwOPFORBase + $BA2AA); //Satchel
      g_ProcMem.WriteByte($90, dwOPFORBase + $DB1FC); //Mine
      g_ProcMem.WriteByte($90, dwOPFORBase + $CD3A2); //Snark
      g_ProcMem.WriteByte($90, dwOPFORBase + $65356); //M249
      g_ProcMem.WriteByte($90, dwOPFORBase + $299C9); //Displacer
      g_ProcMem.WriteByte($90, dwOPFORBase + $299C9 + 1);
      g_ProcMem.WriteByte($90, dwOPFORBase + $299C9 + 2);
      g_ProcMem.WriteByte($90, dwOPFORBase + $C525C); //Sniper
      g_ProcMem.WriteByte($90, dwOPFORBase + $C8F77); //Spore Launcher Primary
      g_ProcMem.WriteByte($90, dwOPFORBase + $C9208); //Spore Launcher Secondary
      g_ProcMem.WriteByte($90, dwOPFORBase + $C02E1); //Shock Roach
    end
    else if CurrentGame = 'b' then
    begin
      //Blue Shit code goes here (ACTIVATE)
      g_ProcMem.WriteByte($90, dwHLBase + $3A425);//Pistol 9mm
      g_ProcMem.WriteByte($90, dwHLBase + $6D6C3);//357 Magnum
      g_ProcMem.WriteByte($90, dwHLBase + $4BB80);//SMG
      g_ProcMem.WriteByte($90, dwHLBase + $4BDD2);//SMG Grenade
      g_ProcMem.WriteByte($90, dwHLBase + $775A6);//Shotgun Primary
      g_ProcMem.WriteByte($90, dwHLBase + $777E9);//Shotgun Secondary
      g_ProcMem.WriteByte($90, dwHLBase + $777E9 + 1);
      g_ProcMem.WriteByte($90, dwHLBase + $777E9 + 2);
      g_ProcMem.WriteByte($90, dwHLBase + $1DB8A);//Crossbow
      g_ProcMem.WriteByte($90, dwHLBase + $70A8A);//RPG
      g_ProcMem.WriteByte($90, dwHLBase + $2FB80);//Gauss Primary
      g_ProcMem.WriteByte($90, dwHLBase + $2FB80 + 1);
      g_ProcMem.WriteByte($90, dwHLBase + $2FB80 + 2);
      g_ProcMem.WriteByte($90, dwHLBase + $2FCB4);//Gauss Secondary A
      g_ProcMem.WriteByte($90, dwHLBase + $2FE03);//Gauss Secondary B
      g_ProcMem.WriteByte($90, dwHLBase + $2597A);//Egon
      g_ProcMem.WriteByte($90, dwHLBase + $2597A + 1);
      g_ProcMem.WriteByte($90, dwHLBase + $3BB43);//Hornet Primary
      g_ProcMem.WriteByte($90, dwHLBase + $3C44C);//Hornet Secondary
      g_ProcMem.WriteByte($90, dwHLBase + $350D6);//Grenade
      g_ProcMem.WriteByte($90, dwHLBase + $718E8);//Satchel
      g_ProcMem.WriteByte($90, dwHLBase + $718E8 + 1);
      g_ProcMem.WriteByte($90, dwHLBase + $87871);//Mine
      g_ProcMem.WriteByte($90, dwHLBase + $7D31E);//Snark
    end;

  end
  else
  begin
    if CurrentGame = 'h' then
    begin
      g_ProcMem.WriteByte($4A, dwHLBase + $6D5F3); //357 X
      g_ProcMem.WriteByte($48, dwHLBase + $3A616); //Pistol X
      g_ProcMem.WriteByte($4A, dwHLBase + $4B990); //SMG  X
      g_ProcMem.WriteByte($4A, dwHLBase + $76297); //Shotgun X
      g_ProcMem.WriteByte($83, dwHLBase + $764DA); //Shotgun Doppelschuss  83 C2 FE
      g_ProcMem.WriteByte($C2, dwHLBase + $764DA + 1); //Shotgun Doppelschuss
      g_ProcMem.WriteByte($FE, dwHLBase + $764DA + 2); //Shotgun Doppelschuss
      g_ProcMem.WriteByte($48, dwHLBase + $1DF4A); //Crossbow X
      g_ProcMem.WriteByte($49, dwHLBase + $6F77A); //Rockets X
      g_ProcMem.WriteByte($2B, dwHLBase + $25DDA); //Egon 1 X
      g_ProcMem.WriteByte($C2, dwHLBase + $25DDB); //Egon 2 X
      g_ProcMem.WriteByte($4F, dwHLBase + $3BD33); //Hornet 2 X
      g_ProcMem.WriteByte($49, dwHLBase + $3C63C);  //Hornet Rightclick
      g_ProcMem.WriteByte($4F, dwHLBase + $352C7); //Nades X
      g_ProcMem.WriteByte($49, dwHLBase + $705DF); //Satchel X
      g_ProcMem.WriteByte($49, dwHLBase + $863A1); //Mines X
      g_ProcMem.WriteByte($49, dwHLBase + $7C022); //Snarks X
      g_ProcMem.WriteByte($4F, dwHLBase + $4BBE2); //SMG Launcher X
      g_ProcMem.WriteByte($83, dwHLBase + $2FFE1); //Gauss X
      g_ProcMem.WriteByte($C1, dwHLBase + $2FFE2); //Gauss X
      g_ProcMem.WriteByte($FE, dwHLBase + $2FFE3); //Gauss X
      g_ProcMem.WriteByte($49, dwHLBase + $30115); //Gauss X
      g_ProcMem.WriteByte($49, dwHLBase + $30264); //Gauss Right click
      //WriteByte($49, dwHLBase + $301B4); //Gauss
    end
    else if CurrentGame = 'o' then
    begin
      //Opfor code goes here (DEACTIVATE)
      g_ProcMem.WriteByte($48, dwOPFORBase + $5A177); //Pistol 9mm
      g_ProcMem.WriteByte($48, dwOPFORBase + $B2234); //357 Magnum
      g_ProcMem.WriteByte($4F, dwOPFORBase + $2D875); //Eagle
      g_ProcMem.WriteByte($4A, dwOPFORBase + $73548); //SMG
      g_ProcMem.WriteByte($49, dwOPFORBase + $737D3); //SMG Grenade
      g_ProcMem.WriteByte($48, dwOPFORBase + $C407B); //Shotgun Primary
      g_ProcMem.WriteByte($83, dwOPFORBase + $C42FF); //Shotgun Secondary
      g_ProcMem.WriteByte($C0, dwOPFORBase + $C42FF + 1);
      g_ProcMem.WriteByte($FE, dwOPFORBase + $C42FF + 2);
      g_ProcMem.WriteByte($48, dwOPFORBase + $247A0); //Crossbow
      g_ProcMem.WriteByte($48, dwOPFORBase + $B9338); //RPG
      g_ProcMem.WriteByte($83, dwOPFORBase + $40E7A); //Gauss Primary
      g_ProcMem.WriteByte($C1, dwOPFORBase + $40E7A + 1);
      g_ProcMem.WriteByte($FE, dwOPFORBase + $40E7A + 2);
      g_ProcMem.WriteByte($49, dwOPFORBase + $40FED); //Gauss Secondary A
      g_ProcMem.WriteByte($49, dwOPFORBase + $4117B); //Gauss Secondary B
      g_ProcMem.WriteByte($2B, dwOPFORBase + $32CDA); //Egon
      g_ProcMem.WriteByte($C2, dwOPFORBase + $32CDA + 1);
      g_ProcMem.WriteByte($49, dwOPFORBase + $5B95F); //Hornet Primary
      g_ProcMem.WriteByte($49, dwOPFORBase + $5C2E8); //Hornet Secondary
      g_ProcMem.WriteByte($4A, dwOPFORBase + $4E185); //Grenade
      g_ProcMem.WriteByte($49, dwOPFORBase + $BA2AA); //Satchel
      g_ProcMem.WriteByte($49, dwOPFORBase + $DB1FC); //Mine
      g_ProcMem.WriteByte($49, dwOPFORBase + $CD3A2); //Snark
      g_ProcMem.WriteByte($4A, dwOPFORBase + $65356); //M249
      g_ProcMem.WriteByte($83, dwOPFORBase + $299C9); //Displacer
      g_ProcMem.WriteByte($C1, dwOPFORBase + $299C9 + 1);
      g_ProcMem.WriteByte($EC, dwOPFORBase + $299C9 + 2);
      g_ProcMem.WriteByte($4B, dwOPFORBase + $C525C); //Sniper
      g_ProcMem.WriteByte($48, dwOPFORBase + $C8F77); //Spore Launcher Primary
      g_ProcMem.WriteByte($48, dwOPFORBase + $C9208); //Spore Launcher Secondary
      g_ProcMem.WriteByte($49, dwOPFORBase + $C02E1); //Shock Roach

    end
    else if CurrentGame = 'b' then
    begin
      //to do (deactivate)
      g_ProcMem.WriteByte($48, dwHLBase + $3A425);//Pistol 9mm
      g_ProcMem.WriteByte($4A, dwHLBase + $6D6C3);//357 Magnum
      g_ProcMem.WriteByte($4A, dwHLBase + $4BB80);//SMG
      g_ProcMem.WriteByte($4F, dwHLBase + $4BDD2);//SMG Grenade
      g_ProcMem.WriteByte($4A, dwHLBase + $775A6);//Shotgun Primary
      g_ProcMem.WriteByte($83, dwHLBase + $777E9);//Shotgun Secondary
      g_ProcMem.WriteByte($C2, dwHLBase + $777E9 + 1);
      g_ProcMem.WriteByte($FE, dwHLBase + $777E9 + 2);
      g_ProcMem.WriteByte($48, dwHLBase + $1DB8A);//Crossbow
      g_ProcMem.WriteByte($48, dwHLBase + $70A8A);//RPG
      g_ProcMem.WriteByte($83, dwHLBase + $2FB80);//Gauss Primary
      g_ProcMem.WriteByte($C1, dwHLBase + $2FB80 + 1);
      g_ProcMem.WriteByte($FE, dwHLBase + $2FB80 + 2);
      g_ProcMem.WriteByte($49, dwHLBase + $2FCB4);//Gauss Secondary A
      g_ProcMem.WriteByte($49, dwHLBase + $2FE03);//Gauss Secondary B
      g_ProcMem.WriteByte($2B, dwHLBase + $2597A);//Egon
      g_ProcMem.WriteByte($C2, dwHLBase + $2597A + 1);
      g_ProcMem.WriteByte($4A, dwHLBase + $3BB43);//Hornet Primary
      g_ProcMem.WriteByte($49, dwHLBase + $3C44C);//Hornet Secondary
      g_ProcMem.WriteByte($4F, dwHLBase + $350D6);//Grenade
      g_ProcMem.WriteByte($FF, dwHLBase + $718E8);//Satchel
      g_ProcMem.WriteByte($08, dwHLBase + $718E8 + 1);
      g_ProcMem.WriteByte($49, dwHLBase + $87871);//Mine
      g_ProcMem.WriteByte($49, dwHLBase + $7D31E);//Snark
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


{ ---------------------- CheckBoxProperRapidfireChange --------------------- }
{ -> Rapidfire is achieved by NOPing a specific jump, that is also specific  }
{    to each version/mod/expansion of halflife. So adding support for more   }
{    versions or mods is possible, it will also become a nightmare to        }
{    maintain                                                                }
{ -> is triggered when the checkbox is clicked, assembly code is disabled    }
{    according to state and according to the CurrentGame flag                }
procedure TForm1.CheckBoxProperRapidfireChange(Sender: TObject);
begin
  if (CheckBoxProperRapidfire.Checked) then
  begin
    if CurrentGame = 'h' then
    begin
      //Rapid fire all guns
      g_ProcMem.WriteByte($90, dwHLBase + $63318);   //Primary Fire
      g_ProcMem.WriteByte($90, dwHLBase + $63319);

      g_ProcMem.WriteByte($90, dwHLBase + $63344);   //Secondary Fire
      g_ProcMem.WriteByte($90, dwHLBase + $63345);
    end                                                    //LocalPlayer
    else if CurrentGame = 'o' then
    begin
      //Opfor code goes here
      g_ProcMem.WriteByte($90, dwOPFORBase + $A67F6);//Primary Fire
      g_ProcMem.WriteByte($90, dwOPFORBase + $A67F6 + 1);

      g_ProcMem.WriteByte($90, dwOPFORBase + $A6822);//Secondary Fire
      g_ProcMem.WriteByte($90, dwOPFORBase + $A6822 + 1);
    end
    else if CurrentGame = 'b' then
    begin
      //Blue Shift
      g_ProcMem.WriteByte($90, dwHLBase + $63488);   //Primary Fire
      g_ProcMem.WriteByte($90, dwHLBase + $63489);

      g_ProcMem.WriteByte($90, dwHLBase + $634B4);   //Secondary Fire
      g_ProcMem.WriteByte($90, dwHLBase + $634B5);
    end;
  end
  else
  begin
    if CurrentGame = 'h' then
    begin
      g_ProcMem.WriteByte($74, dwHLBase + $63318);   //Primary Fire
      g_ProcMem.WriteByte($08, dwHLBase + $63319);

      g_ProcMem.WriteByte($74, dwHLBase + $63344);   //Secondary Fire
      g_ProcMem.WriteByte($08, dwHLBase + $63345);

    end
    else if CurrentGame = 'o' then
    begin
      //Opfor code goes here
      g_ProcMem.WriteByte($74, dwOPFORBase + $A67F6);//Primary Fire
      g_ProcMem.WriteByte($08, dwOPFORBase + $A67F6 + 1);

      g_ProcMem.WriteByte($74, dwOPFORBase + $A6822);//Secondary Fire
      g_ProcMem.WriteByte($08, dwOPFORBase + $A6822 + 1);
    end
    else if CurrentGame = 'b' then
    begin
      //Blue Shift
      g_ProcMem.WriteByte($74, dwHLBase + $63488);   //Primary Fire
      g_ProcMem.WriteByte($08, dwHLBase + $63489);

      g_ProcMem.WriteByte($74, dwHLBase + $634B4);   //Secondary Fire
      g_ProcMem.WriteByte($08, dwHLBase + $634B5);
    end;
  end;

end;

{ ---------------------------- ButtonReInitClick --------------------------- }
{ -> just runs the FormCreate again in order to find the process etc.        }
{ -> resets some checkboxes                                                  }
procedure TForm1.ButtonReInitClick(Sender: TObject);
begin
  CheckBoxProperRapidfire.Checked := False;
  CheckBoxInfAmmo.Checked := False;
  CheckBoxAutoBhop.Enabled := True;
  ReIniter := True;
  FormCreate(nil);
end;


{ ------------------------- CheckBoxAutoBhopChange ------------------------- }
{ -> turns on AutoBhop, if HLpMod is not injected. HLpMod already has an     }
{    AutoBhop included which is waaay better and is always on. So to avoid   }
{    conflicts, Half-Life Trainer's AutoBhop is disabled                     }
procedure TForm1.CheckBoxAutoBhopChange(Sender: TObject);
begin
  if CheckBoxAutoBhop.Checked then
  begin
    if not g_ProcMem.IsDllLoadedInProcess('HLpMod.dll') then
    begin
      TimerBhop.Enabled := True;
    end
    else
    begin
      CheckBoxAutoBhop.Checked := False;
      CheckBoxAutoBhop.Enabled := False;
      //ShowMessage('Error: Can''t enable AutoBhop' + sLineBreak +  '          HLpMod has its own AutoBhop');
      Log('HLpMod''s Bhop preferred');
    end;
  end
  else
    TimerBhop.Enabled := False;
end;


{ ----------------------------- ButtonHelpClick ---------------------------- }
{ -> the formatting dies when using JEDI, so beware. It looks fine in the    }
{    messagebox, but it is a pain to change.                                 }
procedure TForm1.ButtonHelpClick(Sender: TObject);
begin
  ShowMessage('Half-Life Trainer v1.3.5' + sLineBreak +
    'by pombenenge (on YouTube)' + sLineBreak +
    'Last Updated: 2023-08-18' + sLineBreak +
    sLineBreak +
    'Features: Health and Armor regeneration, Rapidfire, Infinite Ammo, AutoBhop'
    +
    sLineBreak + sLineBreak +
    'WARNING: The trainer may cause crashes. Save often.' +
    sLineBreak + sLineBreak + '-- How to use --' + sLineBreak +
    '1. Start Half-life, Opposing Force or Blue Shift (Tested on Steam version, other versions probably don''t work)'
    +
    sLineBreak +
    '2. Start the trainer (If the trainer is already running, click on "Reinitialize")' +
    sLineBreak + '3. Adjust trainer settings to your liking.'
    + sLineBreak + sLineBreak + '-- FAQ --' +
    sLineBreak + 'Q: Does it work in multiplayer?' +
    sLineBreak +
    'A: No. If you try you will get VAC banned. Seriously, do NOT do it.' +
    sLineBreak + sLineBreak + 'Q: Nothing happens? Why?' +
    sLineBreak + 'A: There can be multiple reasons why it does not work.' +
    sLineBreak +
    '   1. You probably need the Steam version of Half-Life. (Cracked or WON version do not work)'
    + sLineBreak + '   2. Run the trainer as administrator.' +
    sLineBreak +
    '   3. Check the instructions above and make sure you are doing it right.' +
    sLineBreak +
    '   4. The trainer may be outdated. (If you have confirmed that everything else is not the cause'
    + sLineBreak + '       contact me on YouTube)' +
    sLineBreak + sLineBreak + 'Q: Why do I explode when I spam SMG grenades'
    +
    sLineBreak +
    'A: When you are in the main menu type "fps_max 100" into the console. In-Game try walking backwards or'
    +
    sLineBreak + '     moving your mouse left or right while shooting grenades.'
    + sLineBreak + '     The grenades must not collide in mid air!'
    + sLineBreak + sLineBreak + 'Q: What is HLpMod.dll?' +
    sLineBreak +
    'A: HLpMod is an OpenGL overlay I made which provides some extra information. It is inteded mainly for bunnyhopping'
    +
    sLineBreak +
    '     and includes it''s own frame perfect AutoBhop, which is always on,' +
    sLineBreak +
    '     and a speedometer (and max speed since last quickload) The source code is also on my GitHub'
    + sLineBreak + sLineBreak +
    'Q: My pirated version of the game won''t work with this trainer!' +
    sLineBreak + 'A: Buy the damn game! It''s like 10 bucks jfc..' +
    sLineBreak +
    '     If you''re too poor, here is your answer: Cracked versions are not supported.'
    + sLineBreak + sLineBreak +
    'Click on the icons for GitHub and YouTube links' +
    sLineBreak + sLineBreak + 'Have fun!'
    );
end;


{ -------------------------- ButtonEnableAllClick -------------------------- }
{ -> enabled all options and sets all trackbars to maximum                   }
{ -> does not inject HLpMod.dll though                                       }
procedure TForm1.ButtonEnableAllClick(Sender: TObject);
begin
  TrackBarMaxHP.Position := 1000;
  TrackBarMaxAP.Position := 1000;
  TrackBarHPRate.Position := 1000;
  TrackBarAPRate.Position := 1000;
  CheckBoxEnableHPRegen.Checked := True;
  CheckBoxEnableAPRegen.Checked := True;
  CheckBoxProperRapidfire.Checked := True;
  CheckBoxAutoBhop.Checked := True;
  CheckBoxInfAmmo.Checked := True;
end;



{ ---------------------------- TimerRegenTimer ----------------------------- }
{ -> takes care of health and/or armor regeneration, if the timer active     }
{    (which is controlled by the appropriate checkboxes)                     }
procedure TForm1.TimerRegenTimer(Sender: TObject);
begin
  if Assigned(g_ProcMem) then begin
    { ------------------------- Read Current HP & AP ------------------------- }
    LocalPlayer.fHP := g_ProcMem.ReadFloat(LocalPlayer.dwAddHP);
    LocalPlayer.fAP := g_ProcMem.ReadFloat(LocalPlayer.dwAddAP);

    { ----------------------------- Regenerate HP ---------------------------- }
    if CheckBoxEnableHPRegen.Checked and (LocalPlayer.fHP <> StrToInt(EditMaxHP.Text)) then
      if ((LocalPlayer.fHP + (LocalPlayer.fHPRate)) <=
        single(TrackBarMaxHP.Position + 1)) then
      begin
        LocalPlayer.fHP := LocalPlayer.fHP + LocalPlayer.fHPRate;
        g_ProcMem.WriteFloat(LocalPlayer.fHP, LocalPlayer.dwAddHP);
      end
      else if ((LocalPlayer.fHP - (LocalPlayer.fHPRate)) >=
        single(TrackBarMaxHP.Position)) then
      begin
        LocalPlayer.fHP := LocalPlayer.fHP - LocalPlayer.fHPRate;
        g_ProcMem.WriteFloat(LocalPlayer.fHP, LocalPlayer.dwAddHP);
      end;


    { ----------------------------- Regenerate AP ---------------------------- }
    if CheckBoxEnableAPRegen.Checked and (LocalPlayer.fAP <> StrToInt(EditMaxAP.Text)) then
      if ((LocalPlayer.fAP + (LocalPlayer.fAPRate)) <=
        single(TrackBarMaxAP.Position + 1)) then
      begin
        LocalPlayer.fAP := LocalPlayer.fAP + LocalPlayer.fAPRate;
        g_ProcMem.WriteFloat(LocalPlayer.fAP, LocalPlayer.dwAddAP);
      end
      else if ((LocalPlayer.fAP - (LocalPlayer.fAPRate)) >=
        single(TrackBarMaxAP.Position)) then
      begin
        LocalPlayer.fAP := LocalPlayer.fAP - LocalPlayer.fAPRate;
        g_ProcMem.WriteFloat(LocalPlayer.fAP, LocalPlayer.dwAddAP);
    end;
  end;
end;


{ -------------------------- TrackBarAPRateChange -------------------------- }
{ -> handles changes to the regeneration rate of armor, when the trackbar is }
{    moved                                                                   }
procedure TForm1.TrackBarAPRateChange(Sender: TObject);
begin
  LabelAPRate.Caption := floatToStr((TrackBarAPRate.Position) / 10) + '%';
  LocalPlayer.fAPRate := TrackBarAPRate.Position / 1000;
  if EditAPRate.Text <> '' then
    EditAPRate.Text := IntToStr(TrackBarAPRate.Position);
end;


{ -------------------------- TrackBarHPRateChange -------------------------- }
{ -> handles changes to the regeneration rate of health, when the trackbar   }
{    is moved                                                                }
procedure TForm1.TrackBarHPRateChange(Sender: TObject);
begin
  LabelHPRate.Caption := floatToStr((TrackBarHPRate.Position) / 10) + '%';
  LocalPlayer.fHPRate := TrackBarHPRate.Position / 1000;
  if EditHPRate.Text <> '' then
    EditHPRate.Text := IntToStr(TrackBarHPRate.Position);
end;


{ --------------------------- TrackBarMaxAPChange -------------------------- }
{ -> handles changes to the maximum amount of armor to be regenerated, when  }
{    the trackbar is moved                                                   }
procedure TForm1.TrackBarMaxAPChange(Sender: TObject);
begin
  LocalPlayer.fMaxAP := TrackBarMaxAP.Position;
  LabelMaxAP.Caption := IntToStr(TrackBarMaxAP.Position);
  if EditMaxAP.Text <> '' then
    EditMaxAP.Text := IntToStr(TrackBarMaxAP.Position);
end;


{ --------------------------- TrackBarMaxHPChange -------------------------- }
{ -> handles changes to the maximum amount of health to be regenerated, when }
{    the trackbar is moved                                                   }
procedure TForm1.TrackBarMaxHPChange(Sender: TObject);
begin
  LocalPlayer.fMaxHP := TrackBarMaxHP.Position;
  LabelMaxHP.Caption := IntToStr(TrackBarMaxHP.Position);
  if EditMaxHP.Text <> '' then
    EditMaxHP.Text := IntToStr(TrackBarMaxHP.Position);
end;


procedure TForm1.Log(LogText: string);
begin
  Form1.ListBoxLog.AddItem(LogText, nil);
  Form1.ListBoxLog.ItemIndex := Form1.ListBoxLog.Items.Count - 1;
  Form1.ListBoxLog.ClearSelection;
end;


end.
