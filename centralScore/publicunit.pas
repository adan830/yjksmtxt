unit publicunit;

interface
uses DB,SysUtils,Variants,excel2000,word2000,msppt2000, classes, forms,windows,Adodb,shellapi,udmMain,commons,ufrminprocess;
{$DEFINE WORD2000}
 // udmMain,
type
  //选择题窗口树控件用
  PNode=^node;
  node=record
    st_no,lr,item1,item2,item3,item4,ksda,stda:string;
    flag,txFlag:boolean;
  end;

  //操作题评分用
  parray=array [0..4]of pchar;
  WGradeParamArray=array of array of  pchar;
  FontParaItem = record
    Lx:integer;
    Param1:string;
    Points:integer;
  end;
  WGradeRecord =record
    Lx:integer;
    ObjStr:string;
    ItemCount:integer;
    Items:array of FontParaItem;
  end;
  PageMargin=(PageTopMargin,PageBottomMargin,PageLeftMargin,PageRightMargin);


procedure GetGradeParam(commandstring: string;
  var WGradeRec:WGradeRecord);
procedure CreateksstRecord;
//获得试题策略
function GetEQStrategy:TStrings;
procedure CreatePptExamEnvironment;
procedure CreateExcelExamEnvironment;
procedure CloseAllDoc;
procedure DeleteDir;
procedure GetCommandParam(var commandstring:string;var param:parray);
procedure ExcuteCommand(param: parray);
procedure CreateWordExamEnvironment;

procedure dzgrade;
procedure UpdateScoreInfo(aMode:TFormMode;scoreinfostr:string); overload;
procedure UpdateScoreInfo(text:string); overload;
function SelectScore(amode:TFormMode;ScoreInfoStrings: TStrings):Integer; //选择题得分
function OperateScore(ScoreInfoStrings: TStrings;chr:char=','):single; //操作题得分
function DZOperateScore(ScoreInfoStrings: TStrings;chr:char=','):Integer;
procedure UpdateTotalScore;
procedure UpdateExamState(StateValue:integer);

procedure CreateKsstk;
procedure ClearScore;

procedure SingleSelectGrade(AOnPreccess: TOnProcess); //单选评分
procedure MultiSelectGrade(AOnPreccess: TOnProcess);  //多选评分
procedure WinGrade(AOnPreccess: TOnProcess);          //Windows评分
procedure WordGrade(AOnPreccess: TOnProcess);
procedure ExcelGrade(AOnPreccess: TOnProcess);
procedure PptGrade(AOnPreccess: TOnProcess);

function GradeInfoStringsToScoreInfoStrings(EQID:string;GradeInfoStrings:TStrings;chr:char=','):TStrings;

//var
 // findtext: string;

implementation
uses idglobal,comobj, uGrade,examglobal,TQ,DataUtils,datafieldconst;

procedure CreateKsstk;
begin
   //create directory
  if directoryExists(dm.KsPath) then
    deleteDir;
  createdir(dm.KsPath);
  //建立考生题库
  dm.tbMainFile.Active:=true;
  if dm.tbMainFile.Locate('guid','1',[loCaseInsensitive]) then
  begin
    dm.tbMainFileFilestream.SaveToFile(dm.KsPath+'\考生题库.dat');
  end;

  dm.tbMainFile.Active:=false;

  //建立考生题库连接
  dm.ksconn.ConnectionString:='Provider=Microsoft.Jet.OLEDB.4.0;Data Source='+dm.kspath+'\考生题库.dat;Persist Security Info=False;Jet OLEDB:Database Password=jiaping';
  dm.ksconn.Connected:=true;
  CreateKsstRecord;

  //切换考生信息到考生数据库
   dm.TbKsxxk.Active:=false;
   dm.TbKsxxk.Connection:=dm.ksconn;
   dm.TbKsxxk.Active:=true;
   dm.TbKsxxk.AppendRecord([dm.kszkh,dm.ksxm,dm.kssj]);
   if trim(dm.tbksXxk.fieldbyname('status').AsString)='' then
      dm.ksStatus:=1
   else
     dm.ksStatus:= strtoint(DecryptStr(dm.tbksXxk.fieldbyname('status').AsString))+1;
