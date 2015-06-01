unit StkRecordInfo;

interface
uses classes,DBclient, DB, Types, IdGlobal, NetGlobal, ExamInterface, adodb, 
  Forms, BaseConfig,tq;

type
parray=array [0..4]of pchar;
//EQStrategyParamArray=array of array of  pchar;
/////策略中大项的子项
//TEQStrategySubItem = record
//   Lx:integer;
//   Param1:string;
//   Count:integer;
//   bb:TThreadList
//end;

//==============================================================================
// 用来保存考试前预生成的全部考生文件的压缩流数组类型
//==============================================================================
  TExamineeTestFilePackArray = array of TMemoryStream;


TThreadDataSet = class
private
   FDataset:TClientDataSet;
   FLockCount:integer;
   FSemaphore:THandle;
   function GetIsLocked:boolean;
public
   constructor Create();
   destructor Destroy; override;
   function TryLock(TimeOut:DWORD):TClientDataSet;
   function Lock:TClientDataSet;
   procedure Unlock;
   property IsLocked:boolean read GetIsLocked;
end;

   TStkRecordInfo= class(TObject,IExamTcpClient)
   private
      FLock:TIdCriticalSection;
      //FBaseConfigs:TThreadList;   //试题策略
      FBaseConfig : TBaseConfig;     //试题策略 only first from db
      FMemStk:TClientDataSet;      //试题记录库
      FMemStkFile:TClientDataSet;  //试题文件库
      FMemExaminees:TThreadDataSet;
      FExamineeTestFilePacks : TExamineeTestFilePackArray;
//==============================================================================
// 在加密的考生信息记录中不能直接使用locate来查找定位记录，所以写了以下函数
// 如果找到则定位到记录，并返回true;
//==============================================================================
      function LocateExamineeRecord(AID:string;ADS : TDataSet) : Boolean;
      procedure CDSExamineesCalcFields(DataSet: TDataSet);

      procedure FreeExamineeTestFilePacks;
      procedure SetupCDSExamineesStructure(ds: TClientDataSet);
      procedure InitBaseConfig;
   public

      constructor Create();
      destructor Destroy; override;

      class function CreateStkRecordInfo():TStkRecordInfo;

      // abandon procedure SetupBaseConfigs();
      procedure SetupMemStk;
      procedure SetupExamineeTestFilePacks(const APackCount: Integer; const ATempPath: string);
      procedure SetupMemStkFile;
      procedure SetupCDSExaminees;
      
//==============================================================================
// 根据试题策略获取考生试题库信息列表，只包括试题编号
//==============================================================================
      function AcquireEQInfo(const ABaseConfig:TBaseConfig): TStringList;
      //获取一条记录
      function AcquireEQRecord(const ARecordNo:String):TClientEQRecordPacket;
//==============================================================================
// 从预生成的考生测试包中，随机获取一个，装载到内存流中
//==============================================================================
      procedure AcquireTestFilePack(const AExamineeID: String;const ALoginType:string;var AStream: TMemoryStream);
//==============================================================================
// 根据附加文件ID来获取文件数据到内存流
//==============================================================================
      function AcquireEQFile(const AFileID:String):TMemoryStream;
      function AcquireBaseConfig(const ABaseConfig: TBaseConfig): TStringList;  //not Include EQStrategies object's list;
      function UpdateExamineeInfo(AExamineeList:TList):Integer;
//==============================================================================
// 实现 Iinterface 接口的过程
//==============================================================================
  protected
    FRefCount: Integer;
    function QueryInterface(const IID: TGUID; out Obj): HResult; stdcall;
    function _AddRef: Integer; stdcall;
    function _Release: Integer; stdcall;
  public
    property RefCount: Integer read FRefCount;
//==============================================================================
// 实现 ITQDataModule 接口的过程
//==============================================================================
      function GetTQDBConn() : TADOConnection;
      procedure GetTQFieldStream(const ASqlStr, AParamValue: string;AStream:TMemoryStream);
