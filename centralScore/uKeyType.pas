unit uKeyType;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ComCtrls, ExtCtrls;

type
  TTypeForm1 = class(TForm)
    SourceRich: TRichEdit;
    targetRich: TRichEdit;
    ExitBitBtn: TBitBtn;
    Timer1: TTimer;
    Edit1: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    procedure ExitBitBtnClick(Sender: TObject);
    procedure targetRichKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure targetRichKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SourceRichKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
    fFlag: boolean;
    fCurrentPos: integer;
//    fLength: integer;
    FTime:integer;
    
  public
    { Public declarations }
     fSource: string;
     fTarget: string;
 
  end;

var
  TypeForm1: TTypeForm1;

implementation

uses udmMain,  publicunit;

{$R *.dfm}

procedure TTypeForm1.ExitBitBtnClick(Sender: TObject);
var
  i,wordnum,correctnum:integer;
  RichStream:TMemoryStream;
begin
   visible:=false;

  dm1.FilterQuery.Active:=false;
  dm1.FilterQuery.Parameters.ParamByName('v_stno').Value:='C%';
  dm1.filterquery.active:=true;
  dm1.filterquery.First;
  RichStream:=TMemoryStream.Create;
  try
    TargetRich.Lines.SaveToStream(RichStream);
//    targetRich.Lines.SaveToFile('k:\type.txt');
    RichStream.Position:=0;
    dm1.FilterQuery.Edit;
    dm1.FilterQueryst_hj.LoadFromStream(RichStream);
    dm1.FilterQueryst_da.AsString:=inttostr(FTime);
    dm1.FilterQuery.Post;
  finally
    RichStream.Free;
  end;
 //  wordnum:=0;
   correctnum:=0;
   for i :=1  to length(TargetRich.Text)  do
   begin
     if TargetRich.Text[i]=SourceRich.Text[i] then
     begin
       correctnum:=correctnum+1;
     end;
   end;
   wordnum:=length(sourcerich.Text);
   
   wordnum:=round((correctnum/wordnum)*10);
   if wordnum<0 then
   begin
      wordnum:=0;
   end;

   //PublicUnit.UpdateScoreInfo(TYPE_MODEL,dm1.FilterQueryst_no.AsString+',1,type,'+inttostr(wordnum)+',,-1,');
   ModalResult:=1;
   //mainform.Visible:=true;
   timer1.Enabled:=false;
end;

procedure TTypeForm1.targetRichKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  cursorpos:Integer;
begin
  cursorpos:=targetRich.SelStart;
  while fCurrentPos<cursorpos do
  begin
    with targetRich do
    if (targetRich.Text[fCurrentPos+1]>=char($a0)) then
    begin
      if (SourceRich.Text[fCurrentPos+1]=targetRich.Text[fCurrentPos+1]) and (SourceRich.Text[fCurrentPos+2]=targetRich.Text[fCurrentPos+2]) then
      begin
           SelStart:=fCurrentPos;
           SelLength:=2;
           SelAttributes.Color:=clBlue;
      end
      else
      begin
           SelStart:=fCurrentPos;
           SelLength:=2;
           SelAttributes.Color:=clRed;
      end;
      fCurrentPos:=fCurrentPos+2;
    end
    else
    begin
      if (SourceRich.Text[fCurrentPos+1]=targetRich.Text[fCurrentPos+1]) then
      begin
         SelStart:=fCurrentPos;
         SelLength:=1;
         SelAttributes.Color:=clBlue;
      end
      else
      begin
         SelStart:=fCurrentPos;
         SelLength:=1;
         SelAttributes.Color:=clRed;
      end;
      fCurrentPos:=fCurrentPos+1;
    end;

  end;
  targetRich.SelStart:=cursorpos;
  fCurrentpos:=targetRich.SelStart;
  
end;

procedure TTypeForm1.FormShow(Sender: TObject);
var
  RichStream:TMemoryStream;
begin
  dm1.FilterQuery.Active:=false;
  dm1.FilterQuery.Parameters.ParamByName('v_stno').Value:='C%';
  dm1.filterquery.active:=true;
  dm1.filterquery.First;
  RichStream:=TMemoryStream.Create;
  try
    dm1.filterquerySt_lr.SaveToStream(RichStream);
    RichStream.Position:=0;
    SourceRich.Lines.LoadFromStream(RichStream);
    RichStream.Clear;
    dm1.FilterQueryst_hj.SaveToStream(RichStream);
    RichStream.Position:=0;
    TargetRich.Lines.LoadFromStream(RichStream);
    if dm1.FilterQueryst_da.asstring='' then
      FTime:=900
    else
      FTime:=strtoint(dm1.FilterQueryst_da.asstring);

  finally
    RichStream.Free;
  end;

  fFlag:=false;
  fCurrentPos:=0;
  ExitBitBtnClick(self);
 // FTime:=900;
 // timer1.Enabled:=true;
end;

procedure TTypeForm1.Timer1Timer(Sender: TObject);
var
  sj:string;
begin
  FTime:=FTime-1;
  if (FTime>-5) and (Ftime<0) then
  begin
    ExitBitBtnClick(self);
    application.MessageBox('打字时间已用完，系统自动返回主界面！','提示：',MB_OK);

    
  end;
  sj:=format('还剩 %.2d 分 %.2d 秒',[FTime div 60,FTime mod 60]);
  edit1.Text:=sj ;

end;

procedure TTypeForm1.targetRichKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
if ((ssctrl in shift) and (key=86 ))or((ssshift in shift) and (key=45 )) then
    key:=32;
end;

procedure TTypeForm1.SourceRichKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
//if ((ssctrl in shift) and ((key=86 )or (key=88)))or((ssshift in shift) and (key=45 )) or (key=vk_delete) or(key=vk_back) then
    key:=32;
    
end;

end.
