object frmMain: TfrmMain
  Left = 219
  Top = 123
  Caption = #19968#32423'Windows'#24179#21488#26080#32440#21270#32771#35797#21629#39064#31995#32479
  ClientHeight = 402
  ClientWidth = 667
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesigned
  WindowState = wsMaximized
  PixelsPerInch = 96
  TextHeight = 13
  object dxBarManager1: TdxBarManager
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Microsoft YaHei UI'
    Font.Style = []
    Categories.Strings = (
      'Default'
      #20027#33756#21333
      #21629#39064#27169#22359)
    Categories.ItemsVisibles = (
      2
      2
      2)
    Categories.Visibles = (
      True
      True
      True)
    PopupMenuLinks = <>
    Style = bmsFlat
    UseSystemFont = True
    Left = 592
    Top = 32
    DockControlHeights = (
      0
      0
      27
      0)
    object dxBarManager1Bar1: TdxBar
      Caption = #20027#33756#21333
      CaptionButtons = <>
      DockedDockingStyle = dsTop
      DockedLeft = 0
      DockedTop = 0
      DockingStyle = dsTop
      FloatLeft = 276
      FloatTop = 216
      FloatClientWidth = 23
      FloatClientHeight = 22
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bsiTestQuestion'
        end
        item
          Visible = True
          ItemName = 'mnSubTQBSystem'
        end
        item
          Visible = True
          ItemName = 'mnsubSystem'
        end>
      OldName = #20027#33756#21333
      OneOnRow = True
      Row = 0
      UseOwnFont = False
      Visible = True
      WholeRow = False
    end
    object mmbtnSysConfig: TdxBarButton
      Caption = #31995#32479#21450#39064#24211#35774#32622
      Category = 0
      Hint = #31995#32479#21450#39064#24211#35774#32622
      Visible = ivAlways
      OnClick = mmbtnSysConfigClick
    end
    object dxBarButton1: TdxBarButton
      Caption = 'New Item'
      Category = 0
      Hint = 'New Item'
      Visible = ivAlways
    end
    object mnbtnSelectConfig: TdxBarButton
      Caption = #32771#35797#24211#36873#29992#21450#23548#20986
      Category = 0
      Hint = #32771#35797#24211#36873#29992#21450#23548#20986
      Visible = ivAlways
      OnClick = mnbtnSelectConfigClick
    end
    object mnSubTQBSystem: TdxBarSubItem
      Caption = #35797#39064#24211#32500#25252
      Category = 0
      Visible = ivAlways
      ItemLinks = <
        item
          Visible = True
          ItemName = 'mmbtnSysConfig'
        end
        item
          Visible = True
          ItemName = 'mnbtnSelectConfig'
        end
        item
          Visible = True
          ItemName = 'mnbtnFileCheck'
        end
        item
          Visible = True
          ItemName = 'mnbtnEQimport'
        end
        item
          Visible = True
          ItemName = 'mnbtnAddonsFile'
        end
        item
          Visible = True
          ItemName = 'mnbtnExpression'
        end
        item
          Visible = True
          ItemName = 'mnbtnEncryptStr'
        end
        item
          Visible = True
          ItemName = 'mnbtnConvertToRTF'
        end>
    end
    object mnbtnConvertToRTF: TdxBarButton
      Caption = #36716#25442#25968#25454#24211#21040'RTF'#26684#24335
      Category = 0
      Hint = #36716#25442#25968#25454#24211#21040'RTF'#26684#24335
      Visible = ivAlways
      OnClick = mnbtnConvertToRTFClick
    end
    object mnbtnAddonsFile: TdxBarButton
      Caption = #38468#21152#25991#20214
      Category = 0
      Hint = #38468#21152#25991#20214
      Visible = ivAlways
      OnClick = mnbtnAddonsFileClick
    end
    object mnbtnEncryptStr: TdxBarButton
      Caption = #23383#31526#20018#21152#35299#23494
      Category = 0
      Hint = #23383#31526#20018#21152#35299#23494
      Visible = ivAlways
      OnClick = mnbtnEncryptStrClick
    end
    object mnsubSystem: TdxBarSubItem
      Caption = #21629#39064#31995#32479#32500#25252
      Category = 0
      Visible = ivAlways
      ItemLinks = <
        item
          Visible = True
          ItemName = 'mnbtnUserManager'
        end>
    end
    object mnbtnUserManager: TdxBarButton
      Caption = #29992#25143#31649#29702
      Category = 0
      Hint = #29992#25143#31649#29702
      Visible = ivAlways
      OnClick = mnbtnUserManagerClick
    end
    object mnbtnExpression: TdxBarButton
      Caption = #34920#36798#24335#26657#39564
      Category = 0
      Hint = #34920#36798#24335#26657#39564
      Visible = ivAlways
      OnClick = mnbtnExpressionClick
    end
    object bsiTestQuestion: TdxBarSubItem
      Caption = #21629#39064#27169#22359
      Category = 1
      Visible = ivAlways
      ItemLinks = <
        item
          Visible = True
          ItemName = 'mmbtnSingleSelect'
        end
        item
          Visible = True
          ItemName = 'mmbtnMultiSelect'
        end
        item
          Visible = True
          ItemName = 'mmbtnType'
        end
        item
          Visible = True
          ItemName = 'bbtnWindows'
        end
        item
          Visible = True
          ItemName = 'bbtnWord'
        end
        item
          Visible = True
          ItemName = 'bbtnExcel'
        end
        item
          Visible = True
          ItemName = 'bbtnPpt'
        end>
    end
    object bbtnWord: TdxBarButton
      Caption = 'Word'#21629#39064
      Category = 2
      Hint = 'Word'#21629#39064
      Visible = ivAlways
      OnClick = bbtnWordClick
    end
    object bbtnWindows: TdxBarButton
      Caption = 'Windows'#21629#39064
      Category = 2
      Hint = 'Windows'#21629#39064
      Visible = ivAlways
      OnClick = bbtnWindowsClick
    end
    object bbtnExcel: TdxBarButton
      Caption = 'Excel'#21629#39064
      Category = 2
      Hint = 'Excel'#21629#39064
      Visible = ivAlways
      OnClick = bbtnExcelClick
    end
    object mmbtnSingleSelect: TdxBarButton
      Caption = #21333#39033#36873#25321
      Category = 2
      Hint = #21333#39033#36873#25321
      Visible = ivAlways
      OnClick = mmbtnSingleSelectClick
    end
    object mmbtnMultiSelect: TdxBarButton
      Caption = #22810#39033#36873#25321
      Category = 2
      Hint = #22810#39033#36873#25321
      Visible = ivAlways
      OnClick = mmbtnMultiSelectClick
    end
    object mmbtnType: TdxBarButton
      Caption = #25171#23383
      Category = 2
      Hint = #25171#23383
      Visible = ivAlways
      OnClick = mmbtnTypeClick
    end
    object bbtnPpt: TdxBarButton
      Caption = 'Ppt'#21629#39064
      Category = 2
      Hint = 'Ppt'#21629#39064
      Visible = ivAlways
      OnClick = bbtnPptClick
    end
    object mnbtnFileCheck: TdxBarButton
      Caption = #25991#20214#26816#26597
      Category = 2
      Hint = #25991#20214#26816#26597
      Visible = ivAlways
      OnClick = mnbtnFileCheckClick
    end
    object mnbtnEQimport: TdxBarButton
      Caption = #35797#39064#23548#20837
      Category = 2
      Hint = #35797#39064#23548#20837
      Visible = ivAlways
      OnClick = mnbtnEQimportClick
    end
  end
end
