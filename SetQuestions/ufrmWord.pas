unit ufrmWord;

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
  cxGrid, cxGridCardView, DB, ADODB,ugrade, Menus, cxCheckGroup, dxSkinsCore, dxSkinsDefaultPainters, dxSkinsdxDockControlPainter, dxSkinscxPCPainter, 
  Commons, JvExStdCtrls, JvRichEdit, DataFieldConst, tq, dxSkinBlack, dxSkinBlue, dxSkinCaramel, dxSkinCoffee,
  dxSkinDarkRoom, dxSkinDarkSide, dxSkinFoggy, dxSkinGlassOceans, dxSkiniMaginary, dxSkinLilian, dxSkinLiquidSky,
  dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMoneyTwins, dxSkinOffice2007Black, dxSkinOffice2007Blue,
  dxSkinOffice2007Green, dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinPumpkin, dxSkinSeven, dxSkinSharp,
  dxSkinSilver, dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008, dxSkinValentine, dxSkinXmas2008Blue,
  cxLookAndFeels, dxSkinBlueprint, dxSkinDevExpressDarkStyle,
  dxSkinDevExpressStyle, dxSkinHighContrast, dxSkinMetropolis,
  dxSkinMetropolisDark, dxSkinOffice2010Black, dxSkinOffice2010Blue,
  dxSkinOffice2010Silver, dxSkinOffice2013DarkGray, dxSkinOffice2013LightGray,
  dxSkinOffice2013White, dxSkinSevenClassic, dxSkinSharpPlus,
  dxSkinTheAsphaltWorld, dxSkinVS2010, dxSkinWhiteprint, cxNavigator, cxPC;

type
  TfrmWord = class(TfrmBase)
    bedtAnswerFile: TcxButtonEdit;
    btnTest: TcxButton;
    cxLabel2: TcxLabel;
    cxLabel3: TcxLabel;
    OpenDialog1: TOpenDialog;
    btnFileExport: TcxButton;
    btnImportDocFile: TcxButton;
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
    procedure btnImportDocFileClick(Sender: TObject);
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
  public
    //WordGrade: TWordGrade;
    function GetWordPointType(ID:integer): Integer;
    class procedure FormShowMode(const AModuleFileName:TFileName;aMode:TFormMode);

  end;

implementation

uses uDmSetQuestion, StrUtils, uDispAnswer,shellapi,uFnMt, ShellModules, 
  ExamGlobal, DataUtils, ExamResourceStrings;


{$R *.dfm}
{
*********************************** TfrmWord ***********************************
}
procedure TfrmWord.bedtAnswerFilePropertiesButtonClick(Sender: TObject;
        AButtonIndex: Integer);
begin
    //Open the answer file,when clicked
    OpenDialog1.InitialDir:=extractFilePath(application.ExeName)+'database\word文档\';
    //OpenDialog1.FileName:=trim(edtStNo.Text)+'.doc';
    OpenDialog1.Filter:='Word文档|*.doc';
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

