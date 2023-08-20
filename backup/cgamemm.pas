unit CgameMM;

{$mode ObjFPC}{$H+}

{ --------------------------------- gameMM --------------------------------- }
{ -> contains functions for infinite ammo and rapidfire for Half-Life: MMod  }


interface

uses
  Classes, SysUtils, Dialogs, Windows,

  { custom }
  Cgame, CProcMem;
type
  TgameMM = class (Tgame)
    function EnableCustomRapidfire(State:Boolean): Boolean;
    function EnableCustomInfAmmo(State:Boolean): Boolean;
    private
      procedure SplitAndReverse(DWORDValue: LongWord; var ByteArray: array of Byte);
    protected
      procedure InitializeOpCodes; override;
  end;

const
  DataSMGRapidFire: array [0..1] of array of LongWord =    //SMG Grenades
  (
    ($79B4D, $F3, $0F, $10, $2D, $A8, $62, $D8, $5D), //Original
    ($79B4D, $F3, $0F, $10, $2D, $11, $00, $61, $68)  //Modified
  );

  DataPistolPrimaryRapidFire: array [0..1] of array of LongWord =
  (
    ($CFDCD, $0F, $84, $99, $00, $00, $00),  //Original

    ($CFDCD, $90, $90, $90, $90, $90, $90)  //Modified
  );

  DataSatchelSecondaryRapidFire: array [0..1] of array of LongWord =
  (
    ($CE0E7, $74, $53),  //Original

    ($CE0E7, $90, $90)  //Modified
  );

  DataHornetClientInfAmmo: array [0..1] of array of LongWord =
  (
    ($3514, $89, $04, $8D, $10, $B9, $6E, $6C),  //Original
    ($3514, $90, $90, $90, $90, $90, $90, $90)   //Modified
  );


implementation

