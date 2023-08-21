unit CgameOP;

{$mode ObjFPC}{$H+}

{ --------------------------------- gameOP --------------------------------- }
{ -> contains functions for infinite ammo and rapidfire for Opposing Force   }


interface

uses
  Classes, SysUtils, Dialogs, Windows,

  { custom }
  Cgame, CProcMem;
type
  TgameOP = class (Tgame)
    {
    constructor Create(g_ProcMem:TProcMem; dwOPFORBase:PDWORD);
    function EnableInfiniteAmmo(State:Boolean): Boolean;
    function EnableRapidFire(State:Boolean): Boolean;
    public
      ProcMem:TProcMem;
      dwOPFORBase:PDWORD;
    private
    }
    protected
    procedure InitializeOpCodes; override;
  end;


implementation

procedure TgameOP.InitializeOpCodes;
var
  FOpCodeInfAmmo: array[0..24] of array of LongWord =
  (
    ($5A177, $48),                                 // Pistol 9mm
    ($B2234, $48),                                 // 357 Magnum
    ($2D875, $4F),                                 // Eagle
    ($73548, $4A),                                 // SMG
    ($737D3, $49),                                 // SMG Grenade
    ($C407B, $48),                                 // Shotgun Primary
    ($C42FF, $83, $C0, $FE),                       // Shotgun Secondary
    ($247A0, $48),                                 // Crossbow
    ($B9338, $48),                                 // RPG
    ($40E7A, $83, $C1, $FE),                       // Gauss Primary
    ($40FED, $49),                                 // Gauss Secondary A
    ($4117B, $49),                                 // Gauss Secondary B
    ($32CDA, $2B, $C2),                            // Egon
    ($5B95F, $49),                                 // Hornet Primary
    ($5C2E8, $49),                                 // Hornet Secondary
    ($4E185, $4A),                                 // Grenade
    ($BA2AA, $49),                                 // Satchel
    ($DB1FC, $49),                                 // Mine
    ($CD3A2, $49),                                 // Snark
    ($65356, $4A),                                 // M249
    ($299C9, $83, $C1, $EC),                       // Displacer
    ($C525C, $4B),                                 // Sniper
    ($C8F77, $48),                                 // Spore Launcher Primary
    ($C9208, $48),                                 // Spore Launcher Secondary
    ($C02E1, $49)                                  // Shock Roach
  );

  FOpCodeRapidFire: array [0..1] of array of LongWord =
  (
    ($A67F6, $74, $08),                            //Primary Fire
    ($A6822, $74, $08)                             //Secondary Fire
  );

  j:Integer;
  jj:integer;
begin
  SetLength(OpCodeInfAmmo,Length(FOpCodeInfAmmo));

  for j:=0 to High(FOpCodeInfAmmo) do begin
    SetLength(OpCodeInfAmmo[j],Length(FOpCodeInfAmmo[j]));
    for jj:=0 to High(FOpCodeInfAmmo[j]) do begin
      OpCodeInfAmmo[j,jj]:=FOpCodeInfAmmo[j,jj];
    end;
  end;

  SetLength(OpCodeRapidFire,Length(FOpCodeRapidFire));

  for j:=0 to High(FOpCodeRapidFire) do begin
    SetLength(OpCodeRapidFire[j],Length(FOpCodeRapidFire[j]));
    for jj:=0 to High(FOpCodeRapidFire[j]) do begin
      OpCodeRapidFire[j,jj]:=FOpCodeRapidFire[j,jj];
    end;
  end;

end;


