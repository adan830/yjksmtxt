object dmSetQuestion: TdmSetQuestion
  OldCreateOrder = False
  Height = 297
  Width = 333
  object stkConn: TADOConnection
    LoginPrompt = False
    Mode = cmShareDenyNone
    Provider = 'Microsoft.Jet.OLEDB.4.0'
    BeforeConnect = stkConnBeforeConnect
    OnConnectComplete = stkConnConnectComplete
    Left = 32
    Top = 24
  end
  object stTable: TADOTable
    Connection = stkConn
    CursorType = ctStatic
    Filtered = True
    TableName = #35797#39064
    Left = 96
    Top = 24
  end
  object infoConn: TADOConnection
    LoginPrompt = False
    Mode = cmShareDenyNone
    Provider = 'Microsoft.Jet.OLEDB.4.0'
    BeforeConnect = infoConnBeforeConnect
    OnConnectComplete = infoConnConnectComplete
    Left = 32
    Top = 152
  end
  object PointTable: TADOTable
    Connection = infoConn
    CursorType = ctStatic
    TableName = 'word'#30693#35782#28857#23376#31867
    Left = 104
    Top = 152
  end
  object stDS: TDataSource
    DataSet = stSt
    Left = 160
    Top = 24
  end
  object TypeTable: TADOTable
    Connection = infoConn
    CursorType = ctStatic
    TableName = 'word'#30693#35782#28857#20027#31867
    Left = 104
    Top = 208
  end
  object TypeDs: TDataSource
    DataSet = TypeTable
    Left = 176
    Top = 208
  end
  object stSt: TADODataSet
    Connection = stkConn
    CursorType = ctStatic
    CommandText = 'select * from '#35797#39064' where st_no like :StNo order by st_no'
    Parameters = <
      item
        Name = 'StNo'
        Attributes = [paNullable]
        DataType = ftWideString
        NumericScale = 255
        Precision = 255
        Size = 510
        Value = Null
      end>
    Left = 224
    Top = 24
  end
  object tblFjwj: TADOTable
    Connection = stkConn
    CursorType = ctStatic
    TableName = #38468#21152#25991#20214
    Left = 96
    Top = 72
    object tblFjwjGuid: TSmallintField
      FieldName = 'Guid'
    end
    object tblFjwjFileName: TWideStringField
      FieldName = 'FileName'
      Size = 100
    end
    object tblFjwjFilestream: TBlobField
      FieldName = 'Filestream'
    end
  end
  object stSelect: TADODataSet
    Connection = stkConn
    CursorType = ctStatic
    CommandText = 'select *  from '#36873#29992
    Parameters = <>
    Left = 224
    Top = 88
  end
  object dlgOpen1: TOpenDialog
    Left = 288
    Top = 24
  end
end
