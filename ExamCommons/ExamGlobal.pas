unit ExamGlobal;

interface

uses
  DataFieldConst, tq;

const
   LF = #10;
   CR = #13;
   EOL = CR + LF;

   CHAR0 = #0;
   BACKSPACE = #8;

   TAB = #9;
   CHAR32 = #32;

   NULL_STR                 = '';

   // field name constant for Examinee Info Base
//   FLDEXAMINEEID     ='ExamineeNo';
//   FLDEXAMINEENAME   ='ExamineeName';
//   FLDIP             ='IP';
//   FLDPORT           ='Port';
//   FLDSTATUS         ='Status';
//   FLDREMAINTIME     ='RemainTime';
//   FLDSCOREINFO      ='ScoreInfo';

   EXAMENATIONTYPESIMULATION     = 'ģ�⿼��';
   EXAMINATIONTYPEFORMAL         = '��ʽ����';

   SCOREDISPLAYMODECLIENT        = '�ͻ���';
   SCOREDISPLAYMODESERVER        = '��������';

   TEST_QUESTION_CLASSIFY_OPERATION= 3;

   SYSKEY ='JiaPing';        //���ڼӽ��ܵ��ܳ�
   SYSDBPWD ='D904050B2BE537CD0F17E81DE522E4020C1024F20E';     //'thepasswordofaccedwm';
   CLIENTDBPWD ='F728F83BFB0C141C';             // 'F728F83BFB0C141C';    //'jiaping'


//module name
   MODULE_SINGLE_NAME = 'SINGLE_CHOICE';
   MODULE_MULTIPLE_NAME = 'MULTIPLE_CHOICE';
   MODULE_KEYTYPE_NAME = 'KEYTYPE';
type
   TFunctionResult = (frError=0 , frOk=1 );
   //for grade fill garde info mode -1:fill standvalue else fill examvalue
   TFillGradeMode = (fmStandValue=-1,fmExamValue = 0);

   //������������
  parray=array [0..4]of pchar;
  WGradeParamArray=array of array of  pchar;
  FontParaItem = record
    Lx:integer;
    Param1:string;
    Points:integer;
  end;
  WGradeRecord =record
    Lx:integer;
    ObjStr:string;
    ItemCount:integer;
    Items:array of FontParaItem;
  end;
  PageMargin=(PageTopMargin,PageBottomMargin,PageLeftMargin,PageRightMargin);
  

{$region '-----ѡ���ⴰ�����ؼ��������----'}
//==============================================================================
// ѡ���ⴰ�����ؼ��������
//==============================================================================
  PTQTreeNode=^TQTreeNode;
  TQTreeNode=record
    CodeText:string; // ������ı�
    TQ : TTQ;
    ksda:string;
    flag :Boolean;   // �Ƿ��Ѵ���
    //������
    txFlag:boolean;  //��ʾ ��ѡ ���ѡ ��
  end;
{$endregion}

implementation


end.
