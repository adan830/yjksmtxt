object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = 'frmMain'
  ClientHeight = 472
  ClientWidth = 1007
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 16
    Width = 132
    Height = 13
    Caption = #32771#29983#25991#20214#20027#25991#20214#22841#65306#12288#12288
  end
  object Label2: TLabel
    Left = 40
    Top = 56
    Width = 48
    Height = 13
    Caption = #36215#22987#21495#65306
  end
  object Label3: TLabel
    Left = 40
    Top = 88
    Width = 48
    Height = 13
    Caption = #32456#27490#21495#65306
  end
  object Label4: TLabel
    Left = 16
    Top = 48
    Width = 108
    Height = 13
    Caption = #31995#32479#39064#24211#36335#24452#65306#12288#12288
    Visible = False
  end
  object lblProgress: TLabel
    Left = 480
    Top = 121
    Width = 353
    Height = 13
    AutoSize = False
  end
  object Label7: TLabel
    Left = 736
    Top = 21
    Width = 36
    Height = 13
    Caption = #22995#21517#65306
  end
  object Label8: TLabel
    Left = 488
    Top = 16
    Width = 36
    Height = 13
    Caption = #20934#32771#21495
  end
  object Label9: TLabel
    Left = 488
    Top = 51
    Width = 36
    Height = 13
    Caption = #36335#24452#65306
  end
  object Label10: TLabel
    Left = 240
    Top = 48
    Width = 48
    Height = 13
    Caption = #24050#35780#20998#65306
  end
  object edtStart: TEdit
    Left = 88
    Top = 48
    Width = 121
    Height = 21
    TabOrder = 0
  end
  object edtEnd: TEdit
    Left = 88
    Top = 88
    Width = 121
    Height = 21
    TabOrder = 1
  end
  object Button1: TButton
    Left = 96
    Top = 160
    Width = 75
    Height = 25
    Caption = #35780#20998
    TabOrder = 2
    OnClick = Button1Click
  end
  object ListBox1: TListBox
    Left = 240
    Top = 75
    Width = 201
    Height = 358
    ItemHeight = 13
    TabOrder = 3
  end
  object cbKspath: TcxShellComboBox
    Left = 144
    Top = 16
    TabOrder = 4
    Width = 321
  end
  object cbSystemDBpath: TcxShellComboBox
    Left = 144
    Top = 48
    TabOrder = 5
    Visible = False
    Width = 321
  end
  object pb: TProgressBar
    Left = 472
    Top = 140
    Width = 513
    Height = 16
    TabOrder = 6
  end
  object edtname: TEdit
    Left = 784
    Top = 16
    Width = 121
    Height = 21
    TabOrder = 7
    Text = 'editName'
  end
  object edtzkh: TEdit
    Left = 544
    Top = 16
    Width = 145
    Height = 21
    TabOrder = 8
    Text = 'edtzkh'
  end
  object edtPath: TEdit
    Left = 544
    Top = 48
    Width = 417
    Height = 21
    TabOrder = 9
    Text = 'edtPath'
  end
  object setExamineeBase: TADODataSet
    Connection = connExamineeBase
    CursorType = ctStatic
    CommandText = 'select  *  from '#32771#29983#20449#24687
    Parameters = <>
    Left = 520
    Top = 296
  end
  object connExamineeBase: TADOConnection
    LoginPrompt = False
    Mode = cmReadWrite
    Provider = 'Microsoft.Jet.OLEDB.4.0'
    BeforeConnect = connExamineeBaseBeforeConnect
    Left = 624
    Top = 296
  end
end
