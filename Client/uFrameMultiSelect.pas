unit uFrameMultiSelect;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls,
  uFrameTQButtons, Vcl.StdCtrls,Generics.Collections,ExamGlobal, Vcl.Buttons,
  JvExStdCtrls, JvRichEdit, CnButtons, JvExExtCtrls, JvRadioGroup;

type
  TFrameMultiSelect = class(TFrame)
    pnl1: TPanel;
    frmTqButtonList: TFrameTQButtons;
    pnl2: TPanel;
    pnl5: TPanel;
    btn1: TButton;
    pnl3: TPanel;
    pnl4: TPanel;
    pnl6: TPanel;
    edtTQContent: TJvRichEdit;
    btnAnswer: TBitBtn;
    grdpnl1: TGridPanel;
    btnNext: TCnSpeedButton;
    btnPrevious: TCnSpeedButton;
    mmo1: TMemo;
    grdpnlAnswer: TGridPanel;
    chkAnswer1: TCheckBox;
    chkAnswer2: TCheckBox;
    chkAnswer3: TCheckBox;
    chkAnswer4: TCheckBox;
    procedure tqButtonClick(Sender: TObject);
    procedure btn1Click(Sender: TObject);
    procedure btnPreviousClick(Sender: TObject);
    procedure btnNextClick(Sender: TObject);
    procedure btnAnswerClick(Sender: TObject);
  private
    tqList:TObjectList<TTQNode>;
    currentTQIndex:Integer;
    procedure SetupTqList;

    procedure ShowCurrentTQ(tqIndex:Integer);

  public
    constructor Create(AOwner: TComponent); override;
    procedure HideFrame;
  end;

implementation

uses
  Data.DB,FrameWorkUtils,DataUtils,Commons,ExamClientGlobal,tq,DataFieldConst,System.StrUtils,uDispAnswer;

{$R *.dfm}

{ TFrameSingleSelect }

procedure TFrameMultiSelect.tqButtonClick(Sender: TObject);
var
  bb:TcnSpeedButton;
begin
   bb:=Sender as TcnSpeedButton;

   ShowCurrentTQ(bb.Tag);
   //Application.MessageBox(PChar(inttostr(bb.Tag)),'hint');
end;

procedure TFrameMultiSelect.btn1Click(Sender: TObject);
var
  bb:Integer;
begin
   bb:=Random(40);
   tqList[bb].flag:=true;
end;

procedure TFrameMultiSelect.btnAnswerClick(Sender: TObject);
var
  mynode:TTQNode;
begin
  if  currentTQIndex<>-1 then
  begin
    mynode:=tqList[currentTQIndex];
    if mynode.TQ.St_no<>'' then
      TfrmDispAnswer.ShowForm(mynode);
  end;
end;

procedure TFrameMultiSelect.btnNextClick(Sender: TObject);
begin
  if currentTQIndex<tqlist.Count-1 then
    ShowCurrentTQ(currentTQIndex+1);
end;

procedure TFrameMultiSelect.btnPreviousClick(Sender: TObject);
begin
  if currentTQIndex>0 then
    ShowCurrentTQ(currentTQIndex-1);
end;

constructor TFrameMultiSelect.Create(AOwner: TComponent);
begin
  inherited;
  currentTQIndex:=-1;
  SetupTqList;
  frmTqButtonList.ButtonClickProc:=tqButtonClick;
  frmTqButtonList.TQList:=self.tqlist;
  frmTqButtonList.ButtonCount:=tqList.Count;
  ShowCurrentTQ(0);
  if (TExamClientGlobal.BaseConfig.ExamClasify=EXAMENATIONTYPESIMULATION) and (TExamClientGlobal.BaseConfig.ScoreDisplayMode=SCOREDISPLAYMODECLIENT) then
   begin
     btnAnswer.Visible:=true;
   end;
end;

procedure TFrameMultiSelect.SetupTqList;
var
  i,rs:integer;
  mynodePtr:TTQNode;
  ds : TDataSet;
  stPrefix:string;