//      procedure GetTQEnvironmentStream(const AStNO:string;AStream:TmemoryStream);
//==============================================================================
// 实现 IExamTcpClient 接口的过程
//==============================================================================
      function CommandGetEQFile(AFileID: string; out AStream: TMemoryStream): TCommandResult;

      //property BaseConfigs :TThreadList read FBaseConfigs;
      // the first baseconfig from db;
      property BaseConfig :TBaseConfig read FBaseConfig;
      property MemStk:TClientDataSet read FMemStk;

   end;

implementation
uses uDmServer,SysUtils, Variants,
  ServerGlobal, Windows, Commons, DataFieldConst, DataUtils, compress, 
  ufrmInProcess, ExamGlobal;


function TStkRecordInfo.AcquireEQRecord(const ARecordNo: String): TClientEQRecordPacket;
var
   RecordData:TStringList;
   streamRecord:TMemoryStream;
begin
   result:=TClientEQRecordPacket.Create;
      with FMemStk do
      begin
          if Filtered then  Filtered:=false;

          if Locate(DFNTQ_ST_NO,ARecordNo,[]) then
          begin
            TTQ.WriteFieldValuesToTQ(FMemStk, result);
          end;
      end;
end;

constructor TStkRecordInfo.Create;
begin
   inherited Create;
   FLock := TIdCriticalSection.Create;
   FMemExaminees := TThreadDataset.Create;
end;

class function TStkRecordInfo.CreateStkRecordInfo:TStkRecordInfo;
begin
  Result := TStkRecordInfo.Create;
  Result.InitBaseConfig;
  Result.SetupMemStk;
  Result.SetupMemStkFile;
  Result.SetupCDSExaminees;
end;

destructor TStkRecordInfo.Destroy;
begin
//     if FbaseConfig.EQStrategies<>nil then begin
//        for  i:= FBaseConfig.EQStrategies.Count-1 downto 0 do begin
//           stragetegyMainItem:=FBaseConfig.EQStrategies[i];
//           FBaseConfig.EQStrategies.Remove(stragetegyMainItem);
//           Dispose(stragetegyMainItem);
//        end;
//     end;
//     FBaseConfig.EQStrategies.Free;
//     if FBaseConfig.Modules<>nil then
//        FBaseConfig.Modules.Free;
     FBaseConfig.Free;

    FMemExaminees.Free;
    FMemStk.Free;
    FMemStkFile.Free;
    FreeExamineeTestFilePacks;
    Flock.Free;
    inherited;
end;
{$REGION '-----Abandon GetEQstrategyItem   ----'}
//function TStkRecordInfo.GetEQStragegyItem(index: Integer): TBaseConfig;
//var
//   list :TList;
//begin
//   FLock.Enter;
//   try
//     list := FBaseConfigs.LockList;
//     try
//        Result :=PBaseConfig(list[index])^;
//     finally
//        FBaseConfigs.UnlockList;
//     end;
//   finally
//     FLock.Leave;
//   end;
//end;
{$ENDREGION}

function TStkRecordInfo.GetTQDBConn: TADOConnection;
begin
  result := nil;
end;

//procedure TStkRecordInfo.GetTQEnvironmentStream(const AStNO:string;AStream:TmemoryStream);
//var
//   RecordData:TStringList;
//   streamRecord:TMemoryStream;
//begin
//
//      with FmemStk do
//      begin
//          if Filtered then  Filtered:=false;
//
//          if Locate(DFNTQ_ST_NO,AStNo,[]) then
//          begin
//
//          end;
//      end;
//end;

procedure TStkRecordInfo.GetTQFieldStream(const ASqlStr, AParamValue: string; AStream: TMemoryStream);
begin
   //null
end;

function TStkRecordInfo.LocateExamineeRecord(AID: string; ADS: TDataSet): Boolean;
var
  str1,str2:string;
begin
  Result := False;
  ads.First;
  with ADS  do
  begin
    while not eof do begin
      str1 := FieldValues[DFNEI_DECRYPTEDID] ;
      if FieldValues[DFNEI_DECRYPTEDID] = AID then begin
        Result := True;
        Exit;
      end;
      Next;
    end;
  end;
