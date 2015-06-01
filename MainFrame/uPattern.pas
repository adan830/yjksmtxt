{ -----------------------------------------------------------------------------
Unit Name: I:\Delphi Studio Projects\framework\\uPattern.pas
Author:     ��ƽ�� Camel_163@163.com
DateTime:  2004-1-21 15:08:04

Purpose:    ģʽ�����඼������������� 

OverView:

History:

Todo:

----------------------------------------------------------------------------- }
unit uPattern;

interface

uses
  Classes, SysUtils, uClasses;

type
  TNodes = class;
  TSubject = class;

  //--------------------------------------------------------------------------
  //  �ϳ�ģʽDELPHIʵ��
  //--------------------------------------------------------------------------

  TNodeClass = class of TNodes;
        {
                ����ֻ��һ�����ĹǼܶ���
        }
  TNodes = class
  private
    FNodeList: TList;
    FOwner: TNodes;
    function GetNodesByIndex(Index: integer): TNodes;
    function GetCount: integer;
    function GetHasChild: boolean;
  protected
    function CreateNode : TNodes; virtual;

    //------------------------------------------------------------------------
    //Stream Functions
    //����ʵ���Լ��ķ�����������ĺ������м̳У�SaveToStream����Virtual
    //����ǽṹ�ϵĸ��ģ���ô����дSaveStructToStream��LoadStructFromStream
    //------------------------------------------------------------------------
    procedure DoSaveToStream(Strm : TStream); virtual;          //Template Function
    procedure DoLoadFromStream(Strm : TStream); virtual;

    procedure SaveStructToStream(Strm : TStream); virtual;
    procedure LoadStructFromStream(Strm : TStream); virtual;

    property NodeList : TList read FNodeList write FNodeList;
  public
        //Create && Destroy
    constructor Create; virtual;
    destructor Destroy; override;

        //����List��һЩ����
    function AddNode : TNodes; virtual;
    procedure DelNode(Index : integer); overload;
    procedure DelNode(Nodes : TNodes); overload;
    procedure ClearAllNodes;

    function LoadFromStream(Strm : TStream) : boolean;
    function SaveToStream(Strm : TStream) : Boolean;
    function LoadFromFile(FileName : string) : boolean;
    function SaveToFile(FileName : string) : boolean;

    function GetAllChildrenCount : integer;

    function GetRootNode : TNodes;

    property Count : integer read GetCount;

    property Nodes[Index : integer] : TNodes read GetNodesByIndex; default;

    property HasChild : boolean read GetHasChild;

    property Owner : TNodes read FOwner write FOwner;
  end;


  //--------------------------------------------------------------------------
  //�۲���ģʽDELPHIʵ��
  //--------------------------------------------------------------------------
        {
                �۲��߽ӿ� 
        }
  IObserver = interface
    procedure Update(theChangedSubject: TSubject);
  end;

        {
                ���۲��߽ӿ�
        }
  ISubject = interface
    procedure AddListener(anObserver : IObserver);
    procedure RemoveListener(anObserver : IObserver);
    procedure Notify();
  end;

        {
                ���۲��߶���
        }
  TSubject = class(TNoLifeInterface, ISubject)
  private
    f_observers: Tlist;
  protected

  public
    constructor Create; virtual;
    destructor Destroy; override;
    procedure AddListener(anObserver: IObserver); virtual;
    procedure RemoveListener(anObserver: IObserver); virtual;
    procedure Notify(); virtual;
  end;


implementation

{ TNodes }

function TNodes.AddNode: TNodes;
begin
  result := CreateNode;
  result.Owner := self;
  FNodeList.Add(result);
end;

procedure TNodes.ClearAllNodes;
var
  I: Integer;
begin
  for I :=Count - 1 downto 0   do    // Iterate
  begin
    DelNode(i);
  end;    // for
end;

constructor TNodes.Create;
begin
  NodeList := TList.Create;
end;

procedure TNodes.DelNode(Nodes: TNodes);
begin
  DelNode(NodeList.IndexOf(Nodes));
