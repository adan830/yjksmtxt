object frmEQBUseInfo: TfrmEQBUseInfo
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMaximize]
  Caption = #35797#39064#24211#20351#29992#20449#24687
  ClientHeight = 406
  ClientWidth = 435
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  DesignSize = (
    435
    406)
  PixelsPerInch = 96
  TextHeight = 13
  object grdSelectTable: TcxGrid
    Left = 8
    Top = 16
    Width = 419
    Height = 351
    Anchors = [akLeft, akTop, akRight, akBottom]
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = 14
    Font.Name = #23435#20307
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    object grdSelectTableDBTableView1: TcxGridDBTableView
      Navigator.Buttons.CustomButtons = <>
      Navigator.Buttons.First.Visible = False
      Navigator.Buttons.PriorPage.Visible = False
      Navigator.Buttons.Prior.Visible = False
      Navigator.Buttons.Next.Visible = False
      Navigator.Buttons.NextPage.Visible = False
      Navigator.Buttons.Last.Visible = False
      Navigator.Buttons.Append.Hint = #28155#21152
      Navigator.Buttons.Delete.Hint = #21024#38500
      Navigator.Buttons.Edit.Hint = #20462#25913
      Navigator.Buttons.Edit.Visible = True
      Navigator.Buttons.Post.Hint = #20445#23384
      Navigator.Buttons.Cancel.Hint = #21462#28040
      Navigator.Buttons.Refresh.Visible = False
      Navigator.Buttons.SaveBookmark.Visible = False
      Navigator.Buttons.GotoBookmark.Visible = False
      Navigator.Buttons.Filter.Visible = False
      Navigator.Visible = True
      DataController.DataSource = dsStUseInfo
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <>
      DataController.Summary.SummaryGroups = <>
      EditForm.DefaultColumnCount = 1
      EditForm.DefaultStretch = fsHorizontal
      OptionsBehavior.NavigatorHints = True
      OptionsBehavior.EditMode = emInplaceEditForm
      OptionsBehavior.ExpandMasterRowOnDblClick = False
      OptionsCustomize.ColumnFiltering = False
      OptionsCustomize.ColumnGrouping = False
      OptionsCustomize.ColumnHidingOnGrouping = False
      OptionsCustomize.ColumnMoving = False
      OptionsCustomize.ColumnSorting = False
      OptionsData.Appending = True
      OptionsSelection.InvertSelect = False
      OptionsView.FocusRect = False
      OptionsView.ShowEditButtons = gsebForFocusedRecord
      OptionsView.ColumnAutoWidth = True
      OptionsView.GroupByBox = False
      OptionsView.HeaderAutoHeight = True
      OptionsView.Indicator = True
      object grdSelectTableDBTableView1DBColumn: TcxGridDBColumn
        DataBinding.FieldName = #21517#31216
        PropertiesClassName = 'TcxTextEditProperties'
        VisibleForEditForm = bTrue
        Width = 200
      end
      object grdSelectTableDBTableView1DBColumn1: TcxGridDBColumn
        DataBinding.FieldName = #26159#21542#36873#29992
        PropertiesClassName = 'TcxCheckBoxProperties'
        Properties.FullFocusRect = True
        VisibleForEditForm = bTrue
      end
    end
    object grdSelectTableLevel1: TcxGridLevel
      GridView = grdSelectTableDBTableView1
    end
  end
  object btnExport: TcxButton
    Left = 8
    Top = 377
    Width = 91
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = #23548#20986#32771#35797#24211
    TabOrder = 1
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = 14
    Font.Name = #23435#20307
    Font.Style = []
    ParentFont = False
    OnClick = btnExportClick
  end
  object cbbDataFolder: TcxShellComboBox
    Left = 105
    Top = 379
    Hint = 
      #40664#35748#20026#26381#21153#22120#31243#24207#25152#22312#25991#20214#22841#65292#23384#25918#32771#22330#35760#24405#13#10#23384#25918#32771#29983#30456#29255#25991#20214#65288#22312'Photos'#23376#30446#24405#19979#65289#13#10#23384#25918#32771#29983#25991#20214#22841#25968#25454#25991#20214#65288#22312'databa' +
      'k'#23376#30446#24405#19979#65289
    Anchors = [akLeft, akRight, akBottom]
    ParentFont = False
    ParentShowHint = False
    Properties.DropDownWidth = 500
    Properties.ShowFullPath = sfpAlways
    ShowHint = True
    Style.Font.Charset = DEFAULT_CHARSET
    Style.Font.Color = clWindowText
    Style.Font.Height = 14
    Style.Font.Name = #23435#20307
    Style.Font.Style = []
    Style.Shadow = True
    Style.TextColor = clBlue
    Style.PopupBorderStyle = epbsFlat
    Style.IsFontAssigned = True
    StyleFocused.TextColor = clRed
    TabOrder = 2
    Width = 322
  end
  object dsStUseInfo: TDataSource
    DataSet = dmSetQuestion.stSelect
    Left = 160
    Top = 176
  end
end
