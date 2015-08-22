object frmReceiveEQUseInfo: TfrmReceiveEQUseInfo
  Left = 0
  Top = 0
  Caption = 'frmReceiveEQUseInfo'
  ClientHeight = 418
  ClientWidth = 647
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  DesignSize = (
    647
    418)
  PixelsPerInch = 96
  TextHeight = 13
  object edtSource: TcxButtonEdit
    Left = 96
    Top = 16
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.OnButtonClick = edtSourcePropertiesButtonClick
    TabOrder = 0
    Text = 'edtSource'
    Width = 473
  end
  object cxLabel1: TcxLabel
    Left = 16
    Top = 16
    Caption = #23398#26657#19978#25253#24211#65306
  end
  object cxButton1: TcxButton
    Left = 416
    Top = 64
    Width = 75
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = #25509#25910
    TabOrder = 2
    OnClick = cxButton1Click
  end
  object edtKStotal: TcxTextEdit
    Left = 480
    Top = 224
    TabOrder = 3
    Text = '0'
    Width = 121
  end
  object edtEQTotal: TcxTextEdit
    Left = 488
    Top = 264
    TabOrder = 4
    Text = '0'
    Width = 121
  end
  object cxLabel2: TcxLabel
    Left = 400
    Top = 232
    Caption = #32771#29983#25968#65306
  end
  object cxLabel3: TcxLabel
    Left = 400
    Top = 272
    Caption = #35797#39064#24635#25968#65306
  end
  object cxButton2: TcxButton
    Left = 416
    Top = 128
    Width = 75
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = #26174#31034
    TabOrder = 7
    OnClick = cxButton2Click
  end
  object OpenDialog1: TOpenDialog
    Left = 576
    Top = 16
  end
  object cdsSystemDB: TClientDataSet
    Aggregates = <>
    CommandText = 'select st_no,nd,syn from '#35797#39064
    Params = <>
    ProviderName = 'DataSetProvider1'
    Left = 416
    Top = 8
  end
  object DataSetProvider1: TDataSetProvider
    DataSet = dmMain.qryStatistics
    Options = [poAllowCommandText, poUseQuoteChar]
    UpdateMode = upWhereKeyOnly
    OnUpdateData = DataSetProvider1UpdateData
    Left = 368
    Top = 8
  end
end
