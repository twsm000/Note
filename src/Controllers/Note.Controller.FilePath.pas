unit Note.Controller.FilePath;

interface

{$WARN SYMBOL_PLATFORM OFF}


uses
  Windows,
  Note.Controller.Interfaces;

function NewFileExtension(Initials: TExtension; const ExtensionName: string;
  AcceptEmptyExtension: Boolean = False): IFileExtension;
function NewFile(const FilePath: string; AcceptEmptyExtension: Boolean = True;
  PromptDeleteFolderMessage: Boolean = True): IFile;
function NewFileTemp(const Directory, Initials: string): IFile;
function NewDirectory(const FilePath: string): IDirectory;

implementation

uses
  SysUtils,
  ShellAPI,
  Forms,
  Controls,
  Note.Controller.Utils;

type
  TFileExtensionHelper = record
  public
    function Format(const Initials: TExtension): TExtension;
    function IsExtension(const Initials: TExtension): Boolean;

  const
    GENERIC_EXTENSION = '.*';
  end;

type
  TFileExtension = class(TInterfacedObject, IFileExtension)
  private
    FInitials: TExtension;
    FName: string;

  const
    EXT_HELPER: TFileExtensionHelper = ();

  public
    constructor Create(Initials: TExtension; const ExtensionName: string; AcceptEmptyExtension: Boolean = False);
    destructor Destroy; override;
    function IsEquals(Initials: TExtension): Boolean;
    function Initials: TExtension;
    function Name: string;
    function Filter: string;
  end;

type
  TGenericFile = class abstract(TInterfacedObject, IGenericFile)
  private
    FFile: string;
  public
    constructor Create(const FilePath: string); virtual;
    destructor Destroy; override;
    function AsObject: TObject;
    function CopyTo(const Destination: string; Overwrite: Boolean = False): Boolean; virtual; abstract;
    function Delete: Boolean; virtual; abstract;
    function Exists: Boolean; virtual; abstract;
    function Path: string; virtual;
    function Name: string; virtual; abstract;
    procedure Open(Handle: THandle); virtual;
  end;

  TDirectory = class(TGenericFile, IDirectory)
  strict private
  type
    TCopyInfo = record
      Arquivos: Integer;
      Diretorios: Integer;
    end;

  const
    FINALIZE_COPY_INFO: TCopyInfo = ();
  private
    procedure CopyDirs(out Input, Output: TCopyInfo; const Destination: string; Overwrite: Boolean = False); overload;
  public
    destructor Destroy; override;
    function CopyTo(const Destination: string; Overwrite: Boolean = False): Boolean; overload; override;
    function CreateDirs: Boolean; virtual;
    function Delete: Boolean; override;
    function Exists: Boolean; override;
    function Path: string; override;
    function Name: string; override;
  end;

  TFile = class(TGenericFile, IFile)
  private
    FDirectory: IDirectory;
    FAcceptEmptyExtension: Boolean;
    FPromptDeleteFolderMessage: Boolean;

  public
    constructor Create(const FilePath: string; AcceptEmptyExtension: Boolean = True;
      PromptDeleteFolderMessage: Boolean = True); reintroduce; virtual;
    destructor Destroy; override;
    function CopyTo(const Destination: string; Overwrite: Boolean = False): Boolean; override;
    function Delete: Boolean; override;
    function Exists: Boolean; override;
    function Date: TDateTime; virtual;
    function Directory: IDirectory; virtual;
    function Extension: IFileExtension; virtual;
    function Name: string; override;
    function FullName: string; virtual;
    function Size: Int64; virtual;
    function SizeDetailed(ShowBytes: Boolean = True): string; virtual;
    function TypeDef: TFilePathType; virtual;
    function IsFile: Boolean; virtual;
    function IsDirectory: Boolean; virtual;
    function SetAttrReadOnlyParaArchive: Boolean; virtual;
    procedure WaitOutput(SleepCheck: Integer = 500); virtual;
    function NewFileName(const NewName: string): IFile;
  end;

  TFileTemp = class(TFile)
  public
    constructor Create(const Directory, Initials: string); reintroduce; overload; virtual;
    constructor Create(const FilePath: string; AcceptEmptyExtension: Boolean = True;
      PromptDeleteFolderMessage: Boolean = True); overload; override; deprecated;
    destructor Destroy; override;

  end;

