unit ufrmScoreReceive;

interface

uses
   Windows,
   Messages,
   SysUtils,
   Variants,
   Classes,
   Graphics,
   Controls,
   Forms,
   Dialogs,
   cxLookAndFeelPainters,
   cxLabel,
   cxControls,
   cxContainer,
   cxEdit,
   cxTextEdit,
   cxMaskEdit,
   cxButtonEdit,
   StdCtrls,
   cxButtons,
   ExtCtrls,
   Menus,
   dxSkinsCore,
   dxSkinsDefaultPainters,
   DBClient,
   DB,
   dxSkinBlack,
   dxSkinBlue,
   dxSkinCaramel,
   dxSkinCoffee,
   dxSkinDarkRoom,
   dxSkinDarkSide,
   dxSkinFoggy,
   dxSkinGlassOceans,
   dxSkiniMaginary,
   dxSkinLilian,
   dxSkinLiquidSky,
   dxSkinLondonLiquidSky,
   dxSkinMcSkin,
   dxSkinMoneyTwins,
   dxSkinOffice2007Black,
   dxSkinOffice2007Blue,
   dxSkinOffice2007Green,
   dxSkinOffice2007Pink,
   dxSkinOffice2007Silver,
   dxSkinPumpkin,
   dxSkinSeven,
   dxSkinSharp,
   dxSkinSilver,
   dxSkinSpringTime,
   dxSkinStardust,
   dxSkinSummer2008,
   dxSkinValentine,
   dxSkinXmas2008Blue,
   cxGraphics,
   cxLookAndFeels,
   dxSkinOffice2010Black,
   dxSkinOffice2010Blue,
   dxSkinOffice2010Silver,
   JvExStdCtrls,
   JvRichEdit;

type
   TfrmScoreReceive = class(TForm)
      btnScore: TcxButton;
      edtSource: TcxButtonEdit;
      cxLabel1: TcxLabel;
      OpenDialog1: TOpenDialog;
      edtInsertNum: TcxTextEdit;
      edtUpdateNum: TcxTextEdit;
      cxLabel2: TcxLabel;
      cxLabel3: TcxLabel;
      Timer1: TTimer;
      edtTime: TcxTextEdit;
      edtRecno: TcxTextEdit;
      cxLabel4: TcxLabel;
      lbError: TListBox;
      btnExportErrorRecord: TcxButton;
      procedure Timer1Timer(Sender: TObject);
      procedure edtSourceClick(Sender: TObject);
      procedure btnScoreClick(Sender: TObject);
      procedure btnExportErrorRecordClick(Sender: TObject);
   private
      // procedure DecryptExamineeInfoCDS(cds: TClientDataSet);
      function GetScoreValue(const scoreStream: TMemoryStream): Integer;
      function ModifyStream(Stream: TStream): TStream;
      { Private declarations }
   public
      { Public declarations }
   end;

var
   frmScoreReceive: TfrmScoreReceive;

implementation

uses udmMain,
   uPubFn,
   DataFieldConst,
   Commons,
   compress,
   ScoreIni,
   datautils,
   examglobal;

{$R *.dfm}

procedure TfrmScoreReceive.btnExportErrorRecordClick(Sender: TObject);
var
   filename: string;
begin
   filename := IncludeTrailingPathDelimiter(ExtractFilePath(edtSource.Text)) + '接收错误记录.txt';
   lbError.Items.SaveToFile(filename);
   Application.MessageBox(pwidechar('已将错误记录保存到文件：' + eol + filename), '提示');
end;

procedure TfrmScoreReceive.btnScoreClick(Sender: TObject);
var
   scoreStream, modifiedScore: TMemoryStream;
   score: Integer;
   currentID: string;
   function myStrToint(const str: string): Integer;
   begin
      if str = '' then
         begin
            result := 0;
            Exit;
         end;
      result := StrToInt(str);
   end;
   procedure SoureToTotal(const cdsSource: TClientDataSet; var cdsTotal: TClientDataSet; const score: Integer);
   // ;const scoreStream:TMemoryStream);
   begin
      with cdsTotal do
         begin
            Edit;
            FieldValues[DFNEI_EXAMINEENAME] := cdsSource.FieldValues[DFNEI_EXAMINEENAME];
            FieldValues[DFNEI_EXAMINEESEX] := cdsSource.FieldValues[DFNEI_EXAMINEESEX];
            FieldValues[DFNEI_IP] := cdsSource.FieldValues[DFNEI_IP];
            FieldValues[DFNEI_PORT] := cdsSource.FieldValues[DFNEI_PORT];
            { TODO : need complete }
            FieldValues[DFNEI_STATUS] := myStrToint(cdsSource.FieldValues[DFNEI_STATUS]);
            FieldValues[DFNEI_REMAINTIME] := cdsSource.FieldValues[DFNEI_REMAINTIME];
            FieldValues[DFNEI_TIMESTAMP] := cdsSource.FieldValues[DFNEI_TIMESTAMP];
            FieldValues[DFNEI_SCORE] := score;
            // scoreStream.Position :=0;
            // (FieldByName(DFNEI_SCOREINFO) as TBlobField).LoadFromStream(scoreStream);
            (FieldByName(DFNEI_SCOREINFO) as TBlobField).Assign(cdsSource.FieldByName(DFNEI_SCOREINFO));
            post;
         end;
   end;

