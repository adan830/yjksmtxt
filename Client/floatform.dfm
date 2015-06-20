object FloatWindow: TFloatWindow
  Left = 184
  Top = 478
  BorderIcons = [biSystemMenu]
  Caption = #25805#20316#39064#35797#39064#65306
  ClientHeight = 145
  ClientWidth = 681
  Color = clBtnFace
  DefaultMonitor = dmDesktop
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  OnActivate = tcEQChange
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object tcEQ: TTabControl
    Left = 0
    Top = 0
    Width = 553
    Height = 145
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Default'
    Font.Style = []
    MultiLine = True
    ParentFont = False
    TabOrder = 0
    OnChange = tcEQChange
    object edtEQContent: TJvRichEdit
      Left = 4
      Top = 6
      Width = 545
      Height = 135
      Align = alClient
      Color = clBtnFace
      Font.Charset = GB2312_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = #23435#20307
      Font.Style = []
      ParentFont = False
      ReadOnly = True
      SelText = ''
      TabOrder = 1
    end
    object btnGrade: TButton
      Left = 472
      Top = 0
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
  object Panel1: TPanel
    Left = 553
    Top = 0
    Width = 128
    Height = 145
    Align = alRight
    BevelOuter = bvNone
    TabOrder = 1
    object ExitBitBtn: TBitBtn
      Left = 5
      Top = 113
      Width = 122
      Height = 28
      Caption = #36820#22238#20027#30028#38754
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
    object stTime: TStaticText
      Left = 5
      Top = 34
      Width = 121
      Height = 28
      Alignment = taCenter
      AutoSize = False
      BevelKind = bkTile
      BevelOuter = bvRaised
      Caption = 'stTime'
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -19
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      TabOrder = 1
    end
    object OpenBitBtn: TBitBtn
      Left = 5
      Top = 68
      Width = 122
      Height = 28
      Caption = '   '#21551'  '#21160
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      Glyph.Data = {
        36030000424D3603000000000000360000002800000010000000100000000100
        1800000000000003000000000000000000000000000000000000EAC5A7EBC5A7
        EAC5A8EDC6A6EFC6A6F0C7A5F3C7A4E2C0A8DBBBA8F0AD95D4A390C5ADA9F19B
        83E19F8BFF9571D39680EEC6A6EEC6A5EDC6A6EEC7A6EAC2A4E5BFA6DABBA9DA
        AB94BFA393A3948B7A74726B6969A7938CCEA292DFA594B9B1AEEAC2A5E4C1A7
        F2C7A4F1C6A5DCB9A7BEABA4C2A89DAC948D6B6153312C312324251616176667
        67C9AA9ED0BEB4CBBDB3ECC6A7F0C4A3E4C1A5BBAFAAAAA1A17D7D7F5F4E412F
        3735112B114B773EA3E49D6D806A2C2A2E9B938FC8B5A8CEBFB4EDC3A3F4CBAD
        C7BCB5707578383533212A2109404E0F4C1D1B765034886865F55B7FE08D2521
        257A7E7FC7BFB9D1CCC0F5C8A7C4B0A3525557353333616E7A31ADD604B7FF06
        84B0059FF00696D4168D264BFF5C1D62265C5059BEC1BFCBCDCDFAD3B3C49D85
        221F1EDAE0E2B5FFFF20A9EE009BE500B1FF01A3F2057CCE22752F3CFB441CB4
        2F25272DB1AFAEC7CACAEAC0A3FACAA75848428FACB656AFC9091F85092B9E06
        A5E10B6F7C12781F1BCF4118CE3E3E41162F0909828989C1C6C1E8C3A3FCBEA5
        B27E6C285553284A981713FF1017D6075E88094F5030661424842314C032397D
        30671200454C4CB3B1B1ECC8A7F0BEA3EAB3942843450764681827BF1931F816
        1CCF040E70A60C002E4E1A12D63B119828AA2F1A3A1D1E9AA3A0EDC9A4F4B492
        F8BFA1886D59021D4E2525E90F30FA2E247F6F2225C133079B28105C3111A429
        14FF8B767347456A7170EFC89FF8B58CFAAE95DEA27A14133C2928F91124EC92
        2411FC4104D63800EF350CFF3413F74D39C26556482D2548484BE7C4A7EDBA9D
        FDA78CFDAE984E49392130AA2833FC44124BBD3300481B38A52F129A1C044317
        1E3131316E7575A8AAB7EEC8A7F6B19BEFA897FCB99CAA866F1D254F6B84FF4C
        64F027287F00016D1C181A515353969C9CBDC4C6C2B7B2CEA38DF0C1A0FBA790
        E4B3A3F5BD98E9B19937322B5863843041752F3351797262BDBDBDD8DCDCB8BC
        C1C99582F18C62FF8B60EDC2A2F1B995EBB8A1F6BA98F3C2A087706941312C91
        8275C7B8A8F6D1BCD7D8D7C4B0ACD68F7BFF8B61FF8F66FB8F68}
      ParentFont = False
      TabOrder = 2
      OnClick = OpenBitBtnClick
    end
    object BitBtn1: TBitBtn
      Left = 6
      Top = 1
      Width = 121
      Height = 28
      Caption = #32553#23567
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
      OnClick = BitBtn1Click
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 177
    Height = 28
    BevelOuter = bvNone
    TabOrder = 2
    Visible = False
    object btnExpand: TButton
      Left = 115
      Top = 3
      Width = 59
      Height = 23
      Caption = #25918#22823
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      OnClick = btnExpandClick
    end
    object stTime1: TStaticText
      Left = 0
      Top = -4
      Width = 109
      Height = 28
      Alignment = taCenter
      AutoSize = False
      BevelEdges = []
      BevelKind = bkTile
      BevelOuter = bvRaised
      Caption = 'stTime'
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -19
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      TabOrder = 1
    end
  end
  object Timer1: TTimer
    Interval = 200
    OnTimer = Timer1Timer
    Left = 320
    Top = 8
  end
end
