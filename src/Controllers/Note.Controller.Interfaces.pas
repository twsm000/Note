unit Note.Controller.Interfaces;

interface

uses
  System.Classes;

type
  TFilePathType = (ftUnknow, ftFileLocated, ftFileUnlocated, ftFolder);
  TExtension = string;

  IFileExtension = interface
    ['{EC211CFE-3125-4D64-A3B5-98E4A577A295}']
    function Initials: TExtension;
    function Name: string;
    function Filter: string;
    function IsEquals(Initials: TExtension): Boolean;
  end;

  IGenericFile = interface
    ['{79D8DE20-6C3B-40B4-8D6A-58274B60CA49}']
    function AsObject: TObject;
    function CopyTo(const Destionation: string; Overwrite: Boolean = False): Boolean;
    function Delete: Boolean;
    function Exists: Boolean;
    function Path: string;
    function Name: string;
    procedure Open(Handle: THandle);
  end;

  IDirectory = interface(IGenericFile)
    ['{D87023E5-B23C-43D5-8D84-F4BCE53F1954}']
    function CreateDirs: Boolean;
  end;

  IFile = interface(IGenericFile)
    ['{2E171990-FDC8-46E4-BB64-7A3BCE96514C}']
    function Date: TDateTime;
    function Directory: IDirectory;
    function Extension: IFileExtension;
    function FullName: string;
    function Size: Int64;
    function SizeDetailed(ShowBytes: Boolean = True): string;
    function TypeDef: TFilePathType;
    function IsFile: Boolean;
    function IsDirectory: Boolean;
    function SetAttrReadOnlyParaArchive: Boolean;
    procedure WaitOutput(SleepCheck: Integer = 500);
    function NewFileName(const NewName: string): IFile;
  end;

  IEditor<T> = interface
    ['{71D2415B-4687-443A-BC46-E5D9B7473845}']
    function Content: T;
    procedure SetOnChangeConsumer(Consumer: TNotifyEvent);
  end;

  IAppMainTitle = interface
    ['{1EF0B283-0412-4179-8A3A-63A005168A0C}']
    procedure SetMainTitle(const Title: string);
  end;

  IFileController<T> = interface
    ['{41048E1E-23E4-4C32-95BE-7CBE046BA71F}']
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

end.
