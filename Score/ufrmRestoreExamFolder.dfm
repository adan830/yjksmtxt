object frmRestoreExamFolder: TfrmRestoreExamFolder
  Left = 0
  Top = 0
  Caption = #36824#21407#32771#29983#25991#20214#22841
  ClientHeight = 344
  ClientWidth = 455
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object bedtSourceFile: TcxButtonEdit
    Left = 146
    Top = 39
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 0
    Text = 'bedtSourceFile'
    OnClick = bedtSourceFileClick
    Width = 253
  end
  object lbl1: TcxLabel
    Left = 40
    Top = 40
    Caption = #38656#36824#21407#30340#21407#25991#20214#65306
  end
  object lbl2: TcxLabel
    Left = 52
    Top = 80
    Caption = #36824#21407#25991#20214#20301#32622#65306
  end
  object cbbPathTarget: TcxShellComboBox
    Left = 146
    Top = 79
    Properties.ShowFullPath = sfpAlways
    TabOrder = 3
    Width = 249
  end
  object btnRestore: TcxButton
    Left = 176
    Top = 232
    Width = 75
    Height = 25
    Caption = #36824#21407
    TabOrder = 4
    OnClick = btnRestoreClick
  end
  object dlgOpen1: TOpenDialog
    DefaultExt = '.dat'
    Options = [ofReadOnly, ofHideReadOnly, ofEnableSizing]
    Left = 16
    Top = 8
  end
end
