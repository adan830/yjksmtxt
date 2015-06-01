unit uConvertDBtoRTF;

interface

uses
  Windows, Messages, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, JvExStdCtrls, JvRichEdit, Menus, cxLookAndFeelPainters, cxButtons,uDmSetQuestion, DB, ADODB, 
  tq, ExamInterface, uGrade;

type
  TfrmConverttoRTF = class(TForm)
    edtConvert: TJvRichEdit;
    btnConvert: TcxButton;
    dsTQDB: TADODataSet;
    procedure btnConvertClick(Sender: TObject);
  private
    procedure ExceuteEnvironmentItemCommand(path: string; AEnvironmentItem: TEnvironmentItem; AExamTcpClient: IExamTcpClient);
    procedure OldGradeInfoStreamToNew(stream: TMemoryStream;chr :Char);
    procedure CovertHj2Environment(sourceHjStr: string;AtempPath:string;ATQ: TTq; AExamTcpClient: IExamTcpClient);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmConverttoRTF: TfrmConverttoRTF;

implementation

uses
  DataFieldConst, StrUtils, DataUtils, Sysutils, Commons, NetGlobal, 
  compress, ExamException, ExamResourceStrings;

{$R *.dfm}

procedure TfrmConverttoRTF.btnConvertClick(Sender: TObject);
var
  strStream: TStringStream;
  stlr :string;
  value:Variant;
  tqRecord : TTQ;
  tempPath:string;
begin
   try
        btnConvert.Enabled := False;
        dsTQDB.Active := True;
        dsTQDB.First;
        strStream := TStringStream.Create('');
        try
          with dsTQDB do
          begin
            while not Eof do
            begin
              tqRecord := TTQ.Create;
              try
                  tqRecord.St_no := FieldValues[DFNTQ_ST_NO];
                 //转换试题文本内容
                 edtConvert.Lines.Clear;
                 edtConvert.Lines.Add(FieldByName(DFNTQ_ST_LR).AsString);
                 if (LeftStr(FieldByName('st_no').AsString,1)='A') or (LeftStr(FieldByName('st_no').AsString,1)='X') then begin
                    edtConvert.Lines.Add('A、'+FieldByName('st_item1').AsString);
                    edtConvert.Lines.Add('B、'+FieldByName('st_item2').AsString);
                    edtConvert.Lines.Add('C、'+FieldByName('st_item3').AsString);
                    edtConvert.Lines.Add('D、'+FieldByName('st_item4').AsString);
                 end;
                 edtConvert.Lines.SaveToStream(tqRecord.Content);
                 //转换试题环境信息
                 if (LeftStr(FieldByName('st_no').AsString,1)='A') or (LeftStr(FieldByName('st_no').AsString,1)='X') then begin
                    //StrToStream( FieldByName(DFNTQ_ST_HJ).AsString ,tqRecord.Environment);
                 end else begin
                     if not (LeftStr(FieldByName('st_no').AsString,1)='C')  then begin

                           CovertHj2Environment(FieldByName(DFNTQ_ST_HJ).AsString,tempPath,tqRecord,IExamTcpClient(DmSetQuestion)) ;

                      end;
                 end;
                 //转换试题标准答案和操作评分信息
                 if (LeftStr(FieldByName('st_no').AsString,1)='A') or (LeftStr(FieldByName('st_no').AsString,1)='X') then begin
                    StrToStream( FieldByName(DFNTQ_ST_DA).AsString ,tqRecord.StAnswer);
                 end else begin
                       StrToStream(FieldByName(DFNTQ_ST_DA1).AsString,tqRecord.StAnswer);
                       if LeftStr(FieldByName('st_no').AsString,1)='F' then
                           OldGradeInfoStreamToNew(tqRecord.StAnswer,'~')
                       else
                           OldGradeInfoStreamToNew(tqRecord.StAnswer,',');
                 end;
                 //将tqRecord数据写入数据库
                 TTQ.WriteCompressedTQ2DB(tqRecord,dmSetQuestion.GetTQDBConn);
              finally
                 tqRecord.Free;
              end;
              Next;
            end;
          end;
        finally
          strStream.Free;
        end;
   except
      on e:Exception do begin
         Application.MessageBox(PChar(Format('转换出错，%s',[e.Message])), PChar('错误'), MB_RETRYCANCEL +
         MB_ICONINFORMATION + MB_TOPMOST) 
      end;
   end;

  btnConvert.Enabled := True;
