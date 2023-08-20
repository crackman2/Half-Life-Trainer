unit CProcMem;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Dialogs, Windows, JwaTlHelp32;

type
  TProcMem = class
    constructor Create(dwProcessId:DWORD);
    procedure WriteFloat(Value: single; Address: DWORD);
    procedure WriteByte(Value: byte; Address: DWORD);
    function ReadByte(Address: DWORD):Byte;
    procedure WriteWord(Value: Word; Address: DWORD);
    function ReadWord(Address: DWORD):Word;
    function ReadFloat(Address: DWORD): single;
    function ReadDword(Address: DWORD): DWORD;
    function GetProcId(ProcName:PChar):DWORD;
    function GetModuleBaseAddress(hProcID: cardinal; lpModName: PChar): Pointer;
    function InjectDll(FullPath:String): Boolean;
    function IsDllLoadedInProcess(const DllName: string): Boolean;
    function ChangePageProtection(Address:DWORD; Size:DWORD; Protection:DWORD): Boolean;
  public
    hProcess:HANDLE;
    dwProcessId:DWORD;
  private
  end;

implementation

constructor TProcMem.Create(dwProcessId:DWORD);
begin
  Self.dwProcessId:=dwProcessId;
  Self.hProcess:=OpenProcess(PROCESS_ALL_ACCESS,False,dwProcessId);
end;

procedure TProcMem.WriteFloat(Value: single; Address: DWORD);
begin
  WriteProcessMemory(hProcess, Pointer(Address), @Value, sizeof(Value), nil);
end;

procedure TProcMem.WriteByte(Value: byte; Address: DWORD);
begin
  if (WriteProcessMemory(hProcess, Pointer(Address), @Value, sizeof(Value), nil) <> False) then begin
    ShowMessage('WriteByte failure: Address' + IntToHex(Address,8));
  end;
end;

function TProcMem.ReadByte(Address: DWORD):Byte;
begin
  ReadProcessMemory(hProcess, Pointer(Address), @Result, sizeof(Result), nil);
end;

procedure TProcMem.WriteWord(Value: Word; Address: DWORD);
begin
  WriteProcessMemory(hProcess, Pointer(Address), @Value, sizeof(Value), nil);
end;

function TProcMem.ReadWord(Address: DWORD):Word;
begin
  ReadProcessMemory(hProcess, Pointer(Address), @Result, sizeof(Result), nil);
end;

function TProcMem.ReadFloat(Address: DWORD): single;
begin
  ReadProcessMemory(hProcess, Pointer(Address), @Result, sizeof(Result), nil);
end;

function TProcMem.ReadDword(Address: DWORD): DWORD;
begin
  ReadProcessMemory(hProcess, Pointer(Address), @Result, sizeof(Result), nil);
end;


function TProcMem.GetProcId(ProcName:PChar):DWORD;
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

function TProcMem.GetModuleBaseAddress(hProcID: cardinal; lpModName: PChar): Pointer;
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


function TProcMem.InjectDll(FullPath:String): Boolean;
var
  remoteThread: THandle;
  hModule: Pointer;
  bytesWritten: SIZE_T = SIZE_T(0);
begin
  Result := False;

  // Open the target process with appropriate access rights
  //hProcess := OpenProcess(PROCESS_ALL_ACCESS, False, ProcessID);
  if Self.hProcess = 0 then
  begin
    ShowMessage('Failed to open the target process: ' + SysErrorMessage(GetLastError));
    Exit;
  end;

  try
    // Get the path to the DLL
    //FullPath := GetCurrentDir + '\HLpMod.dll';

    // Allocate memory in the target process for the DLL path
    hModule := VirtualAllocEx(Self.hProcess, nil, Length(FullPath) + 1, MEM_COMMIT, PAGE_READWRITE);
    if hModule = nil then
    begin
      ShowMessage('VirtualAllocEx failed. Is the game even running?: ' + SysErrorMessage(GetLastError));
      Exit;
    end;

    try
      // Write the DLL path to the target process
      if not WriteProcessMemory(Self.hProcess, hModule, PChar(FullPath), Length(FullPath) + 1, bytesWritten) then
      begin
        ShowMessage('WriteProcessMemory failed: ' + SysErrorMessage(GetLastError));
        Exit;
      end;

      // Create a remote thread to load the DLL into the target process
      remoteThread := CreateRemoteThread(Self.hProcess, nil, 0, GetProcAddress(GetModuleHandle('kernel32.dll'), 'LoadLibraryA'), hModule, 0, bytesWritten);
      if remoteThread = 0 then
      begin
        ShowMessage('CreateRemoteThread failed: ' + SysErrorMessage(GetLastError));
        Exit;
      end;

      WaitForSingleObject(remoteThread, INFINITE);

      Result := True;

    finally
      VirtualFreeEx(Self.hProcess, hModule, 0, MEM_RELEASE);
    end;

  finally
    //CloseHandle(hProcess);
  end;
end;


function TProcMem.IsDllLoadedInProcess(const DllName: string): Boolean;
var
  hSnapshot: THandle;
  me32: TModuleEntry32;
begin
  Result := False;

  hSnapshot := CreateToolhelp32Snapshot(TH32CS_SNAPMODULE, Self.dwProcessId);
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


function TProcMem.ChangePageProtection(Address:DWORD; Size:DWORD; Protection:DWORD): Boolean;
var
  Trash:PDWORD;
begin
     Result:= VirtualProtectEx(hProcess,Pointer(Address),Size, Protection,Trash);
end;



end.

