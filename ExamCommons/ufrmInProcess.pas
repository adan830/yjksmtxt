unit ufrmInProcess;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ImgList, ExtCtrls ;

type
   TOnProcess = procedure(AMessage:string;AStep:Integer=1);
   POnProcess = ^TOnProcess;

  TfrmInProcess = class(TForm)
    Panel1: TPanel;
    lbInfo: TLabel;
    pb: TProgressBar;
    Shape1: TShape;
    btnCancel: TButton;
    Image1: TImage;
    lblCaption: TLabel;
    procedure btnCancelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    FApp:TApplication;
    FCanceled: boolean;
    function GetInfo: string;
    procedure SetInfo(const Value: string);
    function GetMax: integer;
    function GetMin: integer;
    function GetPosition: integer;
    procedure SetMax(const Value: integer);
    procedure SetMin(const Value: integer);
    procedure SetPosition(const Value: integer);
    { Private declarations }
  public
    { Public declarations }
    constructor Create(AOwner: TComponent;AApp:TApplication);
    property Info : string read GetInfo write SetInfo;
    property Min : integer read GetMin write SetMin;
    property Max : integer read GetMax write SetMax;
    property Position : integer read GetPosition write SetPosition;

    property Canceled : boolean read FCanceled write FCanceled;

  end;

  TProcessManager = class
  public
    class function BeginProcess(Info : string; Min, Max, Position : integer) : integer;
    class procedure OnProcess(Handle : integer; Info : string; Position : integer; var Canceled : boolean; ShowPosition : boolean = false);
    class procedure EndProcess(Handle : integer);
  end;

   function PMBeginProcess(AApp:TApplication;ATitle:string;Info : string; Min, Max, Position : integer) : integer;//stdcall;
   procedure PMOnProcess(Handle : integer; Info : string=''; step : integer=1;  ShowPosition : boolean = false);//stdcall;     // var Canceled : boolean =false;
   procedure PMEndProcess(Handle : integer);//stdcall;



implementation

{$R *.dfm}

{ TfrmInProcess }

function TfrmInProcess.GetInfo: string;
begin
  result := lbInfo.Caption;
end;

function TfrmInProcess.GetMax: integer;
begin
  result := pb.Max;
end;

function TfrmInProcess.GetMin: integer;
begin
  result := pb.Min;
end;

function TfrmInProcess.GetPosition: integer;
begin
  result := pb.Position
end;

procedure TfrmInProcess.SetInfo(const Value: string);
begin
  lbInfo.Caption := value;
  FApp.ProcessMessages;
end;

procedure TfrmInProcess.SetMax(const Value: integer);
begin
  pb.Max := Value;
end;

procedure TfrmInProcess.SetMin(const Value: integer);
begin
  pb.Min := Value;
end;

procedure TfrmInProcess.SetPosition(const Value: integer);
begin
  pb.Position := value;
  FApp.ProcessMessages;
end;

{ TProcessManager }

function PMBeginProcess(AApp:TApplication;ATitle:string;Info: string; Min, Max,
  Position: integer): integer;
var
  frmInProcess: TfrmInProcess;
begin
  frmInProcess := TfrmInprocess.Create(nil,AApp);
  frmInProcess.lblCaption.Caption := ATitle;
  frmInProcess.Info := Info;
  frmInProcess.Min := Min;
  frmInProcess.FApp := AApp;
  if Max < Min then
    Max := Min;

  frmInProcess.Max := Max;
  frmInProcess.Position := Position;
  result := integer(frmInProcess);

  frmInProcess.btnCancel.Enabled := false;
  
  frmInProcess.Show;

  AApp.ProcessMessages;
end;

procedure PMEndProcess(Handle: integer);
var
  frmInProcess: TfrmInProcess;
begin
  frmInProcess := TfrmInProcess(Handle);
  frmInProcess.btnCancel.Enabled := false;
  frmInProcess.Free;
end;

procedure PMOnProcess(Handle: integer; Info: string='';
  step: integer =1; ShowPosition : boolean = false);      //var Canceled : boolean =false;
var
  frmInProcess: TfrmInProcess;
begin
  if Handle>0 then
  begin
    frmInProcess := TfrmInProcess(Handle);
    if Info <> '' then
      frmInProcess.Info := Info;

//    if ShowPosition then
//      frmInProcess.Info := frmInProcess.Info + '£¨' + IntToStr(frmInProcess.pb.Position) + '\' + IntToStr(frmInProcess.pb.Max) + '£©';

    if not frmInProcess.btnCancel.Enabled then
      frmInProcess.btnCancel.Enabled := true;

 //   if Position <> -1 then
//      frmInProcess.Position := Position
//    else
      frmInProcess.pb.StepBy(step);

    frmInProcess.FApp.ProcessMessages;

  //  if frmInProcess.Canceled then
  //    Canceled := true;
  end;     
end;

procedure TfrmInProcess.btnCancelClick(Sender: TObject);
begin
  Canceled := true;
end;

constructor TfrmInProcess.Create(AOwner: TComponent; AApp: TApplication);
begin
   inherited Create(AOwner);
   FApp:= AApp;
end;

procedure TfrmInProcess.FormCreate(Sender: TObject);
begin
  Canceled := false;
end;

{ TProcessManager }

class function TProcessManager.BeginProcess(Info: string; Min, Max, Position: integer): integer;
begin
  Result :=0;
end;

class procedure TProcessManager.EndProcess(Handle: integer);
begin

end;

class procedure TProcessManager.OnProcess(Handle: integer; Info: string; Position: integer; var Canceled: boolean; ShowPosition: boolean);
begin

end;

end.
