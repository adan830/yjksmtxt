inherited frmWin: TfrmWin
  Left = 137
  Top = 61
  Caption = 'frmWin'
  ClientHeight = 614
  ClientWidth = 787
  OldCreateOrder = True
  ExplicitWidth = 803
  ExplicitHeight = 653
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
      DesignSize = (
        565
        530)
      inherited grpStUseInfo: TcxCheckGroup
        Caption = #36873#29992#24773#20917'   '
        TabOrder = 1
        ExplicitWidth = 559
        ExplicitHeight = 44
        Height = 44
        Width = 559
      end
      object cxLabel2: TcxLabel [1]
        Left = 6
        Top = 81
        Caption = #35797#39064#35201#27714#65306
      end
      object grdGradeInfo: TcxGrid [2]
        Left = 8
        Top = 184
        Width = 551
        Height = 226
        Anchors = [akLeft, akRight, akBottom]
        TabOrder = 0
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
          OptionsView.ColumnAutoWidth = True
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
      inherited edtStNo: TcxTextEdit
        TabOrder = 3
      end
      inherited edtItemDifficulty: TcxTextEdit
        TabOrder = 9
      end
      object edtEQContent: TJvRichEdit
        Left = 6
        Top = 104
        Width = 553
        Height = 74
        Anchors = [akLeft, akTop, akRight, akBottom]
        BevelKind = bkFlat
        Font.Charset = GB2312_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = #23435#20307
        Font.Style = []
        ParentFont = False
        SelText = ''
        TabOrder = 4
      end
      object cxgrpbx1: TcxGroupBox
        Left = 12
        Top = 416
        Anchors = [akLeft, akRight, akBottom]
        Caption = '  '#27979#35797#25991#26723'   '
        TabOrder = 6
        DesignSize = (
          547
          108)
        Height = 108
        Width = 547
        object btnPointTest: TcxButton
          Left = 116
          Top = 67
          Width = 73
          Height = 25
          Anchors = [akRight, akBottom]
          Caption = #27979#35797#30693#35782#28857
          TabOrder = 0
          OnClick = btnPointTestClick
        end
        object shlboxPath: TcxShellComboBox
          Left = 175
          Top = 26
          Anchors = [akRight, akBottom]
          Properties.ShowFullPath = sfpAlways
          TabOrder = 1
          Width = 346
        end
        object cxLabel10: TcxLabel
          Left = 13
          Top = 27
          Anchors = [akRight, akBottom]
          Caption = #32771#29983'Windows'#25805#20316#30446#24405#29615#22659#65306
        end
        object btnImportEnviron: TcxButton
          Left = 447
          Top = 69
          Width = 75
          Height = 25
          Anchors = [akRight, akBottom]
          Caption = #23548#20837#29615#22659
          TabOrder = 3
          OnClick = btnImportEnvironClick
        end
        object btnExportEnviron: TcxButton
          Left = 352
          Top = 69
          Width = 75
          Height = 25
          Anchors = [akRight, akBottom]
          Caption = #23548#20986#29615#22659
          TabOrder = 4
          OnClick = btnExportEnvironClick
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
      DesignSize = (
        785
        41)
      inherited btnAppend: TcxButton
        Left = 270
        ExplicitLeft = 270
      end
      inherited btnModify: TcxButton
        Left = 351
        ExplicitLeft = 351
      end
      inherited btnDelete: TcxButton
        Left = 432
        ExplicitLeft = 432
      end
      inherited btnSave: TcxButton
        Left = 517
        ExplicitLeft = 517
      end
      inherited btnCancel: TcxButton
        Left = 598
        ExplicitLeft = 598
      end
      inherited btnExit: TcxButton
        Left = 711
        Top = 6
        ExplicitLeft = 711
        ExplicitTop = 6
      end
    end
    inherited dxDockSite1: TdxDockSite
      Width = 220
      Height = 530
      ExplicitWidth = 220
      ExplicitHeight = 530
      DockingType = 5
      OriginalWidth = 0
      OriginalHeight = 563
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
              inherited gvStListst_no: TcxGridColumn
                Width = 87
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
      'select * from WIN'#30693#35782#28857)
    Left = 472
  end
  inherited PointDs: TDataSource
    Left = 520
  end
  inherited cxStyleRepository1: TcxStyleRepository
    Left = 584
    PixelsPerInch = 96
    inherited cxStyle1: TcxStyle
      AssignedValues = [svColor, svFont]
      Font.Charset = GB2312_CHARSET
      Font.Height = -13
    end
    inherited cxStyle2: TcxStyle
      Font.Charset = GB2312_CHARSET
      Font.Height = -13
    end
    inherited cxStyle3: TcxStyle
      AssignedValues = [svColor, svFont, svTextColor]
      Font.Charset = GB2312_CHARSET
      Font.Height = -13
    end
    inherited cxStyle4: TcxStyle
      AssignedValues = [svColor, svFont, svTextColor]
      Font.Charset = GB2312_CHARSET
      Font.Height = -13
    end
    inherited cxStyle5: TcxStyle
      AssignedValues = [svColor, svFont, svTextColor]
      Font.Charset = GB2312_CHARSET
      Font.Height = -13
    end
    inherited cxStyle6: TcxStyle
      Font.Charset = GB2312_CHARSET
      Font.Height = -13
    end
    inherited cxStyle7: TcxStyle
      AssignedValues = [svColor, svFont]
      Font.Charset = GB2312_CHARSET
      Font.Height = -13
    end
    inherited cxStyle8: TcxStyle
      AssignedValues = [svColor, svFont, svTextColor]
      Font.Charset = GB2312_CHARSET
      Font.Height = -13
    end
    inherited cxStyle9: TcxStyle
      Font.Charset = GB2312_CHARSET
      Font.Height = -13
    end
    inherited cxStyle10: TcxStyle
      AssignedValues = [svColor, svFont]
      Font.Charset = GB2312_CHARSET
      Font.Height = -13
    end
    inherited cxStyle11: TcxStyle
      AssignedValues = [svColor, svFont, svTextColor]
      Font.Charset = GB2312_CHARSET
      Font.Height = -13
    end
    inherited cxStyle12: TcxStyle
      AssignedValues = [svColor, svFont]
      Font.Charset = GB2312_CHARSET
      Font.Height = -13
    end
    inherited cxStyle13: TcxStyle
      Font.Charset = GB2312_CHARSET
      Font.Height = -13
    end
    inherited cxStyle14: TcxStyle
      AssignedValues = [svColor, svFont, svTextColor]
      Font.Charset = GB2312_CHARSET
      Font.Height = -13
    end
    inherited GridTableViewStyleSheetDevExpress: TcxGridTableViewStyleSheet
      BuiltIn = True
    end
  end
  inherited styleControllerEdit: TcxEditStyleController
    PixelsPerInch = 96
  end
  object qryEnvironment: TADOQuery
    Connection = dmSetQuestion.infoConn
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'select * from WIN'#29615#22659)
    Left = 368
    Top = 8
  end
  object dsEnvironment: TDataSource
    DataSet = qryEnvironment
    Left = 416
    Top = 8
  end
end
