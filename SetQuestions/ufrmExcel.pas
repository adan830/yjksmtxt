unit ufrmExcel;

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
  cxGrid, cxGridCardView, DB, ADODB,ugrade, Menus,
  cxCheckGroup, dxSkinsCore, dxSkinsDefaultPainters, dxSkinsdxDockControlPainter, dxSkinscxPCPainter, 
  Commons, JvExStdCtrls, JvRichEdit, DataFieldConst, tq, cxLookAndFeels,
  dxSkinBlack, dxSkinBlue, dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee,
  dxSkinDarkRoom, dxSkinDarkSide, dxSkinDevExpressDarkStyle,
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
  cxNavigator;

type
  TfrmExcel = class(TfrmBase)
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
    procedure bedtTestFilePropertiesButtonClick(Sender: TObject; AButtonIndex:
            Integer);
    procedure btnTestClick(Sender: TObject);
    procedure tlGradeInfoSelectionChanged(Sender: TObject);
    procedure btnFileExportClick(Sender: TObject);
    procedure btnFileImportClick(Sender: TObject);
    procedure tvGradeInfoColumn8PropertiesButtonClick(Sender: TObject; AButtonIndex: Integer);
  private
    procedure SaveOperateTQ(const RecID: string;const AGradeInfoDelimiter:Char=',');

  protected
    procedure doSave(RecID: String); override;
    procedure doModify(RecID: String); override;
    procedure doBrowse(RecID: String); override;
    procedure SetControlState(aAction: TFormAction); override;

    function  doFileExport(ATQ: TTQ):string;      //导出考试文件
    procedure InitFormData(aMode: TFormMode); override;
    procedure FillGradeInfoStrings(strings:TStringList); 
  public
    //ExcelGrade: TExcelGrade;
    class procedure FormShowMode(const AModuleFileName:TFileName;aMode:TFormMode);

  end;

implementation

uses uDmSetQuestion, StrUtils, uDispAnswer,shellapi,uFnMt, ExamGlobal, DataUtils, ExamResourceStrings;


{$R *.dfm}
{
*********************************** TfrmWord ***********************************
}
procedure TfrmExcel.bedtAnswerFilePropertiesButtonClick(Sender: TObject;
        AButtonIndex: Integer);
begin
    //Open the answer file,when clicked
    OpenDialog1.InitialDir:=extractFilePath(application.ExeName)+'database\Excel文档\';
    //OpenDialog1.FileName:=trim(edtStNo.Text)+'.xls';
    OpenDialog1.Filter:='Excel文档|*.xls';
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

procedure TfrmExcel.bedtTestFilePropertiesButtonClick(Sender: TObject;
        AButtonIndex: Integer);
begin
//  if CurrentFormAction in [faModify,faAppend,faInsert] then
//  begin
//    OpenDialog1.InitialDir:=dmMain.kspath;
//    OpenDialog1.Filter:='Word文档|*.doc';
//    OpenDialog1.Execute;
//    bedtTestFile.Text:=OpenDialog1.FileName;
//  end;
end;    
procedure TfrmExcel.btnTestClick(Sender: TObject);
var
  GradeInfoStrings:TStringList;
  filename:string;
begin
  filename:=bedtAnswerFile.Text;
  GradeInfoStrings:= TStringList.Create;
  try
    GridToGradeInfoStrings(tvGradeInfo,GradeInfoStrings,'~');
    FillGrades(ExtractFilePath(bedtAnswerFile.Text),ExtractFileName(bedtAnswerFile.Text),GradeInfoStrings,fmStandvalue);
    TfrmDispAnswer.ShowForm(GradeInfoStrings,'~');
  finally // wrap up
    GradeInfoStrings.Free;
  end;    // try/finally
end;

procedure TfrmExcel.tlGradeInfoSelectionChanged(Sender: TObject);
begin
//  if tlGradeInfo.SelectionCount=1  then
//  begin
//    SetNodeToEdit(tlGradeInfo.Selections[0]);
//  end;
  
end;   

procedure TfrmExcel.tvGradeInfoColumn8PropertiesButtonClick(Sender: TObject; AButtonIndex: Integer);
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

procedure TfrmExcel.btnFileExportClick(Sender: TObject);
begin
  doFileExport(FCurrentTQRecord);
end;   

procedure TfrmExcel.doModify(RecID: String);
begin
  inherited;

end;

