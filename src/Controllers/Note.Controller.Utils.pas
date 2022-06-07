unit Note.Controller.Utils;

interface

uses
  Note.Controller.FilePath;

function App: IFile;
function NewGUIID: string;
function NewGUIIDAlphaNumeric: string;

implementation

uses
  Winapi.ActiveX,
  System.SysUtils;

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

initialization
  GApp := NewFile(ParamStr(0));

end.
