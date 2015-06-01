unit uDataConnPool;

interface  

uses
  SysUtils, Classes, DB, ADODB, Contnrs, Windows, ExtCtrls;

type

  TDataConnectionPool = class(TComponent)                   //数据库连接池类
  private
    fConnParameter : RConnParameter;
    fConnList : TComponentList;
    fCleanTimer : TTimer;

    procedure fCleanOnTime(sender : TObject);

    function fMakeConnStr : String;

    function fCreateADOConn : TADOConnection;
      //创建新的空闲连接

    procedure fClean;
      //清理 （清理长时间不用的和长时间不归还的（死的）连接）

    { Private declarations }
  protected
    function getConnCount: Integer;
  public
    { Public declarations }
    property ConnCount: Integer read getConnCount;
    constructor Create(owner : TComponent; connParam : RConnParameter);overload;
    function getConn : TADOConnection;
      //取得空闲连接
    procedure returnConn(conn : TADOConnection);
      //归还连接
  end;


implementation

constructor TDataConnectionPool.Create(owner : TComponent; connParam : RConnParameter);
var
  index: Integer;
begin
  inherited Create(owner);
  fConnParameter.ConnMin := connParam.ConnMin;
  fConnParameter.ConnMax := connParam.ConnMax;
  fConnParameter.RefreshTime := connParam.RefreshTime;
  fConnParameter.dbUser := connParam.dbUser;
  fConnParameter.dbPass := connParam.dbPass;
  fConnParameter.dbSource := connParam.dbSource;

  if fConnList = nil then
  begin
    fConnList := TComponentList.Create;               //创建数据库连接列表
    try
      for index := 1 to fConnParameter.ConnMin do     //创最小连接个数个建数据库连接
      begin
        fConnList.Add(fCreateADOConn);
      end;
    except

    end;
  end;

  if fCleanTimer = nil then
  begin
    fCleanTimer := TTimer.Create(Self);
    fCleanTimer.Name := 'MyCleanTimer1';
    fCleanTimer.Interval := fConnParameter.RefreshTime * 1000;     //清理程序启动的时间间隔
    fCleanTimer.OnTimer :=  fCleanOnTime;
    fCleanTimer.Enabled := True;
  end;




end;

procedure TDataConnectionPool.fClean;
var
  iNow : Integer;
  iCount : Integer;
  index : Integer;
begin
  iNow := GetTickCount;
  iCount := fConnList.Count;
  for index := iCount - 1 downto 0 do
  begin
    if TADOConnection(fConnList[index]).Tag > 0 then
    begin
      if  fConnList.Count > fConnParameter.ConnMin then
      begin
        if iNow - TADOConnection(fConnList[index]).Tag > 600000 then       //超过10分钟不使用的、大于连接池最小数目的空闲连接将被释放
        begin
          fConnList.Delete(index);
        end;
      end;
    end
    else if TADOConnection(fConnList[index]).Tag < 0 then
         begin
           if iNow + TADOConnection(fConnList[index]).Tag > 3600000 then   //被连续使用超过1小时的连接（很可能是死连接将被）释放
           begin
             fConnList.Delete(index);
             if fConnList.Count < fConnParameter.ConnMin then                                //若小于连接池最小数目，则创建新的空闲连接
             begin
               fConnList.Add(fCreateADOConn);
             end;
           end;
         end
  end;
end;

procedure TDataConnectionPool.fCleanOnTime(sender: TObject);
begin
  fClean;
end;

function TDataConnectionPool.fCreateADOConn: TADOConnection;
begin
  Result := TADOConnection.Create(Self);
  Result.ConnectionString := fMakeConnStr;
  Result.LoginPrompt := False;
  Result.Open;
  Result.Tag := GetTickCount;
end;

function TDataConnectionPool.fMakeConnStr: String;
begin
  Result := 'Provider=MSDAORA.1;Password=' + fConnParameter.dbPass +
            ';User ID=' + fConnParameter.dbUser +
            ';Data Source=' + fConnParameter.dbSource + ';Persist Security Info=True';
end;

function TDataConnectionPool.getConn: TADOConnection;
var
  index : Integer;
begin
  Result := nil;
  for index := 0 to fConnList.Count - 1 do
  begin
    if TADOConnection(fConnList[index]).Tag > 0 then
    begin
      Result := TADOConnection(fConnList[index]);
      Result.Tag := - GetTickCount;                                      //使用开始计时 （负数表示正在使用）
    end;
  end;

  if (Result = nil) and (index < fConnParameter.ConnMax)  then                             //无空闲连接，而连接池数目小于允许最大数目（fMax），创建新的连接
  begin
    try
      Result := fCreateADOConn;
      Result.Tag := - GetTickCount;                                      //使用,开始计时 （负数表示正在使用）
      fConnList.Add(Result);
    except

    end;
  end;

