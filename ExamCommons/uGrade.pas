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
    ID:integer;         //����֪ʶ������
    ObjStr:string;      //���ֶ��󣬹ؼ��ַ����������ı�ʶ
    StandardValue:string;           //�����ñ�׼ֵ
//    ValueType:integer; //����������ֲ�����ʵ����������
    EQText:string; //��������
    Points:integer;    //��ֵ
    Exp:string;        //��ϵ���ʽ
    ExamineValue:string;  //����ʵ��ֵ
    IsRight:integer;   //�Դ�
  end;

  //���ɿ��Ի���ʱ��������ȡ��������
  TEnvironmentItem = record
    ID : integer;        //represent command
    Value1 : string;     //parameter value
    Value2 : string;
    Value3 : string;
  end;

  TScoreInfo =record
    EQID:string;          //�����
    GIID:integer;         //����֪ʶ�����ͣ����Բ���������
    EQText:string;        //��������
    Points:integer;       //��ֵ
    Exp:string;           //��ϵ���ʽ
    ExamineValue:string;  //����ʵ��ֵ
    IsRight:integer;      //�Դ�
  end;
{$region '------���濼����Чģ����Ϣ����------'}
    TModuleInfo =class
      private
        FFileName:string;      //ģ���ļ�������װ��ģ��ʱʹ��
        FDllHandle : THandle;  //ģ��װ�غ���ڴ�ģ����
                              //���±������Ǵ�FileNameģ������ʱ��̬��ȡ��
        FPrefix:string;        //ģ���Ӧ������ǰ׺
        FClassify:integer;     //ģ���Ӧ�������ͳ�����������ѡ��...)
        FDocName:string;       //ģ���Ӧ�����ĵ����ļ���
        FName :string;         //ģ����
        FButtonText:string;    //ģ���ж�Ӧ����ϵͳ�У���ʾ���ĵ��İ�ť�ı�
        FDelimiterChar : Char; //ģ����������Ϣʹ�õķָ���
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
  //�Ӽ���ģ���л�ȡ������Ϣ
  //procedure FillModuleInfo(var AModuleInfo:TModuleInfo;AModuleFileName:string);

{$endregion '------���濼����Чģ����Ϣ����------'}



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
