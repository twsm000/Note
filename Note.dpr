program Note;

uses
  System.SysUtils,
  Vcl.Forms,
  Vcl.Themes,
  Vcl.Styles,
  Note.View.Main in 'src\Views\Note.View.Main.pas' {MainView},
  Note.View.Controls in 'src\Views\Note.View.Controls.pas',
  Note.View.Utils in 'src\Views\Note.View.Utils.pas',
  Note.Controller.StringResources in 'src\Controllers\Note.Controller.StringResources.pas',
  Note.Controller.Exceptions in 'src\Controllers\Note.Controller.Exceptions.pas',
  Note.Controller.FilePath in 'src\Controllers\Note.Controller.FilePath.pas',
  Note.Controller.Interfaces in 'src\Controllers\Note.Controller.Interfaces.pas',
  Note.Controller.Utils in 'src\Controllers\Note.Controller.Utils.pas',
  Note.Controller.TextFile in 'src\Controllers\Note.Controller.TextFile.pas',
  Note.View.IniFile in 'src\Views\Note.View.IniFile.pas';

{$R *.res}

var
  FilePath: string;

begin
  try
    Application.Initialize;
    Application.MainFormOnTaskbar := True;
    ReportMemoryLeaksOnShutdown := True;
    Application.CreateForm(TMainView, MainView);
  Application.OnException := MainView.ExceptionHandler;
    FilePath := ParamStr(1);
    if FilePath = '' then
      FilePath := TStringResources.DefaultFileName;
    MainView.FileController := TTextFileController.Create(MainView, MainView.Editor, FilePath, '');
    Application.Run;
  except
    on E: Exception do
      TAlertHelper.MessageError(E.Message);
  end;
end.