end;

procedure CreateksstRecord;
var
   k,recordcount,recordno:integer;
   flag:boolean;

  DaStringList:TStrings;
  commandstring:string;
  WGradeRec:WGradeRecord;
  i,j:integer;
  cc:integer;
  th:array [1..10] of integer;
begin
  dm.TkscQuery.Active:=false;

  dm.TbKsStk.Active:=true;

  DaStringList := GetEQStrategy;
  try
    for i:=0 to Dastringlist.count-1 do
    begin
       commandstring:=Dastringlist.Strings[i];
       GetGradeParam(commandstring,WGradeRec);
      with WGradeRec do
      begin
        for cc:=0 to ItemCount-1 do
        begin
          dm.TkscQuery.Active:=false;
          dm.TkscQuery.Parameters.ParamByName('v_stno').Value:=trim(items[cc].param1);
          dm.TkscQuery.active:=true;

          for k:=0 to 10 do
          begin
            th[k]:=0;
          end;

          recordcount:=dm.TkscQuery.RecordCount;
          k:=1;
          if Recordcount>items[cc].points then
          begin
            randomize;
            while k<=items[cc].points do
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
            for k:=1 to items[cc].points do
            begin
              th[k]:=k;
            end;
          end;
       for k:=1 to items[cc].points do
       begin

        dm.TkscQuery.First;
        dm.TkscQuery.MoveBy(th[k]-1);
        dm.tbKsstk.AppendRecord([dm.TkscQuerySt_no.Text,dm.TkscQuerySt_lr.AsString,
                       dm.TkscQuerySt_item1.AsString,dm.TkscQuerySt_item2.AsString,
                       dm.TkscQuerySt_item3.AsString,dm.TkscQuerySt_item4.AsString,
                       dm.TkscQuerySt_comment.AsVariant,dm.TkscQuerySt_da.AsString,null,
                       dm.TkscQuerySt_hj.AsString,dm.TkscQuerySt_da1.AsString]);

       end;
     end;
    end;
    end;
   finally
       DaSTringList.Free;
       dm.TkscQuery.active:=false;
       WGradeRec.Items:=nil;
   end;
end;

procedure ClearScore;
begin
  UpdateScoreInfo(SINGLESELECT_MODEL,'NULL');
  UpdateScoreInfo(MULTISELECT_MODEL,'NULL');
  UpdateScoreInfo(TYPE_MODEL,'C0,1,type,0,,-1,');
  UpdateScoreInfo(WINDOWS_MODEL,'NULL');
  UpdateScoreInfo(WORD_MODEL,'NULL');
  UpdateScoreInfo(EXCEL_MODEL,'NULL');
  UpdateScoreInfo(POWERPOINT_MODEL,'NULL');
  //UpdateScoreInfo('zf','NULL');
end;

procedure GetCommandParam(var commandstring:string; var param:parray);
var
  temp:pchar;
  count:integer;
begin

  for count:=0 to 4 do begin
    param[count]:=nil;
  end;
  temp:=pchar(commandstring);
  count:=0;
  while temp[0]<>#0 do
  begin
    param[count]:=temp;
    temp:=strscan(temp,',');
    temp[0]:=#0;
    temp:=temp+1;
    count:=count+1;
  end;
end;

procedure ExcuteCommand(param: parray);
var
  apppath,kspath:string;
begin
  kspath:=dm.KsPath+'\';
  //apppath:='C:\Program Files\信息技术考试系统\';
  if param[0]='md' then begin
    if not directoryexists(kspath+param[2]) then
      createdir(kspath+param[2]);
  end;
  if param[0]='copy' then begin
    //copyfileto(apppath+param[2],kspath+param[4]);
  end;
  if param[0]='file' then
  begin
    dm.tbMainFile.Active:=true;
    if dm.tbMainFile.Locate('guid',string(param[1]),[loCaseInsensitive]) then
    begin
      dm.tbMainFileFilestream.SaveToFile(kspath+param[4]);
    end;
    dm.tbMainFile.Active:=false;
  end;
end;

