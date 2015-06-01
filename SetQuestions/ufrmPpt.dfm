inherited frmPpt: TfrmPpt
  Left = 166
  Top = 86
  Caption = 'frmPpt'
  ClientHeight = 614
  ClientWidth = 787
  OldCreateOrder = True
  ExplicitWidth = 795
  ExplicitHeight = 648
  PixelsPerInch = 96
  TextHeight = 13
  inherited Panel1: TPanel
    Width = 787
    ExplicitWidth = 787
    inherited lblTitle: TcxLabel
      Style.IsFontAssigned = True
      ExplicitWidth = 785
    end
  end
  inherited Panel3: TPanel
    Width = 787
    Height = 573
    ExplicitWidth = 787
    ExplicitHeight = 573
    inherited Panel2: TPanel
      Left = 221
      Width = 565
      Height = 530
      AutoSize = True
      ExplicitLeft = 221
      ExplicitWidth = 565
      ExplicitHeight = 530
      inherited grpStUseInfo: TcxCheckGroup
        ExplicitWidth = 559
        Width = 559
      end
      inherited edtStNo: TcxTextEdit
        TabOrder = 3
      end
      object cxLabel2: TcxLabel [2]
        Left = 6
        Top = 77
        Caption = #35797#39064#35201#27714#65306
      end
      inherited edtItemDifficulty: TcxTextEdit
        TabOrder = 7
      end
      inherited edtRedactionTime: TcxTextEdit
        TabOrder = 9
      end
      object edtEQContent: TJvRichEdit
        Left = 6
        Top = 96
        Width = 553
        Height = 103
        Anchors = [akLeft, akTop, akRight, akBottom]
        BevelKind = bkFlat
        Font.Charset = GB2312_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = #23435#20307
        Font.Style = []
        ParentFont = False
        SelText = ''
        TabOrder = 5
      end
      object grdGradeInfo: TcxGrid
        Left = 6
        Top = 208
        Width = 553
        Height = 218
        Anchors = [akLeft, akRight, akBottom]
        TabOrder = 4
        object tvGradeInfo: TcxGridTableView
          Navigator.Buttons.CustomButtons = <>
          Navigator.Buttons.First.Visible = False
          Navigator.Buttons.PriorPage.Visible = False
          Navigator.Buttons.NextPage.Visible = False
          Navigator.Buttons.Last.Visible = False
          Navigator.Buttons.Cancel.Visible = True
          Navigator.Buttons.Refresh.Visible = False
          Navigator.Buttons.SaveBookmark.Visible = False
          Navigator.Buttons.GotoBookmark.Visible = False
          Navigator.Buttons.Filter.Enabled = False
          Navigator.Buttons.Filter.Visible = False
          Navigator.Visible = True
          DataController.Summary.DefaultGroupSummaryItems = <>
          DataController.Summary.FooterSummaryItems = <>
          DataController.Summary.SummaryGroups = <>
          OptionsBehavior.FocusFirstCellOnNewRecord = True
          OptionsBehavior.GoToNextCellOnEnter = True
          OptionsBehavior.FocusCellOnCycle = True
          OptionsCustomize.ColumnFiltering = False
          OptionsCustomize.ColumnGrouping = False
          OptionsCustomize.ColumnMoving = False
          OptionsCustomize.ColumnSorting = False
          OptionsData.Appending = True
          OptionsSelection.CellSelect = False
          OptionsView.CellAutoHeight = True
          OptionsView.GroupByBox = False
          Styles.ContentOdd = cxStyle5
          Styles.StyleSheet = GridTableViewStyleSheetDevExpress
          object tvGradeInfoColumn1: TcxGridColumn
            Caption = #32534#21495
            SortIndex = 0
            SortOrder = soAscending
            Width = 48
          end
          object tvGradeInfoColumn2: TcxGridColumn
            Caption = #30693#35782#28857
            PropertiesClassName = 'TcxLookupComboBoxProperties'
            Properties.KeyFieldNames = #31867#22411
            Properties.ListColumns = <
              item
                FieldName = #31867#22411
              end
              item
                FieldName = #31867#22411#21517
              end>
            Properties.ListFieldIndex = 1
            Properties.ListSource = PointDs
            Width = 152
          end
          object tvGradeInfoColumn3: TcxGridColumn
            Caption = #23545#35937
            Width = 139
          end
          object tvGradeInfoColumn4: TcxGridColumn
            Caption = #20540
            Width = 66
          end
          object tvGradeInfoColumn5: TcxGridColumn
            Caption = #35797#39064#35828#26126
            Width = 170
          end
          object tvGradeInfoColumn6: TcxGridColumn
            Caption = #20998#20540
            Width = 40
          end
          object tvGradeInfoColumn7: TcxGridColumn
            Caption = #20851#31995
            Width = 80
          end
          object tvGradeInfoColumn8: TcxGridColumn
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Caption = #21462#20540
                Default = True
                Kind = bkText
              end>
            Properties.ViewStyle = vsButtonsOnly
            Properties.OnButtonClick = tvGradeInfoColumn8PropertiesButtonClick
          end
        end
        object grdGradeInfoLevel1: TcxGridLevel
          GridView = tvGradeInfo
        end
      end
      object cxgrpbx1: TcxGroupBox
        Left = 6
        Top = 432
        Anchors = [akLeft, akRight, akBottom]
        Caption = ' '#27979#35797#25991#26723'    '
        TabOrder = 6
        DesignSize = (
          553
          92)
        Height = 92
        Width = 553
        object bedtAnswerFile: TcxButtonEdit
          Left = 113
          Top = 15
          Anchors = [akRight, akBottom]
          Properties.Buttons = <
            item
              Default = True
              Kind = bkEllipsis
            end>
          Properties.ReadOnly = True
          Properties.OnButtonClick = bedtAnswerFilePropertiesButtonClick
          TabOrder = 0
          Width = 416
        end
        object btnFileExport: TcxButton
          Left = 296
          Top = 52
          Width = 108
          Height = 25
          Anchors = [akRight, akBottom]
          Caption = #23548#20986#21407#22987#25991#26723
          TabOrder = 1
          OnClick = btnFileExportClick
        end
        object btnFileImport: TcxButton
          Left = 424
          Top = 52
          Width = 107
          Height = 25
          Anchors = [akRight, akBottom]
          Caption = #23548#20837#21407#22987#25991#26723
          TabOrder = 2
          OnClick = btnFileImportClick
        end
        object btnTest: TcxButton
          Left = 91
          Top = 51
          Width = 104
          Height = 25
          Anchors = [akRight, akBottom]
          Caption = #27979#35797
          Enabled = False
          TabOrder = 3
          OnClick = btnTestClick
        end
        object cxLabel3: TcxLabel
          Left = 17
          Top = 19
          Anchors = [akRight, akBottom]
          Caption = 'Excel'#31572#26696#25991#20214#65306
        end
      end
    end
    inherited dxDockSite2: TdxDockSite
      Left = 786
      Height = 530
      ExplicitLeft = 786
      ExplicitHeight = 530
      DockingType = 5
      OriginalWidth = 0
      OriginalHeight = 530
    end
    inherited Panel4: TPanel
      Top = 531
      Width = 785
      ExplicitTop = 531
      ExplicitWidth = 785
      inherited btnAppend: TcxButton
        Left = 296
        Top = 6
        ExplicitLeft = 296
        ExplicitTop = 6
      end
      inherited btnModify: TcxButton
        Left = 377
        Top = 6
        ExplicitLeft = 377
        ExplicitTop = 6
      end
      inherited btnDelete: TcxButton
        Left = 458
        Top = 6
        ExplicitLeft = 458
        ExplicitTop = 6
      end
      inherited btnSave: TcxButton
        Left = 543
        Top = 6
        ExplicitLeft = 543
        ExplicitTop = 6
      end
      inherited btnCancel: TcxButton
        Left = 624
        Top = 6
        ExplicitLeft = 624
        ExplicitTop = 6
      end
      inherited btnExit: TcxButton
        Left = 705
        Top = 6
        ExplicitLeft = 705
        ExplicitTop = 6
      end
    end
    inherited dxDockSite1: TdxDockSite
      Width = 220
      Height = 530
      ExplicitWidth = 220
      DockingType = 5
      OriginalWidth = 220
      OriginalHeight = 578
      inherited dxLayoutDockSite1: TdxLayoutDockSite
        Width = 220
        Height = 530
        ExplicitWidth = 220
        ExplicitHeight = 530
        DockingType = 0
        OriginalWidth = 220
        OriginalHeight = 200
      end
      inherited dxDockPanel1: TdxDockPanel
        Width = 220
        Height = 530
        Caption = #35797#39064#36873#25321#65306
        ExplicitWidth = 220
        ExplicitHeight = 530
        DockingType = 0
        OriginalWidth = 220
        OriginalHeight = 140
        inherited fraTree1: TfraTree
          Width = 216
          Height = 506
          ExplicitWidth = 216
          ExplicitHeight = 506
          inherited grdStList: TcxGrid
            Width = 216
            Height = 465
            ExplicitWidth = 216
            ExplicitHeight = 465
            inherited gvStList: TcxGridTableView
              inherited colSelected: TcxGridColumn
                Width = 30
              end
              inherited gvStListst_no: TcxGridColumn
                Width = 67
              end
            end
          end
          inherited Panel1: TPanel
            Width = 216
            ExplicitWidth = 216
          end
        end
      end
    end
  end
  inherited dxDockingManager1: TdxDockingManager
    Left = 720
    PixelsPerInch = 96
  end
  object OpenDialog1: TOpenDialog [3]
    Left = 632
    Top = 8
  end
  inherited cxEditRepository1: TcxEditRepository
    Left = 673
  end
  inherited qryPoint: TADOQuery
    SQL.Strings = (
      'select * from Ppt'#30693#35782#28857)
    Left = 472
  end
  inherited PointDs: TDataSource
    Left = 520
  end
  inherited cxStyleRepository1: TcxStyleRepository
    PixelsPerInch = 96
    inherited GridTableViewStyleSheetDevExpress: TcxGridTableViewStyleSheet
      BuiltIn = True
    end
  end
  inherited styleControllerEdit: TcxEditStyleController
    PixelsPerInch = 96
  end
end
