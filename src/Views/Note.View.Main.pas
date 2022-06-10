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
  Vcl.Samples.Spin,
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
    PopUpFileMenu: TPopupMenu;
    PopUpNewFile: TMenuItem;
    PopUpNewWindow: TMenuItem;
    PopUpOpenFile: TMenuItem;
    PopUpSaveFile: TMenuItem;
    PopUpSaveFileAs: TMenuItem;
    ActionExit: TAction;
    N1: TMenuItem;
    PopUpSair: TMenuItem;
    StatusBarMain: TStatusBar;
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
    ActionSettings: TAction;
    VirtualImageList1: TVirtualImageList;
    ImageCollection1: TImageCollection;
    PopUpDisplayMenu: TPopupMenu;
    PopUpIncreaseZoom: TMenuItem;
    MenuItem6: TMenuItem;
    PopUpDecreaseZoom: TMenuItem;
    PopUpDefaultZoom: TMenuItem;
    PopUpStatusBar: TMenuItem;
    PopUpWordWrap: TMenuItem;
    PageControlMain: TPageControl;
    TabSheetEditor: TTabSheet;
    TabSheetSettings: TTabSheet;
    Editor: TMemo;
    PanelMenu: TPanel;
    SpeedButtonFileMenu: TSpeedButton;
    SpeedButtonEditMenu: TSpeedButton;
    SpeedButtonDisplayMenu: TSpeedButton;
    SpeedButtonSettings: TSpeedButton;
    ActionBackToEditor: TAction;
    PanelLoremIpsum: TPanel;
    LabelExample: TLabel;
    PanelSettings: TPanel;
    Label1: TLabel;
    SpeedButtonBackToEditor: TSpeedButton;
    Label2: TLabel;
    ComboBoxFontNames: TComboBox;
    Label4: TLabel;
    SpinEditFontSize: TSpinEdit;
    ActionRestoreFontSettings: TAction;
    SpeedButtonRestoreDefaultSettings: TSpeedButton;
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
    procedure ActionIncreaseZoomExecute(Sender: TObject);
    procedure ActionDecreaseZoomExecute(Sender: TObject);
    procedure ActionDefaultZoomExecute(Sender: TObject);
    procedure ActionStatusBarExecute(Sender: TObject);
    procedure ActionWordWrapExecute(Sender: TObject);
    procedure FormMouseWheelUp(Sender: TObject; Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
    procedure FormMouseWheelDown(Sender: TObject; Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ActionBackToEditorExecute(Sender: TObject);
    procedure OnChangeFontSettings(Sender: TObject);
    procedure ActionRestoreFontSettingsExecute(Sender: TObject);
  private
    FPopMenuMap: TDictionary<TObject, TPopupMenu>;
    FFileController: IFileController<TStrings>;
    procedure OnPopUpMenuClick(Sender: TObject);
    procedure SetFileController(const Value: IFileController<TStrings>);
    procedure TrySaveFile;
    procedure SetMainTitle(const Title: string);
    procedure SetWordWrapEnabled(Value: Boolean);
    procedure SetStatusBarVisible(Value: Boolean);
    procedure SetEditorFontSize(const Value: Integer);
    procedure SetEditorFontName(const Value: string);
    procedure SetDisplayTabSheet(TabSheet: TTabSheet);
    procedure SetFontSettings(const FontName: string; const Size: Integer);
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
  System.UITypes,
  Note.Controller.StringResources,
  Note.Controller.FilePath,
  Note.Controller.Exceptions,
  Note.Controller.Utils,
  Note.View.IniFile,
  System.IniFiles;

{$R *.dfm}


const
  INI_SETTINGS_FILE_NAME = 'note.settings.ini';

type
  TIniSectionDisplay = record
  const
    STATUS_BAR: string = 'StatusBar';
    WORD_WRAP: string = 'WordWrap';
  end;

  TIniSectionFont = record
  const
    FONT_NAME: string = 'FontName';
    FONT_SIZE: string = 'FontSize';
  end;

  TIniSections = record
  const
    DISPLAY: string = 'DISPLAY';
    DISPLAY_ITEMS: TIniSectionDisplay = ();

    FONTS: string = 'FONT';
    FONT_ITEMS: TIniSectionFont = ();
  end;

function GetIniFileSettings: IFile;
begin
  Result := NewFile(WindowsUserFolder + INI_SETTINGS_FILE_NAME);
end;

procedure TMainView.FormCreate(Sender: TObject);
begin
  Self.SetDisplayTabSheet(TabSheetEditor);
  ComboBoxFontNames.Items.AddStrings(Screen.FONTS);

  FPopMenuMap := TDictionary<TObject, TPopupMenu>.Create;
  FPopMenuMap.AddOrSetValue(SpeedButtonFileMenu, PopUpFileMenu);
  FPopMenuMap.AddOrSetValue(SpeedButtonDisplayMenu, PopUpDisplayMenu);

  SpeedButtonFileMenu.OnClick := Self.OnPopUpMenuClick;
  SpeedButtonEditMenu.OnClick := Self.OnPopUpMenuClick;
  SpeedButtonDisplayMenu.OnClick := Self.OnPopUpMenuClick;

  ActionIncreaseZoom.ShortCut := scCtrl or vkEqual;
  ActionIncreaseZoom.SecondaryShortCuts.Add('Ctrl++');
  ActionDecreaseZoom.ShortCut := scCtrl or vkMinus;
  ActionDecreaseZoom.SecondaryShortCuts.Add('Ctrl+-');

  NewIniFormFile(GetIniFileSettings, Self)
    .OnReadFile(procedure(Ini: TMemIniFile)
    begin
      Self.SetStatusBarVisible(Ini.ReadBool(TIniSections.DISPLAY, TIniSections.DISPLAY_ITEMS.STATUS_BAR,
        ActionStatusBar.Checked));

      Self.SetWordWrapEnabled(Ini.ReadBool(TIniSections.DISPLAY, TIniSections.DISPLAY_ITEMS.WORD_WRAP,
        ActionWordWrap.Checked));

      Self.SetEditorFontName(Ini.ReadString(TIniSections.FONTS, TIniSectionFont.FONT_NAME, Self.Font.Name));
      Self.SetEditorFontSize(Ini.ReadInteger(TIniSections.FONTS, TIniSectionFont.FONT_SIZE, Self.Font.Size));
    end)
    .Read;
end;

procedure TMainView.SetDisplayTabSheet(TabSheet: TTabSheet);
var
  I: Integer;
begin
  for I := 0 to PageControlMain.PageCount - 1 do
    PageControlMain.Pages[I].TabVisible := False;

  PageControlMain.ActivePage := TabSheet;
  PageControlMain.Canvas.Brush.Color := clWhite;
end;

procedure TMainView.FormDestroy(Sender: TObject);
begin
  FPopMenuMap.Free;
end;

procedure TMainView.FormShow(Sender: TObject);
begin
  if not Assigned(FFileController) then
    raise EForceTermination.Create('TextFileController unassinged');
  Editor.SetFocus;
end;

procedure TMainView.ExceptionHandler(Sender: TObject; E: Exception);
begin
  if E is EForceTermination then
  begin
    TAlertHelper.MessageError(E.Message, App.Name);
    Application.Terminate;
  end
  else
    TAlertHelper.MessageError(E.Message, 'Atenção!');
end;

procedure TMainView.OnPopUpMenuClick(Sender: TObject);
var
  Button: TSpeedButton;
  Menu: TPopupMenu;
begin
  if (Sender is TSpeedButton) and FPopMenuMap.TryGetValue(Sender, Menu) then
  begin
    Button := Sender as TSpeedButton;
    TPopUpHelper.DISPLAY(Self, Menu, Button.Left, Button.Top + Button.Height);
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

procedure TMainView.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  NewIniFormFile(GetIniFileSettings, Self)
    .OnWriteFile(procedure(Ini: TMemIniFile)
    begin
      Ini.WriteBool(TIniSections.DISPLAY, TIniSections.DISPLAY_ITEMS.STATUS_BAR, ActionStatusBar.Checked);
      Ini.WriteBool(TIniSections.DISPLAY, TIniSections.DISPLAY_ITEMS.WORD_WRAP, ActionWordWrap.Checked);

      Ini.WriteString(TIniSections.FONTS, TIniSectionFont.FONT_NAME, Editor.Font.Name);
      Ini.WriteInteger(TIniSections.FONTS, TIniSectionFont.FONT_SIZE, Editor.Font.Size);
    end)
    .Write;
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

procedure TMainView.SetEditorFontName(const Value: string);
begin
  Editor.Font.Name := Value;
end;

procedure TMainView.SetEditorFontSize(const Value: Integer);
begin
  Editor.Font.Size := Value;
end;

procedure TMainView.ActionIncreaseZoomExecute(Sender: TObject);
begin
  Self.SetEditorFontSize(Editor.Font.Size + 1);
end;

procedure TMainView.ActionDecreaseZoomExecute(Sender: TObject);
begin
  Self.SetEditorFontSize(Editor.Font.Size - 1);
end;

procedure TMainView.ActionDefaultZoomExecute(Sender: TObject);
begin
  Editor.Font.Size := Self.Font.Size;
end;

procedure TMainView.ActionStatusBarExecute(Sender: TObject);
begin
  Self.SetStatusBarVisible(not ActionStatusBar.Checked);
end;

procedure TMainView.SetStatusBarVisible(Value: Boolean);
begin
  ActionStatusBar.Checked := Value;
  StatusBarMain.Visible := ActionStatusBar.Checked;
end;

procedure TMainView.ActionWordWrapExecute(Sender: TObject);
begin
  Self.SetWordWrapEnabled(not ActionWordWrap.Checked);
end;

procedure TMainView.SetWordWrapEnabled(Value: Boolean);
begin
  ActionWordWrap.Checked := Value;
  Editor.WordWrap := ActionWordWrap.Checked;
end;

procedure TMainView.FormMouseWheelUp(Sender: TObject; Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
begin
  if Shift = [ssCtrl] then
    ActionIncreaseZoom.Execute;
end;

procedure TMainView.FormMouseWheelDown(Sender: TObject; Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
begin
  if Shift = [ssCtrl] then
    ActionDecreaseZoom.Execute;
end;

procedure TMainView.ActionSettingsExecute(Sender: TObject);
begin
  Self.SetFontSettings(Editor.Font.Name, Editor.Font.Size);
  Self.SetDisplayTabSheet(TabSheetSettings);
end;

procedure TMainView.SetFontSettings(const FontName: string; const Size: Integer);
begin
  ComboBoxFontNames.ItemIndex := ComboBoxFontNames.Items.IndexOf(FontName);
  Editor.Font.Name := FontName;
  LabelExample.Font.Name := FontName;

  SpinEditFontSize.Value := Size;
  Editor.Font.Size := Size;
  LabelExample.Font.Size := Size;
end;

procedure TMainView.ActionBackToEditorExecute(Sender: TObject);
begin
  Self.SetDisplayTabSheet(TabSheetEditor);
end;

procedure TMainView.ActionRestoreFontSettingsExecute(Sender: TObject);
begin
  Self.SetFontSettings(Self.Font.Name, Self.Font.Size);
end;

procedure TMainView.OnChangeFontSettings(Sender: TObject);
begin
  Self.SetFontSettings(ComboBoxFontNames.Text, SpinEditFontSize.Value);
end;

end.
