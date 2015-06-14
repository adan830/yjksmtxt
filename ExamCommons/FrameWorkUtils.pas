unit FrameworkUtils;

interface

uses
  System.Classes,FrameTQModule,Commons, Vcl.Controls,Vcl.Forms;
type
//==============================================================================
// 考试Frame相关函数
//==============================================================================
  TFrameTQModuleClass  =  class    of    TFrame;
  function ExamModuleToStPrefix(aExamModule:TExamModule):string;
  function ExamModuleToStPrefixWildCard(aExamModule:TExamModule):string;
  function LoadFrameByClassName(theFrameClass:TFrameTQModuleClass;aOwner:TComponent;em:TExamModule):TFrame;

implementation
  {$REGION '=====Frame相关函数====='}
function LoadFrameByClassName(theFrameClass: TFrameTQModuleClass;aOwner:TComponent;em:TExamModule):TFrame;
begin
//  if Assigned(FCurrentfrm)and( not SameText(theFrameClass.ClassName,FCurrentfrmClassName)) then
//         FreeAndNil(FCurrentfrm);
   Result:=theFrameClass.Create(nil);
   //Result:=theFrameClass.Create(aOwner,em);
   Result.Parent:=aOwner as TWinControl ;
   Result.Align:=alClient;
   Result.Left:=0;//(Panel1.Width-Result.Width)div 2;
   Result.Top:=0;//(Panel1.Height-Result.Height)div 2;
           Result.Show

   //FCurrentfrmClassName:=theFrameClass.ClassName;

end;

function ExamModuleToStPrefix(aExamModule:TExamModule):string;
begin
  case aExamModule of
    EMSINGLESELECT: result:='A';
    EMMULTISELECT: result:='X';
    EMTYPE: result:='C';
    EMWINDOWS: result:='D';
    EMWORD: result:='E';
    EMEXCEL: result:='F';
    EMPOWERPOINT: result:='G';
  end;
end;

function ExamModuleToStPrefixWildCard(aExamModule:TExamModule):string;
begin
  result:= ExamModuleToStPrefix(aExamModule)+CONSTWILDCARD;
end;
end.
