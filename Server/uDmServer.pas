unit uDmServer;

interface

uses
  SysUtils, Classes, DB, ADODB, Provider, DBClient, Dialogs;

type
  TdmServer = class(TDataModule)
    connStk: TADOConnection;
    qryStk: TADOQuery;
    dsStk: TADODataSet;
    prvStk: TDataSetProvider;
    connExamineeBase: TADOConnection;
    setExamineeBase: TADODataSet;
    prvExamineeBase: TDataSetProvider;
    dlgOpen1: TOpenDialog;
    procedure prvExamineeBaseGetData(Sender: TObject; DataSet: TCustomClientDataSet);
    procedure prvExamineeBaseUpdateData(Sender: TObject; DataSet: TCustomClientDataSet);
    procedure connStkBeforeConnect(Sender: TObject);
    procedure connExamineeBaseBeforeConnect(Sender: TObject);
  private
    procedure GetKsstkRecord;
  public
      StkDbFilePath:string;
      function GetDsStk:TADODataSet;
      function GetStkConn:TADOConnection;
      function GetStkProvider:TDataSetProvider;
      function GetExamineeProvider: TDataSetProvider;
      procedure Close;
  end;

//var
//  dmServer: TdmServer;

implementation
uses  DataFieldConst, Commons,forms,ServerGlobal, Windows, ExamGlobal;
{$R *.dfm}

procedure TdmServer.Close;
begin
   dsStk.Active:=false;
   connStk.Close;
end;

procedure TdmServer.connExamineeBaseBeforeConnect(Sender: TObject);
var
  path:string;
begin
   path := ExtractFilePath(Application.ExeName);
   if FileExists(path+'成绩库.mdb') then begin
      connExamineeBase.ConnectionString:='Provider=Microsoft.Jet.OLEDB.4.0;Data Source='
        +path+'\成绩库.mdb'
        +';Persist Security Info=False;Jet OLEDB:Database Password='+DecryptStr(SYSDBPWD);
   end else begin
      Application.MessageBox(PChar(Format('系统未能在 %s 中找到 %s 文件！'+ExamGlobal.CR+'请选择成绩库，或重新配置服务系统路径！',[path,'成绩库.mdb'])),
        '未找到成绩库', MB_OK + MB_ICONINFORMATION + MB_TOPMOST);
      dlgOpen1.Title := '请选择系统题库：';
      dlgOpen1.InitialDir := path;
      dlgOpen1.FileName := '成绩库.mdb';
      if dlgOpen1.Execute() then
      begin
         StkDbFilePath := dlgOpen1.FileName;
         connExamineeBase.ConnectionString:='Provider=Microsoft.Jet.OLEDB.4.0;Data Source='
           +dlgOpen1.FileName
           +';Persist Security Info=False;Jet OLEDB:Database Password='+DecryptStr(SYSDBPWD);
      end else begin
         { TODO : 是否要退出程序，还是继续 }
      end;
   end;
end;

procedure TdmServer.connStkBeforeConnect(Sender: TObject);
var
  path:string;
begin
   path := ExtractFilePath(Application.ExeName);
   if FileExists(path+'系统题库.mdb') then begin
      connStk.ConnectionString:='Provider=Microsoft.Jet.OLEDB.4.0;Data Source='
        +path+'系统题库.mdb'
        +';Persist Security Info=False;Jet OLEDB:Database Password='+DecryptStr(SYSDBPWD);
        StkDbFilePath := path+'系统题库.mdb';
   end else begin
      Application.MessageBox(PChar(Format('系统未能在 %s 中找到 %s 文件！'+ExamGlobal.CR+'请选择系统题库，或重新配置服务系统路径！',[path,'系统题库.mdb'])),
        '未找到系统题库', MB_OK + MB_ICONINFORMATION + MB_TOPMOST);
      dlgOpen1.Title := '请选择系统题库：';
      dlgOpen1.InitialDir := path;
      dlgOpen1.FileName := '系统题库.mdb';
      if dlgOpen1.Execute() then
      begin
         StkDbFilePath := dlgOpen1.FileName;
         connStk.ConnectionString:='Provider=Microsoft.Jet.OLEDB.4.0;Data Source='
           +dlgOpen1.FileName
           +';Persist Security Info=False;Jet OLEDB:Database Password='+DecryptStr(SYSDBPWD);
      end else begin
         { TODO : 是否要退出程序，还是继续 }
      end;
   end;
