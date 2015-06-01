object dmServer: TdmServer
  OldCreateOrder = False
  Height = 336
  Width = 504
  object connStk: TADOConnection
    ConnectionString = 
      'Provider=Microsoft.Jet.OLEDB.4.0;User ID=admin;Data Source=D:\yj' +
      'ksmtxt\debug\bin\'#31995#32479#39064#24211'.mdb;Mode=Share Deny None;Persist Security ' +
      'Info=False;Jet OLEDB:Database Password=thepasswordofaccedwm'
    LoginPrompt = False
    Provider = 'Microsoft.Jet.OLEDB.4.0'
    BeforeConnect = connStkBeforeConnect
    Left = 40
    Top = 24
  end
  object qryStk: TADOQuery
    Connection = connStk
    Parameters = <>
    Left = 152
    Top = 24
  end
  object dsStk: TADODataSet
    Connection = connStk
    CursorType = ctStatic
    CommandText = 'select * from '#35797#39064
    Parameters = <>
    Left = 264
    Top = 24
  end
  object prvStk: TDataSetProvider
    DataSet = dsStk
    Options = [poReadOnly, poAllowCommandText, poUseQuoteChar]
    Left = 384
    Top = 24
  end
  object connExamineeBase: TADOConnection
    LoginPrompt = False
    Mode = cmShareDenyNone
    Provider = 'Microsoft.Jet.OLEDB.4.0'
    BeforeConnect = connExamineeBaseBeforeConnect
    Left = 40
    Top = 104
  end
  object setExamineeBase: TADODataSet
    Connection = connExamineeBase
    CursorType = ctStatic
    CommandText = 'select  *  from '#32771#29983#20449#24687
    Parameters = <>
    Left = 264
    Top = 104
  end
  object prvExamineeBase: TDataSetProvider
    DataSet = setExamineeBase
    Options = [poAllowMultiRecordUpdates, poAllowCommandText, poUseQuoteChar]
    UpdateMode = upWhereKeyOnly
    OnGetData = prvExamineeBaseGetData
    OnUpdateData = prvExamineeBaseUpdateData
    Left = 384
    Top = 104
  end
  object dlgOpen1: TOpenDialog
    Left = 384
    Top = 240
  end
end
