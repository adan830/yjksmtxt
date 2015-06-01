{ -----------------------------------------------------------------------------
Unit Name: I:\Delphi Studio Projects\FrameWork_New\authorization\CommandRegister.pas
Author:    ��ƽ�� Camel_163@163.com
DateTime:  2004-3-9 9:53:50

Purpose:    ��ǰ��ģ��ע�ᶼ����ÿ����Ԫ��ģ�������ĵ�Ԫ���ֱ���initialization��ɵ�
            ������ģ��һ��֮���ر��ǵ�Ԫ֮�����ù�ϵ���ӻ�֮��initialization
            ��ִ��˳���Ϊһ�����⣬���ｫ���е�ģ��ע�ᶼת�Ƶ�����Ԫ��ʵ��ͳһ
            ����Ҳ�ܹ����initialization��ִ��˳������� 

OverView:

History:

Todo:

----------------------------------------------------------------------------- }
unit CommandRegister;

interface
                                        
uses
  Classes, SysUtils, Role;

implementation

uses
  ufrmMain,  ufrmRoleManager, uAuthAppFactory ;

initialization

      //����������
  TModuleManager.RegistModule(nil, TfrmMainCommand);

      //��¼
  TModuleManager.RegistModule(TfrmMainCommand, TUserLoginCommand);
//
      //Ȩ�޹�����
  TModuleManager.RegistModule(TfrmMainCommand, TRoleManagerCommand);
          //Ȩ�޹���������
      TModuleManager.RegistModule(TRoleManagerCommand, TSetPasswordCommand);
      TModuleManager.RegistModule(TRoleManagerCommand, TAddUserCommand);
      TModuleManager.RegistModule(TRoleManagerCommand, TAddSubUserCommand);
      TModuleManager.RegistModule(TRoleManagerCommand, TDelUserCommand);
      TModuleManager.RegistModule(TRoleManagerCommand, TUpdateUserCommand);
//  TModuleManager.RegistModule(TfrmMainCommand, TBackupCommand);
//  TModuleManager.RegistModule(TfrmMainCommand, TRestoreCommand);
//      //��־����
//  TModuleManager.RegistModule(TfrmMainCommand, TLogManagerCommand);
//
//  //����¼��
//  TModuleManager.RegistModule(TfrmMainCommand, TEqInputCommand);
//    TModuleManager.RegistModule(TEqInputCommand, TEqInputInsertCommand);
//    TModuleManager.RegistModule(TEqInputCommand, TEqInputModifyCommand);
//    TModuleManager.RegistModule(TEqInputCommand, TEqInputDeleteCommand);
//
//  //���
//  TModuleManager.RegistModule(TfrmMainCommand, TManualPaperCommand);
//
//    TModuleManager.RegistModule(TManualPaperCommand, TManualPaperNewPaperCommand);
//    TModuleManager.RegistModule(TManualPaperCommand, TManualPaperNewPaperCommand);
//    TModuleManager.RegistModule(TManualPaperCommand, TManualPaperModifyPaperCommand);
//
//  TModuleManager.RegistModule(TfrmMainCommand, TPaperManagerCommand);
//    TModuleManager.RegistModule(TPaperManagerCommand,TPaperdeleteCommand );
//
//
//  TModuleManager.RegistModule(TfrmMainCommand, TBaseInfoCommand);
//    TModuleManager.RegistModule(TBaseInfoCommand,TEQTypeInfoCommand );
//    TModuleManager.RegistModule(TBaseInfoCommand,TSubInfoCommand );
//    TModuleManager.RegistModule(TBaseInfoCommand,TPointInfoCommand );

  
end.
