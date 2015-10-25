object frmBrowseSource: TfrmBrowseSource
  Left = 146
  Top = 154
  Caption = #28304#24211#27983#35272
  ClientHeight = 470
  ClientWidth = 831
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesigned
  DesignSize = (
    831
    470)
  PixelsPerInch = 96
  TextHeight = 13
  object cxGrid1: TcxGrid
    Left = 8
    Top = 57
    Width = 529
    Height = 361
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 0
    object tvSource: TcxGridDBTableView
      Navigator.Buttons.CustomButtons = <>
      OnFocusedRecordChanged = tvSourceFocusedRecordChanged
      DataController.DataSource = dmMain.dsSource
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <
        item
          Kind = skCount
          FieldName = 'ExamineeName'
        end>
      DataController.Summary.SummaryGroups = <>
      OptionsData.Deleting = False
      OptionsData.Inserting = False
      OptionsSelection.CellSelect = False
      OptionsView.Footer = True
      object clmnSourceExamineeNo: TcxGridDBColumn
        Caption = #20934#32771#35777#21495
        DataBinding.FieldName = 'ExamineeID'
        Width = 99
      end
      object clmnSourceExamineeName: TcxGridDBColumn
        Caption = #22995#21517
        DataBinding.FieldName = 'ExamineeName'
      end
      object tvSourceSex: TcxGridDBColumn
        Caption = #24615#21035
        DataBinding.FieldName = 'ExamineeSex'
      end
      object clmnSourceIP: TcxGridDBColumn
        DataBinding.FieldName = 'IP'
      end
      object clmnSourcePort: TcxGridDBColumn
        DataBinding.FieldName = 'Port'
        Width = 51
      end
      object clmnSourceStatus: TcxGridDBColumn
        Caption = #29366#24577
        DataBinding.FieldName = 'Status'
      end
      object clmnSourceRemainTime: TcxGridDBColumn
        Caption = #21097#20313#26102#38388
        DataBinding.FieldName = 'RemainTime'
      end
      object clmnSourceTimeStamp: TcxGridDBColumn
        Caption = #32771#35797#26085#26399
        DataBinding.FieldName = 'Stamp'
      end
    end
    object cxGrid1Level1: TcxGridLevel
      GridView = tvSource
    end
  end
  object btnBrowse: TcxButton
    Left = 56
    Top = 424
    Width = 221
    Height = 25
    Anchors = [akLeft, akRight, akBottom]
    Caption = #27983#35272#24211
    TabOrder = 1
    OnClick = btnBrowseClick
  end
  object cxLabel1: TcxLabel
    Left = 16
    Top = 16
    Caption = #23398#26657#19978#25253#24211#65306
  end
  object edtSource: TcxButtonEdit
    Left = 96
    Top = 16
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 3
    OnClick = edtSourceClick
    Width = 473
  end
  object chkOriginal: TcxCheckBox
    Left = 584
    Top = 16
    Caption = #21407#22987#35760#24405
    TabOrder = 4
    Width = 73
  end
  object edtUnCompressedScoreInfo: TJvRichEdit
    Left = 543
    Top = 57
    Width = 273
    Height = 361
    Anchors = [akTop, akRight, akBottom]
    Font.Charset = GB2312_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    SelText = ''
    TabOrder = 5
  end
  object ckbxSingleExam: TcxCheckBox
    Left = 688
    Top = 16
    AutoSize = False
    Caption = #21333#32771#22330#35760#24405
    TabOrder = 6
    Height = 21
    Width = 121
  end
  object OpenDialog1: TOpenDialog
    Left = 520
    Top = 8
  end
end
