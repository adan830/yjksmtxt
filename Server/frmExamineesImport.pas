unit frmExamineesImport;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,uDmServer, cxEdit, DB, cxGridLevel, cxClasses, cxControls,
  cxGridCustomView, cxGridCustomTableView, cxGridDBTableView, cxGrid, StdCtrls, DBClient, cxContainer,
  ADODB, cxButtons, cxLabel, cxGridTableView, cxStyles, dxSkinsCore, dxSkinBlack, dxSkinBlue, dxSkinCaramel,
  dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide, dxSkinFoggy, dxSkinGlassOceans, dxSkiniMaginary, dxSkinLilian,
  dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMoneyTwins, dxSkinOffice2007Black, dxSkinOffice2007Blue,
  dxSkinOffice2007Green, dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinPumpkin, dxSkinSeven, dxSkinSharp,
  dxSkinSilver, dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008, dxSkinsDefaultPainters, dxSkinValentine,
  dxSkinXmas2008Blue, dxSkinscxPCPainter, cxCustomData, cxGraphics, cxFilter, cxData, cxDataStorage, cxDBData, Menus,
  cxLookAndFeelPainters, cxLookAndFeels, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver, dxSkinBlueprint,
  dxSkinDevExpressDarkStyle, dxSkinDevExpressStyle, dxSkinHighContrast,
  dxSkinMetropolis, dxSkinMetropolisDark, dxSkinOffice2013DarkGray,
  dxSkinOffice2013LightGray, dxSkinOffice2013White, dxSkinSevenClassic,
  dxSkinSharpPlus, dxSkinTheAsphaltWorld, dxSkinVS2010, dxSkinWhiteprint,
  cxNavigator;

type
  TExamineesImport = class(TForm)
    tvExaminees: TcxGridDBTableView;
    cxgrdlvlGrid1Level1: TcxGridLevel;
    grdExaminees: TcxGrid;
    dsCDSExaminees: TDataSource;
    cxGrid1: TcxGrid;
    tvCDSTemp: TcxGridDBTableView;
    cxgrdlvl1: TcxGridLevel;
    cdsTemp: TClientDataSet;
    dsCDSTemp: TDataSource;
    setExamineeBase: TADODataSet;
    wdstrngfldExamineeBaseExamineeID: TWideStringField;
    wdstrngfldExamineeBaseExamineeName: TWideStringField;
    wdstrngfldExamineeBaseStatus: TWideStringField;
    strngfldExamineeBaseDecryptedID: TStringField;
    strngfldExamineeBaseDecryptedName: TStringField;
    strngfldExamineeBaseDecryptedStatus: TStringField;
    strngfldExamineeBaseDecryptedRemainTime: TStringField;
    strngfldExamineeBaseDecryptedTimeStamp: TStringField;
    wdstrngfldExamineeBaseRemainTime: TWideStringField;
    clmnExamineesDecryptedID: TcxGridDBColumn;
    clmnExamineesDecryptedName: TcxGridDBColumn;
    clmnExamineesDecryptedStatus: TcxGridDBColumn;
    clmnExamineesDecryptedRemainTime: TcxGridDBColumn;
    clmnExamineesDecryptedTimeStamp: TcxGridDBColumn;
    wdstrngfldExamineeBaseTimeStamp: TWideStringField;
    btnAdd: TcxButton;
    btnDelete: TcxButton;
    btnSave: TcxButton;
    lbl1: TcxLabel;
    lbl2: TcxLabel;
    btnExit: TcxButton;
    procedure btnAddClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure setExamineeBaseCalcFields(DataSet: TDataSet);
    procedure tvCDSTempDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure tvCDSTempDragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
    procedure btnExitClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure tvExamineesDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure tvExamineesDragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
  private
    function IsSelected(ACDSTemp: TclientDataSet; AExamineeNo: string): Boolean;
    procedure AddSelectedRecords(ASourceView: TcxCustomGridTableView);
    procedure AddRecord(ARecord: TcxCustomGridRecord);
    procedure DeleteSelectedRecords(ASourceView: TcxCustomGridTableView);
  public
    class procedure FormShow();
  end;

implementation

uses
  NetGlobal, uFormMainServer, DataUtils, DataFieldConst, Commons, ServerGlobal, 
  cxGridDBDataDefinitions;

{$R *.dfm}

procedure TExamineesImport.btnAddClick(Sender: TObject);
var
   i:Integer;
