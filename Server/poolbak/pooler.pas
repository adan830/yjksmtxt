unit pooler;

interface

Uses
  ComOBJ, ActiveX,  Classes, Syncobjs, Windows, DB, ADODB, ComServ,
  SysUtils ;
TYPE
  Tconnectionpools=Class(Tobject)
private
  Fconnlist:Tlist;
  FMaxcount:integer;
  FTimeout:integer;
  FCriticalsection:Tcriticalsection;
  Fsemaphore:Thandle;
  Fconnectionstring: String;
  FDataBaseUser: string;
  FDataBasePass: string;

  Function GetLock(Index:integer):boolean;
  Procedure ReleaseLock(Index:integer;var Value:Tadoconnection);
  Function CreateNewInstance:TADOconnection;

Public
  Constructor Create;
  Destructor Destroy;override;
  Function Lockconnection:Tadoconnection;
  procedure unlockconnection(var value:Tadoconnection);
  procedure SetconnectionString(Const Value:string);
  procedure SetDatabasePass(const Value:string);
  procedure SetDatabaseUser(const Value:string);

  property Timeout: integer read Ftimeout;
  property Maxcount: integer read FMaxCount;

end;

PRemoteConnection=^TRDM;
TRDM=record
  connection:Tadoconnection;
  InUse:Boolean;
end;

var
  Connectionpools:TConnectionpools;

implementation

Constructor Tconnectionpools.Create;
begin
  Fconnlist:=Tlist.Create;
  Fcriticalsection:=Tcriticalsection.Create;
  Ftimeout:=5000;
  Fmaxcount:=15;
  Fsemaphore:=CreateSemaphore(nil,FmaxCount,FmaxCount,nil);
end;

function Tconnectionpools.CreateNewInstance: TADOconnection;
var
P:PRemoteConnection;
begin
  Result:=nil;
  FcriticalSection.Enter;
    try
    new(p);
    p.connection:=Tadoconnection.Create(nil);
    p.connection.ConnectionString:=Fconnectionstring;
    p.connection.LoginPrompt:=False;
      try
        p.connection.Open(FDataBaseUser,FDataBasePass);
      except
        p.connection.Free;
        dispose(p);
        exit;
      end;
     p.InUse:=True;
     Fconnlist.Add(p);
     Result:=p.connection;
    Finally
     FCriticalSection.Free;
    end;
end;

destructor Tconnectionpools.Destroy;
var
i:integer;
begin
  FcriticalSection.Free;
  for i:=0 to Fconnlist.Count-1 do
    begin
      PRemoteConnection(FConnlist[i]).connection.Free;
      dispose(Fconnlist[i]);
    end;
    Fconnlist.Free;
    closehandle(Fsemaphore);
    inherited Destroy;
end;

function Tconnectionpools.GetLock(Index: integer): boolean;
begin
   Fcriticalsection.Enter;
   try
    Result:=not PRemoteconnection(FConnlist[index]).InUse;
    if Result then
      PRemoteConnection(Fconnlist[index]).InUse:=True;
   finally
    FCriticalSection.Leave;
   end;
end;

function Tconnectionpools.Lockconnection: Tadoconnection;
var
i:integer;
begin
 Result:=nil;
 if WaitForSingleObject(Fsemaphore,Timeout)=WAIT_FAILED then
  raise Exception.Create('The Application Server Is Byse ! ');
  for i:=0 to Fconnlist.Count-1 do
    begin
      if Getlock(i) then
        begin
          Result:=PRemoteConnection(FConnlist[i]).connection;
          Exit;
        end;
    end;
    if Fconnlist.Count<Maxcount then
      Result:=Createnewinstance;
    if Result=nil then
      raise Exception.Create('Unable To Lock Connection ! ');
end;

procedure Tconnectionpools.ReleaseLock(Index: integer;
  var Value: Tadoconnection);
begin
  Fcriticalsection.Enter;
  try
    Premoteconnection(FConnlist[index]).InUse:=False;
//    value:=nil;
    releaseSemaphore(Fsemaphore,1,nil);
  finally
    Fcriticalsection.Leave;
  end;
end;

procedure Tconnectionpools.SetconnectionString(const Value: string);
begin
Fconnectionstring:=value;
end;

procedure Tconnectionpools.SetDatabasePass(const Value: string);
begin
Fdatabasepass:=value;
end;

procedure Tconnectionpools.SetDatabaseUser(const Value: string);
begin
Fdatabaseuser:=value;
end;

procedure Tconnectionpools.unlockconnection(var value: Tadoconnection);
var
i:integer;
begin
 for i:=0 to FConnlist.Count-1 do
  begin
    if value=PRemoteConnection(FConnlist[i]).connection then
    begin
      ReleaseLock(i,Value);
      Break;
    end;
  end;
end;

initialization
  connectionpools:=Tconnectionpools.Create;
Finalization
  connectionpools.Free;
end.

procedure Tlxfile.RemoteDataModuleCreate(Sender: TObject);
begin
try
{ADOConnection.Connected:=False;                     這是以前沒有用到pool的代碼
ADOConnection.ConnectionString:=frmserver.s1;
ADOConnection.Connected:=True;}
//=============================================================================
Adoconnection.Connected:=False;                用到池后﹐我添加的代碼
pooler.Connectionpools.SetconnectionString(frmserver.s1);
pooler.Connectionpools.SetDatabaseUser(frmserver.Username);
pooler.Connectionpools.SetDatabasePass(frmserver.pwd); 
pooler.Tconnectionpools.Create;
//=============================================================================
opendatabase;
frmserver.Bconnect:=True;
//frmserver.listadd(Pclientip,pclientname);
Except
on E:exception do
  begin
  messagedlg('The ADOconnection Connection Faile ! '+#10#13+E.Message,mtError,[mbok],0);
  abort;
  end;
end;

end; 

