object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = 'frmMain'
  ClientHeight = 233
  ClientWidth = 339
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object dxBarManager1: TdxBarManager
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    Categories.Strings = (
      'Default'
      'MainMenu')
    Categories.ItemsVisibles = (
      2
      2)
    Categories.Visibles = (
      True
      True)
    PopupMenuLinks = <>
    UseSystemFont = True
    Left = 248
    Top = 24
    DockControlHeights = (
      0
      0
      26
      0)
    object dxBarManager1Bar1: TdxBar
      Caption = 'MainMenu'
      CaptionButtons = <>
      DockedDockingStyle = dsTop
      DockedLeft = 0
      DockedTop = 0
      DockingStyle = dsTop
      FloatLeft = 276
      FloatTop = 213
      FloatClientWidth = 23
      FloatClientHeight = 22
      IsMainMenu = True
      ItemLinks = <
        item
          Visible = True
          ItemName = 'mnSystem'
        end
        item
          Visible = True
          ItemName = 'dxBarButton1'
        end>
      MultiLine = True
      OldName = 'MainMenu'
      OneOnRow = True
      Row = 0
      UseOwnFont = False
      Visible = True
      WholeRow = True
    end
    object mnConfig: TdxBarButton
      Caption = #31995#32479#37197#32622
      Category = 1
      Hint = #31995#32479#37197#32622
      Visible = ivAlways
      OnClick = mnConfigClick
    end
    object mnReceive: TdxBarButton
      Caption = #25104#32489#25509#25910
      Category = 1
      Hint = #25104#32489#25509#25910
      Visible = ivAlways
      OnClick = mnReceiveClick
    end
    object mnStatistics: TdxBarButton
      Caption = #25104#32489#32479#35745
      Category = 1
      Hint = #25104#32489#32479#35745
      Visible = ivAlways
    end
    object mnSystem: TdxBarSubItem
      Caption = #20027#33756#21333
      Category = 1
      Visible = ivAlways
      ItemLinks = <
        item
          Visible = True
          ItemName = 'mnReceive'
        end
        item
          Visible = True
          ItemName = 'mnScore'
        end
        item
          Visible = True
          ItemName = 'mnBrowseSource'
        end
        item
          Visible = True
          ItemName = 'mnConfig'
        end
        item
          Visible = True
          ItemName = 'mnStatistics'
        end
        item
          Visible = True
          ItemName = 'mnbtnEQUseInfo'
        end
        item
          Visible = True
          ItemName = 'mnbtnRestoreExamFolder'
        end>
    end
    object mnBrowseSource: TdxBarButton
      Caption = #27983#35272#19978#25253#24211
      Category = 1
      Hint = #27983#35272#19978#25253#24211
      Visible = ivAlways
      OnClick = mnBrowseSourceClick
    end
    object mnScore: TdxBarButton
      Caption = #27719#24635#25104#32489
      Category = 1
      Hint = #27719#24635#25104#32489
      Visible = ivAlways
      OnClick = mnScoreClick
    end
    object mnbtnEQUseInfo: TdxBarButton
      Caption = #25509#25910#35797#39064#20351#29992#20449#24687
      Category = 1
      Hint = #25509#25910#35797#39064#20351#29992#20449#24687
      Visible = ivAlways
      OnClick = mnbtnEQUseInfoClick
    end
    object dxBarButton1: TdxBarButton
      Caption = 'New Button'
      Category = 0
      Hint = 'New Button'
      Visible = ivAlways
    end
    object mnbtnRestoreExamFolder: TdxBarButton
      Caption = #36824#21407#32771#35797#25991#20214#22841
      Category = 0
      Hint = #36824#21407#32771#35797#25991#20214#22841
      Visible = ivAlways
      OnClick = mnbtnRestoreExamFolderClick
    end
  end
end