procedure CreateWordExamEnvironment;
var
  tempStringList:TStringList;
  commandstring:string;
  param:parray;
  i:integer;

begin
   dm.FilterQuery.Active:=false;
   dm.FilterQuery.Parameters.ParamByName('v_stno').Value:='E%';
   dm.filterquery.active:=true;

   tempStringList:=TstringList.Create;
   try
     tempStringList.Assign(dm.Filterqueryst_hj);
     for i:=0 to tempstringlist.count-1 do  begin

       commandstring:=pchar(tempstringlist.Strings[i]);
       GetCommandParam(commandstring,param);
       ExcuteCommand(param);

     end;
   finally
     tempSTringList.Free;
   end;
end;
procedure CreatePptExamEnvironment;
var
  tempStringList:TStringList;
  commandstring:string;
  param:parray;
  i:integer;
begin
   dm.FilterQuery.Active:=false;
   dm.FilterQuery.Parameters.ParamByName('v_stno').Value:='G%';
   dm.filterquery.active:=true;

   tempStringList:=TstringList.Create;
   try
     tempStringList.Assign(dm.Filterqueryst_hj);
     for i:=0 to tempstringlist.count-1 do  begin

       commandstring:=pchar(tempstringlist.Strings[i]);
       GetCommandParam(commandstring,param);
       ExcuteCommand(param);

     end;
   finally
     tempSTringList.Free;

   end;
end;
procedure CreateExcelExamEnvironment;
var
  tempStringList:TStringList;
  commandstring:string;
  param:parray;
  i:integer;
begin
   dm.FilterQuery.Active:=false;
   dm.FilterQuery.Parameters.ParamByName('v_stno').Value:='F%';
   dm.filterquery.active:=true;

   tempStringList:=TstringList.Create;
   try
     tempStringList.Assign(dm.Filterqueryst_hj);
     for i:=0 to tempstringlist.count-1 do  begin

       commandstring:=pchar(tempstringlist.Strings[i]);
       GetCommandParam(commandstring,param);
       ExcuteCommand(param);

     end;
   finally
     tempSTringList.Free;

   end;
end;

procedure SingleSelectGrade(AOnPreccess: TOnProcess);
//var
//  fs:integer;
//  str:string;
//  ScoreInfoStrings:TStringList;
//begin
//  ScoreInfoStrings:=TstringList.Create;
//  try
//    dm1.FilterQuery.Active:=false;
//    dm1.FilterQuery.Parameters.ParamByName('v_stno').Value := 'A%';
//      dm1.FilterQuery.Active := true;
//      fs := 0;
//      dm1.FilterQuery.First;
//      while not dm1.FilterQuery.Eof do
//         begin
//            if dm1.FilterQueryst_da.text = dm1.FilterQueryksda.text then
//               begin
//                  fs := fs + 1;
//                  str := dm1.FilterQueryst_no.AsString + ',0,,0,' + dm1.FilterQueryksda.text + ',-1,';
//               end
//            else
//               begin
//                  str := dm1.FilterQueryst_no.AsString + ',0,,0,' + dm1.FilterQueryksda.text + ',1,';
//               end;
//            ScoreInfoStrings.Add(str);
//            dm1.FilterQuery.Next;
//            PMOnProcess(pbHandle, '正在对　单项选择题　评分！');
//            // sleep(100);
//         end;
//      UpdateScoreInfo(SINGLESELECT_MODEL, ScoreInfoStrings.text);
//   finally // wrap up

