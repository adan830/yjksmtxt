unit uFrameOperate;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, JvExStdCtrls, JvRichEdit,
  Vcl.StdCtrls, Vcl.ExtCtrls, ugrade, tq, CnButtons;

type
  TFrameOperate = class(TFrame)
    pnl2: TPanel;
    pnl3: TPanel;
    mmTQDesp: TMemo;
    pnl4: TPanel;
    pnl6: TPanel;
    edtTQContent: TJvRichEdit;
    btnShowFloatForm: TCnSpeedButton;
    btnGrade: TCnSpeedButton;
    btnOpen: TCnSpeedButton;
    procedure btnShowFloatFormClick(Sender: TObject);
    procedure btnGradeClick(Sender: TObject);
    procedure btnOpenClick(Sender: TObject);
  private
    ModuleInfo: TModuleInfo;
    tq: TTQ;
    procedure GetEQTextByPrefix(APreFix: string; var ATQ: TTQ);


  public
    procedure SetModuleTq(aModuleInfo: TModuleInfo);
    procedure HideFrame;
    procedure ShowFrame;
  end;

implementation

uses
  ExamClientGlobal, DataUtils,uFormOperate,ShellModules,udispanswer,examGlobal;

{$R *.dfm}
{ TFrameOperate }

{ TFrameOperate }

procedure TFrameOperate.SetModuleTq(aModuleInfo: TModuleInfo);
begin
  self.ModuleInfo := aModuleInfo;
  self.tq := TTQ.Create;
  GetEQTextByPrefix(self.ModuleInfo.Prefix, self.tq);

  self.tq.Content.Position := 0;
  edtTQContent.Lines.LoadFromStream(self.tq.Content);

    edtTQContent.SetSelection(0,length( edtTQContent.Text),false);
            edtTQContent.SelAttributes.Height:=14;
            edtTQContent.SelAttributes.Name:='����';
     edtTQContent.SelAttributes.Color:=$00333333;
     edtTQContent.SetSelection(0,0,false);

  if (TExamClientGlobal.BaseConfig.ExamClasify = EXAMENATIONTYPESIMULATION) and (TExamClientGlobal.BaseConfig.ScoreDisplayMode = SCOREDISPLAYMODECLIENT) then
      begin
        btnGrade.Visible                 := true;
      end;
  btnOpen.Caption := moduleInfo.ButtonText;
  if self.ModuleInfo.Name='Windows' then
          mmTQDesp.Text:=EOL+'  ע�����Windows������'+EOL+'     ��������ɾ�������ļ������������޹ص��ļ����ļ��У�����Ӱ�쿼���ɼ��������ø������ڽ���������Բ��������Ӱ��';
  if self.ModuleInfo.Name='Word' then
          mmTQDesp.Text:=EOL+'  ע�����Word������'+EOL+'     �벻Ҫ���޹ص�Word�ĵ�����������,�����ø������ڽ���������Բ��������Ӱ��'+EOL+'     ����Word�ж�����������������²�����';

  if self.ModuleInfo.Name='Excel' then
          mmTQDesp.Text:=EOL+'  ע�����Excel������'+EOL+'     �벻Ҫ���޹ص�Excel�ĵ�����������,�����ø������ڽ���������Բ��������Ӱ��'+EOL+'     ����Excel�ж�����������������²�����';
;

  if self.ModuleInfo.Name='Ppt' then
          mmTQDesp.Text:=EOL+'  ע�����PowerPoint������'+EOL+'     �벻Ҫ���޹ص�PowerPoint�ĵ�����������,�����ø������ڽ���������Բ��������Ӱ��'+EOL+'     ��ʹ��PowerPoint������²�����';

end;

procedure TFrameOperate.ShowFrame;
begin
   Self.Show;
end;

procedure TFrameOperate.btnGradeClick(Sender: TObject);
var
  GradeInfoStrings: TStringList;
  delegateGrade: fnFillGrades;
begin
  @delegateGrade := GetProcAddress(moduleInfo.DllHandle, FN_FILLGRADES);
  GradeInfoStrings := TStringList.Create;
  try
    Tq.StAnswer.Position := 0;
    GradeInfoStrings.LoadFromStream(tq.StAnswer);
    delegateGrade(GradeInfoStrings, TExamClientGlobal.ExamPath, moduleInfo.DocName, nil, fmExamValue, False);
    TfrmDispAnswer.ShowForm(GradeInfoStrings, moduleInfo.DelimiterChar);
  finally
    GradeInfoStrings.Free;
  end;
end;

procedure TFrameOperate.btnOpenClick(Sender: TObject);
var
  kspath: string;
  DllHandle: THandle;
  delegateOpenAction: ProcOpenAction;
begin
  @delegateOpenAction := GetProcAddress(moduleInfo.DllHandle, PROC_OPEN_ACTION);
  delegateOpenAction(Handle, TExamClientGlobal.ExamPath);
end;

procedure TFrameOperate.btnShowFloatFormClick(Sender: TObject);
begin
  if TExamClientGlobal.Floatwindow = nil then
  begin
    TExamClientGlobal.Floatwindow := TFormOperate.Create(self);
    TExamClientGlobal.Floatwindow.FrameWidth:=2;
    //TExamClientGlobal.Floatwindow.Shadowed:=true;
  end;

//  self.Hide;
  texamclientglobal.ClientMainForm.hide;
  texamclientglobal.ClientMainForm.hide;
  TExamClientGlobal.Floatwindow.ShowForm(self.ModuleInfo,self.tq);
end;

procedure TFrameOperate.GetEQTextByPrefix(APreFix: string; var ATQ: TTQ);
var
  stno: string;
begin
  stno := GetTQIDByPreFix(APreFix + '%', TExamClientGlobal.ConnClientDB);
  TTQ.ReadTQByIDAndUnCompress(stno, TExamClientGlobal.ConnClientDB, ATQ);
end;

procedure TFrameOperate.HideFrame;
//var
//  tn1:TTQNode;
//  i,nodecount:integer;
//  mynode:TTQNode;
//  bb:string;
//  adsKs : TDataSet;
//  stprefix:string;
//
//  procedure  UpdateKsda(ADs:TDataSet;ASt_no:string;AKsda:string);
//  begin
//      with ADs do begin
//            if Locate('st_no',ASt_no,[loCaseInsensitive]) then
//            begin
//               Edit;
//               FieldValues['ksda']:=AKsda;
//               post;
//            end ;
//      end;
//  end;
begin
//   stPrefix :=ExamModuleToStPrefixWildCard(TExamModule.EMSINGLESELECT);
//   adsKs:=getdatasetbyprefix(stPrefix,TExamClientGlobal.ConnClientDB);
//   try
//          for i:=tqList.Count-1 downto 0 do
//          begin
////            tn1:=items.item[i];
//            mynode:=tqList[i];
//            if (mynode.TQ.St_no<>'') and (trim(MyNode.ksda)<>'') then
//            begin
//              if System.strutils.ansileftstr(mynode.TQ.St_no,1)='A' then   UpdateKsda(adsKs,mynode.TQ.St_no,mynode.ksda);
////              if strutils.ansileftstr(mynode.TQ.St_no,1)='X' then   UpdateKsda(adsmultic,mynode.TQ.St_no,mynode.ksda);
//            end;
////            mynode.TQ.Free;
////            dispose(PTQTreeNode(tn1.data));
//          end;
//   finally
//       adsKs.Free;
//   end;
   Self.Hide;

end;

end.
