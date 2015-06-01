unit ExamInterface;

interface
uses Classes,NetGlobal, DataFieldConst, ADODB, ExamGlobal;
type


//==============================================================================
// �ͻ�������ʽӿ�
//==============================================================================
   IExamTcpClient =interface
      function CommandGetEQFile(AFileID: string; out AStream: TMemoryStream): TCommandResult;
   end;

   IDataModule =interface
     procedure SetEQBConn(path:string='';dbName:string='�������.dat';pwd:string=CLIENTDBPWD);
     procedure AddClientEQBRec(const Values: array of const);
     procedure GetTestEnvironmentInfo(out testEnvironmentInfo: TStringList);
     function GetDbStrFieldValue(ASqlStr:string;AParamValue:string):string;
   end;

   ///ʵ�ֱ��ӿ����ṩ�������ݿ⣬��ȡ�������� �� TQRecord ��
   ///�� SetQuestion  client server module �о�Ҫʵ��
   ///���ڹ����� ���� examcommons ���̣��������ݿ�
   ITQDataModule = interface
//     procedure ReadTQByID(const AID: string; out ATQ : TTQ);
//     procedure WriteTQByID(const AID: string; const ATQ :TTQ);
     /// <returns>  ������������ڿ������</returns>
//==============================================================================
// ��ȡ ����� ���������� ������ ϵͳ��� �� ������ ȡ�� ������ ����
//==============================================================================
     function GetTQDBConn() : TADOConnection;
//==============================================================================
// ȡ�� ���� ���� ����TBlobField�ֶ�ֵ  ��Ҫ���� Client �У�ȡ��
//==============================================================================
     procedure GetTQFieldStream(const ASqlStr, AParamValue: string;AStream:TMemoryStream);
//     procedure GetTQEnvironmentStream(const AStNO:string;AStream:TmemoryStream);
   end;

implementation

end.
