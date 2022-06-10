unit Note.Controller.TextFile;

interface

uses
  System.SysUtils,
  System.Classes,
  Note.Controller.Interfaces;

type
  TTextFileController = class(TInterfacedObject, IFileController<TStrings>)
  private
    FOpenedFile: IFile;
    FReadedContent: TStrings;
    FAppMainTitle: IAppMainTitle;
    FEditor: IEditor<TStrings>;
    procedure OnEditorChangeConsumerEvent(Sender: TObject);
    procedure AquireAndReleaseEncoding(const EncodingName: string; Consumer: TProc<TEncoding>);
    function AppTitle: string;
    procedure UpdateAppMainTitle;
    procedure ReadContentFromFile(Encoding: TEncoding);
  public
    constructor Create(AppMainTitle: IAppMainTitle; Editor: IEditor<TStrings>; const FilePath, EncodingName: string);
    destructor Destroy; override;
    procedure NewFile;
    procedure NewWindow;
    procedure OpenFile(const FilePath, EncodingName: string);
    procedure SaveFile;
    procedure SaveFileAs(const FilePath, EncodingName: string);
    function LastOpenedDir: string;
    function OpenedFile: IFile;
    function HasUnwrittenContent: Boolean;
  end;

implementation

uses
  Note.Controller.Exceptions,
  Note.Controller.FilePath,
  Note.Controller.StringResources,
  Note.Controller.Utils;

{ TTextFileController }

constructor TTextFileController.Create(AppMainTitle: IAppMainTitle; Editor: IEditor<TStrings>;
  const FilePath, EncodingName: string);
begin
  if not Assigned(AppMainTitle) then
    raise EArgumentException.Create('AppMainTitle unassigned');

  if not Assigned(Editor) then
    raise EArgumentException.Create('Editor unassigned');

  FAppMainTitle := AppMainTitle;
  FEditor := Editor;
  FEditor.SetOnChangeConsumer(Self.OnEditorChangeConsumerEvent);

  Self.OpenFile(FilePath, EncodingName);
end;

destructor TTextFileController.Destroy;
begin
  FOpenedFile := nil;
  FReadedContent.Free;
  inherited Destroy;
end;

procedure TTextFileController.NewFile;
begin
  if Self.HasUnwrittenContent then
    raise EUnwrittenContent.Create('File ' + FOpenedFile.Name + ' has unwritten content');
end;

procedure TTextFileController.NewWindow;
begin
  App.Open(0);
end;

procedure TTextFileController.OpenFile(const FilePath, EncodingName: string);
var
  FileName: string;
begin
  if Assigned(FReadedContent) then
    FreeAndNil(FReadedContent);
  FReadedContent := TStringList.Create;

  FOpenedFile := Note.Controller.FilePath.NewFile(FilePath);
  try
    if FOpenedFile.Exists then
      AquireAndReleaseEncoding(EncodingName, ReadContentFromFile);

    FEditor.Content.Assign(FReadedContent);
    Self.UpdateAppMainTitle;
  except
    on E: Exception do
    begin
      FileName := FOpenedFile.FullName;
      Self.OpenFile(TStringResources.DefaultFileName, '');
      raise EUnsuportedFile.Create(TStringResources.UnsuportedFile(FileName));
    end;
  end;
end;

procedure TTextFileController.ReadContentFromFile(Encoding: TEncoding);
begin
  FReadedContent.BeginUpdate;
  FReadedContent.Clear;
  FReadedContent.LoadFromFile(FOpenedFile.Path, Encoding);
  FReadedContent.EndUpdate;
end;

procedure TTextFileController.SaveFile;
begin
  if not FOpenedFile.Exists then
    raise EFileNotFoundException.Create('File not found: ' + FOpenedFile.Path);

  FEditor.Content.SaveToFile(FOpenedFile.Path);
  FReadedContent.Assign(FEditor.Content);
  Self.UpdateAppMainTitle;
end;

procedure TTextFileController.SaveFileAs(const FilePath, EncodingName: string);
begin
  AquireAndReleaseEncoding(EncodingName, procedure(Encoding: TEncoding)
  begin
    FEditor.Content.SaveToFile(FilePath, Encoding);
    FReadedContent.Assign(FEditor.Content);
    FOpenedFile := Note.Controller.FilePath.NewFile(FilePath);
    Self.UpdateAppMainTitle;
  end);
end;

function TTextFileController.LastOpenedDir: string;
begin
  if FOpenedFile.Exists then
    Result := FOpenedFile.Directory.Path
  else
    Result := WindowsUserDesktopFolder;
end;

function TTextFileController.OpenedFile: IFile;
begin
  Result := FOpenedFile;
end;

function TTextFileController.HasUnwrittenContent: Boolean;
begin
  Result := Assigned(FEditor) and not FEditor.Content.Equals(FReadedContent);
end;

function TTextFileController.AppTitle: string;
var
  State: string;
begin
  State := '';
  if Self.HasUnwrittenContent then
    State := '*';

  Result := Format('%s%s - %s', [State, FOpenedFile.FullName, App.Name]);
end;

procedure TTextFileController.OnEditorChangeConsumerEvent(Sender: TObject);
begin
  Self.UpdateAppMainTitle;
end;

procedure TTextFileController.AquireAndReleaseEncoding(const EncodingName: string; Consumer: TProc<TEncoding>);
var
  Encoding: TEncoding;
begin
  try
    Encoding := TEncoding.GetEncoding(EncodingName);
  except
    on E: EEncodingError do
      Encoding := TEncoding.UTF8;
  end;

  try
    Consumer(Encoding);
  finally
    if not TEncoding.IsStandardEncoding(Encoding) then
      FreeAndNil(Encoding);
  end;
end;

procedure TTextFileController.UpdateAppMainTitle;
begin
  FAppMainTitle.SetMainTitle(Self.AppTitle);
end;

end.
