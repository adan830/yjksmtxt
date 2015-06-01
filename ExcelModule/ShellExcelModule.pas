unit ShellExcelModule;

interface

uses
  Classes,Forms,ShellExamCommons;

   function GetModuleName() : string; stdcall;
   function GetModulePrefix() : string; stdcall;

   function ExcelGrade(GradeInfoStrings:TStrings;AFileName:string; AOnProcess:TOnProcess=nil;aMode : integer=0):Integer; stdcall;
const
   ExcelModule = 'ExcelModule.dll';

implementation
   function GetModuleName;          external ExcelModule name 'GetModuleName';
   function GetModulePrefix;        external ExcelModule name 'GetModulePrefix';
   function ExcelGrade;             external ExcelModule name 'Grade';
end.
