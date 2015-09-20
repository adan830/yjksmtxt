object EnterForBaseImport: TEnterForBaseImport
  Left = 0
  Top = 0
  Caption = 'EnterForBaseImport'
  ClientHeight = 471
  ClientWidth = 575
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = 14
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesigned
  OnCreate = FormCreate
  DesignSize = (
    575
    471)
  PixelsPerInch = 96
  TextHeight = 14
  object lbl6: TLabel
    Left = 300
    Top = 141
    Width = 120
    Height = 13
    Caption = #23548#20837#32771#29983#21495#33539#22260#65306#12288#12288
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = 14
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    Visible = False
  end
  object lbl8: TLabel
    Left = 300
    Top = 173
    Width = 60
    Height = 14
    Caption = #36215#22987#21495#65306#12288
    Visible = False
  end
  object lbl9: TLabel
    Left = 300
    Top = 220
    Width = 72
    Height = 14
    Caption = #32456#27490#21495#65306#12288#12288
    Visible = False
  end
  object lbl7: TLabel
    Left = 323
    Top = 138
    Width = 180
    Height = 13
    Caption = #32771#35797#25104#32489#24211#29616#26377#32771#29983#20449#24687#65306#12288#12288#12288
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = 14
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object lbl1: TLabel
    Left = 20
    Top = 138
    Width = 132
    Height = 13
    Caption = #25253#21517#24211#32771#29983#20449#24687#65306#12288#12288#12288
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = 14
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object lbl5: TLabel
    Left = 20
    Top = 74
    Width = 296
    Height = 16
    Caption = #35831#36873#25321#32771#21153#31995#32479#23548#20986#30340#32771#29983#20449#24687#25991#20214'(*.dbf)'#65306'                   '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object btnAllImport: TButton
    Left = 403
    Top = 96
    Width = 121
    Height = 25
    Caption = #23548#20837#21040#32771#35797#31995#32479
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = 14
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    OnClick = btnAllImportClick
  end
  object medtStart: TMaskEdit
    Left = 300
    Top = 193
    Width = 93
    Height = 21
    EditMask = '00000000000;1;_'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = 14
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    MaxLength = 11
    ParentFont = False
    TabOrder = 1
    Text = '           '
    Visible = False
  end
  object medtEnd: TMaskEdit
    Left = 300
    Top = 240
    Width = 93
    Height = 21
    EditMask = '00000000000;1;_'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = 14
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    MaxLength = 11
    ParentFont = False
    TabOrder = 2
    Text = '           '
    Visible = False
  end
  object grdAllExaminees: TcxGrid
    Left = 314
    Top = 160
    Width = 247
    Height = 295
    TabOrder = 3
    object tvExaminees: TcxGridDBTableView
      Navigator.Buttons.CustomButtons = <>
      DataController.DataSource = dsksxxk
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <>
      DataController.Summary.SummaryGroups = <>
      OptionsView.GroupByBox = False
      object clmnExamineesDecryptedID: TcxGridDBColumn
        Caption = #20934#32771#35777#21495
        DataBinding.FieldName = 'DecryptedID'
        Width = 110
      end
      object clmnExamineesDecryptedName: TcxGridDBColumn
        Caption = #22995#21517
        DataBinding.FieldName = 'DecryptedName'
        Width = 89
      end
      object clmnExamineesDecryptedSex: TcxGridDBColumn
        DataBinding.FieldName = #24615#21035
      end
    end
    object grdlvlAllExaminees: TcxGridLevel
      GridView = tvExaminees
    end
  end
  object grdEnterFor: TcxGrid
    Left = 20
    Top = 160
    Width = 261
    Height = 298
    TabOrder = 4
    object gvEnterFor: TcxGridDBTableView
      Navigator.Buttons.CustomButtons = <>
      DataController.DataSource = dskwxxk
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
      object clmnGrid1DBTableView1ExamineeNo: TcxGridDBColumn
        DataBinding.FieldName = #20934#32771#35777#21495
        Width = 121
      end
      object clmnGrid1DBTableView1ExamineeName: TcxGridDBColumn
        DataBinding.FieldName = #22995#21517
        Width = 96
      end
      object gvEnterForColumnExamineeSex: TcxGridDBColumn
        DataBinding.FieldName = #24615#21035
      end
    end
    object grdlvlGrid1Level1: TcxGridLevel
      GridView = gvEnterFor
    end
  end
  object edtBmk: TEdit
    Left = 95
    Top = 96
    Width = 285
    Height = 24
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    TabOrder = 5
  end
  object btn2: TButton
    Left = 20
    Top = 96
    Width = 69
    Height = 25
    Caption = #36873#25321#25991#20214
    TabOrder = 6
    OnClick = btn2Click
  end
  object lblHelp: TcxLabel
    Left = 8
    Top = 8
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = #26412#31383#21475#20219#21153#26159#23558#32771#21153#31995#32479#20013#23548#20986#30340#32771#29983#25253#21517#20449#24687#23548#20837#21040#32771#35797#25104#32489#24211#20013#12290
    ParentFont = False
    Style.BorderStyle = ebsUltraFlat
    Style.Font.Charset = DEFAULT_CHARSET
    Style.Font.Color = clWindowText
    Style.Font.Height = -13
    Style.Font.Name = 'Tahoma'
    Style.Font.Style = []
    Style.Shadow = False
    Style.IsFontAssigned = True
    Properties.Depth = 1
    Properties.PenWidth = 5
    Properties.WordWrap = True
    ExplicitWidth = 656
    Height = 47
    Width = 559
  end
  object dlgOpen1: TOpenDialog
    Filter = 'DBF'#25991#20214'|*.dbf'
    Left = 520
    Top = 8
  end
  object dsksxxk: TDataSource
    DataSet = setExamineeBase
    Left = 216
    Top = 40
  end
  object connkwxxk: TADOConnection
    ConnectionString = 'Provider=MSDASQL.1;Persist Security Info=False;'
    KeepConnection = False
    LoginPrompt = False
    Provider = 'MSDASQL.1'
    Left = 336
    Top = 40
  end
  object tblkwxxk: TADOTable
    Connection = connkwxxk
    CursorType = ctStatic
    TableName = 'kwxtdck'
    Left = 392
    Top = 40
  end
  object dskwxxk: TDataSource
    DataSet = tblkwxxk
    Left = 440
    Top = 40
  end
  object setExamineeBase: TADODataSet
    Connection = dmServer.connExamineeBase
    CursorType = ctStatic
    OnCalcFields = setExamineeBaseCalcFields
    CommandText = 'select  *,ExamineeID as DecryptedID  from '#32771#29983#20449#24687
    IndexName = 'DecryptedID'
    Parameters = <>
    Left = 136
    Top = 40
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
      KeyFields = 'DecryptedID'
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
      FieldKind = fkCalculated
      FieldName = 'DecryptedSex'
      Calculated = True
    end
  end
  object cdsExaminees: TClientDataSet
    Aggregates = <>
    CommandText = 'select  *  from '#32771#29983#20449#24687
    Params = <>
    Left = 40
    Top = 40
  end
end
