//==============================================================================
// 2009.5.3 修改，相关文件导入与导出函数，并注释以前的函数，
//          使用试题库中envirenment字段来保存操作题的文档
//==============================================================================


unit uFnMt;

interface
uses adodb, Classes, Commons, DataFieldConst, tq;

type
    ///试题使用信息数组
  TStringListArray= array of TStringList;

  ///命题系统例程
    ///

    ///试题库选用相关例程
    ///
    ///

    /// 将各命题模块ID转换为试题选用表中相应的字段名
    ///
    procedure ModelIDtoName(var fieldname: string; aAction: TFormMode);
    /// 将选用表中当前选用记录所有模块的选用信息装入到数组中
    function GetCurrentStkUseInfo():TStringListArray;
    function GetStkUseInfo(ds:TADODataSet):TStringListArray;



    function GetExportDBConn:TADOConnection;
    procedure ExportTestQuestionsToDB(connSource:TADOConnection;connTarget:TADOConnection;selectInfo:TStringListArray;aModel:TFormMode);


    //打开文件对话框
    //aFilter:代表打开文件对话框中，过滤的文件类型字符串；
    //path:指定打开文件路径，默认为空时，则打开当前程序所在路径
    //result:代表文件打开对话框返回的文件的绝对路径及文件名,为空表示未打开文件；
    function OpenFileDialog(aFilter:string;path:string=''):string;

    procedure doFileImport(var ATQ: TTQ; aFilter: string);
  //操作题用来导入文件
  //从文件中导入
  procedure FileImport(var ATQ: TTQ; FileName: string);
  //从源库中导入
  function   fFileImport(RecID:string;Sourcehjstr:string;sourceConn:TADOConnection):string;  overload;
  function  fFileImport(RecID:string;Sourcehjstr:string;connSource:TADOConnection;connTarget:TADOConnection):string; overload;

implementation
uses uDmSetQuestion,forms,db,sysutils,dialogs,uGrade, ExamException, 
  ExamResourceStrings, ExamGlobal;


procedure FileImport(var ATQ: TTQ; FileName: string);
var
  setTemp:TADODataset;
  str:string;
  environmentItem:TEnvironmentItem;
begin
   EFileNotExistException.IfFalse(FileExists(FileName),Format(RSFileNotExist,[FileName]));
   ATQ.Environment.LoadFromFile(FileName);
end;
{$region  'old fileimport' }
//procedure FileImport(RecID:string;FileName:string;strHj:string);
//var
//  setTemp:TADODataset;
//  str:string;
//  environmentItem:TEnvironmentItem;
//begin
//   EFileNotExistException.IfFalse(FileExists(FileName),Format(RSFileNotExist,[FileName]));
//    if FileName<>'' then
//    begin
//      settemp:=TADODataSet.Create(nil);
//      setTemp.Connection:=dmSetQuestion.stkConn;
//      setTemp.CommandText := 'select st_no,st_hj from 试题 where st_no = '''+RecID+'''';
//      setTemp.Active := true;
//      str:= setTemp.FieldValues['st_hj'];
//      if trim(str)<>'' then
//      begin
//        StrToEnvironmentItem(str,environmentItem);
//        if environmentItem.Value1<>'' then
//        begin
//          settemp.Active :=false;
//          settemp.CommandText:='select guid,filestream from 附加文件 where Guid='+environmentItem.Value1;
//          setTemp.Active:=true;
//          if not setTemp.IsEmpty then
//          begin
//            setTemp.Edit;
//            (setTemp.FieldByName('filestream') as TBlobField).LoadFromFile(FileName);
//            setTemp.Post;
//          end
//        end;
//      end
//      else
//      begin
//        settemp:=TADODataSet.Create(nil);
//        setTemp.Connection:=dmSetQuestion.stkConn;
//        settemp.CommandText:='select max(guid)+1 as id from 附加文件';
//        setTemp.Active:=true;
//        str:= setTemp.FieldValues['id'];
//
//        setTemp.Active := false;
//        setTemp.CommandText := 'select * from 附加文件 ';
//        setTemp.Active := true;
//        setTemp.AppendRecord([strtoint(str),FileName]);
//        begin
//          setTemp.Edit;
//          (setTemp.FieldByName('filestream') as TBlobField).LoadFromFile(FileName);
//          setTemp.Post;
//        end;
//        setTemp.Active := false;
//        settemp.CommandText:='select st_no,st_hj from 试题 where st_no='''+RecID+'''';
//        setTemp.Active:=true;
//        if not setTemp.IsEmpty then
//        begin
//           setTemp.Edit;
//           setTemp.FieldByName('st_hj').Value := 'file,'+str+',,ks_direction,'+strHj+',';
//           setTemp.Post;
//        end;
//      end;
//    end;
//end;

