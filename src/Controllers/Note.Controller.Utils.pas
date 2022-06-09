unit Note.Controller.Utils;

interface

uses
  Note.Controller.Interfaces;

function App: IFile;
function NewGUIID: string;
function NewGUIIDAlphaNumeric: string;

function WindowsUserName: string;
function WindowsUserFolder: string;
function WindowsUserDesktopFolder: string;

implementation

uses
  Winapi.ActiveX,
  Winapi.Windows,
  System.SysUtils,
  Note.Controller.FilePath;

var
  GApp: IFile;

function App: IFile;
begin
  Result := GApp;
end;

function NewGUIID: string;
var
  GUIID: TGUID;
begin
  CoCreateGuid(GUIID);
  Result := GUIDToString(GUIID);
end;

function NewGUIIDAlphaNumeric: string;
begin
  Result := StringReplace(NewGUIID, '-', EmptyStr, [rfReplaceAll]);
  Result := StringReplace(Result, '{', EmptyStr, [rfReplaceAll]);
  Result := StringReplace(Result, '}', EmptyStr, [rfReplaceAll]);
end;

function WindowsUserName: string;
var
  NewLength: Cardinal;
begin
  NewLength := 255;
  SetLength(Result, NewLength);
  GetUserName(PWideChar(Result), NewLength);
  Result := string(PWideChar(Result));
end;

function WindowsUserFolder: string;
const
  USER_PROFILE = 'USERPROFILE';
var
  BufSize: Integer;
begin
  Result := EmptyStr;

  BufSize := Winapi.Windows.GetEnvironmentVariable(PWideChar(USER_PROFILE), nil, 0);
  if BufSize > 0 then
  begin
    Finalize(Result);
    SetLength(Result, BufSize - 1);
    Winapi.Windows.GetEnvironmentVariable(PWideChar(USER_PROFILE), PChar(Result), BufSize);

    Result := IncludeTrailingPathDelimiter(Result);
  end;
end;

function WindowsUserDesktopFolder: string;
begin
  Result := IncludeTrailingPathDelimiter(WindowsUserFolder + 'Desktop');
end;

initialization
  GApp := NewFile(ParamStr(0));

end.
