unit ufrmWin;

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
  Commons, JvExStdCtrls, JvRichEdit, dxSkinBlack, dxSkinBlue, dxSkinCaramel,
  dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide, dxSkinFoggy, dxSkinGlassOceans,
  dxSkiniMaginary, dxSkinLilian, dxSkinLiquidSky, dxSkinLondonLiquidSky,
  dxSkinMcSkin, dxSkinMoneyTwins, dxSkinOffice2007Black, dxSkinOffice2007Blue,
  dxSkinOffice2007Green, dxSkinOffice2007Pink, dxSkinOffice2007Silver,
  dxSkinPumpkin, dxSkinSeven, dxSkinSharp, dxSkinSilver, dxSkinSpringTime,
  dxSkinStardust, dxSkinSummer2008, dxSkinValentine, dxSkinXmas2008Blue,
  cxLookAndFeels, dxSkinBlueprint, dxSkinDevExpressDarkStyle,
  dxSkinDevExpressStyle, dxSkinHighContrast, dxSkinMetropolis,
  dxSkinMetropolisDark, dxSkinOffice2010Black, dxSkinOffice2010Blue,
  dxSkinOffice2010Silver, dxSkinOffice2013DarkGray, dxSkinOffice2013LightGray,
  dxSkinOffice2013White, dxSkinSevenClassic, dxSkinSharpPlus,
  dxSkinTheAsphaltWorld, dxSkinVS2010, dxSkinWhiteprint, cxNavigator, cxPC;

type
  TfrmWin = class(TfrmBase)
    cxLabel2: TcxLabel;
    OpenDialog1: TOpenDialog;
    grdGradeInfo: TcxGrid;
    tvGradeInfo: TcxGridTableView;
    tvGradeInfoColumn1: TcxGridColumn;
    tvGradeInfoColumn2: TcxGridColumn;
    tvGradeInfoColumn3: TcxGridColumn;
    tvGradeInfoColumn4: TcxGridColumn;
    tvGradeInfoColumn5: TcxGridColumn;
    tvGradeInfoColumn6: TcxGridColumn;
    grdGradeInfoLevel1: TcxGridLevel;
    qryEnvironment: TADOQuery;
    dsEnvironment: TDataSource;
    shlboxPath: TcxShellComboBox;
    btnPointTest: TcxButton;
    edtEQContent: TJvRichEdit;
    tvGradeInfoColumn7: TcxGridColumn;
    tvGradeInfoColumn8: TcxGridColumn;
    cxgrpbx1: TcxGroupBox;
    cxLabel10: TcxLabel;
    btnImportEnviron: TcxButton;
    btnExportEnviron: TcxButton;
    procedure bedtTestFilePropertiesButtonClick(Sender: TObject; AButtonIndex:
            Integer);
    procedure tlGradeInfoSelectionChanged(Sender: TObject);
    procedure btnPointTestClick(Sender: TObject);
    procedure tvGradeInfoColumn8PropertiesButtonClick(Sender: TObject; AButtonIndex: Integer);
    procedure btnImportEnvironClick(Sender: TObject);
    procedure btnExportEnvironClick(Sender: TObject);
  private

  protected
    procedure doSave(RecID: String); override;
    procedure doModify(RecID: String); override;
    procedure doBrowse(RecID: String); override;
    procedure SetControlState(aAction: TFormAction); override;

    procedure InitFormData(aMode: TFormMode); override;
  public
    //WordGrade: TWordGrade;
    class procedure FormShowMode(const AModuleFileName:TFileName;aMode:TFormMode);
  end;

implementation

uses uDmSetQuestion, StrUtils, uDispAnswer,shellapi, SetQuestionGlobal, ExamInterface, 
  ShellModules, ExamGlobal, DataFieldConst, DataUtils, compress, ExamException, 
  ExamResourceStrings;


