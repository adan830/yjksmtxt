unit udmClient;

interface

uses
  SysUtils, Classes, DB, ADODB,  ExtCtrls, NetGlobal,
  ExamGlobal, ExamInterface, tq;

type
  TdmClient = class(TDataModule,IDataModule,ITQDataModule)
    connClientDB: TADOConnection;
    dsKsstk: TDataSource;
    TbKsStk: TADOTable;
    qryKsstk: TADOQuery;
    TbKsxxk: TADOTable;
    MainTimer: TTimer;
    FilterQuery: TADOQuery;
    dsFilterQury: TDataSource;
    ScoreQuery: TADOQuery;
    dsScoreQuery: TDataSource;
    UpdateScoreQuery: TADOQuery;
    procedure MainTimerTimer(Sender: TObject);
  private
    procedure GetTestEnvironmentInfo(out testEnvironmentInfo: TStringList);
    { Private declarations }
  public

      procedure SetEQBConn(path:string='';dbName:string='考生题库.dat';pwd:string='jiaping');
      procedure AddClientEQBRec(const Values: array of const); overload;
      procedure AddClientEQBRec(const ARecordPacket :TClientEQRecordPacket); overload;
//==============================================================================
// 加密考生信息，并保存到考生数据库中
//==============================================================================
      procedure SetupExamineeInfoBase(const AExaminee:TExaminee);

      {$IFDEF UPADTEWINDOWENVIRONMENT}
      //将windows操作题的环境参数修改与word等的一致
      procedure UpdateWindowsEnvironmentParam();
      {$ENDIF }

      function GetData(AEQID:string;AFieldName:string;out dataStrings:TStrings) : TFunctionResult;
      function GetDbStrFieldValue(ASqlStr:string;AParamValue:string):string;
//==============================================================================
// 实现 ITQDataModule 接口的过程
//==============================================================================
      procedure GetTQFieldStream(const ASqlStr, AParamValue: string;AStream:TMemoryStream);
      function GetTQDBConn() : TADOConnection;
      procedure GetTQEnvironmentStream(const AStNO:string;AStream:TmemoryStream);

  end;



implementation
uses ExamClientGlobal, floatform, Forms,
  Windows, Select, KeyType, Commons, DataFieldConst, DataUtils, compress,
  ClientMain;
{$R *.dfm}

{ TDataModule1 }

procedure TdmClient.AddClientEQBRec(const Values: array of const);
begin
   if not TbKsStk.Active then  TbKsStk.Active:=true;
   TbKsStk.AppendRecord(values);
end;

procedure TdmClient.SetEQBConn(path : string='';dbName:string='考生题库.dat'; pwd : string='jiaping');
var
   appPath:string;
begin
   if path='' then
      path:='e:\yjksmtxt\debug\bin';
   connClientDB.ConnectionString:='Provider=Microsoft.Jet.OLEDB.4.0;Data Source='
         +path+'\'+dbName+';Mode=Share Deny None;Persist '
         +'Security Info=False;Jet OLEDB:Database Password='+pwd;
   connClientDB.Connected:=true;
end;

procedure TdmClient.SetupExamineeInfoBase(const AExaminee:TExaminee);
begin
   TbKsxxk.Active:=false;
   TbKsxxk.Connection:=connClientDB;
   TbKsxxk.Active:=true;
   with AExaminee do begin
     TbKsxxk.AppendRecord([EncryptStr(ID),EncryptStr(Name),EncryptStr(IntToStr(RemainTime)),EncryptStr(IntToStr(Ord(Status)))]);
   end;
end;

procedure TdmClient.AddClientEQBRec(const ARecordPacket: TClientEQRecordPacket);
begin
   with ARecordPacket do
   begin
      if not TbKsStk.Active then  TbKsStk.Active:=true;
      AppendTQToDB( TbKsStk, ARecordPacket);
   end;
end;

function TdmClient.GetData(AEQID, AFieldName: string; out dataStrings: TStrings): TFunctionResult;
var
  //EnvironmentInfoStrings : TStringList;
  tempSet:TADODataSet;
begin
   Result := frError;
   tempSet:= TADODataSet.Create(nil);
   try
    tempSet.Connection := connClientDB;
    tempSet.CommandText :='select * from 考生试题 where st_no like :v_stno';
    tempSet.Parameters.ParamValues['v_stno']:=AEQID;
    tempSet.Active :=true;
    if not tempSet.IsEmpty then
    begin
      dataStrings:=TStringList.Create;
      dataStrings.Text :=tempSet.FieldByName(AFieldName).AsWideString ;
      Result := frOk;
    end;
   finally // wrap up
    tempSet.Free;
   end;    // try/finally
end;

function TdmClient.GetDbStrFieldValue(ASqlStr, AParamValue: string): string;
var
   tempSet:TADODataSet;
begin
  result :='';
  tempSet:= TADODataSet.Create(nil);
  try
    tempSet.Connection := connClientDB;
    tempSet.CommandText :=ASqlStr;
    tempSet.Parameters.ParamValues['v_stno']:=AParamValue;
    tempSet.Active :=true;
    if not tempSet.IsEmpty then
    begin
      Result:=tempSet.Fields[0].AsWideString ;
    end;
  finally // wrap up
    tempSet.Free;
  end;    // try/finally
end;

function TdmClient.GetTQDBConn: TADOConnection;
begin
   result := connClientDb;
end;

procedure TdmClient.GetTQFieldStream(const ASqlStr, AParamValue: string;AStream:TMemoryStream);
var
   tempSet:TADODataSet;
