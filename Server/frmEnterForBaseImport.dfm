object EnterForBaseImport: TEnterForBaseImport
  Left = 0
  Top = 0
  Caption = 'EnterForBaseImport'
  ClientHeight = 471
  ClientWidth = 579
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesigned
  OnCreate = FormCreate
  DesignSize = (
    579
    471)
  PixelsPerInch = 96
  TextHeight = 13
  object lbl6: TLabel
    Left = 16
    Top = 56
    Width = 120
    Height = 16
    Caption = #23548#20837#32771#29983#21495#33539#22260#65306#12288#12288
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    Visible = False
  end
  object lbl8: TLabel
    Left = 152
    Top = 61
    Width = 48
    Height = 13
    Caption = #36215#21495#65306#12288
    Visible = False
  end
  object lbl9: TLabel
    Left = 308
    Top = 61
    Width = 72
    Height = 13
    Caption = #32456#27490#21495#65306#12288#12288
    Visible = False
  end
  object lbl7: TLabel
    Left = 298
    Top = 138
    Width = 180
    Height = 16
    Caption = #32771#35797#25104#32489#24211#29616#26377#32771#29983#20449#24687#65306#12288#12288#12288
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object lbl1: TLabel
    Left = 20
    Top = 138
    Width = 132
    Height = 16
    Caption = #25253#21517#24211#32771#29983#20449#24687#65306#12288#12288#12288
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object lbl5: TLabel
    Left = 58
    Top = 34
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
    Left = 392
    Top = 96
    Width = 121
    Height = 25
    Caption = #23548#20837#21040#32771#35797#31995#32479
    TabOrder = 0
    OnClick = btnAllImportClick
  end
  object medtStart: TMaskEdit
    Left = 192
    Top = 53
    Width = 101
    Height = 24
    EditMask = '00000000000;1;_'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    MaxLength = 11
    ParentFont = False
    TabOrder = 1
    Text = '           '
    Visible = False
  end
  object medtEnd: TMaskEdit
    Left = 360
    Top = 53
    Width = 105
    Height = 24
    EditMask = '00000000000;1;_'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    MaxLength = 11
    ParentFont = False
    TabOrder = 2
    Text = '           '
    Visible = False
  end
  object grdAllExaminees: TcxGrid
    Left = 308
    Top = 160
    Width = 215
    Height = 298
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
    end
    object grdlvlAllExaminees: TcxGridLevel
      GridView = tvExaminees
    end
  end
  object grdEnterFor: TcxGrid
    Left = 20
    Top = 160
    Width = 224
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
    Height = 82
    Width = 563
  end
  object dlgOpen1: TOpenDialog
    Filter = 'DBF'#25991#20214'|*.dbf'
    Left = 488
    Top = 8
  end
  object dsksxxk: TDataSource
    DataSet = setExamineeBase
    Left = 352
    Top = 8
  end
  object connkwxxk: TADOConnection
    ConnectionString = 
      'Provider=MSDASQL.1;Persist Security Info=False;Extended Properti' +
      'es="DSN=Visual FoxPro Database;UID=;SourceDB=d:\yjksmtxt\debug\b' +
      'in;SourceType=DBF;Exclusive=No;BackgroundFetch=Yes;Collate=Machi' +
      'ne;Null=Yes;Deleted=Yes;"'
    KeepConnection = False
    LoginPrompt = False
    Provider = 'MSDASQL.1'
    Left = 392
    Top = 8
  end
  object tblkwxxk: TADOTable
    Connection = connkwxxk
    CursorType = ctStatic
    TableName = 'kwxtdck'
    Left = 424
    Top = 8
  end
  object dskwxxk: TDataSource
    DataSet = tblkwxxk
    Left = 456
    Top = 8
  end
  object setExamineeBase: TADODataSet
    Connection = dmServer.connExamineeBase
    CursorType = ctStatic
    OnCalcFields = setExamineeBaseCalcFields
    CommandText = 'select  *  from '#32771#29983#20449#24687
    Parameters = <>
    Left = 216
    Top = 8
    object wdstrngfldExamineeBaseExamineeID: TWideStringField
      FieldName = 'ExamineeID'
      Size = 24
    end
    object wdstrngfldExamineeBaseExamineeName: TWideStringField
      FieldName = 'ExamineeName'
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
  end
end