procedure TfrmExcel.doSave(RecID: String);
begin
   SaveOperateTQ(RecID,'~');
   inherited;
end;

procedure TfrmExcel.doBrowse(RecID: String);
var
  GradeInfoStrings: TStringList;
begin
    inherited;
    GradeInfoStrings:=TStringList.Create;
    try
      edtEQContent.Lines.LoadFromStream(FCurrentTQRecord.Content);
      GradeInfoStrings.LoadFromStream(FCurrentTQRecord.StAnswer);
      SetupGradeInfoGrid(GradeInfoStrings,tvGradeInfo,'~');
      edtEQContent.ReadOnly:=true;
    finally
      GradeInfoStrings.free;
    end;
end;

procedure TfrmExcel.SaveOperateTQ(const RecID: string; const AGradeInfoDelimiter: Char);
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
                            //SetupGradeInfoGrid(StrList,tvGradeInfo);
                          end;
                     end;
      end;
   finally
     strList.Free;
   end;
end;

procedure TfrmExcel.SetControlState(aAction: TFormAction);
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
             // bedtAnswerFile.Enabled := True; 
              tvGradeInfo.OptionsData.Editing := True;
              //tvGradeInfo.OptionsView.Navigator := True;
              tvGradeInfo.OptionsSelection.CellSelect := true;
              tvGradeInfoColumn8.Options.ShowEditButtons := isebAlways;
              btnFileImport.Enabled := True;
           end;
  end;
end;  

function TfrmExcel.doFileExport(ATQ: TTQ):string;
var
  setTemp:TADODataset;
  strHj:string;
  environmentItem:TEnvironmentItem;
begin
//  if CurrentFormAction in [faModify,faAppend,faInsert] then
//  begin
    OpenDialog1.InitialDir:=extractFilePath(application.ExeName)+'database\Excel文档\';
    OpenDialog1.FileName:=trim(edtStNo.Text)+'.xls';
    OpenDialog1.Filter:=RSExcelDocFilter;
    if OpenDialog1.Execute then
    begin
      ATQ.Environment.SaveToFile(OpenDialog1.FileName);
    end;
//  end;
end;

class procedure TfrmExcel.FormShowMode(const AModuleFileName:TFileName;aMode: TFormMode);
var
  frmExcel:TfrmExcel;
begin
  frmExcel:=TfrmExcel.Create(AModuleFileName,aMode);
  try
    frmExcel.ShowModal;
  finally // wrap up
    frmExcel.free;
  end;    // try/finally
end;



procedure TfrmExcel.InitFormData(aMode: TFormMode);
begin   
  tvGradeInfoColumn1.DataBinding.ValueTypeClass := TcxIntegerValueType;
  tvGradeInfoColumn2.DataBinding.ValueTypeClass := TcxIntegerValueType;
  tvGradeInfoColumn3.DataBinding.ValueTypeClass := TcxStringValueType;
  tvGradeInfoColumn4.DataBinding.ValueTypeClass := TcxStringValueType;
  tvGradeInfoColumn5.DataBinding.ValueTypeClass := TcxStringValueType;
  tvGradeInfoColumn6.DataBinding.ValueTypeClass := TcxIntegerValueType;
  inherited;
end;

procedure TfrmExcel.FillGradeInfoStrings(strings:TStringList);
var
  I: Integer;
  GradeInfo:TGradeInfo;
begin
  inherited;
//  if not Assigned(ExcelGrade) then
//    ExcelGrade:=TExcelGrade.Create(nil);
//  try
//    ExcelGrade.FileName:=bedtAnswerFile.Text;
//    with strings do
//    begin
//       for I := 0 to Count - 1 do    // Iterate
//      begin
//        StrToGradeInfo(strings[i],GradeInfo,'~');
//        //调用 WordGrade模块，获得评分参数值
//        ExcelGrade.FillKeyGradeInfo(gradeinfo,-1);
//        strings[i] := GradeInfoToStr(GradeInfo,'~')
//      end;    // for
//    end;    // with
//  finally
//    freeandnil(ExcelGrade);
//  end;    // try/finally
end;

procedure TfrmExcel.btnFileImportClick(Sender: TObject);
begin
  if CurrentFormAction in [faModify,faAppend,faInsert] then
  begin
    //doFileImport(, )('Excelst.xls',edtStNo.Text,'Excel文档|*.xls');
    doFileImport(FCurrentTQRecord, RSExcelDocFilter );
  end;
end;

end.













