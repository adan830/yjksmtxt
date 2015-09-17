unit uConvertDBtoRTF;

interface

uses
   Windows, Messages, Variants, Classes, Graphics, Controls, Forms,
   Dialogs, StdCtrls, JvExStdCtrls, JvRichEdit, Menus, cxLookAndFeelPainters,
   cxButtons, uDmSetQuestion, DB, ADODB,
   tq, ExamInterface, uGrade, cxGraphics, cxLookAndFeels, dxSkinsCore,
   dxSkinsDefaultPainters, cxControls, cxContainer, cxEdit, cxDropDownEdit,
   cxTextEdit, cxMaskEdit, cxButtonEdit, cxLabel;

type
   TfrmConverttoRTF = class(TForm)
      edtConvert: TJvRichEdit;
      cxLabel3: TcxLabel;
      bedtSourceFile: TcxButtonEdit;
      cbEqType: TcxComboBox;
      cxLabel1: TcxLabel;
      btnEQImport: TcxButton;
      btnUpdateFont: TcxButton;
      procedure btnConvertClick(Sender: TObject);
      procedure bedtSourceFilePropertiesButtonClick(Sender: TObject;
        AButtonIndex: Integer);
      procedure btnUpdateFontClick(Sender: TObject);
   private
      procedure ExceuteEnvironmentItemCommand(path: string;
        AEnvironmentItem: TEnvironmentItem; AExamTcpClient: IExamTcpClient);
      procedure OldGradeInfoStreamToNew(stream: TMemoryStream; chr: Char);
      procedure CovertHj2Environment(sourceHjStr: string; AtempPath: string;
        ATQ: TTq; AExamTcpClient: IExamTcpClient);
      { Private declarations }
   public
      { Public declarations }
   end;

var
   frmConverttoRTF: TfrmConverttoRTF;

implementation

uses
   DataFieldConst, StrUtils, DataUtils, Sysutils, Commons, NetGlobal,
   compress, ExamException, ExamResourceStrings, examglobal, ufnmt;

{$R *.dfm}

procedure TfrmConverttoRTF.bedtSourceFilePropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
   bedtSourceFile.Text := OpenFileDialog('access数据库|*.mdb');
end;

procedure TfrmConverttoRTF.btnConvertClick(Sender: TObject);
var
   strStream: TStringStream;
   stlr: string;
   value: Variant;
   tqRecord: TTq;
   tempPath: string;
   connsource: TADOConnection;
   adsSource: TADODataSet;
   EQTypeStr: string;