begin
  tempSet:= TADODataSet.Create(nil);
  try
    tempSet.Connection := connClientDB;
    tempSet.CommandText :=ASqlStr;
    tempSet.Parameters.ParamValues['v_stno']:=AParamValue;
    tempSet.Active :=true;
    if not tempSet.IsEmpty then
    begin
      if not Assigned(AStream) then
         AStream := TMemoryStream.Create;
      (tempSet.Fields[0] as TBlobField).SaveToStream(AStream) ;
      UnCompressStream(AStream);
    end;
  finally // wrap up
    tempSet.Free;
  end;    // try/finally
end;

procedure TdmClient.GetTestEnvironmentInfo(out testEnvironmentInfo: TStringList);
var
   tempStringList:TStringList;
begin
//   qryKsstk.Active:=false;
//   qryKsstk.Filtered:=false;
   qryKsstk.Filter:='st_hj <>'+quotedstr('');
//   qryKsstk.Filtered:=true;
   qryKsstk.SQL.Add('select * from 考生试题');
   qryKsstk.Open;
   if qryKsstk.RecordCount>0 then begin
      tempStringList:=TstringList.Create;
      try
         while not qryKsstk.Eof do
         begin
            tempStringList.Text:=qryKsstk.FieldByName('st_hj').AsString;
            testEnvironmentInfo.AddStrings(tempStringList);
            tempStringList.Clear;
            qryKsstk.Next;
         end;
      finally
        tempSTringList.Free;
      end;
   end;

end;

procedure TdmClient.MainTimerTimer(Sender: TObject);
var
   sj:string;
begin
      //only Examining update time
      TExamClientGlobal.RemainTime:=TExamClientGlobal.RemainTime-1;

//      { TODO -ojp -c0 : test if overflow ,test if correct }
//      if (TExamClientGlobal.RemainTime div GlobalSysConfig.StatusRefreshInterval)=(TExamClientGlobal.RemainTime / GlobalSysConfig.StatusRefreshInterval) then
//      begin
//         { TODO -ojp -c0 : direct update remaintime in server ,is correct ? }
//         GlobalExamTCPClient.CommandSendExamineeStatus(TExamClientGlobal.ID,TExamClientGlobal.Name,TExamClientGlobal.Status,TExamClientGlobal.RemainTime);
//      end;
      sj:=format('%.2d:%.2d',[TExamClientGlobal.RemainTime div 60,TExamClientGlobal.RemainTime mod 60]);
//      ClientMainForm.stTime.Caption:=sj;
      if TExamClientGlobal.RemainTime<490 then
          TExamClientGlobal.ClientMainForm.SetFlashRemainTime(sj);
      if assigned(FloatWindow) then
      begin
        Floatwindow.stTime.caption:=sj;
        Floatwindow.stTime1.caption:='时间：'+sj;
      end;
      

      if TExamClientGlobal.RemainTime=300 then
         MessageBoxOnTopForm(application,'还有5分钟考试结束，请保存好文档','警告', mb_ok);
      if TExamClientGlobal.RemainTime<=0 then
      begin
         MainTimer.Enabled:=false;
         if floatWindow.Visible then
         begin
           floatWindow.ExitBitBtnClick(floatwindow);
           floatWindow.Visible:=false;
         end;
         if SelectForm.Visible then
         begin
           SelectForm.btnReturnclick(SelectForm);
           SelectForm.visible:=false;
         end;

          if typeForm.visible then
          begin
            typeForm.ExitBitBtnClick(typeForm);
            typeForm.visible:=false;
          end;
          TExamClientGlobal.ClientMainForm.ModalResult :=-1;
          TExamClientGlobal.ClientMainForm.Close;
        //mainform.btnJJClick(mainform);
 
      end;
end;

procedure TdmClient.GetTQEnvironmentStream(const AStNO:string;AStream:TmemoryStream);
var
   RecordData:TStringList;
   streamRecord:TMemoryStream;
begin

end;

{$IFDEF UPADTEWINDOWENVIRONMENT}
//将windows操作题的环境参数修改与word等的一致
procedure TdmClient.UpdateWindowsEnvironmentParam();
var
   ds:TADODataSet;
   resultHj:string;
   EnvironmentItem:TEnvironmentItem;
   i:integer;
   EnvironmentInfoStrings,resultStrings:TStringlist;
begin
   SetEQBConn('e:\yjksmtxt\debug','系统题库.mdb','thepasswordofaccedwm');
   ds:=TADODataSet.Create(nil);
   ds.Connection:=connClientDB;
   ds.CommandText:='select st_no,st_hj from 试题 where st_no like '+quotedstr('D%');
   
   ds.Active:=true;

   EnvironmentInfoStrings:=TStringList.Create;
   resultStrings:=TStringList.Create;
   while not ds.eof do
   begin
      if pos('D',ds.FieldByName('st_no').AsString)=1 then begin
         EnvironmentInfoStrings.Text:=ds.FieldByName('st_hj').AsString;
         for i:=0 to EnvironmentInfoStrings.count-1 do
         begin
           StrToEnvironmentInfo(EnvironmentInfoStrings.Strings[i],EnvironmentItem);

            case EnvironmentItem.ID of
               1:resultHj:='md,'+EnvironmentItem.Value1+',,,,';
               2:resultHj:='winfile,'+EnvironmentItem.Value1+',,,,';
            end;
            resultStrings.Add(resultHj);

         end;
         ds.Edit;
         ds.FieldByName('st_hj').Value:=resultStrings.Text;
         ds.Post;
         resultStrings.Clear;
         EnvironmentInfoStrings.Clear;
      end;
      ds.Next;
   end;
end;
{$ENDIF }

end.