end;
{$REGION '---abandon SetupBaseConfigs-----'}
//procedure TStkRecordInfo.SetupBaseConfigs;
//var
//  baseConfig:PBaseConfig;
//  setTemp:TADODataset;
//  contentSTrings:TStringList;
//  EQStrategyMainItem:PEQStrategyMainItem;
//  i:integer;
//begin
//     setTemp:= GlobalDmServer.GetDsStk;
//     if setTemp.Active then
//          setTemp.Active:=false;
//     setTemp.CommandText := 'select * from sysconfig';
//     setTemp.Active := True;
//     try
//        with setTemp do begin
//          while not Eof do begin
//            BaseConfig := TBaseConfig.Create;
//            contentSTrings :=TStringList.Create;
//            try
//              contentSTrings.Text := DecryptStr(FieldByName('Config').AsString);
//              BaseConfig.Name:=contentSTrings.Values['名称'] ;
//              BaseConfig.Clasify := contentSTrings.Values['类型'];
//              BaseConfig.LastDate := contentSTrings.Values['有效日期'];
//              BaseConfig.ScoreDisplayMode:=contentSTrings.Values['显示成绩'];
//             // BaseConfig.ManagePwd := contentSTrings.Values['管理密码'];
//              BaseConfig.ExamPath := contentSTrings.Values['考试路径'];
//              BaseConfig.ExamTime := StrToInt(contentSTrings.Values['考试时间']);
//              BaseConfig.ExamTime := StrToInt(contentSTrings.Values['打字时间']);
//              BaseConfig.StatusRefreshInterval := contentSTrings.Values['状态更新间隔'];
//
//              contentSTrings.Clear;
//              contentSTrings.Text :=setTemp.FieldByName('试题策略').AsWideString;
//              BaseConfig.EQStrategies:=TList.Create;
//              for i := 0 to contentSTrings.Count-1 do
//              begin
//                 new(EQStrategyMainItem);
//                 ParseStrToStrategyMainItem(contentSTrings[i],EQStrategyMainItem^);
//                 BaseConfig.Content.Add(EQStrategyMainItem);
//              end;
//            finally
//               contentSTrings.Free;
//               //Dispose(EQStrategyMainItem);
//            end;
//            BaseConfig.Modules := TStringList.Create;
//            BaseConfig.Modules.Text := DecryptStr(setTemp.FieldByName('Modules').AsString);
//            FBaseConfig.Add(BaseConfig);
//            setTemp.Next;
//          end;
//        end;
//     finally // wrap up
//       setTemp.Active:=false;
//      // setTemp.Connection.Close;
//     end;    // try/finally
//end;

{$endregion}

procedure TStkRecordInfo.InitBaseConfig;
var
  setTemp:TADODataset;
begin
     setTemp:= TExamServerGlobal.GlobalDmServer.GetDsStk;
     if setTemp.Active then
          setTemp.Active:=false;
     setTemp.CommandText := 'select * from sysconfig';
     setTemp.Active := True;
     FBaseConfig := TBaseConfig.Create;
     try
        with setTemp do begin
              FBaseConfig.SetConfig(DecryptStr(FieldByName('Config').AsString));
              FBaseConfig.SetModules(DecryptStr(setTemp.FieldByName('Modules').AsString));
              FBaseConfig.SetEQStrategies(DecryptStr(setTemp.FieldByName('Strategy').AsString));
        end;
     finally
       setTemp.Active:=false;
     end;
end;

procedure TStkRecordInfo.SetupCDSExamineesStructure(ds : TClientDataSet);

  procedure AddStringField(AName : string ;ASize : Integer);
  begin
        with TWideStringField.Create(ds) do
        begin
          FieldName := AName ;
          Size := ASize;
          FieldKind := fkData;
          DataSet := ds ;
        end;
  end;
