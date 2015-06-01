{ -----------------------------------------------------------------------------
Unit Name: I:\Delphi Studio Projects\framework\\uClasses.pas
Author:     骆平华 Camel_163@163.com
DateTime:  2004-1-21 14:56:38

Purpose:    框架基础类

OverView:

History:

Todo:

----------------------------------------------------------------------------- }
unit uClasses;

interface

uses
  Classes, SysUtils, Windows;

type

    {
        拥有接口RTTI信息的接口基类
    }
  IRTTIInterface = interface(IInvokable)
  end;

    {
        自主异常类，所有应用程序自身触发的异常都继承自本类
    }
  EAppException = Class(Exception);

    {
      IInterface接口默认实现，由接口进行生命周期管理
    }
  TLifeInterface = class(TInterfacedObject);

    {
      IInterface 接口默认实现，由类进行生命周期管理
    }
  TNoLifeInterface = class(TObject, IInterface)
  protected
    FRefCount: Integer;
  public
        // 2004-2-6 17:27:54 注意这里的重写 都是从SYSTEM单元学习而来的
    function QueryInterface(const IID: TGUID; out Obj): HResult; stdcall;
    function _AddRef: Integer; stdcall;
        //注意下面方法的不同
    function _Release: Integer; virtual; stdcall;
  end;

    {
        RTTI接口默认实现，这里实现的只是不使用接口生命周期管理的类，
        由本类继承的子类生命周期都由自身进行管理
    }
  TNoLifeRTTIInterface = Class(TNoLifeInterface, IRTTIInterface)
  end;

    {
        自描述信息接口
    }
  ISelfDescription = interface
  ['{E6CD84C1-2B1E-4402-A8EE-A136EFE16E7A}']
    function ToString : string;
  end;

        {
                流输入输出基本方法
                来源于柯兄的报表单元                
        }
  TStreamIO = class
  public
   { stream read functions... }

    class function BoolFromStream(Stream: TStream): Boolean;
    class function ByteFromStream(Stream: TStream): Byte;
    class function IntFromStream(Stream: TStream): Integer;
    class function LongIntFromStream(Stream: TStream): LongInt;
    class function FloatFromStream(Stream: TStream): Extended;
    class function SizeFromStream(Stream: TStream): TSize;
    class function RectFromStream(Stream: TStream): TRect;
    class function ColorFromStream(Stream: TStream): COLORREF;
    class function PointFromStream(Stream: TStream): TPoint;
    class function StringFromStream(Stream: TStream): string;
    class function DateTimeFromStream(Stream : TStream) : TDateTime;
    class procedure StreamFromStream(Source, SubStream: TStream);

    { stream write functions... }

    class procedure BoolToStream(Stream: TStream; Value: Boolean);
    class procedure ByteToStream(Stream: TStream; Value: Byte);
    class procedure IntToStream(Stream: TStream; Value: Integer);
    class procedure LongIntToStream(Stream: TStream; Value: LongInt);
    class procedure FloatToStream(Stream: TStream; Value: Extended);
    class procedure SizeToStream(Stream: TStream; Value: TSize);
    class procedure RectToStream(Stream: TStream; Value: TRect);
    class procedure ColorToStream(Stream: TStream; Value: COLORREF);
    class procedure PointToStream(Stream: TStream; Value: TPoint);
    class procedure StringToStream(Stream: TStream; Value: string);
    class procedure DateTimeToStram(Stream : TStream; Value : TDateTime);
    class procedure StreamToStream(Stream, SubStream: TStream);
  end;

implementation

{ TStreamIO }

class function TStreamIO.BoolFromStream(Stream: TStream): Boolean;
begin
  Stream.ReadBuffer(Result, SizeOf(Result));
end;

class procedure TStreamIO.BoolToStream(Stream: TStream; Value: Boolean);
begin
  Stream.WriteBuffer(Value, SizeOf(Value));
end;

class function TStreamIO.ByteFromStream(Stream: TStream): Byte;
begin
  Stream.ReadBuffer(Result, SizeOf(Result));
end;

class procedure TStreamIO.ByteToStream(Stream: TStream; Value: Byte);
begin
  Stream.WriteBuffer(Value, SizeOf(Value));
end;

