object frmStrEncrypt: TfrmStrEncrypt
  Left = 0
  Top = 0
  Caption = #21152#35299#23494#23383#31526
  ClientHeight = 379
  ClientWidth = 472
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  DesignSize = (
    472
    379)
  PixelsPerInch = 96
  TextHeight = 13
  object mmSourceStr: TcxMemo
    Left = 8
    Top = 24
    TabOrder = 0
    Height = 138
    Width = 449
  end
  object lblSourceStr: TcxLabel
    Left = 8
    Top = 8
    Caption = #28304#23383#31526#20018
  end
  object mmTargetStr: TcxMemo
    Left = 8
    Top = 184
    TabOrder = 2
    Height = 129
    Width = 449
  end
  object lblTargetStr: TcxLabel
    Left = 8
    Top = 168
    Caption = #30446#26631#23383#31526#20018
  end
  object btnEncrypt: TcxButton
    Left = 80
    Top = 338
    Width = 65
    Height = 25
    Anchors = [akLeft, akRight, akBottom]
    Caption = #21152#23494
    TabOrder = 4
    OnClick = btnEncryptClick
  end
  object btnDecrypt: TcxButton
    Left = 200
    Top = 338
    Width = 65
    Height = 25
    Anchors = [akLeft, akRight, akBottom]
    Caption = #35299#23494
    TabOrder = 5
    OnClick = btnDecryptClick
  end
end
