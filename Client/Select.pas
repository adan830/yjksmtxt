unit Select;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, DBCtrls, ComCtrls, ImgList,db,
  Buttons, JvExStdCtrls, JvRichEdit, JvExExtCtrls, JvRadioGroup ;

type
  TSelectForm = class(TForm)
    TreeView1: TTreeView;
    ImageList1: TImageList;
    RadioGroup1: TRadioGroup;
    GroupBox1: TGroupBox;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    btReturn: TBitBtn;
    btnAnswer: TBitBtn;
    edtEQContent: TJvRichEdit;
    lblCodeText: TLabel;
    pnlTitle: TPanel;
    lblTime: TLabel;
    pnl1: TPanel;
    pnl2: TPanel;
    lbl1: TLabel;
    procedure btnReturnClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure TreeView1GetImageIndex(Sender: TObject; Node: TTreeNode);
    procedure TreeView1Change(Sender: TObject; Node: TTreeNode);
    procedure TreeView1Changing(Sender: TObject; Node: TTreeNode;
      var AllowChange: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnAnswerClick(Sender: TObject);
  private
//    procedure CreateParams(var Params: TCreateParams);  override;

    { Private declarations }
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  public
    procedure InitTreeView();
    procedure destroyTreeView();
    { Public declarations }
  end;


implementation

uses
  ExamClientGlobal, uDispAnswer, ExamGlobal,
  DataFieldConst,DataUtils, ADODB, tq, ClientMain,StrUtils;

{$R *.dfm}


//procedure TSelectForm.CreateParams(var Params: TCreateParams);
//begin
//  inherited   CreateParams( Params );
//  with Params do
//  begin
//   // {$IFNDEF DEBUG}
//    Style :=WS_BORDER+WS_MAXIMIZE 	;             //ws_overlapped+      params.ExStyle:=ws_ex_topmost;
//    ExStyle := WS_EX_TOOLWINDOW   ;
//    WndParent :=TExamClientGlobal.ClientMainForm.Handle;   // mainform.Handle;    //父窗体为form1
//    Self.Left :=0;
//    Self.Top :=0;
//    Self.AutoSize :=False;
//    //{$ENDIF}
//  end;
//end;

procedure TSelectForm.btnReturnClick(Sender: TObject);
var
  i,j:integer;
  mynode:PTQTreeNode;
begin
   treeview1.Selected:=nil;
   j:=0;
   for i:=0 to treeview1.Items.Count-1 do
   begin
     mynode:=PTQTreeNode(treeview1.Items[i].Data);
     if mynode^.TQ.St_no<>'' then
     begin
       if mynode^.ksda='' then
         j:=j+1;
     end;
   end;
   if j>0 then
   begin
     if application.MessageBox(pchar('你还有'+inttostr(j)+'小题没有回答，真的要返回主界面吗？'),'提示：',MB_YESNO)=6 then
     begin
        modalresult:=1;
        destroyTreeview;
        TExamClientGlobal.ClientMainForm.Visible:=true;
     end;
   end
   else
   begin
      modalresult:=1;
      destroyTreeview;
      TExamClientGlobal.ClientMainForm.Visible:=true;
   end;  
end;

procedure TSelectForm.CreateParams(var Params: TCreateParams);
begin
  inherited;
  with Params do
  begin
    Style :=ws_overlapped;
    params.ExStyle:=params.exstyle or ws_ex_topmost;
    //WndParent:=mainform.Handle;
    WndParent :=GetDesktopWindow;//0;   //     //父窗体为桌面
  end;
end;

procedure TSelectForm.FormShow(Sender: TObject);
begin
  Resizing(wsNormal);
  Caption := TExamClientGlobal.BaseConfig.ExamName + '--客观题';
  pnlTitle.Caption := ' 客观题';
   InitTreeView;
   radiogroup1.Visible:=false;
   groupbox1.Visible:=false;

   if (TExamClientGlobal.BaseConfig.ExamClasify=EXAMENATIONTYPESIMULATION) and (TExamClientGlobal.BaseConfig.ScoreDisplayMode=SCOREDISPLAYMODECLIENT) then
   begin
     btnAnswer.Visible:=true;
   end;
   //
end;

procedure TSelectForm.InitTreeView;
var
  tn1:TTreeNode;
  i,rs:integer;
  mynodePtr:PTQTreeNode;
  ds : TDataSet;
  procedure PopulateItem(codetext:string;des:string;stPrefix:string;stnameprefix:string;tx:Boolean);
  var
    i:Integer;
  begin
    with Treeview1.Items do  begin
      new(mynodePtr);
      mynodePtr^.CodeText := codetext;
      mynodePtr^.TQ := TTQ.Create;
      mynodePtr^.ksda:='';
      mynodePtr^.flag:=false;
      mynodePtr^.txFlag:=true;
      tn1:=Addobject(nil,des,mynodePtr);

      ds := getdatasetbyprefix(stPrefix,TExamClientGlobal.ConnClientDB);
//      ds := TADODataSet.Create(nil);
      try
//        ds.Connection := TExamClientGlobal.ConnClientDB;
//        ds.CommandText := SQLSTR_GETTQDATASET_BY_PREFIX ;
//        ds.Parameters.ParamValues['v_stno']:=stPrefix;
//
//        ds.active:=true;
        rs:=ds.RecordCount;
        DS.First;
        for  i:=1 to rs do
        begin
         with ds do
         begin
          new(mynodePtr);
          mynodePtr.TQ := TTQ.Create;
          TTQ.WriteFieldValuesToTQ(DS,mynodePtr^.TQ);

          mynodePtr^.TQ.UnCompressTQ();
          mynodePtr^.CodeText := stnameprefix+'第'+inttostr(i)+'小题';
          mynodeptr^.txFlag:=tx;
          if FieldValues[DFNTQ_KSDA]=null then
          begin
             mynodePtr^.ksda:='';
             mynodePtr^.flag:=false;
          end
          else
          begin
             mynodePtr^.ksda:=FieldValues[DFNTQ_KSDA];
             mynodePtr^.flag:=true;
          end;
            addchildobject(tn1,'第'+inttostr(i)+'小题',mynodePtr);
          Next;
         end;
        end;
      finally
        ds.Free;
      end;
    end;
  end;
begin
  PopulateItem('请在左边选择试题','单项选择题(每题1分)','A%','单项选择题',true);
  PopulateItem('请在左边选择试题','多项选择题(每题2分)','X%','多项选择题',false);
  TreeView1.FullExpand;
  TreeView1.Select(TreeView1.Items[0]);
end;

procedure TSelectForm.TreeView1GetImageIndex(Sender: TObject;
  Node: TTreeNode);
var
  mynodePtr:PTQTreeNode;
begin
  myNodePtr:=PTQTreeNode(node.Data);
  if mynodePtr.TQ.st_no='' then
  begin
    if Node.Selected then
      Node.SelectedIndex:=3
    else
      Node.ImageIndex:=3
  end
  else
  begin
    if node.Selected then
    begin
        node.SelectedIndex:=1;
    end
    else
    begin
      if myNodePtr.flag then
         node.ImageIndex:=2
      else
         node.ImageIndex:=0;
    end;
  end;   
end;

procedure TSelectForm.TreeView1Change(Sender: TObject; Node: TTreeNode);
var
  mynode:PTQTreeNode;
  s:string;
  i,j:integer;
  pc:pchar;
begin
  if (treeview1.Items.Count>=0) and (treeview1.Selected<>nil) then
  begin
    mynode:=PTQTreeNode(node.Data);
    lblCodeText.Caption := mynode^.CodeText;
    mynode^.TQ.ReadContentToStrings(edtEQContent.Lines);

    if mynode^.txFlag then
    begin
      RadioGroup1.Items.Clear;
      Groupbox1.Visible:=false;
      RadioGroup1.Visible:=False;
      if mynode^.TQ.St_no<>'' then
      begin
        RadioGroup1.Visible:=true;
        RadioGroup1.Items.Add(' A ');
        RadioGroup1.Items.Add(' B ');
        RadioGroup1.Items.Add(' C ');
        RadioGroup1.Items.Add(' D ');
        if mynode^.flag and (mynode^.ksda<>'') then
        begin
          radiogroup1.ItemIndex:=strtoint(mynode^.ksda)-1;
        end;
      end
    end
    else
    begin
      Groupbox1.Visible:=false;
      RadioGroup1.Visible:=false;

      if mynode^.TQ.St_no<>'' then
      begin
         groupbox1.Visible:=true;
          checkbox1.Caption:=' A ';
          checkbox2.Caption:=' B ';
          checkbox3.Caption:=' C ';
          checkbox4.Caption:=' D ';
          for i:=0 to 3 do
          begin
             (groupbox1.Controls[i] as TCheckbox).Checked:=false;
          end;
        if mynode^.flag and (mynode^.ksda<>'') then
        begin
          s:=trim(mynode^.ksda);
          pc:=pchar(s);
          for i:=0 to Length(s)-1 do
          begin
            j:=strtoint(pc[i])-1;                      //在这里要考虑非数值的情况，可能会触发异常
            if (j>=0) and (j<=3) then
               (groupbox1.Controls[j] as TCheckbox).Checked:=true;
          end;
        end;
      end
    end;
  end;
  //Resize;
end;

procedure TSelectForm.TreeView1Changing(Sender: TObject; Node: TTreeNode;
  var AllowChange: Boolean);
var
  mynode:PTQTreeNode;
  bb:string;
  i:integer;
begin
  if (treeview1.Selected <>nil) and (treeview1.Items.Count>=0) then
  begin
  //  bb:=treeview1.Selected.text;
    mynode:=PTQTreeNode(treeview1.Selected.Data);
    if mynode.txFlag then
    begin
      if RadioGroup1.ItemIndex>=0 then
      begin
        mynode^.ksda:=inttostr(RadioGroup1.ItemIndex+1);
        MYNODE^.flag:=true;
      end;
    end
    else
    begin
        bb:='';
        for i:=0 to 3 do
        begin
          if (groupbox1.Controls[i] as TCheckbox).Checked then  bb:=bb+inttostr(i+1);
        end;
        mynode^.ksda:=bb;
        if length(bb)>0 then
          MYNODE^.flag:=true;
    end;
  end;

end;

procedure TSelectForm.destroyTreeView;
var
  tn1:TTreeNode;
  i,nodecount:integer;
  mynode:PTQTreeNode;
  bb:string;
  adsSingle,adsMultic : TDataSet;

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
   adsSingle := getdatasetbyprefix('A%',TExamClientGlobal.ConnClientDB);
   adsMultic := getdatasetbyprefix('X%',TExamClientGlobal.ConnClientDB);
   try
       with TreeView1 do
       begin
          nodecount:=TreeView1.Items.Count;
          for i:=nodecount-1 downto 0 do
          begin
            tn1:=items.item[i];
            mynode:=PTQTreeNode(tn1.Data);
            bb:=items.Item[i].Text;
            if (mynode^.TQ.St_no<>'') and (trim(MyNode^.ksda)<>'') then
            begin
              if strutils.ansileftstr(mynode^.TQ.St_no,1)='A' then   UpdateKsda(adssingle,mynode^.TQ.St_no,mynode^.ksda);
              if strutils.ansileftstr(mynode^.TQ.St_no,1)='X' then   UpdateKsda(adsmultic,mynode^.TQ.St_no,mynode^.ksda);
            end;
            mynode.TQ.Free;
            dispose(PTQTreeNode(tn1.data));
          end;
          treeview1.Items.Clear;
       end;
   finally
       adsSingle.Free;
       adsMultic.Free;
   end;


end;

procedure TSelectForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   treeview1.Selected:=nil;
   modalresult:=1;
   destroyTreeview;
   TExamClientGlobal.ClientMainForm.Visible:=true;
end;

procedure TSelectForm.btnAnswerClick(Sender: TObject);
var
  mynode:PTQTreeNode;
begin
  if (treeview1.Items.Count>=0) and (treeview1.Selected<>nil) then
  begin
    mynode:=PTQTreeNode(treeview1.Selected.Data);
    if mynode^.TQ.St_no<>'' then
      TfrmDispAnswer.ShowForm(mynode);
  end;
end;


end.
