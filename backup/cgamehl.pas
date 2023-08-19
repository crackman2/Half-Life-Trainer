unit CgameHL;

{$mode ObjFPC}{$H+}

{ --------------------------------- gameHL --------------------------------- }
{ -> contains functions for infinite ammo and rapidfire for Half-Life        }


interface

uses
  Classes, SysUtils, Dialogs, Windows,

  { custom }
  CProcMem;
type
  TgameHL = class
    constructor Create(g_ProcMem:TProcMem; dwHLBase:PDWORD);
    function EnableInfiniteAmmo(State:Boolean): Boolean;
    function EnableRapidFire(State:Boolean): Boolean;
    public
      ProcMem:TProcMem;
      dwHLBase:PDWORD;
    private
  end;


implementation

constructor TgameHL.Create(g_ProcMem:TProcMem; dwHLBase:PDWORD);
begin
  Self.dwHLBase:=dwHLBase;
  Self.ProcMem:=g_ProcMem;
  { dwHLBase is always zero when in the main menu
  if Assigned(g_ProcMem) then Self.ProcMem:=g_ProcMem else ShowMessage('TgameHL constructor: g_ProcMem is invalid');
  if dwHLBase^ > 1 then Self.dwHLBase:=dwHLBase else ShowMessage('TgameHL constructor: dwHLBase is invalid' + sLineBreak +
  'Value: 0x' + IntToHex(dwHLBase^,8));
  }
end;

function TgameHL.EnableInfiniteAmmo(State:Boolean): Boolean;
begin
  Result:=False;
  if Assigned(ProcMem) and (dwHLBase^ > 0) then begin
    if State then begin
      ProcMem.WriteByte($90, dwHLBase^ + $6D5F3); //357 X  FIXED
      ProcMem.WriteByte($90, dwHLBase^ + $3A616); //Pistol X
      ProcMem.WriteByte($90, dwHLBase^ + $4B990); //SMG X
      ProcMem.WriteByte($90, dwHLBase^ + $76297); //Shotgun X FIXED 764DA
      ProcMem.WriteByte($90, dwHLBase^ + $764DA); //Shotgun Doppelschuss  FIXED
      ProcMem.WriteByte($90, dwHLBase^ + $764DA + 1); //Shotgun Doppelschuss
      ProcMem.WriteByte($90, dwHLBase^ + $764DA + 2); //Shotgun Doppelschuss
      ProcMem.WriteByte($90, dwHLBase^ + $1DF4A); //Crossbow X
      ProcMem.WriteByte($90, dwHLBase^ + $6F77A); //Rockets X
      ProcMem.WriteByte($90, dwHLBase^ + $25DDA); //Egon 1 X
      ProcMem.WriteByte($90, dwHLBase^ + $25DDB); //Egon 2 X
      // hl.dll+3C59C - 49                    - dec ecx //Hornet gun rechtsklick
      ProcMem.WriteByte($90, dwHLBase^ + $3BD33); //Hornet 2 X
      ProcMem.WriteByte($90, dwHLBase^ + $3C63C); //Hornet rechtsklick
      ProcMem.WriteByte($90, dwHLBase^ + $352C7); //Nades   X
      ProcMem.WriteByte($90, dwHLBase^ + $705DF); //Satchel X
      ProcMem.WriteByte($90, dwHLBase^ + $863A1); //Mines X
      ProcMem.WriteByte($90, dwHLBase^ + $7C022); //Snarks X
      ProcMem.WriteByte($90, dwHLBase^ + $4BBE2); //SMG Launcher
      ProcMem.WriteByte($90, dwHLBase^ + $2FFE1); //Gauss
      ProcMem.WriteByte($90, dwHLBase^ + $2FFE2); //Gauss
      ProcMem.WriteByte($90, dwHLBase^ + $2FFE3); //Gauss
      ProcMem.WriteByte($90, dwHLBase^ + $30115); //Gauss
      ProcMem.WriteByte($90, dwHLBase^ + $30264); //Gauss Right Click
      //WriteByte($90, dwHLBase^ + $301B4); //Gauss
    end
    else begin
      ProcMem.WriteByte($4A, dwHLBase^ + $6D5F3); //357 X
      ProcMem.WriteByte($48, dwHLBase^ + $3A616); //Pistol X
      ProcMem.WriteByte($4A, dwHLBase^ + $4B990); //SMG  X
      ProcMem.WriteByte($4A, dwHLBase^ + $76297); //Shotgun X
      ProcMem.WriteByte($83, dwHLBase^ + $764DA); //Shotgun Doppelschuss  83 C2 FE
      ProcMem.WriteByte($C2, dwHLBase^ + $764DA + 1); //Shotgun Doppelschuss
      ProcMem.WriteByte($FE, dwHLBase^ + $764DA + 2); //Shotgun Doppelschuss
      ProcMem.WriteByte($48, dwHLBase^ + $1DF4A); //Crossbow X
      ProcMem.WriteByte($49, dwHLBase^ + $6F77A); //Rockets X
      ProcMem.WriteByte($2B, dwHLBase^ + $25DDA); //Egon 1 X
      ProcMem.WriteByte($C2, dwHLBase^ + $25DDB); //Egon 2 X
      ProcMem.WriteByte($4F, dwHLBase^ + $3BD33); //Hornet 2 X
      ProcMem.WriteByte($49, dwHLBase^ + $3C63C);  //Hornet Rightclick
      ProcMem.WriteByte($4F, dwHLBase^ + $352C7); //Nades X
      ProcMem.WriteByte($49, dwHLBase^ + $705DF); //Satchel X
      ProcMem.WriteByte($49, dwHLBase^ + $863A1); //Mines X
      ProcMem.WriteByte($49, dwHLBase^ + $7C022); //Snarks X
      ProcMem.WriteByte($4F, dwHLBase^ + $4BBE2); //SMG Launcher X
      ProcMem.WriteByte($83, dwHLBase^ + $2FFE1); //Gauss X
      ProcMem.WriteByte($C1, dwHLBase^ + $2FFE2); //Gauss X
      ProcMem.WriteByte($FE, dwHLBase^ + $2FFE3); //Gauss X
      ProcMem.WriteByte($49, dwHLBase^ + $30115); //Gauss X
      ProcMem.WriteByte($49, dwHLBase^ + $30264); //Gauss Right click
      //WriteByte($49, dwHLBase^ + $301B4); //Gauss
    end;
    Result:=True;
  end;
end;



function TgameHL.EnableRapidFire(State:Boolean): Boolean;
begin
  Result:=False;
  if Assigned(ProcMem) and (dwHLBase^ > 0) then begin
     if State then begin
       ProcMem.WriteByte($90, dwHLBase^ + $63318);   //Primary Fire
       ProcMem.WriteByte($90, dwHLBase^ + $63319);
       ProcMem.WriteByte($90, dwHLBase^ + $63344);   //Secondary Fire
       ProcMem.WriteByte($90, dwHLBase^ + $63345);
     end else begin
       ShowMessage('disable rapid for hl. hlbase: ' + IntToHex(dwHLBase^,8));
       ProcMem.WriteByte($74, dwHLBase^ + $63318);   //Primary Fire
       ProcMem.WriteByte($08, dwHLBase^ + $63319);
       ProcMem.WriteByte($74, dwHLBase^ + $63344);   //Secondary Fire
       ProcMem.WriteByte($08, dwHLBase^ + $63345);
     end;
     Result:=True;
  end;
end;

end.

