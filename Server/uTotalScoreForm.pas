unit uTotalScoreForm;

interface

uses
   Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
   Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Winapi.ShlObj, cxShellCommon, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxContainer,
   cxEdit, cxStyles, cxCustomData, cxFilter, cxData, cxDataStorage, cxNavigator, Data.DB, cxDBData, Vcl.StdCtrls, cxGridLevel, cxGridCustomTableView,
   cxGridTableView, cxGridDBTableView, cxClasses, cxGridCustomView, cxGrid, cxLabel, cxTextEdit, cxMaskEdit, cxDropDownEdit, cxShellComboBox, Datasnap.DBClient,
  dxSkinsCore, dxSkinsDefaultPainters, dxSkinscxPCPainter;

type
   TTotalScoreForm = class(TForm)
      redt1: TRichEdit;
      scbTotalDir: TcxShellComboBox;
      lst1: TListBox;
      cxLabel10: TcxLabel;
      cxGrid2: TcxGrid;
      tvSource: TcxGridDBTableView;
      clmnSourceExamineeNo: TcxGridDBColumn;
      clmnSourceExamineeName: TcxGridDBColumn;
      clmnSourceIP: TcxGridDBColumn;
      clmnSourcePort: TcxGridDBColumn;
      clmnSourceStatus: TcxGridDBColumn;
      clmnSourceRemainTime: TcxGridDBColumn;
      clmnSourceTimeStamp: TcxGridDBColumn;
      cxGrid1Level1: TcxGridLevel;
      btnTotals: TButton;
      procedure btnTotalsClick(Sender: TObject);
   private
      procedure UpdateTotalScore(aFolder: TfileName; aFileList: TStrings; ATotalFileName: TfileName);
      function GetFileList(mPath: TfileName): TStrings;
      procedure CreateTotalReport(cdsTotal: TClientDataSet);
      { Private declarations }
   public
      { Public declarations }
   end;

var
   TotalScoreForm: TTotalScoreForm;

implementation

uses
   System.IOUtils, commons, Data.Win.ADODB, Datasnap.Provider, DataFieldConst, DataUtils;

{$R *.dfm}

