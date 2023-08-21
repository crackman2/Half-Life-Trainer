unit Cgame;

{$mode ObjFPC}{$H+}



interface

uses
  Classes, SysUtils, Dialogs, Windows,

  { custom }
  CProcMem;
type
  Tgame = class
    constructor Create(g_ProcMem:TProcMem; dwModuleBase:PDWORD);
    function EnableInfiniteAmmo(State:Boolean): Boolean;
    function EnableRapidFire(State:Boolean): Boolean;
    public
      ProcMem:TProcMem;
      dwModuleBase:PDWORD;
    protected
      { --- is defined in subclass --- }
      procedure InitializeOpCodes; virtual; abstract;
  end;

var
  { --- is defined in subclass --- }
  OpCodeInfAmmo: array of array of LongWord;
  OpCodeRapidFire: array of array of LongWord;


implementation

constructor Tgame.Create(g_ProcMem:TProcMem; dwModuleBase:PDWORD);
begin
  Self.dwModuleBase:=dwModuleBase;
  Self.ProcMem:=g_ProcMem;
  InitializeOpCodes();
end;

function Tgame.EnableInfiniteAmmo(State:Boolean): Boolean;
var
  i:Cardinal=0;
  ii:Cardinal=0;
begin
  Result:=False;
  if Assigned(ProcMem) and (dwModuleBase^ > 0) then begin
    if State then begin

      for i := 0 to High(OpCodeInfAmmo) do begin
        for ii:=1 to High(OpCodeInfAmmo[i]) do begin
          ProcMem.WriteByte($90, dwModuleBase^ + OpCodeInfAmmo[i,0] + ii - 1);
        end;
      end;

    end
    else begin

      for i := 0 to High(OpCodeInfAmmo) do begin
        for ii:=1 to High(OpCodeInfAmmo[i]) do begin
          ProcMem.WriteByte(OpCodeInfAmmo[i,ii], dwModuleBase^ + OpCodeInfAmmo[i,0] + ii - 1);
        end;
      end;

    end;
    Result:=True;
  end;
end;



function Tgame.EnableRapidFire(State:Boolean): Boolean;
var
  i:Cardinal=0;
  ii:Cardinal=0;
begin
  Result:=False;
  if Assigned(ProcMem) and (dwModuleBase^ > 0) then begin
     if State then begin

       for i := 0 to High(OpCodeRapidFire) do begin
         for ii:=1 to High(OpCodeRapidFire[i]) do begin
           ProcMem.WriteByte($90, dwModuleBase^ + OpCodeRapidFire[i,0] + ii-1);
         end;
       end;

     end else begin

       for i := 0 to High(OpCodeRapidFire) do begin
         for ii:=1 to High(OpCodeRapidFire[i]) do begin
           ProcMem.WriteByte(OpCodeRapidFire[i,ii], dwModuleBase^ + OpCodeRapidFire[i,0] + ii-1);
         end;
       end;

     end;
     Result:=True;
  end;
end;



end.