end;

function TDataConnectionPool.getConnCount: Integer;
begin
  Result := fConnList.Count;
end;

procedure TDataConnectionPool.returnConn(conn: TADOConnection);
begin
  if fConnList.IndexOf(conn) > -1 then
  begin
    conn.Tag := GetTickCount;
  end;


end;

end.


************************************query池************************************
unit UAdoQueryPool;

interface   

uses
  SysUtils, Classes, DB, ADODB, Contnrs, Windows, ExtCtrls, UBase;

type
  TAdoQueryPool = class(TComponent)                   //AdoQuery缓冲池类
  private
    fAdoQueryMin : Integer;

    fAdoQueryMax : Integer;

    fAdoQueryList : TComponentList;

    fCleanTimer : TTimer;

    procedure fCleanOnTime(sender : TObject);
      //按时整理缓冲池

    function fCreateADOQuery : TADOQuery;
      //创建新的AdoQuery

    procedure fClean;
      //整理 （清理长时间不用的和长时间不归还的AdoQuery）

    { Private declarations }
  protected

  public
    { Public declarations }
    constructor Create(owner : TComponent);  override;
    function getAdoQuery : TADOQuery;
      //取得空闲连接
    procedure returnAdoQuery(qry : TADOQuery);
      //归还连接
  end;


implementation

{ TAdoQueryPool }

constructor TAdoQueryPool.Create(owner: TComponent);
var
  index : Integer;
  aAdoQuery : TADOQuery;
begin
  inherited ;
  fAdoQueryMin := 10;
  fAdoQueryMax := 100;
  fAdoQueryList := TComponentList.Create(False);
  for index := 1 to fAdoQueryMin do
  begin
    fAdoQueryList.Add(fCreateADOQuery);
  end;

  if fCleanTimer = nil then
  begin
    fCleanTimer := TTimer.Create(Self);
    fCleanTimer.Name := 'MyCleanTimer1';
    fCleanTimer.Interval := 600 * 1000;     //清理程序启动的时间间隔(10分钟)
    fCleanTimer.OnTimer :=  fCleanOnTime;
    fCleanTimer.Enabled := True;
  end;
end;

procedure TAdoQueryPool.fClean;
var
  iNow : Integer;        //当前时刻
  iCount : Integer;      //List大小
  index : Integer;
begin
  iNow := GetTickCount;
  iCount := fAdoQueryList.Count;
  for index := iCount - 1 downto 0 do
  begin
    if TADOQuery(fAdoQueryList[index]).Tag > 0 then                        //若空闲
    begin
      if  fAdoQueryList.Count > fAdoQueryMin then                          //若AdoQuery个数大于最小值
      begin
        TADOQuery(fAdoQueryList[index]).Free;
      end;
    end
    else if TAdoQuery(fAdoQueryList[index]).Tag < 0 then
         begin
           if iNow + TADOQuery(fAdoQueryList[index]).Tag > 10800000 then   //被连续使用超过3小时的AdoQuery（很可能是死的），释放
           begin
             TADOQuery(fAdoQueryList[index]).Free;
             if fAdoQueryList.Count < fAdoQueryMin then                    //若小于缓冲池最小数目，则创建新的空闲AdoQuery
             begin
               fAdoQueryList.Add(fCreateADOQuery);
             end;
           end;
         end
  end;
end;

procedure TAdoQueryPool.fCleanOnTime(sender: TObject);
begin
  fClean;
end;

function TAdoQueryPool.fCreateADOQuery: TADOQuery;
begin
  Result := TADOQuery.Create(Self);
  Result.Tag := GetTickCount;              //空闲，开始计时(正数表示空闲)
end;

function TAdoQueryPool.getAdoQuery: TADOQuery;
var
  index : Integer;
begin
  Result := nil;
  for index := 0 to fAdoQueryList.Count - 1 do
  begin
    if TADOQuery(fAdoQueryList[index]).Tag > 0 then
    begin
      Result := TADOQuery(fAdoQueryList[index]);
      Result.Tag := - GetTickCount;                                      //使用开始计时 （负数表示正在使用）
    end;
  end;

  if (Result = nil) and (index < fAdoQueryMax)  then                             //无空闲AdoQuery，而缓冲池数目小于允许最大数目（fAdoQueryMax），创建新的Adoquery
  begin
    try
      Result := fCreateADOQuery;
      Result.Tag := - GetTickCount;                                      //使用,开始计时 （负数表示正在使用）
      fAdoQueryList.Add(Result);
    except

    end;
  end;

end;

procedure TAdoQueryPool.returnAdoQuery(qry: TADOQuery);
begin
  if fAdoQueryList.IndexOf(qry) > -1 then
  begin
    qry.Tag := GetTickCount;         //开始空闲计时
  end;

end;

end.

