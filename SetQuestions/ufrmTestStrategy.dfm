inherited frmTestStrategy: TfrmTestStrategy
  Caption = 'frmTestStrategy'
  ClientHeight = 344
  ClientWidth = 621
  ExplicitWidth = 637
  ExplicitHeight = 383
  PixelsPerInch = 96
  TextHeight = 13
  inherited Panel1: TPanel
    Width = 621
    ExplicitWidth = 154
    inherited lblTitle: TcxLabel
      Style.IsFontAssigned = True
      ExplicitWidth = 152
    end
  end
  inherited Panel3: TPanel
    Width = 621
    Height = 303
    ExplicitWidth = 154
    inherited Panel2: TPanel
      Width = 395
      Height = 260
      inherited grpStUseInfo: TcxCheckGroup
        TabOrder = 1
        Width = 389
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
        ExplicitWidth = 585
        Height = 417
        Width = 389
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
      Left = 620
      Height = 260
      ExplicitLeft = 153
      DockingType = 5
      OriginalWidth = 0
      OriginalHeight = 260
    end
    inherited Panel4: TPanel
      Top = 261
      Width = 619
      ExplicitWidth = 152
      inherited btnAppend: TcxButton
        Left = 122
        ExplicitLeft = -345
      end
      inherited btnModify: TcxButton
        Left = 203
        ExplicitLeft = -264
      end
      inherited btnDelete: TcxButton
        Left = 284
        ExplicitLeft = -183
      end
      inherited btnSave: TcxButton
        Left = 369
        ExplicitLeft = -98
      end
      inherited btnCancel: TcxButton
        Left = 450
        ExplicitLeft = -17
      end
      inherited btnExit: TcxButton
        Left = 534
        ExplicitLeft = 67
      end
    end
    inherited dxDockSite1: TdxDockSite
      Height = 260
      ExplicitHeight = 479
      DockingType = 5
      OriginalWidth = 224
      OriginalHeight = 527
      inherited dxLayoutDockSite1: TdxLayoutDockSite
        Height = 260
        DockingType = 0
        OriginalWidth = 224
        OriginalHeight = 200
      end
      inherited dxDockPanel1: TdxDockPanel
        Height = 260
        DockingType = 0
        OriginalWidth = 224
        OriginalHeight = 140
        inherited fraTree1: TfraTree
          Height = 236
          inherited grdStList: TcxGrid
            Height = 195
          end
        end
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