{$endregion}

function  fFileImport(RecID:string;Sourcehjstr:string;sourceConn:TADOConnection):string; overload;
var
  adsSource:TADODataset;
  adsTarget:TADODataset;
  environmentItem:TEnvironmentItem;
  str:string;
begin
  if Sourcehjstr<>'' then
  begin
    StrToEnvironmentItem(Sourcehjstr,environmentItem);
    if environmentItem.Value1<>'' then
    begin
      adsSource:=TADODataSet.Create(nil);
      adsTarget:=TADODataSet.Create(nil);
      try
        adsSource.Connection:=sourceConn;
        adsSource.CommandText := 'select guid,filestream from 附加文件 where Guid='+environmentItem.Value1;
        adsSource.Active := true;

        if not adsSource.IsEmpty then
        begin
          adsTarget.Connection:=dmSetQuestion.stkConn;
          adsTarget.CommandText:='select max(guid)+1 as id from 附加文件';
          adsTarget.Active:=true;
          str:= adsTarget.FieldValues['id'];

          adsTarget.Active := false;
          adsTarget.CommandText := 'select * from 附加文件 ';
          adsTarget.Active := true;
          adsTarget.AppendRecord([strtoint(str),RecID]);
          begin
            adsTarget.Edit;
            (adsTarget.FieldByName('filestream') as TBlobField).Assign(adsSource.FieldByName('filestream'));
            adsTarget.Post;
          end;
          result:=IntToStr(environmentItem.ID)+','+adsTarget.Fieldbyname('guid').AsString+','+environmentItem.Value2+','+environmentItem.Value3+',';
        end;
      finally
        adsSource.Free;
        adsTarget.Free;
      end;
    end;
  end
  else
  begin
    application.MessageBox('附加文件不正确','错误');
  end;
end;

function OpenFileDialog(aFilter:string;path:string=''):string;
var
  OpenDialog: TOpenDialog;
begin
  OpenDialog:=TOpenDialog.Create(nil);
  try
    if path='' then
      path:= extractFilePath(application.ExeName);

    OpenDialog.InitialDir:=path;
    OpenDialog.Filter := aFilter;
    if OpenDialog.Execute then
      result:=OpenDialog.FileName
    else
      result:='';
  finally
    OpenDialog.Free;
  end;
end;

procedure doFileImport(var ATQ: TTQ; aFilter: string);
var
  fileName:string;
begin
    fileName:=OpenFileDialog(aFilter);
    if fileName<>'' then
    begin
      FileImport(ATQ, fileName);
      //提示导入成功
    end;
end;

 //
procedure ModelIDtoName(var fieldname: string; aAction: TFormMode);
begin
  case aAction of
    SINGLESELECT_MODEL:
      fieldname := '单项选择题';
    MULTISELECT_MODEL:
      fieldname := '多项选择题';
    TYPE_MODEL:
      fieldname := '打字题';
    WINDOWS_MODEL:
      fieldname := 'WIN操作题';
    WORD_MODEL:
      fieldname := 'Word操作题';
    EXCEL_MODEL:
      fieldname := 'Excel操作题';
    POWERPOINT_MODEL:
      fieldname := 'Ppt操作题';
  end;
