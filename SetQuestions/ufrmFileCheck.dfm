object frmFileCheck: TfrmFileCheck
  Left = 0
  Top = 0
  Caption = 'frmFileCheck'
  ClientHeight = 460
  ClientWidth = 643
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object cxGrid1: TcxGrid
    Left = 25
    Top = 24
    Width = 409
    Height = 369
    TabOrder = 0
    object tvFileTable: TcxGridDBTableView
      NavigatorButtons.ConfirmDelete = False
      DataController.DataSource = dsFileTable
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <>
      DataController.Summary.SummaryGroups = <>
      object tvFileTableGuid: TcxGridDBColumn
        DataBinding.FieldName = 'Guid'
      end
      object tvFileTableFileName: TcxGridDBColumn
        DataBinding.FieldName = 'FileName'
      end
      object tvFileTableFilestream: TcxGridDBColumn
        DataBinding.FieldName = 'Filestream'
      end
    end
    object cxGrid1Level1: TcxGridLevel
      GridView = tvFileTable
    end
  end
  object cxButton1: TcxButton
    Left = 288
    Top = 232
    Width = 75
    Height = 25
    Caption = 'cxButton1'
    TabOrder = 1
  end
  object btnCheck: TcxButton
    Left = 456
    Top = 408
    Width = 75
    Height = 25
    Caption = #26816#26597#25991#20214
    TabOrder = 2
    OnClick = btnCheckClick
  end
  object Memo1: TMemo
    Left = 440
    Top = 72
    Width = 169
    Height = 321
    Lines.Strings = (
      'Memo1')
    TabOrder = 3
  end
  object btn1: TcxButton
    Left = 200
    Top = 416
    Width = 75
    Height = 25
    Caption = 'ccccc'
    TabOrder = 4
    OnClick = btn1Click
  end
  object edt1: TEdit
    Left = 48
    Top = 408
    Width = 121
    Height = 21
    TabOrder = 5
    Text = 'edt1'
  end
  object mmo1: TMemo
    Left = 296
    Top = 344
    Width = 185
    Height = 89
    Lines.Strings = (
      'mmo1')
    TabOrder = 6
  end
  object adsFileTable: TADODataSet
    CursorType = ctStatic
    CommandText = 'select * from '#38468#21152#25991#20214
    Parameters = <>
    Left = 496
    Top = 8
  end
  object dsFileTable: TDataSource
    DataSet = adsFileTable
    Left = 448
    Top = 8
  end
end
