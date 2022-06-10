unit Note.Controller.StringResources;

interface

type
  TStringResources = class
  public
    class function DefaultFileName: string;
    class function SaveFileMessage(const FileName: string): string;
    class function OpenFileTitle: string;
    class function SaveFileAsTitle: string;
    class function DefaultEncoding: string;
    class function UnsuportedFile(const FileName: string): string;
  end;

implementation

uses
  System.SysUtils;

resourcestring
  DEFAULT_FILE_NAME = 'Sem título';
  SAVE_FILE_MSG = 'Deseja salvar as alterações em %s?';
  OPEN_FILE_TITLE = 'Abrir';
  SAVE_FILE_TITLE = 'Salvar como';
  DEFAULT_ENCODING = 'UTF-8';
  UNSUPORTED_FILE = 'Arquivo não suportado: %s';

  { TStringResources }

class function TStringResources.DefaultFileName: string;
begin
  Result := DEFAULT_FILE_NAME;
end;

class function TStringResources.SaveFileMessage(const FileName: string): string;
begin
  Result := Format(SAVE_FILE_MSG, [FileName]);
end;

class function TStringResources.UnsuportedFile(const FileName: string): string;
begin
  Result := Format(UNSUPORTED_FILE, [FileName]);
end;

class function TStringResources.OpenFileTitle: string;
begin
  Result := OPEN_FILE_TITLE;
end;

class function TStringResources.SaveFileAsTitle: string;
begin
  Result := SAVE_FILE_TITLE;
end;

class function TStringResources.DefaultEncoding: string;
begin
  Result := DEFAULT_ENCODING;
end;

end.