end;

function GetCurrentStkUseInfo():TStringListArray;
var
  ds:TADODataSet;
begin
  ds := dmSetQuestion.StUseInfoDataSet;
  result:=GetStkUseInfo(ds);
end;

function GetStkUseInfo(ds:TADODataSet):TStringListArray;
var
  StUseInfo:TStringListArray;
begin

  SetLength(StUseInfo,7);
  StUseInfo[0]:=TStringList.Create();
  StUseInfo[1]:=TStringList.Create();
  StUseInfo[2]:=TStringList.Create();
  StUseInfo[3]:=TStringList.Create();
  StUseInfo[4]:=TStringList.Create();
  StUseInfo[5]:=TStringList.Create();
  StUseInfo[6]:=TStringList.Create();
  ds.First;
  while not ds.Eof do
  begin
    if ds.FieldValues['是否选用'] then
    begin
         StUseInfo[0].DelimitedText:=ds.FieldValues['单项选择题'];
         StUseInfo[1].DelimitedText:=ds.FieldValues['多项选择题'];
         StUseInfo[2].DelimitedText:=ds.FieldValues['打字题'];
         StUseInfo[3].DelimitedText:=ds.FieldValues['WIN操作题'];
         StUseInfo[4].DelimitedText:=ds.FieldValues['Word操作题'];
         StUseInfo[5].DelimitedText:=ds.FieldValues['Excel操作题'];
         StUseInfo[6].DelimitedText:=ds.FieldValues['Ppt操作题'];
    end;
    ds.Next;
  end;
  result:=StUseInfo;
end;

function GetExportDBConn:TADOConnection;
var
  conn:TADOConnection;
begin
  conn:=TADOConnection.Create(nil);
  conn.Provider:='Microsoft.Jet.OLEDB.4.0';
  conn.LoginPrompt:=false;
  conn.Mode:=cmShareDenyNone;
  conn.ConnectionString:='Provider=Microsoft.Jet.OLEDB.4.0;Data Source='
        +GetApplicationPath()
        +'系统题库-export2007shang.mdb;Persist Security Info=False;Jet OLEDB:Database Password='+DecryptStr(SYSDBPWD);
  conn.Connected:=true;
  result:=conn;
end;


procedure ExportTestQuestionsToDB(connSource:TADOConnection;connTarget:TADOConnection;selectInfo:TStringListArray;aModel:TFormMode);
var
  adsSource,adsTarget:TADODataSet;
  preFlag:string;
  Stno: string;
begin
  preFlag:=GetRecordNoPreFlag(aModel)+'%';
  adsSource:=TADODataSet.Create(nil);
  adsTarget:= TADODataSet.Create(nil);
  try
    adsSource.Connection := connSource;
    adsSource.CommandText :='select * from 试题 where st_no like :v_stno';
    adsSource.Parameters.ParamValues['v_stno']:=preFlag;
    adsSource.Active :=true;

    adsTarget.Connection:=connTarget;
    adsTarget.CommandText :='select * from 试题 where st_no like :v_stno';
    adsTarget.Parameters.ParamValues['v_stno']:=preFlag;
    adsTarget.Active :=true;

    for Stno in selectInfo[integer(aModel)] do
    begin
      if adsSource.Locate('st_no',Stno,[loCaseInsensitive]) then
      begin
          with adsSource do 
          begin
            adsTarget.AppendRecord([FieldValues['st_no'],
                                    FieldValues['st_lr'],
                                    FieldValues['st_item1'],
                                    FieldValues['st_item2'],
                                    FieldValues['st_item3'],
                                    FieldValues['st_item4'],
                                    FieldValues['st_da'],
                                    FieldValues['ksda'],
                                    FieldValues['st_hj'],
                                    FieldValues['st_da1'],
                                    FieldValues['st_comment'],
                                    FieldValues['PointID'],
                                    FieldValues['Nd'],
                                    FieldValues['syn']
                                  ]);
            if (integer(aModel)>=4)  then
              begin
                adsTarget.Edit;
                adsTarget.FieldValues['st_hj']:=fFileImport(FieldValues['st_no'],FieldValues['st_hj'],connSource,connTarget);
                adsTarget.Post;
              end;
          end;         
      end   else begin
        //未找到记录，错误
      end;
    end;
    
  finally // wrap up
    adsSource.Free;
    adsTarget.Free;
  end;    // try/finally