begin
  tqList:=TObjectList<TTQNode>.Create;
      stPrefix:=ExamModuleToStPrefixWildCard(TExamModule.EMMULTISELECT);
      ds := getdatasetbyprefix(stPrefix,TExamClientGlobal.ConnClientDB);
      try
        rs:=ds.RecordCount;
        DS.First;
        for  i:=1 to rs do
        begin
           with ds do
           begin
                mynodeptr:=TTQNode.Create();   // new(mynodePtr);
                mynodePtr.TQ := TTQ.Create;
                TTQ.WriteFieldValuesToTQ(DS,mynodePtr.TQ);

                mynodePtr.TQ.UnCompressTQ();
                mynodePtr.CodeText := '第'+inttostr(i)+'小题:';
                //txFlag:=False;  //已弃用
                if FieldValues[DFNTQ_KSDA]=null then
                begin
                   mynodePtr.ksda:='';
                   mynodePtr.flag:=false;
                end
                else
                begin
                   mynodePtr.ksda:=FieldValues[DFNTQ_KSDA];
                   mynodePtr.flag:=true;
                end;
                  tqList.Add(mynodePtr);
                Next;
           end;
        end;
      finally
        ds.Free;
      end;
end;

procedure TFrameMultiSelect.ShowCurrentTQ(tqIndex: Integer);
var
  currentTq:TTQNode;
  s:string;
  i,j:integer;
  pc:pchar;
  bb:string;
begin
  if (currentTQIndex>-1) then
  begin
    currentTq:= tqList[currentTQIndex];
    bb:='';
        for i:=0 to 3 do
        begin
          if (grdpnlAnswer.Controls[i] as TCheckBox).Checked then
            bb := bb + inttostr(i + 1);
        end;
        currentTq.ksda := bb;
        if length(bb) > 0 then
        begin
          currentTq.flag := true;
          frmTqButtonList.UpdateCompletedFlag(currentTQIndex, 1);
        end
        else
          frmTqButtonList.UpdateCompletedFlag(currentTQIndex, 3);

  end;


  currentTq:=tqList[tqIndex];
  currentTQIndex:=tqIndex;
  // lblCodeText.Caption := currentTq^.CodeText;
  currentTq.tq.ReadContentToStrings(edtTQContent.Lines);
  edtTQContent.Lines[0]:=IntToStr(currentTQIndex+1)+'.'+edtTQContent.Lines[0];
  frmTqButtonList.UpdateCompletedFlag(currentTQIndex, 2);
  //edtTQContent.Font.Height:=14;
//  edtTQContent.Font.Name:='宋体';
//  edtTQContent.Font.Color:=$00333333;
  if currentTq.TQ.St_no<>'' then
  begin
      chkAnswer1.Checked:=false;
      chkAnswer2.Checked:=false;
      chkAnswer3.Checked:=false;
      chkAnswer4.Checked:=false;
    if currentTq.flag and (currentTq.ksda<>'') then
    begin
      s:=trim(currentTq.ksda);
      pc:=pchar(s);
      for i:=0 to Length(s)-1 do
      begin
        j:=strtoint(pc[i])-1;                      //在这里要考虑非数值的情况，可能会触发异常
        if (j>=0) and (j<=3) then
           (grdpnlAnswer.Controls[j] as TCheckbox).Checked:=true;
      end;
    end;
  end
end;

procedure TFrameMultiSelect.HideFrame;
var
  tn1:TTQNode;
  i,nodecount:integer;
  mynode:TTQNode;
  bb:string;
  adsKs : TDataSet;
  stprefix:string;

  procedure  UpdateKsda(ADs:TDataSet;ASt_no:string;AKsda:string);
  begin
      with ADs do begin
            if Locate('st_no',ASt_no,[loCaseInsensitive]) then
            begin
               Edit;
               FieldValues['ksda']:=AKsda;
               post;
            end ;
      end;
  end;
begin
   stPrefix :=ExamModuleToStPrefixWildCard(TExamModule.EMMULTISELECT);
   adsKs:=getdatasetbyprefix(stPrefix,TExamClientGlobal.ConnClientDB);
   try
          for i:=tqList.Count-1 downto 0 do
          begin
//            tn1:=items.item[i];
            mynode:=tqList[i];
            if (mynode.TQ.St_no<>'') and (trim(MyNode.ksda)<>'') then
            begin
              if System.strutils.ansileftstr(mynode.TQ.St_no,1)='A' then   UpdateKsda(adsKs,mynode.TQ.St_no,mynode.ksda);
//              if strutils.ansileftstr(mynode.TQ.St_no,1)='X' then   UpdateKsda(adsmultic,mynode.TQ.St_no,mynode.ksda);
            end;
//            mynode.TQ.Free;
//            dispose(PTQTreeNode(tn1.data));
          end;
   finally
       adsKs.Free;
   end;
   Self.Hide;

end;

end.