end;

function TdmServer.GetDsStk: TAdoDataSet;
begin
   result:= dsStk;
end;

procedure TdmServer.GetKsstkRecord;
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
//  dm.TkscQuery.Active:=false;
//
//  dm.TbKsStk.Active:=true;
//
//  DaStringList := GetEQStrategy;
//  try
//    for i:=0 to Dastringlist.count-1 do
//    begin
//       commandstring:=Dastringlist.Strings[i];
//       GetGradeParam(commandstring,WGradeRec);
//      with WGradeRec do
//      begin
//        for cc:=0 to ItemCount-1 do
//        begin
//          dm.TkscQuery.Active:=false;
//          dm.TkscQuery.Parameters.ParamByName('v_stno').Value:=trim(items[cc].param1);
//          dm.TkscQuery.active:=true;
//
//          for k:=0 to 10 do
//          begin
//            th[k]:=0;
//          end;    
//
//          recordcount:=dm.TkscQuery.RecordCount;
//          k:=1;
//          if Recordcount>items[cc].points then
//          begin
//            randomize;
//            while k<=items[cc].points do
//            begin
//              recordno:=random(recordcount+1);
//              flag:=false;
//
//              if recordno=0 then
//                 flag:=true
//              else
//              begin
//                for j:=1 to k-1 do
//                begin
//                  if th[j]=recordno then flag:=true;
//                end;
//              end;
//              if  not flag then
//              begin
//                 th[k]:=recordno;
//                 k:=k+1;
//              end;
//            end
//          end
//          else
//          begin
//            for k:=1 to items[cc].points do
//            begin
//              th[k]:=k;
//            end;
//          end;
//       for k:=1 to items[cc].points do
//       begin
//
//        dm.TkscQuery.First;
//        dm.TkscQuery.MoveBy(th[k]-1);
//        dm.tbKsstk.AppendRecord([dm.TkscQuerySt_no.Text,dm.TkscQuerySt_lr.AsString,
//                       dm.TkscQuerySt_item1.AsString,dm.TkscQuerySt_item2.AsString,
//                       dm.TkscQuerySt_item3.AsString,dm.TkscQuerySt_item4.AsString,
//                       dm.TkscQuerySt_comment.AsVariant,dm.TkscQuerySt_da.AsString,null,
//                       dm.TkscQuerySt_hj.AsString,dm.TkscQuerySt_da1.AsString]);
//
//       end;
//     end;
//    end;
//    end;
//   finally
//       DaSTringList.Free;
//       dm.TkscQuery.active:=false;
//       WGradeRec.Items:=nil;
//   end;     
end;

function TdmServer.GetStkConn: TADOConnection;
begin
  Result := connStk;
end;

function TdmServer.GetStkProvider: TDataSetProvider;
begin
   result:=prvStk;
end;

procedure TdmServer.prvExamineeBaseGetData(Sender: TObject; DataSet: TCustomClientDataSet);
begin
//  with DataSet do
//  begin
//    First;
//    while not Eof do
//    begin
//      Edit;
//      FieldValues[DFNEI_EXAMINEEID] := DecryptStr(FieldValues[DFNEI_EXAMINEEID]);
//      Post;
//      Next;
//    end;
//  end;
end;


procedure TdmServer.prvExamineeBaseUpdateData(Sender: TObject; DataSet: TCustomClientDataSet);
begin
  DataSet.FieldByName(DFNEI_EXAMINEEID).ProviderFlags := [pfInKey,pfInWhere];
  //DataSet.FieldByName(DFNEI_IP).ProviderFlags := [pfHidden];
//  DataSet.FieldByName(DFNEI_PORT).ProviderFlags := [pfHidden];
//  DataSet.FieldByName(DFNEI_STATUS).ProviderFlags := [pfHidden];
//  DataSet.FieldByName(DFNEI_REMAINTIME).ProviderFlags := [pfHidden];
  //DataSet.FieldByName(DFNEI_TIMESTAMP).ProviderFlags := [pfHidden];
  //DataSet.FieldByName(DFNEI_SCOREINFO).ProviderFlags := [pfHidden];
end;

function TdmServer.GetExamineeProvider: TDataSetProvider;
begin
  result:=prvExamineeBase;
end;


end.
