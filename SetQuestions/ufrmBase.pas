unit ufrmBase;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, dxDockControl, dxDockPanel, ExtCtrls, cxLookAndFeelPainters,
  StdCtrls, cxButtons, ufraTree, cxEdit, cxEditRepositoryItems,cxTL,uGrade,
  DB, ADODB,cxGridTableView, cxStyles, cxClasses,cxGridCustomTableView,
  Menus, cxControls, cxContainer, cxGroupBox, cxCheckGroup,ZLib, uFnMt, dxSkinsCore, dxSkinsDefaultPainters, dxSkinsdxDockControlPainter, 
  Commons, cxLabel, cxTextEdit, ExamGlobal, DataFieldConst, tq,
  dxSkinBlack, dxSkinBlue, dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom,
  dxSkinDarkSide, dxSkinFoggy, dxSkinGlassOceans, dxSkiniMaginary, dxSkinLilian,
  dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinPumpkin, dxSkinSeven,
  dxSkinSharp, dxSkinSilver, dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008,
  dxSkinValentine, dxSkinXmas2008Blue, cxGraphics, cxLookAndFeels,
  dxSkinBlueprint, dxSkinDevExpressDarkStyle, dxSkinDevExpressStyle,
  dxSkinHighContrast, dxSkinMetropolis, dxSkinMetropolisDark,
  dxSkinOffice2010Black, dxSkinOffice2010Blue, dxSkinOffice2010Silver,
  dxSkinOffice2013DarkGray, dxSkinOffice2013LightGray, dxSkinOffice2013White,
  dxSkinSevenClassic, dxSkinSharpPlus, dxSkinTheAsphaltWorld, dxSkinVS2010,
  dxSkinWhiteprint, cxPC;