begin
   btnAdd.Enabled := False;
   with tvExaminees do begin
      try
            for i := 0 to tvExaminees.Controller.SelectedRecordCount-1 do begin
               if not IsSelected(cdsTemp,tvExaminees.Controller.SelectedRecords[i].Values[0]) then begin
                  with tvExaminees.Controller.SelectedRecords[i] do
                  begin
                     cdsTemp.AppendRecord([VarToStr(Values[0]),VarToStr(Values[1]),VarToStr(Values[2])]);
                  end;
               end;
            end;
      finally
         Controller.ClearSelection;
         btnAdd.Enabled:=True;
      end;
   end;
   btnSave.Enabled := True;
end;

procedure TExamineesImport.btnDeleteClick(Sender: TObject);
begin
      tvCDSTemp.Controller.DeleteSelection;
end;

procedure TExamineesImport.btnExitClick(Sender: TObject);
begin
   Close;
end;

function TExamineesImport.IsSelected(ACDSTemp:TclientDataSet;AExamineeNo:string):Boolean;
begin
   Result:=ACDSTemp.Locate(DFNEI_EXAMINEEID,AExamineeNo,[]);
end;

procedure TExamineesImport.setExamineeBaseCalcFields(DataSet: TDataSet);
begin
  with DataSet do begin
    FieldValues[DFNEI_DECRYPTEDID] := DecryptStr(FieldByName(DFNEI_EXAMINEEID).AsString);
    FieldValues[DFNEI_DECRYPTEDNAME] := DecryptStr(FieldByName(DFNEI_EXAMINEENAME).AsString);
    FieldValues[DFNEI_DECRYPTEDSTATUS] := DecryptStr(FieldByName(DFNEI_STATUS).AsString);
    FieldValues[DFNEI_DECRYPTEDREMAINTIME] := DecryptStr(FieldByName(DFNEI_REMAINTIME).AsString);
    FieldValues[DFNEI_DECRYPTEDTIMESTAMP] := DecryptStr(FieldByName(DFNEI_TIMESTAMP).AsString);
  end;
end;

procedure TExamineesImport.tvCDSTempDragDrop(Sender, Source: TObject; X, Y: Integer);
var
  AControl: TControl;
begin
  AControl := TDragControlObject(Source).Control;
  if AControl is TcxGridSite then
    AddSelectedRecords(TcxCustomGridTableView(TcxGridSite(AControl).GridView));end;
//==============================================================================
// 将拖动记录添加到表中
//==============================================================================
procedure TExamineesImport.AddSelectedRecords(ASourceView: TcxCustomGridTableView);
var
  I: Integer;
begin
    if ASourceView.OptionsSelection.MultiSelect then
         for I := 0 to ASourceView.Controller.SelectedRecordCount - 1 do
            AddRecord(ASourceView.Controller.SelectedRecords[I])
    else
       AddRecord(ASourceView.Controller.FocusedRecord);
end;

procedure TExamineesImport.AddRecord(ARecord: TcxCustomGridRecord);
begin
    if ARecord is TcxGridGroupRow then      Exit;
    if not IsSelected(cdsTemp,ARecord.Values[0]) then
      cdsTemp.AppendRecord([ARecord.DisplayTexts[0],ARecord.DisplayTexts[1],ARecord.DisplayTexts[2]]);
end;

procedure TExamineesImport.tvCDSTempDragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
begin
   Accept := False;
  if Source is TcxDragControlObject then
    with TcxDragControlObject(Source) do
      if Control is TcxGridSite then
        with TcxGridSite(Control) do
          Accept := (GridView.PatternGridView = tvExaminees) ;
end;

procedure TExamineesImport.tvExamineesDragDrop(Sender, Source: TObject; X, Y: Integer);
var
  AControl: TControl;
begin
   AControl := TDragControlObject(Source).Control;
   if AControl is TcxGridSite then
      DeleteSelectedRecords(TcxCustomGridTableView(TcxGridSite(AControl).GridView));
end;

//==============================================================================
// 将拖动记录从列表中删除
//==============================================================================
procedure TExamineesImport.DeleteSelectedRecords(ASourceView: TcxCustomGridTableView);
begin
   ASourceView.Controller.DeleteSelection;
end;

procedure TExamineesImport.tvExamineesDragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
begin
  Accept := False;
  if Source is TcxDragControlObject then
    with TcxDragControlObject(Source) do
      if Control is TcxGridSite then
        with TcxGridSite(Control) do
          Accept := (GridView.PatternGridView = tvcdstemp) ;
