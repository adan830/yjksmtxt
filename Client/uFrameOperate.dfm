object FrameOperate: TFrameOperate
  Left = 0
  Top = 0
  Width = 638
  Height = 418
  TabOrder = 0
  object pnl2: TPanel
    Left = 0
    Top = 0
    Width = 638
    Height = 418
    Align = alClient
    Caption = 'pnl2'
    TabOrder = 0
    object pnl3: TPanel
      Left = 1
      Top = 1
      Width = 636
      Height = 82
      Align = alTop
      BevelOuter = bvNone
      Caption = 'pnl3'
      Color = clWhite
      ParentBackground = False
      ShowCaption = False
      TabOrder = 0
      object mmo1: TMemo
        Left = 0
        Top = 0
        Width = 636
        Height = 82
        Align = alClient
        BorderStyle = bsNone
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 5592405
        Font.Height = 14
        Font.Name = #23435#20307
        Font.Style = [fsBold]
        Lines.Strings = (
          ''
          #21333#39033#36873#25321#39064#65288#26412#39064#20849'40'#23567#39064#65292#27599#23567#39064'1'#20998#65292#20849'40'#20998#65289#21482#26377#19968#20010#36873#39033#26159#27491#30830#30340)
        ParentFont = False
        TabOrder = 0
      end
    end
    object pnl4: TPanel
      Left = 1
      Top = 337
      Width = 636
      Height = 80
      Align = alBottom
      Caption = 'pnl4'
      ShowCaption = False
      TabOrder = 1
      DesignSize = (
        636
        80)
      object btnShowFloatForm: TCnSpeedButton
        Left = 498
        Top = 24
        Width = 82
        Height = 30
        Anchors = []
        Color = 15966293
        DownBold = False
        FlatBorder = False
        HotTrackBold = False
        HotTrackColor = 16551233
        ModernBtnStyle = bsFlat
        Caption = #28014#21160#31383#21475
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = 14
        Font.Name = #23435#20307
        Font.Style = [fsBold]
        Margin = 4
        ParentFont = False
        OnClick = btnShowFloatFormClick
      end
      object btnGrade: TButton
        Left = 365
        Top = 28
        Width = 75
        Height = 25
        Caption = #35780#20998
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Default'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        OnClick = btnGradeClick
      end
    end
    object pnl6: TPanel
      Left = 1
      Top = 83
      Width = 636
      Height = 254
      Align = alClient
      Caption = 'pnl6'
      TabOrder = 2
      object edtTQContent: TJvRichEdit
        Left = 1
        Top = 1
        Width = 634
        Height = 252
        Align = alClient
        BevelInner = bvNone
        BevelOuter = bvNone
        BorderStyle = bsNone
        Flat = True
        Font.Charset = GB2312_CHARSET
        Font.Color = 3355443
        Font.Height = 14
        Font.Name = #23435#20307
        Font.Style = []
        ParentFlat = False
        ParentFont = False
        ReadOnly = True
        SelText = ''
        TabOrder = 0
      end
    end
  end
end