type

  TFormAction=(faRecChange,faBrowse,faModify,faAppend,faInsert,faSave,faDelete,faCancel,faClose);
  {TODO 要在操作题中，显示知识点难易度}
  TUseItemNameArray=array of string;
  TfrmBase = class(TForm)
    btnAppend: TcxButton;
    btnCancel: TcxButton;
    btnDelete: TcxButton;
    btnExit: TcxButton;
    btnModify: TcxButton;
    btnSave: TcxButton;
    dxDockingManager1: TdxDockingManager;
    dxDockPanel1: TdxDockPanel;
    dxDockSite1: TdxDockSite;
    dxDockSite2: TdxDockSite;
    fraTree1: TfraTree;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    cxEditRepository1: TcxEditRepository;
    cxEditRepository1ButtonItem1: TcxEditRepositoryButtonItem;
    qryPoint: TADOQuery;
    PointDs: TDataSource;
    dxLayoutDockSite1: TdxLayoutDockSite;
    cxStyleRepository1: TcxStyleRepository;
    GridTableViewStyleSheetDevExpress: TcxGridTableViewStyleSheet;
    cxStyle1: TcxStyle;
    cxStyle2: TcxStyle;
    cxStyle3: TcxStyle;
    cxStyle4: TcxStyle;
    cxStyle5: TcxStyle;
    cxStyle6: TcxStyle;
    cxStyle7: TcxStyle;
    cxStyle8: TcxStyle;
    cxStyle9: TcxStyle;
    cxStyle10: TcxStyle;
    cxStyle11: TcxStyle;
    cxStyle12: TcxStyle;
    cxStyle13: TcxStyle;
    cxStyle14: TcxStyle;
    grpStUseInfo: TcxCheckGroup;
    edtStNo: TcxTextEdit;
    cxlbl1: TcxLabel;
    lblTitle: TcxLabel;
    lblItemDifficulty: TcxLabel;
    edtItemDifficulty: TcxTextEdit;
    lblRedactor: TcxLabel;
    edtRedactor: TcxTextEdit;
    edtRedactionTime: TcxTextEdit;
    lblRedactionTime: TcxLabel;
    styleControllerEdit: TcxEditStyleController;
    procedure fraTree1tvTreeCanFocusRecord(Sender: TcxCustomGridTableView;
      ARecord: TcxCustomGridRecord; var AAllow: Boolean);
    procedure fraTree1tvTreeFocusedRecordChanged(Sender: TcxCustomGridTableView;
      APrevFocusedRecord, AFocusedRecord: TcxCustomGridRecord;
      ANewItemRecordFocusingChanged: Boolean);
    procedure btnAppendClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure btnExitClick(Sender: TObject);
    procedure btnModifyClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure fraTree1tvTreeDblClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnSaveSelectClick(Sender: TObject);
    procedure btnSelectClick(Sender: TObject);
  private

    function ModelIDtoName(aAction: TFormMode):string;
    procedure SetCurrentStUseInfo();
    procedure deleteCurrentRec(ARecID: string);
    procedure SetPublicTQEditData;


  protected
    FModule : TModuleInfo;
    CurrentFormAction: TFormAction;
    FModelID: TFormMode;
    procedure InitFormData(aMode:TFormMode); virtual;    //初始化窗体数据
    procedure SetControlState(aAction:TFormAction); virtual;  //设置窗体控件状态
    procedure SetModule(AModuleFileName:TFileName);
    //数据处理事件调用函数
    procedure FormAction(aAction:TFormAction; RecID:string);
    
    procedure doBrowse(RecID:string);virtual;
    procedure doAppend(RecID:string);virtual;
    procedure doModify(RecID:String);virtual;
    procedure doSave(RecID:string);virtual;
    procedure doCancel(RecID:string);virtual;
    procedure doDelete(RecID:string);virtual;
    procedure doClose; virtual;

    //评分信息Grid相关函数
    procedure SetupGradeInfoGrid(GradeInfoStrings:TStringList;tvGradeInfo: TcxGridTableView);overload;
    procedure GridToGradeInfoStrings(tvGradeInfo:TcxGridTableView;aStringList:TStringList);overload;
    procedure SetupGradeInfoGrid(GradeInfoStrings:TStringList;tvGradeInfo: TcxGridTableView;chr:char); overload;
    procedure GridToGradeInfoStrings(tvGradeInfo:TcxGridTableView;aStringList:TStringList;chr:char);overload;
    procedure GridRowToGradeInfoStrings(tvGradeInfo: TcxGridTableView; aStringList: TStringList; chr: char);
    procedure FillGridRowWithGradeInfo(GradeInfoStrings: TStringList; tvGradeInfo: TcxGridTableView; chr: char);

    //试题环境信息Grid相关函数
    procedure SetupEnvironmentInfoGrid(EnvironmentInfoStrings:TStringList;tvEnvironmentInfo: TcxGridTableView);
    procedure GridToEnvironmentInfoStrings(tvEnvironmentInfo:TcxGridTableView;aStringList:TStringList);
    //获得新记录号
    function NewRecordNo(aMode:TFormMode):string;
    // 根据模式确定试题编号前辍字符
    //function GetRecordNoPreFlag(aMode:TFormMode):string;

    ///this function is for convert TQ content control (TJVRichedit.lines) value to variant;
//    function StringsToVairant(strings:TStrings):Variant;
    //procedure AssignValueToRichEdit(value:Variant;ARichEdit:TJvRichEdit);
  public
    StUseInfo:TStringListArray;
    StUseInfoName:array of string;
    CurrentStUseInfoItem:integer;
    FCurrentTQRecord : TTQ;
    constructor Create(const AModuleFileName:TFileName;const aMode: TFormMode); reintroduce;
    destructor Destroy();  override;
    procedure LoadStUseInfo(ds:TADODataSet;aAction: TFormMode);
    procedure CreateStUseInfoControl(name :array of string);
    procedure FillGrades(APath,AFileName:TFileName;AGradeInfoList:TStrings;AFillMode:TFillGradeMode);
  end;

implementation

uses uDmSetQuestion,strutils,cxDataStorage, cxCheckBox,ShellModules, 
  ufrmModifyTQNo, DataUtils,SetQuestionsResoureStrings, ExamException, 
  ExamResourceStrings,Role;


{$R *.dfm}

{ TfrmBase }

{
*********************************** TfrmBase ***********************************
}


procedure TfrmBase.btnAppendClick(Sender: TObject);
begin
  FormAction(faAppend,'');
end;

procedure TfrmBase.btnCancelClick(Sender: TObject);
begin
  FormAction(faCancel,'');
end;

