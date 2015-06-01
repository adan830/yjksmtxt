object frmAddonsFile: TfrmAddonsFile
  Left = 0
  Top = 0
  Caption = 'frmAddonsFile'
  ClientHeight = 268
  ClientWidth = 483
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  DesignSize = (
    483
    268)
  PixelsPerInch = 96
  TextHeight = 13
  object cxLabel3: TcxLabel
    Left = 31
    Top = 32
    Anchors = [akLeft]
    Caption = #23548#20837#25991#20214#65306
  end
  object bedtSourceFile: TcxButtonEdit
    Left = 93
    Top = 31
    Anchors = [akLeft]
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 1
    Width = 361
  end
  object cxLabel1: TcxLabel
    Left = 8
    Top = 66
    Anchors = [akLeft]
    Caption = #38468#21152#25991#20214'ID'#21495#65306
  end
  object btnEQImport: TcxButton
    Left = 93
    Top = 136
    Width = 75
    Height = 25
    Caption = #23548#20837#25991#20214
    TabOrder = 3
    OnClick = btnEQImportClick
  end
  object edtFileID: TcxTextEdit
    Left = 96
    Top = 64
    TabOrder = 4
    Text = 'edtFileID'
    Width = 121
  end
  object btnExport: TcxButton
    Left = 269
    Top = 136
    Width = 75
    Height = 25
    Caption = #23548#20986#25991#20214
    TabOrder = 5
    OnClick = btnExportClick
  end
  object OpenDialog1: TOpenDialog
    Left = 632
    Top = 8
  end
end
