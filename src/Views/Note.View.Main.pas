unit Note.View.Main;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  System.Actions,
  System.Generics.Collections,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.Menus,
  Vcl.ComCtrls,
  Vcl.StdCtrls,
  Vcl.ActnList,
  Vcl.Buttons,
  Vcl.ExtCtrls,
  Vcl.BaseImageCollection,
  Vcl.ImageCollection,
  System.ImageList,
  Vcl.ImgList,
  Vcl.VirtualImageList,
  Note.Controller.Interfaces,
  Note.View.Utils,
  Note.View.Controls;

type
  TMainView = class(TForm, IAppMainTitle)
    ActionListMain: TActionList;
    ActionNewFile: TAction;
    ActionNewWindow: TAction;
    ActionOpenFile: TAction;
    ActionSaveFile: TAction;
    ActionSaveFileAs: TAction;
    PanelMenu: TPanel;
    SpeedButtonFileMenu: TSpeedButton;
    PopUpFileMenu: TPopupMenu;
    PopUpNewFile: TMenuItem;
    PopUpNewWindow: TMenuItem;
    PopUpOpenFile: TMenuItem;
    PopUpSaveFile: TMenuItem;
    PopUpSaveFileAs: TMenuItem;
    ActionExit: TAction;
    N1: TMenuItem;
    PopUpSair: TMenuItem;
    SpeedButtonEditMenu: TSpeedButton;
    SpeedButtonDisplayMenu: TSpeedButton;
    StatusBar1: TStatusBar;
    ActionUndo: TAction;
    ActionCut: TAction;
    ActionCopy: TAction;
    ActionPaste: TAction;
    ActionDelete: TAction;
    ActionLocate: TAction;
    ActionLocateNext: TAction;
    ActionLocatePrevious: TAction;
    ActionReplace: TAction;
    ActionGoTo: TAction;
    ActionSelectAll: TAction;
    ActionDateTime: TAction;
    ActionFont: TAction;
    ActionIncreaseZoom: TAction;
    ActionDecreaseZoom: TAction;
    ActionDefaultZoom: TAction;
    ActionStatusBar: TAction;
    ActionWordWrap: TAction;
    Editor: TMemo;
    ActionSettings: TAction;
    SpeedButtonSettings: TSpeedButton;
    VirtualImageList1: TVirtualImageList;
    ImageCollection1: TImageCollection;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ActionNewFileExecute(Sender: TObject);
    procedure ActionNewWindowExecute(Sender: TObject);
    procedure ActionOpenFileExecute(Sender: TObject);
    procedure ActionSaveFileExecute(Sender: TObject);
    procedure ActionSaveFileAsExecute(Sender: TObject);
    procedure ActionExitExecute(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormShow(Sender: TObject);
    procedure ActionSettingsExecute(Sender: TObject);
  private
    FPopMenuMap: TDictionary<TObject, TPopupMenu>;
    FFileController: IFileController<TStrings>;
    procedure OnPopUpMenuClick(Sender: TObject);
    procedure SetFileController(const Value: IFileController<TStrings>);
    procedure TrySaveFile;
    procedure SetMainTitle(const Title: string);
    { Private declarations }
  public
    property FileController: IFileController<TStrings> read FFileController write SetFileController;
    procedure ExceptionHandler(Sender: TObject; E: Exception);
    { Public declarations }
  end;

var
  MainView: TMainView;

implementation

uses
  Note.View.StringResources,
  Note.Controller.Exceptions,
  Note.Controller.Utils;

{$R *.dfm}


procedure TMainView.FormCreate(Sender: TObject);
begin
  FPopMenuMap := TDictionary<TObject, TPopupMenu>.Create;
  FPopMenuMap.AddOrSetValue(SpeedButtonFileMenu, PopUpFileMenu);

  SpeedButtonFileMenu.OnClick := Self.OnPopUpMenuClick;
  SpeedButtonEditMenu.OnClick := Self.OnPopUpMenuClick;
  SpeedButtonDisplayMenu.OnClick := Self.OnPopUpMenuClick;
end;

procedure TMainView.FormDestroy(Sender: TObject);
begin
  FPopMenuMap.Free;
end;

procedure TMainView.FormShow(Sender: TObject);
begin
  if not Assigned(FFileController) then
    raise EForceTermination.Create('TextFileController unassinged');
end;

procedure TMainView.ExceptionHandler(Sender: TObject; E: Exception);
begin
  if E is EForceTermination then
  begin
    TAlertHelper.MessageError(E.Message, App.Name);
    Application.Terminate;
  end;
end;

procedure TMainView.OnPopUpMenuClick(Sender: TObject);
var
  Button: TSpeedButton;
  Menu: TPopupMenu;
begin
  if (Sender is TSpeedButton) and FPopMenuMap.TryGetValue(Sender, Menu) then
  begin
    Button := Sender as TSpeedButton;
    TPopUpHelper.Display(Self, Menu, Button.Left, Button.Top + Button.Height);
  end;
end;

procedure TMainView.SetFileController(const Value: IFileController<TStrings>);
begin
  if not Assigned(Value) then
    raise EArgumentException.Create('TextFileController unassinged');

  FFileController := Value;
end;

procedure TMainView.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if not FFileController.HasUnwrittenContent then
    Exit;

  Self.TrySaveFile;
end;

procedure TMainView.TrySaveFile;
var
  AMessage: string;
begin
  AMessage := TStringResources.SaveFileMessage(FFileController.OpenedFile.Name);
  if TAlertHelper.MessageConfirmationCancelation(AMessage, App.Name) then
    ActionSaveFile.Execute;
end;

procedure TMainView.ActionNewFileExecute(Sender: TObject);
begin
  try
    FFileController.NewFile;
  except
    on E: EUnwrittenContent do
    begin
      Self.TrySaveFile;
      FFileController.OpenFile(TStringResources.DefaultFileName, TStringResources.DefaultEncoding);
    end;
  end;
end;

procedure TMainView.ActionNewWindowExecute(Sender: TObject);
begin
  FFileController.NewWindow;
end;

procedure TMainView.ActionOpenFileExecute(Sender: TObject);
var
  FileInfo: TFileInfo;
begin
  FileInfo := TDialogHelper.OpenTextFile(FFileController.LastOpenedDir);
  FFileController.OpenFile(FileInfo.FilePath, FileInfo.Encoding);
end;

procedure TMainView.ActionSaveFileExecute(Sender: TObject);
begin
  try
    FFileController.SaveFile;
  except
    on E: EFileNotFoundException do
    begin
      ActionSaveFileAs.Execute;
    end;
  end;
end;

procedure TMainView.ActionSaveFileAsExecute(Sender: TObject);
var
  FileInfo: TFileInfo;
begin
  FileInfo := TDialogHelper.SaveTextFile(FFileController.LastOpenedDir,
    FFileController.OpenedFile.Name, Editor.Lines.Encoding.EncodingName);
  FFileController.SaveFileAs(FileInfo.FilePath, FileInfo.Encoding);
end;

procedure TMainView.ActionExitExecute(Sender: TObject);
begin
  Self.Close;
end;

procedure TMainView.SetMainTitle(const Title: string);
begin
  Self.Caption := Title;
end;

procedure TMainView.ActionSettingsExecute(Sender: TObject);
begin
  // TODO: ...
end;

end.
