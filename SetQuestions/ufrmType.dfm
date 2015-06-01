inherited frmType: TfrmType
  Left = 116
  Top = 112
  Caption = 'frmType'
  ClientHeight = 454
  ClientWidth = 892
  OldCreateOrder = True
  ExplicitWidth = 908
  ExplicitHeight = 493
  PixelsPerInch = 96
  TextHeight = 13
  inherited Panel1: TPanel
    Width = 892
    ExplicitWidth = 162
    inherited lblTitle: TcxLabel
      Style.IsFontAssigned = True
      ExplicitWidth = 160
    end
  end
  inherited Panel3: TPanel
    Width = 892
    Height = 413
    ExplicitWidth = 162
    inherited Panel2: TPanel
      Left = 211
      Width = 680
      Height = 370
      ExplicitLeft = 211
      ExplicitWidth = 605
      inherited grpStUseInfo: TcxCheckGroup
        Left = 10
        ExplicitLeft = 10
        ExplicitWidth = 584
        Width = 659
      end
      inherited edtStNo: TcxTextEdit
        Top = 5
        TabOrder = 2
        ExplicitTop = 5
      end
      inherited edtRedactionTime: TcxTextEdit
        TabOrder = 9
      end
      object cxGroupBox2: TcxGroupBox
        Left = 8
        Top = 77
        Anchors = [akLeft, akTop, akRight, akBottom]
        Caption = #25171#23383#21407#25991#65306
        TabOrder = 3
        ExplicitWidth = 586
        ExplicitHeight = 340
        Height = 231
        Width = 661
        object edtEQContent: TJvRichEdit
          Left = 2
          Top = 18
          Width = 657
          Height = 211
          Align = alClient
          BevelKind = bkFlat
          Font.Charset = GB2312_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = #23435#20307
          Font.Style = []
          ParentFont = False
          SelText = ''
          TabOrder = 0
          ExplicitWidth = 199
          ExplicitHeight = 22
        end
      end
      object lbl1: TcxLabel
        Left = 353
        Top = 328
        Anchors = [akRight, akBottom]
        Caption = #21407#25991#24635#23383#25968#65306
        ExplicitLeft = 278
        ExplicitTop = 437
      end
      object edtTotalNum: TcxTextEdit
        Left = 435
        Top = 325
        Anchors = [akRight, akBottom]
        Properties.ReadOnly = True
        TabOrder = 5
        ExplicitLeft = 360
        ExplicitTop = 434
        Width = 129
      end
      object btnTotal: TcxButton
        Left = 579
        Top = 325
        Width = 75
        Height = 25
        Anchors = [akRight, akBottom]
        Caption = #32479#35745#23383#25968
        TabOrder = 6
        OnClick = btnTotalClick
        ExplicitLeft = 504
        ExplicitTop = 434
      end
    end
    inherited dxDockSite2: TdxDockSite
      Left = 891
      Height = 370
      ExplicitLeft = 161
      DockingType = 5
      OriginalWidth = 0
      OriginalHeight = 370
    end
    inherited Panel4: TPanel
      Top = 371
      Width = 890
      ExplicitWidth = 160
      inherited btnAppend: TcxButton
        Left = 393
        Top = 6
        ExplicitLeft = -337
        ExplicitTop = 6
      end
      inherited btnModify: TcxButton
        Left = 474
        Top = 6
        ExplicitLeft = -256
        ExplicitTop = 6
      end
      inherited btnDelete: TcxButton
        Left = 555
        Top = 6
        ExplicitLeft = -175
        ExplicitTop = 6
      end
      inherited btnSave: TcxButton
        Left = 640
        Top = 6
        ExplicitLeft = -90
        ExplicitTop = 6
      end
      inherited btnCancel: TcxButton
        Left = 721
        Top = 6
        ExplicitLeft = -9
        ExplicitTop = 6
      end
      inherited btnExit: TcxButton
        Left = 811
        Top = 6
        ExplicitLeft = 81
        ExplicitTop = 6
      end
    end
    inherited dxDockSite1: TdxDockSite
      Width = 210
      Height = 370
      ExplicitWidth = 210
      ExplicitHeight = 479
      DockingType = 5
      OriginalWidth = 0
      OriginalHeight = 527
      inherited dxLayoutDockSite1: TdxLayoutDockSite
        Width = 210
        Height = 370
        ExplicitWidth = 210
        DockingType = 0
        OriginalWidth = 210
        OriginalHeight = 200
      end
      inherited dxDockPanel1: TdxDockPanel
        Width = 210
        Height = 370
        ExplicitWidth = 210
        DockingType = 0
        OriginalWidth = 210
        OriginalHeight = 140
        inherited fraTree1: TfraTree
          Width = 206
          Height = 346
          ExplicitWidth = 206
          inherited grdStList: TcxGrid
            Width = 206
            Height = 305
            ExplicitWidth = 206
          end
          inherited Panel1: TPanel
            Width = 206
            ExplicitWidth = 206
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
end