procedure TfrmBase.btnDeleteClick(Sender: TObject);
begin
  FormAction(faDelete,'');
end;

procedure TfrmBase.btnExitClick(Sender: TObject);
begin
  FormAction(faClose,'');
end;

procedure TfrmBase.btnModifyClick(Sender: TObject);
begin
  FormAction(faModify,'');
end;

procedure TfrmBase.btnSaveClick(Sender: TObject);
begin
  FormAction(faSave,Trim(edtStNo.text));
end;

procedure TfrmBase.btnSaveSelectClick(Sender: TObject);
var
  stringList: TStringList;
  rn: integer;
  I: Integer;
  SelectedItem: Integer;
  fieldname: string;
begin
  fieldname:=ModelIDtoName(FModelID);
  stringList:=TStringList.Create;
  try
      rn:=fraTree1.gvStList.DataController.RecordCount;
      for I := 0 to rn - 1 do
      begin
        if (fraTree1.gvStList.DataController.Values[i,0]) then
            stringList.Add(fraTree1.gvStList.DataController.Values[i,1]);
      end;
      rn:=dmSetQuestion.stSelect.RecordCount;
      SelectedItem:=-1;
      dmSetQuestion.stSelect.First;
      while not dmSetQuestion.stSelect.Eof do
      begin
        if dmSetQuestion.stSelect.FieldValues['是否选用'] then
        begin
           dmSetQuestion.stSelect.Edit;
           dmSetQuestion.stSelect.FieldValues[fieldname]:=stringList.DelimitedText;
           dmSetQuestion.stSelect.Post;
           break;
        end else
            dmSetQuestion.stSelect.Next;
      end
  finally
    stringList.Free;
  end;
  fraTree1.colSelected.Options.Editing:=false;
end;

procedure TfrmBase.btnSelectClick(Sender: TObject);
begin
  fraTree1.colSelected.Options.Editing:=true;
end;

procedure TfrmBase.FormAction(aAction:TFormAction; RecID:string);
begin
  if CurrentFormAction<>faBrowse then
  begin
    case aAction of    //
      faSave: begin
                  doSave(RecID);
                  CurrentFormAction := faBrowse;
              end ;
      faCancel: begin
                  doCancel('');
                  CurrentFormAction := faBrowse;
                end ;
    else
         application.MessageBox('你正在改变数据，必须保存或取消！','警告：');
    end;    // case
  end
  else begin
    if CurrentFormAction=faBrowse then
    begin
      case aAction of
        faBrowse: doBrowse(RecID) ;
        faAppend: begin
                    CurrentFormAction:=faAppend;
                    doAppend('');
                  end;
        faModify: begin
                    CurrentFormAction:=faModify;
                    doModify('');
                  end;
        faClose : begin
                    doClose;
                  end;
        faDelete: begin
                    dodelete(recID);
        				end;
      end;
    end;
  end;
  SetControlState(CurrentFormAction);
end;

procedure TfrmBase.fraTree1tvTreeDblClick(Sender: TObject);
begin
 // FormAction(faBrowse,dmMain.stSt.FieldByName('st_no').AsString);
end;

procedure TfrmBase.InitFormData(aMode:TFormMode);
begin
  FModelID:=aMode;
  Caption := RSAppTitle;
  lblTitle.Caption := ModelIDToName(FModelID);

  CurrentFormAction:=faBrowse;

  qryPoint.Active:=true;
  dmSetQuestion.TypeTable.Active:=true;
  
  with dmSetQuestion.stSt do
  begin
    //DisableControls;
    Active:=false;
    Parameters.ParamByName('StNo').Value:=GetRecordNoPreFlag(aMode)+'%';
    Active:=true;
    fraTree1.LoadStList(dmSetQuestion.stSt);
    LoadStUseInfo(dmSetQuestion.stSelect,FModelID);
    SetCurrentStUseInfo();
    CreateStUseInfoControl(StUseInfoName);
    //EnableControls;
  end;
  if not dmSetQuestion.stSt.IsEmpty then
  begin
    dmSetQuestion.stSt.First;
    fraTree1.SetFocus(dmSetQuestion.stSt.fieldbyname('st_no').AsString);
  end;
  SetControlState(faBrowse);
end;



