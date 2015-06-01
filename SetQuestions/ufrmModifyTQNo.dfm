object frmModifyTQNo: TfrmModifyTQNo
  Left = 0
  Top = 0
  Caption = #20462#25913#35797#39064#32534#21495' '
  ClientHeight = 206
  ClientWidth = 308
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object lblcxlbl1: TcxLabel
    Left = 44
    Top = 32
    Caption = #21407#35797#39064#32534#21495#65306
  end
  object edtOldStNo: TcxTextEdit
    Left = 126
    Top = 31
    Properties.ReadOnly = True
    TabOrder = 1
    Width = 129
  end
  object lblcxlbl11: TcxLabel
    Left = 44
    Top = 72
    Caption = #26032#35797#39064#32534#21495#65306
  end
  object edtNewStNo: TcxTextEdit
    Left = 126
    Top = 71
    Properties.MaxLength = 6
    Properties.ReadOnly = False
    TabOrder = 3
    Width = 129
  end
  object btnSave: TcxButton
    Left = 56
    Top = 136
    Width = 75
    Height = 25
    Caption = #20445#23384
    TabOrder = 4
    OnClick = btnSaveClick
  end
  object btnCancel: TcxButton
    Left = 160
    Top = 136
    Width = 75
    Height = 25
    Caption = #21462#28040
    ModalResult = 2
    TabOrder = 5
  end
end
