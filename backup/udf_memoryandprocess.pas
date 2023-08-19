unit UDF_MemoryAndProcess;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils;

implementation

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


end.