end;

function fFileImport(RecID:string;Sourcehjstr:string;connSource:TADOConnection;connTarget:TADOConnection):string; overload;
var
  adsSource:TADODataset;
  adsTarget:TADODataset;
  environmentItem:TEnvironmentItem;
  str:string;
begin
  if Sourcehjstr<>'' then
  begin
    StrToEnvironmentItem(Sourcehjstr,environmentItem);
//    GetCommandParam(Sourcehjstr,param);
    if environmentItem.Value1<>'' then
    begin
      adsSource:=TADODataSet.Create(nil);
      adsTarget:=TADODataSet.Create(nil);
      try
        adsSource.Connection:=connSource;
        adsSource.CommandText := 'select guid,filestream from 附加文件 where Guid='+environmentItem.Value1;
        adsSource.Active := true;

        if not adsSource.IsEmpty then
        begin
          adsTarget.Connection:=connTarget;
          adsTarget.CommandText:='select max(guid)+1 as id from 附加文件';
          adsTarget.Active:=true;
          str:= adsTarget.FieldValues['id'];

          adsTarget.Active := false;
          adsTarget.CommandText := 'select * from 附加文件 ';
          adsTarget.Active := true;
          adsTarget.AppendRecord([strtoint(str),RecID]);
          begin
            adsTarget.Edit;
            (adsTarget.FieldByName('filestream') as TBlobField).Assign(adsSource.FieldByName('filestream'));
            adsTarget.Post;
          end;
          result:=IntToStr(environmentItem.ID)+','+adsTarget.Fieldbyname('guid').AsString+','+environmentItem.Value2+','+environmentItem.Value3+',';
        end;
      finally
        adsSource.Free;
        adsTarget.Free;
      end;
    end;
  end
  else
  begin
    application.MessageBox('附加文件不正确','错误');
  end;
end;


//procedure CreateExportDB;
//begin
//   //create directory
//  if directoryExists(dm.KsPath) then
//    deleteDir;
//  createdir(dm.KsPath);
//  //建立考生题库
//  dm.tbMainFile.Active:=true;
//  if dm.tbMainFile.Locate('guid','1',[loCaseInsensitive]) then
//  begin
//    dm.tbMainFileFilestream.SaveToFile(dm.KsPath+'\考生题库.dat');
//  end;
//
//  dm.tbMainFile.Active:=false;
//
//  //建立考生题库连接
//  dm.ksconn.ConnectionString:='Provider=Microsoft.Jet.OLEDB.4.0;Data Source='+dm.kspath+'\考生题库.dat;Persist Security Info=False;Jet OLEDB:Database Password=jiaping';
//  dm.ksconn.Connected:=true;
//  CreateKsstRecord;
//
//  //切换考生信息到考生数据库
//   dm.TbKsxxk.Active:=false;
//   dm.TbKsxxk.Connection:=dm.ksconn;
//   dm.TbKsxxk.Active:=true;
//   dm.TbKsxxk.AppendRecord([dm.kszkh,dm.ksxm,dm.kssj]);
//   if trim(dm.tbksXxk.fieldbyname('status').AsString)='' then
//      dm.ksStatus:=1
//   else
//     dm.ksStatus:= strtoint(DecryptStr(dm.tbksXxk.fieldbyname('status').AsString))+1;
//end;

end.
 