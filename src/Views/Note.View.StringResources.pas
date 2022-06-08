unit Note.View.StringResources;

interface

type
  TStringResources = class
  public
    class function DefaultFileName: string;
    class function SaveFileMessage(const FileName: string): string;
    class function OpenFileTitle: string;
    class function SaveFileAsTitle: string;
  end;

implementation

uses
  System.SysUtils;

resourcestring
  DEFAULT_FILE_NAME = 'Sem título';
  SAVE_FILE_MSG = 'Deseja salvar as alterações em %s?';
  OPEN_FILE_TITLE = 'Abrir';
  SAVE_FILE_TITLE = 'Salvar como';

  { TStringResources }

class function TStringResources.DefaultFileName: string;
begin
  Result := DEFAULT_FILE_NAME;
end;

class function TStringResources.SaveFileMessage(const FileName: string): string;
begin
  Result := Format(SAVE_FILE_MSG, [FileName]);
end;

class function TStringResources.OpenFileTitle: string;
begin
  Result := OPEN_FILE_TITLE;
end;

class function TStringResources.SaveFileAsTitle: string;
begin
  Result := SAVE_FILE_TITLE;
end;

end.
