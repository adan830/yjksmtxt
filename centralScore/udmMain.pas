unit udmMain;

interface

uses
  SysUtils, Classes,  ADODB, DB, ExtCtrls;

type
  Tdm1 = class(TDataModule)
    dsKsXxk: TDataSource;
    dsKsstk: TDataSource;
    dsMainFile: TDataSource;
    sysconn: TADOConnection;
    TbKsxxk: TADOTable;
    TbKsStk: TADOTable;
    TbMainFile: TADOTable;
    TbKsStkst_no: TWideStringField;
    TbKsStkst_lr: TMemoField;
    TbKsStkst_item1: TWideStringField;
    TbKsStkst_item2: TWideStringField;
    TbKsStkst_item3: TWideStringField;
    TbKsStkst_item4: TWideStringField;
    TbKsStkst_tx: TBlobField;
    TbKsStkst_da: TWideStringField;
    TbKsStkksda: TWideStringField;
    TbKsStkst_hj: TMemoField;
    TbKsStkst_da1: TMemoField;
    Timer1: TTimer;
    TbMainFileGuid: TAutoIncField;
    TbMainFileFileName: TWideStringField;
    TbMainFileFilestream: TBlobField;
    ksconn: TADOConnection;
    FilterQuery: TADOQuery;
    FilterQueryst_no: TWideStringField;
    FilterQueryst_lr: TMemoField;
    FilterQueryst_item1: TWideStringField;
    FilterQueryst_item2: TWideStringField;
    FilterQueryst_item3: TWideStringField;
    FilterQueryst_item4: TWideStringField;
    FilterQueryst_tx: TBlobField;
    FilterQueryst_da: TWideStringField;
    FilterQueryksda: TWideStringField;
    FilterQueryst_hj: TMemoField;
    FilterQueryst_da1: TMemoField;
    dsFilterQuery: TDataSource;
    TimeUpdateQuery: TADOQuery;
    UpdateScoreQuery: TADOQuery;
    ScoreQuery: TADOQuery;
    dsScoreQuery: TDataSource;
    tkscQuery: TADOQuery;
    tkscQueryst_no: TWideStringField;
    tkscQueryst_lr: TMemoField;
    tkscQueryst_item1: TWideStringField;
    tkscQueryst_item2: TWideStringField;
    tkscQueryst_item3: TWideStringField;
    tkscQueryst_item4: TWideStringField;
    tkscQueryst_da: TWideStringField;
    tkscQueryksda: TWideStringField;
    tkscQueryst_hj: TMemoField;
    tkscQueryst_da1: TMemoField;
    DataSource1: TDataSource;
    tkscQueryst_comment: TMemoField;
    procedure Timer1Timer(Sender: TObject);
   
  private
    { Private declarations }
    
  public
      //这几个这是值由sysconfig表获得，不可更改
      ksName:string;
      ksType:string;  //value:正式考试，模拟考试
      dispScore:string; //客户端，服务器端
      RetryPwd:string;
      ContPwd:string;

      ksxm,kszkh,KsPath:string;
      kssj,ksStatus:integer;
    { Public declarations }

  end;

var
  dm,dm1: Tdm1;


implementation

{$R *.dfm}
//uses main,floatform,forms, Select, KeyType;


procedure Tdm1.Timer1Timer(Sender: TObject);
var
   sj:string;
//   M:integer;
//   cc:boolean;
begin
//   dm.kssj:=dm.kssj-1;
//   if (dm.kssj div 60)=(dm.kssj / 60) then
//   begin
//     TimeUpdateQuery.Parameters.ParamByName('vTime').Value:=dm.kssj;
//     TimeUpdateQuery.Parameters.ParamByName('vZkh').Value:=dm.kszkh;
//     TimeUpdateQuery.ExecSQL;
//   end;
//   sj:=format('%.2d:%.2d',[dm.kssj div 60,dm.kssj mod 60]);
//   mainform.stTime.Caption:=sj;
//   if assigned(FloatWindow) then
//   begin
//     Floatwindow.stTime.caption:=sj;
//     Floatwindow.stTime1.caption:='时间：'+sj;
//   end;
//      
//
//   if dm.kssj=300 then
//   begin
//     application.NormalizeTopMosts;
//     application.MessageBox('还有5分钟考试结束，请保存好文档','警告');
//     application.RestoreTopMosts;
//   end;
//   if dm.kssj<=0 then
//   begin
//     Timer1.Enabled:=false;
//      if floatWindow.Visible then
//      begin
//        floatWindow.ExitBitBtnClick(floatwindow);
//        floatWindow.Visible:=false;
//      end;
//      if SelectForm.Visible then
//      begin
//        SelectForm.btnReturnclick(SelectForm);
//         SelectForm.visible:=false;
//      end;
//
//       if typeForm.visible then
//       begin
//         typeForm.ExitBitBtnClick(typeForm);
//         typeForm.visible:=false;
//       end;
//     mainform.btnJJClick(mainform);
// 
//   end;
end;

end.
