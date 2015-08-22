object frmConfig: TfrmConfig
  Left = 0
  Top = 0
  Caption = #25104#32489#25509#25910#37197#32622
  ClientHeight = 260
  ClientWidth = 389
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object cxLabel1: TcxLabel
    Left = 16
    Top = 40
    Caption = #34987#25509#25910#25104#32489#20301#32622#65306
  end
  object cxLabel2: TcxLabel
    Left = 26
    Top = 89
    Caption = #27719#24635#25104#32489#20301#32622#65306
  end
  object cxButton1: TcxButton
    Left = 144
    Top = 176
    Width = 75
    Height = 25
    Caption = #20445#23384
    TabOrder = 2
    OnClick = cxButton1Click
  end
  object cbPathSource: TcxShellComboBox
    Left = 120
    Top = 40
    Properties.ShowFullPath = sfpAlways
    TabOrder = 3
    Width = 241
  end
  object cbPathTarget: TcxShellComboBox
    Left = 120
    Top = 88
    Properties.ShowFullPath = sfpAlways
    TabOrder = 4
    Width = 249
  end
end