class function TStreamIO.ColorFromStream(Stream: TStream): COLORREF;
begin
  Stream.ReadBuffer(Result, SizeOf(Result));
end;

class procedure TStreamIO.ColorToStream(Stream: TStream; Value: COLORREF);
begin
  Stream.WriteBuffer(Value, SizeOf(Value));
end;

class function TStreamIO.DateTimeFromStream(Stream: TStream): TDateTime;
begin
  Stream.ReadBuffer(result, SizeOf(result));
end;

class procedure TStreamIO.DateTimeToStram(Stream: TStream;
  Value: TDateTime);
begin
  Stream.WriteBuffer(Value, SizeOf(Value));
end;

class function TStreamIO.FloatFromStream(Stream: TStream): Extended;
begin
  Stream.ReadBuffer(Result, SizeOf(Result));
end;

class procedure TStreamIO.FloatToStream(Stream: TStream; Value: Extended);
begin
  Stream.WriteBuffer(Value, SizeOf(Value));
end;

class function TStreamIO.IntFromStream(Stream: TStream): Integer;
begin
  Stream.ReadBuffer(Result, SizeOf(Result));
end;

class procedure TStreamIO.IntToStream(Stream: TStream; Value: Integer);
begin
  Stream.WriteBuffer(Value, SizeOf(Value));
end;

class function TStreamIO.LongIntFromStream(Stream: TStream): LongInt;
begin
  Stream.ReadBuffer(Result, SizeOf(Result));
end;

class procedure TStreamIO.LongIntToStream(Stream: TStream; Value: Integer);
begin
  Stream.WriteBuffer(Value, SizeOf(Value));
end;

class function TStreamIO.PointFromStream(Stream: TStream): TPoint;
begin
  Stream.ReadBuffer(Result, SizeOf(Result));
end;

class procedure TStreamIO.PointToStream(Stream: TStream; Value: TPoint);
begin
  Stream.WriteBuffer(Value, SizeOf(Value));
end;

class function TStreamIO.RectFromStream(Stream: TStream): TRect;
begin
  Stream.ReadBuffer(Result, SizeOf(Result));
end;

class procedure TStreamIO.RectToStream(Stream: TStream; Value: TRect);
begin
  Stream.WriteBuffer(Value, SizeOf(Value));
end;

class function TStreamIO.SizeFromStream(Stream: TStream): TSize;
begin
  Stream.ReadBuffer(Result, SizeOf(Result));
end;

class procedure TStreamIO.SizeToStream(Stream: TStream; Value: TSize);
begin
  Stream.WriteBuffer(Value, SizeOf(Value));
end;

class procedure TStreamIO.StreamFromStream(Source, SubStream: TStream);
var
  StreamSize: Integer;
begin
  StreamSize := IntFromStream(Source);
  if StreamSize > 0 then
    SubStream.CopyFrom(Source, StreamSize);
end;

class procedure TStreamIO.StreamToStream(Stream, SubStream: TStream);
var
  StreamSize: Integer;
begin
  StreamSize := SubStream.Size;
  IntToStream(Stream, StreamSize);
  if StreamSize > 0 then
  begin
    SubStream.Seek(0, soFromBeginning);
    Stream.CopyFrom(SubStream, StreamSize);
  end;
end;

class function TStreamIO.StringFromStream(Stream: TStream): string;
var
  ALength: Integer;
begin
  ALength := IntFromStream(Stream);
  if ALength > 0 then
  begin
    SetLength(Result, ALength);
    Stream.ReadBuffer(Result[1], ALength);
  end;
end;

class procedure TStreamIO.StringToStream(Stream: TStream; Value: string);
begin
  IntToStream(Stream, Length(Value));
  Stream.WriteBuffer(Value[1], Length(Value));
end;

{ TNoLifeInterface }

function TNoLifeInterface._AddRef: Integer;
begin
  Result := InterlockedIncrement(FRefCount);
end;

function TNoLifeInterface._Release: Integer;
begin
  Result := InterlockedDecrement(FRefCount);
end;

function TNoLifeInterface.QueryInterface(const IID: TGUID;
  out Obj): HResult;
begin
  if GetInterface(IID, Obj) then
    Result := 0
  else
    Result := E_NOINTERFACE;
end;

end.