//   end; // try/finally

   var
      fs: integer;
      str: string;
      tq: TTQ;
      AScoreInfo: TStringList;
      ADS: TDataSet;
   begin
      AScoreInfo := TStringList.Create;
      tq := TTQ.Create;
      //ADS := getdatasetbyprefix('A%',TExamClientGlobal.ConnClientDB);
  try
    with  ADS do begin
      fs:=0;
      while not Eof do
      begin
        tq.ClearData;
        TTQ.ReadTQAndUnCompressFromDS(ADS,tq);

        if FieldByName(DFNTQ_KSDA).Text = tq.ReadStAnswerStr then
        begin
          fs:=fs+1;
          str:=FormatSelectGradeInfo(tq.St_no,'1',FieldByName(DFNTQ_KSDA).Text,True);
        end
        else
        begin
          str:=FormatSelectGradeInfo(tq.St_no,'1',FieldByName(DFNTQ_KSDA).Text,False);
        end;
        AScoreInfo.Add(str);
        ads.Next;
        //PMOnProcess(AApp,pbHandle,'正在对　单项选择题　评分！');
        AOnPreccess('正在对　单项选择题　第'+tq.St_no+'题　评分！');

        sleep(100);
      end;
     // UpdateScoreInfo(MODULE_SINGLE_NAME,AScoreInfo.Text);

  //      SaveScoreInto('siglescore.txt',AScoreInfo);
  //    UpdateScoreInfo(SINGLESELECT_MODEL,AScoreInfo.text);
    end;
  finally // wrap up
     AScoreInfo.Free;
     ads.free;
     tq.free;
  end;    // try/finally
end;

procedure MultiSelectGrade(AOnPreccess: TOnProcess);
var
  fs:integer;
  str:string;
  ScoreInfoStrings:TStringList;
begin
  ScoreInfoStrings:=TstringList.Create;
  try
    dm.FilterQuery.Active:=false;
    dm.FilterQuery.Parameters.ParamByName('v_stno').Value:='X%';
    dm.filterquery.active:=true;
    fs:=0;
    dm.filterquery.First;
    while not dm.filterquery.Eof do
    begin
      if dm.FilterQueryst_da.Text=dm.FilterQueryksda.Text then
      begin
        fs:=fs+2;
        str:=dm.FilterQueryst_no.AsString+',0,,0,'+dm.FilterQueryksda.Text+',-1,';
      end
      else
      begin
        str:=dm.FilterQueryst_no.AsString+',0,,0,'+dm.FilterQueryksda.Text+',1,';
      end;
      ScoreInfoStrings.Add(str);
      dm.filterquery.Next;
     // PMOnProcess(pbHandle,'正在对　　多项选择题　　评分！',2);
      //sleep(100)
    end;
    UpdateScoreInfo(MULTISELECT_MODEL,ScoreInfoStrings.text);
  finally // wrap up
    ScoreInfoStrings.free;
  end;    // try/finally
end;

procedure WinGrade(AOnPreccess: TOnProcess);
var
  tempSet: TAdodataSet;
  ScoreInfoStrings :TStringList;
  GradeInfoStrings : TStringList;
begin
  GradeinfoStrings := TStringList.Create;
  ScoreInfoStrings := TStringList.Create;
  tempSet:=TADODataSet.Create(nil);
  try
    tempSet.Connection:= dm.ksconn;
    tempSet.CommandText :='select * from 考生试题 where st_no like :v_stno';
    tempSet.Parameters.ParamValues['v_stno']:='D%';
    tempSet.Active :=true;
    if not tempSet.IsEmpty then
    begin
      GradeInfoStrings.Assign(tempSet.FieldByName('st_da1'));
      //TWinGrade.WinGrade(GradeinfoStrings,dm.kspath,1,pbHandle);
      scoreinfostrings.AddStrings(GradeInfoStringsToScoreInfoStrings(tempSet.FieldByName('st_no').asstring,GradeInfoStrings));
    end;
    UpdateScoreInfo(WINDOWS_MODEL,ScoreInfoStrings.text);
  finally // wrap up
    tempSet.Free;
    GradeInfoStrings.Free;
    ScoreInfoStrings.Free;
  end;    // try/finally
end;

procedure WordGrade(AOnPreccess: TOnProcess);
var
  GradeInfoStrings:TStringList;
  scoreinfostrings : TStringList;
  tempSet: TAdodataSet;
