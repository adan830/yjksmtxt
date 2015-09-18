object FrameMultiSelect: TFrameMultiSelect
  Left = 0
  Top = 0
  Width = 778
  Height = 498
  TabOrder = 0
  object pnl1: TPanel
    Left = 0
    Top = 38
    Width = 778
    Height = 460
    Align = alClient
    BevelOuter = bvNone
    Caption = 'pnl1'
    TabOrder = 0
    object pnl2: TPanel
      Left = 0
      Top = 0
      Width = 778
      Height = 460
      Align = alClient
      BevelOuter = bvNone
      Caption = 'pnl2'
      TabOrder = 0
      object pnl3: TPanel
        Left = 0
        Top = 0
        Width = 778
        Height = 62
        Align = alTop
        BevelOuter = bvNone
        Caption = 'pnl3'
        Color = clWhite
        ParentBackground = False
        ShowCaption = False
        TabOrder = 0
        object mmo1: TMemo
          Left = 0
          Top = 0
          Width = 778
          Height = 62
          Align = alClient
          BorderStyle = bsNone
          Font.Charset = DEFAULT_CHARSET
          Font.Color = 5592405
          Font.Height = 14
          Font.Name = #23435#20307
          Font.Style = []
          Lines.Strings = (
            ''
            #27880#24847#20107#39033#65306
            '    '#22810#39033#36873#25321#39064#65288#26412#39064#20849'5'#23567#39064#65292#27599#23567#39064'2'#20998#65292#20849'10'#20998#65289#33267#23569#26377#19968#20010#36873#39033#26159#27491#30830#30340#12290)
          ParentFont = False
          TabOrder = 0
          ExplicitHeight = 82
        end
      end
      object pnl4: TPanel
        Left = 0
        Top = 380
        Width = 778
        Height = 80
        Align = alBottom
        BevelOuter = bvNone
        Caption = 'pnl4'
        ShowCaption = False
        TabOrder = 1
        object grdpnl1: TGridPanel
          Left = 0
          Top = 0
          Width = 778
          Height = 80
          Align = alClient
          BevelOuter = bvNone
          Color = 15921906
          ColumnCollection = <
            item
              Value = 25.001660114886350000
            end
            item
              Value = 49.994766519750640000
            end
            item
              Value = 25.003573365363010000
            end
            item
              SizeStyle = ssAbsolute
            end>
          ControlCollection = <
            item
              Column = 0
              Control = btnPrevious
              Row = 0
            end
            item
              Column = 2
              Control = btnNext
              Row = 0
            end
            item
              Column = 1
              Control = grdpnlAnswer
              Row = 0
            end
            item
              Column = 3
              Control = btnAnswer
              Row = 0
            end>
          ParentBackground = False
          RowCollection = <
            item
              Value = 100.000000000000000000
            end
            item
              SizeStyle = ssAuto
            end>
          ShowCaption = False
          TabOrder = 0
          DesignSize = (
            778
            80)
          object btnPrevious: TCnSpeedButton
            Left = 56
            Top = 25
            Width = 82
            Height = 30
            Anchors = []
            Color = 15966293
            DownBold = False
            FlatBorder = True
            HotTrackBold = False
            HotTrackColor = 16551233
            ModernBtnStyle = bsFlat
            Caption = #19978#19968#39064
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWhite
            Font.Height = 14
            Font.Name = #23435#20307
            Font.Style = [fsBold]
            Margin = 4
            ParentFont = False
            OnClick = btnPreviousClick
            ExplicitLeft = 45
            ExplicitTop = 28
          end
          object btnNext: TCnSpeedButton
            Left = 638
            Top = 25
            Width = 82
            Height = 30
            Anchors = []
            Color = 15966293
            DownBold = False
            FlatBorder = False
            HotTrackBold = False
            HotTrackColor = 16551233
            ModernBtnStyle = bsFlat
            Caption = #19979#19968#39064
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWhite
            Font.Height = 14
            Font.Name = #23435#20307
            Font.Style = [fsBold]
            Margin = 4
            ParentFont = False
            OnClick = btnNextClick
            ExplicitLeft = 559
            ExplicitTop = 28
          end
          object grdpnlAnswer: TGridPanel
            Left = 194
            Top = 0
            Width = 388
            Height = 80
            Align = alClient
            BevelOuter = bvNone
            Color = clWhite
            ColumnCollection = <
              item
                Value = 25.000327054435120000
              end
              item
                Value = 24.998325752826680000
              end
              item
                Value = 25.000449672482660000
              end
              item
                Value = 25.000897520255530000
              end>
            ControlCollection = <
              item
                Column = 0
                Control = chkAnswer1
                Row = 0
              end
              item
                Column = 1
                Control = chkAnswer2
                Row = 0
              end
              item
                Column = 2
                Control = chkAnswer3
                Row = 0
              end
              item
                Column = 3
                Control = chkAnswer4
                Row = 0
              end>
            ParentBackground = False
            RowCollection = <
              item
                Value = 100.000000000000000000
              end>
            ShowCaption = False
            TabOrder = 0
            object chkAnswer1: TCheckBox
              AlignWithMargins = True
              Left = 15
              Top = 3
              Width = 79
              Height = 74
              Margins.Left = 15
              Align = alClient
              Caption = 'A'
              Color = clWhite
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = 28
              Font.Name = 'Arial'
              Font.Style = []
              ParentColor = False
              ParentFont = False
              TabOrder = 0
            end
            object chkAnswer2: TCheckBox
              AlignWithMargins = True
              Left = 112
              Top = 3
              Width = 78
              Height = 74
              Margins.Left = 15
              Align = alClient
              Caption = 'B'
              Color = clWhite
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = 28
              Font.Name = 'Arial'
              Font.Style = []
              ParentColor = False
              ParentFont = False
              TabOrder = 1
            end
            object chkAnswer3: TCheckBox
              AlignWithMargins = True
              Left = 208
              Top = 3
              Width = 79
              Height = 74
              Margins.Left = 15
              Align = alClient
              Caption = 'C'
              Color = clWhite
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = 28
              Font.Name = 'Arial'
              Font.Style = []
              ParentColor = False
              ParentFont = False
              TabOrder = 2
            end
            object chkAnswer4: TCheckBox
              AlignWithMargins = True
              Left = 305
              Top = 3
              Width = 80
              Height = 74
              Margins.Left = 15
              Align = alClient
              Caption = 'D'
              Color = clWhite
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = 28
              Font.Name = 'Arial'
              Font.Style = []
              ParentColor = False
              ParentFont = False
              TabOrder = 3
            end
          end
          object btnAnswer: TCnSpeedButton
            Left = 776
            Top = 25
            Width = 0
            Height = 30
            Anchors = []
            Color = 15966293
            DownBold = False
            FlatBorder = False
            HotTrackBold = False
            HotTrackColor = 16551233
            ModernBtnStyle = bsFlat
            Caption = #31572#26696
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWhite
            Font.Height = 14
            Font.Name = #23435#20307
            Font.Style = [fsBold]
            Glyph.Data = {
              36060000424D3606000000000000360400002800000020000000100000000100
              08000000000000020000420B0000420B00000001000000000000000000003300
              00006600000099000000CC000000FF0000000033000033330000663300009933
              0000CC330000FF33000000660000336600006666000099660000CC660000FF66
              000000990000339900006699000099990000CC990000FF99000000CC000033CC
              000066CC000099CC0000CCCC0000FFCC000000FF000033FF000066FF000099FF
              0000CCFF0000FFFF000000003300330033006600330099003300CC003300FF00
              330000333300333333006633330099333300CC333300FF333300006633003366
              33006666330099663300CC663300FF6633000099330033993300669933009999
              3300CC993300FF99330000CC330033CC330066CC330099CC3300CCCC3300FFCC
              330000FF330033FF330066FF330099FF3300CCFF3300FFFF3300000066003300
              66006600660099006600CC006600FF0066000033660033336600663366009933
              6600CC336600FF33660000666600336666006666660099666600CC666600FF66
              660000996600339966006699660099996600CC996600FF99660000CC660033CC
              660066CC660099CC6600CCCC6600FFCC660000FF660033FF660066FF660099FF
              6600CCFF6600FFFF660000009900330099006600990099009900CC009900FF00
              990000339900333399006633990099339900CC339900FF339900006699003366
              99006666990099669900CC669900FF6699000099990033999900669999009999
              9900CC999900FF99990000CC990033CC990066CC990099CC9900CCCC9900FFCC
              990000FF990033FF990066FF990099FF9900CCFF9900FFFF99000000CC003300
              CC006600CC009900CC00CC00CC00FF00CC000033CC003333CC006633CC009933
              CC00CC33CC00FF33CC000066CC003366CC006666CC009966CC00CC66CC00FF66
              CC000099CC003399CC006699CC009999CC00CC99CC00FF99CC0000CCCC0033CC
              CC0066CCCC0099CCCC00CCCCCC00FFCCCC0000FFCC0033FFCC0066FFCC0099FF
              CC00CCFFCC00FFFFCC000000FF003300FF006600FF009900FF00CC00FF00FF00
              FF000033FF003333FF006633FF009933FF00CC33FF00FF33FF000066FF003366
              FF006666FF009966FF00CC66FF00FF66FF000099FF003399FF006699FF009999
              FF00CC99FF00FF99FF0000CCFF0033CCFF0066CCFF0099CCFF00CCCCFF00FFCC
              FF0000FFFF0033FFFF0066FFFF0099FFFF00CCFFFF00FFFFFF00000080000080
              000000808000800000008000800080800000C0C0C00080808000191919004C4C
              4C00B2B2B200E5E5E500C8AC2800E0CC6600F2EABF00B59B2400D8E9EC009933
              6600D075A300ECC6D900646F710099A8AC00E2EFF10000000000000000000000
              0000000000000000000000000000000000000000000000000000000000000000
              0000000000000000000000000000000000000000000000000000E8E8E8E8E8E8
              E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8
              E8E8E8E8E8787878E8E8E8E8E8E8E8E8E8E8E8E8E8818181E8E8E8E8E8E8E8E8
              E8E8E8E878A3A3CE78E8E8E8E8E8E8E8E8E8E8E881ACACE881E8E8E8E8E8E8E8
              E8E8E878A378CCCE78E8E8E8E8E8E8E8E8E8E881AC81E8E881E8E8E8E8E8E8E8
              E8E878A378CCA3CE78E8E8E8E8E8E8E8E8E881AC81E8ACE881E8E8E8E8E8E8E8
              7878A378CCA3CE78E8E8E8E8E8E8E8E88181AC81E8ACE881E8E8E8E878787878
              A3A378CCA3CE78E8E8E8E8E881818181ACAC81E8ACE881E8E8E8E878CCCCCCCC
              7878CCA3CE78E8E8E8E8E881E8E8E8E88181E8ACE881E8E8E8E878CCCCA3CCCC
              CCCCA3CE78E8E8E8E8E881E8E8ACE8E8E8E8ACE881E8E8E8E8E878CCA3CCA3CC
              CCCCCE78E8E8E8E8E8E881E8ACE8ACE8E8E8E881E8E8E8E8E8E878CCCCA3CCA3
              CCCCCE78E8E8E8E8E8E881E8E8ACE8ACE8E8E881E8E8E8E8E8E878CCCCCCA3CC
              A3CCCE78E8E8E8E8E8E881E8E8E8ACE8ACE8E881E8E8E8E8E8E878CC7878CCA3
              CCA3CE78E8E8E8E8E8E881E88181E8ACE8ACE881E8E8E8E8E8E878D5A378CCCC
              A3CCD578E8E8E8E8E8E881E8AC81E8E8ACE8E881E8E8E8E8E8E8E878D5CECECE
              CED578E8E8E8E8E8E8E8E881E8E8E8E8E8E881E8E8E8E8E8E8E8E8E878787878
              7878E8E8E8E8E8E8E8E8E8E8818181818181E8E8E8E8E8E8E8E8}
            Margin = 4
            NumGlyphs = 2
            ParentFont = False
            OnClick = btnAnswerClick
            ExplicitLeft = 685
            ExplicitTop = 24
          end
        end
      end
      object pnl6: TPanel
        Left = 0
        Top = 62
        Width = 778
        Height = 318
        Align = alClient
        BevelOuter = bvNone
        Caption = 'pnl6'
        TabOrder = 2
        ExplicitTop = 82
        ExplicitHeight = 298
        object edtTQContent: TJvRichEdit
          Left = 0
          Top = 0
          Width = 778
          Height = 318
          Align = alClient
          BevelInner = bvNone
          BevelOuter = bvNone
          BorderStyle = bsNone
          Flat = True
          Font.Charset = GB2312_CHARSET
          Font.Color = 3355443
          Font.Height = 14
          Font.Name = #23435#20307
          Font.Style = []
          ParentFlat = False
          ParentFont = False
          ReadOnly = True
          SelText = ''
          TabOrder = 0
          ExplicitHeight = 298
        end
      end
    end
  end
  inline frmTqButtonList: TFrameTQButtons
    Left = 0
    Top = 0
    Width = 778
    Height = 38
    Align = alTop
    AutoScroll = True
    AutoSize = True
    TabOrder = 1
    ExplicitWidth = 778
    inherited grdpnlTQButtons: TGridPanel
      Width = 778
      Align = alTop
      ExplicitWidth = 778
    end
  end
end
