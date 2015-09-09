object TypeForm: TTypeForm
  Left = 206
  Top = 100
  Align = alClient
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = #19968#32423'Windows'#26080#32440#21270#32771#35797#65293#25171#23383#27979#35797
  ClientHeight = 506
  ClientWidth = 746
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCloseQuery = FormCloseQuery
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  ExplicitWidth = 320
  ExplicitHeight = 240
  PixelsPerInch = 96
  TextHeight = 20
  object pnlTitle: TPanel
    Left = 0
    Top = 0
    Width = 746
    Height = 52
    Align = alTop
    Alignment = taLeftJustify
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = #40657#20307
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    DesignSize = (
      746
      52)
    object lblTime: TLabel
      Left = 533
      Top = 17
      Width = 200
      Height = 19
      Alignment = taCenter
      Anchors = [akTop, akRight]
      AutoSize = False
      Color = clRed
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = #40657#20307
      Font.Style = []
      ParentColor = False
      ParentFont = False
    end
  end
  object pnl1: TPanel
    Left = 0
    Top = 52
    Width = 746
    Height = 413
    Align = alClient
    TabOrder = 1
    object cxspltr1: TcxSplitter
      Left = 1
      Top = 181
      Width = 744
      Height = 8
      HotZoneClassName = 'TcxSimpleStyle'
      HotZone.SizePercent = 50
      AlignSplitter = salTop
      AllowHotZoneDrag = False
      InvertDirection = True
      MinSize = 100
      Control = pnl3
      ExplicitWidth = 8
    end
    object pnl3: TPanel
      Left = 1
      Top = 1
      Width = 744
      Height = 180
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 1
      object SourceRich: TRichEdit
        Left = 0
        Top = 25
        Width = 744
        Height = 155
        Align = alClient
        Color = clBtnFace
        Enabled = False
        Font.Charset = GB2312_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = #23435#20307
        Font.Style = []
        HideScrollBars = False
        Lines.Strings = (
          '')
        ParentFont = False
        ReadOnly = True
        ScrollBars = ssVertical
        TabOrder = 0
        Zoom = 100
        OnKeyDown = SourceRichKeyDown
      end
      object pnl5: TPanel
        Left = 0
        Top = 0
        Width = 744
        Height = 25
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 1
        DesignSize = (
          744
          25)
        object Label1: TLabel
          Left = 145
          Top = 5
          Width = 579
          Height = 20
          Anchors = [akLeft, akTop, akRight]
          AutoSize = False
          Caption = #25171#23383#26102#38388#20026'15'#20998#38047#65292#22914#26102#38388#26410#29992#23436#65292#36864#20986#21518#21487#20877#27425#36827#20837#20462#25913'!                                    '
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlue
          Font.Height = -16
          Font.Name = #23435#20307
          Font.Style = []
          ParentFont = False
          ExplicitWidth = 577
        end
      end
    end
    object pnl4: TPanel
      Left = 1
      Top = 189
      Width = 744
      Height = 223
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 2
      object targetRich: TRichEdit
        Left = 0
        Top = 26
        Width = 744
        Height = 197
        Align = alClient
        Font.Charset = GB2312_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = #23435#20307
        Font.Style = []
        HideScrollBars = False
        ImeMode = imChinese
        ParentFont = False
        ScrollBars = ssVertical
        TabOrder = 0
        Zoom = 100
        OnChange = targetRichChange
        OnKeyDown = targetRichKeyDown
        OnKeyUp = targetRichKeyUp
      end
      object pnl6: TPanel
        Left = 0
        Top = 0
        Width = 744
        Height = 26
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 1
        DesignSize = (
          744
          26)
        object Label3: TLabel
          Left = 18
          Top = 4
          Width = 723
          Height = 16
          Anchors = [akLeft, akTop, akRight]
          AutoSize = False
          Caption = #35831#22312#19979#38754#30340#32534#36753#26694#20013#24405#20837#19978#38754#30340#25991#23383#65292#34013#33394#34920#31034#27491#30830#65292#32418#33394#34920#31034#38169#35823#12290
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlue
          Font.Height = -16
          Font.Name = #23435#20307
          Font.Style = []
          ParentFont = False
          ExplicitWidth = 721
        end
      end
    end
  end
  object pnl2: TPanel
    Left = 0
    Top = 465
    Width = 746
    Height = 41
    Align = alBottom
    TabOrder = 2
    DesignSize = (
      746
      41)
    object ExitBitBtn: TBitBtn
      Left = 620
      Top = 8
      Width = 105
      Height = 33
      Anchors = [akRight, akBottom]
      Caption = #36864#20986#25171#23383#39064
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000120B0000120B00001000000000000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF0033BBBBBBBBBB
        BB33337777777777777F33BB00BBBBBBBB33337F77333333F37F33BB0BBBBBB0
        BB33337F73F33337FF7F33BBB0BBBB000B33337F37FF3377737F33BBB00BB00B
        BB33337F377F3773337F33BBBB0B00BBBB33337F337F7733337F33BBBB000BBB
        BB33337F33777F33337F33EEEE000EEEEE33337F3F777FFF337F33EE0E80000E
        EE33337F73F77773337F33EEE0800EEEEE33337F37377F33337F33EEEE000EEE
        EE33337F33777F33337F33EEEEE00EEEEE33337F33377FF3337F33EEEEEE00EE
        EE33337F333377F3337F33EEEEEE00EEEE33337F33337733337F33EEEEEEEEEE
        EE33337FFFFFFFFFFF7F33EEEEEEEEEEEE333377777777777773}
      NumGlyphs = 2
      ParentFont = False
      TabOrder = 0
      OnClick = ExitBitBtnClick
    end
  end
  object Timer1: TTimer
    Enabled = False
    OnTimer = Timer1Timer
    Left = 640
    Top = 8
  end
end
