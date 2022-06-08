program Note;

uses
  Vcl.Forms,
  Vcl.Themes,
  Vcl.Styles,
  Note.View.Main in 'src\Views\Note.View.Main.pas' {MainView},
  Note.View.Forms in 'src\Views\Note.View.Forms.pas',
  Note.View.Utils in 'src\Views\Note.View.Utils.pas',
  Note.View.StringResources in 'src\Views\Note.View.StringResources.pas',
  Note.Controller.Utils in 'src\Controllers\Note.Controller.Utils.pas',
  Note.Controller.FilePath in 'src\Controllers\Note.Controller.FilePath.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainView, MainView);
  TStyleManager.TrySetStyle('Windows10');
  Application.Run;
end.


