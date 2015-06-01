{ -----------------------------------------------------------------------------
Unit Name: I:\Delphi Studio Projects\FrameWork_New\System\uException.pas
Author:     ��ƽ��  Camel_163@163.com
DateTime:  2004-3-6 10:16:01

Purpose:    ϵͳ�쳣����Ԫ

OverView:

History:

Todo:
----------------------------------------------------------------------------- }
unit uException;

interface

uses
  Classes, Forms, SysUtils, uPattern, uClasses;

type

  TExceptionHandle = class(TSubject, ISelfDescription)
  private
  protected
    FDesc : string;

    procedure ProcessExceptions(e : Exception);
  public
    constructor Create; override;
    destructor Destroy; override;

      //ISelfDescription
    function ToString : string;

    procedure HandleException(Sender: TObject; E: Exception);

    class function ExceptionHandle : TExceptionHandle;
  end;


implementation

uses
  Dialogs, Role, ufrmException, Windows;

var
  FExceptionHandle : TExceptionHandle;

{ TExceptionHandle }

constructor TExceptionHandle.Create;
begin
  inherited;

//  if TLogManager.LogManager <> nil then
//    self.AddListener(TLogManager.LogManager);
end;

destructor TExceptionHandle.Destroy;
begin

  inherited;
end;

class function TExceptionHandle.ExceptionHandle: TExceptionHandle;
begin
  Result := FExceptionHandle;
end;

procedure TExceptionHandle.HandleException(Sender: TObject; E: Exception);
begin
  ProcessExceptions(E);
end;

procedure TExceptionHandle.ProcessExceptions(e: Exception);
begin
  if e is EAppException then
  begin
    FDesc := e.Message;

    if e is ERoleException then
    begin
      if e is ECommandExecuteExeception then
      begin
        FDesc := '����ִ�д���' + #13#10 +
                 '����������ϢΪ��' + e.Message + #13#10 +
                 '�����û���ϸ��ϢΪ����¼����';
        if ECommandExecuteExeception(e).User <> nil then
          FDesc := FDesc + ECommandExecuteExeception(e).User.LoginName + '����ʵ������' + ECommandExecuteExeception(e).User.RealName + #13#10;

        FDesc := FDesc + '������������ϢΪ��' + ECommandExecuteExeception(e).Desc + #13#10 +
                         '������ͨ����ѯ����ϵͳ����Ա����������⡣';
      end;

      FDesc := FDesc + #13#10 + '������Դ��ϵͳȨ�޹���ģ��';
    end;

      //֪ͨ���е��쳣�۲���  ������LOG������
    Notify;
      //��ʾ���û�
    ShowMessage(FDesc);
  end
  else
  begin
    //Application.HandleException(Application);
    //TfrmException.ShowException(e.Message);
    Application.MessageBox(PChar(e.Message), '����', MB_OK + MB_ICONSTOP + MB_DEFBUTTON2 + MB_TOPMOST);

  end;
end;

function TExceptionHandle.ToString: string;
begin
  Result := FDesc;
end;

initialization
  FExceptionHandle := TExceptionHandle.Create;
  Application.OnException := FExceptionHandle.HandleException;
  
finalization
  FExceptionHandle.Free;
  
end.
