object FormMainServer: TFormMainServer
  Left = 146
  Top = 115
  Caption = #26381#21153#22120
  ClientHeight = 515
  ClientWidth = 734
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesigned
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object pgServer: TcxPageControl
    Left = 0
    Top = 28
    Width = 734
    Height = 487
    Align = alClient
    TabOrder = 4
    Properties.ActivePage = tbshtMonitor
    Properties.CustomButtons.Buttons = <>
    Properties.HotTrack = True
    Properties.ShowFrame = True
    Properties.Style = 7
    Properties.TabSlants.Kind = skCutCorner
    LookAndFeel.Kind = lfOffice11
    LookAndFeel.NativeStyle = True
    TabSlants.Kind = skCutCorner
    OnPageChanging = pgServerPageChanging
    ClientRectBottom = 486
    ClientRectLeft = 1
    ClientRectRight = 733
    ClientRectTop = 21
    object tbshtTQBInfo: TcxTabSheet
      Caption = #39064#24211#20449#24687
      ImageIndex = 3
      object grpbx3: TcxGroupBox
        Left = 16
        Top = 3
        Caption = 'grpbx3'
        TabOrder = 0
        Height = 302
        Width = 497
        object cxLabel1: TcxLabel
          Left = 88
          Top = 32
          Caption = #39064#24211#21517#31216#65306
        end
        object edtName: TcxTextEdit
          Left = 152
          Top = 32
          Enabled = False
          Properties.ReadOnly = True
          Style.StyleController = cxEditStyleController1
          TabOrder = 1
          Width = 257
        end
        object cxLabel2: TcxLabel
          Left = 88
          Top = 72
          Caption = #39064#24211#31867#22411#65306
        end
        object cxLabel3: TcxLabel
          Left = 88
          Top = 112
          Caption = #26377#25928#26085#26399#65306
        end
        object cxLabel4: TcxLabel
          Left = 88
          Top = 152
          Caption = #25104#32489#26174#31034#65306
        end
        object cxLabel5: TcxLabel
          Left = 18
          Top = 272
          Caption = #37325#32771#23494#30721#65306
          Visible = False
        end
        object cxLabel6: TcxLabel
          Left = 88
          Top = 276
          Caption = #32493#32771#23494#30721#65306
          Visible = False
        end
        object edtRetryPwd: TcxTextEdit
          Left = 320
          Top = 279
          Enabled = False
          Properties.ReadOnly = True
          Style.StyleController = cxEditStyleController1
          TabOrder = 7
          Visible = False
          Width = 121
        end
        object edtContPwd: TcxTextEdit
          Left = 158
          Top = 279
          Enabled = False
          Properties.ReadOnly = True
          Style.StyleController = cxEditStyleController1
          TabOrder = 8
          Visible = False
          Width = 121
        end
        object edtType: TcxTextEdit
          Left = 152
          Top = 71
          Enabled = False
          Properties.ReadOnly = True
          Style.StyleController = cxEditStyleController1
          TabOrder = 9
          Width = 257
        end
        object edtDuration: TcxTextEdit
          Left = 152
          Top = 111
          Enabled = False
          Properties.ReadOnly = True
          Style.StyleController = cxEditStyleController1
          TabOrder = 10
          Width = 257
        end
        object edtScoreDisp: TcxTextEdit
          Left = 152
          Top = 151
          Enabled = False
          Properties.ReadOnly = True
          Style.StyleController = cxEditStyleController1
          TabOrder = 11
          Width = 257
        end
        object edtStkDbFilePath: TcxTextEdit
          Left = 151
          Top = 257
          Enabled = False
          Properties.ReadOnly = True
          Style.StyleController = cxEditStyleController1
          TabOrder = 12
          Width = 257
        end
        object lbl5: TcxLabel
          Left = 88
          Top = 256
          Caption = #39064#24211#36335#24452#65306
        end
        object edtTypeTime: TcxTextEdit
          Left = 151
          Top = 222
          Enabled = False
          Style.StyleController = cxEditStyleController1
          TabOrder = 14
          Width = 121
        end
        object cxLabel8: TcxLabel
          Left = 53
          Top = 221
          Caption = #25171#23383#26102#38388#65288#31186#65289#65306
        end
        object edtExamTime: TcxTextEdit
          Left = 151
          Top = 186
          Enabled = False
          Style.StyleController = cxEditStyleController1
          TabOrder = 16
          Width = 121
        end
        object cxLabel7: TcxLabel
          Left = 52
          Top = 184
          Caption = #32771#35797#26102#38388#65288#31186#65289#65306
        end
      end
    end
    object tbshtMonitor: TcxTabSheet
      Caption = #32771#35797#30417#25511
      ImageIndex = 0
      DesignSize = (
        732
        465)
      object img1: TImage
        Left = 643
        Top = 47
        Width = 32
        Height = 32
        Anchors = [akTop, akRight]
        AutoSize = True
        Picture.Data = {
          055449636F6E0000010001002020100000000000E80200001600000028000000
          2000000040000000010004000000000080020000000000000000000010000000
          0000000000000000000080000080000000808000800000008000800080800000
          80808000C0C0C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000
          FFFFFF0000000000070070000000000000000000000000007000070000000000
          000000000000000000FF000000000000000000000000000000FF000000000000
          000000000000000000FF000000000000000000000000000000FF000000000000
          000000000000000000FF000000000000000000000000000000FF000700700000
          000000000000000000FF000000070000000000000000000000FF0000FF000707
          000000000000000000FF0007FF700000700000000000000000FF0007FF700FF0
          000000000000000700000007FF707FF80070000000000000077770007F708FF8
          00000000000000008FFFF87007708F870FF070000000700FFFFFFFFF0000FF80
          7FF00000000000FFFFFFFFFF0000FF70FFF07000000000FFF707FFF000008F07
          FF700000000000FFF70000007700000FFF070000000070FFFFF70007FF700008
          F00000000000000FFFFFFFFFFF7077000070000000000000FFFFFFFFFF70FF00
          000000000000000007FFFFFFF007FFF00000000000000000007FFFFFF70FFF70
          0000000000000000000FFFFFFFFFFF000000000000000000700078FFFFF87000
          700000000000000000F00000000000F0000000000000000000F87000000078F0
          000000000000000000FFFFFFFFFFFFF0000000000000000070078FFFFFFF8700
          7000000000000000070000000000000700000000000000000007000000000700
          00000000FF87FFFFFF03FFFFFF03FFFFFF03FFFFFF03FFFFFF03FFFFFF03FFFF
          FF021FFFFF000FFFFF0008FFFF00007FFF00007FFE00001FFC00000FF8000007
          F0000007F0000007F000000FF000000FF000001FF800001FFC00003FFE00007F
          FF0000FFFF8000FFFF00007FFF00007FFF00007FFF00007FFF00007FFF8000FF
          FFE003FF}
        ExplicitLeft = 584
      end
      object img2: TImage
        Left = 643
        Top = 116
        Width = 32
        Height = 32
        Anchors = [akTop, akRight]
        AutoSize = True
        Picture.Data = {
          055449636F6E0000010001002020100000000000E80200001600000028000000
          2000000040000000010004000000000080020000000000000000000010000000
          0000000000000000000080000080000000808000800000008000800080800000
          80808000C0C0C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000
          FFFFFF0000000000070070000000000000000000000000007000070000000000
          000000000000000000FF000000000000000000000000000000FF000000000000
          000000000000000000FF000000000000000000000000000000FF000000000000
          000000000000000000FF000000000000000000000000000000FF000700700000
          000000000000000000FF000000070000000000000000000000FF0000FF000707
          000000000000000000FF0007FF700000700000000000000000FF0007FF700FF0
          000000000000000700000007FF707FF80070000000000000077770007F708FF8
          00000000000000008FFFF87007708F870FF070000000700FFFFFFFFF0000FF80
          7FF00000000000FFFFFFFFFF0000FF70FFF07000000000FFF707FFF000008F07
          FF700000000000FFF70000007700000FFF070000000070FFFFF70007FF700008
          F00000000000000FFFFFFFFFFF7077000070000000000000FFFFFFFFFF70FF00
          000000000000000007FFFFFFF007FFF00000000000000000007FFFFFF70FFF70
          0000000000000000000FFFFFFFFFFF000000000000000000700078FFFFF87000
          700000000000000000F00000000000F0000000000000000000F87000000078F0
          000000000000000000FFFFFFFFFFFFF0000000000000000070078FFFFFFF8700
          7000000000000000070000000000000700000000000000000007000000000700
          00000000FF87FFFFFF03FFFFFF03FFFFFF03FFFFFF03FFFFFF03FFFFFF03FFFF
          FF021FFFFF000FFFFF0008FFFF00007FFF00007FFE00001FFC00000FF8000007
          F0000007F0000007F000000FF000000FF000001FF800001FFC00003FFE00007F
          FF0000FFFF8000FFFF00007FFF00007FFF00007FFF00007FFF00007FFF8000FF
          FFE003FF}
        ExplicitLeft = 584
      end
      object img3: TImage
        Left = 643
        Top = 185
        Width = 32
        Height = 32
        Anchors = [akTop, akRight]
        AutoSize = True
        Picture.Data = {
          055449636F6E0000010001002020100000000000E80200001600000028000000
          2000000040000000010004000000000080020000000000000000000010000000
          0000000000000000000080000080000000808000800000008000800080800000
          80808000C0C0C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000
          FFFFFF0000000000070070000000000000000000000000007000070000000000
          000000000000000000FF000000000000000000000000000000FF000000000000
          000000000000000000FF000000000000000000000000000000FF000000000000
          000000000000000000FF000000000000000000000000000000FF000700700000
          000000000000000000FF000000070000000000000000000000FF0000FF000707
          000000000000000000FF0007FF700000700000000000000000FF0007FF700FF0
          000000000000000700000007FF707FF80070000000000000077770007F708FF8
          00000000000000008FFFF87007708F870FF070000000700FFFFFFFFF0000FF80
          7FF00000000000FFFFFFFFFF0000FF70FFF07000000000FFF707FFF000008F07
          FF700000000000FFF70000007700000FFF070000000070FFFFF70007FF700008
          F00000000000000FFFFFFFFFFF7077000070000000000000FFFFFFFFFF70FF00
          000000000000000007FFFFFFF007FFF00000000000000000007FFFFFF70FFF70
          0000000000000000000FFFFFFFFFFF000000000000000000700078FFFFF87000
          700000000000000000F00000000000F0000000000000000000F87000000078F0
          000000000000000000FFFFFFFFFFFFF0000000000000000070078FFFFFFF8700
          7000000000000000070000000000000700000000000000000007000000000700
          00000000FF87FFFFFF03FFFFFF03FFFFFF03FFFFFF03FFFFFF03FFFFFF03FFFF
          FF021FFFFF000FFFFF0008FFFF00007FFF00007FFE00001FFC00000FF8000007
          F0000007F0000007F000000FF000000FF000001FF800001FFC00003FFE00007F
          FF0000FFFF8000FFFF00007FFF00007FFF00007FFF00007FFF00007FFF8000FF
          FFE003FF}
        ExplicitLeft = 584
      end
      object img4: TImage
        Left = 643
        Top = 257
        Width = 32
        Height = 32
        Anchors = [akTop, akRight]
        AutoSize = True
        Picture.Data = {
          055449636F6E0000010001002020100000000000E80200001600000028000000
          2000000040000000010004000000000080020000000000000000000010000000
          0000000000000000000080000080000000808000800000008000800080800000
          80808000C0C0C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000
          FFFFFF0000000000070070000000000000000000000000007000070000000000
          000000000000000000FF000000000000000000000000000000FF000000000000
          000000000000000000FF000000000000000000000000000000FF000000000000
          000000000000000000FF000000000000000000000000000000FF000700700000
          000000000000000000FF000000070000000000000000000000FF0000FF000707
          000000000000000000FF0007FF700000700000000000000000FF0007FF700FF0
          000000000000000700000007FF707FF80070000000000000077770007F708FF8
          00000000000000008FFFF87007708F870FF070000000700FFFFFFFFF0000FF80
          7FF00000000000FFFFFFFFFF0000FF70FFF07000000000FFF707FFF000008F07
          FF700000000000FFF70000007700000FFF070000000070FFFFF70007FF700008
          F00000000000000FFFFFFFFFFF7077000070000000000000FFFFFFFFFF70FF00
          000000000000000007FFFFFFF007FFF00000000000000000007FFFFFF70FFF70
          0000000000000000000FFFFFFFFFFF000000000000000000700078FFFFF87000
          700000000000000000F00000000000F0000000000000000000F87000000078F0
          000000000000000000FFFFFFFFFFFFF0000000000000000070078FFFFFFF8700
          7000000000000000070000000000000700000000000000000007000000000700
          00000000FF87FFFFFF03FFFFFF03FFFFFF03FFFFFF03FFFFFF03FFFFFF03FFFF
          FF021FFFFF000FFFFF0008FFFF00007FFF00007FFE00001FFC00000FF8000007
          F0000007F0000007F000000FF000000FF000001FF800001FFC00003FFE00007F
          FF0000FFFF8000FFFF00007FFF00007FFF00007FFF00007FFF00007FFF8000FF
          FFE003FF}
      end
      object btnStart: TButton
        Left = 610
        Top = 85
        Width = 97
        Height = 25
        Anchors = [akTop, akRight]
        Caption = #24320#22987#32771#35797
        TabOrder = 0
        OnClick = btnStartClick
      end
      object btnEndExam: TButton
        Left = 610
        Top = 154
        Width = 97
        Height = 25
        Anchors = [akTop, akRight]
        Caption = #32467#26463#32771#35797
        TabOrder = 1
        OnClick = btnEndExamClick
      end
      object btnExamineeSelect: TButton
        Left = 610
        Top = 16
        Width = 97
        Height = 25
        Anchors = [akTop, akRight]
        Caption = #26412#22330#32771#29983#23548#20837
        TabOrder = 2
        OnClick = btnExamineeSelectClick
      end
      object btnSaveExamineeInfo: TButton
        Left = 610
        Top = 223
        Width = 97
        Height = 25
        Anchors = [akTop, akRight]
        Caption = #20445#23384#32771#29983#20449#24687
        TabOrder = 3
        OnClick = btnSaveExamineeInfoClick
      end
      object btnExit: TButton
        Left = 610
        Top = 406
        Width = 97
        Height = 25
        Anchors = [akRight, akBottom]
        Caption = #36864#20986
        TabOrder = 4
        OnClick = btnExitClick
      end
      object cxGrid1: TcxGrid
        Left = 3
        Top = 3
        Width = 594
        Height = 428
        Anchors = [akLeft, akTop, akRight, akBottom]
        TabOrder = 5
        object tvExaminees: TcxGridTableView
          Navigator.Buttons.CustomButtons = <>
          DataController.Summary.DefaultGroupSummaryItems = <>
          DataController.Summary.FooterSummaryItems = <>
          DataController.Summary.SummaryGroups = <>
          OptionsCustomize.ColumnFiltering = False
          OptionsCustomize.ColumnGrouping = False
          OptionsCustomize.ColumnMoving = False
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Inserting = False
          OptionsSelection.CellSelect = False
          OptionsView.ShowEditButtons = gsebForFocusedRecord
          OptionsView.ColumnAutoWidth = True
          OptionsView.GroupByBox = False
          Styles.ContentEven = cxStyle4
          Styles.ContentOdd = cxStyle6
        end
        object grdlvlExaminees: TcxGridLevel
          GridView = tvExaminees
        end
      end
      object btnExamRecord: TButton
        Left = 610
        Top = 295
        Width = 97
        Height = 25
        Anchors = [akTop, akRight]
        Caption = #25171#21360#32771#22330#35760#24405
        TabOrder = 6
        OnClick = btnExamRecordClick
      end
      object btnLock: TButton
        Left = 610
        Top = 350
        Width = 97
        Height = 25
        Anchors = [akRight, akBottom]
        Caption = #38145#23450
        TabOrder = 7
      end
    end
    object tbshtConfig: TcxTabSheet
      Caption = #31995#32479#37197#32622
      ImageIndex = 1
      OnShow = tbshtConfigShow
      object grpbx1: TcxGroupBox
        Left = 24
        Top = 199
        Caption = #23458#25143#31471
        TabOrder = 0
        Height = 135
        Width = 585
        object lbl3: TcxLabel
          Left = 16
          Top = 24
          Caption = #29366#24577#21047#26032#38388#38548#65306
        end
        object spndtStatusRefreshInterval: TcxSpinEdit
          Left = 110
          Top = 20
          Properties.MaxValue = 300.000000000000000000
          Properties.MinValue = 3.000000000000000000
          Properties.OnChange = ConfigChange
          Style.StyleController = cxEditStyleController1
          TabOrder = 1
          Value = 3
          Width = 65
        end
        object lbl4: TcxLabel
          Left = 181
          Top = 24
          Caption = #65288#21333#20301#65306#31186#65289
        end
        object lbl2: TcxLabel
          Left = 16
          Top = 64
          Caption = #32771#29983#25805#20316#20301#32622#65306
        end
        object txtClientFolder: TcxMaskEdit
          Left = 110
          Top = 63
          Properties.OnChange = ConfigChange
          Style.StyleController = cxEditStyleController1
          TabOrder = 4
          Text = 'txtClientFolder'
          Width = 335
        end
      end
      object grpbx2: TcxGroupBox
        Left = 24
        Top = 24
        Caption = #26381#21153#22120#31471
        TabOrder = 1
        Height = 137
        Width = 585
        object lbl1: TcxLabel
          Left = 16
          Top = 72
          Caption = #32771#22330#25968#25454#23384#25918#36335#24452#65306
        end
        object cbbDataFolder: TcxShellComboBox
          Left = 134
          Top = 72
          Properties.ShowFullPath = sfpAlways
          Style.StyleController = cxEditStyleController1
          TabOrder = 1
          Width = 337
        end
        object cxlbl2: TcxLabel
          Left = 64
          Top = 25
          Caption = #23398#26657#20195#30721#65306
        end
        object txtSchoolCode: TcxMaskEdit
          Left = 134
          Top = 24
          Properties.EditMask = '!999;1;_'
          Properties.MaxLength = 0
          Properties.OnChange = ConfigChange
          Style.StyleController = cxEditStyleController1
          TabOrder = 3
          Text = '   '
          Width = 187
        end
        object cxLabel9: TcxLabel
          Left = 16
          Top = 113
          Caption = #32771#29983#25968#25454#22791#20221#36335#24452#65306
        end
        object cbbExamBakFolder: TcxShellComboBox
          Left = 134
          Top = 113
          Properties.ShowFullPath = sfpAlways
          Style.StyleController = cxEditStyleController1
          TabOrder = 5
          Width = 337
        end
      end
      object btnSaveConfig: TButton
        Left = 512
        Top = 432
        Width = 97
        Height = 25
        Caption = #20445#23384#20462#25913
        TabOrder = 2
        OnClick = btnSaveConfigClick
      end
      object btnConfigEdit: TButton
        Left = 296
        Top = 432
        Width = 97
        Height = 25
        Caption = #20462#25913#37197#32622
        TabOrder = 3
        OnClick = btnConfigEditClick
      end
      object btnConfigCancel: TButton
        Left = 409
        Top = 432
        Width = 97
        Height = 25
        Caption = #21462#28040#20462#25913
        TabOrder = 4
        OnClick = btnConfigCancelClick
      end
    end
    object tbshtSubmit: TcxTabSheet
      Caption = #27719#24635#19978#25253
      ImageIndex = 2
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      DesignSize = (
        732
        465)
      object redt1: TRichEdit
        Left = 16
        Top = 16
        Width = 697
        Height = 113
        Anchors = [akLeft, akTop, akRight]
        Enabled = False
        Font.Charset = GB2312_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        Lines.Strings = (
          #12288#12288#27719#24635#19978#25253#26159#25351#23558#25152#26377#32771#35797#26381#21153#22120#19978#30340#8220#25104#32489#24211#8221#27719#24635#21040#19968#20010#24635#30340#25104#32489#24211#26469#19978#25253#65292#21516#26102#20063#26041#20415#26816#26597#24050#32771#12289#26410#32771#12289#32570
          #32771#12289#20316#24330#12289#25104#32489#24322#24120#30340#32771#29983#65292#20351#19978#25253#25104#32489#25968#25454#26356#21152#20934#30830#23436#25972#12290
          #12288#12288#27719#24635#26102#65292#35831#23558#25152#26377#26381#21153#22120#19978#30340#8220#25104#32489#24211'.mdb'#8221#25991#20214#22797#21046#21040#19968#20010#25991#20214#22841#20013#65292#28857#20987#27719#24635#65292#31243#24207#23558#33258#21160#23558#25351#23450#25991#20214#22841#19979#25152#26377#25104#32489#24211#27719#24635
          #21040#19968#20010#25991#20214#12290
          #12288#12288#19978#25253#26102#65292#21482#38656#23558#27719#24635#24471#21040#30340#19968#20010#8220#25104#32489#24211'.mdb'#8221#19978#25253#21363#21487#12290)
        ParentFont = False
        ReadOnly = True
        TabOrder = 0
        Zoom = 100
      end
      object cxLabel10: TcxLabel
        Left = 40
        Top = 144
        Caption = #38656#21512#24182#25104#32489#24211#25991#20214#22841#65306
      end
      object scbTotalDir: TcxShellComboBox
        Left = 190
        Top = 143
        Properties.ShowFullPath = sfpAlways
        Style.StyleController = cxEditStyleController1
        TabOrder = 2
        Width = 337
      end
      object btnTotals: TButton
        Left = 550
        Top = 139
        Width = 97
        Height = 25
        Caption = #27719#24635
        TabOrder = 3
        OnClick = btnTotalsClick
      end
      object lst1: TListBox
        Left = 16
        Top = 167
        Width = 193
        Height = 274
        ItemHeight = 13
        TabOrder = 4
      end
      object cxGrid2: TcxGrid
        Left = 224
        Top = 170
        Width = 505
        Height = 266
        Anchors = [akLeft, akTop, akRight, akBottom]
        TabOrder = 5
        object tvSource: TcxGridDBTableView
          Navigator.Buttons.CustomButtons = <>
          DataController.Summary.DefaultGroupSummaryItems = <>
          DataController.Summary.FooterSummaryItems = <
            item
              Kind = skCount
              FieldName = 'ExamineeName'
            end>
          DataController.Summary.SummaryGroups = <>
          OptionsData.Deleting = False
          OptionsData.Inserting = False
          OptionsView.Footer = True
          object clmnSourceExamineeNo: TcxGridDBColumn
            DataBinding.FieldName = 'ExamineeID'
            Width = 99
          end
          object clmnSourceExamineeName: TcxGridDBColumn
            DataBinding.FieldName = 'ExamineeName'
          end
          object clmnSourceIP: TcxGridDBColumn
            DataBinding.FieldName = 'IP'
          end
          object clmnSourcePort: TcxGridDBColumn
            DataBinding.FieldName = 'Port'
            Width = 51
          end
          object clmnSourceStatus: TcxGridDBColumn
            DataBinding.FieldName = 'Status'
          end
          object clmnSourceRemainTime: TcxGridDBColumn
            DataBinding.FieldName = 'RemainTime'
          end
          object clmnSourceTimeStamp: TcxGridDBColumn
            DataBinding.FieldName = 'Stamp'
          end
        end
        object cxGrid1Level1: TcxGridLevel
          GridView = tvSource
        end
      end
    end
    object tbshtExamineeInfoImport: TcxTabSheet
      Caption = #32771#29983#20449#24687#23548#20837
      ImageIndex = 4
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
    end
    object tbshtCheckZero: TcxTabSheet
      Caption = 'tbshtCheckZero'
      ImageIndex = 5
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
    end
  end
  object dxbrmngrMainMenu: TdxBarManager
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Microsoft YaHei UI'
    Font.Style = []
    Categories.Strings = (
      'Default'
      'popupmenu1')
    Categories.ItemsVisibles = (
      2
      2)
    Categories.Visibles = (
      True
      True)
    MenuAnimations = maRandom
    PopupMenuLinks = <>
    UseSystemFont = True
    Left = 520
    Top = 8
    DockControlHeights = (
      0
      0
      28
      0)
    object dxbrmngrMainMenuBar1: TdxBar
      Caption = 'MainMenu'
      CaptionButtons = <>
      DockedDockingStyle = dsTop
      DockedLeft = 0
      DockedTop = 0
      DockingStyle = dsTop
      FloatLeft = 701
      FloatTop = 8
      FloatClientWidth = 0
      FloatClientHeight = 0
      ItemLinks = <
        item
          Visible = True
          ItemName = 'mnbtnAllExamineeInfoImport'
        end>
      OneOnRow = True
      Row = 0
      UseOwnFont = False
      Visible = True
      WholeRow = False
    end
    object mnbtnAllExamineeInfoImport: TdxBarButton
      Caption = #32771#29983#20449#24687#23548#20837
      Category = 0
      Hint = #32771#29983#20449#24687#23548#20837
      Visible = ivAlways
      OnClick = mnbtnAllExamineeInfoImportClick
    end
    object dxBarSeparator1: TdxBarSeparator
      Caption = 'New Separator'
      Category = 0
      Hint = 'New Separator'
      Visible = ivAlways
    end
    object pmbtnReExam: TdxBarButton
      Caption = #20801#35768#37325#32771
      Category = 1
      Hint = #20801#35768#37325#32771
      Visible = ivAlways
      OnClick = pmbtnReExamClick
    end
    object pmbtnContinuteExam: TdxBarButton
      Caption = #20801#35768#32493#32771
      Category = 1
      Hint = #20801#35768#32493#32771
      Visible = ivAlways
      OnClick = pmbtnContinuteExamClick
    end
    object mnbtnAbsent: TdxBarButton
      Caption = #32570#32771
      Category = 1
      Hint = #32570#32771
      Visible = ivAlways
      OnClick = mnbtnAbsentClick
    end
    object mnbtnCrib: TdxBarButton
      Caption = #20316#24330
      Category = 1
      Hint = #20316#24330
      Visible = ivAlways
      OnClick = mnbtnCribClick
    end
  end
  object cxStyleRepository1: TcxStyleRepository
    Left = 472
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
  object cxGridPopupMenu1: TcxGridPopupMenu
    Grid = cxGrid1
    PopupMenus = <
      item
        GridView = tvExaminees
        HitTypes = [gvhtCell, gvhtRecord]
        Index = 0
        PopupMenu = dxBarPopupMenu1
      end>
    UseBuiltInPopupMenus = False
    AlwaysFireOnPopup = True
    Left = 616
    Top = 8
  end
  object dxBarPopupMenu1: TdxBarPopupMenu
    BarManager = dxbrmngrMainMenu
    ItemLinks = <
      item
        Visible = True
        ItemName = 'pmbtnReExam'
      end
      item
        Visible = True
        ItemName = 'pmbtnContinuteExam'
      end
      item
        BeginGroup = True
        Visible = True
        ItemName = 'mnbtnAbsent'
      end
      item
        Visible = True
        ItemName = 'mnbtnCrib'
      end>
    UseOwnFont = False
    Left = 568
    Top = 8
  end
  object cxEditStyleController1: TcxEditStyleController
    Style.TextColor = clRed
    StyleDisabled.TextColor = clBlue
    Left = 672
    Top = 8
    PixelsPerInch = 96
  end
end
