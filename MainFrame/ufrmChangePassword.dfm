inherited frmChangePassword: TfrmChangePassword
  Left = 332
  Top = 202
  Caption = #26356#25913#23494#30721
  ClientHeight = 220
  ClientWidth = 346
  ExplicitWidth = 354
  ExplicitHeight = 254
  PixelsPerInch = 96
  TextHeight = 12
  inherited Bevel1: TBevel
    Top = 182
    Width = 346
    ExplicitTop = 189
    ExplicitWidth = 346
  end
  inherited Bevel2: TBevel
    Width = 346
    ExplicitWidth = 346
  end
  object Label2: TLabel [2]
    Left = 92
    Top = 80
    Width = 48
    Height = 12
    Caption = #26087#23494#30721#65306
  end
  object Label3: TLabel [3]
    Left = 92
    Top = 108
    Width = 48
    Height = 12
    Caption = #26032#23494#30721#65306
  end
  object Label4: TLabel [4]
    Left = 44
    Top = 136
    Width = 96
    Height = 12
    Caption = #37325#22797#36755#20837#26032#23494#30721#65306
  end
  inherited pnlTop: TPanel
    Width = 346
    ExplicitWidth = 346
    inherited Label1: TLabel
      Width = 262
      ExplicitWidth = 262
    end
    inherited Image1: TImage
      Left = 285
      ExplicitLeft = 285
    end
  end
  inherited pnlBottom: TPanel
    Top = 186
    Width = 346
    ExplicitTop = 193
    ExplicitWidth = 346
    inherited btnOk: TcxButton
      Left = 189
      OnClick = btnOKClick
      ExplicitLeft = 189
    end
    inherited btnCancel: TcxButton
      Left = 265
      ExplicitLeft = 265
    end
  end
  object edtOldPassword: TEdit
    Left = 140
    Top = 76
    Width = 121
    Height = 20
    ImeName = #20013#25991' ('#31616#20307') - '#24494#36719#25340#38899
    PasswordChar = '*'
    TabOrder = 2
  end
  object edtNewPassword: TEdit
    Left = 140
    Top = 104
    Width = 121
    Height = 20
    ImeName = #20013#25991' ('#31616#20307') - '#24494#36719#25340#38899
    PasswordChar = '*'
    TabOrder = 3
  end
  object edtNewPasswordRep: TEdit
    Left = 140
    Top = 132
    Width = 121
    Height = 20
    ImeName = #20013#25991' ('#31616#20307') - '#24494#36719#25340#38899
    PasswordChar = '*'
    TabOrder = 4
  end
end
