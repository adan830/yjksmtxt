unit uFrameSingleSelect;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls,
  uFrameTQButtons, Vcl.StdCtrls, Generics.Collections, ExamGlobal, Vcl.Buttons,
  JvExStdCtrls, JvRichEdit, CnButtons, JvExExtCtrls, JvRadioGroup;

type
  TFrameSingleSelect = class(TFrame)
    pnl1: TPanel;
    pnl2: TPanel;
    pnl3: TPanel;
    pnl4: TPanel;
    pnl6: TPanel;
    edtTQContent: TJvRichEdit;
    grdpnl1: TGridPanel;
    btnNext: TCnSpeedButton;
    btnPrevious: TCnSpeedButton;
    RadioGroup1: TJvRadioGroup;
    mmo1: TMemo;
    frmTqButtonList: TFrameTQButtons;
    btnAnswer: TCnSpeedButton;
    procedure tqButtonClick(Sender: TObject);
    procedure btnPreviousClick(Sender: TObject);
    procedure btnNextClick(Sender: TObject);
    procedure btnAnswerClick(Sender: TObject);

  private
    tqList: TObjectList<TTQNode>;
    currentTQIndex: Integer;
    procedure SetupTqList;

    procedure ShowCurrentTQ(tqIndex: Integer);
    /// <summary>
    /// 保存最后试题答案
    /// </summary>
    procedure SaveCurrentAnswer();

  public
    constructor Create(AOwner: TComponent); override;
    procedure HideFrame;
    procedure ShowFrame;
  end;

implementation

uses
  Data.DB, FrameWorkUtils, DataUtils, Commons, ExamClientGlobal, tq, DataFieldConst, System.StrUtils, uDispAnswer;

{$R *.dfm}
{ TFrameSingleSelect }

procedure TFrameSingleSelect.tqButtonClick(Sender: TObject);
  var
    bb: TCnSpeedButton;
  begin
    bb := Sender as TCnSpeedButton;
    SaveCurrentAnswer;
    ShowCurrentTQ(bb.Tag);
    // Application.MessageBox(PChar(inttostr(bb.Tag)),'hint');
  end;

procedure TFrameSingleSelect.btnAnswerClick(Sender: TObject);
  var
    mynode: TTQNode;
    index:Integer;
  begin
    if currentTQIndex <> -1 then
      begin
         index:=RadioGroup1.ItemIndex ;
        mynode := tqList[currentTQIndex];
        if mynode.tq.St_no <> '' then
          TfrmDispAnswer.ShowForm(mynode);
        RadioGroup1.ItemIndex:=index;
      end;
  end;

procedure TFrameSingleSelect.btnNextClick(Sender: TObject);
  begin
    if currentTQIndex < tqList.Count - 1 then
            begin
            SaveCurrentAnswer;
         ShowCurrentTQ(currentTQIndex + 1);
      end;
  end;

procedure TFrameSingleSelect.btnPreviousClick(Sender: TObject);
  begin
    if currentTQIndex > 0 then
            begin
            SaveCurrentAnswer;
         ShowCurrentTQ(currentTQIndex - 1);
      end;
  end;

constructor TFrameSingleSelect.Create(AOwner: TComponent);
  begin
    inherited;
    currentTQIndex := -1;
    SetupTqList;
    frmTqButtonList.ButtonClickProc := tqButtonClick;
    frmTqButtonList.tqList          := self.tqList;
    frmTqButtonList.ButtonCount     := tqList.Count;
    ShowCurrentTQ(0);
    if (TExamClientGlobal.BaseConfig.ExamClasify = EXAMENATIONTYPESIMULATION) and (TExamClientGlobal.BaseConfig.ScoreDisplayMode = SCOREDISPLAYMODECLIENT) then
      begin
        grdpnl1.ColumnCollection[3].Value := 100;
        btnAnswer.width                   := 80;
        btnAnswer.Visible                 := true;
      end;
  end;