//procedure TfrmBase.setupTreeList(GradeInfoStrings:TStringList;tlGradeInfo:TcxTreeList);
//var
//  node1:TcxTreeListNode;
//  i:integer;
//  GradeInfo:TGradeInfo;
//begin
//  with tlGradeInfo do
//  begin
//    Clear;
//    for i:=0 to GradeInfoStrings.Count-1 do
//    begin
//      StrToGradeInfo(GradeInfoStrings.Strings[i],GradeInfo);
//      node1:=Nodes.Root.AddChild;
//
//      node1.Values[0] := node1.VisibleIndex+1;
//      node1.Values[1] := inttostr(GradeInfo.ID);
//      node1.Values[2] := GradeInfo.ObjStr;
//      node1.Values[3] := GradeInfo.StandardValue;
//      node1.Values[4] := GradeInfo.EQText;
//      node1.Values[5] := GradeInfo.Points;
//    end;
//    SetFocusedNode(nodes.Root.getFirstChild,[]);
//  end;
//end;

//procedure TfrmBase.TreeToGradeInfoStrings(aTree:TcxTreeList;aStringList:TStringList);
//var
//   root,node:TcxTreeListNode;
//   str:string;
//begin
//   aStringList.Clear;
//   root:=aTree.Nodes.Root;
//   node:=root.getFirstChild;
//   while node<>nil do
//   begin
//     with node do
//     begin
//       str:=inttostr(Values[1])+','+Values[2]+','+Values[3]+','+Values[4]+','+inttostr(Values[5])+','+',0,';
//     end;    // with
//     aStringList.Add(str);
//     node:=root.GetNextChild(node);
//   end;
//end;

procedure TfrmBase.doBrowse(RecID: string);
var
  I,j: Integer;
begin
  j:=0;
  for I := 0 to length(StUseInfo) - 1 do
  begin
    //if i<>CurrentStUseInfoItem then        //包含当前项目
    begin
      if StUseInfo[i].IndexOf(RecID)>=0 then
         grpStUseInfo.States[j]:=cbsChecked
      else
         grpStUseInfo.States[j]:=cbsUnChecked;
      j:=j+1;
    end;
  end;
  //get test question form db and uncompress ,then fill the tqRecord
  if Assigned(FCurrentTQRecord) then
      FCurrentTQRecord.ClearData;
  TTQ.ReadTQByIDAndUnCompress(RecID,DmSetQuestion.GetTQDBConn,FCurrentTQRecord,TQReadWriteOptionsAllTQFields);
  SetPublicTQEditData;
end;

procedure TfrmBase.SetPublicTQEditData;
begin
   edtStNo.Text:=FCurrentTQRecord.st_no;
   edtItemDifficulty.Text := IntToStr(FCurrentTQRecord.Difficulty);
   edtRedactor.Text := FCurrentTQRecord.Redactor;
   edtRedactionTime.Text := DateTimeToStr(FCurrentTQRecord.RedactTime)
end;

procedure TfrmBase.doCancel(RecID: string);
begin
  if CurrentFormAction=faAppend then
  begin
     RecID:= fraTree1.CurrentTQNo;
     deleteCurrentRec(RecID);
  end;
  doBrowse(fraTree1.CurrentTQNo);
end;

procedure TfrmBase.doModify(RecID: String);
begin

end;

procedure TfrmBase.doSave(RecID: string);
begin
   //保存时填充试题修订者，及修订时间
   FCurrentTQRecord.Redactor := TUsermanager.CurUser.RealName;
   FCurrentTQRecord.RedactTime := Now;
   TTQ.WriteCompressedTQ2DB(FCurrentTQRecord,dmSetQuestion.GetTQDBConn,[rwoRedactor,rwoRedactTime,rwoIsModified]);
   doBrowse(RecID);
end;

procedure TfrmBase.SetControlState(aAction: TFormAction);
begin
  case aAction of
    faBrowse:begin
               btnAppend.Enabled:=true;
               btnModify.Enabled:=true;
               btnSave.Enabled:=false;
               btnCancel.Enabled:=false;
               btnDelete.Enabled:=true;
             end;
    faAppend,
    faModify :begin
               btnAppend.Enabled:=false;
               btnModify.Enabled:=false;
               btnSave.Enabled:=true;
               btnCancel.Enabled:=true;
               btnDelete.Enabled:=false;
             end;
    faSave,
    faCancel:begin
               btnAppend.Enabled:=true;
               btnModify.Enabled:=true;
               btnSave.Enabled:=false;
               btnCancel.Enabled:=false;
               btnDelete.Enabled:=true;
             end;
  end;
