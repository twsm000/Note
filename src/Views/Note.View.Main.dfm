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
  Position = poDesigned
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnMouseWheelDown = FormMouseWheelDown
  OnMouseWheelUp = FormMouseWheelUp
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object PanelMenu: TPanel
    Left = 0
    Top = 0
    Width = 830
    Height = 41
    Align = alTop
    BevelOuter = bvNone
    Color = clWhite
    ParentBackground = False
    TabOrder = 0
    object SpeedButtonFileMenu: TSpeedButton
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 75
      Height = 35
      Align = alLeft
      Caption = 'Arquivo'
      Flat = True
      ExplicitLeft = -19
      ExplicitTop = 6
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
      Visible = False
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
    object SpeedButtonSettings: TSpeedButton
      AlignWithMargins = True
      Left = 794
      Top = 3
      Width = 33
      Height = 35
      Action = ActionSettings
      Align = alRight
      Images = VirtualImageList1
      Flat = True
      Visible = False
      ExplicitLeft = 752
    end
  end
  object StatusBarMain: TStatusBar
    Left = 0
    Top = 699
    Width = 830
    Height = 19
    Panels = <>
  end
  object Editor: TMemo
    Left = 0
    Top = 41
    Width = 830
    Height = 658
    Align = alClient
    ScrollBars = ssVertical
    TabOrder = 2
  end
  object ActionListMain: TActionList
    Images = VirtualImageList1
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
      OnExecute = ActionIncreaseZoomExecute
    end
    object ActionDecreaseZoom: TAction
      Category = 'Display'
      Caption = 'Reduzir zoom'
      OnExecute = ActionDecreaseZoomExecute
    end
    object ActionDefaultZoom: TAction
      Category = 'Display'
      Caption = 'Restaurar zoom padr'#227'o'
      ShortCut = 16432
      OnExecute = ActionDefaultZoomExecute
    end
    object ActionStatusBar: TAction
      Category = 'Display'
      Caption = 'Barra de status'
      Checked = True
      OnExecute = ActionStatusBarExecute
    end
    object ActionWordWrap: TAction
      Category = 'Display'
      Caption = 'Quebra de linha automatica'
      Checked = True
      OnExecute = ActionWordWrapExecute
    end
    object ActionSettings: TAction
      Category = 'Menu'
      ImageIndex = 0
      ImageName = 'settings'
      OnExecute = ActionSettingsExecute
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
  object VirtualImageList1: TVirtualImageList
    DisabledGrayscale = False
    DisabledSuffix = '_Disabled'
    Images = <
      item
        CollectionIndex = 0
        CollectionName = 'settings'
        Disabled = False
        Name = 'settings'
      end>
    ImageCollection = ImageCollection1
    Left = 736
    Top = 360
  end
  object ImageCollection1: TImageCollection
    Images = <
      item
        Name = 'settings'
        SourceImages = <
          item
            Image.Data = {
              89504E470D0A1A0A0000000D4948445200000020000000200806000000737A7A
              F400000006624B474400FF00FF00FFA0BDA79300000285494441545885E5973B
              6F13411485BF205244343C058B842320410AAE0845E880CA76F2937814890412
              90F00778FC8010521011095A4BA1C445A08888A1403C043834263C6253CC19ED
              7833BB3B6B050A38D2C8F29D73CFBDBB3377E62EFCEF18E8D36F3F5006F6EA7F
              0B58D5EF1FC76DA09B32E68A8AF5F3065E01278035A029DB71601458074EF6A1
              198C5DC026E669871CFB906C9BE2EC08CE019584E0A402AD7BF84DCDD5120957
              A4550817811F125C03A681196043B64B1E9F2B9ADB107746BE5D695D080D7E08
              F828C7AF6CDF680F80DD1EBF4160C1C3B71AEF81832109DC97C373CCDA4E0137
              342A646FDC01A00ADC147F521A0D69DECD0B3E0AFC023AC0991C6EA40035E048
              0E775C9A3FC9A992EBCAF45106E728B0086C11BFE62DCCEB8F32FC96C4BD9695
              C013915681B194E06FC46903758DB66CAF539218936657315251065E8AF819B3
              242E1635B7021C73EC25D9EC2675714A5A5D6997B31200D8032C7BC422CCAB6E
              2782BB49B4C571F7C443693D96761086896BDAA22A5B3DC3AF2E4EC5B1D9321C
              F639A41D9BB6D4BA01C9E6A1B086BB04F38EDD5D8292C7CF5D82C38EDD1E4ECB
              042C81BB093F012389792BB69248A2043CF3240D6623076FC2A76497618429B5
              64197E93AD49EFD35B0497A13D8896323811A63A9207D17C4A708BA0836884F8
              281ECF222A5855232B30C059028F62807BCAB4417C19CD02B7142CEF32AA39FC
              297A2FA33B79C1C15C991F48BF8E1730576F1283C427A5EF3A7E071C0849004C
              F3E06B485AB25DF6F85CD55C4BFC69E286E43B703E34B8C504DB5BB21AF92D59
              D5B1D9966CA268F034EC7853EA6BADB2D001DE62DAF206BD6D399AEB14D42C8C
              39D23F4C668B8AF5FB69B60F388DF94403F802BCE02F7D9AFD5BF80DB5D4E4F6
              F1EB4FCE0000000049454E44AE426082}
          end>
      end>
    Left = 736
    Top = 296
  end
  object PopUpDisplayMenu: TPopupMenu
    MenuAnimation = [maTopToBottom]
    OwnerDraw = True
    Left = 744
    Top = 166
    object PopUpIncreaseZoom: TMenuItem
      Action = ActionIncreaseZoom
    end
    object PopUpDecreaseZoom: TMenuItem
      Action = ActionDecreaseZoom
    end
    object PopUpDefaultZoom: TMenuItem
      Action = ActionDefaultZoom
    end
    object MenuItem6: TMenuItem
      Caption = '-'
    end
    object PopUpStatusBar: TMenuItem
      Action = ActionStatusBar
    end
    object PopUpWordWrap: TMenuItem
      Action = ActionWordWrap
    end
  end
end