{$R *.dfm}
{
*********************************** TfrmWord ***********************************
}
procedure TfrmWin.bedtTestFilePropertiesButtonClick(Sender: TObject;
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

procedure TfrmWin.tlGradeInfoSelectionChanged(Sender: TObject);
begin
//  if tlGradeInfo.SelectionCount=1  then
//  begin
//    SetNodeToEdit(tlGradeInfo.Selections[0]);
//  end;
  
end;

procedure TfrmWin.doModify(RecID: String);
begin
  inherited;
end;

procedure TfrmWin.doSave(RecID: String);
var
  StrList:TStringList;
begin
   StrList:=TStringList.Create;
   try
      case  CurrentFormAction  of
         faModify,faAppend:begin
                         FCurrentTQRecord.Content.Clear;
                         edtEQContent.Lines.SaveToStream(FCurrentTQRecord.Content);
                          GridToGradeInfoStrings(tvGradeInfo,StrList);
                          if application.MessageBox('是否保存评分信息','保存提示：',MB_YESNO)=IDYES then
                          begin
                            //FillGrades(shlboxPath.AbsolutePath,'',StrList,fmExamValue);
                            FCurrentTQRecord.StAnswer.Clear;
                            StrList.SaveToStream(FCurrentTQRecord.StAnswer);
                            //必须保存后再更新，否则由于转换过程中字符串发生变化产生错误
                            SetupGradeInfoGrid(StrList,tvGradeInfo);
                          end;
//                         StrList.Clear;
//                          GridToEnvironmentInfoStrings(tvEnvironmentInfo,StrList);
//                          if application.MessageBox('是否保存环境信息','保存提示：',MB_YESNO)=IDYES then begin
//                            FCurrentTQRecord.Environment.Clear;
//                            StrList.SaveToStream(FCurrentTQRecord.Environment);
//                          end;
                     end;
      end;
   finally
     strList.Free;
   end;
   inherited;
end;

procedure TfrmWin.doBrowse(RecID: String);
var
  GradeInfoStrings: TStringList;
  EnvironmentInfoStrings : TStringList;
begin
    inherited;
    GradeInfoStrings:=TStringList.Create;
    EnvironmentInfoStrings := TStringList.Create;
    try
      edtEQContent.Lines.LoadFromStream(FCurrentTQRecord.Content);
      GradeInfoStrings.LoadFromStream(FCurrentTQRecord.StAnswer);
      EnvironmentInfoStrings.LoadFromStream(FCurrentTQRecord.Environment);
      SetupGradeInfoGrid(GradeInfoStrings,tvGradeInfo);
      //SetupEnvironmentInfoGrid(EnvironmentInfoStrings,tvEnvironmentInfo);
      edtEQContent.ReadOnly:=true;
    finally
      GradeInfoStrings.free;
      EnvironmentInfoStrings.free;
    end;
end;

procedure TfrmWin.SetControlState(aAction: TFormAction);
begin
  inherited;
  case aAction of
  faBrowse,
  faSave,
  faCancel:begin
  					edtEQContent.ReadOnly := True;
              tvGradeInfo.OptionsData.Editing := False;
              //tvGradeInfo.OptionsView.Navigator := False;
              tvGradeInfo.OptionsSelection.CellSelect := false;
              tvGradeInfoColumn8.Options.ShowEditButtons := isebNever;
              btnImportEnviron.Enabled := False;
           end;
  faAppend,
  faModify:begin
               edtEQContent.ReadOnly := False;
              tvGradeInfo.OptionsData.Editing := True;
              //tvGradeInfo.OptionsView.Navigator := True;
              tvGradeInfo.OptionsSelection.CellSelect := true;
              tvGradeInfoColumn8.Options.ShowEditButtons := isebAlways;
              btnImportEnviron.Enabled := True;
           end;
  end;
end;  

class procedure TfrmWin.FormShowMode(const AModuleFileName:TFileName;aMode: TFormMode);
var
  frmWin:TfrmWin;
begin
  frmWin:=TfrmWin.Create(AModuleFileName,aMode);
  try
    frmWin.ShowModal;
  finally // wrap up
    frmWin.free;
  end;    // try/finally
end;

procedure TfrmWin.InitFormData(aMode: TFormMode);
begin   
  tvGradeInfoColumn1.DataBinding.ValueTypeClass := TcxIntegerValueType;
  tvGradeInfoColumn2.DataBinding.ValueTypeClass := TcxIntegerValueType;
  tvGradeInfoColumn3.DataBinding.ValueTypeClass := TcxStringValueType;
  tvGradeInfoColumn4.DataBinding.ValueTypeClass := TcxStringValueType;
  tvGradeInfoColumn5.DataBinding.ValueTypeClass := TcxStringValueType;
  tvGradeInfoColumn6.DataBinding.ValueTypeClass := TcxIntegerValueType;
  qryEnvironment.Active:=true;
  inherited;
end;


procedure TfrmWin.btnExportEnvironClick(Sender: TObject);
var
  path: string;
  EnvironmentInfoStrings : TStringList;
begin
   EDirNotExistException.ifFalse(DirectoryExists(shlboxPath.Text),Format(RSDirNotExist,[shlboxPath.Text]));
      //根据流中压缩包文件解压生成目录树结构
       CreateOperateDir(shlboxPath.Text,FCurrentTQRecord.Environment);
       ShellExecute( handle,	// handle to parent window
                     'open',	// pointer to string that specifies operation to perform
                     pchar(path),	// pointer to filename or folder name string
                     '',	// pointer to string that specifies executable-file parameters
                     pchar(path),	// pointer to string that specifies default directory
                     SW_SHOWNORMAL 	// whether file is shown when opened
                     );
end;

procedure TfrmWin.btnImportEnvironClick(Sender: TObject);
var
   path:string;
   environmentStream:TMemoryStream;
begin
   if CurrentFormAction in [faModify,faAppend,faInsert] then
   begin
      EDirNotExistException.ifFalse(DirectoryExists(shlboxPath.Text),Format(RSDirNotExist,[shlboxPath.Text]));
      if Application.MessageBox(PChar(Format('你真的要将下面目录中的内容作为本题考生目录环境导入吗？'+eol+' %s ',[shlboxPath.Text])), '错误', MB_YESNO + MB_ICONQUESTION + MB_DEFBUTTON2 + MB_TOPMOST) =IDYES then
      begin
         try
            DirectoryCompression(shlboxPath.Text,environmentstream);
            FCurrentTQRecord.Environment.LoadFromStream(environmentstream);
         finally
            environmentstream.Free;
         end;
      end;
   end;
end;

procedure TfrmWin.btnPointTestClick(Sender: TObject);
var
  GradeInfoStrings :TStringList;
  path: string;
begin
  inherited;
  path := shlboxPath.AbsolutePath;
  GradeinfoStrings := TStringList.Create;
  try
    GridToGradeInfoStrings(tvGradeInfo,GradeInfoStrings);
    FillGrades(path,'',GradeInfoStrings,fmExamValue);
    TfrmDispAnswer.ShowForm(GradeInfoStrings);
  finally
    GradeInfoStrings.Free;
  end;    
end;

procedure TfrmWin.tvGradeInfoColumn8PropertiesButtonClick(Sender: TObject; AButtonIndex: Integer);
var
  StrList:TStringList;
begin
  inherited;
  StrList:=TStringList.Create;
   try
      GridRowToGradeInfoStrings(tvGradeInfo,StrList,',');
      FillGrades(shlboxPath.AbsolutePath,'',StrList,fmStandValue);
      FillGridRowWithGradeInfo(StrList,tvGradeInfo,',');
   finally
      StrList.Free;
   end;
  
end;



end.













