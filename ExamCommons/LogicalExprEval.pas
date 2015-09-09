unit LogicalExprEval;

interface

uses rtti,types;

const
   CONSTSTARTTOKEN ='C';
type
   TLogicalExprEval =class
   private
      ///求值表达式
      ///常量只能为：C0,C1..C10,C11,...的形式
      ///常量编号必须从0开始，中间不能有间隔
      FExprString :string;
      FConstName :TStringDynArray;
      FConstValue :TIntegerDynArray;  //this only integer,will convert to float to TEvaluator
      FExprValue: Boolean;        //only need logica result;
      FEvaluateSuccess:Boolean;  // if evaluate success, the result is in FExprValue;

      procedure ParseConst();
      procedure SetExprString(const Value: string);
    function GetConstCount: integer;
    procedure AddConstName(AName: string);
    procedure SortConstName;
   public
      constructor Create(AExprString :string);
      destructor Destroy; override;
      procedure Evaluate();
      function ValidateExpr(var errorMsg:string):boolean;

      property ExprString : string read FExprString write SetExprString;
      property ConstCount:integer read GetConstCount;
      property ConstValue :TIntegerDynArray read FConstValue write FConstValue;
      property ConstName : TStringDynArray read FConstName;
      property ExprValue : Boolean read FExprValue;
      property EvaluateSuccess : Boolean read FEvaluateSuccess;
   end;

implementation

uses
  SysUtils,JclStrings,JclExprEval;

{ TLogicalExprEval }

constructor TLogicalExprEval.Create(AExprString :string);
begin
   inherited Create();
   ExprString := AExprString;
end;

destructor TLogicalExprEval.Destroy;
begin

  inherited;
end;

procedure TLogicalExprEval.Evaluate;
var
   evaluator :TEvaluator;
   I: Integer;
begin
   FEvaluateSuccess := false;
   Assert(length(FConstName)>0,'表达式中没有常量');
   assert(Length(FConstValue)>0,'未对常量赋值');
   Assert(length(FConstName) = Length(FConstValue),'常量个数与值个数不一致');

   evaluator := Tevaluator.Create();
   try
      for I := 0 to ConstCount - 1 do
      begin
         evaluator.AddConst(CONSTSTARTTOKEN+ IntToStr(I),FConstValue[i]);
      end;
      FExprValue := evaluator.Evaluate(FExprString)<>0.0;
      FEvaluateSuccess := true;
   finally
      evaluator.Free;
   end;
end;

function TLogicalExprEval.GetConstCount: integer;
begin
   Result := Length(FConstName);
end;

procedure TLogicalExprEval.ParseConst;
var
   cp : PChar;
   start : PChar;
   currConst : string;
begin
   cp := PChar(FExprString);
   while cp^<>#0 do
   begin
      while (cp^ <>CONSTSTARTTOKEN)and(cp^<>#0)  do Inc(cp);
      if cp^=#0 then Break;
      start := cp;
      Inc(cp);
      while CharIsDigit(cp^) do Inc(cp);
      SetString(currConst, start, cp - start);
      AddConstName(currConst);
   end;
   SortConstName();
   SetLength(FConstValue,ConstCount);
end;

procedure TLogicalExprEval.AddConstName(AName:string);
var
  I: Integer;
  bFind:Boolean;
begin
   bFind :=False;
   for I := 0 to Length(FConstName) - 1 do
      if FConstName[i] =AName then
      begin
         bFind := True;
         break;
      end;
   if not bFind then
   begin
      SetLength(FConstName,Length(FConstName)+1);
      FConstName[Length(FConstName)-1] := AName;
   end;
end;

procedure TLogicalExprEval.SortConstName();
var
  I: Integer;
  currentName:string;
  j: Integer;
begin
   for I := 0 to Length(FConstName) - 1 do
   begin
      currentName :=CONSTSTARTTOKEN+IntToStr(i);
      if FConstName[i]<>currentName then
      begin
         for j := i+1 to Length(FConstName) - 1 do
         begin
            if FConstName[j]=currentName then  begin
               FConstName[j]:=FConstName[i];
               FConstName[i]:=currentName;
               break;
            end;
         end;
      end;
   end;
end;

function TLogicalExprEval.ValidateExpr(var errorMsg:string):boolean;
var
  I,J: Integer;
  currentName:string;
   evaluator :TEvaluator;
begin
   Result :=true;
   for I := 0 to Length(FConstName) - 1 do
   begin
      currentName :=CONSTSTARTTOKEN+IntToStr(i);
      if FConstName[i]<>currentName then
      begin
         Result := False;
         errorMsg := '没发现变量：'+currentName;
         Break;
      end;
   end;
   if not Result then  begin
      evaluator := TEvaluator.Create;
      try
         for I := 0 to Length(FConstName) - 1 do  evaluator.AddConst(FConstName[i],1.0);
         try
            evaluator.Evaluate(FExprString);
         except
            on e :Exception do begin
               Result := False;
               errorMsg := e.Message;
            end;
         end;
      finally
         evaluator.Free;
      end;

   end;
end;

procedure TLogicalExprEval.SetExprString(const Value: string);
begin
  FExprString := UpperCase( Value );
  ParseConst();
end;

end.
