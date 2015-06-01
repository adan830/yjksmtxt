object dmClient: TdmClient
  OldCreateOrder = False
  Height = 373
  Width = 439
  object connClientDB: TADOConnection
    ConnectionString = 
      'Provider=Microsoft.Jet.OLEDB.4.0;User ID=Admin;Data Source=;Mode' +
      '=Share Deny None;Extended Properties="";Jet OLEDB:System databas' +
      'e="";Jet OLEDB:Registry Path="";Jet OLEDB:Database Password=jiap' +
      'ing;Jet OLEDB:Engine Type=5;Jet OLEDB:Database Locking Mode=1;Je' +
      't OLEDB:Global Partial Bulk Ops=2;Jet OLEDB:Global Bulk Transact' +
      'ions=1;Jet OLEDB:New Database Password="";Jet OLEDB:Create Syste' +
      'm Database=False;Jet OLEDB:Encrypt Database=False;Jet OLEDB:Don'#39 +
      't Copy Locale on Compact=False;Jet OLEDB:Compact Without Replica' +
      ' Repair=False;Jet OLEDB:SFP=False'
    LoginPrompt = False
    Provider = 'Microsoft.Jet.OLEDB.4.0'
    Left = 48
    Top = 48
  end
  object dsKsstk: TDataSource
    DataSet = TbKsStk
    Left = 136
    Top = 48
  end
  object TbKsStk: TADOTable
    CacheSize = 100
    Connection = connClientDB
    CursorType = ctStatic
    TableName = #35797#39064
    Left = 136
    Top = 120
  end
  object qryKsstk: TADOQuery
    CacheSize = 100
    Connection = connClientDB
    CursorType = ctStatic
    Filtered = True
    Parameters = <
      item
        Name = 'v_stno'
        Attributes = [paNullable]
        DataType = ftWideString
        NumericScale = 255
        Precision = 255
        Size = 510
        Value = Null
      end>
    SQL.Strings = (
      '')
    Left = 200
    Top = 48
  end
  object TbKsxxk: TADOTable
    CacheSize = 100
    CursorType = ctStatic
    TableName = #32771#29983#20449#24687
    Left = 136
    Top = 200
  end
  object MainTimer: TTimer
    Enabled = False
    OnTimer = MainTimerTimer
    Left = 320
    Top = 40
  end
  object FilterQuery: TADOQuery
    CacheSize = 100
    Connection = connClientDB
    CursorType = ctStatic
    Parameters = <
      item
        Name = 'v_stno'
        Attributes = [paNullable]
        DataType = ftWideString
        NumericScale = 255
        Precision = 255
        Size = 510
        Value = Null
      end>
    SQL.Strings = (
      'select * from '#32771#29983#35797#39064' where st_no like :v_stno')
    Left = 56
    Top = 200
  end
  object dsFilterQury: TDataSource
    DataSet = FilterQuery
    Left = 56
    Top = 264
  end
  object ScoreQuery: TADOQuery
    Connection = connClientDB
    Parameters = <
      item
        Name = 'v_ExamineeID'
        Size = -1
        Value = Null
      end>
    SQL.Strings = (
      'select * from '#32771#29983#20449#24687' where ExamineeID=:v_ExamineeID')
    Left = 208
    Top = 200
  end
  object dsScoreQuery: TDataSource
    DataSet = ScoreQuery
    Left = 320
    Top = 280
  end
  object UpdateScoreQuery: TADOQuery
    CacheSize = 100
    Connection = connClientDB
    Parameters = <
      item
        Name = 'v_df'
        DataType = ftString
        Size = -1
        Value = Null
      end
      item
        Name = 'v_zkh'
        DataType = ftString
        Size = -1
        Value = Null
      end>
    Left = 320
    Top = 200
  end
end
