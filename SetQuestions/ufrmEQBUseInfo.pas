unit ufrmEQBUseInfo;

interface

uses
   Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
   Dialogs, cxStyles, cxCustomData, cxGraphics, cxFilter, cxData,
   cxDataStorage, cxEdit, DB, cxDBData, cxGridLevel, cxClasses, cxControls,
   cxGridCustomView, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
   cxGrid, Menus, cxLookAndFeelPainters, StdCtrls, cxButtons, cxContainer,
   cxTextEdit, ADODB, cxBlobEdit, cxRichEdit, dxSkinsCore, dxSkinsDefaultPainters, dxSkinscxPCPainter,
   cxLookAndFeels, cxNavigator, Vcl.ComCtrls, Winapi.ShlObj, cxShellCommon,
   cxMaskEdit, cxDropDownEdit, cxShellComboBox, cxCheckBox;

type
   TfrmEQBUseInfo = class(TForm)
      grdSelectTableLevel1 : TcxGridLevel;
      grdSelectTable : TcxGrid;
      btnExport : TcxButton;
      grdSelectTableDBTableView1 : TcxGridDBTableView;
      grdSelectTableDBTableView1DBColumn : TcxGridDBColumn;
      grdSelectTableDBTableView1DBColumn1 : TcxGridDBColumn;
      dsStUseInfo : TDataSource;
      cbbDataFolder : TcxShellComboBox;
      procedure FormCreate(Sender : TObject);
      procedure btnExportClick(Sender : TObject);
      private
         procedure AppendClientDd(aConn: TADOConnection);

         { Private declarations }

      public
         procedure doExport;
         { Public declarations }
   end;

var
   frmEQBUseInfo : TfrmEQBUseInfo;

implementation

uses uFnMt, uDmSetQuestion, Commons, AccessHelper, examglobal;
{$R *.dfm}

procedure TfrmEQBUseInfo.btnExportClick(Sender : TObject);
   begin
      doExport;
   end;

procedure TfrmEQBUseInfo.FormCreate(Sender : TObject);
   begin
      if not dmSetQuestion.stSelect.Active then
         dmSetQuestion.stSelect.Active := true;
      cbbDataFolder.Text               := ExtractFilePath(application.ExeName);
   end;

procedure TfrmEQBUseInfo.doExport();
   var
      StkUseInfo             : TStringListArray;
      connSource, connTarget : TADOConnection;
      mdbpath, mdbFile, pwd  : string;
      rt                     : boolean;
   begin
      StkUseInfo := GetCurrentStkUseInfo();
      connSource := dmSetQuestion.stkConn;
      mdbpath    := IncludeTrailingPathDelimiter(cbbDataFolder.Text);
      mdbFile    := mdbpath + StkUseInfo[7].DelimitedText + '.mdb';
      pwd        := decryptStr(SYSDBPWD);
      if FileExists(mdbFile) then
      begin
         application.MessageBox('文件已存在！', '提示');
         exit;
      end;

      TaccessHelper.CreateSysQuestionBase(mdbFile, pwd);
      TaccessHelper.AddTrustedLocation(mdbpath);
      TaccessHelper.EncryptionBase(mdbFile, pwd);
      connTarget := TaccessHelper.GetMdbConnection(mdbFile, pwd);
      // connTarget := GetExportDBconn();
      try
         AppendClientDd(connTarget);
         ExportTestQuestionsToDB(connSource, connTarget, StkUseInfo, SINGLESELECT_MODEL);
         ExportTestQuestionsToDB(connSource, connTarget, StkUseInfo, MULTISELECT_MODEL);
         ExportTestQuestionsToDB(connSource, connTarget, StkUseInfo, TYPE_MODEL);
         ExportTestQuestionsToDB(connSource, connTarget, StkUseInfo, WINDOWS_MODEL);
         ExportTestQuestionsToDB(connSource, connTarget, StkUseInfo, WORD_MODEL);
         ExportTestQuestionsToDB(connSource, connTarget, StkUseInfo, EXCEL_MODEL);
         ExportTestQuestionsToDB(connSource, connTarget, StkUseInfo, POWERPOINT_MODEL);

         ExportSysConfigToDB(connSource, connTarget);
         application.MessageBox(PWideChar('题库成功导出至：'+EOL+mdbfile), '提示');
      finally
         connTarget.Free;
      end;

   end;

procedure TfrmEQBUseInfo.AppendClientDd(aConn: TADOConnection);
   var
      mdbpath, mdbFile, pwd : string;
      lStream:TMemoryStream;
   begin
      mdbpath := IncludeTrailingPathDelimiter(cbbDataFolder.Text);
      mdbFile := mdbpath + '考生题库.mdb';
      pwd     := decryptStr(CLIENTDBPWD);
      if FileExists(mdbFile) then
      begin
         application.MessageBox('文件已存在！', '提示');
         exit;
      end;

      TaccessHelper.CreateClientBase(mdbFile, pwd);
      TaccessHelper.EncryptionBase(mdbFile, pwd);
      lStream:=TMemoryStream.Create();
      try
       lStream.LoadFromFile(mdbFile);
      ClientDbFileImport(lstream,aConn);
      finally
        lStream.Free;
        DeleteFile(mdbFile);
      end;

   end;

end.
