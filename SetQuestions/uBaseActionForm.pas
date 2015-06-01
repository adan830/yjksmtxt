unit uBaseActionForm;
      //�������������������ʾ���ݼ�����Ĵ��ڣ������õ�һЩ���ݴ�����¼�ͳһ��TFORMACTION�¼���
      //
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,adodb, cxContainer, cxEdit, cxClasses, cxStyles, cxGridTableView;

type
   //���������ݴ����¼�
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
    CurrentFormAction: TFormAction;   //��ʾ��ǰ״̬
    FModelID: Integer;                //ģ���ʶ

    setData:TADODataSet;  //�����������������ݼ������Ӷ�����һ��Ҫʵ����

    procedure InitData;virtual;       //��ʼ����������
    procedure SetControlState(aAction:TFormAction); virtual;  //���ô���ؼ�״̬

  public
     constructor Create(AOwner: TComponent); override;
    //���ݴ����¼����ú���
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
   FormAction(faBrowse,'1');  //�����ǵ�һ�����ô������ݣ���¼��Ϊ 1 ��֪�Ƿ���ʣ��д���֤
   SetControlState(faBrowse);
end;

procedure TBaseActionForm.SetControlState(aAction: TFormAction);
begin

end;



end.