end;



procedure TfrmBase.doAppend(RecID: string);
begin
  RecID := NewRecordNo(FModelID);
  recID:=TfrmModifyTQNo.frmShow(RecID,dmSetQuestion.stSt );
  dmSetQuestion.stSt.AppendRecord([recid]);
  fraTree1.Append(RecID);
  doBrowse(RecID);
  doModify(RecID);
end;

procedure TfrmBase.doClose;
begin
  if CurrentFormAction=faBrowse then
     self.Close;
end;

constructor TfrmBase.Create(const AModuleFileName:TFileName;const aMode: TFormMode);
begin
  inherited Create(application);
  FCurrentTQRecord := TTQ.Create;
  InitFormData(aMode);
  SetModule(AModuleFileName);
end;

procedure TfrmBase.CreateStUseInfoControl(name: array of string);
var
  chkItem:TcxCheckGroupItem;
  I: Integer;
begin
  for I := 0 to length(name) - 1 do
  begin
    //if i<>CurrentStUseInfoItem then  //包含当前项
    begin
      chkItem:=grpStUseInfo.Properties.Items.Add;
      chkItem.Caption:= name[i];
    end;
  end;
end;

destructor TfrmBase.Destroy;
var
  i: Integer;
   fr:Boolean;
   dllhandle:Cardinal;
begin
  for i := 0 to High(StUseInfo) do StUseInfo[i].Free;
  if Assigned(FCurrentTQRecord) then
     FreeAndNil(FCurrentTQRecord);
  if FModule<>nil then  begin
      dllhandle := FModule.DllHandle;
      fr:=FreeLibrary(DllHandle);
      FModule.Free;

  end;

  inherited ;
end;

function TfrmBase.NewRecordNo(aMode: TFormMode): string;
var
  setTemp: TADODataSet;
  i,j:integer;
  preFlag:string;
begin
    inherited;
    preFlag := GetRecordNoPreFlag(aMode); 
    setTemp:=TADODataSet.Create(self);
    try
      setTemp.Connection:=dmSetQuestion.stkConn;

        if settemp.Active then
           settemp.Active:=false;
        setTemp.CommandText:='select st_no from 试题 where st_no like :stno';
        settemp.Parameters.ParamByName('stno').Value := preFlag+'%';
        setTemp.Active:=true;
        i:=0;
        settemp.First;
        while not settemp.Eof do
        begin
           j:=strtoint( rightstr(settemp.fieldbyname('st_no').AsString,5)) ;
           if i<j then
              i:=j;
           settemp.Next;
        end;
        i:=i+1;
        result := preFlag+format('%5.5d',[i]);
    finally
      setTemp.Free;
    end;
end;

//function TfrmBase.GetRecordNoPreFlag(aMode: TFormMode): string;
//var
//  preFlag :string;
//begin
//    case aMode of    //
//      SINGLESELECT_MODEL: preFlag := 'A';
//      MULTISELECT_MODEL: preFlag := 'X';
//      TYPE_MODEL : preFlag := 'C' ;
//      WORD_MODEL: preFlag := 'E';
//      WINDOWS_MODEL: preFlag := 'D';
//      EXCEL_MODEL : preFlag := 'F';
//      POWERPOINT_MODEL : preFlag := 'G';
//    end;    // case
//    Result := preFlag;
//end;

