object frmScoreReceive: TfrmScoreReceive
  Left = 0
  Top = 0
  Caption = #25104#32489#25509#25910
  ClientHeight = 405
  ClientWidth = 609
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object btnScore: TcxButton
    Left = 160
    Top = 272
    Width = 75
    Height = 25
    Caption = #27719#24635#25104#32489
    TabOrder = 0
    OnClick = btnScoreClick
  end
  object edtSource: TcxButtonEdit
    Left = 96
    Top = 16
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 1
    OnClick = edtSourceClick
    Width = 473
  end
  object cxLabel1: TcxLabel
    Left = 16
    Top = 16
    Caption = #23398#26657#19978#25253#24211#65306
  end
  object edtInsertNum: TcxTextEdit
    Left = 160
    Top = 96
    TabOrder = 3
    Text = '0'
    Width = 121
  end
  object edtUpdateNum: TcxTextEdit
    Left = 160
    Top = 136
    TabOrder = 4
    Text = '0'
    Width = 121
  end
  object cxLabel2: TcxLabel
    Left = 64
    Top = 96
    Caption = #28155#21152#20154#25968#65306
  end
  object cxLabel3: TcxLabel
    Left = 64
    Top = 144
    Caption = #26356#26032#20154#25968#65306
  end
  object edtTime: TcxTextEdit
    Left = 160
    Top = 176
    TabOrder = 7
    Text = '0'
    Width = 121
  end
  object edtRecno: TcxTextEdit
    Left = 160
    Top = 56
    TabOrder = 8
    Text = '0'
    Width = 121
  end
  object cxLabel4: TcxLabel
    Left = 64
    Top = 56
    Caption = #24403#21069#35760#24405#65306
  end
  object lbError: TListBox
    Left = 344
    Top = 43
    Width = 225
    Height = 313
    ItemHeight = 13
    TabOrder = 10
  end
  object btnExportErrorRecord: TcxButton
    Left = 480
    Top = 362
    Width = 89
    Height = 25
    Caption = #23548#20986#38169#35823#35760#24405
    TabOrder = 11
    OnClick = btnExportErrorRecordClick
  end
  object OpenDialog1: TOpenDialog
    Left = 576
    Top = 8
  end
  object Timer1: TTimer
    Enabled = False
    OnTimer = Timer1Timer
    Left = 304
    Top = 72
  end
end
