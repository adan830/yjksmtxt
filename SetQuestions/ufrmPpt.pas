unit ufrmPpt;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ufrmBase, cxLookAndFeelPainters, cxGraphics, cxCustomData,
  cxStyles, cxTL, cxInplaceContainer, cxMaskEdit, cxDropDownEdit,
  cxLookupEdit, cxDBLookupEdit, cxDBLookupComboBox, cxGroupBox, cxLabel,
  cxTextEdit, StdCtrls, cxButtons, cxControls, cxContainer, cxEdit, cxMemo,
  ExtCtrls, dxDockControl, dxDockPanel, ufraTree, ComCtrls,
  ShlObj, cxShellCommon, cxShellComboBox, cxButtonEdit,
  cxEditRepositoryItems, cxFilter, cxData, cxDataStorage, cxClasses,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView, cxGridLevel,
  cxGrid, cxGridCardView, DB, ADODB,ugrade, Menus, dxSkinsCore, dxSkinsDefaultPainters, dxSkinsdxDockControlPainter, dxSkinscxPCPainter,
  cxCheckGroup, Commons, JvExStdCtrls, JvRichEdit, DataFieldConst, tq,
  cxLookAndFeels, dxSkinBlack, dxSkinBlue, dxSkinBlueprint, dxSkinCaramel,
  dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide, dxSkinDevExpressDarkStyle,
  dxSkinDevExpressStyle, dxSkinFoggy, dxSkinGlassOceans, dxSkinHighContrast,
  dxSkiniMaginary, dxSkinLilian, dxSkinLiquidSky, dxSkinLondonLiquidSky,
  dxSkinMcSkin, dxSkinMetropolis, dxSkinMetropolisDark, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver, dxSkinOffice2013DarkGray,
  dxSkinOffice2013LightGray, dxSkinOffice2013White, dxSkinPumpkin, dxSkinSeven,
  dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus, dxSkinSilver,
  dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008, dxSkinTheAsphaltWorld,
  dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint, dxSkinXmas2008Blue,
  cxNavigator, cxPC;

type
  TfrmPpt = class(TfrmBase)
    bedtAnswerFile: TcxButtonEdit;
    btnTest: TcxButton;
    cxLabel2: TcxLabel;
    cxLabel3: TcxLabel;
    OpenDialog1: TOpenDialog;
    btnFileExport: TcxButton;
    btnFileImport: TcxButton;
    edtEQContent: TJvRichEdit;
    grdGradeInfo: TcxGrid;
    tvGradeInfo: TcxGridTableView;
    tvGradeInfoColumn1: TcxGridColumn;
    tvGradeInfoColumn2: TcxGridColumn;
    tvGradeInfoColumn3: TcxGridColumn;
    tvGradeInfoColumn4: TcxGridColumn;
    tvGradeInfoColumn5: TcxGridColumn;
    tvGradeInfoColumn6: TcxGridColumn;
    tvGradeInfoColumn7: TcxGridColumn;
    tvGradeInfoColumn8: TcxGridColumn;
    grdGradeInfoLevel1: TcxGridLevel;
    cxgrpbx1: TcxGroupBox;
    procedure bedtAnswerFilePropertiesButtonClick(Sender: TObject;
            AButtonIndex: Integer);
    procedure btnTestClick(Sender: TObject);
    procedure btnFileExportClick(Sender: TObject);
    procedure btnFileImportClick(Sender: TObject);
    procedure tvGradeInfoColumn8PropertiesButtonClick(Sender: TObject; AButtonIndex: Integer);
  private
    procedure SaveOperateTQ(const RecID: string; const AGradeInfoDelimiter: Char=',');

  protected
    procedure doSave(RecID: String); override;
    procedure doModify(RecID: String); override;
    procedure doBrowse(RecID: String); override;
    procedure SetControlState(aAction: TFormAction); override;

    function  doFileExport(ATQ: TTQ):string;      //导出考试文件
    procedure InitFormData(aMode: TFormMode); override;
    procedure FillGradeInfoStrings(strings:TStringList); 
  public
   // PptGrade: TPptGrade;
    class procedure FormShowMode(const AModuleFileName:TFileName;aMode:TFormMode);

  end;

implementation

uses uDmSetQuestion, StrUtils, uDispAnswer,shellapi,uFnMt, ExamGlobal, DataUtils, ExamResourceStrings;


{$R *.dfm}
{
*********************************** TfrmWord ***********************************
}
procedure TfrmPpt.bedtAnswerFilePropertiesButtonClick(Sender: TObject;
        AButtonIndex: Integer);