begin
   if Length(bedtSourceFile.Text) = 0 then
      exit;
   btnEQImport.Enabled := False;
   // modify this for st
   EQTypeStr := 'A%';

   connsource := TADOConnection.Create(nil);
   adsSource := TADODataSet.Create(nil);
   try
      if cbEqType.Text = '单项选择题' then
      begin
         EQTypeStr := 'A%';
      end;
      if cbEqType.Text = '多项选择题' then
      begin
         EQTypeStr := 'X%';
      end;
      if cbEqType.Text = '打字题' then
      begin
         EQTypeStr := 'C%';
      end;
      if cbEqType.Text = 'Windows操作题' then
      begin
         EQTypeStr := 'D%';
      end;
      if cbEqType.Text = 'Word操作题' then
      begin
         EQTypeStr := 'E%';
      end;
      if cbEqType.Text = 'Excel操作题' then
      begin
         EQTypeStr := 'F%';
      end;
      if cbEqType.Text = 'PowerPoint操作题' then
      begin
         EQTypeStr := 'G%';
      end;

      connsource.ConnectionString :=
        'Provider=Microsoft.Jet.OLEDB.4.0;User ID=Admin;Data Source=' +
        bedtSourceFile.Text +
        ';Mode=Share Deny None;Extended Properties="";Jet OLEDB:System database="";Jet OLEDB:Database Password='
        + DecryptStr(SYSDBPWD) +
        ';Jet OLEDB:Engine Type=5;Jet OLEDB:Database Locking Mode=1;';
      connsource.LoginPrompt := False;
      adsSource.Connection := connsource;
      adsSource.CommandText := 'select * from 试题 where st_no like ' +
        QuotedStr(EQTypeStr);
      adsSource.Active := True;

      strStream := TStringStream.Create('');

      try
         with adsSource do
         begin
            while not Eof do
            begin
               tqRecord := TTq.Create;
               try
                  tqRecord.St_no := FieldValues[DFNTQ_ST_NO];
                  // 转换试题文本内容
                  edtConvert.Lines.Clear;
                  edtConvert.Lines.Add(FieldByName(DFNTQ_ST_LR).AsString);
                  if (LeftStr(FieldByName('st_no').AsString, 1) = 'A') or
                    (LeftStr(FieldByName('st_no').AsString, 1) = 'X') then
                  begin
                     edtConvert.Lines.Add('A、' + FieldByName('st_item1')
                       .AsString);
                     edtConvert.Lines.Add('B、' + FieldByName('st_item2')
                       .AsString);
                     edtConvert.Lines.Add('C、' + FieldByName('st_item3')
                       .AsString);
                     edtConvert.Lines.Add('D、' + FieldByName('st_item4')
                       .AsString);
                  end;
                  edtConvert.Lines.SaveToStream(tqRecord.Content);
                  // 转换试题环境信息
                  if (LeftStr(FieldByName('st_no').AsString, 1) = 'A') or
                    (LeftStr(FieldByName('st_no').AsString, 1) = 'X') then
                  begin
                     // StrToStream( FieldByName(DFNTQ_ST_HJ).AsString ,tqRecord.Environment);
                  end
                  else
                  begin
                     if not(LeftStr(FieldByName('st_no').AsString, 1) = 'C')
                     then
                     begin

                        CovertHj2Environment(FieldByName(DFNTQ_ST_HJ).AsString,
                          tempPath, tqRecord, IExamTcpClient(DmSetQuestion));

                     end;
                  end;
                  // 转换试题标准答案和操作评分信息
                  if (LeftStr(FieldByName('st_no').AsString, 1) = 'A') or
                    (LeftStr(FieldByName('st_no').AsString, 1) = 'X') then
                  begin
                     StrToStream(FieldByName(DFNTQ_ST_DA).AsString,
                       tqRecord.StAnswer);
                  end
                  else
                  begin
                     StrToStream(FieldByName(DFNTQ_ST_DA1).AsString,
                       tqRecord.StAnswer);
                     if LeftStr(FieldByName('st_no').AsString, 1) = 'F' then
                        OldGradeInfoStreamToNew(tqRecord.StAnswer, '~')
                     else
                        OldGradeInfoStreamToNew(tqRecord.StAnswer, ',');
                  end;
                  // 将tqRecord数据写入数据库
                  TTq.WriteCompressedTQ2DB(tqRecord, DmSetQuestion.GetTQDBConn);
               finally
                  tqRecord.Free;
               end;
               Next;
            end;
         end;
      finally
         strStream.Free;
         btnEQImport.Enabled := True;
      end;
   except
      on e: Exception do
      begin
         Application.MessageBox(PChar(Format('转换出错，%s', [e.Message])),
           PChar('错误'), MB_RETRYCANCEL + MB_ICONINFORMATION + MB_TOPMOST)
      end;
   end;

end;

procedure TfrmConverttoRTF.btnUpdateFontClick(Sender: TObject);
var
   strStream: TStringStream;
   stlr: string;
   value: Variant;
   tqRecord: TTq;
   tempPath: string;
   EQTypeStr: string;
   setSysBase: TADODataSet;
begin
   btnUpdateFont.Enabled := False;
   // modify this for st
   EQTypeStr := 'A%';

   if cbEqType.Text = '单项选择题' then
   begin
      EQTypeStr := 'A%';
   end;
   if cbEqType.Text = '多项选择题' then
   begin
      EQTypeStr := 'X%';
   end;
   if cbEqType.Text = '打字题' then
   begin
      EQTypeStr := 'C%';
   end;
   if cbEqType.Text = 'Windows操作题' then
   begin
      EQTypeStr := 'D%';
   end;
   if cbEqType.Text = 'Word操作题' then
   begin
      EQTypeStr := 'E%';
   end;
   if cbEqType.Text = 'Excel操作题' then
   begin
      EQTypeStr := 'F%';
   end;
   if cbEqType.Text = 'PowerPoint操作题' then
   begin
      EQTypeStr := 'G%';
   end;
   setSysBase := TADODataSet.Create(nil);
   try
      setSysBase.Connection := DmSetQuestion.stkConn;
      setSysBase.CommandText := 'select * from 试题 where st_no like ' +
        QuotedStr(EQTypeStr);
      setSysBase.Active := True;

      //while not setSysBase.Eof do
      begin
         tqRecord := TTq.Create;
         try
            TTq.ReadTQFromDB(setSysBase.FieldValues['st_no'],
              DmSetQuestion.GetTQDBConn, tqRecord);
            UnCompressStream(tqRecord.Content);
            edtConvert.Lines.LoadFromStream(tqRecord.Content);
            edtConvert.SetSelection(0,length( edtConvert.Text),false);
            edtConvert.SelAttributes.Height:=24;
            edtConvert.SelAttributes.Name:='宋体';
            edtConvert.Lines.SaveToStream(tqRecord.Content);
            //tqRecord.Content.SaveToFile('aaaa.txt');
            CompressStream(tqRecord.Content);

            TTq.WriteTQ2DB(tqRecord, DmSetQuestion.GetTQDBConn,[]);
         //   setSysBase.Next;
         finally
            tqRecord.Free;
         end;
      end;
   finally
      setSysBase.Free;
   end;

