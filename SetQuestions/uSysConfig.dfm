inherited frmSysConfig: TfrmSysConfig
  Left = 297
  Top = 204
  Caption = #31995#32479#21450#39064#24211#37197#32622
  ClientHeight = 505
  ClientWidth = 707
  ExplicitWidth = 723
  ExplicitHeight = 544
  PixelsPerInch = 96
  TextHeight = 13
  object cxLabel1: TcxLabel [0]
    Left = 40
    Top = 16
    Caption = #39064#24211#21517#31216#65306
  end
  object edtName: TcxTextEdit [1]
    Left = 110
    Top = 16
    Style.StyleController = styleControllerEdit
    TabOrder = 1
    Width = 355
  end
  object cxLabel2: TcxLabel [2]
    Left = 40
    Top = 56
    Caption = #39064#24211#31867#22411#65306
  end
  object cxLabel3: TcxLabel [3]
    Left = 280
    Top = 57
    Caption = #26377#25928#26085#26399#65306
  end
  object cxLabel4: TcxLabel [4]
    Left = 40
    Top = 96
    Caption = #25104#32489#26174#31034#65306
  end
  object cbType: TcxComboBox [5]
    Left = 110
    Top = 55
    Properties.DropDownListStyle = lsFixedList
    Properties.Items.Strings = (
      #27491#24335#32771#35797
      #27169#25311#32771#35797)
    Style.StyleController = styleControllerEdit
    TabOrder = 5
    Width = 115
  end
  object edtDate: TcxDateEdit [6]
    Left = 344
    Top = 55
    Style.StyleController = styleControllerEdit
    TabOrder = 6
    Width = 121
  end
  object cbDispScore: TcxComboBox [7]
    Left = 110
    Top = 93
    Properties.DropDownListStyle = lsFixedList
    Properties.Items.Strings = (
      #23458#25143#31471
      #26381#21153#22120#31471)
    Style.StyleController = styleControllerEdit
    TabOrder = 7
    Width = 115
  end
  object Panel1: TPanel [8]
    Left = 0
    Top = 464
    Width = 707
    Height = 41
    Align = alBottom
    TabOrder = 8
    DesignSize = (
      707
      41)
    object btnModify: TcxButton
      Left = 64
      Top = 8
      Width = 75
      Height = 25
      Caption = #20462#25913
      TabOrder = 0
      OnClick = btnModifyClick
    end
    object btnSave: TcxButton
      Left = 160
      Top = 8
      Width = 75
      Height = 25
      Caption = #20445#23384
      TabOrder = 1
      OnClick = btnSaveClick
    end
    object btnExit: TcxButton
      Left = 608
      Top = 8
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = #36820#22238
      OptionsImage.Glyph.Data = {
        36060000424D3606000000000000360400002800000020000000100000000100
        08000000000000020000730B0000730B00000001000000000000000000003300
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
        EEE8E8E8E8E8E8E8E8E8E8E8E8E8E8E8EEE8E8E8E8E8E8E8E8E8E8E8E8EEE3AC
        E3EEE8E8E8E8E8E8E8E8E8E8E8EEE8ACE3EEE8E8E8E8E8E8E8E8E8EEE3E28257
        57E2ACE3EEE8E8E8E8E8E8EEE8E2818181E2ACE8EEE8E8E8E8E8E382578282D7
        578181E2E3E8E8E8E8E8E881818181D7818181E2E8E8E8E8E8E857828989ADD7
        57797979EEE8E8E8E8E88181DEDEACD781818181EEE8E8E8E8E857898989ADD7
        57AAAAA2D7ADE8E8E8E881DEDEDEACD781DEDE81D7ACE8E8E8E857898989ADD7
        57AACEA3AD10E8E8E8E881DEDEDEACD781DEAC81AC81E8E8E8E85789825EADD7
        57ABCFE21110E8E8E8E881DE8181ACD781ACACE28181E8E8E8E8578957D7ADD7
        57ABDE101010101010E881DE56D7ACD781ACDE818181818181E857898257ADD7
        57E810101010101010E881DE8156ACD781E381818181818181E857898989ADD7
        57E882101010101010E881DEDEDEACD781E381818181818181E857898989ADD7
        57ACEE821110E8E8E8E881DEDEDEACD781ACEE818181E8E8E8E857898989ADD7
        57ABE8AB8910E8E8E8E881DEDEDEACD781ACE3ACDE81E8E8E8E857828989ADD7
        57ACE8A3E889E8E8E8E88181DEDEACD781ACE381E8DEE8E8E8E8E8DE5E8288D7
        57A2A2A2E8E8E8E8E8E8E8DE8181DED781818181E8E8E8E8E8E8E8E8E8AC8257
        57E8E8E8E8E8E8E8E8E8E8E8E8AC818181E8E8E8E8E8E8E8E8E8}
      OptionsImage.NumGlyphs = 2
      TabOrder = 2
      OnClick = btnExitClick
    end
    object btnCancel: TcxButton
      Left = 264
      Top = 8
      Width = 75
      Height = 25
      Caption = #25764#28040
      TabOrder = 3
      OnClick = btnCancelClick
    end
  end
  object cxLabel7: TcxLabel [9]
    Left = 4
    Top = 133
    Caption = #32771#35797#26102#38388#65288#31186#65289#65306
  end
  object cxLabel8: TcxLabel [10]
    Left = 244
    Top = 133
    Caption = #25171#23383#26102#38388#65288#31186#65289#65306
  end
  object edtExamTime: TcxTextEdit [11]
    Left = 110
    Top = 132
    Style.StyleController = styleControllerEdit
    TabOrder = 11
    Width = 115
  end
  object edtTypeTime: TcxTextEdit [12]
    Left = 344
    Top = 132
    Style.StyleController = styleControllerEdit
    TabOrder = 12
    Width = 121
  end
  object cxgrpbxModules: TcxGroupBox [13]
    Left = 471
    Top = 16
    Caption = #27169#22359#21160#24577#24211#21015#34920#65306
    TabOrder = 13
    Height = 169
    Width = 210
    object cxmModules: TcxMemo
      Left = 2
      Top = 18
      Align = alClient
      Lines.Strings = (
        'cxmModules')
      Style.StyleController = styleControllerEdit
      TabOrder = 0
      Height = 149
      Width = 206
    end
  end
  object cxgrpbxStrategy: TcxGroupBox [14]
    Left = 8
    Top = 232
    Caption = #36873#39064#31574#30053#65306
    TabOrder = 14
    Height = 226
    Width = 691
    object cxmStrategy: TcxMemo
      Left = 2
      Top = 18
      Align = alClient
      Lines.Strings = (
        'cxmStrategy')
      Style.StyleController = styleControllerEdit
      TabOrder = 0
      Height = 206
      Width = 687
    end
  end
  object cxLabel5: TcxLabel [15]
    Left = 220
    Top = 95
    Caption = #29366#24577#26356#26032#38388#38548#65288#31186#65289#65306
  end
  object edtStatusRefeshInterval: TcxTextEdit [16]
    Left = 344
    Top = 94
    Style.StyleController = styleControllerEdit
    TabOrder = 16
    Width = 121
  end
  object cxLabel9: TcxLabel [17]
    Left = 451
    Top = 196
    AutoSize = False
    Caption = #37325#12289#32493#12289#24310#32771#23494#30721#65306
    Height = 17
    Width = 135
  end
  object edtPwd: TcxTextEdit [18]
    Left = 587
    Top = 194
    Style.StyleController = styleControllerEdit
    TabOrder = 18
    Width = 106
  end
  object radiogrpRetryModel: TcxRadioGroup [19]
    Left = 116
    Top = 180
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
    TabOrder = 19
    Height = 42
    Width = 329
  end
  object cxLabel11: TcxLabel [20]
    Left = 21
    Top = 195
    Caption = #30331#24405#35768#21487#27169#24335#65306
  end
  object setSysConfig: TADODataSet [21]
    Connection = dmSetQuestion.stkConn
    CommandText = 'select * from sysconfig'
    Parameters = <>
    Left = 424
    Top = 8
  end
  inherited styleControllerEdit: TcxEditStyleController
    PixelsPerInch = 96
  end
  inherited cxStyleRepository1: TcxStyleRepository
    PixelsPerInch = 96
    inherited GridTableViewStyleSheetDevExpress: TcxGridTableViewStyleSheet
      BuiltIn = True
    end
  end
end
