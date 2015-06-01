unit SetQuestionGlobal;

interface



//var

     //ClientMainForm: TClientMainForm;
     //GlobalExamTCPClient : TExamTCPClient;
     //GlobalExaminee : TExaminee;

     //GlobalSysConfig : TSysConfig ;
     //GlobalExamPath : string;
     //GlobalLoginType : TLoginType;
     //GlobalDmSetQuestion: TdmSetQuestion;
     //GlobalModules : TModules;
     //GlobalScore : TScoreIni;



implementation

uses
  Role, SysUtils, Forms, ufrmLogin;


procedure InitGlobalObject();
begin
  // CreateUser;
end;



procedure FreeGlobalObject();
begin
//   if Assigned(GlobalSysConfig.Modules) then GlobalSysConfig.Modules.Free;
//   GlobalExamTCPClient.Free;
//   GlobalScore.Free;
end;

initialization
   InitGlobalObject;
   
finalization
   FreeGlobalObject;
end.