begin
  //Open the answer file,when clicked
  OpenDialog1.InitialDir:=extractFilePath(application.ExeName)+'database\Ppt文档\';
  OpenDialog1.Filter:=RSPptDocFilter;//'PowerPoint文档|*.ppt';
  if OpenDialog1.Execute then
  begin
    bedtAnswerfile.Text:=OpenDialog1.FileName;
    ShellExecute(
                  handle,	// handle to parent window
                  'open',	// pointer to string that specifies operation to perform
                  pchar(ExtractFileName(OpenDialog1.FileName)),	// pointer to filename or folder name string
                  '',	// pointer to string that specifies executable-file parameters
                  pchar(ExtractFilePath(OpenDialog1.FileName)),	// pointer to string that specifies default directory
                  SW_SHOWNORMAL 	// whether file is shown when opened
                 );
    btnTest.Enabled := True;
  end;
end;

procedure TfrmPpt.btnTestClick(Sender: TObject);
var
  GradeInfoStrings:TStringList;
  filename:string;
begin
  filename:=bedtAnswerFile.Text;
  GradeInfoStrings:= TStringList.Create;
  try
    GridToGradeInfoStrings(tvGradeInfo,GradeInfoStrings);
    FillGrades(ExtractFilePath(bedtAnswerFile.Text),ExtractFileName(bedtAnswerFile.Text),GradeInfoStrings,fmExamValue);
    TfrmDispAnswer.ShowForm(GradeInfoStrings);
  finally // wrap up
    GradeInfoStrings.Free;
  end;    // try/finally
end;

procedure TfrmPpt.btnFileExportClick(Sender: TObject);
begin
  doFileExport(FCurrentTQRecord);
end;   

procedure TfrmPpt.doModify(RecID: String);
begin
  inherited;

end;
procedure TfrmPpt.SaveOperateTQ(const RecID: string; const AGradeInfoDelimiter: Char=',');
var
  StrList:TStringList;
begin
   StrList:=TStringList.Create;
   try
      case  CurrentFormAction  of
         faModify,faAppend:begin
                         FCurrentTQRecord.Content.Clear;
                         edtEQContent.Lines.SaveToStream(FCurrentTQRecord.Content);
                          //GridToGradeInfoStrings(tvGradeInfo,StrList);
                          if application.MessageBox('是否保存评分信息','保存提示：',MB_YESNO)=IDYES then
                          begin
                            GridToGradeInfoStrings(tvGradeInfo,StrList,AGradeInfoDelimiter);
                            //FillGrades(ExtractFilePath(bedtAnswerFile.Text),ExtractFileName(bedtAnswerFile.Text),StrList,fmStandvalue);
                            FCurrentTQRecord.StAnswer.Clear;
                            StrList.SaveToStream(FCurrentTQRecord.StAnswer);
                            //必须保存后再更新，否则由于转换过程中字符串发生变化产生错误
                            SetupGradeInfoGrid(StrList,tvGradeInfo);
                          end;
                     end;
      end;
   finally
     strList.Free;
   end;
end;
procedure TfrmPpt.doSave(RecID: String);
//var
//  fieldValues:Variant;
//  StrList:TStringList;
begin
   SaveOperateTQ(RecID);
   inherited;
//   setSt:=TADODataSet.Create(self);
//   StrList:=TStringList.Create;
//   setSt.Connection:=dmSetQuestion.stkConn;
//   with setSt do
//   try
//      case  CurrentFormAction  of
//         faModify,faAppend:
//         begin
//           CommandText:='select * from 试题 where st_no=:stno';
//           Parameters.ParamByName('stno').Value:=trim(edtStNo.Text);
//           active:=true;
//           if not isempty then
//           begin
//              edit;
//              FieldByName('st_lr').Assign(memost.Lines);
//              GridToGradeInfoStrings(tvGradeInfo,StrList);
//              FillGradeInfoStrings(StrList);
//              FieldByName('st_da1').Assign(StrList);
//              //必须保存后再更新，否则由于转换过程中字符串发生变化产生错误
//              SetupGradeInfoGrid(StrList,tvGradeInfo);
//              Post;
//           end;
//         end;
//      end;
//   finally
//     strList.Free;
//     setSt.Free;
//     //dmMain.stSt.Requery();
//   end;
end;

procedure TfrmPpt.doBrowse(RecID: String);
var
  GradeInfoStrings: TStringList;
begin
    inherited;
    GradeInfoStrings:=TStringList.Create;
    try
      edtEQContent.Lines.LoadFromStream(FCurrentTQRecord.Content);
      GradeInfoStrings.LoadFromStream(FCurrentTQRecord.StAnswer);
      SetupGradeInfoGrid(GradeInfoStrings,tvGradeInfo);
      edtEQContent.ReadOnly:=true;
    finally
      GradeInfoStrings.free;
    end;
