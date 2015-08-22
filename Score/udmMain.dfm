object dmMain: TdmMain
  OldCreateOrder = False
  Height = 353
  Width = 508
  object connSource: TADOConnection
    ConnectionString = 
      'Provider=Microsoft.Jet.OLEDB.4.0;User ID=admin;Data Source=E:\yj' +
      'ksmtxt\debug\bin\'#25104#32489#24211'.mdb;Mode=Share Deny None;Persist Security I' +
      'nfo=False;Jet OLEDB:System database="";Jet OLEDB:Registry Path="' +
      '";Jet OLEDB:Database Password=thepasswordofaccedwm;Jet OLEDB:Eng' +
      'ine Type=5;Jet OLEDB:Database Locking Mode=1;Jet OLEDB:Global Pa' +
      'rtial Bulk Ops=2;Jet OLEDB:Global Bulk Transactions=1;Jet OLEDB:' +
      'New Database Password="";Jet OLEDB:Create System Database=False;' +
      'Jet OLEDB:Encrypt Database=False;Jet OLEDB:Don'#39't Copy Locale on ' +
      'Compact=False;Jet OLEDB:Compact Without Replica Repair=False;Jet' +
      ' OLEDB:SFP=False;'
    LoginPrompt = False
    Provider = 'Microsoft.Jet.OLEDB.4.0'
    Left = 48
    Top = 24
  end
  object connScore: TADOConnection
    ConnectionString = 
      'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=E:\yjksmtxt\debug\b' +
      'in\'#27719#24635#25104#32489'.mdb;Persist Security Info=False'
    LoginPrompt = False
    Mode = cmShareDenyNone
    Provider = 'Microsoft.Jet.OLEDB.4.0'
    OnWillConnect = connScoreWillConnect
    Left = 48
    Top = 184
  end
  object qrySource: TADOQuery
    Connection = connSource
    CursorType = ctStatic
    Parameters = <>
    Left = 120
    Top = 24
  end
  object cdsSource: TClientDataSet
    Aggregates = <>
    CommandText = 'select * from '#32771#29983#20449#24687
    Params = <>
    ProviderName = 'dspSource'
    OnCalcFields = cdsSourceCalcFields
    Left = 312
    Top = 24
    object wdstrngfldSourceExamineeID: TWideStringField
      FieldName = 'ExamineeID'
      Size = 24
    end
    object wdstrngfldSourceExamineeName: TWideStringField
      FieldName = 'ExamineeName'
    end
    object wdstrngfldSourceIP: TWideStringField
      FieldName = 'IP'
      Size = 32
    end
    object wdstrngfldSourcePort: TWideStringField
      FieldName = 'Port'
      Size = 30
    end
    object wdstrngfldSourceStatus: TWideStringField
      FieldName = 'Status'
    end
    object wdstrngfldSourceRemainTime: TWideStringField
      FieldName = 'RemainTime'
      Size = 24
    end
    object wdstrngfldSourceTimeStamp: TWideStringField
      FieldName = 'Stamp'
    end
    object blbfldSourceScoreInfo: TBlobField
      FieldName = 'ScoreInfo'
    end
  end
  object dspSource: TDataSetProvider
    DataSet = qrySource
    Options = [poAllowCommandText, poUseQuoteChar]
    UpdateMode = upWhereKeyOnly
    Left = 192
    Top = 24
  end
  object dsSource: TDataSource
    DataSet = cdsSourceFromFile
    Left = 408
    Top = 24
  end
  object dspSourceOriginal: TDataSetProvider
    DataSet = qrySource
    Options = [poAllowCommandText, poUseQuoteChar]
    Left = 192
    Top = 80
  end
  object cdsSourceoriginal: TClientDataSet
    Aggregates = <>
    CommandText = 'select * from '#32771#29983#20449#24687
    Params = <>
    ProviderName = 'dspSourceOriginal'
    ReadOnly = True
    Left = 312
    Top = 80
  end
  object connStatistics: TADOConnection
    ConnectionString = 
      'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=E:\yjksmtxt\debug\b' +
      'in\'#31995#32479#39064#24211'.mdb;Persist Security Info=False;Jet OLEDB:Database Passw' +
      'ord=thepasswordofaccedwm'
    LoginPrompt = False
    Mode = cmShareDenyNone
    Provider = 'Microsoft.Jet.OLEDB.4.0'
    Left = 48
    Top = 256
  end
  object qryStatistics: TADOQuery
    Connection = connStatistics
    CursorType = ctStatic
    Parameters = <>
    Left = 120
    Top = 256
  end
  object dspScore: TDataSetProvider
    DataSet = qryScore
    Options = [poAllowCommandText, poUseQuoteChar]
    UpdateMode = upWhereKeyOnly
    OnUpdateData = dspScoreUpdateData
    Left = 208
    Top = 184
  end
  object dspStatistics: TDataSetProvider
    DataSet = qryStatistics
    Options = [poAllowCommandText, poUseQuoteChar]
    Left = 208
    Top = 256
  end
  object cdsScore: TClientDataSet
    Aggregates = <>
    Params = <>
    ProviderName = 'dspScore'
    Left = 320
    Top = 184
  end
  object cdsStatistics: TClientDataSet
    Aggregates = <>
    CommandText = 'select st_no,nd,syn from '#35797#39064
    Params = <>
    ProviderName = 'dspStatistics'
    Left = 320
    Top = 256
  end
  object qryScore: TADOQuery
    Connection = connScore
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'select * from '#27719#24635#25104#32489' ')
    Left = 120
    Top = 184
  end
  object dsScore: TDataSource
    Left = 400
    Top = 184
  end
  object cdsSourceFromFile: TClientDataSet
    Aggregates = <>
    FileName = 'E:\yjksmtxt\debug\bin\111200805071031.dat'
    Params = <>
    Left = 312
    Top = 128
    object wdstrngfldSourceFromFileExamineeID: TWideStringField
      FieldName = 'ExamineeID'
      Size = 24
    end
    object wdstrngfldSourceFromFileExamineeName: TWideStringField
      FieldName = 'ExamineeName'
    end
    object wdstrngfldSourceFromFileIP: TWideStringField
      FieldName = 'IP'
      Size = 32
    end
    object wdstrngfldSourceFromFilePort: TWideStringField
      FieldName = 'Port'
      Size = 30
    end
    object wdstrngfldSourceFromFileStatus: TWideStringField
      FieldName = 'Status'
    end
    object wdstrngfldSourceFromFileRemainTime: TWideStringField
      FieldName = 'RemainTime'
      Size = 24
    end
    object wdstrngfldSourceFromFileTimeStamp: TWideStringField
      FieldName = 'Stamp'
    end
    object blbfldSourceFromFileScoreInfo: TBlobField
      FieldName = 'ScoreInfo'
    end
  end
end
