unit Note.View.IniFile;

interface

uses
  Vcl.Forms,
  System.IniFiles,
  System.SysUtils,
  Note.Controller.Interfaces;

type
  ICommand = interface
    ['{5CE129A2-1CE8-4857-869B-EAB2C063DE52}']
    procedure Execute;
  end;

  IIniFile = interface
    ['{66F6AC81-9511-4705-A427-A281B2118B4F}']
    function OnReadFile(Event: TProc<TMemIniFile>): IIniFile;
    function OnReadFileNotExists(Event: TProc<TMemIniFile>): IIniFile;
    function OnWriteFile(Event: TProc<TMemIniFile>): IIniFile;
    procedure Read;
    procedure Write;
  end;

function NewIniFile(AFile: IFile): IIniFile;
function NewIniFormFile(AFile: IFile; AForm: TForm): IIniFile;

implementation

uses
  Note.Controller.FilePath;

type
  TIniFile = class(TInterfacedObject, IIniFile)
  private
    FFile: IFile;
    FOnReadFile: TProc<TMemIniFile>;
    FOnReadFileNotExists: TProc<TMemIniFile>;
    FOnWriteFile: TProc<TMemIniFile>;
  protected
    property &File: IFile read FFile;
    procedure OnReadFileExecute(Ini: TMemIniFile); virtual;
    procedure OnReadFileNotExistsExecute(Ini: TMemIniFile); virtual;
    procedure OnWriteFileExecute(Ini: TMemIniFile); virtual;
  public
    constructor Create(AFile: IFile);
    destructor Destroy; override;
    class function New(AFile: IFile): IIniFile;
    function OnReadFile(Event: TProc<TMemIniFile>): IIniFile;
    function OnReadFileNotExists(Event: TProc<TMemIniFile>): IIniFile;
    function OnWriteFile(Event: TProc<TMemIniFile>): IIniFile;
    procedure Read;
    procedure Write;
  end;

  TIniFileReadCommand = class(TInterfacedObject, ICommand)
  private
    FIniForm: TIniFile;
  public
    constructor Create(IniFileForm: TIniFile);
    destructor Destroy; override;
    class function New(IniFileForm: TIniFile): ICommand;
    procedure Execute;
  end;

  TIniFileWriteCommand = class(TInterfacedObject, ICommand)
  private
    FIniForm: TIniFile;
  public
    constructor Create(IniFileForm: TIniFile);
    destructor Destroy; override;
    class function New(IniFileForm: TIniFile): ICommand;
    procedure Execute;
  end;

  TIniFileForm = class(TIniFile, IIniFile)
  private
    FForm: TForm;
  protected
    procedure OnReadFileExecute(Ini: TMemIniFile); override;
    procedure OnReadFileNotExistsExecute(Ini: TMemIniFile); override;
    procedure OnWriteFileExecute(Ini: TMemIniFile); override;
  public
    constructor Create(AFile: IFile; Form: TForm); reintroduce;
    destructor Destroy; override;
    class function New(AFile: IFile; Form: TForm): IIniFile;
  end;

function NewIniFile(AFile: IFile): IIniFile;
begin
  Result := TIniFile.New(AFile);
end;

function NewIniFormFile(AFile: IFile; AForm: TForm): IIniFile;
begin
  Result := TIniFileForm.New(AFile, AForm);
end;

{ TIniFile }

constructor TIniFile.Create(AFile: IFile);
begin
  FFile := AFile;
end;

destructor TIniFile.Destroy;
begin
  inherited;
end;

class function TIniFile.New(AFile: IFile): IIniFile;
begin
  Result := Self.Create(AFile);
end;

function TIniFile.OnReadFile(Event: TProc<TMemIniFile>): IIniFile;
begin
  Result := Self;
  FOnReadFile := Event;
end;

function TIniFile.OnWriteFile(Event: TProc<TMemIniFile>): IIniFile;
begin
  Result := Self;
  FOnWriteFile := Event;
end;

procedure TIniFile.OnReadFileExecute(Ini: TMemIniFile);
begin
  if Assigned(FOnReadFile) then
    FOnReadFile(Ini);
end;

