unit JpExprEval1;

interface

uses JclExprEval, JclBase, JpExprEval;

type
   TCompiledEvaluator = class(TEasyEvaluator)
   private
      FExpr: string;
      FVirtMach: TExprVirtMach;
   public
      constructor Create;
      destructor Destroy; override;
      procedure Compile(const AExpr: string);
      function Evaluate: TFloat;
   end;

   TExprVirtMachOp = class(TObject)
   private
      function GetOutputLoc: PFloat;
   protected
      FOutput: TFloat;
   public
      procedure Execute; virtual; abstract;
      property OutputLoc: PFloat read GetOutputLoc;
   end;

   TExprVarVmOp = class(TExprVirtMachOp)
   private
      FVarLoc: Pointer;
   public
      constructor Create(AVarLoc: Pointer);
   end;

implementation

constructor TCompiledEvaluator.Create;
begin
   inherited Create;
   FVirtMach := TExprVirtMach.Create;
end;

destructor TCompiledEvaluator.Destroy;
begin
   FVirtMach.Free;
   inherited Destroy;
end;

procedure TCompiledEvaluator.Compile(const AExpr: string);
var
   Lex: TExprSimpleLexer;
   Parse: TExprCompileParser;
   NodeFactory: TExprVirtMachNodeFactory;
begin
   if AExpr <> FExpr then
   begin
      FExpr := AExpr;
      FVirtMach.Clear;

      Parse := nil;
      NodeFactory := nil;
      Lex := TExprSimpleLexer.Create(FExpr);
      try
         NodeFactory := TExprVirtMachNodeFactory.Create;
         Parse := TExprCompileParser.Create(Lex, NodeFactory);
         Parse.Context := InternalContextSet;
         Parse.Compile;
         NodeFactory.GenCode(FVirtMach);
      finally
         Parse.Free;
         NodeFactory.Free;
         Lex.Free;
      end;
   end;
end;

function TCompiledEvaluator.Evaluate: TFloat;
begin
   Result := FVirtMach.Execute;
end;

function TExprVirtMachOp.GetOutputLoc: PFloat;
begin
   Result := @FOutput;
end;

constructor TExprVarVmOp.Create(AVarLoc: Pointer);
begin
   inherited Create;
   FVarLoc := AVarLoc;
end;

end.