{$REGION ' FACTORY METHODS '}

function NewFileExtension(Initials: TExtension; const ExtensionName: string;
  AcceptEmptyExtension: Boolean): IFileExtension;
begin
  Result := TFileExtension.Create(Initials, ExtensionName, AcceptEmptyExtension);
end;

function NewFile(const FilePath: string; AcceptEmptyExtension, PromptDeleteFolderMessage: Boolean): IFile;
begin
  Result := TFile.Create(FilePath, AcceptEmptyExtension, PromptDeleteFolderMessage);
end;

function NewFileTemp(const Directory, Initials: string): IFile;
begin
  Result := TFileTemp.Create(Directory, Initials);
end;

function NewDirectory(const FilePath: string): IDirectory;
begin
  Result := TDirectory.Create(FilePath);
end;
{$ENDREGION}

{ TFileExtensionHelper }

function TFileExtensionHelper.Format(const Initials: TExtension): TExtension;
begin
  Result := Trim(Initials);
  if (Length(Result) > 0)
    and NOT(Result[1] = '.') then
    Result := '.' + Result;
end;

function TFileExtensionHelper.IsExtension(const Initials: TExtension): Boolean;
begin
  Result := (Length(Initials) >= 2) and (Initials[1] = '.');
end;

{ TFileExtension }

constructor TFileExtension.Create(Initials: TExtension; const ExtensionName: string;
  AcceptEmptyExtension: Boolean);
begin
  Initials := EXT_HELPER.Format(Initials);
  if not AcceptEmptyExtension and not EXT_HELPER.IsExtension(Initials) then
    raise Exception.Create(Self.ClassName + ': Extensão informada inválida!');

  FInitials := Initials;
  FName := ExtensionName + ' (' + AnsiUpperCase(FInitials) + ')';
end;

destructor TFileExtension.Destroy;
begin
  inherited Destroy;
end;

function TFileExtension.IsEquals(Initials: TExtension): Boolean;
begin
  Initials := EXT_HELPER.Format(Initials);
  Result := (AnsiUpperCase(Self.Initials) = AnsiUpperCase(Initials))
    or (Self.Initials = '.*');
end;

function TFileExtension.Initials: TExtension;
begin
  Result := AnsiLowerCase(FInitials);
end;

function TFileExtension.Name: string;
begin
  Result := FName;
end;

function TFileExtension.Filter: string;
begin
  Result := Self.Name + '| *' + Self.Initials;
end;

{ TFile }

function TFile.CopyTo(const Destination: string; Overwrite: Boolean): Boolean;
var
  Source: string;
  FailWhenFileExists: Boolean;
begin
  Source := Self.Path;
  FailWhenFileExists := not Overwrite;
  Result := CopyFile(PWideChar(Source), PWideChar(Destination), FailWhenFileExists);
end;

constructor TFile.Create(const FilePath: string; AcceptEmptyExtension: Boolean;
  PromptDeleteFolderMessage: Boolean);
begin
  inherited Create(FilePath);
  FAcceptEmptyExtension := AcceptEmptyExtension;
  FPromptDeleteFolderMessage := PromptDeleteFolderMessage;
end;

destructor TFile.Destroy;
begin
  inherited Destroy;
end;

function TFile.Delete: Boolean;
begin
  Result := DeleteFile(Self.Path);
end;

function TFile.Exists: Boolean;
begin
  Result := FileExists(Self.Path);
end;

function TFile.Directory: IDirectory;
begin
  if not Assigned(FDirectory) then
  begin
    if Self.IsFile then
      FDirectory := TDirectory.Create(ExtractFilePath(Self.Path))
    else
      FDirectory := TDirectory.Create(Self.Path)
  end;

  Result := FDirectory;
