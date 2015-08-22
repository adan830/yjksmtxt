object frmEQBUseInfo: TfrmEQBUseInfo
  Left = 0
  Top = 0
  Caption = #35797#39064#24211#20351#29992#20449#24687
  ClientHeight = 406
  ClientWidth = 670
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  DesignSize = (
    670
    406)
  PixelsPerInch = 96
  TextHeight = 13
  object grdSelectTable: TcxGrid
    Left = 8
    Top = 16
    Width = 638
    Height = 351
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 0
    object grdSelectTableDBTableView1: TcxGridDBTableView
      Navigator.Buttons.CustomButtons = <>
      DataController.DataSource = dsStUseInfo
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <>
      DataController.Summary.SummaryGroups = <>
      OptionsBehavior.FocusFirstCellOnNewRecord = True
      OptionsData.Appending = True
      object grdSelectTableDBTableView1DBColumn: TcxGridDBColumn
        DataBinding.FieldName = #21517#31216
      end
      object grdSelectTableDBTableView1DBColumn1: TcxGridDBColumn
        DataBinding.FieldName = #26159#21542#36873#29992
      end
      object grdSelectTableDBTableView1DBColumn2: TcxGridDBColumn
        DataBinding.FieldName = #21333#39033#36873#25321#39064
      end
      object grdSelectTableDBTableView1DBColumn3: TcxGridDBColumn
        DataBinding.FieldName = #22810#39033#36873#25321#39064
      end
      object grdSelectTableDBTableView1DBColumn4: TcxGridDBColumn
        DataBinding.FieldName = #25171#23383#39064
      end
      object grdSelectTableDBTableView1WIN: TcxGridDBColumn
        DataBinding.FieldName = 'WIN'#25805#20316#39064
        PropertiesClassName = 'TcxRichEditProperties'
      end
      object grdSelectTableDBTableView1Word: TcxGridDBColumn
        DataBinding.FieldName = 'Word'#25805#20316#39064
        PropertiesClassName = 'TcxBlobEditProperties'
        Properties.BlobEditKind = bekBlob
      end
      object grdSelectTableDBTableView1Excel: TcxGridDBColumn
        DataBinding.FieldName = 'Excel'#25805#20316#39064
      end
      object grdSelectTableDBTableView1Ppt: TcxGridDBColumn
        DataBinding.FieldName = 'Ppt'#25805#20316#39064
      end
    end
    object grdSelectTableLevel1: TcxGridLevel
      GridView = grdSelectTableDBTableView1
    end
  end
  object btnExport: TcxButton
    Left = 239
    Top = 375
    Width = 91
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = #23548#20986#32771#35797#24211
    TabOrder = 1
    OnClick = btnExportClick
  end
  object cbbDataFolder: TcxShellComboBox
    Left = 349
    Top = 377
    Hint = 
      #40664#35748#20026#26381#21153#22120#31243#24207#25152#22312#25991#20214#22841#65292#23384#25918#32771#22330#35760#24405#13#10#23384#25918#32771#29983#30456#29255#25991#20214#65288#22312'Photos'#23376#30446#24405#19979#65289#13#10#23384#25918#32771#29983#25991#20214#22841#25968#25454#25991#20214#65288#22312'databa' +
      'k'#23376#30446#24405#19979#65289
    ParentShowHint = False
    Properties.DropDownWidth = 500
    Properties.ShowFullPath = sfpAlways
    ShowHint = True
    Style.Shadow = True
    Style.TextColor = clBlue
    Style.PopupBorderStyle = epbsFlat
    StyleFocused.TextColor = clRed
    TabOrder = 2
    Width = 297
  end
  object dsStUseInfo: TDataSource
    DataSet = dmSetQuestion.stSelect
    Left = 536
    Top = 176
  end
end
