{ -----------------------------------------------------------------------------
Unit Name: I:\Delphi Studio Projects\FrameWork_New\authorization\CommandRegister.pas
Author:    骆平华 Camel_163@163.com
DateTime:  2004-3-9 9:53:50

Purpose:    以前的模块注册都是在每个单元（模块声明的单元）分别由initialization完成的
            后来当模块一多之后，特别是单元之间引用关系复杂化之后，initialization
            的执行顺序成为一个难题，这里将所有的模块注册都转移到本单元，实现统一
            管理，也能够解决initialization块执行顺序的问题 

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

      //根－主方法
  TModuleManager.RegistModule(nil, TfrmMainCommand);

      //登录
  TModuleManager.RegistModule(TfrmMainCommand, TUserLoginCommand);
//
      //权限管理方法
  TModuleManager.RegistModule(TfrmMainCommand, TRoleManagerCommand);
          //权限管理子命令
      TModuleManager.RegistModule(TRoleManagerCommand, TSetPasswordCommand);
      TModuleManager.RegistModule(TRoleManagerCommand, TAddUserCommand);
      TModuleManager.RegistModule(TRoleManagerCommand, TAddSubUserCommand);
      TModuleManager.RegistModule(TRoleManagerCommand, TDelUserCommand);
      TModuleManager.RegistModule(TRoleManagerCommand, TUpdateUserCommand);
//  TModuleManager.RegistModule(TfrmMainCommand, TBackupCommand);
//  TModuleManager.RegistModule(TfrmMainCommand, TRestoreCommand);
//      //日志管理
//  TModuleManager.RegistModule(TfrmMainCommand, TLogManagerCommand);
//
//  //试题录入
//  TModuleManager.RegistModule(TfrmMainCommand, TEqInputCommand);
//    TModuleManager.RegistModule(TEqInputCommand, TEqInputInsertCommand);
//    TModuleManager.RegistModule(TEqInputCommand, TEqInputModifyCommand);
//    TModuleManager.RegistModule(TEqInputCommand, TEqInputDeleteCommand);
//
//  //组卷
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
