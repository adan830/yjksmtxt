object fraTree: TfraTree
  Left = 0
  Top = 0
  Width = 155
  Height = 334
  TabOrder = 0
  TabStop = True
  object grdStList: TcxGrid
    Left = 0
    Top = 41
    Width = 155
    Height = 293
    Align = alClient
    TabOrder = 0
    object gvStList: TcxGridTableView
      Navigator.Buttons.CustomButtons = <>
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <>
      DataController.Summary.SummaryGroups = <>
      OptionsCustomize.ColumnFiltering = False
      OptionsData.Inserting = False
      OptionsSelection.HideFocusRectOnExit = False
      OptionsView.ColumnAutoWidth = True
      OptionsView.GroupByBox = False
      object colSelected: TcxGridColumn
        Caption = #36873#25321
        DataBinding.ValueType = 'Boolean'
        PropertiesClassName = 'TcxCheckBoxProperties'
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
        Width = 32
      end
      object gvStListst_no: TcxGridColumn
        Caption = #39064#21495
        DataBinding.ValueType = 'WideString'
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
      end
    end
    object grdStListLevel1: TcxGridLevel
      GridView = gvStList
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 155
    Height = 41
    Align = alTop
    TabOrder = 1
    object btnSaveSelect: TcxButton
      Left = 79
      Top = 10
      Width = 66
      Height = 25
      Caption = #20445#23384#36873#25321
      TabOrder = 0
    end
    object btnSelect: TcxButton
      Left = 8
      Top = 10
      Width = 65
      Height = 25
      Caption = #36873#25321
      TabOrder = 1
    end
  end
end