end;

procedure TfrmConverttoRTF.CovertHj2Environment(sourceHjStr: string;
  AtempPath: string; ATQ: TTq; AExamTcpClient: IExamTcpClient);
var
   hjstrList: TStringList;
   i: Integer;
   EnvironmentItem: TEnvironmentItem;
   environmentstream: TMemoryStream;
begin
   hjstrList := TStringList.Create;
   try
      hjstrList.Text := sourceHjStr;
      if LeftStr(ATQ.St_no, 1) = 'D' then
      begin
         AtempPath := IncludeTrailingPathDelimiter
           (ExtractFilePath(Application.ExeName)) + 'tempdir';
         try
            if directoryExists(AtempPath) then
            begin
               deleteDir(AtempPath); // path is not exist ?
            end;
            // 创建文件夹，如果失败抛出异常
            EDirCreateException.IfFalse(createdir(AtempPath),
              Format(RSDirCreateError, [AtempPath]));
            // 创建windows环境
            for i := 0 to hjstrList.count - 1 do
            begin
               StrToEnvironmentItem(hjstrList.Strings[i], EnvironmentItem);
               ExceuteEnvironmentItemCommand(AtempPath, EnvironmentItem,
                 AExamTcpClient);
            end;
            // 打包windows环境到流中
            try
               DirectoryCompression(AtempPath, environmentstream);
               ATQ.Environment.LoadFromStream(environmentstream);
            finally
               FreeAndNil(environmentstream);
            end;
         finally
            if directoryExists(AtempPath) then
            begin
               deleteDir(AtempPath);
            end;
         end;
      end
      else
      begin
         // 将word,excel,ppt文档从附加文件转到//新库environment 中
         StrToEnvironmentItem(hjstrList.Strings[0], EnvironmentItem);
         EExamException.IfFalse(AExamTcpClient.CommandGetEQFile
           (EnvironmentItem.Value1, ATQ.Environment) = crOk,
           Format('转换试题环境出错，试题号：%s !', [ATQ.St_no]))
      end;
   finally

   end;

end;

procedure TfrmConverttoRTF.ExceuteEnvironmentItemCommand(path: string;
  AEnvironmentItem: TEnvironmentItem; AExamTcpClient: IExamTcpClient);
var
   fileStream: TFileStream;
   memStream: TMemoryStream;
begin
   path := path + '\';
   case AEnvironmentItem.ID of
      1:
         begin
            if not directoryExists(path + AEnvironmentItem.Value1) then
               createdir(path + AEnvironmentItem.Value1);
         end;
      2:
         begin
            fileStream := TFileStream.Create(path + AEnvironmentItem.Value1,
              fmCreate);
            try
               fileStream.WriteBuffer('abc', 3);
            finally // wrap up
               fileStream.Free;
            end; // try/finally
         end;
      3:
         begin
            try
               if AExamTcpClient.CommandGetEQFile(AEnvironmentItem.Value1,
                 memStream) = crOk then
               begin
                  memStream.SaveToFile(path + AEnvironmentItem.Value3);
               end
               else
               begin
                  // raise ;
               end;
            finally
               memStream.Free;
            end;
         end;
   end; // case
end;

procedure TfrmConverttoRTF.OldGradeInfoStreamToNew(stream: TMemoryStream;
  chr: Char);
var
   strList: TStringList;
   i: Integer;
   function InsertStr(str: string): string;
   var
      j: Integer;
      head, tail: PChar;
      tempstr: string;
      len: Integer;
   begin
      len := Length(str);
      SetLength(str, len + 1);
      head := @(str[len]);
      tail := @(str[len + 1]);
      j := 0;
      while True do
      begin
         if head^ = chr then
            j := j + 1;
         tail^ := head^;
         tail := tail - 1;
         head := head - 1;
         if j = 2 then
         begin
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
      for i := 0 to strList.count - 1 do
         strList[i] := InsertStr(strList[i]);
      stream.Clear;
      strList.SaveToStream(stream);
   finally
      strList.Free;
   end;
end;

end.