procedure TFrameSingleSelect.SetupTqList;
  var
    i, rs: Integer;
    mynodePtr: TTQNode;
    ds: TDataSet;
    stPrefix: string;
  begin
    tqList   := TObjectList<TTQNode>.Create;
    stPrefix := ExamModuleToStPrefixWildCard(TExamModule.EMSINGLESELECT);
    ds       := getdatasetbyprefix(stPrefix, TExamClientGlobal.ConnClientDB);
    try
      rs := ds.RecordCount;
      ds.First;
      for i := 1 to rs do
        begin
          with ds do
            begin
              mynodePtr    := TTQNode.Create(); // new(mynodePtr);
              mynodePtr.tq := TTQ.Create;
              TTQ.WriteFieldValuesToTQ(ds, mynodePtr.tq);

              mynodePtr.tq.UnCompressTQ();
              mynodePtr.CodeText := '第' + inttostr(i) + '小题:';
              // txFlag:=False;  //已弃用
              if FieldValues[DFNTQ_KSDA] = null then
                begin
                  mynodePtr.ksda := '';
                  mynodePtr.flag := false;
                end
              else
                begin
                  mynodePtr.ksda := FieldValues[DFNTQ_KSDA];
                  mynodePtr.flag := true;
                end;
              tqList.Add(mynodePtr);
              Next;
            end;
        end;
    finally
      ds.Free;
    end;
  end;
procedure TFrameSingleSelect.SaveCurrentAnswer();
var
    currentTq: TTQNode;
  begin
    if (currentTQIndex > -1) then
      begin
        if (RadioGroup1.ItemIndex <> -1) then
          begin
            currentTq      := tqList[currentTQIndex];
            currentTq.ksda := inttostr(RadioGroup1.ItemIndex + 1);
            currentTq.flag := true;
            frmTqButtonList.UpdateCompletedFlag(currentTQIndex, 1);
          end
        else
          frmTqButtonList.UpdateCompletedFlag(currentTQIndex, 3);

      end;
  end;

procedure TFrameSingleSelect.ShowCurrentTQ(tqIndex: Integer);
  var
    currentTq: TTQNode;
  begin


    currentTq      := tqList[tqIndex];
    currentTQIndex := tqIndex;
    // lblCodeText.Caption := currentTq^.CodeText;
    currentTq.tq.ReadContentToStrings(edtTQContent.Lines);
    edtTQContent.Lines[0] := inttostr(currentTQIndex + 1) + '.' + edtTQContent.Lines[0];
    frmTqButtonList.UpdateCompletedFlag(currentTQIndex, 2);
    edtTQContent.SetSelection(0,length( edtTQContent.Text),false);
            edtTQContent.SelAttributes.Height:=14;
            edtTQContent.SelAttributes.Name:='宋体';
     edtTQContent.SelAttributes.Color:=$00333333;
     edtTQContent.SetSelection(0,0,false);
    if currentTq.tq.St_no <> string.Empty then
      begin
        if currentTq.flag and (currentTq.ksda <> '') then
          begin
            RadioGroup1.ItemIndex := strtoint(currentTq.ksda) - 1;
          end
        else
          RadioGroup1.ItemIndex := -1;

      end
  end;

procedure TFrameSingleSelect.ShowFrame;
begin
if currentTQIndex < tqList.Count  then
      ShowCurrentTQ(currentTQIndex);
   Self.Show;
end;

procedure TFrameSingleSelect.HideFrame;
  var
    tn1: TTQNode;
    i, nodecount: Integer;
    mynode: TTQNode;
    bb: string;
    adsKs: TDataSet;
    stPrefix: string;

    procedure UpdateKsda(ADs: TDataSet; ASt_no: string; AKsda: string);
      begin
        with ADs do
          begin
            if Locate('st_no', ASt_no, [loCaseInsensitive]) then
              begin
                Edit;
                FieldValues['ksda'] := AKsda;
                post;
              end;
          end;
      end;

  begin
   SaveCurrentAnswer();
    stPrefix := ExamModuleToStPrefixWildCard(TExamModule.EMSINGLESELECT);
    adsKs    := getdatasetbyprefix(stPrefix, TExamClientGlobal.ConnClientDB);
    try
      for i := tqList.Count - 1 downto 0 do
        begin
          // tn1:=items.item[i];
          mynode := tqList[i];
          if (mynode.tq.St_no <> '') and (trim(mynode.ksda) <> '') then
            begin
              if System.StrUtils.ansileftstr(mynode.tq.St_no, 1) =ExamModuleToStPrefix(TExamModule.EMSINGLESELECT)  then
                UpdateKsda(adsKs, mynode.tq.St_no, mynode.ksda);
              // if strutils.ansileftstr(mynode.TQ.St_no,1)='X' then   UpdateKsda(adsmultic,mynode.TQ.St_no,mynode.ksda);
            end;
          // mynode.TQ.Free;
          // dispose(PTQTreeNode(tn1.data));
        end;
    finally
      adsKs.Free;
    end;
    self.Hide;

  end;

end.


