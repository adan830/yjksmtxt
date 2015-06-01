object frmDispAnswer: TfrmDispAnswer
  Left = 137
  Top = 100
  Caption = #35797#39064#31572#26696#65306
  ClientHeight = 348
  ClientWidth = 482
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesigned
  PixelsPerInch = 96
  TextHeight = 13
  object memoComment: TMemo
    Left = 0
    Top = 57
    Width = 482
    Height = 250
    Align = alClient
    BevelKind = bkTile
    BevelOuter = bvNone
    Color = clBtnFace
    Ctl3D = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = #23435#20307
    Font.Style = []
    ParentCtl3D = False
    ParentFont = False
    ReadOnly = True
    TabOrder = 0
    ExplicitTop = 51
  end
  object grdAnswer: TStringGrid
    Left = 0
    Top = 57
    Width = 482
    Height = 250
    Align = alClient
    Color = clBtnFace
    ColCount = 4
    Ctl3D = False
    FixedCols = 0
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = #23435#20307
    Font.Style = []
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goRowSizing, goColSizing]
    ParentCtl3D = False
    ParentFont = False
    TabOrder = 3
    OnDrawCell = grdAnswerDrawCell
    ColWidths = (
      35
      264
      84
      54)
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 482
    Height = 57
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    object lblCaption: TLabel
      Left = 16
      Top = 16
      Width = 121
      Height = 20
      AutoSize = False
      Caption = #26631#20934#31572#26696#65306
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object lblAnswer: TLabel
      Left = 128
      Top = 16
      Width = 201
      Height = 20
      AutoSize = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object imgOk: TImage
      Left = 400
      Top = 8
      Width = 16
      Height = 16
      Picture.Data = {
        07544269746D6170F6000000424DF60000000000000076000000280000001000
        0000100000000100040000000000800000000000000000000000100000000000
        0000000000000000800000800000008080008000000080008000808000008080
        8000C0C0C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFF
        FF00FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFA2FFFFFFFFFFFFFA222FFFFF
        FFFFFFA22222FFFFFFFFFA2222222FFFFFFFFA222A2222FFFFFFFA22FFA2222F
        FFFFFA2FFFFA2222FFFFFFFFFFFFA2222FFFFFFFFFFFFA2222FFFFFFFFFFFFA2
        22FFFFFFFFFFFFFA22FFFFFFFFFFFFFFA2FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFF}
      Transparent = True
      Visible = False
    end
    object imgError: TImage
      Left = 432
      Top = 8
      Width = 16
      Height = 16
      Picture.Data = {
        07544269746D6170F6000000424DF60000000000000076000000280000001000
        0000100000000100040000000000800000000000000000000000100000000000
        0000000000000000800000800000008080008000000080008000808000008080
        8000C0C0C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFF
        FF00FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF9111FFFFF91
        11FFF99991FFF99991FFFF99991F99991FFFFFF999919991FFFFFFFF9999991F
        FFFFFFFFF99991FFFFFFFFFF9999991FFFFFFFF999919991FFFFFF99991F9999
        1FFFF99991FFF99991FFF9999FFFFF9999FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFF}
      Transparent = True
      Visible = False
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 307
    Width = 482
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 2
    object btnClose: TButton
      Left = 376
      Top = 8
      Width = 75
      Height = 25
      Caption = #20851#38381
      TabOrder = 0
      OnClick = btnExitClick
    end
  end
end