end;
//TODO: Check photo file if exist
procedure TExamineesImport.btnSaveClick(Sender: TObject);
var
   Examinee:PExaminee;
   procedure AddNewExaminee();
   begin
      with cdsTemp do begin
        New(Examinee);
        { TODO -ojp -ctest :
               test field value is null
               if field value is null ,can't convert variant to string ,so add vartostr }
        Examinee.ID := VarToStr(FieldValues[DFNEI_EXAMINEEID]);
        Examinee.Name := VarToStr(FieldValues[DFNEI_EXAMINEENAME]);
        Examinee.IP := '' ;
        Examinee.Port := 0 ;

        Examinee.TimeStamp := 0;
        Examinee.ScoreCompressedStream := nil;

        Examinee.Status := esNotLogined; //TExamineeStatus(vartoint(FieldValues['Status']));
        Examinee.RemainTime := TExamServerGlobal.GlobalStkRecordInfo.BaseConfig.ExamTime;
        if FileExists(examinee.ID+'.jpg') then
        Examinee.HasPhoto:=true
        else
          Examinee.HasPhoto:=false;
//        case AStatus of
//          esAllowReExam:  begin
//                    Examinee.Status := esNotLogined; //TExamineeStatus(vartoint(FieldValues['Status']));
//                    Examinee.RemainTime := CONSTEXAMINENATIONTIME;
//                end;
//          else begin
//                    Examinee.Status := TExamineeStatus(vartoint(FieldValues[DFNEI_STATUS]));
//                    Examinee.RemainTime := vartoint(FieldValues[DFNEI_REMAINTIME]);
//                end;
//        end;
        if not FormMainServer.ExamineesManager.Add(Examinee) then Dispose(Examinee);
      end;
   end;
begin
   btnSave.Enabled := False;
   with cdsTemp do
   begin
      First;
      while not Eof do
      begin
///   当考生状态为 esExamEnded 时，导入时，需确认，其它状态一律原样导入
///   导入后的考生，初始化状态全为esFirstLogin
            if (TExamineeStatus(vartoint(FieldValues[DFNEI_STATUS]))=esExamEnded) then begin
               if Application.MessageBox(PChar('考生：'+FieldByName(DFNEI_EXAMINEEID).AsString +'已完成了一次考试，是否重考？'),'请确认',MB_YESNO)=ID_YES then
               begin
                  AddNewExaminee();
               end;
            end else begin
               AddNewExaminee();
            end;
         Next;
      end;
   end;
   FormMainServer.Refreshdata;
   btnAdd.Enabled := True;
end;

procedure TExamineesImport.FormCreate(Sender: TObject);
begin
   cdsTemp := TClientDataSet.Create(self);
   cdsTemp.FieldDefs.Add(DFNEI_EXAMINEEID,ftString,11);
   cdsTemp.FieldDefs.Add(DFNEI_EXAMINEENAME,ftString,8);
//   cdsTemp.FieldDefs.Add('IP',ftString,15);
//   cdsTemp.FieldDefs.Add('Port',ftInteger);
   cdsTemp.FieldDefs.Add(DFNEI_STATUS,ftInteger);
   cdsTemp.FieldDefs.Add(DFNEI_REMAINTIME,ftInteger);
   //cdsTemp.FieldDefs.Add('TimeStamp',ftDateTime);
   //cdsTemp.FieldDefs.Add('ScoreInfo',ftBlob);
   cdsTemp.CreateDataSet;
   cdsTemp.Active:=True;
   dsCDSTemp.DataSet := cdsTemp;
   tvCDSTemp.DataController.CreateAllItems;
   tcxgriddbcolumn(tvCDSTemp.Columns[0]).Caption :='准考证号';
   tcxgriddbcolumn(tvCDSTemp.Columns[1]).Caption :='姓名';
   tcxgriddbcolumn(tvCDSTemp.Columns[2]).Caption :='状态';
   tcxgriddbcolumn(tvCDSTemp.Columns[3]).Caption :='剩余时间';
end;

class procedure TExamineesImport.FormShow();
var
   frm:TExamineesImport;
begin
  frm:=TExamineesImport.Create(nil);
  try
    frm.dsCDSExaminees.DataSet.Active :=True;
    frm.ShowModal;
    FormMainServer.ServerStatus := essExamineeSelected;
  finally
    frm.Free;
  end;
end;

end.
