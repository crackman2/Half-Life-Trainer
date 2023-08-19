unit memory_and_process;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Windows, JwaTlHelp32;

type
  TProcMem = class
    procedure WriteFloat(Value: single; Address: DWORD);
    procedure WriteByte(Value: byte; Address: DWORD);
    function ReadByte(Address: DWORD):Byte;
    procedure WriteWord(Value: Word; Address: DWORD);
    function ReadWord(Address: DWORD):Word;
    function ReadFloat(Address: DWORD): single;
    function ReadDword(Address: DWORD): DWORD;
    function GetProcId(ProcName:PChar):DWORD;
    function GetModuleBaseAddress(hProcID: cardinal; lpModName: PChar): Pointer;
  public
    hProcess:HANDLE;
    dwProcessId:DWORD;
  private
  end;

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

function GetModuleBaseAddress(hProcID: cardinal; lpModName: PChar): Pointer;
var
  hSnap: cardinal;
  tm: TModuleEntry32;
begin
  Result := Pointer(0);
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



end.

