object frmScore: TfrmScore
  Left = 0
  Top = 0
  Caption = #27719#24635#25104#32489
  ClientHeight = 454
  ClientWidth = 719
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  DesignSize = (
    719
    454)
  PixelsPerInch = 96
  TextHeight = 13
  object cxGrid1: TcxGrid
    Left = 8
    Top = 32
    Width = 385
    Height = 362
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 0
    object tvscore: TcxGridDBTableView
      Navigator.Buttons.CustomButtons = <>
      OnFocusedRecordChanged = tvscoreFocusedRecordChanged
      DataController.DataSource = dmMain.dsScore
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <
        item
          Kind = skCount
          Column = tvscorestatus
        end>
      DataController.Summary.SummaryGroups = <>
      OptionsData.CancelOnExit = False
      OptionsData.Deleting = False
      OptionsData.DeletingConfirmation = False
      OptionsData.Editing = False
      OptionsData.Inserting = False
      OptionsSelection.CellSelect = False
      OptionsView.Footer = True
      object tvscoreExamineeID: TcxGridDBColumn
        Caption = #20934#32771#21495
        DataBinding.FieldName = 'ExamineeID'
      end
      object tvscoreName: TcxGridDBColumn
        Caption = #22995#21517
        DataBinding.FieldName = 'ExamineeName'
      end
      object tvscorexSex: TcxGridDBColumn
        Caption = #24615#21035
        DataBinding.FieldName = 'ExamineeSex'
      end
      object tvscorestatus: TcxGridDBColumn
        Caption = #29366#24577
        DataBinding.FieldName = 'status'
      end
      object tvscoreRemainTime: TcxGridDBColumn
        Caption = #21097#20313#26102#38388
        DataBinding.FieldName = 'RemainTime'
      end
      object tvscorezf: TcxGridDBColumn
        Caption = #24635#20998
        DataBinding.FieldName = 'Score'
      end
      object tvsScoreInfo: TcxGridDBColumn
        Caption = #35780#20998#20449#24687
        DataBinding.FieldName = 'ScoreInfo'
        PropertiesClassName = 'TcxBlobEditProperties'
        Visible = False
      end
    end
    object cxGrid1Level1: TcxGridLevel
      GridView = tvscore
    end
  end
  object cxButton1: TcxButton
    Left = 16
    Top = 8
    Width = 75
    Height = 25
    Caption = #25171#24320
    TabOrder = 1
    OnClick = cxButton1Click
  end
  object cxButton2: TcxButton
    Left = 208
    Top = 8
    Width = 75
    Height = 25
    Caption = 'cxButton2'
    TabOrder = 2
  end
  object edtUnCompressedScoreInfo: TJvRichEdit
    Left = 399
    Top = 32
    Width = 306
    Height = 361
    Anchors = [akTop, akRight, akBottom]
    Font.Charset = GB2312_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    SelText = ''
    TabOrder = 3
  end
end
