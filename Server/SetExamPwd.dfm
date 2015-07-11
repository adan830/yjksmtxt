object ResetExamPwdForm: TResetExamPwdForm
  Left = 0
  Top = 0
  BorderIcons = []
  Caption = 'ResetExamPwdForm'
  ClientHeight = 242
  ClientWidth = 527
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  PixelsPerInch = 96
  TextHeight = 13
  object edtAddTimePwd1: TcxTextEdit
    Left = 293
    Top = 114
    Properties.ReadOnly = False
    TabOrder = 0
    Width = 121
  end
  object edtAddTimePwd: TcxTextEdit
    Left = 142
    Top = 114
    Properties.ReadOnly = False
    TabOrder = 1
    Width = 121
  end
  object cxLabel13: TcxLabel
    Left = 72
    Top = 114
    Caption = #24310#32771#23494#30721#65306
  end
  object cxLabel5: TcxLabel
    Left = 72
    Top = 83
    Caption = #37325#32771#23494#30721#65306
  end
  object edtContPwd: TcxTextEdit
    Left = 142
    Top = 52
    Properties.ReadOnly = False
    TabOrder = 4
    Width = 121
  end
  object edtContPwd1: TcxTextEdit
    Left = 293
    Top = 52
    Properties.ReadOnly = False
    TabOrder = 5
    Width = 121
  end
  object edtRetryPwd: TcxTextEdit
    Left = 142
    Top = 81
    Properties.ReadOnly = False
    TabOrder = 6
    Width = 121
  end
  object edtRetryPwd1: TcxTextEdit
    Left = 293
    Top = 81
    Properties.ReadOnly = False
    TabOrder = 7
    Width = 121
  end
  object cxLabel6: TcxLabel
    Left = 72
    Top = 53
    Caption = #32493#32771#23494#30721#65306
  end
  object btnYes: TButton
    Left = 126
    Top = 170
    Width = 97
    Height = 25
    Caption = #30830#23450
    TabOrder = 9
    OnClick = btnYesClick
  end
  object btnCancel: TButton
    Left = 302
    Top = 170
    Width = 97
    Height = 25
    Caption = #21462#28040
    ModalResult = 7
    TabOrder = 10
  end
end
