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
  cxMaskEdit, cxDropDownEdit, cxShellComboBox;

type
   TfrmEQBUseInfo = class(TForm)
      grdSelectTableLevel1 : TcxGridLevel;
      grdSelectTable : TcxGrid;
      btnExport : TcxButton;
      grdSelectTableDBTableView1 : TcxGridDBTableView;
      grdSelectTableDBTableView1DBColumn : TcxGridDBColumn;
      grdSelectTableDBTableView1DBColumn1 : TcxGridDBColumn;
      grdSelectTableDBTableView1DBColumn2 : TcxGridDBColumn;
      grdSelectTableDBTableView1DBColumn3 : TcxGridDBColumn;
      grdSelectTableDBTableView1DBColumn4 : TcxGridDBColumn;
      grdSelectTableDBTableView1WIN : TcxGridDBColumn;
      grdSelectTableDBTableView1Word : TcxGridDBColumn;
      grdSelectTableDBTableView1Excel : TcxGridDBColumn;
      grdSelectTableDBTableView1Ppt : TcxGridDBColumn;
      dsStUseInfo : TDataSource;
    cbbDataFolder: TcxShellComboBox;
      procedure FormCreate(Sender : TObject);
      procedure btnExportClick(Sender : TObject);
      private

         { Private declarations }

      public
         procedure doExport;
         { Public declarations }
   end;

var
   frmEQBUseInfo : TfrmEQBUseInfo;

implementation

uses uFnMt, uDmSetQuestion, Commons,AccessHelper,examglobal;
{$R *.dfm}

procedure TfrmEQBUseInfo.btnExportClick(Sender : TObject);
   begin
      doExport;
   end;

procedure TfrmEQBUseInfo.FormCreate(Sender : TObject);
   begin
      if not dmSetQuestion.stSelect.Active then
         dmSetQuestion.stSelect.Active := true;
      cbbDataFolder.Text:= ExtractFilePath(application.ExeName);
   end;

procedure TfrmEQBUseInfo.doExport();
   var
      StkUseInfo             : TStringListArray;
      connSource, connTarget : TADOConnection;
      mdbFile,pwd:string;
   begin
      StkUseInfo := GetCurrentStkUseInfo();
      connSource := dmSetQuestion.stkConn;
      mdbfile:=IncludeTrailingPathDelimiter(cbbDataFolder.text)+StkUseInfo[7].DelimitedText+'.mdb';
      pwd:= decryptStr(SYSDBPWD);
      if FileExists(mdbFile) then
      begin
         Application.MessageBox('文件已存在！','提示');
         exit;
      end;

      TaccessHelper.CreateSysQuestionBase(mdbFile,pwd);
      connTarget :=TAccessHelper.GetMdbConnection(mdbFile,pwd);
      //connTarget := GetExportDBconn();
      try
         ExportTestQuestionsToDB(connSource, connTarget, StkUseInfo, SINGLESELECT_MODEL);
         ExportTestQuestionsToDB(connSource, connTarget, StkUseInfo, MULTISELECT_MODEL);
         ExportTestQuestionsToDB(connSource, connTarget, StkUseInfo, TYPE_MODEL);
         ExportTestQuestionsToDB(connSource, connTarget, StkUseInfo, WINDOWS_MODEL);
         ExportTestQuestionsToDB(connSource, connTarget, StkUseInfo, WORD_MODEL);
         ExportTestQuestionsToDB(connSource, connTarget, StkUseInfo, EXCEL_MODEL);
         ExportTestQuestionsToDB(connSource, connTarget, StkUseInfo, POWERPOINT_MODEL);

         ExportSysConfigToDB( connSource, connTarget);
      finally
         connTarget.Free;
      end;
   end;


end.