end;

procedure TNodes.DelNode(Index: integer);
begin
  if (Index < Count) and (Index > -1) then
  begin
    Nodes[Index].Free;
    NodeList.Delete(Index);
  end;
end;

destructor TNodes.Destroy;
begin
  ClearAllNodes;

  NodeList.Free;

  inherited;
end;

function TNodes.GetCount: integer;
begin
  result := NodeList.Count;
end;

function TNodes.GetHasChild: boolean;
begin
  result := (Count > 0);
end;

function TNodes.CreateNode: TNodes;
begin
  result := TNodes.Create;
end;

function TNodes.GetNodesByIndex(Index: integer): TNodes;
begin
  result := TNodes(NodeList[Index]);
end;

function TNodes.LoadFromFile(FileName: string): boolean;
var
  strm : TFileStream;
begin
  strm := TFileStream.Create(FileName, fmOpenRead);
  try
    LoadFromStream(strm);
    result := true;
  finally // wrap up
    strm.Free;
  end;    // try/finally
end;

function TNodes.LoadFromStream(Strm: TStream): boolean;
begin
  self.DoLoadFromStream(Strm);
  result := true;
end;

function TNodes.SaveToFile(FileName: string): boolean;
var
  strm : TFileStream;
begin
  if FileExists(FileName) then
    DeleteFile(FileName);

  strm := TFileStream.Create(FileName, fmCreate);
  try
    SaveToStream(strm);
    result := true;
  finally // wrap up
    strm.Free;
  end;    // try/finally
end;

function TNodes.SaveToStream(Strm: TStream): Boolean;
begin
  DoSaveToStream(Strm);
  result := true;
end;

procedure TNodes.DoSaveToStream(Strm: TStream);
begin
  SaveStructToStream(Strm);
end;

procedure TNodes.SaveStructToStream(Strm: TStream);
var
  i : integer;
begin
  TStreamIO.IntToStream(Strm, self.Count);
  for I := 0 to Count - 1 do    // Iterate
  begin
    Nodes[i].SaveStructToStream(Strm);
  end;    // for
end;

procedure TNodes.DoLoadFromStream(Strm: TStream);
begin
  LoadStructFromStream(Strm);
end;

procedure TNodes.LoadStructFromStream(Strm: TStream);
var
  I: Integer;
  NodeCount : integer;
begin
        //����֮ǰӦ��������е��ӽڵ�
  self.ClearAllNodes;
  
  NodeCount := TStreamIO.IntFromStream(Strm);
  for I := 0 to NodeCount - 1 do    // Iterate
  begin
    self.AddNode.LoadStructFromStream(Strm);
  end;    // for
end;

function TNodes.GetAllChildrenCount: integer;
var
  AllCount : integer;
  
  procedure ProcessNodes(ANodes : TNodes);
  var
    I: Integer;
  begin
    Inc(AllCount);
    for I := 0 to ANodes.Count - 1 do    // Iterate
    begin
      ProcessNodes(ANodes[i]);
    end;    // for
  end;
begin
  AllCount := 0;
  ProcessNodes(self);
  Result := AllCount;
end;

function TNodes.GetRootNode: TNodes;
var
  tmpResult : TNodes;
begin
  tmpResult := self;
  while tmpResult <> nil do
  begin
    Result := tmpResult;
    tmpResult := tmpResult.Owner;
  end;    // while
end;

{ TSubject }

procedure TSubject.AddListener(anObserver: IObserver);
begin
  f_observers.Add(Pointer(anObserver));
end;

constructor TSubject.Create;
begin
  f_observers := TList.Create;
end;

destructor TSubject.Destroy;
begin
  f_observers.Free;
end;

procedure TSubject.RemoveListener(anObserver: IObserver);
begin
  f_observers.Remove(Pointer(anObserver));
end;

procedure TSubject.Notify;
var
  I: Integer;
begin
  for I := 0 to f_observers.Count - 1 do    // Iterate
  begin
    IObserver(f_observers[i]).Update(self);
  end;    // for
end;

end.