procedure TTotalScoreForm.btnTotalsClick(Sender: TObject);
   var
      fileList: TStrings;
      TotalFileName: string;
   begin
    // TODO:
       // scbTotalDir.Text := 'D:\yjksmtxt\debug\test\totals';
           btnTotals.Enabled := False;
   try
      TotalFileName := scbTotalDir.Text + '\' + '汇总成绩库.mdb';
      if FileExists(TotalFileName) then
         if (not deletefilewithprompt(TotalFileName)) then
            Exit;
      fileList := GetFileList(scbTotalDir.Path + '\*.mdb');
      lst1.Items.Clear;
      lst1.Items.AddStrings(fileList);

      TFile.Copy(scbTotalDir.Path + '\' + fileList[0], TotalFileName);
      // fileList.Delete(0);
      UpdateTotalScore(scbTotalDir.Path, fileList, TotalFileName);
   finally
      fileList.Free;
      btnTotals.Enabled := True;
   end;
end;

procedure TTotalScoreForm.UpdateTotalScore(aFolder: TfileName; aFileList: TStrings; ATotalFileName: TfileName);
   var
      fileItem: string;
      connTotal: TADOConnection;
      qryTotal: TADOQuery;
      pvdTotal: TDataSetProvider;
      cdsTotal: TClientDataSet;
      cdsTotalWrite: TClientDataSet;
      dsTotal: TDataSource;

      connSource: TADOConnection;
      qrySource: TADOQuery;
      pvdSource: TDataSetProvider;
      cdsSource: TClientDataSet;

      procedure SoureToTotal(const cdsSource: TClientDataSet; var cdsTotal: TClientDataSet);
         begin
            with cdsTotal do
            begin
               Edit;
               FieldValues[DFNEI_EXAMINEENAME] := cdsSource.FieldValues[DFNEI_EXAMINEENAME];
               FieldValues[DFNEI_IP] := cdsSource.FieldValues[DFNEI_IP];
               FieldValues[DFNEI_PORT] := cdsSource.FieldValues[DFNEI_PORT];
               FieldValues[DFNEI_REMAINTIME] := cdsSource.FieldValues[DFNEI_REMAINTIME];
               FieldValues[DFNEI_STATUS] := cdsSource.FieldValues[DFNEI_STATUS];
               FieldValues[DFNEI_TIMESTAMP] := cdsSource.FieldValues[DFNEI_TIMESTAMP];
               (FieldByName(DFNEI_SCOREINFO) as TBlobField).Assign(cdsSource.FieldByName(DFNEI_SCOREINFO) as TBlobField);
               post;
            end;
         end;

   begin
      try
         connTotal := DataUtils.GetMdbConn(ATotalFileName, 'share exclusive');
         qryTotal := GetMdbAdoQuery(connTotal);
         qryTotal.SQL.Add('delete  from 考生信息 where true');
         qryTotal.ExecSQL();
         pvdTotal := DataUtils.GetMdbProvider(qryTotal);
         cdsTotal := GetMdbCDS(pvdTotal, 'select * from 考生信息');
         cdsTotalWrite := GetMdbCDS(pvdTotal, 'select * from 考生信息');
         cdsTotal.Active := True;
         DecryptExamineeInfoCDS(cdsTotal);
         cdsTotal.IndexFieldNames := DFNEI_EXAMINEEID;
         dsTotal := TDataSource.Create(nil);
         dsTotal.DataSet := cdsTotal;
         tvSource.DataController.DataSource := dsTotal;

         for fileItem in aFileList do
         begin
            try
               connSource := DataUtils.GetMdbConn(aFolder + '\' + fileItem, 'share deny write');
               qrySource := GetMdbAdoQuery(connSource);
               pvdSource := DataUtils.GetMdbProvider(qrySource);
               cdsSource := GetMdbCDS(pvdSource, 'select * from 考生信息');
               cdsSource.Active := True;
               DecryptExamineeInfoCDS(cdsSource);
               cdsSource.IndexFieldNames := DFNEI_EXAMINEEID;

               with cdsSource do
               begin
                  first;
                  while not eof do
                  begin
                     Application.ProcessMessages;
                     if cdsTotal.Locate(DFNEI_EXAMINEEID, cdsSource.FieldValues[DFNEI_EXAMINEEID], [loCaseInsensitive]) then
                     begin
                        // 更新数据
                        if cdsSource.FieldValues[DFNEI_TIMESTAMP] > cdsTotal.FieldValues[DFNEI_TIMESTAMP] then
                        begin
                           SoureToTotal(cdsSource, cdsTotal);
                        end;
                     end
                     else
                     begin // 添加新数据
                        cdsTotal.AppendRecord([FieldValues[DFNEI_EXAMINEEID]]);
                        SoureToTotal(cdsSource, cdsTotal);
                     end;
                     next;
                  end;
               end;
            finally
               FreeAndNil(connSource);
               FreeAndNil(qrySource);
               FreeAndNil(pvdSource);
               FreeAndNil(cdsSource);
            end;
         end;
         EncryptExamineeInfoCDS(cdsTotal, cdsTotalWrite);

         if cdsTotalWrite.ApplyUpdates(0) = 0 then
         begin
            Application.MessageBox('汇总成功', '提示');
            CreateTotalReport(cdsTotal);
         end
         else
         begin
            Application.MessageBox('汇总失败', '错误');
         end;
      finally
         FreeAndNil(connTotal);
         FreeAndNil(qryTotal);
         FreeAndNil(pvdTotal);
         FreeAndNil(cdsTotal);
         FreeAndNil(cdsTotalWrite);
         FreeAndNil(dsTotal);
      end;
   end;

/// <summary>
/// 获取目录中文件列表
/// 只获取单层目录，不搜索子目录
/// </summary>
/// <param name="mPath">需搜索的目录及文件通配符，如 .\test\*.mdb </param>
/// <returns>返回匹配的文件列表，结果保存在TStringList中</returns>
function TTotalScoreForm.GetFileList(mPath: TfileName): TStrings;
   var
      vSearchRec: TSearchRec;
      K: integer;
      attr: integer;
      fileList: TStringList;
   begin
      attr := faAnyFile;
      fileList := TStringList.Create();
      if FindFirst(mPath, attr, vSearchRec) = 0 then
      begin
         repeat
            if (vSearchRec.attr and attr) = vSearchRec.attr then
            begin
               fileList.Add(vSearchRec.Name);
            end;
         until FindNext(vSearchRec) <> 0;
         FindClose(vSearchRec);
      end;
      Result := fileList;
   end;

procedure TTotalScoreForm.CreateTotalReport(cdsTotal: TClientDataSet);
   begin
      // var
      // ds :TfrxDBDataset;
      // frxRep :TfrxReport;
      // cdsTemp :TClientDataSet;
      // begin
      // frxRep := TfrxReport.Create(Self);//.DesignCreate(Self,0);
      // ds := TfrxDBDataset.Create(nil);
      // cdsTemp := GetUnnormalExamineeInfoCDS(cdstotal);
      //
      // try
      // ds.Name := 'frxds';
      // //ds.UserName := 'frxds';
      // ds.DataSet := cdstemp;
      // frxRep.LoadFromFile('schooltotalrecord.fr3',true);
      // frxRep.DataSets.Add(ds);
      // if (frxRep.PrepareReport) then
      // frxRep.ShowPreparedReport;
      /// /    frxReport1.ShowReport();
      // finally
      // FreeAndNil(frxrep);
      // FreeAndNil(ds);
      // FreeAndNil(cdsTemp);
      // end;

   end;

end.