end;

function TFile.Extension: IFileExtension;
var
  Initials: TExtension;
begin
  Initials := AnsiLowerCase(ExtractFileExt(Self.Path));
  Result := TFileExtension.Create(Initials, EmptyStr, FAcceptEmptyExtension);
end;

function TFile.Name: string;
begin
  Result := Self.FullName;
  Result := StringReplace(Result, Self.Extension.Initials, EmptyStr, [rfIgnoreCase]);
end;

function TFile.FullName: string;
begin
  Result := ExtractFileName(Self.Path);
end;

function TFile.Size: Int64;
var
  Search: TSearchRec;
begin
  try
    if FindFirst(Self.Path, faAnyFile, Search) = 0 then
      Result := Search.Size
    else
      Result := -1;
  finally
    FindClose(Search);
  end;
end;

function TFile.SizeDetailed(ShowBytes: Boolean): string;
var
  FileSize: Int64;
begin
  if not Self.Exists then
  begin
    Result := '?';
    Exit;
  end;

  FileSize := Self.Size;

  if (FileSize > (1024 * 1000)) then
    Result := Format('%.2n Mb', [(FileSize / 1024 / 1024), Formatfloat('#,###.##', FileSize)])
  else
    Result := Format('%.1n Kb', [FileSize / 1024, Formatfloat('#,###.##', FileSize)]);

  if ShowBytes then
    Result := Result + Format(' (%s bytes)', [Formatfloat('#,###.##', FileSize)]);
end;

function TFile.TypeDef: TFilePathType;
begin
  if (Self.Exists) and (Self.Date > 0) then
    Result := ftFileLocated
  else if not Self.Exists and not DirectoryExists(ExcludeTrailingPathDelimiter(Self.Path)) then
    Result := ftFileUnlocated
  else if DirectoryExists(ExcludeTrailingPathDelimiter(Self.Path)) then
    Result := ftFolder
  else
    Result := ftUnknow;
end;

function TFile.IsFile: Boolean;
begin
  Result := (Self.TypeDef in [ftFileLocated, ftFileUnlocated]);
end;

function TFile.IsDirectory: Boolean;
begin
  Result := Self.TypeDef = ftFolder;
end;

function TFile.SetAttrReadOnlyParaArchive: Boolean;
var
  Search: TSearchRec;
begin
  Result := False;
  if (FindFirst(Self.Path, faAnyFile - faDirectory, Search) = 0)
    and ((Search.Attr and faReadOnly) > 0)
    and (Self.TypeDef = ftFileLocated) then
    Result := SetFileAttributes(PWideChar(Self.Path), FILE_ATTRIBUTE_ARCHIVE);

  FindClose(Search);
end;

procedure TFile.WaitOutput(SleepCheck: Integer);
var
  FileSize: Int64;
begin
  Screen.Cursor := crHourGlass;
  try
    repeat
    until (Self.Exists);

    repeat
      FileSize := Self.Size;
      Sleep(SleepCheck);
    until (FileSize = Self.Size);
  finally
    Screen.Cursor := crDefault;
  end;
end;

function TFile.Date: TDateTime;
begin
  FileAge(ExcludeTrailingPathDelimiter(Self.Path), Result);
end;

function TFile.NewFileName(const NewName: string): IFile;
begin
  Result := NewFile(Self.Directory.Path + NewName, FAcceptEmptyExtension, FPromptDeleteFolderMessage);
end;

{ TFileTemp }

constructor TFileTemp.Create(const Directory, Initials: string);
var
  FileExtension: IFileExtension;
  AFile: string;
begin
  FileExtension := TFileExtension.Create(Initials, EmptyStr);
  AFile := IncludeTrailingPathDelimiter(Directory) + NewGUIIDAlphaNumeric + FileExtension.Initials;
  inherited Create(AFile, False);
end;

