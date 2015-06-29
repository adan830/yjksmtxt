unit Logger;
// =======================================================================
// ��־�ࣨTLogger�� ver.1.0
// ����� http://blog.sina.com.cn/hblyuhong
// 2014/06/24
// ����1.0�޸�
// PFeng  (http://www.pfeng.org / xxmc01#gmail.com)
// 2012/11/08
// ��־����Լ����
// 0 - Information
// 1 - Notice
// 2 - Warning
// 3 - Error
// =======================================================================

interface

uses Windows, Classes, SysUtils, StdCtrls, ComCtrls, ComObj, Messages;

const
  WRITE_LOG_DIR = 'log\'; // ��¼��־Ĭ��Ŀ¼
  WRITE_LOG_MIN_LEVEL = 0; // ��¼��־����ͼ���С�ڴ˼���ֻ��ʾ����¼
  WRITE_LOG_ADD_TIME = True; // ��¼��־�Ƿ����ʱ��
  WRITE_LOG_TIME_FORMAT = 'hh:nn:ss.zzz'; // ��¼��־���ʱ��ĸ�ʽ
  SHOW_LOG_ADD_TIME = True; // ��־��ʾ�����Ƿ����ʱ��
  SHOW_LOG_TIME_FORMAT = 'yyyy/mm/dd hh:nn:ss.zzz'; // ��־��ʾ���ʱ��ĸ�ʽ
  SHOW_LOG_CLEAR_COUNT = 1000; // ��־��ʾ���������ʾ����

type
  TLogger = class
  private
    FCSLock: TRTLCriticalSection; // �ٽ���
    FFileStream: TFileStream; // �ļ���
    FLogShower: TComponent; // ��־��ʾ����
    FLogName: String; // ��־����
    FEnabled: Boolean;
    FLogFileDir: string; // ��־Ŀ¼
    procedure SetEnabled(const Value: Boolean);
    procedure SetLogFileDir(const Value: string);
    procedure SetLogShower(const Value: TComponent);
  protected
    procedure ShowLog(Log: String; const LogLevel: Integer = 0);
  public
    procedure WriteLog(Log: String; const LogLevel: Integer = 0); overload;
    procedure WriteLog(Log: String; const Args: array of const; const LogLevel: Integer = 0); overload;

    constructor Create;
    destructor Destroy; override;

    // �Ƿ������¼��־
    property Enabled: Boolean read FEnabled write SetEnabled;
    // ��־�ļ�Ŀ¼,Ĭ�ϵ�ǰĿ¼��LogĿ¼
    property LogFileDir: string read FLogFileDir write SetLogFileDir;
    // ��ʾ��־�����
    property LogShower: TComponent read FLogShower write SetLogShower;

  end;

implementation

constructor TLogger.Create;
begin
  InitializeCriticalSection(FCSLock);
  FLogShower := nil;
  LogFileDir := ExtractFilePath(ParamStr(0)) + WRITE_LOG_DIR;
end;

procedure TLogger.WriteLog(Log: String; const Args: array of const; const LogLevel: Integer = 0);
begin
  WriteLog(Format(Log, Args), LogLevel);
end;

procedure TLogger.WriteLog(Log: String; const LogLevel: Integer = 0);
var
  logName: String;
  fMode: Word;
  bytes: TBytes;
begin
  EnterCriticalSection(FCSLock);
  try
    if not Enabled then
      Exit;

    ShowLog(Log, LogLevel); // ��ʾ��־������
    if LogLevel >= WRITE_LOG_MIN_LEVEL then
    begin
      logName := FormatDateTime('yyyymmdd', Now) + '.log';
      if FLogName <> logName then
      begin
        FLogName := logName;
        if FileExists(FLogFileDir + FLogName) then // ����������־�ļ�����
          fMode := fmOpenWrite or fmShareDenyNone
        else
          fMode := fmCreate or fmShareDenyNone;

        if Assigned(FFileStream) then
          FreeAndNil(FFileStream);
        FFileStream := TFileStream.Create(FLogFileDir + FLogName, fMode);
      end;

      FFileStream.Position := FFileStream.Size; // ׷�ӵ����
      case LogLevel of
        0:
          Log := '[Information] ' + Log;
        1:
          Log := '[Notice] ' + Log;
        2:
          Log := '[Warning] ' + Log;
        3:
          Log := '[Error] ' + Log;
      end;
      if WRITE_LOG_ADD_TIME then
        Log := FormatDateTime(WRITE_LOG_TIME_FORMAT, Now) + ' ' + Log + #13#10;

      bytes := TEnCoding.UTF8.GetBytes(Log);
      FFileStream.Write(bytes, Length(bytes));

    end;
  finally
    LeaveCriticalSection(FCSLock);
  end;
end;

procedure TLogger.SetEnabled(const Value: Boolean);
begin
  FEnabled := Value;
end;

procedure TLogger.SetLogFileDir(const Value: string);
begin
  FLogFileDir := Value;
  if not DirectoryExists(FLogFileDir) then
    if not ForceDirectories(FLogFileDir) then
    begin
      raise Exception.Create('��־·��������־������ܱ�����');
    end;
end;

procedure TLogger.SetLogShower(const Value: TComponent);
begin
  FLogShower := Value;
end;

procedure TLogger.ShowLog(Log: String; const LogLevel: Integer = 0);
var
  lineCount: Integer;
  listItem: TListItem;
begin
  if FLogShower = nil then
    Exit;
  if (FLogShower is TMemo) then
  begin
    if SHOW_LOG_ADD_TIME then
      Log := FormatDateTime(SHOW_LOG_TIME_FORMAT, Now) + ' ' + Log;
    lineCount := TMemo(FLogShower).Lines.Add(Log);
    // ���������һ��
    SendMessage(TMemo(FLogShower).Handle, WM_VSCROLL, SB_LINEDOWN, 0);
    if lineCount >= SHOW_LOG_CLEAR_COUNT then
      TMemo(FLogShower).Clear;
  end
  else if (FLogShower is TListBox) then
  begin
    if SHOW_LOG_ADD_TIME then
      Log := FormatDateTime(SHOW_LOG_TIME_FORMAT, Now) + ' ' + Log;
    lineCount := TListBox(FLogShower).Items.Add(Log);
    SendMessage(TListBox(FLogShower).Handle, WM_VSCROLL, SB_LINEDOWN, 0);
    if lineCount >= SHOW_LOG_CLEAR_COUNT then
      TListBox(FLogShower).Clear;
  end
  else if (FLogShower is TListView) then
  begin
    listItem := TListView(FLogShower).Items.Add;
    if SHOW_LOG_ADD_TIME then
      listItem.Caption := FormatDateTime(SHOW_LOG_TIME_FORMAT, Now);
    if Assigned(TListView(FLogShower).SmallImages) and (TListView(FLogShower).SmallImages.Count - 1 >= LogLevel) then
      listItem.ImageIndex := LogLevel; // ���Ը��ݲ�ͬ�ȼ���ʾ��ͬͼƬ
    listItem.SubItems.Add(Log);
    SendMessage(TListView(FLogShower).Handle, WM_VSCROLL, SB_LINEDOWN, 0);
    if TListView(FLogShower).Items.Count >= SHOW_LOG_CLEAR_COUNT then
      TListView(FLogShower).Items.Clear;
  end
  else
    raise Exception.Create('��־�������Ͳ�֧��:' + FLogShower.ClassName);
end;

destructor TLogger.Destroy;
begin
  DeleteCriticalSection(FCSLock);
  if Assigned(FFileStream) then
    FreeAndNil(FFileStream);

end;

end.
