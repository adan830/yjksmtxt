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
  PixelsPerInch = 96
  TextHeight = 13
  object edtConvert: TJvRichEdit
    Left = 8
    Top = 8
    Width = 450
    Height = 266
    Font.Charset = GB2312_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    SelText = ''
    TabOrder = 0
  end
  object btnConvert: TcxButton
    Left = 64
    Top = 280
    Width = 75
    Height = 25
    Caption = 'Convert'
    TabOrder = 1
    OnClick = btnConvertClick
  end
  object dsTQDB: TADODataSet
    Connection = dmSetQuestion.stkConn
    CommandText = 'select  * from '#35797#39064' '
    Parameters = <>
    Left = 400
    Top = 24
  end
end
