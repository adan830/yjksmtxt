object FormMainServer: TFormMainServer
  Left = 146
  Top = 115
  BorderStyle = bsToolWindow
  Caption = #23433#24509#39640#31561#23398#26657#65288#23433#24509#32771#21306#65289#35745#31639#26426#27700#24179#32771#35797#19968#32423'Windows'#26381#21153#22120
  ClientHeight = 531
  ClientWidth = 739
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWhite
  Font.Height = -19
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poDesigned
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 19
  object pgServer: TcxPageControl
    Left = 0
    Top = 28
    Width = 739
    Height = 503
    Align = alClient
    TabOrder = 4
    Properties.ActivePage = tbshtConfig
    Properties.CustomButtons.Buttons = <>
    Properties.HotTrack = True
    Properties.ShowFrame = True
    Properties.Style = 7
    Properties.TabSlants.Kind = skCutCorner
    LookAndFeel.Kind = lfOffice11
    LookAndFeel.NativeStyle = True
    TabSlants.Kind = skCutCorner
    OnPageChanging = pgServerPageChanging
    ClientRectBottom = 502
    ClientRectLeft = 1
    ClientRectRight = 738
    ClientRectTop = 27
    object tbshtMonitor: TcxTabSheet
      Caption = #32771#35797#30417#25511
      Color = 16775666
      ImageIndex = 0
      ParentColor = False
      DesignSize = (
        737
        475)
      object img1: TImage
        Left = 648
        Top = 42
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
      object img2: TImage
        Left = 648
        Top = 109
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
      object img3: TImage
        Left = 648
        Top = 176
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
      object btnGrade: TCnSpeedButton
        Left = 171
        Top = 107
        Width = 115
        Height = 30
        Anchors = [akRight]
        Color = 15966293
        DownBold = False
        FlatBorder = False
        HotTrackBold = False
        HotTrackColor = 16551233
        ModernBtnStyle = bsFlat
        Caption = #35299#38145
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = 14
        Font.Name = #23435#20307
        Font.Style = [fsBold]
        Margin = 4
        ParentFont = False
        ExplicitLeft = -92
        ExplicitTop = 11
      end
      object btnStart: TCnSpeedButton
        Left = 607
        Top = 77
        Width = 115
        Height = 30
        Anchors = [akRight]
        Color = 15966293
        DownBold = False
        FlatBorder = False
        HotTrackBold = False
        HotTrackColor = 16551233
        ModernBtnStyle = bsFlat
        Caption = #24320#22987#32771#35797
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = 14
        Font.Name = #23435#20307
        Font.Style = [fsBold]
        Margin = 4
        ParentFont = False
        OnClick = btnStartClick
      end
      object btnEndExam: TCnSpeedButton
        Left = 607
        Top = 143
        Width = 115
        Height = 30
        Anchors = [akRight]
        Color = 15966293
        DownBold = False
        FlatBorder = False
        HotTrackBold = False
        HotTrackColor = 16551233
        ModernBtnStyle = bsFlat
        Caption = #32467#26463#32771#35797
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = 14
        Font.Name = #23435#20307
        Font.Style = [fsBold]
        Margin = 4
        ParentFont = False
        OnClick = btnEndExamClick
      end
      object btnExamineeSelect: TCnSpeedButton
        Left = 607
        Top = 11
        Width = 115
        Height = 30
        Anchors = [akRight]
        Color = 15966293
        DownBold = False
        FlatBorder = False
        HotTrackBold = False
        HotTrackColor = 16551233
        ModernBtnStyle = bsFlat
        Caption = #26412#22330#32771#29983#23548#20837
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = 14
        Font.Name = #23435#20307
        Font.Style = [fsBold]
        Margin = 4
        ParentFont = False
        OnClick = btnExamineeSelectClick
      end
      object btnExamRecord: TCnSpeedButton
        Left = 607
        Top = 205
        Width = 115
        Height = 30
        Anchors = [akRight]
        Color = 15966293
        DownBold = False
        FlatBorder = False
        HotTrackBold = False
        HotTrackColor = 16551233
        ModernBtnStyle = bsFlat
        Caption = #25171#21360#32771#22330#35760#24405
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = 14
        Font.Name = #23435#20307
        Font.Style = [fsBold]
        Margin = 4
        ParentFont = False
        OnClick = btnExamRecordClick
      end
      object btnCheckZero: TCnSpeedButton
        Left = 607
        Top = 276
        Width = 115
        Height = 30
        Anchors = [akRight]
        Color = 15966293
        DownBold = False
        FlatBorder = False
        HotTrackBold = False
        HotTrackColor = 16551233
        ModernBtnStyle = bsFlat
        Caption = #26597#38646#20998
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = 14
        Font.Name = #23435#20307
        Font.Style = [fsBold]
        Margin = 4
        ParentFont = False
      end
      object btnLock: TCnSpeedButton
        Left = 607
        Top = 340
        Width = 115
        Height = 30
        Anchors = [akRight]
        Color = 15966293
        DownBold = False
        FlatBorder = False
        HotTrackBold = False
        HotTrackColor = 16551233
        ModernBtnStyle = bsFlat
        Caption = #38145#23450
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = 14
        Font.Name = #23435#20307
        Font.Style = [fsBold]
        Margin = 4
        ParentFont = False
        OnClick = btnLockClick
      end
      object btnExit: TCnSpeedButton
        Left = 607
        Top = 411
        Width = 115
        Height = 30
        Anchors = [akRight]
        Color = 3184887
        DownBold = False
        FlatBorder = False
        HotTrackBold = False
        HotTrackColor = 16551233
        ModernBtnStyle = bsFlat
        Caption = #36864#20986
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = 14
        Font.Name = #23435#20307
        Font.Style = [fsBold]
        Margin = 4
        ParentFont = False
        OnClick = btnExitClick
      end
      object Image1: TImage
        Left = 648
        Top = 241
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
      object cxGrid1: TcxGrid
        Left = 3
        Top = 3
        Width = 582
        Height = 438
        Anchors = [akLeft, akTop, akRight, akBottom]
        BevelInner = bvNone
        BevelOuter = bvNone
        TabOrder = 0
        object tvExaminees: TcxGridTableView
          Navigator.Buttons.CustomButtons = <>
          DataController.Summary.DefaultGroupSummaryItems = <>
          DataController.Summary.FooterSummaryItems = <>
          DataController.Summary.SummaryGroups = <>
          OptionsBehavior.ColumnHeaderHints = False
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
    end
    object tbshtConfig: TcxTabSheet
      Caption = #31995#32479#37197#32622
      ImageIndex = 1
      OnShow = tbshtConfigShow
      object cxGroupBox1: TcxGroupBox
        Left = 152
        Top = 494
        Caption = #32493#32771#12289#24310#32771#12289#37325#32771#35774#32622#65306
        TabOrder = 0
        Height = 67
        Width = 585
      end
      object GridPanel2: TGridPanel
        Left = 0
        Top = 0
        Width = 737
        Height = 475
        Align = alClient
        BevelOuter = bvNone
        Caption = 'GridPanel2'
        Color = clWhite
        ColumnCollection = <
          item
            Value = 49.996347923022810000
          end
          item
            SizeStyle = ssAbsolute
            Value = 600.000000000000000000
          end
          item
            Value = 50.003652076977180000
          end>
        ControlCollection = <
          item
            Column = 1
            Control = Panel1
            Row = 2
          end
          item
            Column = 1
            Control = Panel2
            Row = 1
          end>
        ParentBackground = False
        RowCollection = <
          item
            Value = 21.875000000000000000
          end
          item
            SizeStyle = ssAbsolute
            Value = 300.000000000000000000
          end
          item
            Value = 78.125000000000000000
          end>
        TabOrder = 1
        object Panel1: TPanel
          Left = 68
          Top = 338
          Width = 600
          Height = 137
          Align = alClient
          BevelOuter = bvNone
          Caption = 'Panel1'
          Color = clWhite
          ParentBackground = False
          ShowCaption = False
          TabOrder = 0
          DesignSize = (
            600
            137)
          object btnSaveConfig: TCnSpeedButton
            Left = 504
            Top = 25
            Width = 82
            Height = 30
            Anchors = [akTop]
            Color = 15966293
            DownBold = False
            FlatBorder = False
            HotTrackBold = False
            HotTrackColor = 16551233
            ModernBtnStyle = bsFlat
            Caption = #20445#23384#20462#25913
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWhite
            Font.Height = 14
            Font.Name = #23435#20307
            Font.Style = [fsBold]
            Margin = 4
            ParentFont = False
            OnClick = btnSaveConfigClick
          end
          object btnConfigCancel: TCnSpeedButton
            Left = 392
            Top = 25
            Width = 82
            Height = 30
            Anchors = [akTop]
            Color = 15966293
            DownBold = False
            FlatBorder = False
            HotTrackBold = False
            HotTrackColor = 16551233
            ModernBtnStyle = bsFlat
            Caption = #21462#28040#20462#25913
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWhite
            Font.Height = 14
            Font.Name = #23435#20307
            Font.Style = [fsBold]
            Margin = 4
            ParentFont = False
            OnClick = btnConfigCancelClick
          end
          object btnConfigEdit: TCnSpeedButton
            Left = 272
            Top = 25
            Width = 82
            Height = 30
            Anchors = [akTop]
            Color = 15966293
            DownBold = False
            FlatBorder = False
            HotTrackBold = False
            HotTrackColor = 16551233
            ModernBtnStyle = bsFlat
            Caption = #20462#25913#37197#32622
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWhite
            Font.Height = 14
            Font.Name = #23435#20307
            Font.Style = [fsBold]
            Margin = 4
            ParentFont = False
            OnClick = btnConfigEditClick
          end
          object btnResetExamPwd: TCnSpeedButton
            Left = 152
            Top = 25
            Width = 82
            Height = 30
            Anchors = [akTop]
            Color = 15966293
            DownBold = False
            FlatBorder = False
            HotTrackBold = False
            HotTrackColor = 16551233
            ModernBtnStyle = bsFlat
            Caption = #37325#35774#23494#30721
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWhite
            Font.Height = 14
            Font.Name = #23435#20307
            Font.Style = [fsBold]
            Margin = 4
            ParentFont = False
            OnClick = btnResetExamPwdClick
          end
        end
        object Panel2: TPanel
          Left = 68
          Top = 38
          Width = 600
          Height = 300
          Align = alClient
          Anchors = []
          Caption = 'Panel2'
          Color = clWhite
          ParentBackground = False
          ShowCaption = False
          TabOrder = 1
          DesignSize = (
            600
            300)
          object grpbx2: TcxGroupBox
            Left = 3
            Top = 0
            Align = alCustom
            Caption = #26381#21153#22120#31471
            Style.BorderColor = 15966293
            Style.Edges = [bTop]
            Style.Shadow = False
            TabOrder = 0
            DesignSize = (
              590
              130)
            Height = 130
            Width = 590
            object btnOpenFirewallPort: TCnSpeedButton
              Left = 187
              Top = 93
              Width = 238
              Height = 30
              Anchors = [akTop]
              Color = 15966293
              DownBold = False
              FlatBorder = False
              HotTrackBold = False
              HotTrackColor = 16551233
              ModernBtnStyle = bsFlat
              Caption = #25171#24320#38450#28779#22681#30340#32771#35797#26381#21153#31471#21475
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWhite
              Font.Height = 14
              Font.Name = #23435#20307
              Font.Style = [fsBold]
              Margin = 4
              ParentFont = False
              OnClick = btnOpenFirewallPortClick
            end
            object lbl1: TcxLabel
              Left = 21
              Top = 31
              Caption = #26381#21153#22120#25968#25454#23384#25918#36335#24452#65306
              ParentFont = False
              Style.Font.Charset = DEFAULT_CHARSET
              Style.Font.Color = clBlack
              Style.Font.Height = -19
              Style.Font.Name = #23435#20307
              Style.Font.Style = []
              Style.IsFontAssigned = True
            end
            object cbbDataFolder: TcxShellComboBox
              Left = 32
              Top = 60
              Hint = #23384#25918#32771#29983#19978#25253#25991#20214#65292#40664#35748#20026#26381#21153#22120#31243#24207#25152#22312#25991#20214#22841
              ParentShowHint = False
              Properties.ShowFullPath = sfpAlways
              ShowHint = True
              Style.StyleController = cxEditStyleController1
              Style.TextColor = clBlue
              StyleFocused.TextColor = clRed
              TabOrder = 1
              Width = 555
            end
            object cxlbl2: TcxLabel
              Left = 506
              Top = 54
              Caption = #23398#26657#20195#30721#65306
              Visible = False
            end
            object txtSchoolCode: TcxMaskEdit
              Left = 477
              Top = 77
              Hint = #29992#20110#32771#21495#30340#26657#39564#65292#21487#24573#30053#65281
              Properties.EditMask = '!999;1;_'
              Properties.MaxLength = 0
              Properties.OnChange = ConfigChange
              Style.StyleController = cxEditStyleController1
              TabOrder = 3
              Text = '   '
              Visible = False
              Width = 187
            end
            object cxLabel9: TcxLabel
              Left = 281
              Top = 7
              Caption = #32771#29983#25968#25454#22791#20221#36335#24452#65306
              Visible = False
            end
            object cbbExamBakFolder: TcxShellComboBox
              Left = 399
              Top = 3
              ParentShowHint = False
              Properties.ShowFullPath = sfpAlways
              ShowHint = True
              Style.StyleController = cxEditStyleController1
              TabOrder = 5
              Visible = False
              Width = 337
            end
            object cxLabel12: TcxLabel
              Left = 305
              Top = 39
              Caption = #32771#29983#30456#29255#36335#24452#65306
              Visible = False
            end
            object cbbExamineePhotoFolder: TcxShellComboBox
              Left = 399
              Top = 38
              Hint = #20301#20110#26381#21153#22120#19978#30340#32771#29983#30456#29255#30446#24405#65292#22312#32771#29983#20449#24687#23548#20837#26102#20250#23558#32771#29983#30456#29255#23384#25918#20110#27492#12290
              ParentShowHint = False
              Properties.ShowFullPath = sfpAlways
              ShowHint = True
              Style.StyleController = cxEditStyleController1
              TabOrder = 7
              Visible = False
              Width = 337
            end
          end
          object grpbx1: TcxGroupBox
            Left = 3
            Top = 152
            Anchors = []
            Caption = #32771#29983#31471
            TabOrder = 1
            Height = 142
            Width = 590
            object lbl3: TcxLabel
              Left = 341
              Top = 56
              Caption = #29366#24577#21047#26032#38388#38548#65306
              Visible = False
            end
            object spndtStatusRefreshInterval: TcxSpinEdit
              Left = 435
              Top = 52
              Properties.MaxValue = 300.000000000000000000
              Properties.MinValue = 3.000000000000000000
              Properties.OnChange = ConfigChange
              Style.StyleController = cxEditStyleController1
              TabOrder = 1
              Value = 3
              Visible = False
              Width = 65
            end
            object lbl4: TcxLabel
              Left = 506
              Top = 56
              Caption = #65288#21333#20301#65306#31186#65289
              Visible = False
            end
            object lbl2: TcxLabel
              Left = 21
              Top = 24
              Caption = #23458#25143#26426#32771#29983#25991#20214#22841#65306
              ParentColor = False
              ParentFont = False
              Style.Color = clWhite
              Style.Font.Charset = DEFAULT_CHARSET
              Style.Font.Color = clBlack
              Style.Font.Height = -19
              Style.Font.Name = #23435#20307
              Style.Font.Style = []
              Style.IsFontAssigned = True
            end
            object txtClientFolder: TcxMaskEdit
              Left = 32
              Top = 53
              Hint = #25351#23450#35813#30446#24405#26159#25351#26126#23398#29983#26426#19978#32771#29983#32771#35797#25991#20214#22841#30340#20301#32622#12290#13#10#35831#30830#20445#35813' '#25991#20214#22841'$0d'#22312#32771#29983#26426#19978#23384#22312#65292#13#10#21542#21017#20250#20986#29616#29983#25104#32771#35797#29615#22659#20986#38169#25552#31034#65281
              ParentShowHint = False
              Properties.OnChange = ConfigChange
              ShowHint = True
              Style.StyleController = cxEditStyleController1
              Style.TextColor = clBlue
              StyleFocused.TextColor = clRed
              TabOrder = 4
              Text = 'txtClientFolder'
              Width = 550
            end
            object radiogrpRetryModel: TcxRadioGroup
              Left = 126
              Top = 86
              Hint = 
                'this is a test for show hint test word'#13#10' break for when the even' +
                't happen'
              ParentFont = False
              ParentShowHint = False
              Properties.Columns = 2
              Properties.DefaultValue = 0
              Properties.Items = <
                item
                  Caption = #32771#29983#26426#36890#36807#23494#30721#25805#20316
                  Value = 0
                end
                item
                  Caption = #26381#21153#22120#31471#25805#20316
                  Value = 1
                end>
              ItemIndex = 0
              ShowHint = True
              Style.Font.Charset = DEFAULT_CHARSET
              Style.Font.Color = clWindowText
              Style.Font.Height = -19
              Style.Font.Name = 'Tahoma'
              Style.Font.Style = []
              Style.IsFontAssigned = True
              TabOrder = 5
              Height = 45
              Width = 461
            end
            object cxLabel11: TcxLabel
              Left = 21
              Top = 104
              Caption = #25805#20316#27169#24335#65306
              ParentFont = False
              Style.Font.Charset = DEFAULT_CHARSET
              Style.Font.Color = clBlack
              Style.Font.Height = -19
              Style.Font.Name = #23435#20307
              Style.Font.Style = []
              Style.IsFontAssigned = True
            end
          end
        end
      end
    end
    object tbshtTQBInfo: TcxTabSheet
      Caption = #39064#24211#20449#24687
      ImageIndex = 3
      object GridPanel1: TGridPanel
        Left = 0
        Top = 0
        Width = 737
        Height = 475
        Align = alClient
        BevelOuter = bvNone
        Caption = 'GridPanel1'
        Color = clWhite
        ColumnCollection = <
          item
            Value = 50.000000372529040000
          end
          item
            SizeStyle = ssAbsolute
            Value = 600.000000000000000000
          end
          item
            Value = 49.999999627470970000
          end>
        ControlCollection = <
          item
            Column = 1
            Control = grpbx3
            Row = 1
          end>
        ParentBackground = False
        RowCollection = <
          item
            Value = 23.444920794882010000
          end
          item
            SizeStyle = ssAbsolute
            Value = 300.000000000000000000
          end
          item
            Value = 76.555079205117990000
          end>
        TabOrder = 0
        object grpbx3: TcxGroupBox
          Left = 68
          Top = 41
          Align = alClient
          Caption = #39064#24211#20449#24687
          TabOrder = 0
          Height = 300
          Width = 600
          object cxLabel1: TcxLabel
            Left = 104
            Top = 32
            Caption = #39064#24211#21517#31216#65306
            ParentFont = False
            Style.Font.Charset = DEFAULT_CHARSET
            Style.Font.Color = clBlack
            Style.Font.Height = -19
            Style.Font.Name = #23435#20307
            Style.Font.Style = []
            Style.IsFontAssigned = True
          end
          object edtName: TcxTextEdit
            Left = 210
            Top = 31
            Enabled = False
            Properties.ReadOnly = True
            Style.StyleController = cxEditStyleController1
            TabOrder = 1
            Width = 367
          end
          object cxLabel2: TcxLabel
            Left = 104
            Top = 72
            Caption = #39064#24211#31867#22411#65306
            ParentFont = False
            Style.Font.Charset = DEFAULT_CHARSET
            Style.Font.Color = clBlack
            Style.Font.Height = -19
            Style.Font.Name = #23435#20307
            Style.Font.Style = []
            Style.IsFontAssigned = True
          end
          object cxLabel3: TcxLabel
            Left = 104
            Top = 112
            Caption = #26377#25928#26085#26399#65306
            ParentFont = False
            Style.Font.Charset = DEFAULT_CHARSET
            Style.Font.Color = clBlack
            Style.Font.Height = -19
            Style.Font.Name = #23435#20307
            Style.Font.Style = []
            Style.IsFontAssigned = True
          end
          object cxLabel4: TcxLabel
            Left = 104
            Top = 152
            Caption = #25104#32489#26174#31034#65306
            ParentFont = False
            Style.Font.Charset = DEFAULT_CHARSET
            Style.Font.Color = clBlack
            Style.Font.Height = -19
            Style.Font.Name = #23435#20307
            Style.Font.Style = []
            Style.IsFontAssigned = True
          end
          object edtType: TcxTextEdit
            Left = 210
            Top = 70
            Enabled = False
            Properties.ReadOnly = True
            Style.StyleController = cxEditStyleController1
            TabOrder = 5
            Width = 367
          end
          object edtDuration: TcxTextEdit
            Left = 210
            Top = 110
            Enabled = False
            Properties.ReadOnly = True
            Style.StyleController = cxEditStyleController1
            TabOrder = 6
            Width = 367
          end
          object edtScoreDisp: TcxTextEdit
            Left = 210
            Top = 150
            Enabled = False
            Properties.ReadOnly = True
            Style.StyleController = cxEditStyleController1
            TabOrder = 7
            Width = 367
          end
          object edtStkDbFilePath: TcxTextEdit
            Left = 209
            Top = 256
            Enabled = False
            Properties.ReadOnly = True
            Style.StyleController = cxEditStyleController1
            TabOrder = 8
            Width = 368
          end
          object lbl5: TcxLabel
            Left = 104
            Top = 256
            Caption = #39064#24211#36335#24452#65306
            ParentFont = False
            Style.Font.Charset = DEFAULT_CHARSET
            Style.Font.Color = clBlack
            Style.Font.Height = -19
            Style.Font.Name = #23435#20307
            Style.Font.Style = []
            Style.IsFontAssigned = True
          end
          object edtTypeTime: TcxTextEdit
            Left = 209
            Top = 221
            Enabled = False
            Style.StyleController = cxEditStyleController1
            TabOrder = 10
            Width = 121
          end
          object cxLabel8: TcxLabel
            Left = 47
            Top = 221
            Caption = #25171#23383#26102#38388#65288#31186#65289#65306
            ParentFont = False
            Style.Font.Charset = DEFAULT_CHARSET
            Style.Font.Color = clBlack
            Style.Font.Height = -19
            Style.Font.Name = #23435#20307
            Style.Font.Style = []
            Style.IsFontAssigned = True
          end
          object edtExamTime: TcxTextEdit
            Left = 209
            Top = 185
            Enabled = False
            Style.StyleController = cxEditStyleController1
            TabOrder = 12
            Width = 121
          end
          object cxLabel7: TcxLabel
            Left = 47
            Top = 184
            Caption = #32771#35797#26102#38388#65288#31186#65289#65306
            ParentFont = False
            Style.Font.Charset = DEFAULT_CHARSET
            Style.Font.Color = clBlack
            Style.Font.Height = -19
            Style.Font.Name = #23435#20307
            Style.Font.Style = []
            Style.IsFontAssigned = True
          end
        end
      end
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
    Left = 408
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
        end
        item
          Visible = True
          ItemName = 'dxBarButton1'
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
    object dxBarButton1: TdxBarButton
      Caption = #27719#24635#19978#25253
      Category = 0
      Hint = #27719#24635#19978#25253
      Visible = ivAlways
    end
    object dxBarButton2: TdxBarButton
      Caption = 'New Button'
      Category = 0
      Hint = 'New Button'
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
    object mnbtnNormal: TdxBarButton
      Caption = #27491#24120
      Category = 1
      Hint = #27491#24120
      Visible = ivAlways
    end
  end
  object cxStyleRepository1: TcxStyleRepository
    Left = 312
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
  object grdPopupMenu: TcxGridPopupMenu
    Grid = cxGrid1
    PopupMenus = <
      item
        GridView = tvExaminees
        HitTypes = [gvhtCell, gvhtRecord]
        Index = 0
        PopupMenu = barPopupMenu
      end>
    UseBuiltInPopupMenus = False
    AlwaysFireOnPopup = True
    Left = 600
    Top = 8
  end
  object barPopupMenu: TdxBarPopupMenu
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
      end
      item
        Visible = True
        ItemName = 'mnbtnNormal'
      end>
    UseOwnFont = False
    OnPopup = barPopupMenuPopup
    Left = 504
    Top = 8
  end
  object cxEditStyleController1: TcxEditStyleController
    Style.TextColor = clRed
    StyleDisabled.TextColor = clBlue
    Left = 672
    Top = 8
    PixelsPerInch = 96
  end
  object Report: TfrxReport
    Version = '5.1.5'
    DotMatrixReport = False
    IniFile = '\Software\Fast Reports'
    PreviewOptions.Buttons = [pbPrint, pbLoad, pbSave, pbExport, pbZoom, pbFind, pbOutline, pbPageSetup, pbTools, pbEdit, pbNavigator, pbExportQuick]
    PreviewOptions.Zoom = 1.000000000000000000
    PrintOptions.Printer = 'Default'
    PrintOptions.PrintOnSheet = 0
    ReportOptions.CreateDate = 39637.370979594900000000
    ReportOptions.LastChange = 42224.785221851850000000
    ScriptLanguage = 'PascalScript'
    ScriptText.Strings = (
      'begin'
      ''
      'end.')
    OnGetValue = ReportGetValue
    Left = 337
    Top = 119
    Datasets = <>
    Variables = <
      item
        Name = ' MyVar'
        Value = Null
      end
      item
        Name = 'vSchoolName'
        Value = Null
      end
      item
        Name = 'vCode'
        Value = Null
      end
      item
        Name = 'vTotalNum'
        Value = Null
      end
      item
        Name = 'vExamTime'
        Value = Null
      end
      item
        Name = 'vExamID'
        Value = ''
      end>
    Style = <
      item
        Name = 'Title'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -16
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        Fill.BackColor = clGray
      end
      item
        Name = 'Header'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clMaroon
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
      end
      item
        Name = 'Group header'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clMaroon
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        Fill.BackColor = 16053492
      end
      item
        Name = 'Data'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = []
      end
      item
        Name = 'Group footer'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
      end
      item
        Name = 'Header line'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftBottom]
        Frame.Width = 2.000000000000000000
      end>
    object Data: TfrxDataPage
      Height = 1000.000000000000000000
      Width = 1000.000000000000000000
    end
    object Page1: TfrxReportPage
      PaperWidth = 210.000000000000000000
      PaperHeight = 297.000000000000000000
      PaperSize = 9
      LeftMargin = 10.000000000000000000
      RightMargin = 10.000000000000000000
      TopMargin = 10.000000000000000000
      BottomMargin = 10.000000000000000000
      object ReportTitle1: TfrxReportTitle
        FillType = ftBrush
        Height = 45.354360000000000000
        Top = 18.897650000000000000
        Width = 718.110700000000000000
        object Memo4: TfrxMemoView
          Align = baCenter
          Left = 264.567100000000000000
          Width = 188.976500000000000000
          Height = 18.897650000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          HAlign = haCenter
          Memo.UTF8W = (
            #19978#26426#32771#35797#30417#32771#35760#24405#34920)
          ParentFont = False
        end
      end
      object PageHeader1: TfrxPageHeader
        FillType = ftBrush
        Height = 60.472480000000000000
        Top = 86.929190000000000000
        Width = 718.110700000000000000
        object Memo2: TfrxMemoView
          Width = 71.810606220000000000
          Height = 22.677180000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftBottom]
          Frame.Width = 2.000000000000000000
          Memo.UTF8W = (
            #32771#28857#21517#31216':')
          ParentFont = False
          Style = 'Header line'
        end
        object Memo7: TfrxMemoView
          Left = 317.480520000000000000
          Width = 71.810606220000000000
          Height = 22.677180000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftBottom]
          Frame.Width = 2.000000000000000000
          Memo.UTF8W = (
            #35838#31243#20195#21495':')
          ParentFont = False
          Style = 'Header line'
        end
        object Memo9: TfrxMemoView
          Left = 476.220780000000000000
          Width = 71.810606220000000000
          Height = 22.677180000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftBottom]
          Frame.Width = 2.000000000000000000
          Memo.UTF8W = (
            #32771#22330#32534#21495':')
          ParentFont = False
          Style = 'Header line'
        end
        object Memo11: TfrxMemoView
          Top = 37.795300000000000000
          Width = 128.503556220000000000
          Height = 22.677180000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftBottom]
          Frame.Width = 2.000000000000000000
          Memo.UTF8W = (
            #32570#32771#21450#20316#24330#35760#24405':')
          ParentFont = False
          Style = 'Header line'
        end
        object vSchoolName: TfrxMemoView
          Left = 75.590600000000000000
          Top = 3.779530000000000000
          Width = 185.196970000000000000
          Height = 18.897650000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Memo.UTF8W = (
            '[vSchoolName]')
          ParentFont = False
        end
        object vCode: TfrxMemoView
          Left = 389.291590000000000000
          Top = 3.779530000000000000
          Width = 79.370130000000000000
          Height = 18.897650000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Memo.UTF8W = (
            '[vCode]')
          ParentFont = False
        end
        object Memo1: TfrxMemoView
          Left = 551.811380000000000000
          Width = 158.740260000000000000
          Height = 18.897650000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Memo.UTF8W = (
            '[vExamID]')
          ParentFont = False
        end
      end
      object MasterData1: TfrxMasterData
        FillType = ftBrush
        Height = 18.897650000000000000
        Top = 207.874150000000000000
        Width = 718.110700000000000000
        RowCount = 0
        object ReportDS: TfrxMemoView
          Left = 3.779530000000000000
          Width = 162.519790000000000000
          Height = 18.897650000000000000
          DataSet = Form1.ReportDS
          DataSetName = 'ReportDS'
          Memo.UTF8W = (
            '[ReportDS.ExamineeID]')
        end
        object ReportDS1: TfrxMemoView
          Left = 204.094620000000000000
          Width = 162.519790000000000000
          Height = 18.897650000000000000
          DataSet = Form1.ReportDS
          DataSetName = 'ReportDS'
          Memo.UTF8W = (
            '[ReportDS.ExamineeName]')
        end
        object ReportDS2: TfrxMemoView
          Left = 393.071120000000000000
          Width = 166.299320000000000000
          Height = 18.897650000000000000
          DataSet = Form1.ReportDS
          DataSetName = 'ReportDS'
          Memo.UTF8W = (
            '[ReportDS.ExamineeStatus]')
        end
      end
      object Footer1: TfrxFooter
        FillType = ftBrush
        Height = 56.692950000000000000
        Top = 249.448980000000000000
        Width = 718.110700000000000000
        object Memo17: TfrxMemoView
          Left = 7.559060000000000000
          Top = 30.236240000000000000
          Width = 98.267316220000000000
          Height = 22.677180000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftBottom]
          Frame.Width = 2.000000000000000000
          Memo.UTF8W = (
            #30417#32771#20154#21592#31614#21517#65306)
          ParentFont = False
          Style = 'Header line'
        end
        object Memo3: TfrxMemoView
          Left = 128.504020000000000000
          Top = 30.236240000000000000
          Width = 94.488250000000000000
          Height = 18.897650000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Memo.UTF8W = (
            'adfas')
          ParentFont = False
        end
      end
    end
  end
end
