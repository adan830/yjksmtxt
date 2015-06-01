{ -----------------------------------------------------------------------------
Unit Name: I:\Delphi Studio Projects\FrameWork_New\System\uException.pas
Author:     骆平华  Camel_163@163.com
DateTime:  2004-3-6 10:16:01

Purpose:    系统异常处理单元

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
        FDesc := '命令执行错误：' + #13#10 +
                 '错误描述信息为：' + e.Message + #13#10 +
                 '您的用户详细信息为：登录名：';
        if ECommandExecuteExeception(e).User <> nil then
          FDesc := FDesc + ECommandExecuteExeception(e).User.LoginName + '　真实姓名：' + ECommandExecuteExeception(e).User.RealName + #13#10;

        FDesc := FDesc + '命令自描述信息为：' + ECommandExecuteExeception(e).Desc + #13#10 +
                         '您可以通过咨询您的系统管理员来解决本问题。';
      end;

      FDesc := FDesc + #13#10 + '错误来源：系统权限管理模块';
    end;

      //通知所有的异常观察者  这里有LOG管理者
    Notify;
      //显示给用户
    ShowMessage(FDesc);
  end
  else
  begin
    //Application.HandleException(Application);
    //TfrmException.ShowException(e.Message);
    Application.MessageBox(PChar(e.Message), '错误', MB_OK + MB_ICONSTOP + MB_DEFBUTTON2 + MB_TOPMOST);

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
