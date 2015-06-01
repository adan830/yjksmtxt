unit WindowsTest;

interface

uses
   Classes, SysUtils, ExamGlobal;

   function GetModuleDllName() : string; stdcall;
   function GetModulePrefix() : string; stdcall;
   function GetModuleDocName() : string; stdcall;
   function GetModuleButtonText(): string; stdcall;
   function GetModuleDelimiterChar() : Char; stdcall;
   procedure OpenAction(AHandle:THandle;APath:string;ADocName:TFileName=NULL_STR); stdcall;


implementation
uses ShellAPI, Windows;
   function GetModuleDllName() : string; stdcall;
   begin
      Result := 'Windows';
   end;
   function GetModulePrefix() : string; stdcall;
   begin
      Result := 'D';
   end;
   function GetModuleDocName() : string; stdcall;
   Begin
      result := NULL_STR;
   End;
   function GetModuleButtonText(): string; stdcall;
   begin
      Result := '打开考生文件夹';
   end;
   function GetModuleDelimiterChar() : Char; stdcall;
   begin
      Result := ',';
   end;
   procedure OpenAction(AHandle:THandle;APath:string;ADocName:TFileName=NULL_STR); stdcall;
   begin
      ShellExecute(
      AHandle,	// handle to parent window
      'open',	// pointer to string that specifies operation to perform
      pchar(APath),	// pointer to filename or folder name string
      '',	// pointer to string that specifies executable-file parameters
      pchar(APath),	// pointer to string that specifies default directory
      SW_SHOWNORMAL 	// whether file is shown when opened
     );
   end;
end.