begin
  GradeInfoStrings:=TStringList.Create;
  scoreinfostrings := TStringList.Create;
  tempSet:=TADODataSet.Create(nil);
  try
    tempSet.Connection:= dm.ksconn;
    tempSet.CommandText :='select * from 考生试题 where st_no like :v_stno';
    tempSet.Parameters.ParamValues['v_stno']:='E%';
    tempSet.Active :=true;
    if not tempSet.IsEmpty then
    begin
      GradeInfoStrings.Assign(tempSet.FieldByName('st_da1'));
      //TWordGrade.WordGrade(GradeInfoStrings,dm.KsPath+'\wordst.doc',pbHandle);
      scoreinfostrings.AddStrings(GradeInfoStringsToScoreInfoStrings(tempSet.FieldByName('st_no').asstring,GradeInfoStrings));
    end;
    UpdateScoreInfo(WORD_MODEL,ScoreInfoStrings.text);
  finally // wrap up
    tempSet.Free;
    scoreinfostrings.Free;
    GradeInfoStrings.Free;
  end;    // try/finally
end;

procedure dzgrade;
begin

end;


procedure GetGradeParam(commandstring: string;
  var WGradeRec:WGradeRecord);
var
  temp,temp1:pchar;
  index:integer;
  FontItemCount:integer;
begin
  temp:=pchar(commandstring);
  temp1:=temp;
  temp:=strscan(temp,',');
  temp[0]:=#0;
  temp:=temp+1;
  WGradeRec.Lx:=strtoint(temp1);

  temp1:=temp;
  temp:=strscan(temp,',');
  temp[0]:=#0;
  temp:=temp+1;
  WGradeRec.ObjStr:=temp1;

  temp1:=temp;
  temp:=strscan(temp,',');
  temp[0]:=#0;
  temp:=temp+1;
  WGradeRec.ItemCount:=strtoint(temp1);

  setlength(WGradeRec.items,WGradeRec.ItemCount);
//  FontItemCount:=3;
//  index:=0;
  with WGradeRec do
  begin
    for index:=0 to ItemCount-1 do
    begin
      temp1:=temp;
      temp:=strscan(temp,',');
      temp[0]:=#0;
      temp:=temp+1;
      Items[index].Lx:=strtoint(temp1);

      temp1:=temp;
      temp:=strscan(temp,',');
      temp[0]:=#0;
      temp:=temp+1;
      Items[index].Param1:=temp1;

      temp1:=temp;
      temp:=strscan(temp,',');
      temp[0]:=#0;
      temp:=temp+1;
      Items[index].Points:=strtoint(temp1);
    end;
  end;
end;

procedure ExcelGrade(AOnPreccess: TOnProcess);
var
  GradeInfoStrings:TStringList;
  scoreinfostrings : TStringList;
  tempSet: TAdodataSet;
begin
  GradeInfoStrings:=TStringList.Create;
  scoreinfostrings := TStringList.Create;
  tempSet:=TADODataSet.Create(nil);
  try
      tempSet.Connection:= dm.ksconn;
      tempSet.CommandText :='select * from 考生试题 where st_no like :v_stno';
      tempSet.Parameters.ParamValues['v_stno']:='F%';
      tempSet.Active :=true;
      if not tempSet.IsEmpty then
      begin
        GradeInfoStrings.Assign(tempSet.FieldByName('st_da1'));
        //TExcelGrade.ExcelGrade(GradeInfoStrings,dm.KsPath+'\Excelst.xls',pbHandle);
        scoreinfostrings.AddStrings(GradeInfoStringsToScoreInfoStrings(tempSet.FieldByName('st_no').asstring,GradeInfoStrings,'~'));
      end;
      UpdateScoreInfo(EXCEL_MODEL,ScoreInfoStrings.text);
  finally // wrap up
    GradeInfoStrings.Free;
    scoreinfostrings.free;
    tempSet.Free;
  end;    // try/finally
end;

procedure PptGrade(AOnPreccess: TOnProcess);
var
  GradeInfoStrings:TStringList;
  scoreinfostrings : TStringList;
  tempSet: TAdodataSet;
