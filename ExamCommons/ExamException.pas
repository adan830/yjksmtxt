{*******************************************************}
{                                                       }
{       �����  ���ļ����indy����е��쳣����ܹ�      }
{        ����μ� idException.pas                       }
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
  ///��ʾ���ش��󣬳��������ֹ
  /// </summary>
  ESeriousException=class(EExamException);
  ECoreFileNotExitException      = class (ESeriousException);


  //�ļ��������쳣
  EFileNotExistException         = class (EExamException);

  //Ŀ¼�������쳣
  EDirNotExistException          = class (EExamException);
  //�ļ���ɾ���쳣
  EDirDeleteException            = class (EExamException);
  //�ļ��д����쳣
  EDirCreateException            = class (EExamException);



//==============================================================================
// �����쳣�������ݿ����������
//==============================================================================
   //��ȡ������Ϣʱ��δ���ҵ����� st_no������
   // RSTQRecordNotFound
   ETQRecordNotFoundException    = class (EExamException);


//==============================================================================
// �����쳣�ڲ�����������غ�����
//==============================================================================

//�������ģ��������֣�����䴫���������Ϣʱ�쳣
//�������ڲ�������ģ���FillGrade�е��쳣�����У�
//���쳣����Ƕ��һ����쳣�����һ��һֱ�������쳣��
//�����ĺô��ǣ�һ��Ҫʵ�ּ̳���Щ��ģ�һ���쳣����Ϊ�������ܴܺ�
//��������ģ���У����õĲ�׽��һ�����쳣
   EGradeException            = class (EExamException);
   ELoadLibraryException       = class (EExamException);

 //==============================================================================
// �����쳣�������ݿ������أ�
//==============================================================================
   /// <summary>
   /// ����mdb���ݿ����ӵ��쳣
   /// </summary>
   /// <param name="MdbFileName">mdb���ݿ��ļ�</param>
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
  inherited Create(Format('�������ݿ⣺%s ��������������ļ�·�����ļ��Ƿ���ڣ�',[mdbfilename]));
end;

end.
