unit Note.Controller.Exceptions;

interface

uses
  System.SysUtils;

type
  EForceTermination = class(Exception);
  EUnsuportedFile = class(Exception);
  EUnwrittenContent = class(Exception);

implementation

end.
