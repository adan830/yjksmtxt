unit uDataModulePool;

interface

uses
  {$IFDEF Linux}
  Libc, Types, 
  {$ELSE}
  Windows, {$IFDEF VER130}Forms,{$ENDIF} Messages,
  {$ENDIF}
  SysUtils, Classes, SyncObjs;

type

  TObjectEvent = procedure(Sender : TObject; var AObject : TObject) of object;

  TObjectPool = class(TObject)
  private
    CS : TCriticalSection;
    ObjList : TList;
    ObjInUse : TBits;

    FActive : boolean;
    FAutoGrow: boolean;
    FGrowToSize: integer;
    FPoolSize: integer;
    FOnCreateObject: TObjectEvent;
    FOnDestroyObject: TObjectEvent;
    FUsageCount: integer;
    FRaiseExceptions: boolean;
  protected
  public
    constructor Create; virtual;
    destructor Destroy; override;

    procedure Start(RaiseExceptions : boolean = False); virtual;
    procedure Stop; virtual;

    function Acquire : TObject; virtual;
    procedure Release(item : TObject); virtual;

    property Active : boolean read FActive;
    property RaiseExceptions : boolean read FRaiseExceptions write FRaiseExceptions;
    property UsageCount : integer read FUsageCount;
    property PoolSize : integer read FPoolSize write FPoolSize;
    property AutoGrow : boolean read FAutoGrow write FAutoGrow;
    property GrowToSize : integer read FGrowToSize write FGrowToSize;
    property OnCreateObject : TObjectEvent read FOnCreateObject write FOnCreateObject;
    property OnDestroyObject : TObjectEvent read FOnDestroyObject write FOnDestroyObject;
  end;

  TDataModulePool = class;

  TIWDataModuleEvent = procedure(var ADataModule : TDataModule) of Object;

  TDataModulePool = class(TComponent)
  private
    FSetToActive : boolean;
    FPool : TObjectPool;
    FOnCreateDataModule: TIWDataModuleEvent;
    FOnFreeDataModule: TIWDataModuleEvent;
    procedure SetActive(const Value: boolean);
    procedure SetPoolCount(const Value: integer);
    function getVersion: string;
    procedure SetVersion(const Value: string);
    function GetPoolCount: integer;
    function GetActive: boolean;
  protected
    procedure ErrorIfActive;
    procedure ErrorIfNotActive;
    procedure _OnCreateObject(Sender : TObject; var AObject : TObject);
    procedure _OnDestroyObject(Sender : TObject; var AObject : TObject);
    procedure Loaded; override;
  public
    constructor Create(AOwner : TComponent); override;
    destructor Destroy; override;
    function Lock : TDataModule;
    procedure Unlock(var ADataModule : TDataModule);
    function CurrentThreadsInUse : integer;
  published
    property OnCreateDataModule : TIWDataModuleEvent read FOnCreateDataModule write FOnCreateDataModule;
    property OnFreeDataModule : TIWDataModuleEvent read FOnFreeDataModule write FOnFreeDataModule;
    property PoolCount : integer read GetPoolCount write SetPoolCount;

    property Active : boolean read GetActive write SetActive;
    property Version : string read getVersion write SetVersion;
  end;

const
  COMPONENT_VERSION = '2.0.0';


function MakeUniqueDBName(Prefix : string='') : string;

implementation

function MakeUniqueDBName(Prefix : string='') : string;
begin
  if Prefix = '' then
    Prefix := 'DB';
  result := Prefix+IntToStr(GetCurrentThreadId);
end;

{ TIWDataModulePool }

constructor TDataModulePool.Create(AOwner: TComponent);
begin
  inherited;
  FSetToActive := False;
  FPool := TObjectPool.Create;
  FPool.PoolSize := 20;


  FPool.OnCreateObject := _OnCreateObject;
  FPool.OnDestroyObject := _OnDestroyObject;
end;

function TDataModulePool.CurrentThreadsInUse: integer;
begin
  Result := FPool.UsageCount;
end;

destructor TDataModulePool.Destroy;
begin
  if Active then
    Active := False;
  FPool.Free;
  inherited;
end;

procedure TDataModulePool.ErrorIfActive;
begin
  if (not(csDesigning in ComponentState)) and FPool.Active then
    raise EComponentError.Create('You cannot perform this operation on an active TArcDMServerPool');
end;

procedure TDataModulePool.ErrorIfNotActive;
begin
  if not FPool.Active then
    raise EComponentError.Create('You cannot perform this operation on an inactive TArcDMServerPool');
end;

function TDataModulePool.GetActive: boolean;
begin
  Result := FPool.Active;
end;

function TDataModulePool.GetPoolCount: integer;
begin
  Result := FPool.PoolSize;
end;

function TDataModulePool.getVersion: string;
begin
  Result := COMPONENT_VERSION;
end;

procedure TDataModulePool.Loaded;
begin
  inherited;
  if FSetToActive then
  begin
    FPool.Start(true);
    FSetToActive := False;
  end;
end;

function TDataModulePool.Lock: TDataModule;
begin
  ErrorIfNotActive;
  Result := TDataModule(FPool.Acquire);
end;

procedure TDataModulePool.SetActive(const Value: boolean);
begin
  if Value = FPool.Active then
    exit;

  if csLoading in ComponentState then
  begin
    FSetToActive := True;   
  end else
  begin
    if Value then
      FPool.Start(True)
    else
      FPool.Stop;
  end;
end;

procedure TDataModulePool.SetPoolCount(const Value: integer);
begin
  ErrorIfActive;
  FPool.PoolSize := Value;