function TIniFile.OnReadFileNotExists(Event: TProc<TMemIniFile>): IIniFile;
begin
  Result := Self;
  FOnReadFileNotExists := Event;
end;

procedure TIniFile.OnReadFileNotExistsExecute(Ini: TMemIniFile);
begin
  if Assigned(FOnReadFileNotExists) then
    FOnReadFileNotExists(Ini);
end;

procedure TIniFile.OnWriteFileExecute(Ini: TMemIniFile);
begin
  if Assigned(FOnWriteFile) then
    FOnWriteFile(Ini);
end;

procedure TIniFile.Read;
begin
  TIniFileReadCommand.New(Self).Execute;
end;

procedure TIniFile.Write;
begin
  TIniFileWriteCommand.New(Self).Execute;
end;

{ TIniFileReadCommand }

constructor TIniFileReadCommand.Create(IniFileForm: TIniFile);
begin
  FIniForm := IniFileForm;
end;

destructor TIniFileReadCommand.Destroy;
begin
  inherited Destroy;
end;

class function TIniFileReadCommand.New(IniFileForm: TIniFile): ICommand;
begin
  Result := Self.Create(IniFileForm);
end;

procedure TIniFileReadCommand.Execute;
var
  MemIni: TMemIniFile;
begin
  MemIni := TMemIniFile.Create(FIniForm.&File.Path);
  try
    if FIniForm.&File.Exists then
      FIniForm.OnReadFileExecute(MemIni)
    else
      FIniForm.OnReadFileNotExistsExecute(MemIni);
  finally
    MemIni.Free;
  end;
end;

{ TIniFileWriteCommand }

constructor TIniFileWriteCommand.Create(IniFileForm: TIniFile);
begin
  FIniForm := IniFileForm;
end;

destructor TIniFileWriteCommand.Destroy;
begin
  inherited Destroy;
end;

class function TIniFileWriteCommand.New(IniFileForm: TIniFile): ICommand;
begin
  Result := Self.Create(IniFileForm);
end;

procedure TIniFileWriteCommand.Execute;
var
  MemIni: TMemIniFile;
begin
  MemIni := TMemIniFile.Create(FIniForm.&File.Path);
  try
    FIniForm.OnWriteFileExecute(MemIni);
    MemIni.UpdateFile;
  finally
    MemIni.Free;
  end;
end;

{ TIniFileForm }

constructor TIniFileForm.Create(AFile: IFile; Form: TForm);
begin
  inherited Create(AFile);
  FForm := Form;
end;

destructor TIniFileForm.Destroy;
begin
  inherited;
end;

class function TIniFileForm.New(AFile: IFile; Form: TForm): IIniFile;
begin
  Result := Self.Create(AFile, Form);
end;

procedure TIniFileForm.OnReadFileExecute(Ini: TMemIniFile);
begin
  if Ini.SectionExists(FForm.Name) then
  begin
    FForm.Position := poDesigned;
    FForm.Height := Ini.ReadInteger(FForm.Name, 'Height', FForm.Height);
    FForm.Width := Ini.ReadInteger(FForm.Name, 'Width', FForm.Width);
    FForm.Left := Ini.ReadInteger(FForm.Name, 'Left', FForm.Left);
    FForm.Top := Ini.ReadInteger(FForm.Name, 'Top', FForm.Top);
  end
  else
    FForm.Position := poScreenCenter;

  inherited OnReadFileExecute(Ini);
end;

procedure TIniFileForm.OnReadFileNotExistsExecute(Ini: TMemIniFile);
begin
  FForm.Position := poScreenCenter;
  inherited OnReadFileNotExistsExecute(Ini);
end;

procedure TIniFileForm.OnWriteFileExecute(Ini: TMemIniFile);
begin
  Ini.WriteInteger(FForm.Name, 'Height', FForm.Height);
  Ini.WriteInteger(FForm.Name, 'Width', FForm.Width);
  Ini.WriteInteger(FForm.Name, 'Left', FForm.Left);
  Ini.WriteInteger(FForm.Name, 'Top', FForm.Top);
  inherited OnWriteFileExecute(Ini);
end;

end.
