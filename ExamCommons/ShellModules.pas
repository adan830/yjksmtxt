unit ShellModules;

interface

uses
  Classes, SysUtils, ExamGlobal, ufrmInProcess;

type
   FnGetModuleDllName         = function() : string; stdcall;
   FnGetModulePreFix          = function() : string; stdcall;
   FnGetModuleDocName         = function() : string; stdcall;
   FnGetModuleButtonText      = function() : string; stdcall;
   FnGetModuleIcon            = function() : string; stdcall;
   FnGetModuleDelimiterChar   = function() : Char; stdcall;

   ProcOpenAction               =procedure(AHandle:THandle;APath:string;ADocName:TFileName=NULL_STR); stdcall;

   //aMode 代表模式 -1表示 填充标准答案值
   // 1 表示填充考试值  ,并评分
//   FnCreateModuleEnvironment  = function(APath:String; EnvironmentStrings:TStringList):Integer; stdcall;
   fnFillGrades                    = function(GradeInfoStrings:TStrings;APath:string;AFileName:string; AOnProcess:TOnProcess=nil;aFillMode : TFillGradeMode = fmExamValue;ANeedCloseDoc:Boolean =true):Integer; stdcall;
const
   FN_GET_MODULE_DLLNAME      = 'GetModuleDllName';
   FN_GET_MODULE_PREFIX       = 'GetModulePrefix';
   FN_GET_MODULE_DOCNAME      = 'GetModuleDocName';
   FN_GET_MODULE_BUTTON_TEXT  = 'GetModuleButtonText';
   FN_GET_MODULE_ICON         = 'GetModuleIcon';
   PROC_OPEN_ACTION           = 'OpenAction';
   FN_GET_MODULE_DELIMITER_CHAR = 'GetModuleDelimiterChar';
//   FN_CREATE_MODULE_ENVIRONMENT= 'CreateModuleEnvironment';
   FN_FILLGRADES           = 'FillGrades';
implementation

end.


