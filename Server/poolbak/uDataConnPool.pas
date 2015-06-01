unit uDataConnPool;

interface  

uses
  SysUtils, Classes, DB, ADODB, Contnrs, Windows, ExtCtrls;

type

  TDataConnectionPool = class(TComponent)                   //���ݿ����ӳ���
  private
    fConnParameter : RConnParameter;
    fConnList : TComponentList;
    fCleanTimer : TTimer;

    procedure fCleanOnTime(sender : TObject);

    function fMakeConnStr : String;

    function fCreateADOConn : TADOConnection;
      //�����µĿ�������

    procedure fClean;
      //���� ������ʱ�䲻�õĺͳ�ʱ�䲻�黹�ģ����ģ����ӣ�

    { Private declarations }
  protected
    function getConnCount: Integer;
  public
    { Public declarations }
    property ConnCount: Integer read getConnCount;
    constructor Create(owner : TComponent; connParam : RConnParameter);overload;
    function getConn : TADOConnection;
      //ȡ�ÿ�������
    procedure returnConn(conn : TADOConnection);
      //�黹����
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
    fConnList := TComponentList.Create;               //�������ݿ������б�
    try
      for index := 1 to fConnParameter.ConnMin do     //����С���Ӹ����������ݿ�����
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
    fCleanTimer.Interval := fConnParameter.RefreshTime * 1000;     //�������������ʱ����
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
        if iNow - TADOConnection(fConnList[index]).Tag > 600000 then       //����10���Ӳ�ʹ�õġ��������ӳ���С��Ŀ�Ŀ������ӽ����ͷ�
        begin
          fConnList.Delete(index);
        end;
      end;
    end
    else if TADOConnection(fConnList[index]).Tag < 0 then
         begin
           if iNow + TADOConnection(fConnList[index]).Tag > 3600000 then   //������ʹ�ó���1Сʱ�����ӣ��ܿ����������ӽ������ͷ�
           begin
             fConnList.Delete(index);
             if fConnList.Count < fConnParameter.ConnMin then                                //��С�����ӳ���С��Ŀ���򴴽��µĿ�������
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
      Result.Tag := - GetTickCount;                                      //ʹ�ÿ�ʼ��ʱ ��������ʾ����ʹ�ã�
    end;
  end;

  if (Result = nil) and (index < fConnParameter.ConnMax)  then                             //�޿������ӣ������ӳ���ĿС�����������Ŀ��fMax���������µ�����
  begin
    try
      Result := fCreateADOConn;
      Result.Tag := - GetTickCount;                                      //ʹ��,��ʼ��ʱ ��������ʾ����ʹ�ã�
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


************************************query��************************************
unit UAdoQueryPool;

interface   

uses
  SysUtils, Classes, DB, ADODB, Contnrs, Windows, ExtCtrls, UBase;

type
  TAdoQueryPool = class(TComponent)                   //AdoQuery�������
  private
    fAdoQueryMin : Integer;

    fAdoQueryMax : Integer;

    fAdoQueryList : TComponentList;

    fCleanTimer : TTimer;

    procedure fCleanOnTime(sender : TObject);
      //��ʱ�������

    function fCreateADOQuery : TADOQuery;
      //�����µ�AdoQuery

    procedure fClean;
      //���� ������ʱ�䲻�õĺͳ�ʱ�䲻�黹��AdoQuery��

    { Private declarations }
  protected

  public
    { Public declarations }
    constructor Create(owner : TComponent);  override;
    function getAdoQuery : TADOQuery;
      //ȡ�ÿ�������
    procedure returnAdoQuery(qry : TADOQuery);
      //�黹����
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
    fCleanTimer.Interval := 600 * 1000;     //�������������ʱ����(10����)
    fCleanTimer.OnTimer :=  fCleanOnTime;
    fCleanTimer.Enabled := True;
  end;
end;

procedure TAdoQueryPool.fClean;
var
  iNow : Integer;        //��ǰʱ��
  iCount : Integer;      //List��С
  index : Integer;
begin
  iNow := GetTickCount;
  iCount := fAdoQueryList.Count;
  for index := iCount - 1 downto 0 do
  begin
    if TADOQuery(fAdoQueryList[index]).Tag > 0 then                        //������
    begin
      if  fAdoQueryList.Count > fAdoQueryMin then                          //��AdoQuery����������Сֵ
      begin
        TADOQuery(fAdoQueryList[index]).Free;
      end;
    end
    else if TAdoQuery(fAdoQueryList[index]).Tag < 0 then
         begin
           if iNow + TADOQuery(fAdoQueryList[index]).Tag > 10800000 then   //������ʹ�ó���3Сʱ��AdoQuery���ܿ��������ģ����ͷ�
           begin
             TADOQuery(fAdoQueryList[index]).Free;
             if fAdoQueryList.Count < fAdoQueryMin then                    //��С�ڻ������С��Ŀ���򴴽��µĿ���AdoQuery
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
  Result.Tag := GetTickCount;              //���У���ʼ��ʱ(������ʾ����)
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
      Result.Tag := - GetTickCount;                                      //ʹ�ÿ�ʼ��ʱ ��������ʾ����ʹ�ã�
    end;
  end;

  if (Result = nil) and (index < fAdoQueryMax)  then                             //�޿���AdoQuery�����������ĿС�����������Ŀ��fAdoQueryMax���������µ�Adoquery
  begin
    try
      Result := fCreateADOQuery;
      Result.Tag := - GetTickCount;                                      //ʹ��,��ʼ��ʱ ��������ʾ����ʹ�ã�
      fAdoQueryList.Add(Result);
    except

    end;
  end;

end;

procedure TAdoQueryPool.returnAdoQuery(qry: TADOQuery);
begin
  if fAdoQueryList.IndexOf(qry) > -1 then
  begin
    qry.Tag := GetTickCount;         //��ʼ���м�ʱ
  end;

end;

end.

