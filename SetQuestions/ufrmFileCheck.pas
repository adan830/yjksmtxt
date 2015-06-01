unit ufrmFileCheck;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cxStyles, cxCustomData, cxGraphics, cxFilter, cxData, cxDataStorage,
  cxEdit, DB, cxDBData, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, ADODB, cxGridLevel, cxClasses, cxControls,
  cxGridCustomView, cxGrid, cxLookAndFeelPainters, StdCtrls, cxButtons, Menus, dxSkinsCore, dxSkinsDefaultPainters, dxSkinscxPCPainter;

type
  TfrmFileCheck = class(TForm)
    tvFileTable: TcxGridDBTableView;
    cxGrid1Level1: TcxGridLevel;
    cxGrid1: TcxGrid;
    adsFileTable: TADODataSet;
    dsFileTable: TDataSource;
    tvFileTableGuid: TcxGridDBColumn;
    tvFileTableFileName: TcxGridDBColumn;
    tvFileTableFilestream: TcxGridDBColumn;
    cxButton1: TcxButton;
    btnCheck: TcxButton;
    Memo1: TMemo;
    btn1: TcxButton;
    edt1: TEdit;
    mmo1: TMemo;
    procedure btnCheckClick(Sender: TObject);
    procedure btn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmFileCheck: TfrmFileCheck;

implementation

uses uDmSetQuestion, uGrade, Commons, LogicExpEval;

{$R *.dfm}

procedure TfrmFileCheck.btn1Click(Sender: TObject);
var
  expEva : TLogicexpeval;
  values : string;
  i: Integer;
  Exp : string;
begin
  expEva := TLogicExpEval.Create;
  try
    SetLength(values,mmo1.Lines.Count);
    for i := 0 to mmo1.Lines.Count -1 do begin
      values[i] := PChar(mmo1.Lines[i])^ ;
    end;
    Exp := edt1.Text ;
    edt1.Text := IntToStr(expEva.Eval(exp,values));
  finally
     expEva.Free;
  end;  
end;

procedure TfrmFileCheck.btnCheckClick(Sender: TObject);
var
  adsSt:TADODataSet;
  strHj:string;
  environmentItem:TEnvironmentItem;
  fileList:variant;
  i:integer;
  filelistcount:integer;
begin
  adsst:=TADODataSet.Create(nil);
  try
    adsSt.Connection:=dmSetQuestion.stkConn;
    adsSt.CommandText:='select * from 试题 where (st_no like '+quotedstr('E%')+
                                             ') or (st_no like '+quotedstr('F%')+
                                             ') or (st_no like '+quotedstr('G%')+')';
    //adsst.Parameters.ParamByName('vstno').Value:='E%';
    adsSt.Active:=true;
    if not adsSt.IsEmpty then
    begin
      adsFileTable.First;
      i:=0;
      filelist:=vararraycreate([0,adsFileTable.RecordCount-1,0,1],varInteger);
      filelistcount:=adsFileTable.RecordCount;
      while not adsFileTable.Eof do
      begin
        filelist[i,0]:=adsFileTable.FieldValues['guid'];
        filelist[i,1]:=0;
        i:=i+1;
        adsFileTable.Next;
      end;

      adsst.First;
      while not adsSt.Eof do
      begin
        strHj:=adsSt.FieldValues['st_hj'];
        if trim(strhj)<>'' then
        begin
          StrToEnvironmentItem(strhj,environmentItem);
          if environmentItem.Value1<>'' then
          begin
            for i:=0 to filelistcount-1 do
            begin
              if filelist[i,0]=environmentItem.Value1 then
              begin
                filelist[i,1]:=-1;
              end;
            end;
          end; 
        end;
        adsst.Next;
      end
    end
    else
    begin
        //hj is empty
    end;

  finally
    adsst.Free;
  end;
  for i:=0 to filelistcount-1 do
  begin
    if (filelist[i,1]<>-1)and (filelist[i,0]<>1) then   //guid=1  为考生数据库，不能删除
    begin
      if adsFileTable.Locate('guid',filelist[i,0],[]) then
      begin
        adsFileTable.Delete;
        memo1.Lines.Add(filelist[i,0]);
      end; 
    end;
       
  end;
end;

end.
