unit ExcelTest;

interface

uses
   uGrade,Classes, SysUtils,ExamGlobal;

   function GetModuleDllName() : string; stdcall;
   function GetModulePrefix() : string; stdcall;
   function GetModuleButtonText(): string; stdcall;
   function GetModuleDocName() : string; stdcall;
   function GetModuleDelimiterChar() : Char; stdcall;
   procedure OpenAction(AHandle:THandle;APath:string;ADocName:TFileName=NULL_STR); stdcall;

const
  DOCNAME = 'Excelst.xls' ;
implementation
uses
   ShellAPI, Windows;

   function GetModuleDllName() : string; stdcall;
   begin
      Result := 'Excel';
   end;
   function GetModulePrefix() : string; stdcall;
   begin
      Result := 'F';
   end;
   function GetModuleDocName() : string; stdcall;
   begin
      Result := DOCNAME;
   end;
   function GetModuleButtonText(): string; stdcall;
   begin
      Result := '打开电子表格';
   end;
   function GetModuleDelimiterChar() : Char; stdcall;
   begin
      Result := '~';
   end;
   procedure OpenAction(AHandle:THandle;APath:string;ADocName:TFileName=NULL_STR); stdcall;
   begin
      if ADocName=NULL_STR then  ADocName := DOCNAME;
      
      ShellExecute(
      Ahandle,	// handle to parent window
      'open',	// pointer to string that specifies operation to perform
      pchar(ADocName),	// pointer to filename or folder name string
      '',	// pointer to string that specifies executable-file parameters
      pchar(APath),	// pointer to string that specifies default directory
      SW_SHOWNORMAL 	// whether file is shown when opened
     );
   end;
end.
