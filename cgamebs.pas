unit CgameBS;

{$mode ObjFPC}{$H+}

{ --------------------------------- gameBS --------------------------------- }
{ -> contains functions for infinite ammo and rapidfire for Blue Shift       }


interface

uses
  Classes, SysUtils, Dialogs, Windows,

  { custom }
  CProcMem;
type
  TgameBS = class
    constructor Create(g_ProcMem:TProcMem; dwHLBase:PDWORD);
    function EnableInfiniteAmmo(State:Boolean): Boolean;
    function EnableRapidFire(State:Boolean): Boolean;
    public
      ProcMem:TProcMem;
      dwHLBase:PDWORD;
    private
  end;


implementation

constructor TgameBS.Create(g_ProcMem:TProcMem; dwHLBase:PDWORD);
begin
  Self.dwHLBase:=dwHLBase;
  Self.ProcMem:=g_ProcMem;

  { dwHLBase is always zero when in the main menu
  if Assigned(g_ProcMem) then Self.ProcMem:=g_ProcMem else ShowMessage('TgameBS constructor: g_ProcMem is invalid');
  if dwHLBase^ > 1 then Self.dwHLBase:=dwHLBase else ShowMessage('TgameBS constructor: dwHLBase is invalid' + sLineBreak +
  'Value: 0x' + IntToHex(dwHLBase^,8));
  }
end;

function TgameBS.EnableInfiniteAmmo(State:Boolean): Boolean;
begin
  Result:=False;
  if Assigned(ProcMem) and (dwHLBase^ > 0) then begin
    if State then begin
      //Blue Shit code goes here (ACTIVATE)
      ProcMem.WriteByte($90, dwHLBase^ + $3A425);//Pistol 9mm
      ProcMem.WriteByte($90, dwHLBase^ + $6D6C3);//357 Magnum
      ProcMem.WriteByte($90, dwHLBase^ + $4BB80);//SMG
      ProcMem.WriteByte($90, dwHLBase^ + $4BDD2);//SMG Grenade
      ProcMem.WriteByte($90, dwHLBase^ + $775A6);//Shotgun Primary
      ProcMem.WriteByte($90, dwHLBase^ + $777E9);//Shotgun Secondary
      ProcMem.WriteByte($90, dwHLBase^ + $777E9 + 1);
      ProcMem.WriteByte($90, dwHLBase^ + $777E9 + 2);
      ProcMem.WriteByte($90, dwHLBase^ + $1DB8A);//Crossbow
      ProcMem.WriteByte($90, dwHLBase^ + $70A8A);//RPG
      ProcMem.WriteByte($90, dwHLBase^ + $2FB80);//Gauss Primary
      ProcMem.WriteByte($90, dwHLBase^ + $2FB80 + 1);
      ProcMem.WriteByte($90, dwHLBase^ + $2FB80 + 2);
      ProcMem.WriteByte($90, dwHLBase^ + $2FCB4);//Gauss Secondary A
      ProcMem.WriteByte($90, dwHLBase^ + $2FE03);//Gauss Secondary B
      ProcMem.WriteByte($90, dwHLBase^ + $2597A);//Egon
      ProcMem.WriteByte($90, dwHLBase^ + $2597A + 1);
      ProcMem.WriteByte($90, dwHLBase^ + $3BB43);//Hornet Primary
      ProcMem.WriteByte($90, dwHLBase^ + $3C44C);//Hornet Secondary
      ProcMem.WriteByte($90, dwHLBase^ + $350D6);//Grenade
      ProcMem.WriteByte($90, dwHLBase^ + $718E8);//Satchel
      ProcMem.WriteByte($90, dwHLBase^ + $718E8 + 1);
      ProcMem.WriteByte($90, dwHLBase^ + $87871);//Mine
      ProcMem.WriteByte($90, dwHLBase^ + $7D31E);//Snark
    end
    else begin
      //to do (deactivate)
      ProcMem.WriteByte($48, dwHLBase^ + $3A425);//Pistol 9mm
      ProcMem.WriteByte($4A, dwHLBase^ + $6D6C3);//357 Magnum
      ProcMem.WriteByte($4A, dwHLBase^ + $4BB80);//SMG
      ProcMem.WriteByte($4F, dwHLBase^ + $4BDD2);//SMG Grenade
      ProcMem.WriteByte($4A, dwHLBase^ + $775A6);//Shotgun Primary
      ProcMem.WriteByte($83, dwHLBase^ + $777E9);//Shotgun Secondary
      ProcMem.WriteByte($C2, dwHLBase^ + $777E9 + 1);
      ProcMem.WriteByte($FE, dwHLBase^ + $777E9 + 2);
      ProcMem.WriteByte($48, dwHLBase^ + $1DB8A);//Crossbow
      ProcMem.WriteByte($48, dwHLBase^ + $70A8A);//RPG
      ProcMem.WriteByte($83, dwHLBase^ + $2FB80);//Gauss Primary
      ProcMem.WriteByte($C1, dwHLBase^ + $2FB80 + 1);
      ProcMem.WriteByte($FE, dwHLBase^ + $2FB80 + 2);
      ProcMem.WriteByte($49, dwHLBase^ + $2FCB4);//Gauss Secondary A
      ProcMem.WriteByte($49, dwHLBase^ + $2FE03);//Gauss Secondary B
      ProcMem.WriteByte($2B, dwHLBase^ + $2597A);//Egon
      ProcMem.WriteByte($C2, dwHLBase^ + $2597A + 1);
      ProcMem.WriteByte($4A, dwHLBase^ + $3BB43);//Hornet Primary
      ProcMem.WriteByte($49, dwHLBase^ + $3C44C);//Hornet Secondary
      ProcMem.WriteByte($4F, dwHLBase^ + $350D6);//Grenade
      ProcMem.WriteByte($FF, dwHLBase^ + $718E8);//Satchel
      ProcMem.WriteByte($08, dwHLBase^ + $718E8 + 1);
      ProcMem.WriteByte($49, dwHLBase^ + $87871);//Mine
      ProcMem.WriteByte($49, dwHLBase^ + $7D31E);//Snark
    end;
    Result:=True;
  end;
end;



function TgameBS.EnableRapidFire(State:Boolean): Boolean;
begin
  Result:=False;
  if Assigned(ProcMem) and (dwHLBase^ > 0) then begin
     if State then begin
       ProcMem.WriteByte($90, dwHLBase^ + $63488);   //Primary Fire
       ProcMem.WriteByte($90, dwHLBase^ + $63489);
       ProcMem.WriteByte($90, dwHLBase^ + $634B4);   //Secondary Fire
       ProcMem.WriteByte($90, dwHLBase^ + $634B5);
     end else begin
       ProcMem.WriteByte($74, dwHLBase^ + $63488);   //Primary Fire
       ProcMem.WriteByte($08, dwHLBase^ + $63489);
       ProcMem.WriteByte($74, dwHLBase^ + $634B4);   //Secondary Fire
       ProcMem.WriteByte($08, dwHLBase^ + $634B5);
     end;
     Result:=True;
  end;
end;

end.

