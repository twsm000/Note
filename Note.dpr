program Note;

uses
  Vcl.Forms,
  Vcl.Themes,
  Vcl.Styles,
  Note.View.Main in 'src\Views\Note.View.Main.pas' {MainView},
  Note.View.Forms in 'src\Views\Note.View.Forms.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainView, MainView);
  TStyleManager.TrySetStyle('Windows10');
  Application.Run;
end.
