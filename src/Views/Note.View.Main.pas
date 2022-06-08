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
  Note.Controller.Interfaces,
  Note.View.Utils,
  Note.View.Forms;

type
  TMainView = class(TForm)
    ActionListMain: TActionList;
    ActionNewFile: TAction;
    ActionNewWindow: TAction;
    ActionOpenFile: TAction;
    ActionSaveFile: TAction;
    ActionSaveFileAs: TAction;
    Editor: TRichEdit;
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
  private
    FPopMenuMap: TDictionary<TObject, TPopupMenu>;
    FTextFileController: ITextFileController;
    procedure OnPopUpMenuClick(Sender: TObject);
    { Private declarations }
  public
    property FileController: ITextFileController read FTextFileController write FTextFileController;
    procedure ExceptionHandler(Sender: TObject; E: Exception);
    { Public declarations }
  end;

type
  EForceTermination = class(Exception);

var
  MainView: TMainView;

implementation

uses
  Note.View.StringResources,
  Note.Controller.Exceptions;

{$R *.dfm}

procedure TMainView.FormCreate(Sender: TObject);
begin
  FPopMenuMap := TDictionary<TObject, TPopupMenu>.Create;
  FPopMenuMap.AddOrSetValue(SpeedButtonFileMenu, PopUpFileMenu);
  // FPopMenuMap.AddOrSetValue(SpeedButtonEditMenu, PopUpEditMenu);
  // FPopMenuMap.AddOrSetValue(SpeedButtonDisplayMenu, PopUpDisplayMenu);

  SpeedButtonFileMenu.OnClick := Self.OnPopUpMenuClick;
  // SpeedButtonEditMenu.OnClick := Self.OnPopUpMenuClick;
  // SpeedButtonDisplayMenu.OnClick := Self.OnPopUpMenuClick;
end;

procedure TMainView.FormDestroy(Sender: TObject);
begin
  FPopMenuMap.Free;
end;

procedure TMainView.FormShow(Sender: TObject);
begin
  if not Assigned(FTextFileController) then
    raise EForceTermination.Create('TextFileController unassinged');
end;

procedure TMainView.ExceptionHandler(Sender: TObject; E: Exception);
begin
  if E is EForceTermination then
  begin
    TAlertHelper.MessageError(E.Message);
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

procedure TMainView.ActionNewFileExecute(Sender: TObject);
begin
  try
    FTextFileController.NewFile;
  except
    on E: EUnwrittenContent do
    begin
      // TODO: save file
    end;
  end;
end;

procedure TMainView.ActionNewWindowExecute(Sender: TObject);
begin
  FTextFileController.NewWindow;
end;

procedure TMainView.ActionOpenFileExecute(Sender: TObject);
var
  FilePath: string;
begin
  FilePath := TDialogHelper.OpenTextFile(FTextFileController.LastOpenedDir);
  FTextFileController.OpenFile(FilePath);
end;

procedure TMainView.ActionSaveFileExecute(Sender: TObject);
begin
  try
    FTextFileController.SaveFile;
  except
    on E: EFileNotExists do
    begin
      ActionSaveFileAs.Execute;
    end;
  end;
end;

procedure TMainView.ActionSaveFileAsExecute(Sender: TObject);
var
  FilePath: string;
begin
  FilePath := TDialogHelper.SaveTextFile(FTextFileController.LastOpenedDir, FTextFileController.OpenedFile.Name);
  FTextFileController.SaveFileAs(FilePath);
end;

procedure TMainView.ActionExitExecute(Sender: TObject);
begin
  Self.Close;
end;

procedure TMainView.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
var
  AMessage: string;
begin
  if not FTextFileController.HasUnwrittenContent then
    Exit;

  AMessage := TStringResources.SaveFileMessage(FTextFileController.OpenedFile.Name);
  if not TAlertHelper.MessageConfirmationCancelation(AMessage) then
    Exit;

  ActionSaveFile.Execute;
end;

end.
