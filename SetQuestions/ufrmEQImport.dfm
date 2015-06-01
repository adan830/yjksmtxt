object frmEQImport: TfrmEQImport
  Left = 0
  Top = 0
  Caption = 'frmEQImport'
  ClientHeight = 248
  ClientWidth = 427
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  DesignSize = (
    427
    248)
  PixelsPerInch = 96
  TextHeight = 13
  object cxLabel3: TcxLabel
    Left = 23
    Top = 32
    Anchors = [akLeft]
    Caption = #23548#20837#28304#65306
  end
  object bedtSourceFile: TcxButtonEdit
    Left = 88
    Top = 28
    Anchors = [akLeft]
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    Properties.OnButtonClick = bedtSourceFilePropertiesButtonClick
    TabOrder = 1
    Width = 313
  end
  object cbEqType: TcxComboBox
    Left = 88
    Top = 64
    Properties.DropDownListStyle = lsFixedList
    Properties.Items.Strings = (
      #21333#39033#36873#25321#39064
      #22810#39033#36873#25321#39064
      #25171#23383#39064
      'Windows'#25805#20316#39064
      'Word'#25805#20316#39064
      'Excel'#25805#20316#39064
      'PowerPoint'#25805#20316#39064)
    TabOrder = 2
    Width = 153
  end
  object cxLabel1: TcxLabel
    Left = 23
    Top = 64
    Anchors = [akLeft]
    Caption = #23548#20837#39064#22411#65306
  end
  object btnEQImport: TcxButton
    Left = 128
    Top = 152
    Width = 75
    Height = 25
    Caption = #23548#20837#35797#39064
    TabOrder = 4
    OnClick = btnEQImportClick
  end
  object btnExport: TcxButton
    Left = 224
    Top = 152
    Width = 75
    Height = 25
    Caption = #23548#20986#35797#39064
    TabOrder = 5
    OnClick = btnExportClick
  end
end
