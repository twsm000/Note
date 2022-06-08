unit Note.Controller.Interfaces;

interface

uses
  Note.Controller.FilePath;

type
  ITextFileController = interface
    ['{41048E1E-23E4-4C32-95BE-7CBE046BA71F}']
    procedure NewFile;
    procedure NewWindow;
    procedure OpenFile(const FilePath: string);
    procedure SaveFile;
    procedure SaveFileAs(const FilePath: string);
    function LastOpenedDir: string;
    function OpenedFile: IFile;
    function HasUnwrittenContent: Boolean;
    function ApplicationFileTitle: string;
  end;

implementation

end.
