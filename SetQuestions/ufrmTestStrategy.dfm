inherited frmTestStrategy: TfrmTestStrategy
  Caption = 'frmTestStrategy'
  PixelsPerInch = 96
  TextHeight = 13
  inherited Panel1: TPanel
    inherited lblTitle: TcxLabel
      Style.IsFontAssigned = True
    end
  end
  inherited Panel3: TPanel
    inherited Panel2: TPanel
      inherited grpStUseInfo: TcxCheckGroup
        TabOrder = 1
      end
      inherited edtStNo: TcxTextEdit
        TabOrder = 6
      end
      object memoStrategy: TcxMemo [2]
        Left = 8
        Top = 48
        Anchors = [akLeft, akTop, akRight]
        Lines.Strings = (
          'memoSt')
        ParentFont = False
        Properties.ScrollBars = ssVertical
        Style.Font.Charset = DEFAULT_CHARSET
        Style.Font.Color = clWindowText
        Style.Font.Height = -16
        Style.Font.Name = #23435#20307
        Style.Font.Style = []
        Style.IsFontAssigned = True
        TabOrder = 0
        Height = 417
        Width = 585
      end
      object cxLabel2: TcxLabel [3]
        Left = 7
        Top = 32
        Caption = #35797#21367#31574#30053#65306
      end
      object cxLabel9: TcxLabel [4]
        Left = 7
        Top = 8
        Caption = #35797#21367#21517#31216#65306
      end
      object edtTestName: TcxTextEdit [5]
        Left = 72
        Top = 8
        Properties.ReadOnly = True
        TabOrder = 2
        Width = 129
      end
      inherited edtItemDifficulty: TcxTextEdit
        TabOrder = 3
      end
      inherited edtRedactionTime: TcxTextEdit
        TabOrder = 4
      end
    end
    inherited dxDockSite2: TdxDockSite
      DockingType = 5
      OriginalWidth = 0
      OriginalHeight = 479
    end
    inherited dxDockSite1: TdxDockSite
      DockingType = 5
      OriginalWidth = 224
      OriginalHeight = 527
      inherited dxLayoutDockSite1: TdxLayoutDockSite
        DockingType = 0
        OriginalWidth = 224
        OriginalHeight = 200
      end
      inherited dxDockPanel1: TdxDockPanel
        DockingType = 0
        OriginalWidth = 224
        OriginalHeight = 140
      end
    end
  end
  inherited dxDockingManager1: TdxDockingManager
    PixelsPerInch = 96
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
  object setSysConfig: TADODataSet
    CursorType = ctStatic
    CommandText = 'select * from sysconfig'
    Parameters = <>
    Left = 312
    Top = 8
  end
  object dsTestStrategy: TDataSource
    DataSet = setSysConfig
    Left = 264
    Top = 8
  end
end
