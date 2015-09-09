library WindowsModule;

{ Important note about DLL memory management: ShareMem must be the
  first unit in your library's USES clause AND your project's (select
  Project-View Source) USES clause if your DLL exports any procedures or
  functions that pass strings as parameters or function results. This
  applies to all strings passed to and from your DLL--even those that
  are nested in records and classes. ShareMem is the interface unit to
  the BORLNDMM.DLL shared memory manager, which must be deployed along
  with your DLL. To avoid using BORLNDMM.DLL, pass string information
  using PChar or ShortString parameters. }

uses
 {$IFDEF DEBUG}
   FastMM4,
 {$ENDIF}
//  Windows,
  SysUtils,
  Classes,
  WindowsTest in 'WindowsModule\WindowsTest.pas',
  WindowsGrade in 'WindowsModule\WindowsGrade.pas';

{$R *.res}
exports
   GetModuleDllName,
   GetModulePrefix,
   GetModuleDocName,
   GetModuleButtonText,
   GetModuleDelimiterChar,
   OpenAction,
   FillGrades;

//var
//  OldDllProc: TDLLProc;
//
//  procedure ThisDllProc(Reason: Integer);
//begin
//  if Reason = DLL_THREAD_ATTACH then
//      IsMultiThread := True;
//  if Assigned(OldDllProc) then
//      OldDllProc(Reason);
//  end;

begin
//
//  OldDllProc := DllProc;
//  DllProc := ThisDllProc;
//  ThisDllProc(DLL_PROCESS_ATTACH);
end.
