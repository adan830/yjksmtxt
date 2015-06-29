object FrameKeyType: TFrameKeyType
  Left = 0
  Top = 0
  Width = 794
  Height = 544
  TabOrder = 0
  object pnlTitle: TPanel
    Left = 0
    Top = 0
    Width = 794
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
      794
      52)
    object lblTime: TLabel
      Left = 581
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
      ExplicitLeft = 533
    end
  end
  object pnl1: TPanel
    Left = 0
    Top = 52
    Width = 794
    Height = 451
    Align = alClient
    TabOrder = 1
    object spl1: TSplitter
      Left = 1
      Top = 181
      Width = 792
      Height = 3
      Cursor = crVSplit
      Align = alTop
      ExplicitWidth = 269
    end
    object pnl3: TPanel
      Left = 1
      Top = 1
      Width = 792
      Height = 180
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 0
      object sourceRich: TRichEdit
        Left = 0
        Top = 25
        Width = 792
        Height = 155
        Align = alClient
        Color = clWhite
        Enabled = False
        Font.Charset = GB2312_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = #23435#20307
        Font.Style = []
        Lines.Strings = (
          '')
        ParentFont = False
        ReadOnly = True
        TabOrder = 0
        Zoom = 100
        OnKeyDown = sourceRichKeyDown
      end
      object pnl5: TPanel
        Left = 0
        Top = 0
        Width = 792
        Height = 25
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 1
        DesignSize = (
          792
          25)
        object lbl1: TLabel
          Left = 145
          Top = 5
          Width = 627
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
      Top = 184
      Width = 792
      Height = 266
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 1
      object targetRich: TRichEdit
        Left = 0
        Top = 26
        Width = 792
        Height = 240
        Align = alClient
        Color = clWhite
        Font.Charset = GB2312_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = #23435#20307
        Font.Style = []
        HideScrollBars = False
        ImeMode = imChinese
        ParentFont = False
        TabOrder = 0
        Zoom = 100
        OnKeyDown = targetRichKeyDown
        OnKeyUp = targetRichKeyUp
      end
      object pnl6: TPanel
        Left = 0
        Top = 0
        Width = 792
        Height = 26
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 1
        DesignSize = (
          792
          26)
        object lbl2: TLabel
          Left = 18
          Top = 4
          Width = 771
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
    Top = 503
    Width = 794
    Height = 41
    Align = alBottom
    TabOrder = 2
  end
  object timer1: TTimer
    Enabled = False
    OnTimer = timer1Timer
    Left = 640
    Top = 8
  end
end
