object ExamineesImport: TExamineesImport
  Left = 0
  Top = 0
  BorderIcons = []
  BorderStyle = bsToolWindow
  Caption = #32771#29983#36873#21462
  ClientHeight = 415
  ClientWidth = 695
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWhite
  Font.Height = -19
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 23
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 695
    Height = 415
    Align = alClient
    Caption = 'Panel1'
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentBackground = False
    ParentFont = False
    ShowCaption = False
    TabOrder = 0
    DesignSize = (
      695
      415)
    object btnSave: TCnSpeedButton
      Left = 388
      Top = 372
      Width = 115
      Height = 30
      Anchors = [akRight]
      Color = 15966293
      DownBold = False
      FlatBorder = False
      HotTrackBold = False
      HotTrackColor = 16551233
      ModernBtnStyle = bsFlat
      Caption = #20445#23384
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = 14
      Font.Name = #23435#20307
      Font.Style = [fsBold]
      Margin = 4
      ParentFont = False
      OnClick = btnSaveClick
    end
    object btnExit: TCnSpeedButton
      Left = 548
      Top = 372
      Width = 115
      Height = 30
      Anchors = [akRight]
      Color = 15966293
      DownBold = False
      FlatBorder = False
      HotTrackBold = False
      HotTrackColor = 16551233
      ModernBtnStyle = bsFlat
      Caption = #36864#20986
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = 14
      Font.Name = #23435#20307
      Font.Style = [fsBold]
      Margin = 4
      ParentFont = False
      OnClick = btnExitClick
    end
    object btnAdd: TCnSpeedButton
      Left = 356
      Top = 103
      Width = 61
      Height = 30
      Anchors = [akRight]
      Color = 15966293
      DownBold = False
      FlatBorder = False
      HotTrackBold = False
      HotTrackColor = 16551233
      ModernBtnStyle = bsFlat
      Caption = #28155#21152
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = 14
      Font.Name = #23435#20307
      Font.Style = [fsBold]
      Margin = 4
      ParentFont = False
      OnClick = btnAddClick
    end
    object btnDelete: TCnSpeedButton
      Left = 356
      Top = 163
      Width = 61
      Height = 30
      Anchors = [akRight]
      Color = 15966293
      DownBold = False
      FlatBorder = False
      HotTrackBold = False
      HotTrackColor = 16551233
      ModernBtnStyle = bsFlat
      Caption = #21024#38500
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = 14
      Font.Name = #23435#20307
      Font.Style = [fsBold]
      Margin = 4
      ParentFont = False
      OnClick = btnDeleteClick
    end
    object lbl2: TcxLabel
      Left = 440
      Top = 17
      Caption = #24050#36873#26412#22330#32771#29983#65306
    end
    object lbl1: TcxLabel
      Left = 8
      Top = 17
      Caption = #24635#32771#29983#24211#65306
    end
    object grdExaminees: TcxGrid
      Left = 8
      Top = 40
      Width = 345
      Height = 313
      DragMode = dmAutomatic
      TabOrder = 2
      object tvExaminees: TcxGridDBTableView
        DragMode = dmAutomatic
        OnDragDrop = tvExamineesDragDrop
        OnDragOver = tvExamineesDragOver
        Navigator.Buttons.CustomButtons = <>
        DataController.DataSource = dsCDSExaminees
        DataController.Summary.DefaultGroupSummaryItems = <>
        DataController.Summary.FooterSummaryItems = <>
        DataController.Summary.SummaryGroups = <>
        OptionsCustomize.ColumnGrouping = False
        OptionsData.Deleting = False
        OptionsData.Editing = False
        OptionsData.Inserting = False
        OptionsSelection.CellSelect = False
        OptionsSelection.MultiSelect = True
        OptionsView.GroupByBox = False
        object clmnExamineesDecryptedID: TcxGridDBColumn
          Caption = #20934#32771#35777#21495
          DataBinding.FieldName = 'DecryptedID'
          Width = 78
        end
        object clmnExamineesDecryptedName: TcxGridDBColumn
          Caption = #22995#21517
          DataBinding.FieldName = 'DecryptedName'
          Width = 60
        end
        object tvExamineesColumnDecryptedSex: TcxGridDBColumn
          Caption = #24615#21035
          DataBinding.FieldName = 'DecryptedSex'
        end
        object clmnExamineesDecryptedStatus: TcxGridDBColumn
          Caption = #29366#24577
          DataBinding.FieldName = 'DecryptedStatus'
          Width = 39
        end
        object clmnExamineesDecryptedRemainTime: TcxGridDBColumn
          Caption = #21097#20313#26102#38388
          DataBinding.FieldName = 'DecryptedRemainTime'
        end
        object clmnExamineesDecryptedTimeStamp: TcxGridDBColumn
          Caption = #32771#35797#26085#26399
          DataBinding.FieldName = 'DecryptedTimeStamp'
        end
      end
      object cxgrdlvlGrid1Level1: TcxGridLevel
        GridView = tvExaminees
      end
    end
    object cxGrid1: TcxGrid
      Left = 423
      Top = 40
      Width = 254
      Height = 313
      DragMode = dmAutomatic
      TabOrder = 3
      object tvCDSTemp: TcxGridDBTableView
        DragMode = dmAutomatic
        OnDragDrop = tvCDSTempDragDrop
        OnDragOver = tvCDSTempDragOver
        Navigator.Buttons.CustomButtons = <>
        DataController.DataSource = dsCDSTemp
        DataController.Summary.DefaultGroupSummaryItems = <>
        DataController.Summary.FooterSummaryItems = <>
        DataController.Summary.SummaryGroups = <>
        OptionsCustomize.ColumnGrouping = False
        OptionsData.Deleting = False
        OptionsData.Editing = False
        OptionsData.Inserting = False
        OptionsSelection.CellSelect = False
        OptionsSelection.MultiSelect = True
        OptionsView.GroupByBox = False
      end
      object cxgrdlvl1: TcxGridLevel
        GridView = tvCDSTemp
      end
    end
  end
  object dsCDSExaminees: TDataSource
    DataSet = setExamineeBase
    Left = 464
    Top = 8
  end
  object cdsTemp: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 136
    Top = 8
  end
  object dsCDSTemp: TDataSource
    DataSet = cdsTemp
    Left = 200
    Top = 8
  end
  object setExamineeBase: TADODataSet
    Connection = dmServer.connExamineeBase
    CursorType = ctStatic
    OnCalcFields = setExamineeBaseCalcFields
    CommandText = 'select  *  from '#32771#29983#20449#24687
    Parameters = <>
    Left = 352
    Top = 8
    object wdstrngfldExamineeBaseExamineeID: TWideStringField
      FieldName = 'ExamineeID'
      Size = 24
    end
    object wdstrngfldExamineeBaseExamineeName: TWideStringField
      FieldName = 'ExamineeName'
    end
    object setExamineeBaseExamineeSex: TStringField
      FieldName = 'ExamineeSex'
    end
    object wdstrngfldExamineeBaseStatus: TWideStringField
      FieldName = 'Status'
    end
    object strngfldExamineeBaseDecryptedID: TStringField
      FieldKind = fkCalculated
      FieldName = 'DecryptedID'
      Size = 11
      Calculated = True
    end
    object strngfldExamineeBaseDecryptedName: TStringField
      FieldKind = fkCalculated
      FieldName = 'DecryptedName'
      Size = 8
      Calculated = True
    end
    object setExamineeBaseDecryptedSex: TStringField
      DisplayWidth = 2
      FieldKind = fkCalculated
      FieldName = 'DecryptedSex'
      Calculated = True
    end
    object strngfldExamineeBaseDecryptedStatus: TStringField
      FieldKind = fkCalculated
      FieldName = 'DecryptedStatus'
      Size = 2
      Calculated = True
    end
    object strngfldExamineeBaseDecryptedRemainTime: TStringField
      FieldKind = fkCalculated
      FieldName = 'DecryptedRemainTime'
      Size = 10
      Calculated = True
    end
    object strngfldExamineeBaseDecryptedTimeStamp: TStringField
      FieldKind = fkCalculated
      FieldName = 'DecryptedTimeStamp'
      Calculated = True
    end
    object wdstrngfldExamineeBaseRemainTime: TWideStringField
      FieldName = 'RemainTime'
      Size = 24
    end
    object wdstrngfldExamineeBaseTimeStamp: TWideStringField
      FieldName = 'Stamp'
    end
  end
end
