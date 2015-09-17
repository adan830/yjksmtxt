inherited frmSelect: TfrmSelect
  Left = 169
  Top = 104
  Caption = #36873#25321#39064
  ClientHeight = 581
  ClientWidth = 837
  OldCreateOrder = True
  ExplicitTop = -53
  ExplicitWidth = 853
  ExplicitHeight = 620
  PixelsPerInch = 96
  TextHeight = 13
  inherited Panel1: TPanel
    Width = 837
    ExplicitWidth = 837
    inherited lblTitle: TcxLabel
      Style.IsFontAssigned = True
      ExplicitWidth = 835
    end
  end
  inherited Panel3: TPanel
    Width = 837
    Height = 540
    ExplicitWidth = 837
    ExplicitHeight = 540
    inherited Panel2: TPanel
      Left = 211
      Width = 625
      Height = 497
      ExplicitLeft = 211
      ExplicitWidth = 625
      ExplicitHeight = 497
      object chkgrpItem: TcxGroupBox [0]
        Left = 6
        Top = 279
        Anchors = [akLeft, akRight, akBottom]
        Caption = #36873#25321#39033#21450#31572#26696#65306
        Style.StyleController = styleControllerEdit
        TabOrder = 3
        Height = 56
        Width = 607
        object chkItem1: TcxCheckBox
          Left = 59
          Top = 23
          TabOrder = 0
          Width = 30
        end
        object chkItem2: TcxCheckBox
          Left = 128
          Top = 23
          TabOrder = 1
          Width = 30
        end
        object chkItem3: TcxCheckBox
          Left = 195
          Top = 23
          TabOrder = 2
          Width = 30
        end
        object chkItem4: TcxCheckBox
          Left = 265
          Top = 23
          TabOrder = 3
          Width = 30
        end
        object rbItem1: TcxRadioButton
          Left = 59
          Top = 27
          Width = 30
          Height = 17
          TabOrder = 4
        end
        object rbItem2: TcxRadioButton
          Left = 128
          Top = 27
          Width = 30
          Height = 17
          TabOrder = 5
        end
        object rbItem3: TcxRadioButton
          Left = 195
          Top = 27
          Width = 30
          Height = 17
          TabOrder = 6
        end
        object rbItem4: TcxRadioButton
          Left = 265
          Top = 27
          Width = 30
          Height = 17
          TabOrder = 7
        end
        object lblItemA: TcxLabel
          Left = 30
          Top = 27
          Caption = 'A'#12289
        end
        object lblItemB: TcxLabel
          Left = 99
          Top = 27
          Caption = 'B'#12289
        end
        object lblItemC: TcxLabel
          Left = 166
          Top = 27
          Caption = 'C'#12289
        end
        object lblItemD: TcxLabel
          Left = 235
          Top = 27
          Caption = 'D'#12289
        end
      end
      inherited grpStUseInfo: TcxCheckGroup
        Left = 10
        Caption = ' '#36873#29992#24773#20917'   '
        ExplicitLeft = 10
        ExplicitWidth = 607
        Width = 607
      end
      inherited edtStNo: TcxTextEdit
        TabOrder = 6
      end
      object cxGroupBox1: TcxGroupBox [3]
        Left = 8
        Top = 343
        Anchors = [akLeft, akRight, akBottom]
        Caption = #35299#26512#65306
        TabOrder = 1
        Height = 97
        Width = 607
        object edtEQComment: TJvRichEdit
          Left = 2
          Top = 18
          Width = 603
          Height = 77
          Align = alClient
          Font.Charset = GB2312_CHARSET
          Font.Color = clWindowText
          Font.Height = 14
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          SelText = ''
          TabOrder = 0
        end
      end
      object cxGroupBox2: TcxGroupBox [4]
        Left = 8
        Top = 77
        Anchors = [akLeft, akTop, akRight, akBottom]
        Caption = #35797#39064#65306
        TabOrder = 2
        Height = 196
        Width = 607
        object edtEQContent: TJvRichEdit
          Left = 2
          Top = 18
          Width = 603
          Height = 176
          Align = alClient
          Font.Charset = GB2312_CHARSET
          Font.Color = clWindowText
          Font.Height = 14
          Font.Name = #23435#20307
          Font.Style = []
          ParentFont = False
          SelText = ''
          TabOrder = 0
        end
      end
    end
    inherited dxDockSite2: TdxDockSite
      Left = 836
      Height = 497
      ExplicitLeft = 836
      ExplicitHeight = 497
      DockingType = 5
      OriginalWidth = 0
      OriginalHeight = 497
    end
    inherited Panel4: TPanel
      Top = 498
      Width = 835
      ExplicitTop = 498
      ExplicitWidth = 835
      inherited btnAppend: TcxButton
        Left = 294
        Top = 6
        ExplicitLeft = 294
        ExplicitTop = 6
      end
      inherited btnModify: TcxButton
        Left = 382
        Top = 6
        ExplicitLeft = 382
        ExplicitTop = 6
      end
      inherited btnDelete: TcxButton
        Left = 463
        Top = 6
        ExplicitLeft = 463
        ExplicitTop = 6
      end
      inherited btnSave: TcxButton
        Left = 556
        Top = 6
        ExplicitLeft = 556
        ExplicitTop = 6
      end
      inherited btnCancel: TcxButton
        Left = 637
        Top = 6
        ExplicitLeft = 637
        ExplicitTop = 6
      end
      inherited btnExit: TcxButton
        Left = 755
        Top = 6
        ExplicitLeft = 755
        ExplicitTop = 6
      end
    end
    inherited dxDockSite1: TdxDockSite
      Width = 210
      Height = 497
      ExplicitWidth = 210
      ExplicitHeight = 497
      DockingType = 5
      OriginalWidth = 210
      OriginalHeight = 538
      inherited dxLayoutDockSite1: TdxLayoutDockSite
        Width = 210
        Height = 497
        ExplicitWidth = 210
        ExplicitHeight = 497
        DockingType = 0
        OriginalWidth = 210
        OriginalHeight = 200
      end
      inherited dxDockPanel1: TdxDockPanel
        Width = 210
        Height = 497
        ExplicitWidth = 210
        ExplicitHeight = 497
        DockingType = 0
        OriginalWidth = 210
        OriginalHeight = 140
        inherited fraTree1: TfraTree
          Width = 206
          Height = 473
          ExplicitWidth = 206
          ExplicitHeight = 473
          inherited grdStList: TcxGrid
            Width = 206
            Height = 432
            ExplicitWidth = 206
            ExplicitHeight = 432
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
  inherited cxEditRepository1: TcxEditRepository
    Left = 785
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
