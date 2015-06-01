object frmEQBUseInfo: TfrmEQBUseInfo
  Left = 0
  Top = 0
  Caption = #35797#39064#24211#20351#29992#20449#24687
  ClientHeight = 323
  ClientWidth = 596
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  DesignSize = (
    596
    323)
  PixelsPerInch = 96
  TextHeight = 13
  object grdSelectTable: TcxGrid
    Left = 24
    Top = 16
    Width = 564
    Height = 257
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 0
    object grdSelectTableDBTableView1: TcxGridDBTableView
      NavigatorButtons.ConfirmDelete = False
      DataController.DataSource = dsStUseInfo
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <>
      DataController.Summary.SummaryGroups = <>
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
    Left = 48
    Top = 290
    Width = 75
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = #23548#20986#39064#24211
    TabOrder = 1
    OnClick = btnExportClick
  end
  object dsStUseInfo: TDataSource
    Left = 512
    Top = 280
  end
end