begin
      with TWideStringField.Create(ds) do
      begin
        FieldName := DFNEI_EXAMINEEID ;
        Size := DFNLENEI_EXAMINEEID;
        FieldKind := fkData;
        ProviderFlags :=  [pfInWhere, pfInKey];
        DataSet := ds ;
      end;
  //        AddStringField(DFNEI_EXAMINEEID,DFNLENEI_EXAMINEEID);
  AddStringField(DFNEI_EXAMINEENAME,DFNLENEI_EXAMINEENAME);
  AddStringField(DFNEI_IP,DFNLENEI_IP);
  AddStringField(DFNEI_PORT,DFNLENEI_PORT);
  AddStringField(DFNEI_STATUS,DFNLENEI_STATUS);
  AddStringField(DFNEI_REMAINTIME,DFNLENEI_REMAINTIME);
  AddStringField(DFNEI_TIMESTAMP,DFNLENEI_TIMESTAMP);
  with TStringField.Create(ds) do
  begin
    FieldName := DFNEI_DECRYPTEDID ;
    Size := DFNLENEI_DECRYPTEDID;
    FieldKind := fkCalculated;
    DataSet := ds ;
  end;
  with TBlobField.Create(ds) do
  begin
    FieldName := DFNEI_SCOREINFO ;
    FieldKind := fkData;
    DataSet := ds ;
  end;
end;



procedure TStkRecordInfo.SetupCDSExaminees;
//var
//  setTemp:TADODataset;
//  tempCDS:TClientDataSet;
begin
     FMemExaminees.FDataset := TClientDataSet.Create(nil);
     SetupCDSExamineesStructure(FMemExaminees.FDataset);
     with FMemExaminees.FDataset do
     begin
        //CreateDataSet;
        SetProvider(TExamServerGlobal.GlobalDmServer.prvExamineeBase);
        CommandText:='select * from 考生信息';
        OnCalcFields := CDSExamineesCalcFields ;
        Active:=true;
        ReadOnly := False;    //notice
     end;
end;

procedure TStkRecordInfo.CDSExamineesCalcFields(DataSet: TDataSet);
begin
    DataSet.FieldValues[DFNEI_DECRYPTEDID] := DecryptStr(DataSet.FieldByName(DFNEI_EXAMINEEID).AsString);
end;

function TStkRecordInfo.CommandGetEQFile(AFileID: string; out AStream: TMemoryStream): TCommandResult;
begin
  result:=crError;
  AStream :=AcquireEQFile(AFileID);
  if AStream.Size>0 then Result := crOk;
end;

procedure TStkRecordInfo.SetupMemStk;
begin
   FMemStk := TClientDataSet.Create(nil);
   with FMemStk do
   begin
      SetProvider(TExamServerGlobal.GlobalDmServer.getStkProvider);
      CommandText:='select * from 试题 ';
      Active:=true;
   end;
end;

procedure TStkRecordInfo.SetupExamineeTestFilePacks(const APackCount: Integer; const ATempPath: string);
var
  I: Integer;
  ZipFileStream:TMemoryStream;
  conn : TADOConnection;
  tempdb : TADODataSet;
  ClientDBFileStream : TMemoryStream;  //used for save clientdb
  pbHandle :Integer;

  procedure SetEQBConn(path : string ;dbName : string=CLIENTDB_FILENAME; pwd : string=CLIENTDBPWD);
  begin
     if tempdb.Active  then tempdb.Active := False;
     if conn.Connected then conn.Connected := False;

     conn.ConnectionString:='Provider=Microsoft.Jet.OLEDB.4.0;Data Source='
           +path+'\'+dbName+';Mode=Share Deny None;Persist '
           +'Security Info=False;Jet OLEDB:Database Password='+DecryptStr(pwd);
     conn.Connected:=true;
     tempdb.Active := True;
  end;

  procedure GetEQRecord(EQNo :string);
  var
     recordPacket:TClientEQRecordPacket;
  begin
    recordPacket := nil;
    try
      recordPacket:=AcquireEQRecord(EQNo);
      AppendTQToDB( tempdb, RecordPacket);
    finally
       if (recordPacket <>nil ) or Assigned(recordPacket)  then
          recordPacket.Free;
    end;
  end;

  procedure PopulateExamineeBase();
  var
     i:Integer;
     AEQInfo :TStringList;
  begin
      AEQInfo := AcquireEQInfo(FBaseConfig);
      try
         for i := 0 to AEQInfo.Count-1 do
         begin
           GetEQRecord(AEQInfo[i]);
         end;
      finally
         AEQInfo.Free;
      end;
  end;
