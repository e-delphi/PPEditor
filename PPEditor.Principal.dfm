object Principal: TPrincipal
  Left = 0
  Top = 0
  HelpType = htKeyword
  HelpKeyword = 'F1'
  Caption = 'PPEditor'
  ClientHeight = 437
  ClientWidth = 852
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnHelp = FormHelp
  PixelsPerInch = 96
  TextHeight = 13
  object sptDivisor: TSplitter
    Left = 217
    Top = 30
    Width = 5
    Height = 388
  end
  object lbxImagens: TListBox
    Left = 0
    Top = 30
    Width = 217
    Height = 388
    Align = alLeft
    ItemHeight = 13
    TabOrder = 0
    OnClick = lbxImagensClick
  end
  object sbarInformacao: TStatusBar
    Left = 0
    Top = 418
    Width = 852
    Height = 19
    Panels = <
      item
        Text = 'Dimens'#245'es'
        Width = 65
      end
      item
        Alignment = taCenter
        Width = 80
      end
      item
        Text = 'Tamanho'
        Width = 60
      end
      item
        Width = 50
      end>
  end
  object pnlTop: TPanel
    Left = 0
    Top = 0
    Width = 852
    Height = 30
    Align = alTop
    BevelKind = bkTile
    BevelOuter = bvNone
    TabOrder = 2
    object lbArquivo: TLabel
      AlignWithMargins = True
      Left = 155
      Top = 3
      Width = 3
      Height = 20
      Margins.Left = 5
      Align = alLeft
      Layout = tlCenter
      ExplicitHeight = 13
    end
    object btnAbrir: TButton
      Left = 0
      Top = 0
      Width = 75
      Height = 26
      Align = alLeft
      Caption = 'Abrir'
      TabOrder = 0
      OnClick = btnAbrirClick
    end
    object btnSalvar: TButton
      Left = 75
      Top = 0
      Width = 75
      Height = 26
      Align = alLeft
      Caption = 'Salvar'
      Enabled = False
      TabOrder = 1
      OnClick = btnSalvarClick
    end
  end
  object pnlClient: TPanel
    Left = 222
    Top = 30
    Width = 630
    Height = 388
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 3
    object imgImagem: TImage
      Left = 0
      Top = 30
      Width = 630
      Height = 358
      Align = alClient
      Center = True
      Proportional = True
      ExplicitLeft = 1
      ExplicitTop = -6
      ExplicitHeight = 388
    end
    object pnlTopImagem: TPanel
      Left = 0
      Top = 0
      Width = 630
      Height = 30
      Align = alTop
      BevelKind = bkTile
      BevelOuter = bvNone
      TabOrder = 0
      object btnLimpar: TButton
        Left = 150
        Top = 0
        Width = 75
        Height = 26
        Align = alLeft
        Caption = 'Limpar'
        Enabled = False
        TabOrder = 0
        OnClick = btnLimparClick
      end
      object btnSalvarImagem: TButton
        Left = 0
        Top = 0
        Width = 75
        Height = 26
        Align = alLeft
        Caption = 'Salvar'
        Enabled = False
        TabOrder = 1
        OnClick = btnSalvarImagemClick
      end
      object btnSubstituir: TButton
        Left = 75
        Top = 0
        Width = 75
        Height = 26
        Align = alLeft
        Caption = 'Substituir'
        Enabled = False
        TabOrder = 2
        OnClick = btnSubstituirClick
      end
    end
  end
  object OpenDialog: TOpenDialog
    Filter = 'Microsoft Power Point|*.pptx'
    Left = 688
  end
  object SavePictureDialog: TSavePictureDialog
    Left = 768
  end
end