procedure TfrmWord.bedtTestFilePropertiesButtonClick(Sender: TObject;
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
procedure TfrmWord.btnTestClick(Sender: TObject);
var
  GradeInfoStrings:TStringList;
  filename:string;
begin
  filename:=bedtAnswerFile.Text;
  GradeInfoStrings:= TStringList.Create;
  try
    GridToGradeInfoStrings(tvGradeInfo,GradeInfoStrings);
    FillGrades(ExtractFilePath(filename),ExtractFileName(filename),GradeInfoStrings,fmExamValue);
    TfrmDispAnswer.ShowForm(GradeInfoStrings);
  finally // wrap up
    GradeInfoStrings.Free;
  end;    // try/finally
end;

function TfrmWord.GetWordPointType(ID:integer): Integer;
begin
  case ID of
    1..50      :result:=1 ;
    51..100    :result:=2;
    101..150   :result:=3;
    151..180   :result:=15;
    181..190   :result:=8;
    191..200   :result:=10;
    201..201   :result:=16;
  end;
end;




procedure TfrmWord.tlGradeInfoSelectionChanged(Sender: TObject);
begin
//  if tlGradeInfo.SelectionCount=1  then
//  begin
//    SetNodeToEdit(tlGradeInfo.Selections[0]);
//  end;
  
end;



procedure TfrmWord.tvGradeInfoColumn8PropertiesButtonClick(Sender: TObject; AButtonIndex: Integer);
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

procedure TfrmWord.btnFileExportClick(Sender: TObject);
begin
  doFileExport(FCurrentTQRecord);
end;   

procedure TfrmWord.doModify(RecID: String);
begin
  inherited;
end;

procedure TfrmWord.doSave(RecID: String);
begin
   SaveOperateTQ(RecID);
   inherited;
end;

procedure TfrmWord.SaveOperateTQ(const RecID: string; const AGradeInfoDelimiter: Char=',');
var
  StrList:TStringList;
begin
   StrList:=TStringList.Create;
   try
      case  CurrentFormAction  of
         faModify,faAppend:begin
                         FCurrentTQRecord.Content.Clear;
                         edtEQContent.Lines.SaveToStream(FCurrentTQRecord.Content);
                         // GridToGradeInfoStrings(tvGradeInfo,StrList);
                          if application.MessageBox('是否保存评分信息','保存提示：',MB_YESNO)=IDYES then
                          begin
                            GridToGradeInfoStrings(tvGradeInfo,StrList,AGradeInfoDelimiter);
                            //FillGrades(ExtractFilePath(bedtAnswerFile.Text),ExtractFileName(bedtAnswerFile.Text),StrList,fmStandvalue,false);
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

procedure TfrmWord.doBrowse(RecID: String);
var
  GradeInfoStrings: TStringList;
begin
    inherited;
    GradeInfoStrings:=TStringList.Create;
    try
      edtEQContent.Lines.LoadFromStream(FCurrentTQRecord.Content);
      GradeInfoStrings.LoadFromStream(FCurrentTQRecord.StAnswer);

//        commstr:= settemp.FieldByName('st_hj').AsString;
//        GetCommandParam(commstr,pcomm);
//        if pcomm[1]<>'' then
//        begin
//           setTemp.Active:=false;
//           settemp.CommandText:='select * from 附加文件 where guid='+pcomm[1];
//           settemp.Active:=true;
//           if not settemp.IsEmpty then
//              btnFileExport.Enabled:=true
//           else
//              btnFileExport.Enabled:=false;
//        end
//        else begin
//           btnFileExport.Enabled:=false;
//        end;
//        setupTreeList(GradeInfoStrings,tlGradeInfo);

        SetupGradeInfoGrid(GradeInfoStrings,tvGradeInfo);
        edtEQContent.ReadOnly:=true;
    finally
      GradeInfoStrings.free;
    end;
end;

procedure TfrmWord.SetControlState(aAction: TFormAction);
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
              btnImportDocFile.Enabled := False;
           end;
  faAppend,
  faModify:begin
   				    edtEQContent.ReadOnly := False;
              //bedtAnswerFile.Enabled := True;
              tvGradeInfo.OptionsData.Editing := True;
              //tvGradeInfo.OptionsView.Navigator := True;
              tvGradeInfo.OptionsSelection.CellSelect := true;
              tvGradeInfoColumn8.Options.ShowEditButtons := isebAlways;
              btnImportDocFile.Enabled := True;
           end;
  end;
end;  

function TfrmWord.doFileExport(ATQ: TTQ):string;
var
  setTemp:TADODataset;
  strHj:string;
  environmentItem:TEnvironmentItem;
begin
    OpenDialog1.InitialDir:=extractFilePath(application.ExeName)+'database\word文档\';
    OpenDialog1.FileName:=trim(edtStNo.Text)+'.doc';
    OpenDialog1.Filter:=RSWordDocFilter;
    if OpenDialog1.Execute then
    begin
      ATQ.Environment.SaveToFile(OpenDialog1.FileName);
    end;
end;

class procedure TfrmWord.FormShowMode(const AModuleFileName:TFileName;aMode: TFormMode);
var
  frmWord:TfrmWord;
begin
  frmWord:=TfrmWord.Create(AModuleFileName,aMode);
  try
    frmWord.ShowModal;
  finally // wrap up
    frmWord.free;
  end;    // try/finally
end;

procedure TfrmWord.InitFormData(aMode: TFormMode);
begin   
  tvGradeInfoColumn1.DataBinding.ValueTypeClass := TcxIntegerValueType;
  tvGradeInfoColumn2.DataBinding.ValueTypeClass := TcxIntegerValueType;
  tvGradeInfoColumn3.DataBinding.ValueTypeClass := TcxStringValueType;
  tvGradeInfoColumn4.DataBinding.ValueTypeClass := TcxStringValueType;
  tvGradeInfoColumn5.DataBinding.ValueTypeClass := TcxStringValueType;
  tvGradeInfoColumn6.DataBinding.ValueTypeClass := TcxIntegerValueType;
  inherited;
end;

procedure TfrmWord.btnImportDocFileClick(Sender: TObject);
begin
  if CurrentFormAction in [faModify,faAppend,faInsert] then
  begin
    //doFileImport('wordst.doc',edtStNo.Text,'Word文档|*.doc');
    doFileImport(FCurrentTQRecord, RSWordDocFilter );
  end;
end;

end.













