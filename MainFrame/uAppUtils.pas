{ -----------------------------------------------------------------------------
Unit Name: I:\Delphi Studio Projects\FrameWork_New\System\Utils\uAppUtils.pas
Author:    骆平华 Camel_163@163.com
DateTime:  2004-3-8 12:16:58

Purpose:   应用程序工具单元

OverView:

History:

Todo:

----------------------------------------------------------------------------- }
unit uAppUtils;

interface

uses
  Classes, SysUtils,ufrmInProcess, Forms, DB, uClasses, uPathFileOperation;

type
  TAppUtils = class
  public
    class procedure ClearStringsAndNil(var Strs : TStrings);
    class function AppPath : string;
  end;

  TDBUtils = class;

  TDBUtilsClass = class of TDBUtils;

  TProcessManagerClass = class of TProcessManager;

  TRaiseExceptions = class
  public
    class procedure raiseNotCreateDir(Dir : string; aException : ExceptClass);// = MyException);
  end;

  TUtils = class(TAppUtils)
  private
  public
    class procedure DoBusy(Busy: Boolean);
    class function EncryptionEngine(Src:String; Key:String; Encrypt : Boolean):string;
    class function SysDatabaseFileName : string;
    class procedure MyMessage(Title, Text : string);

    class function DateTimeToStr(const Format: string; DateTime: TDateTime) : string;

    class function TDbUtils : TDBUtilsClass;

    class function TProcessManager : TProcessManagerClass;

    class function TPathFileUtils : TPathFileClass;
  end;

  TDBUtils = class
  public
    class procedure PostDataSet(DataSet : TDataSet);
    class function GetFieldNamesByTable(Table : TDataSet) : TStringList;
    class function ClearDataSet(DataSet : TDataSet) : boolean;
  end;

  TMessageManager = class
  public
    class procedure ShowLogMessage(Msg : string; Caption : string = '应用程序消息');
  end;

  function SelectDatabaseFile(var FileName : string; Ext : string = '*.DBF'; DefaultFileName : string = '') : boolean;
  function SelectPath(var PathName : string; BaseFolder : string = ''; Title : string = '请选择一个目录') : boolean;
  function SaveDatabaseFile(var FileName : string; Ext : string = '*.DBF'; FilterDesc : string = '招生录取系统数据表'; DefaultFileName : string = '') : boolean;

  function GetGUID:string;

implementation

uses
  Controls, MSNPopUp, ufrmMsg, dialogs, Graphics;

{ TUtils }

class function TAppUtils.AppPath: string;
begin
  result := ExtractFilePath(Application.ExeName);
end;

class procedure TAppUtils.ClearStringsAndNil(var Strs: TStrings);
var
  I: Integer;
begin
  if Strs.Count <= 0 then exit;

  for I := (Strs.Count - 1) downto 0 do    // Iterate
  begin
    if Assigned(Strs.Objects[i]) then
      Strs.Objects[i].Free;
  end;    // for

  Strs.Clear;

  FreeAndNil(Strs);
end;

function GetGUID:string;
var
 id:tguid;
begin
 if CreateGUID(id)=s_ok then
  result:=guidtostring(id);
end;

function SelectPath(var PathName : string; BaseFolder : string = ''; Title : string = '请选择一个目录') : boolean;
{
var
  SelectFolder : TRzSelectFolderDialog;
  }
begin
  {SelectFolder := TRzselectFolderDialog.Create(nil);
  try
    SelectFolder.SelectedFolder.PathName := BaseFolder;
    SelectFolder.Title := Title;
    result := SelectFolder.Execute;
    if result then
      PathName := Selectfolder.SelectedPathName;
  finally // wrap up
    SelectFolder.Free;
  end;    // try/finally
  }
end;

function SaveDatabaseFile(var FileName : string; Ext : string = '*.DBF'; FilterDesc : string = '招生录取系统数据表'; DefaultFileName : string = '') : boolean;
var
  SaveDlg : TSaveDialog;
begin
  SaveDlg := TSaveDialog.Create(nil);
  try
    SaveDlg.DefaultExt := Ext;
    SaveDlg.Filter := FilterDesc + '|' + Ext;
    SaveDlg.FileName := DefaultFileName;
    result := SaveDlg.Execute;
    if result then
      FileName := SaveDlg.FileName;

  finally // wrap up
    SaveDlg.Free;
  end;    // try/finally
end;

function SelectDatabaseFile(var FileName : string; Ext : string = '*.DBF'; DefaultFileName : string = '') : boolean;
var
  openDlg: TOpenDialog;
begin
  openDlg := TOpenDialog.Create(nil);
  try
    openDlg.Filter := '招生录取系统数据库文件|' + Ext + '|所有文件(*.*)|*.*';
    openDlg.FileName := DefaultFileName;
    result := openDlg.Execute;
    if result then
      FileName := openDlg.FileName;
  finally // wrap up
    openDlg.Free;
  end;    // try/finally
end;

var
  MSNPopUp : TMSNPopUp;

{ RaiseExceptions }

class procedure TRaiseExceptions.raiseNotCreateDir(Dir: string;
  aException: ExceptClass);
begin
  raise aException.Create('应用程序无法创建程序目录：' + dir + '发生这个错误的原因可能是' +
                               '目标位置不可访问，或者是不可写。');
end;

{ TUtils }

class function TUtils.TDbUtils: TDBUtilsClass;
begin
  result := TDBUtils;
end;

