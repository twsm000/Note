unit Note.View.Forms;

interface

uses
  Vcl.Forms,
  Vcl.Controls,
  System.Classes,
  System.Generics.Collections,
  System.SysUtils,
  Winapi.Windows;

type
  TForm = class(Vcl.Forms.TForm)
  private
    FOnKeyDownMap: TDictionary<Word, TKeyEvent>;
    procedure OnKeyDownExecute(Sender: TObject; var Key: Word; Shift: TShiftState);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure AddOnKeyDownEvent(const Key: Word; Event: TKeyEvent);
  end;

implementation

{ TForm }

constructor TForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Self.KeyPreview := True;
  Self.OnKeyDown := Self.OnKeyDownExecute;
  Self.Position := poScreenCenter;
  Self.Font.Name := 'Verdana';
  Self.Font.Size := 10;

  FOnKeyDownMap := TDictionary<Word, TKeyEvent>.Create;
end;

destructor TForm.Destroy;
begin
  FOnKeyDownMap.Free;
  inherited Destroy;
end;

procedure TForm.OnKeyDownExecute(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  Event: TKeyEvent;
begin
  if FOnKeyDownMap.TryGetValue(Key, Event) then
    Event(Sender, Key, Shift);
end;

procedure TForm.AddOnKeyDownEvent(const Key: Word; Event: TKeyEvent);
begin
  FOnKeyDownMap.AddOrSetValue(Key, Event);
end;

end.