begin
   edtUpdateNum.Text := '0';
   edtInsertNum.Text := '0';
   edtTime.Text := '0';
   btnScore.Enabled := false;
   if edtSource.Text <> '' then
      begin
         // 清空当前数据集
         if dmMain.cdsSource.Active then
            begin
               dmMain.connSource.Connected := false;
               // dmMain.cdsSource.EmptyDataSet;
               dmMain.cdsSource.Active := false;
            end;
         // 设置源数据集
         if SetSourceConn(edtSource.Text) then
            begin
               // if not dmMain.cdsSource.Active  then   dmMain.cdsSource.active := True;
               // dmMain.cdsSource.IndexFieldNames := '';
               dmMain.dsSource.DataSet := nil;
               DecryptExamineeInfoCDS(dmMain.cdsSource, true);
               // dmMain.cdsSource.IndexFieldNames := DFNEI_EXAMINEEID;
            end;
      end
   else
      Application.MessageBox('上报库路径为空', '错误');
   // 打开汇总成绩库
   dmMain.cdsScore.Active := false;
   dmMain.dsScore.DataSet := nil;
   dmMain.cdsScore.Active := true;
   dmMain.cdsScore.IndexFieldNames := DFNEI_EXAMINEEID;
   Timer1.Enabled := true;
   scoreStream := TMemoryStream.Create;
   try
      with dmMain.cdsSource do
         begin
            first;
            while not eof do
               begin
                  edtRecno.Text := inttostr(dmMain.cdsSource.RecNo); // 显示当前源数据库记录号
                  Application.ProcessMessages;
                  scoreStream.Clear;
                  (FieldByName(DFNEI_SCOREINFO) as TBlobField).SaveToStream(scoreStream);
                  // UnCompressStream(scorestream);
                  currentID := VarToStr(dmMain.cdsSource.FieldValues[DFNEI_EXAMINEEID]);
                  try
                     try
                        modifiedScore := ModifyStream(scoreStream) as TMemoryStream;
                        if modifiedScore <> nil then
                           begin
                              score := GetScoreValue(modifiedScore);
                              FreeAndNil(modifiedScore);
                           end
                        else
                           score := GetScoreValue(scoreStream);
                     except
                        on E: Exception do
                           begin
                              lbError.Items.Add(currentID+'.dat');
                              next;
                              Continue;
                           end;
                     end;

                     if dmMain.cdsScore.Locate(DFNEI_EXAMINEEID, dmMain.cdsSource.FieldValues[DFNEI_EXAMINEEID], [loCaseInsensitive]) then
                        begin
                           // 更新数据
                           if score > dmMain.cdsScore.FieldByName(DFNEI_SCORE).AsInteger then
                              begin
                                 SoureToTotal(dmMain.cdsSource, dmMain.cdsScore, score); // ,scoreStream);
                                 edtUpdateNum.Text := inttostr(StrToInt(edtUpdateNum.Text) + 1); // 显示更新记录数
                              end;
                        end
                     else
                        begin // 添加新数据
                           dmMain.cdsScore.AppendRecord([FieldValues[DFNEI_EXAMINEEID]]);
                           SoureToTotal(dmMain.cdsSource, dmMain.cdsScore, score); // ,scoreStream);
                           edtInsertNum.Text := inttostr(StrToInt(edtInsertNum.Text) + 1); // 显示添加记录数
                        end;

                  except
                     on E: Exception do
                        begin
                           Application.MessageBox(pwidechar(currentID), 'error');
                        end;
                  end;
                  next;

               end;

            if dmMain.cdsScore.ApplyUpdates(0) = 0 then
               begin
                  Timer1.Enabled := false;
                  Application.MessageBox('update complete', 'info')
               end
            else
               begin
                  Timer1.Enabled := false;
                  Application.MessageBox('update error', 'error');
               end;
         end;
   finally
      scoreStream.Free;
      btnScore.Enabled := true;
   end;
end;

procedure TfrmScoreReceive.edtSourceClick(Sender: TObject);
begin
   if OpenDialog1.Execute then
      edtSource.Text := OpenDialog1.filename
   else
      edtSource.Text := '';
end;

procedure TfrmScoreReceive.Timer1Timer(Sender: TObject);
begin
   edtTime.Text := inttostr(StrToInt(edtTime.Text) + 1);
end;

function TfrmScoreReceive.GetScoreValue(const scoreStream: TMemoryStream): Integer;
var
   ScoreIni: TScoreIni;
begin
   ScoreIni := TScoreIni.Create;
   try
      scoreStream.Position := 0;
      ScoreIni.LoadFormStream(scoreStream);
      result := ScoreIni.GetScoreValue;
   finally
      ScoreIni.Free;
   end;
end;

function TfrmScoreReceive.ModifyStream(Stream: TStream): TStream;
var
   Size: Integer;
   Buffer: TBytes;
   rs: Integer;
   i: Integer;
begin
   result := nil;

   Size := Stream.Size;
   if Size = 0 then
      Exit;

   Stream.Position := 0;
   SetLength(Buffer, Size);
   Stream.Read(Buffer, 0, Size);

   if Buffer[17] = byte(#0) then
      begin
         for i := 17 to 35 do
            begin
               if Buffer[i] = byte(#0) then
                  Buffer[i] := $2C;
            end;
         result := TBytesStream.Create(Buffer);
      end;
end;

end.
