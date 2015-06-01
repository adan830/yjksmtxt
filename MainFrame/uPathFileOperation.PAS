{{
管理文件目录的各种操作及访问
}
unit uPathFileOperation;

interface

uses
  classes, SysUtils, Forms;

type
  TPathFile = class;

  TPathFileClass = class of TPathFile;

  TFindCallBack = procedure (const Filename : string; const Info : TSearchRec; var bQuit,bSub:boolean);

  {
  处理文件及目录的各种操作
  }
  TPathFile = class (TObject)
  public
      {找到path目录下的所有文件，如果bSub为真，还会找到所有的目录，放在PathNames里}
    class procedure FindFiles(const path : String; FileNames : TStrings;
            PathNames : TStrings = nil;
            const filename : string = '*.*'; clearOld : boolean = false;
            Proc : TFindCallBack = nil; bSub : boolean = false;
            const bMsg : boolean = true);
  end;
  

implementation

{{
处理文件及目录的各种操作
}
{
********************************** TPathFile ***********************************
}
class procedure TPathFile.FindFiles(const path : String; FileNames : TStrings;
            PathNames : TStrings = nil;
            const filename : string = '*.*'; clearOld : boolean = false;
            Proc : TFindCallBack = nil; bSub : boolean = false;
            const bMsg : boolean = true);
var
  fpath: string;
  info: TsearchRec;
  Quit: Boolean;
  
  procedure ProcessAFile;
  begin
    if (info.Name<>'.') and (info.Name<>'..') and ((info.Attr and faDirectory)<>faDirectory) then
    begin
    if assigned(proc) then
      proc(fpath+info.FindData.cFileName,info,quit,bsub);
    end;
    FileNames.Add(fpath+info.FindData.cFileName);
  end;
  
  procedure ProcessADirectory;
  begin
    if (info.Name<>'.') and (info.Name<>'..') and ((info.attr and fadirectory)=fadirectory) then
    begin
      if Assigned(PathNames) then
        PathNames.Add(fPath + info.Name);
      
      findfiles(fpath+info.Name,FileNames, PathNames, FileName, false, proc, bsub, bmsg);
    end;
  end;
  
begin
  if clearOld then
    FileNames.Clear;
  
  if path[length(path)]<>'\' then
    fpath:=path+'\'
  else
    fpath:=path;
  try
    if 0=findfirst(fpath+filename,faanyfile and (not fadirectory),info) then
    begin
      ProcessAFile;
      while 0=findnext(info) do
      begin
        ProcessAFile;
        if bmsg then application.ProcessMessages;
      end;
    end;
  finally
    findclose(info);
  end;
  
  try
    if bsub and (0=findfirst(fpath+'*',faanyfile,info)) then
      begin
        ProcessADirectory;
        while findnext(info)=0 do
          ProcessADirectory;
      end;
  finally
    findclose(info);
  end;
end;


end.