begin
  conn := TADOConnection.Create(nil);
  conn.LoginPrompt := False;
  tempdb := TADODataSet.Create(nil);
  tempdb.Active := False;
  tempdb.CommandText := SQLSTR_GETCLIENT_AllTQ;
  tempdb.Connection := conn;

  ClientDBFileStream:=AcquireEQFile(CLIENTDB_FILEID);
  try
    SetLength(FExamineeTestFilePacks,APackCount);
    pbHandle:=PMBeginProcess(Application,'正在生成考试试卷，请稍等...','',0, APackCount,-1);
    try
      for I := 0 to APackCount-1 do
      begin
        if directoryExists(ATempPath) then begin
            deleteDir(ATempPath);  //path is not exist ?
         end;
        createdir(ATempPath);
        ClientDBFileStream.SaveToFile(ATempPath+'\'+CLIENTDB_FILENAME);
        try
          try
            SetEQBConn(ATempPath);
            PopulateExamineeBase();
            CreateExamEnvironmentByModules(ATempPath,TExamServerGlobal.GlobalOperateModules,tempdb);
          finally
            tempdb.Active := False;
            conn.Connected := False;
          end;
          DirectoryCompression(ATempPath,ZipFileStream );
          FExamineeTestFilePacks[i] := ZipFileStream;
        finally
          if directoryExists(ATempPath) then begin
            deleteDir(ATempPath);
          end;
        end;
        PMOnProcess(pbHandle);
      end;
    finally
      PMEndProcess(pbHandle);
    end;
  finally
    tempdb.Free;
    conn.Free;
    ClientDBFileStream.Free;
    ZipFileStream:=nil;
  end;
end;

procedure TStkRecordInfo.FreeExamineeTestFilePacks;
var
  I: Integer;
begin
  if Length(FExamineeTestFilePacks)>0 then begin
    for I := 0 to High(FExamineeTestFilePacks) do
    begin
      if FExamineeTestFilePacks[i]<>nil  then FExamineeTestFilePacks[i].Free;
    end;
    SetLength(FExamineeTestFilePacks,0);
  end;
end;

procedure TStkRecordInfo.SetupMemStkFile;
begin
   FMemStkFile:=TClientDataSet.Create(nil);
      with FMemStkFile do
      begin
         SetProvider(TExamServerGlobal.GlobalDmServer.getStkProvider);
         CommandText:='select * from 附加文件';
         Active:=true;
      end;
end;

function TStkRecordInfo.UpdateExamineeInfo(AExamineeList: TList): Integer;
var
   i:Integer;
   Item:PExaminee;
   ds:TClientDataSet;
   timeStr:string;
   dstemp:TClientDataSet;
   procedure CopyRecord();
   begin
     dstemp.Append;
     dstemp.Edit;
     dstemp.FieldValues[DFNEI_EXAMINEEID]:= ds.FieldValues[DFNEI_EXAMINEEID];
     dstemp.FieldValues[DFNEI_EXAMINEENAME]:= ds.FieldValues[DFNEI_EXAMINEENAME];
     dstemp.FieldValues[DFNEI_IP]:= ds.FieldValues[DFNEI_IP];
     dstemp.FieldValues[DFNEI_PORT]:= ds.FieldValues[DFNEI_PORT];
     dstemp.FieldValues[DFNEI_STATUS]:= ds.FieldValues[DFNEI_STATUS];
     dstemp.FieldValues[DFNEI_REMAINTIME]:= ds.FieldValues[DFNEI_REMAINTIME];
     dstemp.FieldValues[DFNEI_TIMESTAMP]:= ds.FieldValues[DFNEI_TIMESTAMP];
     (dstemp.FieldByName(DFNEI_SCOREINFO) as TBlobField).Assign(ds.FieldByName(DFNEI_SCOREINFO));
     dstemp.Post;
   end;
begin
  ds := FMemExaminees.Lock;
  dstemp := TClientDataSet.Create(nil);
  try
    SetupCDSExamineesStructure(dstemp);
    dstemp.CreateDataSet;
    dstemp.Active := True;

    ///save current test score to total db
     for i := 0 to AExamineeList.Count-1 do begin
        Item:= AExamineeList[i];
  //{ TODO -ojp -c0 : update for need }
        if Item.Status<>esNotLogined then begin
           if LocateExamineeRecord(item.ID,ds) then begin
              ds.Edit;
              ds.FieldValues[DFNEI_IP]:=EncryptStr(item.IP);
              ds.FieldValues[DFNEI_PORT]:= EncryptStr(IntToStr(item.Port));
              ds.FieldValues[DFNEI_STATUS]:= EncryptStr(IntToStr(Ord(item.Status)));
              ds.FieldValues[DFNEI_REMAINTIME]:= EncryptStr(IntToStr(item.RemainTime));
              ds.FieldValues[DFNEI_TIMESTAMP]:= EncryptStr(DateTimeToStr(item.TimeStamp));
              if Assigned(Item.ScoreCompressedStream) then begin
                Item.ScoreCompressedStream.Position :=0;
                (ds.FieldByName(DFNEI_SCOREINFO) as TBlobField).LoadFromStream(item.ScoreCompressedStream);
              end;
              ds.Post;
              CopyRecord;
           end else begin
              raise Exception.Create('没找到需更新的考生记录');
           end;
        end;
     end;
     ds.ApplyUpdates(0);
     ///save current test score to single file
     DateTimeToString(timeStr,'yyyymmddhhnn',Now);
     { TODO : 需要修改加密 }

     dstemp.SaveToFile(TExamServerGlobal.ServerCustomConfig.ServerDataPath+'\'+ TExamServerGlobal.ServerCustomConfig.SchoolCode+timeStr+'.dat');
  finally
     dstemp.Free;
     FMemExaminees.Unlock;
  end;
   Result := 0;
end;

procedure TStkRecordInfo.AcquireTestFilePack(const AExamineeID: String;const ALoginType:string;var AStream: TMemoryStream);
var
  packCount,index:Integer;
  AStatus : TLoginType;
begin
  packCount:=High(FExamineeTestFilePacks);
  randomize;
  index:=random(packCount+1);
  { TODO -ojp -c0 : 需要考虑是否是多线程安全的 }
  AStatus :=TLoginType( strtoint(ALoginType));
  case AStatus of
    ltFirstLogin,ltReExamLogin : begin
       AStream.LoadFromStream(FExamineeTestFilePacks[index]);
    end;
    ltContinuteEndedExam: begin
                              if  FileExists(TExamServerGlobal.ServerCustomConfig.ServerDataPath+'\'+AExamineeID+'.dat') then begin
                                  AStream.LoadFromFile(TExamServerGlobal.ServerCustomConfig.ServerDataPath+'\'+AExamineeID+'.dat');
                                  AStream.Position :=0;
                              end;
                            end;
     //ltContinuteInterupt: no need file
  end;
end;

function TStkRecordInfo.AcquireEQFile(const AFileID: String): TMemoryStream;
var
   tempDS:TClientDataSet;
begin
   result:=nil;
  // tempDS := FMemStkFile.Lock;
 //  try
      with FMemStkFile do
      begin
          if Locate('guid',AFileID,[]) then
          begin
             result:=TMemoryStream.Create;
             try
                (FieldByName('filestream') as TBlobField).SaveToStream(result);
             except
                result.Free;
                result:=nil;
             end;
          end;
      end;
//   finally
//      FMemStkFile.Unlock;
//   end;
end;

function TStkRecordInfo.AcquireEQInfo(const ABaseConfig:TBaseConfig):TStringList;
var
   k,recordcount,recordno:integer;
   flag:boolean;
  list:TList;
  StrategyContents:TList;
  commandstring:string;
  EQStrategyMainItem:TEQStrategyMainItem;
  i,j:integer;
  cc:integer;
  th:array [1..10] of integer;
  tempDS:TClientDataSet;
begin
  StrategyContents := ABaseConfig.EQStrategies;
  Result:=TStringList.Create;
  tempDS:=TClientDataSet.Create(nil);
  try
//     try
//         tempDS.Data := FMemStk.Lock.Data;
//     finally
//        FMemStk.Unlock;
//     end;
      tempDS.Data := FMemStk.Data;
      for i:=0 to StrategyContents.count-1 do
      begin
      //       commandstring:=StrategyContents.Strings[i];
      //       ParseStrToStrategyMainItem(commandstring,EQStrategyMainItem);
      EQStrategyMainItem:=TEQStrategyMainItem(StrategyContents.Items[i]^);

      with EQStrategyMainItem do
      begin
        for cc:=0 to ItemCount-1 do
        begin
          if tempDS.Filtered then  tempDS.Filtered:=false;
           //if use '%' as wildcard ,the field must be TStringfield,so we use '*'
          tempDS.Filter:='st_no='+quotedStr(trim(items[cc].param1));
          tempDS.Filtered:=true;

          for k:=1 to 10 do
          begin
            th[k]:=0;
          end;
          recordcount:=tempDS.RecordCount;

          k:=1;
          if Recordcount>items[cc].Count then
          begin
            randomize;
            while k<=items[cc].Count do
            begin
              recordno:=random(recordcount+1);
              flag:=false;

              if recordno=0 then
                 flag:=true
              else
              begin
                for j:=1 to k-1 do
                begin
                  if th[j]=recordno then flag:=true;
                end;
              end;
              if  not flag then
              begin
                 th[k]:=recordno;
                 k:=k+1;
              end;
            end
          end
          else
          begin
            for k:=1 to items[cc].Count do
            begin
              th[k]:=k;
            end;
          end;

          for k:=1 to items[cc].Count do
          begin
                with tempDS do
                begin
                   First;
                   MoveBy(th[k]-1);
                   Result.Add(FieldByName('st_no').AsString);
                end;
          end;
         end;
        end;
      end;
   finally
       EQStrategyMainItem.Items:=nil;
       tempDS.Free;
   end;
end;
                  { TODO : 需要修改为ConvertBaseConfigToStrings，而且将过程放入BaseConfig中 当前没引用本函数，改为baseconfig.tostrings}
function TStkRecordInfo.AcquireBaseConfig(const ABaseConfig:TBaseConfig):TStringList;
var
   i:Integer;
begin
//   FLock.Enter;
//   try
//     Result:=TStringList.Create;
//     ABaseConfig.AssignToStrings(Result);                               //将库中默认配置值复制到TStringList中
//     Result[5]:= GlobalCustomConfig.ClientPath;                         //修改为服务器端设置值;
//     Result[8]:= IntToStr(GlobalCustomConfig.StatusRefreshInterval);    //修改为服务器端设置值;
//   finally
//     FLock.Leave;
//   end;
end;



function TStkRecordInfo.QueryInterface(const IID: TGUID; out Obj): HResult;
begin
  if GetInterface(IID, Obj) then
    Result := 0
  else
    Result := E_NOINTERFACE;
end;

function TStkRecordInfo._AddRef: Integer;
begin
  Result := InterlockedIncrement(FRefCount);
end;

function TStkRecordInfo._Release: Integer;
begin
  Result := InterlockedDecrement(FRefCount);
//  if Result = 0 then
//    Destroy;
end;

{ TkbmThreadDataSet }

constructor TThreadDataSet.Create();
begin
   inherited Create();
   FLockCount:=0;
   FSemaphore:=CreateSemaphore(nil,1,1,nil);
end;

destructor TThreadDataSet.Destroy;
begin
   Lock;    // Make sure nobody else is inside the list.
   try
      FDataset.Free;
      inherited Destroy;
   finally
      Unlock;
      CloseHandle(FSemaphore);
   end;
  inherited;
end;

// Take control of the attached dataset.
// Wait for as much as TimeOut msecs to get the control.
// Setting TimeOut to INFINITE (DWORD($FFFFFFFF)) will make the lock wait for ever.

function TThreadDataSet.TryLock(TimeOut:DWORD):TClientDataSet;
var
   n:DWORD;
begin
   inc(FLockCount);
   n:=WaitForSingleObject(FSemaphore,TimeOut);
   if (n=WAIT_TIMEOUT) or (n=WAIT_FAILED) then
   begin
       Result:=nil;
       dec(FLockCount);
       exit;
   end;
   Result:=FDataset;
end;


function TThreadDataSet.Lock:TClientDataSet;
begin
   Result:=TryLock(INFINITE);
end;

procedure TThreadDataSet.Unlock;
begin
     dec(FLockCount);
     ReleaseSemaphore(FSemaphore,1,nil);
end;

function TThreadDataSet.GetIsLocked:boolean;
begin
     Result:=(FLockCount>0);
end;



end.
