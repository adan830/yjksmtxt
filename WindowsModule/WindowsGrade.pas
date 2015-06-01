unit WindowsGrade;

interface
uses classes,ExamGlobal,uGrade ,ufrmInProcess;
         { TODO -ojp -cwindows : 关于windows操作环境的设置函数是否放到这里？ }
         { TODO -ojp -cwindows : 更改文件属性能否不涉及其它属性？ }
   function FillGrades(GradeInfoStrings:TStrings;APath:string;AFileName:string; AOnProcess:TOnProcess=nil;aFillMode : TFillGradeMode = fmExamValue;ANeedCloseDoc:Boolean =true):Integer; stdcall;
   function GetFileText(filename:string):string;
   procedure  FillGradeInfoItem(var gradeinfo: TGradeInfo;path:string;aFillMode : TFillGradeMode);

implementation
uses system.SysUtils, ExamResourceStrings,ExamException,WindowsTest,Commons;
{ TWinGrade }

procedure FillGradeInfoItem(var gradeinfo: TGradeInfo; path:string;aFillMode : TFillGradeMode); //amode =-1 命题使用
var
  value:string;
begin
  path := path+'\';
  case gradeinfo.ID of    //
    1:  if fileexists(path+gradeinfo.ObjStr)  then
          value := '-1'
        else
          value := '1';
    2: if directoryexists(path+gradeinfo.ObjStr) then
          value := '-1'
        else
          value := '1';
    3: value:=GetFileText(path+gradeinfo.ObjStr);
    4: if fileexists(path+gradeinfo.ObjStr) then
         value := inttostr(FileGetAttr(path+gradeinfo.ObjStr));
       else
         value := 'file not found';
  end;    // case
  if aFillMode= fmStandValue then
  begin
    gradeinfo.StandardValue := Value;
  end
  else
  begin
    gradeinfo.ExamineValue := Value;
    if gradeinfo.StandardValue=gradeinfo.ExamineValue then
      gradeinfo.IsRight := -1
    else
      gradeinfo.IsRight := 1;       
  end;
    
end;

function FillGrades(GradeInfoStrings:TStrings;APath:string;AFileName:string; AOnProcess:TOnProcess=nil;aFillMode : TFillGradeMode = fmExamValue;ANeedCloseDoc:Boolean =true):Integer; stdcall;
var
  I: Integer;
  gradeInfo : TGradeInfo;
begin
   try
       for I := 0 to GradeInfoStrings.Count - 1 do    // Iterate
       begin
         StrToGradeInfo(GradeInfoStrings[i],GradeInfo);
         FillGradeInfoItem(GradeInfo,apath,aFillMode);
         GradeInfoStrings[i] := GradeInfoToStr(GradeInfo);
         if Assigned(AOnProcess) then AOnProcess(Format(RSScoring,['Windows操作题']));
         sleep(100);
       end;    //
   except
       on E:Exception do
         EGradeException.Toss(Format(RsGradeError,[GetModuleDllName,e.Message]));
   end;

end;
function GetFileText(filename:string):string;
var
  sl:TStringList;
begin
  try
    if fileexists(filename)  then
    begin
      sl:=TStringList.Create;
      try
        sl.loadfromfile(filename);
        result:=trim(DelStrChar(sl.text));
      finally
        sl.Free;
      end; 
    end
    else
      result:='NULL';
  except
    result:='NULL';
  end;
end;

end.

