object frmBase: TfrmBase
  Left = 139
  Top = 84
  Caption = 'frmBase'
  ClientHeight = 563
  ClientWidth = 817
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  WindowState = wsMaximized
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 817
    Height = 41
    Align = alTop
    TabOrder = 0
    object lblTitle: TcxLabel
      Left = 1
      Top = 1
      Align = alClient
      Caption = 'lblTitle'
      ParentFont = False
      Style.Font.Charset = DEFAULT_CHARSET
      Style.Font.Color = clWindowText
      Style.Font.Height = -32
      Style.Font.Name = #26999#20307'_GB2312'
      Style.Font.Style = []
      Style.IsFontAssigned = True
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 41
    Width = 817
    Height = 522
    Align = alClient
    Caption = 'Panel3'
    TabOrder = 1
    object Panel2: TPanel
      Left = 225
      Top = 1
      Width = 591
      Height = 479
      Align = alClient
      TabOrder = 1
      DesignSize = (
        591
        479)
      object grpStUseInfo: TcxCheckGroup
        Left = 3
        Top = 34
        Margins.Left = 0
        Margins.Top = 0
        Margins.Right = 0
        Margins.Bottom = 0
        Anchors = [akLeft, akTop, akRight]
        Caption = '  '#36873#29992#24773#20917'    '
        Enabled = False
        Properties.Columns = 10
        Properties.Items = <>
        Properties.ReadOnly = True
        Style.StyleController = styleControllerEdit
        TabOrder = 0
        Height = 40
        Width = 585
      end
      object edtStNo: TcxTextEdit
        Left = 70
        Top = 7
        Enabled = False
        Properties.ReadOnly = True
        Style.StyleController = styleControllerEdit
        TabOrder = 1
        Width = 89
      end
      object cxlbl1: TcxLabel
        Left = 8
        Top = 9
        Caption = #35797#39064#32534#21495#65306
      end
      object lblItemDifficulty: TcxLabel
        Left = 167
        Top = 9
        Caption = #38590#24230#31995#25968#65306
      end
      object edtItemDifficulty: TcxTextEdit
        Left = 228
        Top = 7
        Enabled = False
        Properties.ReadOnly = True
        Style.StyleController = styleControllerEdit
        TabOrder = 4
        Width = 34
      end
      object edtRedactionTime: TcxTextEdit
        Left = 473
        Top = 7
        Enabled = False
        Properties.ReadOnly = True
        Style.StyleController = styleControllerEdit
        TabOrder = 5
        Width = 113
      end
      object lblRedactionTime: TcxLabel
        Left = 412
        Top = 9
        Caption = #20462#35746#26102#38388#65306
      end
      object lblRedactor: TcxLabel
        Left = 272
        Top = 9
        Caption = #20462#35746#32773#65306
      end
      object edtRedactor: TcxTextEdit
        Left = 321
        Top = 7
        Enabled = False
        Properties.ReadOnly = True
        Style.StyleController = styleControllerEdit
        TabOrder = 8
        Width = 85
      end
    end
    object dxDockSite2: TdxDockSite
      Left = 816
      Top = 1
      Width = 0
      Height = 479
      Align = alRight
      AutoSize = True
      DockingType = 5
      OriginalWidth = 0
      OriginalHeight = 479
    end
    object Panel4: TPanel
      Left = 1
      Top = 480
      Width = 815
      Height = 41
      Align = alBottom
      TabOrder = 3
      DesignSize = (
        815
        41)
      object btnAppend: TcxButton
        AlignWithMargins = True
        Left = 318
        Top = 8
        Width = 75
        Height = 25
        Anchors = [akTop, akRight]
        Caption = #28155#21152
        TabOrder = 0
        OnClick = btnAppendClick
      end
      object btnModify: TcxButton
        AlignWithMargins = True
        Left = 399
        Top = 8
        Width = 75
        Height = 25
        Anchors = [akTop, akRight]
        Caption = #20462#25913
        TabOrder = 1
        OnClick = btnModifyClick
      end
      object btnDelete: TcxButton
        AlignWithMargins = True
        Left = 480
        Top = 8
        Width = 75
        Height = 25
        Anchors = [akTop, akRight]
        Caption = #21024#38500
        TabOrder = 2
        OnClick = btnDeleteClick
      end
      object btnSave: TcxButton
        AlignWithMargins = True
        Left = 565
        Top = 8
        Width = 75
        Height = 25
        Anchors = [akTop, akRight]
        Caption = #20445#23384
        TabOrder = 3
        OnClick = btnSaveClick
      end
      object btnCancel: TcxButton
        AlignWithMargins = True
        Left = 646
        Top = 8
        Width = 75
        Height = 25
        Anchors = [akTop, akRight]
        Caption = #21462#28040
        TabOrder = 4
        OnClick = btnCancelClick
      end
      object btnExit: TcxButton
        AlignWithMargins = True
        Left = 730
        Top = 8
        Width = 68
        Height = 25
        Anchors = [akTop, akRight]
        Caption = #36864#20986
        TabOrder = 5
        OnClick = btnExitClick
      end
    end
    object dxDockSite1: TdxDockSite
      Left = 1
      Top = 1
      Width = 224
      Height = 479
      Align = alLeft
      AutoSize = True
      DockingType = 5
      OriginalWidth = 224
      OriginalHeight = 527
      object dxLayoutDockSite1: TdxLayoutDockSite
        Left = 0
        Top = 0
        Width = 224
        Height = 479
        DockingType = 0
        OriginalWidth = 224
        OriginalHeight = 200
      end
      object dxDockPanel1: TdxDockPanel
        Left = 0
        Top = 0
        Width = 224
        Height = 479
        AllowFloating = True
        AutoHide = False
        Caption = #35797#39064#21015#34920
        CaptionButtons = [cbMaximize, cbHide]
        CustomCaptionButtons.Buttons = <>
        Dockable = False
        TabsProperties.CustomButtons.Buttons = <>
        TabsProperties.TabPosition = tpTop
        DockingType = 0
        OriginalWidth = 224
        OriginalHeight = 140
        inline fraTree1: TfraTree
          Left = 0
          Top = 0
          Width = 220
          Height = 455
          Align = alClient
          TabOrder = 0
          TabStop = True
          ExplicitWidth = 220
          ExplicitHeight = 455
          inherited grdStList: TcxGrid
            Width = 220
            Height = 414
            ExplicitWidth = 220
            ExplicitHeight = 414
            inherited gvStList: TcxGridTableView
              OnCanFocusRecord = fraTree1tvTreeCanFocusRecord
              OnFocusedRecordChanged = fraTree1tvTreeFocusedRecordChanged
            end
          end
          inherited Panel1: TPanel
            Width = 220
            ExplicitWidth = 220
            inherited btnSaveSelect: TcxButton
              OnClick = btnSaveSelectClick
            end
            inherited btnSelect: TcxButton
              OnClick = btnSelectClick
            end
          end
        end
      end
    end
  end
  object dxDockingManager1: TdxDockingManager
    AutoShowInterval = 0
    Color = clBtnFace
    DefaultHorizContainerSiteProperties.CustomCaptionButtons.Buttons = <>
    DefaultHorizContainerSiteProperties.Dockable = True
    DefaultHorizContainerSiteProperties.ImageIndex = -1
    DefaultVertContainerSiteProperties.CustomCaptionButtons.Buttons = <>
    DefaultVertContainerSiteProperties.Dockable = True
    DefaultVertContainerSiteProperties.ImageIndex = -1
    DefaultTabContainerSiteProperties.CustomCaptionButtons.Buttons = <>
    DefaultTabContainerSiteProperties.Dockable = True
    DefaultTabContainerSiteProperties.ImageIndex = -1
    DefaultTabContainerSiteProperties.TabsProperties.CustomButtons.Buttons = <>
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    LookAndFeel.Kind = lfOffice11
    LookAndFeel.NativeStyle = False
    Options = [doActivateAfterDocking, doDblClickDocking, doFloatingOnTop, doTabContainerHasCaption, doTabContainerCanAutoHide, doSideContainerCanClose, doSideContainerCanAutoHide, doTabContainerCanInSideContainer, doImmediatelyHideOnAutoHide, doHideAutoHideIfActive]
    Left = 600
    Top = 8
    PixelsPerInch = 96
  end
  object cxEditRepository1: TcxEditRepository
    Left = 505
    Top = 10
    object cxEditRepository1ButtonItem1: TcxEditRepositoryButtonItem
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
    end
  end
  object qryPoint: TADOQuery
    Connection = dmSetQuestion.infoConn
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'select * from WORD'#30693#35782#28857#23376#31867)
    Left = 744
    Top = 8
  end
  object PointDs: TDataSource
    DataSet = qryPoint
    Left = 696
    Top = 8
  end
  object cxStyleRepository1: TcxStyleRepository
    Left = 392
    Top = 8
    PixelsPerInch = 96
    object cxStyle1: TcxStyle
      AssignedValues = [svColor]
      Color = 15451300
    end
    object cxStyle2: TcxStyle
      AssignedValues = [svColor, svFont, svTextColor]
      Color = 16247513
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      TextColor = clBlack
    end
    object cxStyle3: TcxStyle
      AssignedValues = [svColor, svTextColor]
      Color = 16247513
      TextColor = clBlack
    end
    object cxStyle4: TcxStyle
      AssignedValues = [svColor, svTextColor]
      Color = 16247513
      TextColor = clBlack
    end
    object cxStyle5: TcxStyle
      AssignedValues = [svColor, svTextColor]
      Color = 14811135
      TextColor = clBlack
    end
    object cxStyle6: TcxStyle
      AssignedValues = [svColor, svFont, svTextColor]
      Color = 14811135
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      TextColor = clNavy
    end
    object cxStyle7: TcxStyle
      AssignedValues = [svColor]
      Color = 14872561
    end
    object cxStyle8: TcxStyle
      AssignedValues = [svColor, svTextColor]
      Color = 4707838
      TextColor = clBlack
    end
    object cxStyle9: TcxStyle
      AssignedValues = [svColor, svFont, svTextColor]
      Color = 12937777
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      TextColor = clWhite
    end
    object cxStyle10: TcxStyle
      AssignedValues = [svColor]
      Color = 15451300
    end
    object cxStyle11: TcxStyle
      AssignedValues = [svColor, svTextColor]
      Color = 4707838
      TextColor = clBlack
    end
    object cxStyle12: TcxStyle
      AssignedValues = [svColor]
      Color = 15451300
    end
    object cxStyle13: TcxStyle
      AssignedValues = [svColor, svFont, svTextColor]
      Color = 14811135
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      TextColor = clNavy
    end
    object cxStyle14: TcxStyle
      AssignedValues = [svColor, svTextColor]
      Color = 12937777
      TextColor = clWhite
    end
    object GridTableViewStyleSheetDevExpress: TcxGridTableViewStyleSheet
      Caption = 'DevExpress'
      Styles.Background = cxStyle1
      Styles.Content = cxStyle2
      Styles.ContentEven = cxStyle3
      Styles.ContentOdd = cxStyle4
      Styles.FilterBox = cxStyle5
      Styles.Inactive = cxStyle10
      Styles.IncSearch = cxStyle11
      Styles.Selection = cxStyle14
      Styles.Footer = cxStyle6
      Styles.Group = cxStyle7
      Styles.GroupByBox = cxStyle8
      Styles.Header = cxStyle9
      Styles.Indicator = cxStyle12
      Styles.Preview = cxStyle13
      BuiltIn = True
    end
  end
  object styleControllerEdit: TcxEditStyleController
    StyleDisabled.TextColor = clBlue
    Left = 304
    Top = 8
    PixelsPerInch = 96
  end
end