constructor TFileTemp.Create(const FilePath: string; AcceptEmptyExtension: Boolean;
  PromptDeleteFolderMessage: Boolean);
begin
  raise Exception.Create('Invalid constructor!');
  // inherited Create(CaminhoArquivo, AcceptEmptyExtension);
end;

destructor TFileTemp.Destroy;
begin
  inherited Destroy;
end;

{ TDirectory }

destructor TDirectory.Destroy;
begin
  inherited Destroy;
end;

function TDirectory.CopyTo(const Destination: string; Overwrite: Boolean): Boolean;
var
  Input: TCopyInfo;
  Output: TCopyInfo;
begin
  Input := FINALIZE_COPY_INFO;
  Output := FINALIZE_COPY_INFO;
  Self.CopyDirs(Input, Output, Destination, Overwrite);

  Result := (Input.Arquivos = Output.Arquivos) and (Input.Diretorios = Output.Diretorios);
end;

procedure TDirectory.CopyDirs(out Input, Output: TCopyInfo; const Destination: string; Overwrite: Boolean);
var
  Search: TSearchRec;
  Return: Integer;
  OutputDir: IDirectory;
  AFile: IFile;
begin
  OutputDir := TDirectory.Create(Destination);
  if Overwrite then
    OutputDir.Delete;

  OutputDir.CreateDirs;

  Return := FindFirst(Self.Path + '*.*', faAnyFile, Search);
  try
    while (Return = 0) do
    begin
      if NOT(Search.Name = '.') and NOT(Search.Name = '..') then
      begin
        AFile := TFile.Create(Self.Path + Search.Name);
        if AFile.IsFile then
        begin
          Inc(Input.Arquivos);

          AFile.CopyTo(OutputDir.Path + Search.Name, Overwrite);
          if FileExists(OutputDir.Path + Search.Name) then
            Inc(Output.Arquivos);
        end
        else if AFile.IsDirectory then
        begin
          Inc(Input.Diretorios);
          TDirectory(AFile.Directory.AsObject).CopyDirs(Input, Output, OutputDir.Path + Search.Name, Overwrite);

          if DirectoryExists(OutputDir.Path + Search.Name) then
            Inc(Output.Diretorios);
        end;
      end;

      Return := FindNext(Search);
    end;
  finally
    FindClose(Search);
  end;
end;

function TDirectory.Delete: Boolean;
var
  Search: TSearchRec;
  Return: Integer;
  AFile: IFile;
begin
  if not Self.Exists then
  begin
    Result := False;
    Exit;
  end;

  Return := FindFirst(Self.Path + '*.*', faAnyFile, Search);
  try
    while (Return = 0) do
    begin
      if not(Search.Name = '.') and not(Search.Name = '..') then
      begin
        AFile := TFile.Create(Self.Path + Search.Name);
        if AFile.IsFile then
          AFile.Delete
        else if AFile.IsDirectory then
          AFile.Directory.Delete;
      end;

      Return := FindNext(Search);
    end;
  finally
    FindClose(Search);
  end;

  Result := RemoveDir(Self.Path);
end;

function TDirectory.Exists: Boolean;
begin
  Result := DirectoryExists(Self.Path);
end;

function TDirectory.Path: string;
begin
  Result := IncludeTrailingPathDelimiter(inherited Path);
end;

function TDirectory.Name: string;
begin
  Result := ExtractFileName(Self.Path);
end;

function TDirectory.CreateDirs: Boolean;
begin
  Result := ForceDirectories(Self.Path);
end;

{ TGenericFile }

function TGenericFile.AsObject: TObject;
begin
  Result := Self;
end;

procedure TGenericFile.Open;
begin
  ShellExecute(Handle, 'open', PWideChar(Self.Path), nil, nil, SW_SHOWNORMAL);
end;

constructor TGenericFile.Create(const FilePath: string);
begin
  FFile := FilePath;
end;

destructor TGenericFile.Destroy;
begin
  inherited Destroy;
end;

function TGenericFile.Path: string;
begin
  Result := FFile;
end;

end.
