unit Note.Controller.Exceptions;

interface

uses
  System.SysUtils;

type
  EFileNotExists = class(Exception);
  EUnwrittenContent = class(Exception);

implementation

end.