procedure TgameMM.InitializeOpCodes;
var
  FOpCodeInfAmmo: array[0..17] of array of LongWord =
  (
    ($CFF60, $48),                                    //Pistol 9mm
    ($9CCEB, $FF, $8F, $A0, $00, $00, $00),           //Magnum
    ($79452, $FF, $8E, $A0, $00, $00, $00),           //SMG
    ($79959, $FF, $8C, $88, $04, $05, $00, $00),      //SMG Grenade
    ($AA1B0, $FF, $8E, $A0, $00, $00, $00),           //Shotgun
    ($AA6BF, $83, $86, $A0, $00, $00, $00, $FE),      //Shotgun secondary
    ($2B38A, $FF, $8F, $A0, $00, $00, $00),           //Crossbow
    ($A052A, $FF, $8E, $A0, $00, $00, $00),           //RPG
    ($4DB8D, $83, $84, $88, $04, $05, $00, $00, $FE), //Gauss
    ($4DDCB, $FF, $8C, $88, $04, $05, $00, $00),      //Gauss secondary 1
    ($4DF26, $FF, $8C, $8A, $04, $05, $00, $00),      //Gauss secondary 2
    ($3D166, $89, $88, $04, $05, $00, $00),           //Egon
    ($93DA0, $89, $43, $3C),                          //Hornet
    ($2FEE0, $83, $84, $90, $04, $05, $00, $00, $F6), //BFG
    ($55512, $FF, $8C, $88, $04, $05, $00, $00),      //Grenades
    ($A19E2, $FF, $8C, $88, $04, $05, $00, $00),      //Satchels
    ($BE578, $FF, $8C, $88, $04, $05, $00, $00),      //Tripmines
    ($B15B8, $FF, $8C, $88, $04, $05, $00, $00)       //Snarks
  );

  FOpCodeRapidFire: array [0..0] of array of LongWord =
  (
   ($CE1B9,$74,$59)
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


function TgameMM.EnableCustomRapidfire(State:Boolean): Boolean;
var
  i:Cardinal;
  dwTempBase:DWORD=0;
  dwModuleBytes:array [0..3] of Byte = (0,0,0,0);
begin
  Result:=False;
  if Assigned(ProcMem) and (dwModuleBase^ > 0) then begin
      dwTempBase:=dwModuleBase^;



      if State then begin
        { ---- SMG Grenades ON ---- }
        dwTempBase+=$11; //hl.dll + 0x11 -> points to a location that has the value 0.0f
        SplitAndReverse(dwTempBase,dwModuleBytes);

        for i:=0 to High(dwModuleBytes) do begin
          DataSMGRapidFire[1,5 + i]:=LongWord(dwModuleBytes[i]);
        end;

        for i:=0 to High(DataSMGRapidFire[1])-1 do begin
          ProcMem.WriteByte(DataSMGRapidFire[1,1 + i] , dwModuleBase^ + DataSMGRapidFire[1,0] + i);
        end;


        { ---- Pistol Primary ON ---- }
        for i:=0 to High(DataPistolPrimaryRapidFire[1])-1 do begin
          ProcMem.WriteByte(DataPistolPrimaryRapidFire[1,1 + i] , dwModuleBase^ + DataPistolPrimaryRapidFire[1,0] + i);
        end;

        { ---- Satchel Secondary ON ---- }
        for i:=0 to High(DataSatchelSecondaryRapidFire[1])-1 do begin
          ProcMem.WriteByte(DataSatchelSecondaryRapidFire[1,1 + i] , dwModuleBase^ + DataSatchelSecondaryRapidFire[1,0] + i);
        end;



      end else begin
        { ---- SMG Grenades OFF --- }   +
        dwTempBase+=$1262A8; //hl.dll + 0x1262A8 -> points to a location that has the original value
        SplitAndReverse(dwTempBase,dwModuleBytes);

        for i:=0 to High(dwModuleBytes) do begin
          DataSMGRapidFire[0,5 + i]:=LongWord(dwModuleBytes[i]);
        end;

         for i:=0 to High(DataSMGRapidFire[0])-1 do begin
          ProcMem.WriteByte(DataSMGRapidFire[0,1 + i],  dwModuleBase^ + DataSMGRapidFire[0,0] + i);
        end;


        { ---- Pistol Primary OFF ---- }
        for i:=0 to High(DataPistolPrimaryRapidFire[0])-1 do begin
          ProcMem.WriteByte(DataPistolPrimaryRapidFire[0,1 + i] , dwModuleBase^ + DataPistolPrimaryRapidFire[0,0] + i);
        end;

        { ---- Satchel Secondary OFF ---- }
        for i:=0 to High(DataSatchelSecondaryRapidFire[0])-1 do begin
          ProcMem.WriteByte(DataSatchelSecondaryRapidFire[0,1 + i] , dwModuleBase^ + DataSatchelSecondaryRapidFire[0,0] + i);
        end;

      end;
      Result:=True;
  end;
end;


function TgameMM.EnableCustomInfAmmo(State:Boolean): Boolean;
var
  dwClientBase:DWORD=0;
begin
  Result:=False;
  if Assigned(ProcMem) then begin
    dwClientBase:=DWORD(ProcMem.GetModuleBaseAddress(ProcMem.dwProcessId,'client.dll'));
    if dwClientBase <> 0 then begin
      if State then begin
        for i:=0 to High(DataHornetClientInfAmmo[1])-1 do begin
          ProcMem.WriteByte(DataHornetClientInfAmmo[1,1 + i] , dwClientBase + DataHornetClientInfAmmo[1,0] + i);
        end;
        Result:=True;
      end else begin
        for i:=0 to High(DataHornetClientInfAmmo[0])-1 do begin
          ProcMem.WriteByte(DataHornetClientInfAmmo[0,1 + i] , dwClientBase + DataHornetClientInfAmmo[0,0] + i);
        end;
        Result:=True;
      end;
    end;
  end;
end;

procedure TgameMM.SplitAndReverse(DWORDValue: LongWord; var ByteArray: array of Byte);
var
  i: Integer;
begin
  for i := 0 to Length(ByteArray) - 1 do
  begin
    ByteArray[i] := DWORDValue and $FF;
    DWORDValue := DWORDValue shr 8;
  end;
end;






end.




{

    { ---------------------------- Infinite Ammo --------------------------- }
    hl.dll+CFF60 - 48                    - dec eax                                //Pistol 9mm
    hl.dll+9CCEB - FF 8F A0000000        - dec [edi+000000A0]                     //Magnum
    hl.dll+79452 - FF 8E A0000000        - dec [esi+000000A0]                     //SMG
    hl.dll+79959 - FF 8C 88 04050000     - dec [eax+ecx*4+00000504]               //SMG Grenade
    hl.dll+AA1B0 - FF 8E A0000000        - dec [esi+000000A0]                     //Shotgun
    hl.dll+AA6BF - 83 86 A0000000 FE     - add dword ptr [esi+000000A0],-02       //Shotgun secondary
    hl.dll+2B38A - FF 8F A0000000        - dec [edi+000000A0]                     //Crossbow
    hl.dll+A052A - FF 8E A0000000        - dec [esi+000000A0]                     //RPG
    hl.dll+4DB8D - 83 84 88 04050000 FE  - add dword ptr [eax+ecx*4+00000504],-02 //Gauss
    hl.dll+4DDCB - FF 8C 88 04050000     - dec [eax+ecx*4+00000504]               //Gauss secondary 1
    hl.dll+4DF26 - FF 8C 8A 04050000     - dec [edx+ecx*4+00000504]               //Gauss secondary 2
    hl.dll+3D166 - 89 88 04050000        - mov [eax+00000504],ecx                 //Egon
    hl.dll+93DA0 - 89 43 3C              - mov [ebx+3C],eax                       //Hornet
    client.dll+3514 - 89 04 8D 10B96E6C     - mov [ecx*4+client.dll+10B910],eax   //Hornet (otherwise bugs happen)

    hl.dll+2FEE0 - 83 84 90 04050000 F6  - add dword ptr [eax+edx*4+00000504],-0A //BFG
    hl.dll+55512 - FF 8C 88 04050000     - dec [eax+ecx*4+00000504]               //Grenades
    hl.dll+A19E2 - FF 8C 88 04050000     - dec [eax+ecx*4+00000504]               //Satchels
    hl.dll+BE578 - FF 8C 88 04050000     - dec [eax+ecx*4+00000504]               //Tripmines
    hl.dll+B15B8 - FF 8C 88 04050000     - dec [eax+ecx*4+00000504]               //Snarks


    { ------------------------------ Rapidfire ----------------------------- }

    { ---------- General --------- }
    { -> most but not all guns }
    hl.dll+CE1B9 - 74 59                 - je hl.dll.text+CD214

    { -------- SMG Grenade ------- }
    hl.dll+79B4D - F3 0F10 2D A862D85D   - movss xmm5,[hl.dll+1262A8]   <--- hl.dll+1262A8 default value is 1.97. it must be overwritten with 0.0 in order to enable rapidfire
    hl.dll+79B4D - F3 0F10 2D 11006168   - movss xmm5,[hl.dll+11]       <--- let it point to the value zero

    { ---- Pistol 9mm primary ---- }
    hl.dll+CFDCD - 0F84 99000000         - je hl.dll+CFE6C

    { ---- Satchel secondary ---- }
    hl.dll+CE0E7 - 74 53                 - je hl.dll+CE13C





}

