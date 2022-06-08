unit Note.View.Utils;

interface

uses
  System.UITypes,
  Vcl.ExtDlgs,
  Vcl.Forms,
  Vcl.Menus,
  Winapi.Windows;

type
  TPopUpHelper = class
  public
    class procedure Display(View: TForm; Menu: TPopUpMenu; const X, Y: Integer);
  end;

  TAlertHelper = class
  private
    class function MessageBoxExtension(AMessage: string; ACaption: string; Flags: Integer = 0): Integer;
  public
    class function MessageConfirmation(AMessage: string; ACaption: string = ''): Boolean;
    class function MessageConfirmationCancelation(AMessage: string; ACaption: string = ''): Boolean;
    class procedure MessageError(AMessage: string; ACaption: string = 'Atenção!');
    class procedure MessageInformation(AMessage: string; ACaption: string = '');
    class procedure MessageWarning(AMessage: string; ACaption: string = 'Aviso!');
    class procedure MessageDebug(AMessage: string);
  end;

  TDialogHelper = class
  public
    class function OpenTextFile(const InitialDir: string): string;
    class function SaveTextFile(const InitialDir, FileName: string): string;
  end;

implementation

uses
  System.SysUtils,
  Note.View.StringResources;

const
  MB_CONFIRMATION = MB_ICONQUESTION + MB_YESNO;
  MB_CONFIRMATION_CANCEL = MB_ICONQUESTION + MB_YESNOCANCEL;

  { TPopUpHelper }

class procedure TPopUpHelper.Display(View: TForm; Menu: TPopUpMenu; const X, Y: Integer);
var
  ClientCoord: TPoint;
  ScreenCoord: TPoint;
begin
  ClientCoord.X := X;
  ClientCoord.Y := Y;
  ScreenCoord := View.ClientToScreen(ClientCoord);
  Menu.Popup(ScreenCoord.X, ScreenCoord.Y);
end;

{ TAlert }

class function TAlertHelper.MessageBoxExtension(AMessage, ACaption: string; Flags: Integer): Integer;
begin
  Result := Application.MessageBox(PWideChar(AMessage), PWideChar(ACaption), Flags);
end;

class function TAlertHelper.MessageConfirmation(AMessage, ACaption: string): Boolean;
begin
  Result := Self.MessageBoxExtension(AMessage, ACaption, MB_CONFIRMATION) = ID_YES;
end;

class function TAlertHelper.MessageConfirmationCancelation(AMessage, ACaption: string): Boolean;
var
  Output: Integer;
begin
  Result := False;
  Output := Self.MessageBoxExtension(AMessage, ACaption, MB_CONFIRMATION_CANCEL);
  case Output of
    ID_YES:
      Result := True;
    ID_CANCEL:
      Abort;
  end;
end;

class procedure TAlertHelper.MessageDebug(AMessage: string);
begin
  OutputDebugString(PWideChar(AMessage));
end;

class procedure TAlertHelper.MessageError(AMessage, ACaption: string);
begin
  Self.MessageBoxExtension(AMessage, ACaption, MB_ICONERROR);
end;

class procedure TAlertHelper.MessageInformation(AMessage, ACaption: string);
begin
  Self.MessageBoxExtension(AMessage, ACaption, MB_ICONINFORMATION);
end;

class procedure TAlertHelper.MessageWarning(AMessage, ACaption: string);
begin
  Self.MessageBoxExtension(AMessage, ACaption, MB_ICONWARNING);
end;

{ TOpenDialogHelper }

class function TDialogHelper.OpenTextFile(const InitialDir: string): string;
var
  FileDialog: TOpenTextFileDialog;
begin
  FileDialog := TOpenTextFileDialog.Create(Application);
  try
    FileDialog.Title := TStringResources.OpenFileTitle;
    FileDialog.Filter := 'Text file | *.txt';
    FileDialog.InitialDir := InitialDir;
    FileDialog.Options := [TOpenOption.ofOverwritePrompt, TOpenOption.ofPathMustExist,
      TOpenOption.ofFileMustExist];

    if not FileDialog.Execute then
      Abort;
    Result := FileDialog.FileName;
  finally
    FileDialog.Free;
  end;
end;

class function TDialogHelper.SaveTextFile(const InitialDir, FileName: string): string;
var
  FileDialog: TSaveTextFileDialog;
begin
  FileDialog := TSaveTextFileDialog.Create(Application);
  try
    FileDialog.Title := TStringResources.SaveFileAsTitle;
    FileDialog.Filter := 'Text file | *.txt';
    FileDialog.InitialDir := InitialDir;
    FileDialog.FileName := FileName;
    FileDialog.Options := [TOpenOption.ofOverwritePrompt, TOpenOption.ofPathMustExist];

    if not FileDialog.Execute then
      Abort;
    Result := FileDialog.FileName;
  finally
    FileDialog.Free;
  end;
end;

end.