begin
  GradeInfoStrings:=TStringList.Create;
  scoreinfostrings := TStringList.Create;
  tempSet:=TADODataSet.Create(nil);
  try
      tempSet.Connection:= dm.ksconn;
      tempSet.CommandText :='select * from 考生试题 where st_no like :v_stno';
      tempSet.Parameters.ParamValues['v_stno']:='G%';
      tempSet.Active :=true;
      if not tempSet.IsEmpty then
      begin
        GradeInfoStrings.Assign(tempSet.FieldByName('st_da1'));
        //TPptGrade.PptGrade(GradeInfoStrings,dm.KsPath+'\powerpointst.ppt',pbHandle);
        scoreinfostrings.AddStrings(GradeInfoStringsToScoreInfoStrings(tempSet.FieldByName('st_no').asstring,GradeInfoStrings));
      end;
    UpdateScoreInfo(POWERPOINT_MODEL,ScoreInfoStrings.text);
  finally // wrap up
    GradeInfoStrings.Free;
    scoreinfostrings.free;
    tempSet.Free;
  end;    // try/finally
end;

procedure UpdateScoreInfo(aMode:TFormMode;scoreinfostr:string);
var
  sqlStr:string;
  dfstr:string;
begin
  dm.UpdateScoreQuery.Active:=false;
  dm.UpdateScoreQuery.SQL.Clear;

  case aMode of    //
   SINGLESELECT_MODEL : sqlstr:='update 考生信息 set xz1_fs = :v_df where zkh=:v_zkh';
   MULTISELECT_MODEL  : sqlstr:='update 考生信息 set pd_fs = :v_df where zkh=:v_zkh';
   TYPE_MODEL         : sqlstr:='update 考生信息 set dz_fs = :v_df where zkh=:v_zkh';
   WINDOWS_MODEL      : sqlstr:='update 考生信息 set win_fs = :v_df where zkh=:v_zkh';
   WORD_MODEL         : sqlstr:='update 考生信息 set word_fs = :v_df where zkh=:v_zkh';
   EXCEL_MODEL        : sqlstr:='update 考生信息 set excel_fs = :v_df where zkh=:v_zkh';
   POWERPOINT_MODEL   : sqlstr:='update 考生信息 set ppt_fs = :v_df where zkh=:v_zkh';
  end;    // case

  begin
    dm.UpdateScoreQuery.SQL.Add(sqlstr);
    dfstr:=encryptStr(scoreInfostr);
    Dm.UpdateScoreQuery.Parameters.ParamByName('v_df').Value:=dfstr;
    Dm.UpdateScoreQuery.Parameters.ParamByName('v_zkh').Value:=dm.kszkh;
    dm.UpdateScoreQuery.ExecSQL;
  end
end;

function SelectScore(amode:TFormMode;ScoreInfoStrings: TStrings):Integer;
var
  I: Integer;
  Score : Integer;
  scoreInfo:TScoreInfo;
begin
  score := 0;
  for I := 1 to ScoreInfoStrings.Count  do    // Iterate
  begin
    StrToScoreInfo(ScoreInfoStrings.Strings[i-1],scoreinfo);
    if scoreinfo.IsRight=-1 then
    begin
      Score := score +1;
    end
  end;    // for
  case aMode  of    //
    MULTISELECT_MODEL:
    begin
      score := score*2;
    end;
  end;    // case
  result := Score ;
end;

function OperateScore(ScoreInfoStrings: TStrings;chr:char=','):single;
var
  I: Integer;
  Score : single;
  scoreInfo:TScoreInfo;
begin
  score := 0;
  for I := 1 to ScoreInfoStrings.Count  do    // Iterate
  begin
    StrToScoreInfo(ScoreInfoStrings.Strings[i-1],scoreinfo,chr);
    if scoreinfo.IsRight=-1 then
    begin
      Score := score + scoreInfo.points;
    end
  end;    // for
  result := Score/10 ;
end;

function DZOperateScore(ScoreInfoStrings: TStrings;chr:char=','):Integer;
var
  I: Integer;
  Score : Integer;
  scoreInfo:TScoreInfo;
begin
  score := 0;
  for I := 1 to ScoreInfoStrings.Count  do    // Iterate
  begin
    StrToScoreInfo(ScoreInfoStrings.Strings[i-1],scoreinfo,chr);
    if scoreinfo.IsRight=-1 then
    begin
      Score := score + scoreInfo.points;
    end
  end;    // for
  result := Score ;
end;

procedure UpdateTotalScore;
var
  ScoreInfoStrings:TStringList;
  tempSet: TAdodataSet;
  TotalScore:single;