procedure TfrmBase.doDelete(RecID: string);
begin
  RecID:= fraTree1.CurrentTQNo;
  if application.MessageBox(pchar('你真的要删除记录：'+#10#13+recID),'删除吗？',mb_Yesno)=IDYES then
  begin
     deleteCurrentRec(RecID);
  end;
  //RecID:=dmSetQuestion.stSt.FieldValues['st_no'];
  doBrowse(fraTree1.CurrentTQNo);
end;


{-------------------------------------------------------------------------------
  过程名:    TfrmBase.deleteCurrentRec		日期:      2009.05.01
  参数:      ARecID: string
  返回值:    无
  说明:      删除显示的当前试题记录，同时删除数据库和列表显示数据
-------------------------------------------------------------------------------}
procedure TfrmBase.deleteCurrentRec(ARecID: string);
begin
   ETQRecordNotFoundException.IfFalse(dmSetQuestion.stSt.Locate(DFNTQ_ST_NO,ARecID,[]),Format(RSTQRecordNotFound,[ARecID]));
   dmSetQuestion.stSt.Delete;
   fraTree1.DeleteCurrent;
end;

procedure TfrmBase.FillGrades(APath,AFileName:TFileName;AGradeInfoList:TStrings;AFillMode:TFillGradeMode);
var
  delegateGrade : fnFillGrades;
begin
   try
      @delegateGrade := GetProcAddress(FModule.DllHandle,FN_FILLGRADES);
      delegateGrade(AGradeInfoList,APath,AFileName,nil,AFillMode,False);
   except
      on E:EGradeException do
         Application.MessageBox(PChar(E.message), '错误', MB_OK + MB_ICONINFORMATION + MB_TOPMOST);
      else
         raise;
   end;
end; 

procedure TfrmBase.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if CurrentFormAction<>fabrowse then
  begin
    application.MessageBox('你正在改变数据，必须保存或取消！','警告：');
    action:= caNone;
  end;    
end;

procedure TfrmBase.SetupGradeInfoGrid(GradeInfoStrings: TStringList;
  tvGradeInfo: TcxGridTableView);
begin
  SetupGradeInfoGrid(GradeInfoStrings,tvGradeInfo,',');
end;

procedure TfrmBase.GridToGradeInfoStrings(tvGradeInfo: TcxGridTableView;
  aStringList: TStringList);
begin
  GridToGradeInfoStrings(tvGradeInfo,aStringList,',');
end;



procedure TfrmBase.GridToEnvironmentInfoStrings(
  tvEnvironmentInfo: TcxGridTableView; aStringList: TStringList);
var
  I,J: Integer;
  str:string;
begin
   aStringList.Clear;
   with tvEnvironmentInfo.DataController do
   begin

     for I := 0 to RecordCount - 1 do    // Iterate
     begin
       str:='';
       for J := 1 to 4 do    // Iterate
       begin
         if not varisnull(Values[I,J]) then
           if tvEnvironmentInfo.Columns[J].DataBinding.ValueTypeClass = TcxIntegerValueType then
              str := str+inttostr(Values[I,J])+','
           else
             str:= str+Values[I,J]+','
         else
           if tvEnvironmentInfo.Columns[J].DataBinding.ValueTypeClass = TcxIntegerValueType then
              str := str+inttostr(0)+','
           else
           	str := str+',';
       end;    // for

//       FillGradeInfoString(str);
       aStringList.add(str);
     end;    // for
   end;    // with
end;

procedure TfrmBase.SetupEnvironmentInfoGrid(EnvironmentInfoStrings: TStringList;
  tvEnvironmentInfo: TcxGridTableView);
var
  i:integer;
  EnvironmentInfo:TEnvironmentItem;
begin
  with tvEnvironmentInfo do
  begin

    tvEnvironmentInfo.BeginUpdate;
    tvEnvironmentInfo.DataController.RecordCount := EnvironmentInfoStrings.Count;
    for i:=0 to EnvironmentInfoStrings.Count-1 do
    begin
      StrToEnvironmentItem(EnvironmentInfoStrings.Strings[i],EnvironmentInfo);
      tvEnvironmentInfo.DataController.Values[i,1] := EnvironmentInfo.ID;
      tvEnvironmentInfo.DataController.Values[i,2] := EnvironmentInfo.value1 ;
      tvEnvironmentInfo.DataController.Values[i,3] := EnvironmentInfo.Value2;
    end;
    tvEnvironmentInfo.EndUpdate;
  end;
end;

procedure TfrmBase.GridToGradeInfoStrings(tvGradeInfo: TcxGridTableView;aStringList: TStringList; chr: char);
var
  I,J: Integer;
  str:string;
begin
   aStringList.Clear;
   with tvGradeInfo.DataController do
   begin

     for I := 0 to RecordCount - 1 do    // Iterate
     begin
       str:='';
       for J := 1 to 6 do    // Iterate
       begin
         if not varisnull(Values[I,J]) then
           if tvGradeInfo.Columns[J].DataBinding.ValueTypeClass = TcxIntegerValueType then
              str := str+inttostr(Values[I,J])+chr
           else
             str:= str+Values[I,J]+chr
         else
           if tvGradeInfo.Columns[J].DataBinding.ValueTypeClass = TcxIntegerValueType then
              str := str+inttostr(0)+chr
           else
           	str := str+chr;
       end;    // for

       str := str+chr+'0'+chr;
//       FillGradeInfoString(str);
       aStringList.add(str);
     end;    // for
   end;    // with

end;

procedure TfrmBase.GridRowToGradeInfoStrings(tvGradeInfo: TcxGridTableView;aStringList: TStringList; chr: char);
var
  I,J: Integer;
  str:string;
begin
   aStringList.Clear;

   with tvGradeInfo.DataController do
   begin
     i := FocusedRowIndex;
     begin
       str:='';
       for J := 1 to 6 do    // Iterate
       begin
         if not varisnull(Values[I,J]) then
           if tvGradeInfo.Columns[J].DataBinding.ValueTypeClass = TcxIntegerValueType then
              str := str+inttostr(Values[I,J])+chr
           else
             str:= str+Values[I,J]+chr
         else
           if tvGradeInfo.Columns[J].DataBinding.ValueTypeClass = TcxIntegerValueType then
              str := str+inttostr(0)+chr
           else
           	str := str+chr;
       end;    // for

       str := str+chr+'0'+chr;
//       FillGradeInfoString(str);
       aStringList.add(str);
     end;    // for
   end;    // with

end;

procedure TfrmBase.SetupGradeInfoGrid(GradeInfoStrings: TStringList;tvGradeInfo: TcxGridTableView; chr: char);
var
  i:integer;
  GradeInfo:TGradeInfo;
begin
  with tvGradeInfo do
  begin
    tvGradeInfo.BeginUpdate;
    tvGradeInfo.DataController.RecordCount := GradeInfoStrings.Count;
    for i:=0 to GradeInfoStrings.Count-1 do
    begin
      StrToGradeInfo(GradeInfoStrings.Strings[i],GradeInfo,chr);
      tvGradeInfo.DataController.Values[i,1] := GradeInfo.ID;
      tvGradeInfo.DataController.Values[i,2] := GradeInfo.ObjStr;
      tvGradeInfo.DataController.Values[i,3] := GradeInfo.StandardValue;
      tvGradeInfo.DataController.Values[i,4] := GradeInfo.EQText;
      tvGradeInfo.DataController.Values[i,5] := GradeInfo.Points;
      tvGradeInfo.DataController.Values[i,6] := GradeInfo.Exp;
    end;
    tvGradeInfo.EndUpdate;
  end;
end;

procedure TfrmBase.FillGridRowWithGradeInfo(GradeInfoStrings: TStringList;tvGradeInfo: TcxGridTableView; chr: char);
var
  i:integer;
  GradeInfo:TGradeInfo;
begin
  with tvGradeInfo do
  begin
    tvGradeInfo.BeginUpdate;
    i := tvGradeInfo.DataController.FocusedRowIndex;
    begin
      StrToGradeInfo(GradeInfoStrings.Strings[0],GradeInfo,chr);
      tvGradeInfo.DataController.Values[i,1] := GradeInfo.ID;
      tvGradeInfo.DataController.Values[i,2] := GradeInfo.ObjStr;
      tvGradeInfo.DataController.Values[i,3] := GradeInfo.StandardValue;
      tvGradeInfo.DataController.Values[i,4] := GradeInfo.EQText;
      tvGradeInfo.DataController.Values[i,5] := GradeInfo.Points;
      tvGradeInfo.DataController.Values[i,6] := GradeInfo.Exp;
    end;
    tvGradeInfo.EndUpdate;
  end;
end;

//function TfrmBase.StringsToVairant(strings: TStrings): Variant;
//var
//  strStream:TStringStream;
//begin
//  Result := '';
//  strStream := TStringStream.Create('');
//  try
//    strings.SaveToStream(strStream);
//    strStream.Position :=0;
//    Result := strStream.ReadString(strStream.Size);
//  finally
//    strStream.Free;
//  end;
//end;

//procedure TfrmBase.AssignValueToRichEdit(value: Variant; ARichEdit: TJvRichEdit);
//var
//  stream : TStringStream;
//begin
//  stream := TStringStream.Create(value);
//  try
//    ARichEdit.Lines.LoadFromStream(stream);
//  finally
//    stream.Free;
//  end;
//
//end;
procedure TfrmBase.fraTree1tvTreeFocusedRecordChanged(
  Sender: TcxCustomGridTableView; APrevFocusedRecord,
  AFocusedRecord: TcxCustomGridRecord; ANewItemRecordFocusingChanged: Boolean);
begin

  if not ( CurrentFormAction in [faAppend,faModify]) then
     FormAction(faBrowse,fraTree1.gvStListst_no.EditValue);
    //FormAction(faBrowse,dmMain.stSt.FieldByName('st_no').AsString);
end;

procedure TfrmBase.fraTree1tvTreeCanFocusRecord(Sender: TcxCustomGridTableView;
  ARecord: TcxCustomGridRecord; var AAllow: Boolean);
begin
 if CurrentFormAction in [faAppend,faModify] then
 begin
   aallow := false;
   application.MessageBox('你正在改变数据，必须保存或取消！','警告：');
 end;

end;

procedure TfrmBase.LoadStUseInfo(ds:TADODataSet;aAction: TFormMode);
var
  rn: Integer;
  I: Integer;
  fieldname:string;
begin
  fieldname:=ModelIDtoName(aAction);
  rn:=ds.RecordCount;
  SetLength(StUseInfo,rn);
  SetLength(StUseInfoName,rn);
  CurrentStUseInfoItem:=-1;
  ds.First;
  for I := 0 to rn - 1 do
  begin
    StUseInfo[i]:=TStringList.Create;
    try
       StUseInfoName[i]:=ds.FieldValues['名称'];
       StUseInfo[i].DelimitedText:=ds.FieldValues[fieldname];
       if ds.FieldValues['是否选用'] then
          CurrentStUseInfoItem:=i;
    except
      application.MessageBox('获取试题选用记录发生错误！','警告');
    end;
    ds.Next;
  end;
end;

procedure TfrmBase.SetCurrentStUseInfo();
var
  I: Integer;
  rn: Integer;
begin
  fraTree1.gvStList.BeginUpdate;
  rn := fraTree1.gvStList.DataController.RecordCount;
  if CurrentStUseInfoItem >= 0 then
  begin
    for I := 0 to rn - 1 do
    begin
      if (StUseInfo[CurrentStUseInfoItem].IndexOf(fraTree1.gvStList.DataController.Values[I, 1]) >= 0) then
        fraTree1.gvStList.DataController.Values[I, 0] := true
      else
        fraTree1.gvStList.DataController.Values[I, 0] := false;
    end;
  end;
  fraTree1.gvStList.EndUpdate;
end;

procedure TfrmBase.SetModule(AModuleFileName:TFileName);
var
   delegateGetModuleName:FngetModuleDllName;
   delegateGetModuleButtonText: FnGetModuleButtonText;
   delegateGetPrefix : FnGetModulePreFix;
   delegateGetModuleDocName : FnGetModuleDocName;
   delegateGetModuleDelimiterChar : FnGetModuleDelimiterChar;
begin
  if AModuleFileName <> NULL_STR then begin
      if FModule=nil then  FModule:= TModuleInfo.Create;
      FModule.FillModuleInfo(AModuleFileName);
  end;
end;

function TfrmBase.ModelIDtoName(aAction: TFormMode):string;
begin
  case aAction of
    SINGLESELECT_MODEL:
      Result := '单项选择题';
    MULTISELECT_MODEL:
      Result := '多项选择题';
    TYPE_MODEL:
      Result := '打字题';
    WINDOWS_MODEL:
      Result := 'WIN操作题';
    WORD_MODEL:
      Result := 'Word操作题';
    EXCEL_MODEL:
      Result := 'Excel操作题';
    POWERPOINT_MODEL:
      Result := 'Ppt操作题';
  end;
end;

end.










