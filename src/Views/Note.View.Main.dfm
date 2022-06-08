object MainView: TMainView
  Left = 0
  Top = 0
  Caption = 'Note'
  ClientHeight = 718
  ClientWidth = 830
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Editor: TRichEdit
    Left = 0
    Top = 41
    Width = 830
    Height = 658
    Align = alClient
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    ScrollBars = ssBoth
    TabOrder = 0
    WantTabs = True
    Zoom = 100
  end
  object PanelMenu: TPanel
    Left = 0
    Top = 0
    Width = 830
    Height = 41
    Align = alTop
    BevelOuter = bvNone
    Color = clWhite
    ParentBackground = False
    TabOrder = 1
    object SpeedButtonFileMenu: TSpeedButton
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 75
      Height = 35
      Align = alLeft
      Caption = 'Arquivo'
      Flat = True
      ExplicitLeft = 0
      ExplicitTop = 0
    end
    object SpeedButtonEditMenu: TSpeedButton
      AlignWithMargins = True
      Left = 84
      Top = 3
      Width = 75
      Height = 35
      Align = alLeft
      Caption = 'Editar'
      Flat = True
      ExplicitTop = 0
    end
    object SpeedButtonDisplayMenu: TSpeedButton
      AlignWithMargins = True
      Left = 165
      Top = 3
      Width = 75
      Height = 35
      Align = alLeft
      Caption = 'Exibir'
      Flat = True
      ExplicitLeft = 246
      ExplicitTop = 6
    end
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 699
    Width = 830
    Height = 19
    Panels = <>
  end
  object ActionListMain: TActionList
    Left = 744
    Top = 58
    object ActionNewFile: TAction
      Category = 'File'
      Caption = 'Novo'
      ShortCut = 16462
      OnExecute = ActionNewFileExecute
    end
    object ActionNewWindow: TAction
      Category = 'File'
      Caption = 'Nova janela'
      ShortCut = 24654
      OnExecute = ActionNewWindowExecute
    end
    object ActionOpenFile: TAction
      Category = 'File'
      Caption = 'Abrir'
      ShortCut = 16463
      OnExecute = ActionOpenFileExecute
    end
    object ActionSaveFile: TAction
      Category = 'File'
      Caption = 'Salvar'
      ShortCut = 16467
      OnExecute = ActionSaveFileExecute
    end
    object ActionSaveFileAs: TAction
      Category = 'File'
      Caption = 'Salvar como'
      ShortCut = 24659
      OnExecute = ActionSaveFileAsExecute
    end
    object ActionExit: TAction
      Category = 'File'
      Caption = 'Sair'
      OnExecute = ActionExitExecute
    end
    object ActionUndo: TAction
      Category = 'Edit'
      Caption = 'Desfazer'
      ShortCut = 16474
    end
    object ActionCut: TAction
      Category = 'Edit'
      Caption = 'Recortar'
      ShortCut = 16472
    end
    object ActionCopy: TAction
      Category = 'Edit'
      Caption = 'Copiar'
      ShortCut = 16451
    end
    object ActionPaste: TAction
      Category = 'Edit'
      Caption = 'Colar'
      ShortCut = 16470
    end
    object ActionDelete: TAction
      Category = 'Edit'
      Caption = 'Excluir'
      ShortCut = 46
    end
    object ActionLocate: TAction
      Category = 'Edit'
      Caption = 'Localizar'
      ShortCut = 16454
    end
    object ActionLocateNext: TAction
      Category = 'Edit'
      Caption = 'Localizar pr'#243'ximo'
      ShortCut = 114
    end
    object ActionLocatePrevious: TAction
      Category = 'Edit'
      Caption = 'Localizar anterior'
      ShortCut = 8306
    end
    object ActionReplace: TAction
      Category = 'Edit'
      Caption = 'Substituir'
      ShortCut = 16456
    end
    object ActionGoTo: TAction
      Category = 'Edit'
      Caption = 'V'#225' para'
      ShortCut = 16455
    end
    object ActionSelectAll: TAction
      Category = 'Edit'
      Caption = 'Selecionar tudo'
      ShortCut = 16449
    end
    object ActionDateTime: TAction
      Category = 'Edit'
      Caption = 'Data/Hora'
      ShortCut = 116
    end
    object ActionFont: TAction
      Category = 'Edit'
      Caption = 'Fonte'
    end
    object ActionIncreaseZoom: TAction
      Category = 'Display'
      Caption = 'Aplicar zoom'
    end
    object ActionDecreaseZoom: TAction
      Category = 'Display'
      Caption = 'Reduzir zoom'
    end
    object ActionDefaultZoom: TAction
      Category = 'Display'
      Caption = 'Restaurar zoom padr'#227'o'
      ShortCut = 16432
    end
    object ActionStatusBar: TAction
      Category = 'Display'
      Caption = 'Barra de status'
    end
    object ActionWordWrap: TAction
      Category = 'Display'
      Caption = 'Quebra de linha automatica'
    end
  end
  object PopUpFileMenu: TPopupMenu
    MenuAnimation = [maTopToBottom]
    OwnerDraw = True
    Left = 744
    Top = 110
    object PopUpNewFile: TMenuItem
      Action = ActionNewFile
    end
    object PopUpNewWindow: TMenuItem
      Action = ActionNewWindow
    end
    object PopUpOpenFile: TMenuItem
      Action = ActionOpenFile
    end
    object PopUpSaveFile: TMenuItem
      Action = ActionSaveFile
    end
    object PopUpSaveFileAs: TMenuItem
      Action = ActionSaveFileAs
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object PopUpSair: TMenuItem
      Action = ActionExit
    end
  end
end