end;

procedure TDataModulePool.SetVersion(const Value: string);
begin
  // do nothing;
end;


procedure TDataModulePool.Unlock(var ADataModule : TDataModule);
begin
  ErrorIfNotActive;
  FPool.Release(ADataModule);
  ADataModule := nil;
end;

procedure TDataModulePool._OnCreateObject(Sender: TObject;
  var AObject: TObject);
var
  DM : TDataModule;
begin
  DM := nil;
  if Assigned(FOnCreateDataModule) then
    FOnCreateDataModule(DM);
  AObject := DM;
end;

procedure TDataModulePool._OnDestroyObject(Sender: TObject;
  var AObject: TObject);
var
  DM : TDataModule;
begin
  DM := TDataModule(AObject);
  if Assigned(FOnFreeDataModule) then
    FOnFreeDataModule(DM);
  AObject := nil;
end;


{ TObjectPool }

function TObjectPool.Acquire: TObject;
var
  idx : integer;
begin
  Result := nil;
  if not FActive then
  begin
    if FRaiseExceptions then
      raise EAbort.Create('Cannot acquire an object before calling Start')
    else
      exit;
  end;
  CS.Enter;
  try
    Inc(FUsageCount);
    idx := ObjInUse.OpenBit;
    if idx < FPoolSize then // idx = FPoolSize when there are no openbits
    begin
      Result := Objlist[idx];
      ObjInUse[idx] := True;
    end else
    begin
      // Handle the case where the pool is completely acquired.
      if not AutoGrow or (FPoolSize > FGrowToSize) then
      begin
        if FRaiseExceptions then
          raise Exception.Create('There are no available objects in the pool')
        else
          Exit;
      end;
      inc(FPoolSize);
      ObjInUse.Size := FPoolSize;
      FOnCreateObject(Self, Result);
      ObjList.Add(Result);
      ObjInUse[FPoolSize-1] := True;
    end;
  finally
    CS.Leave;
  end;
end;

constructor TObjectPool.Create;
begin
  {$IFDEF CLR}
  inherited;
  {$ENDIF}
  CS := TCriticalSection.Create;
  ObjList := TList.Create;
  ObjInUse := TBits.Create;

  FActive := False;
  FAutoGrow := False;
  FGrowToSize := 20;
  FPoolSize := 20;
  FRaiseExceptions := True;
  FOnCreateObject := nil;
  FOnDestroyObject := nil;
end;

destructor TObjectPool.Destroy;
begin
  if FActive then
    Stop;
  CS.Free;
  ObjList.Free;
  ObjInUse.Free;
  inherited;
end;

procedure TObjectPool.Release(item: TObject);
var
  idx : integer;
begin
  if not FActive then
  begin
    if FRaiseExceptions then
      raise Exception.Create('Cannot release an object before calling Start')
    else
      exit;
  end;
  if item = nil then
  begin
    if FRaiseExceptions then
      raise Exception.Create('Cannot release an object before calling Start')
    else
      exit;
  end;
  CS.Enter;
  try
    idx := ObjList.IndexOf(item);
    if idx < 0 then
    begin
      if FRaiseExceptions then
        raise Exception.Create('Cannot release an object that is not in the pool')
      else
        exit;
    end;
    ObjInUse[idx] := False;

    Dec(FUsageCount);
  finally
    CS.Leave;
  end;
end;

procedure TObjectPool.Start(RaiseExceptions : boolean = False);
var
  i : integer;
  o : TObject;
begin
  // Make sure events are assigned before starting the pool.
  if not Assigned(FOnCreateObject) then
    raise Exception.Create('There must be an OnCreateObject event before calling Start');
  if not Assigned(FOnDestroyObject) then
    raise Exception.Create('There must be an OnDestroyObject event before calling Start');

  // Set the TBits class to the same size as the pool.
  ObjInUse.Size := FPoolSize;

  // Call the OnCreateObject event once for each item in the pool.
  for i := 0 to FPoolSize-1 do
  begin
    o := nil;
    FOnCreateObject(Self,o);
    ObjList.Add(o);
    ObjInUse[i] := False;
  end;

  // Set the active flag to true so that the Acquire method will return values.
  FActive := True;

  // Automatically set RaiseExceptions to false by default.  This keeps
  // exceptions from being raised in threads.
  FRaiseExceptions := RaiseExceptions;
end;

procedure TObjectPool.Stop;
var
  i : integer;
  o : TObject;
begin
  // Wait until all objects have been released from the pool.  After waiting
  // 10 seconds, stop anyway.  This may cause unforseen problems, but usually
  // you only Stop a pool as the application is stopping.  40 x 250 = 10,000
  for i := 1 to 40 do
  begin
    CS.Enter;
    try
      // Setting Active to false here keeps the Acquire method from continuing to
      // retrieve objects.
      FActive := False;
      if FUsageCount = 0 then
        break;
    finally
     CS.Leave;
    end;
    // Sleep here to allow give threads time to release their objects.
    Sleep(250);
  end;

  CS.Enter;
  try
    // Loop through all items in the pool calling the OnDestroyObject event.
    for i := 0 to FPoolSize-1 do
    begin
      o := ObjList[i];
      if Assigned(FOnDestroyObject) then
        FOnDestroyObject(Self, o)
      else
        o.Free;
    end;

    // clear the memory used by the list object and TBits class.
    ObjList.Clear;
    ObjInUse.Size := 0;

    FRaiseExceptions := True;
  finally
    CS.Leave;
  end;
end;

end.