begin
  TotalScore := 0;
  tempSet:= TAdodataSet.Create(nil);
  ScoreInfoStrings:=TStringList.Create;
  try
    tempSet.Connection := dm.sysconn;
    tempSet.CommandText:='select * from 考生信息 where zkh=:v_zkh';
    tempSet.Parameters.ParamByName('v_zkh').Value:=dm.kszkh;
    tempSet.Active:=true;
    ScoreInfoStrings.Text:=DecryptStr(tempSet.Fieldbyname('xz1_fs').AsString);
    TotalScore := TotalScore+SelectScore(SINGLESELECT_MODEL,ScoreInfoStrings);

    ScoreInfoStrings.Text:=DecryptStr(tempSet.Fieldbyname('pd_fs').AsString);
    TotalScore := TotalScore+SelectScore(MULTISELECT_MODEL,ScoreInfoStrings);

    ScoreInfoStrings.Text:=DecryptStr(tempSet.Fieldbyname('dz_fs').AsString);
    TotalScore := TotalScore+dzOperateScore(ScoreInfoStrings);

    ScoreInfoStrings.Text:=DecryptStr(tempSet.Fieldbyname('Win_fs').AsString);
    TotalScore := TotalScore+OperateScore(ScoreInfoStrings);

    ScoreInfoStrings.Text:=DecryptStr(tempSet.Fieldbyname('Word_fs').AsString);
    TotalScore := TotalScore+OperateScore(ScoreInfoStrings);

    ScoreInfoStrings.Text:=DecryptStr(tempSet.Fieldbyname('Excel_fs').AsString);
    TotalScore := TotalScore+OperateScore(ScoreInfoStrings,'~');

    ScoreInfoStrings.Text:=DecryptStr(tempSet.Fieldbyname('ppt_fs').AsString);
    TotalScore := TotalScore+OperateScore(ScoreInfoStrings);

    dm.UpdateScoreQuery.Active:=false;
    dm.UpdateScoreQuery.SQL.Clear;

    dm.UpdateScoreQuery.SQL.Add('update 考生信息 set zf = :v_df where zkh=:v_zkh');
    Dm.UpdateScoreQuery.Parameters.ParamByName('v_df').Value:=encryptStr(inttostr(trunc(TotalScore)));
    Dm.UpdateScoreQuery.Parameters.ParamByName('v_zkh').Value:=dm.kszkh;
    dm.UpdateScoreQuery.ExecSQL;
  finally // wrap up
    ScoreInfoStrings.Free;
    tempSet.Free;
  end;    // try/finally
end;

procedure UpdateExamState(StateValue:integer);
var
  dfstr:string;
begin
  dm.UpdateScoreQuery.Active:=false;
  dm.UpdateScoreQuery.SQL.Clear;
  dm.UpdateScoreQuery.SQL.Add('update 考生信息 set status = :v_df where zkh=:v_zkh');
  dfstr:=encryptStr(inttostr(StateValue));
  Dm.UpdateScoreQuery.Parameters.ParamByName('v_df').Value:=dfstr;
  Dm.UpdateScoreQuery.Parameters.ParamByName('v_zkh').Value:=dm.kszkh;
  dm.UpdateScoreQuery.ExecSQL;
end;

procedure UpdateScoreInfo(text:string);
var
  dfstr:string;
  sqlstr:string;
begin
  dm.UpdateScoreQuery.SQL.Clear;
  sqlstr:='update 考生信息 set scoreinfo = :v_df where zkh=:v_zkh';
  dm.UpdateScoreQuery.SQL.Add(sqlstr);
  dfstr:=encryptStr(text);
  Dm.UpdateScoreQuery.Parameters.ParamByName('v_df').Value:=dfstr;
  Dm.UpdateScoreQuery.Parameters.ParamByName('v_zkh').Value:=dm.kszkh;
  dm.UpdateScoreQuery.ExecSQL;
end;

procedure CloseAllDoc;
var
  WordApp:TWordApplication;
  ExcelApp:TExcelApplication;
  PptApp:TPowerPointApplication;
  savechanges,originalformat,routeDocument:olevariant;
  i,c:integer;
