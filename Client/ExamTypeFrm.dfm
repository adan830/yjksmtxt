object ExamTypeForm: TExamTypeForm
  Left = 342
  Top = 185
  BorderIcons = []
  BorderStyle = bsToolWindow
  Caption = #35831#36873#25321#32771#35797#26041#24335#65306
  ClientHeight = 268
  ClientWidth = 398
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 398
    Height = 268
    Align = alClient
    Caption = 'Panel1'
    Color = clWhite
    ParentBackground = False
    ShowCaption = False
    TabOrder = 0
    object btnRetry: TCnSpeedButton
      Left = 72
      Top = 224
      Width = 82
      Height = 30
      Color = 15966293
      DownBold = False
      FlatBorder = False
      HotTrackBold = False
      HotTrackColor = 16551233
      ModernBtnStyle = bsFlat
      Caption = #37325#12288#32771
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = 14
      Font.Name = #23435#20307
      Font.Style = []
      Margin = 4
      ParentFont = False
      OnClick = btRetryClick
    end
    object CnSpeedButton1: TCnSpeedButton
      Left = 240
      Top = 224
      Width = 82
      Height = 30
      Color = 15966293
      DownBold = False
      FlatBorder = False
      HotTrackBold = False
      HotTrackColor = 16551233
      ModernBtnStyle = bsFlat
      Caption = #36864#20986
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = 14
      Font.Name = #23435#20307
      Font.Style = []
      Margin = 4
      ParentFont = False
      OnClick = btnExitClick
    end
    object lbltime: TLabel
      Left = 19
      Top = 131
      Width = 143
      Height = 19
      Caption = #24310#38271#26102#38388#65288#31186#65289':'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 5000268
      Font.Height = -19
      Font.Name = #23435#20307
      Font.Style = []
      ParentFont = False
    end
    object Label2: TLabel
      Left = 72
      Top = 16
      Width = 177
      Height = 26
      AutoSize = False
      Caption = #20320#24050#25104#21151#23436#25104#20102#32771#35797#65281#12288
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clLime
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      Transparent = True
    end
    object Label3: TLabel
      Left = 72
      Top = 48
      Width = 233
      Height = 16
      AutoSize = False
      Caption = #20320#21487#20197#32493#32487#19978#27425#20013#26029#30340#32771#35797#65306#12288#12288
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clLime
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      Transparent = True
    end
    object lblID: TLabel
      Left = 57
      Top = 89
      Width = 105
      Height = 19
      Caption = #35831#36755#20837#23494#30721':'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 5000268
      Font.Height = -19
      Font.Name = #23435#20307
      Font.Style = []
      ParentFont = False
    end
    object edtAddTime: TEdit
      Left = 168
      Top = 128
      Width = 193
      Height = 27
      AutoSize = False
      BevelEdges = []
      BevelInner = bvNone
      BevelOuter = bvNone
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = #23435#20307
      Font.Style = []
      MaxLength = 11
      NumbersOnly = True
      ParentFont = False
      TabOrder = 0
    end
    object edtpw: TEdit
      Left = 168
      Top = 86
      Width = 193
      Height = 27
      AutoSize = False
      BevelEdges = []
      BevelInner = bvNone
      BevelOuter = bvNone
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = #23435#20307
      Font.Style = []
      MaxLength = 11
      ParentFont = False
      PasswordChar = '*'
      TabOrder = 1
    end
    object rgExamType: TJvRadioGroup
      Left = 44
      Top = 158
      Width = 354
      Height = 50
      Margins.Top = 0
      Align = alCustom
      Anchors = [akLeft, akTop, akRight, akBottom]
      Caption = 'rgExamType'
      Columns = 3
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = 14
      Font.Name = #23435#20307
      Font.Style = []
      Items.Strings = (
        #37325#32771
        #32493#32771
        #24310#26102#32493#32771)
      ParentFont = False
      TabOrder = 2
      OnClick = rgExamTypeClick
      CaptionVisible = False
      EdgeBorders = []
    end
  end
end
