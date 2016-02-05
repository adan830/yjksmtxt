object TypeForm1: TTypeForm1
  Left = 206
  Top = 100
  BorderIcons = []
  Caption = #19968#32423'Windows'#26080#32440#21270#32771#35797#65293#25171#23383#27979#35797
  ClientHeight = 459
  ClientWidth = 702
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnShow = FormShow
  DesignSize = (
    702
    459)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 16
    Width = 545
    Height = 16
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = #25171#23383#26102#38388#20026'15'#20998#38047#65292#22914#26102#38388#26410#29992#23436#65292#36864#20986#21518#21487#20877#27425#36827#20837#20462#25913'!                                    '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -16
    Font.Name = #23435#20307
    Font.Style = []
    ParentFont = False
  end
  object Label2: TLabel
    Left = 40
    Top = 24
    Width = 3
    Height = 13
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label3: TLabel
    Left = 8
    Top = 244
    Width = 689
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
  end
  object SourceRich: TRichEdit
    Left = 7
    Top = 56
    Width = 698
    Height = 177
    Color = clBtnFace
    DragMode = dmAutomatic
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
  object targetRich: TRichEdit
    Left = 7
    Top = 266
    Width = 698
    Height = 156
    Font.Charset = GB2312_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = #23435#20307
    Font.Style = []
    HideScrollBars = False
    ImeMode = imChinese
    ParentFont = False
    ScrollBars = ssVertical
    TabOrder = 1
    Zoom = 100
    OnKeyDown = targetRichKeyDown
    OnKeyUp = targetRichKeyUp
  end
  object ExitBitBtn: TBitBtn
    Left = 568
    Top = 430
    Width = 105
    Height = 33
    Anchors = [akTop, akRight]
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
    TabOrder = 2
    OnClick = ExitBitBtnClick
  end
  object Edit1: TEdit
    Left = 560
    Top = 8
    Width = 137
    Height = 28
    Anchors = [akTop, akRight]
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
  end
  object Timer1: TTimer
    Enabled = False
    OnTimer = Timer1Timer
    Left = 576
    Top = 16
  end
end