begin
   //关闭WORD程序
   if  findwindow('OpusApp',nil)>0 then
   begin
      WordApp:=TWordApplication.Create(application);
      wordapp.Visible:=true;
      if  wordapp.Documents.Count>0 then
      begin
       savechanges:=wdSaveChanges;
       originalformat:=wdOriginalDocumentFormat;
       routeDocument:=false;
       wordapp.Documents.Close(savechanges,originalformat,routeDocument);
      end;
      WordApp.quit;
      WordApp:=nil;
   end;
   //关闭EXCEL程序
   if  findwindow('XLMAIN',nil)>0 then
   begin
      ExcelApp:=TExcelApplication.Create(application);
     // ExcelApp.v.Visible:=true;
     c:= ExcelApp.Workbooks.Count;
      if  c>0 then
      begin
       savechanges:=wdSaveChanges;
       originalformat:=null;
       routeDocument:=null;
       for i:=1 to c do
       begin
         ExcelApp.Workbooks.Item[c].Close(savechanges,originalformat,routeDocument,0);

       end;
      end;
      Excelapp.Workbooks.Close(0);
      excelapp.Disconnect;
      excelapp.Quit;
     excelapp.Destroy;

      ExcelApp:=nil;
   end;
   //关闭PPT程序
   if  findwindow('PP9FrameClass',nil)>0 then
   begin
      PptApp:=TPowerPointApplication.Create(application);
     // ExcelApp.v.Visible:=true;
      c:=PptApp.Presentations.Count;

      if  c>0 then
      begin
       savechanges:=wdSaveChanges;
       originalformat:=null;
       routeDocument:=null;
       for i:=1 to c do
       begin
         PptApp.Presentations.Item(i).save;
         PptApp.Presentations.Item(i).close;
       end;
      end;
      PptApp.quit;
      PptApp:=nil;
   end;end;

procedure DeleteDir;
var
  lpFileOp: TSHFileOpstruct;
begin
   dm.ksconn.Connected:=false;
    if DirectoryExists(dm.KsPath) then
    begin
        with lpFileOp do
        begin
            Wnd := application.Handle;
            wFunc := FO_DELETE;
            pFrom := pchar(dm.KsPath + #0#0);
            pTo := nil;
            fFlags := FOF_NOCONFIRMATION;
            hNameMappings := nil;
            lpszProgressTitle := nil;
            fAnyOperationsAborted := false;
        end;
        SHFileOperation(lpFileOp);

    end;
end;


//获得试题策略
function GetEQStrategy:TStrings;
var
  strlist:TStrings;
  setTemp:TADODataset;
begin
  setTemp := TADODataSet.Create(nil);
  try
    setTemp.Connection :=dm.sysconn;
    setTemp.CommandText := 'select top 1 试题策略 from sysconfig';
    setTemp.Active := True;
    if not setTemp.IsEmpty then
    begin
      strlist := TStringList.Create;
      try
        strlist.Assign(setTemp.FieldByName('试题策略'));
        result := strlist;
      except
        strlist.Free;
        result := nil;
      end;    // try/except
    end;
  finally // wrap up
    setTemp.Free;
  end;    // try/finally
end;

function GradeInfoStringsToScoreInfoStrings(EQID:string;GradeInfoStrings:TStrings;chr:char=','):TStrings;
var
  GradeInfo: TGradeInfo;
  I: Integer;
  ResultStrings:TStringlist;
begin
  ResultStrings:=TStringList.create;
  try
    for I := 0 to GradeInfoStrings.Count - 1 do    // Iterate
    begin
      StrToGradeInfo(GradeInfoStrings.Strings[i],GradeInfo,chr);
      ResultStrings.Add(EQID+chr+inttostr(gradeInfo.ID)+chr+gradeinfo.EQText+chr+inttostr(gradeinfo.Points)+chr+gradeinfo.ExamineValue+chr+inttostr(gradeInfo.IsRight)+chr);
    end;    // for
    result:=ResultStrings;
  except // wrap up
    result:=nil;
    ResultStrings.Free;
  end;    // try/finally
end;


end.
