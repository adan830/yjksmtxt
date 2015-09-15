object frmEQImport: TfrmEQImport
  Left = 0
  Top = 0
  BorderIcons = [biMinimize, biMaximize]
  Caption = #35797#39064#23548#20837
  ClientHeight = 248
  ClientWidth = 427
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = 14
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  DesignSize = (
    427
    248)
  PixelsPerInch = 96
  TextHeight = 14
  object cxLabel3: TcxLabel
    Left = 38
    Top = 29
    Anchors = [akLeft]
    Caption = #23548#20837#28304#65306
  end
  object bedtSourceFile: TcxButtonEdit
    Left = 104
    Top = 27
    Anchors = [akLeft]
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    Properties.OnButtonClick = bedtSourceFilePropertiesButtonClick
    TabOrder = 1
    Width = 297
  end
  object cbEqType: TcxComboBox
    Left = 103
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
    Width = 298
  end
  object cxLabel1: TcxLabel
    Left = 24
    Top = 66
    Anchors = [akLeft]
    Caption = #23548#20837#39064#22411#65306
  end
  object btnEQImport: TcxButton
    Left = 104
    Top = 144
    Width = 75
    Height = 25
    Caption = #23548#20837#35797#39064
    TabOrder = 4
    OnClick = btnEQImportClick
  end
  object btnExit: TcxButton
    Left = 224
    Top = 144
    Width = 75
    Height = 25
    Caption = #36864#20986
    TabOrder = 5
    OnClick = btnExitClick
  end
  object chkImportOldBase: TCheckBox
    Left = 296
    Top = 104
    Width = 97
    Height = 17
    Caption = #23548#20837#32769#24211
    TabOrder = 6
  end
end
