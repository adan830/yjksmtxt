unit uGrade;
{
   This file is for Examine environment and grade;
}

interface

uses
  Classes, Generics.Collections;
type
   // for environment command to access data table;
  
  TExamModule =(EMSINGLESELECT=0,EMMULTISELECT=1,EMTYPE=2,EMWINDOWS=3,EMWORD=4,EMEXCEL=5,EMPOWERPOINT=6,EMIE=7);

  TGradeInfo = record
    ID:integer;         //评分知识点类型
    ObjStr:string;      //评分对象，关键字符串，或对象的标识
    StandardValue:string;           //评分用标准值
//    ValueType:integer; //代表程序评分参数的实际数据类型
    EQText:string; //试题文字
    Points:integer;    //分值
    Exp:string;        //关系表达式
    ExamineValue:string;  //考生实考值
    IsRight:integer;   //对错
  end;

  //生成考试环境时，用来获取环境参数
  TEnvironmentItem = record
    ID : integer;        //represent command
    Value1 : string;     //parameter value
    Value2 : string;
    Value3 : string;
  end;

  TScoreInfo =record
    EQID:string;          //试题号
    GIID:integer;         //评分知识点类型，仅对操作题有用
    EQText:string;        //试题文字
    Points:integer;       //分值
    Exp:string;           //关系表达式
    ExamineValue:string;  //考生实考值
    IsRight:integer;      //对错
  end;
{$region '------保存考试有效模块信息类型------'}
    TModuleInfo =class
      private
        FFileName:string;      //模块文件名，在装载模块时使用
        FDllHandle : THandle;  //模块装载后的内存模块句柄
                              //以下变量，是从FileName模块运行时动态获取的
        FPrefix:string;        //模块对应试题编号前缀
        FClassify:integer;     //模块对应试题类型常量（操作、选择...)
        FDocName:string;       //模块对应试题文档的文件名
        FName :string;         //模块名
        FButtonText:string;    //模块中对应考试系统中，显示打开文档的按钮文本
        FDelimiterChar : Char; //模块中试题信息使用的分隔符
      public

         //procedure FillModuleInfo(var AModuleInfo: TModuleInfo; AModuleFileName: string);
         procedure FillModuleInfo( AModuleFileName: string);
      public
        property FileName:string  read FFileName write FFileName;
        property DllHandle : THandle  read FDllHandle write FDllHandle;
        property Prefix:string  read FPrefix write FPrefix;
        property Classify:integer  read FClassify write FClassify;
        property DocName:string  read FDocName write FDocName;
        property Name :string  read FName write FName;
        property ButtonText:string read FButtonText write FButtonText;
        property DelimiterChar : Char read FDelimiterChar write FDelimiterChar;
  end;
  //TModules = TList<TModuleInfo>;

   TModules = array of TModuleInfo;
  //从加载模块中获取各种信息
  //procedure FillModuleInfo(var AModuleInfo:TModuleInfo;AModuleFileName:string);

{$endregion '------保存考试有效模块信息类型------'}



implementation

uses
  ShellModules, Windows, ExamGlobal, SysUtils, ExamResourceStrings,
  ExamException;
procedure TModuleInfo.FillModuleInfo(AModuleFileName:string);
var
  delegateGetModuleDelimiterChar: FnGetModuleDelimiterChar;
  delegateGetPrefix: FnGetModulePreFix;
  delegateGetModuleDocName: FnGetModuleDocName;
  delegateGetModuleName: FnGetModuleDllName;
  delegateGetModuleButtonText: FnGetModuleButtonText;
begin
  //with self do
  begin
    FFileName := AModuleFileName;
    FDllHandle := LoadLibrary(PChar(AModuleFileName));
    //GetLastError
    ELoadLibraryException.IfTrue(DllHandle =0 ,Format(RSLoadLibraryError,[AModuleFileName]));
      FClassify := TEST_QUESTION_CLASSIFY_OPERATION;
      //need to be modify
      @delegateGetModuleDocName := GetProcAddress(DllHandle, FN_GET_MODULE_DOCNAME);
      FDocName := delegateGetModuleDocName;
      @delegateGetPrefix := GetProcAddress(DllHandle, FN_GET_MODULE_PREFIX);
      FPrefix := delegateGetPrefix;
      @delegateGetModuleName := GetProcAddress(DllHandle, FN_GET_MODULE_DLLNAME);
      FName := delegateGetModuleName;
      @delegateGetModuleButtonText := GetProcAddress(dllHandle, FN_GET_MODULE_BUTTON_TEXT);
      FButtonText := delegateGetModuleButtonText;
      @delegateGetModuleDelimiterChar := GetProcAddress(dllHandle, FN_GET_MODULE_DELIMITER_CHAR);
      FDelimiterChar := delegateGetModuleDelimiterChar;
  end;
end;
//procedure TModuleInfo.FillModuleInfo(var AModuleInfo:TModuleInfo;AModuleFileName:string);
//var
//  delegateGetModuleDelimiterChar: FnGetModuleDelimiterChar;
//  delegateGetPrefix: FnGetModulePreFix;
//  delegateGetModuleDocName: FnGetModuleDocName;
//  delegateGetModuleName: FnGetModuleDllName;
//  delegateGetModuleButtonText: FnGetModuleButtonText;
//begin
//  with AModuleInfo do
//  begin
//    DllHandle := LoadLibrary(PChar(AModuleFileName));
//    //GetLastError
//    ELoadLibraryException.IfTrue(DllHandle =0 ,Format(RSLoadLibraryError,[AModuleFileName]));
//      Classify := TEST_QUESTION_CLASSIFY_OPERATION;
//      //need to be modify
//      @delegateGetModuleDocName := GetProcAddress(DllHandle, FN_GET_MODULE_DOCNAME);
//      DocName := delegateGetModuleDocName;
//      @delegateGetPrefix := GetProcAddress(DllHandle, FN_GET_MODULE_PREFIX);
//      Prefix := delegateGetPrefix;
//      @delegateGetModuleName := GetProcAddress(DllHandle, FN_GET_MODULE_DLLNAME);
//      Name := delegateGetModuleName;
//      @delegateGetModuleButtonText := GetProcAddress(dllHandle, FN_GET_MODULE_BUTTON_TEXT);
//      ButtonText := delegateGetModuleButtonText;
//      @delegateGetModuleDelimiterChar := GetProcAddress(dllHandle, FN_GET_MODULE_DELIMITER_CHAR);
//      DelimiterChar := delegateGetModuleDelimiterChar;
//  end;
//end;


{ TGradeInfo }



end.
