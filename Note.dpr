program Note;

uses
  System.SysUtils,
  Vcl.Forms,
  Vcl.Themes,
  Vcl.Styles,
  Note.View.Main in 'src\Views\Note.View.Main.pas' {MainView},
  Note.View.Forms in 'src\Views\Note.View.Forms.pas',
  Note.View.Utils in 'src\Views\Note.View.Utils.pas',
  Note.View.StringResources in 'src\Views\Note.View.StringResources.pas',
  Note.Controller.Exceptions in 'src\Controllers\Note.Controller.Exceptions.pas',
  Note.Controller.FilePath in 'src\Controllers\Note.Controller.FilePath.pas',
  Note.Controller.Interfaces in 'src\Controllers\Note.Controller.Interfaces.pas',
  Note.Controller.Utils in 'src\Controllers\Note.Controller.Utils.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  ReportMemoryLeaksOnShutdown := True;
  Application.CreateForm(TMainView, MainView);
  MainView.FileController := nil;
  Application.OnException := MainView.ExceptionHandler;
  Application.Run;
end.

