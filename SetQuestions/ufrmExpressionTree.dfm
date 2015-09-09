object frmExpressionTree: TfrmExpressionTree
  Left = 0
  Top = 0
  Caption = #34920#36798#24335#26641#29983#25104
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
    Height = 73
    Width = 449
  end
  object lblSourceStr: TcxLabel
    Left = 8
    Top = 8
    Caption = #28304#34920#36798#24335
  end
  object mmTargetStr: TcxMemo
    Left = 8
    Top = 144
    TabOrder = 2
    Height = 169
    Width = 449
  end
  object lblTargetStr: TcxLabel
    Left = 8
    Top = 120
    Caption = #34920#36798#24335#26641#65288#20808#24207#65289
  end
  object btnCreateTree: TcxButton
    Left = 80
    Top = 338
    Width = 65
    Height = 25
    Anchors = [akLeft, akRight, akBottom]
    Caption = #26657#39564
    TabOrder = 4
    OnClick = btnCreateTreeClick
  end
end
