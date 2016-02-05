object dm1: Tdm1
  OldCreateOrder = False
  Height = 544
  Width = 509
  object dsKsXxk: TDataSource
    DataSet = TbKsxxk
    Left = 184
    Top = 16
  end
  object dsKsstk: TDataSource
    DataSet = TbKsStk
    Left = 104
    Top = 152
  end
  object dsMainFile: TDataSource
    DataSet = TbMainFile
    Left = 288
    Top = 176
  end
  object sysconn: TADOConnection
    ConnectionString = 
      'Provider=Microsoft.Jet.OLEDB.4.0;User ID=Admin;Data Source=S:\yj' +
      'win\'#31995#32479#39064#24211'.mdb;Mode=Share Deny None;Extended Properties="";Persist' +
      ' Security Info=False;Jet OLEDB:System database="";Jet OLEDB:Regi' +
      'stry Path="";Jet OLEDB:Database Password=thepasswordofaccedwm;Je' +
      't OLEDB:Engine Type=5;Jet OLEDB:Database Locking Mode=0;Jet OLED' +
      'B:Global Partial Bulk Ops=2;Jet OLEDB:Global Bulk Transactions=1' +
      ';Jet OLEDB:New Database Password="";Jet OLEDB:Create System Data' +
      'base=False;Jet OLEDB:Encrypt Database=False;Jet OLEDB:Don'#39't Copy' +
      ' Locale on Compact=False;Jet OLEDB:Compact Without Replica Repai' +
      'r=False;Jet OLEDB:SFP=False'
    LoginPrompt = False
    Provider = 'Microsoft.Jet.OLEDB.4.0'
    Left = 24
    Top = 16
  end
  object TbKsxxk: TADOTable
    CacheSize = 100
    Connection = sysconn
    CursorType = ctStatic
    TableName = #32771#29983#20449#24687
    Left = 104
    Top = 16
  end
  object TbKsStk: TADOTable
    CacheSize = 100
    Connection = ksconn
    CursorType = ctStatic
    TableName = #32771#29983#35797#39064
    Left = 40
    Top = 152
    object TbKsStkst_no: TWideStringField
      FieldName = 'st_no'
      Size = 6
    end
    object TbKsStkst_lr: TMemoField
      FieldName = 'st_lr'
      BlobType = ftMemo
    end
    object TbKsStkst_item1: TWideStringField
      FieldName = 'st_item1'
      Size = 120
    end
    object TbKsStkst_item2: TWideStringField
      FieldName = 'st_item2'
      Size = 120
    end
    object TbKsStkst_item3: TWideStringField
      FieldName = 'st_item3'
      Size = 120
    end
    object TbKsStkst_item4: TWideStringField
      FieldName = 'st_item4'
      Size = 120
    end
    object TbKsStkst_tx: TBlobField
      FieldName = 'st_tx'
    end
    object TbKsStkst_da: TWideStringField
      FieldName = 'st_da'
      Size = 4
    end
    object TbKsStkksda: TWideStringField
      FieldName = 'ksda'
      Size = 4
    end
    object TbKsStkst_hj: TMemoField
      FieldName = 'st_hj'
      BlobType = ftMemo
    end
    object TbKsStkst_da1: TMemoField
      FieldName = 'st_da1'
      BlobType = ftMemo
    end
  end
  object TbMainFile: TADOTable
    CacheSize = 50
    Connection = sysconn
    CursorType = ctStatic
    TableName = #38468#21152#25991#20214
    Left = 208
    Top = 176
    object TbMainFileGuid: TAutoIncField
      FieldName = 'Guid'
      ReadOnly = True
    end
    object TbMainFileFileName: TWideStringField
      FieldName = 'FileName'
      Size = 100
    end
    object TbMainFileFilestream: TBlobField
      FieldName = 'Filestream'
    end
  end
  object Timer1: TTimer
    Enabled = False
    OnTimer = Timer1Timer
    Left = 360
    Top = 16
  end
  object ksconn: TADOConnection
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
    Left = 24
    Top = 472
  end
  object FilterQuery: TADOQuery
    CacheSize = 100
    Connection = ksconn
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
      'select * from '#32771#29983#35797#39064' where st_no like :v_stno'
      '')
    Left = 40
    Top = 216
    object FilterQueryst_no: TWideStringField
      FieldName = 'st_no'
      Size = 6
    end
    object FilterQueryst_lr: TMemoField
      FieldName = 'st_lr'
      BlobType = ftMemo
    end
    object FilterQueryst_item1: TWideStringField
      FieldName = 'st_item1'
      Size = 120
    end
    object FilterQueryst_item2: TWideStringField
      FieldName = 'st_item2'
      Size = 120
    end
    object FilterQueryst_item3: TWideStringField
      FieldName = 'st_item3'
      Size = 120
    end
    object FilterQueryst_item4: TWideStringField
      FieldName = 'st_item4'
      Size = 120
    end
    object FilterQueryst_tx: TBlobField
      FieldName = 'st_tx'
    end
    object FilterQueryst_da: TWideStringField
      FieldName = 'st_da'
      Size = 4
    end
    object FilterQueryksda: TWideStringField
      FieldName = 'ksda'
      Size = 4
    end
    object FilterQueryst_hj: TMemoField
      FieldName = 'st_hj'
      BlobType = ftMemo
    end
    object FilterQueryst_da1: TMemoField
      FieldName = 'st_da1'
      BlobType = ftMemo
    end
  end
  object dsFilterQuery: TDataSource
    DataSet = FilterQuery
    Left = 120
    Top = 216
  end
  object TimeUpdateQuery: TADOQuery
    Connection = sysconn
    Parameters = <
      item
        Name = 'vTime'
        Size = -1
        Value = Null
      end
      item
        Name = 'vZkh'
        Size = -1
        Value = Null
      end>
    SQL.Strings = (
      'update '#32771#29983#20449#24687' set zsj= :vTime where zkh= :vZkh')
    Left = 160
    Top = 328
  end
  object UpdateScoreQuery: TADOQuery
    CacheSize = 100
    Connection = sysconn
    Parameters = <>
    Left = 160
    Top = 272
  end
  object ScoreQuery: TADOQuery
    Connection = sysconn
    Parameters = <
      item
        Name = 'v_zkh'
        Size = -1
        Value = Null
      end>
    SQL.Strings = (
      'select * from '#32771#29983#20449#24687' where zkh=:v_zkh')
    Left = 288
    Top = 272
  end
  object dsScoreQuery: TDataSource
    DataSet = ScoreQuery
    Left = 288
    Top = 328
  end
  object tkscQuery: TADOQuery
    CacheSize = 100
    Connection = sysconn
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
      'select * from '#35797#39064' where st_no like :v_stno')
    Left = 32
    Top = 360
    object tkscQueryst_no: TWideStringField
      FieldName = 'st_no'
      Size = 6
    end
    object tkscQueryst_lr: TMemoField
      FieldName = 'st_lr'
      BlobType = ftMemo
    end
    object tkscQueryst_item1: TWideStringField
      FieldName = 'st_item1'
      Size = 120
    end
    object tkscQueryst_item2: TWideStringField
      FieldName = 'st_item2'
      Size = 120
    end
    object tkscQueryst_item3: TWideStringField
      FieldName = 'st_item3'
      Size = 120
    end
    object tkscQueryst_item4: TWideStringField
      FieldName = 'st_item4'
      Size = 120
    end
    object tkscQueryst_da: TWideStringField
      FieldName = 'st_da'
      Size = 4
    end
    object tkscQueryksda: TWideStringField
      FieldName = 'ksda'
      Size = 4
    end
    object tkscQueryst_hj: TMemoField
      FieldName = 'st_hj'
      BlobType = ftMemo
    end
    object tkscQueryst_da1: TMemoField
      FieldName = 'st_da1'
      BlobType = ftMemo
    end
    object tkscQueryst_comment: TMemoField
      FieldName = 'st_comment'
      BlobType = ftMemo
    end
  end
  object DataSource1: TDataSource
    DataSet = tkscQuery
    Left = 32
    Top = 416
  end
end
