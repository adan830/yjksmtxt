unit uBaseActionForm;
      //这个基础窗体是用来表示数据集处理的窗口，将常用的一些数据处理的事件统一到TFORMACTION事件中
      //
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,adodb, cxContainer, cxEdit, cxClasses, cxStyles, cxGridTableView;

type
   //代表常用数据处理事件
  TFormAction=(faRecChange,faBrowse,faModify,faAppend,faInsert,faSave,faDelete,faCancel);

  TBaseActionForm = class(TForm)
    styleControllerEdit: TcxEditStyleController;
    cxStyleRepository1: TcxStyleRepository;
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
    GridTableViewStyleSheetDevExpress: TcxGridTableViewStyleSheet;
  private
    { Private declarations }
  protected
    CurrentFormAction: TFormAction;   //表示当前状态
    FModelID: Integer;                //模块标识

    setData:TADODataSet;  //动作函数操作的数据集，在子对象中一定要实例化

    procedure InitData;virtual;       //初始化窗体数据
    procedure SetControlState(aAction:TFormAction); virtual;  //设置窗体控件状态

  public
     constructor Create(AOwner: TComponent); override;
    //数据处理事件调用函数
    procedure FormAction(aAction:TFormAction; RecID:string);
    procedure doBrowse(RecID:string);virtual;
    procedure doModify(RecID:String);virtual;
    procedure doSave(RecID:string);virtual;
    procedure doCancel(RecID:string);virtual;

    { Public declarations }
  end;

var
  BaseActionForm: TBaseActionForm;

implementation

{$R *.dfm}

{ TBaseActionForm }

constructor TBaseActionForm.Create(AOwner: TComponent);
begin
  inherited;
  InitData;
end;

procedure TBaseActionForm.doBrowse(RecID: string);
begin

end;

procedure TBaseActionForm.doCancel(RecID: string);
begin

end;

procedure TBaseActionForm.doModify(RecID: String);
begin

end;

procedure TBaseActionForm.doSave(RecID: string);
begin

end;

procedure TBaseActionForm.FormAction(aAction: TFormAction; RecID: string);
begin
  case aAction of    //
    faBrowse:begin  doBrowse(RecID); SetControlState(faBrowse); end;
    faModify: begin doModify(RecID); SetControlState(faModify); end;
    faSave: begin doSave(RecID);   SetControlState(faBrowse); end;
    faCancel:begin doCancel(RecID);  SetControlState(faBrowse); end;
  end;    // case
end;

procedure TBaseActionForm.InitData;
begin
   FormAction(faBrowse,'1');  //这里是第一次设置窗体数据，记录号为 1 不知是否合适，有待验证
   SetControlState(faBrowse);
end;

procedure TBaseActionForm.SetControlState(aAction: TFormAction);
begin

end;



end.




