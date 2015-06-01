unit ShellPptModule;

interface

uses
  Classes,Forms,ShellExamCommons;

   function GetModuleName() : string; stdcall;
   function GetModulePrefix() : string; stdcall;

   function PptGrade(GradeInfoStrings:TStrings;AFileName:string; AOnProcess:TOnProcess=nil;aMode : integer=0):Integer; stdcall;
const
   PptModule = 'PptModule.dll';

implementation
   function GetModuleName;          external PptModule name 'GetModuleName';
   function GetModulePrefix;        external PptModule name 'GetModulePrefix';
   function PptGrade;               external PptModule name 'Grade';
end.