{
constructor TgameOP.Create(g_ProcMem:TProcMem; dwOPFORBase:PDWORD);
begin
  Self.dwOPFORBase:=dwOPFORBase;
  Self.ProcMem:=g_ProcMem;
  {  dwOPFORBase is always zero when in the main menu
  if Assigned(g_ProcMem) then Self.ProcMem:=g_ProcMem else ShowMessage('TgameOP constructor: g_ProcMem is invalid');
  if dwOPFORBase^ > 1 then Self.dwOPFORBase:=dwOPFORBase else ShowMessage('TgameOP constructor: dwOPFORBase is invalid' + sLineBreak +
  'Value: 0x' + IntToHex(dwOPFORBase^,8));
  }
end;

function TgameOP.EnableInfiniteAmmo(State:Boolean): Boolean;
begin
  Result:=False;
  if Assigned(ProcMem) and (dwOPFORBase^ > 0) then begin
    if State then begin
      //Opfor code goes here (ACTIVATE)
      ProcMem.WriteByte($90, dwOPFORBase^ + $5A177); //Pistol 9mm
      ProcMem.WriteByte($90, dwOPFORBase^ + $B2234); //357 Magnum
      ProcMem.WriteByte($90, dwOPFORBase^ + $2D875); //Eagle
      ProcMem.WriteByte($90, dwOPFORBase^ + $73548); //SMG
      ProcMem.WriteByte($90, dwOPFORBase^ + $737D3); //SMG Grenade
      ProcMem.WriteByte($90, dwOPFORBase^ + $C407B); //Shotgun Primary
      ProcMem.WriteByte($90, dwOPFORBase^ + $C42FF); //Shotgun Secondary
      ProcMem.WriteByte($90, dwOPFORBase^ + $C42FF + 1);
      ProcMem.WriteByte($90, dwOPFORBase^ + $C42FF + 2);
      ProcMem.WriteByte($90, dwOPFORBase^ + $247A0); //Crossbow
      ProcMem.WriteByte($90, dwOPFORBase^ + $B9338); //RPG
      ProcMem.WriteByte($90, dwOPFORBase^ + $40E7A); //Gauss Primary
      ProcMem.WriteByte($90, dwOPFORBase^ + $40E7A + 1);
      ProcMem.WriteByte($90, dwOPFORBase^ + $40E7A + 2);
      ProcMem.WriteByte($90, dwOPFORBase^ + $40FED); //Gauss Secondary A
      ProcMem.WriteByte($90, dwOPFORBase^ + $4117B); //Gauss Secondary B
      ProcMem.WriteByte($90, dwOPFORBase^ + $32CDA); //Egon
      ProcMem.WriteByte($90, dwOPFORBase^ + $32CDA + 1);
      ProcMem.WriteByte($90, dwOPFORBase^ + $5B95F); //Hornet Primary
      ProcMem.WriteByte($90, dwOPFORBase^ + $5C2E8); //Hornet Secondary
      ProcMem.WriteByte($90, dwOPFORBase^ + $4E185); //Grenade
      ProcMem.WriteByte($90, dwOPFORBase^ + $BA2AA); //Satchel
      ProcMem.WriteByte($90, dwOPFORBase^ + $DB1FC); //Mine
      ProcMem.WriteByte($90, dwOPFORBase^ + $CD3A2); //Snark
      ProcMem.WriteByte($90, dwOPFORBase^ + $65356); //M249
      ProcMem.WriteByte($90, dwOPFORBase^ + $299C9); //Displacer
      ProcMem.WriteByte($90, dwOPFORBase^ + $299C9 + 1);
      ProcMem.WriteByte($90, dwOPFORBase^ + $299C9 + 2);
      ProcMem.WriteByte($90, dwOPFORBase^ + $C525C); //Sniper
      ProcMem.WriteByte($90, dwOPFORBase^ + $C8F77); //Spore Launcher Primary
      ProcMem.WriteByte($90, dwOPFORBase^ + $C9208); //Spore Launcher Secondary
      ProcMem.WriteByte($90, dwOPFORBase^ + $C02E1); //Shock Roach
    end
    else begin
      //Opfor code goes here (DEACTIVATE)
      ProcMem.WriteByte($48, dwOPFORBase^ + $5A177); //Pistol 9mm
      ProcMem.WriteByte($48, dwOPFORBase^ + $B2234); //357 Magnum
      ProcMem.WriteByte($4F, dwOPFORBase^ + $2D875); //Eagle
      ProcMem.WriteByte($4A, dwOPFORBase^ + $73548); //SMG
      ProcMem.WriteByte($49, dwOPFORBase^ + $737D3); //SMG Grenade
      ProcMem.WriteByte($48, dwOPFORBase^ + $C407B); //Shotgun Primary
      ProcMem.WriteByte($83, dwOPFORBase^ + $C42FF); //Shotgun Secondary
      ProcMem.WriteByte($C0, dwOPFORBase^ + $C42FF + 1);
      ProcMem.WriteByte($FE, dwOPFORBase^ + $C42FF + 2);
      ProcMem.WriteByte($48, dwOPFORBase^ + $247A0); //Crossbow
      ProcMem.WriteByte($48, dwOPFORBase^ + $B9338); //RPG
      ProcMem.WriteByte($83, dwOPFORBase^ + $40E7A); //Gauss Primary
      ProcMem.WriteByte($C1, dwOPFORBase^ + $40E7A + 1);
      ProcMem.WriteByte($FE, dwOPFORBase^ + $40E7A + 2);
      ProcMem.WriteByte($49, dwOPFORBase^ + $40FED); //Gauss Secondary A
      ProcMem.WriteByte($49, dwOPFORBase^ + $4117B); //Gauss Secondary B
      ProcMem.WriteByte($2B, dwOPFORBase^ + $32CDA); //Egon
      ProcMem.WriteByte($C2, dwOPFORBase^ + $32CDA + 1);
      ProcMem.WriteByte($49, dwOPFORBase^ + $5B95F); //Hornet Primary
      ProcMem.WriteByte($49, dwOPFORBase^ + $5C2E8); //Hornet Secondary
      ProcMem.WriteByte($4A, dwOPFORBase^ + $4E185); //Grenade
      ProcMem.WriteByte($49, dwOPFORBase^ + $BA2AA); //Satchel
      ProcMem.WriteByte($49, dwOPFORBase^ + $DB1FC); //Mine
      ProcMem.WriteByte($49, dwOPFORBase^ + $CD3A2); //Snark
      ProcMem.WriteByte($4A, dwOPFORBase^ + $65356); //M249
      ProcMem.WriteByte($83, dwOPFORBase^ + $299C9); //Displacer
      ProcMem.WriteByte($C1, dwOPFORBase^ + $299C9 + 1);
      ProcMem.WriteByte($EC, dwOPFORBase^ + $299C9 + 2);
      ProcMem.WriteByte($4B, dwOPFORBase^ + $C525C); //Sniper
      ProcMem.WriteByte($48, dwOPFORBase^ + $C8F77); //Spore Launcher Primary
      ProcMem.WriteByte($48, dwOPFORBase^ + $C9208); //Spore Launcher Secondary
      ProcMem.WriteByte($49, dwOPFORBase^ + $C02E1); //Shock Roach
    end;
    Result:=True;
  end;
end;



function TgameOP.EnableRapidFire(State:Boolean): Boolean;
begin
  Result:=False;
  if Assigned(ProcMem) and (dwOPFORBase^ > 0) then begin
     if State then begin
       //Opfor code goes here
       ProcMem.WriteByte($90, dwOPFORBase^ + $A67F6);//Primary Fire
       ProcMem.WriteByte($90, dwOPFORBase^ + $A67F6 + 1);
       ProcMem.WriteByte($90, dwOPFORBase^ + $A6822);//Secondary Fire
       ProcMem.WriteByte($90, dwOPFORBase^ + $A6822 + 1);
     end else begin
       //Opfor code goes here
       ProcMem.WriteByte($74, dwOPFORBase^ + $A67F6);//Primary Fire
       ProcMem.WriteByte($08, dwOPFORBase^ + $A67F6 + 1);
       ProcMem.WriteByte($74, dwOPFORBase^ + $A6822);//Secondary Fire
       ProcMem.WriteByte($08, dwOPFORBase^ + $A6822 + 1);
     end;
     Result:=True;
  end;
end;

}
end.

