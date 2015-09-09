{*******************************************************}
{                                                       }
{       软件名  本文件借鉴indy软件中的异常处理架构      }
{        具体参见 idException.pas                       }
{                                                       }
{*******************************************************}

unit ExamException;

interface
uses SysUtils,DataUtils;

type

  EExamException = class(Exception)
  public
    constructor Create(
      AMsg: string
      ); overload; virtual;
    class procedure IfAssigned(
      const ACheck: TObject;
      const AMsg: string = ''
      );
    class procedure IfFalse(
      const ACheck: Boolean;
      const AMsg: string = ''
      );
    class procedure IfNotAssigned(
      const ACheck: TObject;
      const AMsg: string = ''
      );
    class procedure IfNotInRange(
      const AValue: Integer;
      const AMin: Integer;
      const AMax: Integer;
      const AMsg: string = ''
      );
    class procedure IfTrue(
      const ACheck: Boolean;
      const AMsg: string = ''
      );
    class procedure Toss(
      const AMsg: string
      );
  end;
  /// <summary>
  ///表示严重错误，程序必须终止
  /// </summary>
  ESeriousException=class(EExamException);
  ECoreFileNotExitException      = class (ESeriousException);


  //文件不存在异常
  EFileNotExistException         = class (EExamException);

  //目录不存在异常
  EDirNotExistException          = class (EExamException);
  //文件夹删除异常
  EDirDeleteException            = class (EExamException);
  //文件夹创建异常
  EDirCreateException            = class (EExamException);



//==============================================================================
// 以下异常用于数据库试题访问中
//==============================================================================
   //读取试题信息时，未能找到给定 st_no的试题
   // RSTQRecordNotFound
   ETQRecordNotFoundException    = class (EExamException);


//==============================================================================
// 以下异常于操作题评分相关函数，
//==============================================================================

//调用相关模块进行评分，并填充传入的评分信息时异常
//而是用于操作评分模块的FillGrade中的异常处理中，
//本异常用于嵌套一般的异常，因此一般一直接用于异常中
//这样的好处是，一需要实现继承于些类的，一般异常，因为数量可能很大
//又能在主模块中，更好的捕捉这一大类异常
   EGradeException            = class (EExamException);
   ELoadLibraryException       = class (EExamException);

 //==============================================================================
// 以下异常用于数据库访问相关，
//==============================================================================
   /// <summary>
   /// 创建mdb数据库连接的异常
   /// </summary>
   /// <param name="MdbFileName">mdb数据库文件</param>
   EMDBConnectionException = class (EExamException)
   public
    constructor Create(
      MdbFileName: string
      ); override;
   end;

implementation

{ EExamException }

constructor EExamException.Create(AMsg : String);
begin
  inherited Create(AMsg);
end;

class procedure EExamException.IfAssigned(const ACheck: TObject;const AMsg: string);
begin
  if ACheck <> nil then begin
    Toss(AMsg);
  end;
end;

class procedure EExamException.IfFalse(const ACheck: Boolean; const AMsg: string);
begin
  if not ACheck then begin
    Toss(AMsg);
  end;
end;

class procedure EExamException.IfNotAssigned(const ACheck: TObject; const AMsg: string);
begin
  if ACheck = nil then begin
    Toss(AMsg);
  end;
end;

class procedure EExamException.IfNotInRange(
  const AValue: Integer;
  const AMin: Integer;
  const AMax: Integer;
  const AMsg: string = ''
  );
begin
  if (AValue < AMin) or (AValue > AMax) then begin
    Toss(AMsg);
  end;
end;

class procedure EExamException.IfTrue(const ACheck: Boolean; const AMsg: string);
begin
  if ACheck then begin
    Toss(AMsg);
  end;
end;

class procedure EExamException.Toss(const AMsg: string);
begin
  raise Create(AMsg);
end;

{ EMDBConnectionException }

constructor EMDBConnectionException.Create(MdbFileName: string);
begin
  inherited Create(Format('连接数据库：%s 发生错误，请检查库文件路径或文件是否存在！',[mdbfilename]));
end;

end.
