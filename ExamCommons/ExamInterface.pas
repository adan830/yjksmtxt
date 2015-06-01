unit ExamInterface;

interface
uses Classes,NetGlobal, DataFieldConst, ADODB, ExamGlobal;
type


//==============================================================================
// 客户网络访问接口
//==============================================================================
   IExamTcpClient =interface
      function CommandGetEQFile(AFileID: string; out AStream: TMemoryStream): TCommandResult;
   end;

   IDataModule =interface
     procedure SetEQBConn(path:string='';dbName:string='考生题库.dat';pwd:string=CLIENTDBPWD);
     procedure AddClientEQBRec(const Values: array of const);
     procedure GetTestEnvironmentInfo(out testEnvironmentInfo: TStringList);
     function GetDbStrFieldValue(ASqlStr:string;AParamValue:string):string;
   end;

   ///实现本接口以提供访问数据库，获取试题内容 到 TQRecord 中
   ///在 SetQuestion  client server module 中均要实现
   ///可在过程中 调用 examcommons 过程，访问数据库
   ITQDataModule = interface
//     procedure ReadTQByID(const AID: string; out ATQ : TTQ);
//     procedure WriteTQByID(const AID: string; const ATQ :TTQ);
     /// <returns>  返回试题表所在库的连接</returns>
//==============================================================================
// 获取 试题库 的数据连接 可用于 系统题库 或 考生库 取得 试题表的 连接
//==============================================================================
     function GetTQDBConn() : TADOConnection;
//==============================================================================
// 取得 试题 表中 单个TBlobField字段值  主要用于 Client 中，取得
//==============================================================================
     procedure GetTQFieldStream(const ASqlStr, AParamValue: string;AStream:TMemoryStream);
//     procedure GetTQEnvironmentStream(const AStNO:string;AStream:TmemoryStream);
   end;

implementation

end.