end;

procedure TfrmConverttoRTF.CovertHj2Environment(sourceHjStr:string;AtempPath:string;ATQ: TTq; AExamTcpClient: IExamTcpClient);
var
   hjstrList:TStringList;
   i:Integer;
   EnvironmentItem : TEnvironmentItem;
   environmentstream : TMemoryStream;
begin
    hjstrList:= TStringList.Create;
   try
     hjstrList.Text := sourceHjStr;
      if LeftStr(ATQ.St_no,1)='D' then begin
         AtempPath := IncludeTrailingPathDelimiter(ExtractFilePath(Application.ExeName))+'tempdir';
         try
            if directoryExists(AtempPath) then begin
               deleteDir(AtempPath);  //path is not exist ?
            end;
            //创建文件夹，如果失败抛出异常
            EDirCreateException.IfFalse(createdir(AtempPath),Format(RSDirCreateError,[AtempPath]));
         //创建windows环境
         for i:=0 to hjstrList.count-1 do
         begin
            StrToEnvironmentItem(hjstrList.Strings[i],EnvironmentItem);
            ExceuteEnvironmentItemCommand(AtempPath,EnvironmentItem,AExamTcpClient);
         end;
         //打包windows环境到流中
         try
               DirectoryCompression(AtempPath,environmentstream);
               ATQ.Environment.LoadFromStream(environmentstream);
            finally
               FreeAndNil(environmentstream);
            end;
         finally
            if directoryExists(AtempPath) then begin
               deleteDir(AtempPath);
            end;
         end;
      end else begin
         //将word,excel,ppt文档从附加文件转到//新库environment 中
         StrToEnvironmentItem(hjstrList.Strings[0],EnvironmentItem);
         EExamException.IfFalse(AExamTcpClient.CommandGetEQFile(EnvironmentItem.Value1,ATQ.Environment)=crOk,Format(
           '转换试题环境出错，试题号：%s !',[ATQ.st_no]))
      end;
   finally

   end;


end;

procedure TfrmConverttoRTF.ExceuteEnvironmentItemCommand(path: string; AEnvironmentItem: TEnvironmentItem; AExamTcpClient: IExamTcpClient);
var
  fileStream:TFileStream;
  memStream : TMemoryStream;
begin
  path:=path+'\';
  case AEnvironmentItem.ID of
    1:  begin
          if not directoryexists(path+AEnvironmentItem.Value1) then
            createdir(path+AEnvironmentItem.Value1);
        end;
    2:  begin
          fileStream := TFileStream.Create(path+AEnvironmentItem.Value1,fmCreate);
          try
            fileStream.WriteBuffer('abc',3);
          finally // wrap up
            fileStream.Free;
          end;    // try/finally
        end;
    3:  begin
            try
               if AExamTcpClient.CommandGetEQFile(AEnvironmentItem.Value1,memStream) =crOk then
               begin
                   memStream.SaveToFile(path+AEnvironmentItem.Value3);
               end else begin
//                  raise ;
               end; 
            finally
               memStream.Free;
            end;
        end;
  end;    // case
end;

procedure TfrmConverttoRTF.OldGradeInfoStreamToNew(stream :TMemoryStream;chr :Char);
var
  strList :TStringList;
  I: Integer;
  function InsertStr(str : string) :string;
  var j :Integer;
    head ,tail:PChar;
    tempstr:string;
    len :integer;
  begin
    len := Length(str);
    SetLength(str,len+1);
    head := @(str[len]);
    tail := @(str[Len+1]);
    j := 0;
    while True do
    begin
      if head^ = chr  then j:=j+1;
      tail^ := head ^;
      tail := tail-1;
      head := head -1;
      if j=2 then begin
        head^ := chr;
        Break;
      end;        
    end;
    Result := str;
  end;
begin
  strList := TStringList.Create;
  try
    strList.LoadFromStream(stream);
    for I := 0 to strList.Count  - 1 do
      strList[i] :=InsertStr(strList[i]);
    stream.Clear;
    strList.SaveToStream(stream);
  finally
     strList.Free;
  end;
end;

end.