{$J+}
class procedure TUtils.DoBusy(Busy: Boolean);
const
  Times: Integer = 0;
begin
  if Busy then
  begin
    Inc(Times);
    if Times = 1 then Screen.Cursor := crHourGlass;
    //Screen.Cursor := crHourGlass;
  end
  else
  begin
    dec(Times);
    if Times = 0 then Screen.Cursor := crDefault;
    //Screen.Cursor := crDefault;
  end;
end;
{$J-}

class function TUtils.EncryptionEngine(Src, Key: String;
  Encrypt: Boolean): string;
const
  C_Key = 'LuoPinghua';
var
   idx         :integer;
   KeyLen      :Integer;
   KeyPos      :Integer;
   offset      :Integer;
   dest        :string;
   SrcPos      :Integer;
   SrcAsc      :Integer;
   TmpSrcAsc   :Integer;
   Range       :Integer;

begin
  try
    if Src='' then
    begin
      result := '';
      exit;
    end;

       KeyLen:=Length(Key);
       if KeyLen = 0 then key:='Tom Lee';
       KeyPos:=0;
       SrcPos:=0;
       SrcAsc:=0;
       Range:=256;
       if Encrypt then
       begin
            Randomize;
            offset:=Random(Range);
            dest:=format('%1.2x',[offset]);
            for SrcPos := 1 to Length(Src) do
            begin
                 SrcAsc:=(Ord(Src[SrcPos]) + offset) MOD 255;
                 if KeyPos < KeyLen then KeyPos:= KeyPos + 1 else KeyPos:=1;
                 SrcAsc:= SrcAsc xor Ord(Key[KeyPos]);
                 dest:=dest + format('%1.2x',[SrcAsc]);
                 offset:=SrcAsc;
            end;
       end
       else
       begin
            offset:=StrToInt('$'+ copy(src,1,2));
            SrcPos:=3;
            repeat
                  SrcAsc:=StrToInt('$'+ copy(src,SrcPos,2));
                  if KeyPos < KeyLen Then KeyPos := KeyPos + 1 else KeyPos := 1;
                  TmpSrcAsc := SrcAsc xor Ord(Key[KeyPos]);
                  if TmpSrcAsc <= offset then
                       TmpSrcAsc := 255 + TmpSrcAsc - offset
                  else
                       TmpSrcAsc := TmpSrcAsc - offset;
                  dest := dest + chr(TmpSrcAsc);
                  offset:=srcAsc;
                  SrcPos:=SrcPos + 2;
            until SrcPos >= Length(Src);
       end;
       Result:=Dest;
  except
    on e: Exception do
      raise EAppException.Create('密码加密/解密错误，发生这个错误的可能原因是您的密文被人手动更改或者已经不能够正确读取！');
  end;
end;

class procedure TUtils.MyMessage(Title, Text: string);
begin
  MSNPopUp.Text := Text;
  MSNPopUp.Title := Title;
  MSNPopUp.ShowPopUp;
end;

class function TUtils.SysDatabaseFileName: string;
begin
  result := self.AppPath + 'SysDatabase.dat';
end;

class function TUtils.TProcessManager: TProcessManagerClass;
begin
  result := ufrmInProcess.TProcessManager;
end;

class function TUtils.TPathFileUtils: TPathFileClass;
begin
  Result := uPathFileOperation.TPathFile;
end;

class function TUtils.DateTimeToStr(const Format: string;
  DateTime: TDateTime): string;
begin
  SysUtils.DateTimeToString(Result, Format, DateTime);
end;

{ TMessageManager }
class procedure TMessageManager.ShowLogMessage(Msg, Caption: string);
var
  frmMsg: TfrmMsg;
begin
  frmMsg := TfrmMsg.Create(Application);
  try
    frmMsg.Caption := Caption;
    frmMsg.Memo1.Lines.Text := Msg;
    frmMsg.ShowModal;
  finally // wrap up
    frmMsg.Free;
  end;    // try/finally
end;

{ TDBUtils }

class function TDBUtils.ClearDataSet(DataSet: TDataSet): boolean;
begin
  result := false;

  with DataSet do
  begin
    Last;

    while not Bof do
    begin
      DataSet.Delete;

      Prior;
    end;    // while
  end;    // with
end;

class function TDBUtils.GetFieldNamesByTable(Table: TDataSet): TStringList;
var
  I: Integer;
begin
  result := TStringList.Create;
  result.Clear;
  for I := 0 to Table.FieldDefs.Count - 1 do    // Iterate
  begin
    result.Add(Table.FieldDefs[i].Name);
  end;    // for
end;

class procedure TDBUtils.PostDataSet(DataSet: TDataSet);
begin
  if DataSet.State in [dsEdit, dsInsert] then
    DataSet.Post;
end;

initialization
  MSNPopUp := TMSNPopUp.Create(nil);
  MSNPopUp.Options := [msnSystemFont, msnCascadePopups, msnAllowScroll];
  //MSNPopUp.URL := 'http://www.growway.com';
  MSNPopUp.Font.Name := '宋体';
  MSNPopUp.Font.Charset := 134; //GB2312_CHARSET
  MSNPopUp.Font.Size := 9;

  MSNPopUp.HoverFont.Assign(MSNPopUp.Font);
  MSNPopUp.HoverFont.Style := [fsUnderline];

  MSNPopUp.TitleFont.Assign(MSNPopUp.Font);
  MSNPopUp.TitleFont.Style := [fsBold];

finalization
  MSNPopUp.Free;

end.