end;

procedure TfrmPpt.SetControlState(aAction: TFormAction);
begin
  inherited;
  case aAction of
  faBrowse,
  faSave,
  faCancel:begin
  					  edtEQContent.ReadOnly := True;
              //bedtAnswerFile.Enabled := False;
              tvGradeInfo.OptionsData.Editing := False;
              //tvGradeInfo.OptionsView.Navigator := False;
              tvGradeInfo.OptionsSelection.CellSelect := false;
              tvGradeInfoColumn8.Options.ShowEditButtons := isebNever;
              btnFileImport.Enabled := False;
           end;
  faAppend,
  faModify:begin
   				    edtEQContent.ReadOnly := False;
              //bedtAnswerFile.Enabled := True; 
              tvGradeInfo.OptionsData.Editing := True;
              //tvGradeInfo.OptionsView.Navigator := True;
              tvGradeInfo.OptionsSelection.CellSelect := true;
              tvGradeInfoColumn8.Options.ShowEditButtons := isebAlways;
              btnFileImport.Enabled := True;
           end;
  end;
end;  

procedure TfrmPpt.tvGradeInfoColumn8PropertiesButtonClick(Sender: TObject; AButtonIndex: Integer);
var
  StrList:TStringList;
begin
  inherited;
  StrList:=TStringList.Create;
   try
      GridRowToGradeInfoStrings(tvGradeInfo,StrList,',');
      FillGrades(ExtractFilePath(bedtAnswerFile.Text),ExtractFileName(bedtAnswerFile.Text),StrList,fmStandValue);
      FillGridRowWithGradeInfo(StrList,tvGradeInfo,',');
   finally
      StrList.Free;
   end;
end;

function TfrmPpt.doFileExport(ATQ: TTQ):string;
var
  setTemp:TADODataset;
  strHj:string;
  environmentItem:TEnvironmentItem;
begin
//  if CurrentFormAction in [faModify,faAppend,faInsert] then
//  begin
    OpenDialog1.InitialDir:=extractFilePath(application.ExeName)+'database\Ppt文档\';
    OpenDialog1.FileName:=trim(edtStNo.Text)+'.pptx';
    OpenDialog1.Filter:=RSPptDocFilter;
    if OpenDialog1.Execute then
    begin
      ATQ.Environment.SaveToFile(OpenDialog1.FileName);
    end;
//  end;
end;

class procedure TfrmPpt.FormShowMode(const AModuleFileName:TFileName;aMode: TFormMode);
var
  frmPpt:TfrmPpt;
begin
  frmPpt:=TfrmPpt.Create(AModuleFileName,aMode);
  try
    frmPpt.ShowModal;
  finally // wrap up
    frmPpt.free;
  end;    // try/finally
end;

procedure TfrmPpt.InitFormData(aMode: TFormMode);
begin   
  tvGradeInfoColumn1.DataBinding.ValueTypeClass := TcxIntegerValueType;
  tvGradeInfoColumn2.DataBinding.ValueTypeClass := TcxIntegerValueType;
  tvGradeInfoColumn3.DataBinding.ValueTypeClass := TcxStringValueType;
  tvGradeInfoColumn4.DataBinding.ValueTypeClass := TcxStringValueType;
  tvGradeInfoColumn5.DataBinding.ValueTypeClass := TcxStringValueType;
  tvGradeInfoColumn6.DataBinding.ValueTypeClass := TcxIntegerValueType;
  inherited;
end;

procedure TfrmPpt.FillGradeInfoStrings(strings:TStringList);
var
  I: Integer;
  GradeInfo:TGradeInfo;
begin
  inherited;
//  if not Assigned(PptGrade) then
//    PptGrade:=TPptGrade.Create(nil);
//  try
//    PptGrade.FileName:=bedtAnswerFile.Text;
//    with strings do
//    begin
//       for I := 0 to Count - 1 do    // Iterate
//      begin
//        StrToGradeInfo(strings[i],GradeInfo);
//        //调用 WordGrade模块，获得评分参数值
//          PptGrade.FillKeyGradeInfo(gradeinfo,-1);
//          strings[i] := GradeInfoToStr(GradeInfo)
//      end;    // for
//    end;    // with
//  finally
//    freeandnil(PptGrade);
//  end;    // try/finally
end;

procedure TfrmPpt.btnFileImportClick(Sender: TObject);
begin
  if CurrentFormAction in [faModify,faAppend,faInsert] then
  begin
    doFileImport(FCurrentTQRecord, RSPptDocFilter );
  end;
end;

end.













