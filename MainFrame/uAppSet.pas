{ -----------------------------------------------------------------------------
Unit Name: I:\Delphi Studio Projects\FrameWork_New\System\uAppSet.pas
Author:    ��ƽ��
DateTime:  2004-2-26 10:16:32

Purpose:

OverView:

History:

Todo:

----------------------------------------------------------------------------- }
unit uAppSet;

interface

uses
  Classes, SysUtils;

type
  IAppSet = interface
      //�Ƿ��һ������
    function GetIsFirstRun : boolean;
    procedure SetIsFirstRun(Value : boolean);
    property IsFirstRun : boolean read GetIsFirstRun write SetIsFirstRun;

    function Instance : TObject;
  end;

var
  AppSet : IAppSet;

implementation

end.
