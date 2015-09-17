object frmConverttoRTF: TfrmConverttoRTF
  Left = 0
  Top = 0
  Caption = 'frmConverttoRTF'
  ClientHeight = 325
  ClientWidth = 466
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  DesignSize = (
    466
    325)
  PixelsPerInch = 96
  TextHeight = 13
  object edtConvert: TJvRichEdit
    Left = 8
    Top = 8
    Width = 450
    Height = 161
    Font.Charset = GB2312_CHARSET
    Font.Color = clWindowText
    Font.Height = 14
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    SelText = ''
    TabOrder = 0
  end
  object cxLabel3: TcxLabel
    Left = 38
    Top = 197
    Anchors = [akLeft]
    Caption = #23548#20837#28304#65306
  end
  object bedtSourceFile: TcxButtonEdit
    Left = 104
    Top = 195
    Anchors = [akLeft]
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    Properties.OnButtonClick = bedtSourceFilePropertiesButtonClick
    TabOrder = 2
    Width = 297
  end
  object cbEqType: TcxComboBox
    Left = 103
    Top = 232
    Properties.DropDownListStyle = lsFixedList
    Properties.Items.Strings = (
      #21333#39033#36873#25321#39064
      #22810#39033#36873#25321#39064
      #25171#23383#39064
      'Windows'#25805#20316#39064
      'Word'#25805#20316#39064
      'Excel'#25805#20316#39064
      'PowerPoint'#25805#20316#39064)
    TabOrder = 3
    Width = 298
  end
  object cxLabel1: TcxLabel
    Left = 24
    Top = 234
    Anchors = [akLeft]
    Caption = #23548#20837#39064#22411#65306
  end
  object btnEQImport: TcxButton
    Left = 56
    Top = 272
    Width = 75
    Height = 25
    Caption = #23548#20837#35797#39064
    TabOrder = 5
    OnClick = btnConvertClick
  end
  object btnUpdateFont: TcxButton
    Left = 200
    Top = 272
    Width = 75
    Height = 25
    Caption = #26356#26032#23383#20307
    TabOrder = 6
    OnClick = btnUpdateFontClick
  end
end
