{ ************************************************************************************************** }
{ }
{ Project JEDI Code Library (JCL) }
{ }
{ The contents of this file are subject to the Mozilla Public License Version 1.1 (the "License"); }
{ you may not use this file except in compliance with the License. You may obtain a copy of the }
{ License at http://www.mozilla.org/MPL/ }
{ }
{ Software distributed under the License is distributed on an "AS IS" basis, WITHOUT WARRANTY OF }
{ ANY KIND, either express or implied. See the License for the specific language governing rights }
{ and limitations under the License. }
{ }
{ The Original Code is JclExprEval.pas. }
{ }
{ The Initial Developer of the Original Code is Barry Kelly. }
{ Portions created by Barry Kelly are Copyright (C) Barry Kelly. All rights reserved. }
{ }
{ Contributor(s): }
{ Barry Kelly }
{ Matthias Thoma (mthoma) }
{ Petr Vones (pvones) }
{ Robert Marquardt (marquardt) }
{ Robert Rossmair (rrossmair) }
{ }
{ ************************************************************************************************** }
{ }
{ This unit contains three expression evaluators, each tailored for different usage patterns. It }
{ also contains the component objects, so that a customized expression evaluator can be assembled }
{ relatively easily. }
{ }
{ ************************************************************************************************** }
{ }
{ Last modified: $Date:: 2009-08-09 15:08:29 +0200 (dim., 09 ao没t 2009)                         $ }
{ Revision:      $Rev:: 2921                                                                     $ }
{ Author:        $Author:: outchy                                                                $ }
{ }
{ ************************************************************************************************** }

// operator priority (as implemented in this unit)
// all binary operators are associated from left to right
// all unary operators are associated from right to left

// (highest) not bnot(bitwise) +(unary) -(unary)                      (level 3)
// * / div mod and band(bitwise) shl shr                    (level 2)
// +(binary) -(binary) or xor bor(bitwise) bxor(bitwise)    (level 1)
// (lowest)  < <= > >= cmp = <>                                       (level 0)

// details on cmp operator:
// "1.5 cmp 2.0" returns -1.0 because 1.5 < 2.0
// "1.5 cmp 1.5" returns 0.0 because 1.5 = 1.5
// "1.5 cmp 0.0" returns 1.0 because 1.5 > 0.0


// modified by jiaping  for logical expression

unit JpExprEval3;
{$I jcl.inc}

interface

uses
{$IFDEF UNITVERSIONING}
   jcJpExprEval, JpExprEval, lexpreval, jpexpreval2,
{$ENDIF UNITVERSIONING}
   SysUtils, Classes,
   JclBase, JclSysUtils, JclStrHashMap, JclResources;

const
   cExprEvalHashSize = 127;

type
   TFloat = JclBase.Float;

   TFloat32 = Single;
   PFloat32 = ^TFloat32;

   TFloat64 = Double;
   PFloat64 = ^TFloat64;
{$IFDEF SUPPORTS_EXTENDED}
   TFloat80 = Extended;
   PFloat80 = ^TFloat80;
{$ENDIF SUPPORTS_EXTENDED}
   TFloatFunc = function: TFloat;
   TFloat32Func = function: TFloat32;
   TFloat64Func = function: TFloat64;
{$IFDEF SUPPORTS_EXTENDED}
   TFloat80Func = function: TFloat80;
{$ENDIF SUPPORTS_EXTENDED}
   TUnaryFunc = function(X: TFloat): TFloat;
   TUnary32Func = function(X: TFloat32): TFloat32;
   TUnary64Func = function(X: TFloat64): TFloat64;
{$IFDEF SUPPORTS_EXTENDED}
   TUnary80Func = function(X: TFloat80): TFloat80;
{$ENDIF SUPPORTS_EXTENDED}
   TBinaryFunc = function(X, Y: TFloat): TFloat;
   TBinary32Func = function(X, Y: TFloat32): TFloat32;
   TBinary64Func = function(X, Y: TFloat64): TFloat64;
{$IFDEF SUPPORTS_EXTENDED}
   TBinary80Func = function(X, Y: TFloat80): TFloat80;
{$ENDIF SUPPORTS_EXTENDED}
   TTernaryFunc = function(X, Y, Z: TFloat): TFloat;
   TTernary32Func = function(X, Y, Z: TFloat32): TFloat32;
   TTernary64Func = function(X, Y, Z: TFloat64): TFloat64;
{$IFDEF SUPPORTS_EXTENDED}
   TTernary80Func = function(X, Y, Z: TFloat80): TFloat80;
{$ENDIF SUPPORTS_EXTENDED}

type
   { Forward Declarations }
   TExprLexer = class;
   TExprCompileParser = class;

   TExprNode = class;
   TExprNodeFactory = class;

   TExprLexer = class(TObject)
   protected
      FCurrTok: TExprToken;
      FTokenAsNumber: TFloat;
      FTokenAsString: string;
   public
      constructor Create;
      procedure NextTok; virtual; abstract;
      procedure Reset; virtual;
      property TokenAsString: string read FTokenAsString;
      property TokenAsNumber: TFloat read FTokenAsNumber;
      property CurrTok: TExprToken read FCurrTok;
   end;

   TExprNode = class(TObject)
   private
      FDepList: TList;
      function GetDepCount: Integer;
      function GetDeps(AIndex: Integer): TExprNode;
   public
      constructor Create(const ADepList: array of TExprNode);
      destructor Destroy; override;
      procedure AddDep(ADep: TExprNode);
      property DepCount: Integer read GetDepCount;
      property Deps[AIndex: Integer]: TExprNode read GetDeps; default;
      property DepList: TList read FDepList;
   end;

   TExprNodeFactory = class(TObject)
   public
      function LoadVar32(ALoc: PFloat32): TExprNode; virtual; abstract;
      function LoadVar64(ALoc: PFloat64): TExprNode; virtual; abstract;
{$IFDEF SUPPORTS_EXTENDED}
      function LoadVar80(ALoc: PFloat80): TExprNode; virtual; abstract;
{$ENDIF SUPPORTS_EXTENDED}
      function LoadConst32(AValue: TFloat32): TExprNode; virtual; abstract;
      function LoadConst64(AValue: TFloat64): TExprNode; virtual; abstract;
{$IFDEF SUPPORTS_EXTENDED}
      function LoadConst80(AValue: TFloat80): TExprNode; virtual; abstract;
{$ENDIF SUPPORTS_EXTENDED}
      function CallFloatFunc(AFunc: TFloatFunc): TExprNode; virtual; abstract;
      function CallFloat32Func(AFunc: TFloat32Func): TExprNode; virtual;
        abstract;
      function CallFloat64Func(AFunc: TFloat64Func): TExprNode; virtual;
        abstract;
{$IFDEF SUPPORTS_EXTENDED}
      function CallFloat80Func(AFunc: TFloat80Func): TExprNode; virtual;
        abstract;
{$ENDIF SUPPORTS_EXTENDED}
      function CallUnaryFunc(AFunc: TUnaryFunc; X: TExprNode): TExprNode;
        virtual; abstract;
      function CallUnary32Func(AFunc: TUnary32Func; X: TExprNode): TExprNode;
        virtual; abstract;
      function CallUnary64Func(AFunc: TUnary64Func; X: TExprNode): TExprNode;
        virtual; abstract;
{$IFDEF SUPPORTS_EXTENDED}
      function CallUnary80Func(AFunc: TUnary80Func; X: TExprNode): TExprNode;
        virtual; abstract;
{$ENDIF SUPPORTS_EXTENDED}
      function CallBinaryFunc(AFunc: TBinaryFunc; X, Y: TExprNode): TExprNode;
        virtual; abstract;
      function CallBinary32Func(AFunc: TBinary32Func; X, Y: TExprNode)
        : TExprNode; virtual; abstract;
      function CallBinary64Func(AFunc: TBinary64Func; X, Y: TExprNode)
        : TExprNode; virtual; abstract;
{$IFDEF SUPPORTS_EXTENDED}
      function CallBinary80Func(AFunc: TBinary80Func; X, Y: TExprNode)
        : TExprNode; virtual; abstract;
{$ENDIF SUPPORTS_EXTENDED}
      function CallTernaryFunc(AFunc: TTernaryFunc; X, Y, Z: TExprNode)
        : TExprNode; virtual; abstract;
      function CallTernary32Func(AFunc: TTernary32Func; X, Y, Z: TExprNode)
        : TExprNode; virtual; abstract;
      function CallTernary64Func(AFunc: TTernary64Func; X, Y, Z: TExprNode)
        : TExprNode; virtual; abstract;
{$IFDEF SUPPORTS_EXTENDED}
      function CallTernary80Func(AFunc: TTernary80Func; X, Y, Z: TExprNode)
        : TExprNode; virtual; abstract;
{$ENDIF SUPPORTS_EXTENDED}
      function Add(ALeft, ARight: TExprNode): TExprNode; virtual; abstract;
      function Subtract(ALeft, ARight: TExprNode): TExprNode; virtual; abstract;
      function Multiply(ALeft, ARight: TExprNode): TExprNode; virtual; abstract;
      function Divide(ALeft, ARight: TExprNode): TExprNode; virtual; abstract;
      function IntegerDivide(ALeft, ARight: TExprNode): TExprNode; virtual;
        abstract;
      function Modulo(ALeft, ARight: TExprNode): TExprNode; virtual; abstract;
      function Negate(AValue: TExprNode): TExprNode; virtual; abstract;

      function Compare(ALeft, ARight: TExprNode): TExprNode; virtual; abstract;
      function CompareEqual(ALeft, ARight: TExprNode): TExprNode; virtual;
        abstract;
      function CompareNotEqual(ALeft, ARight: TExprNode): TExprNode; virtual;
        abstract;
      function CompareLess(ALeft, ARight: TExprNode): TExprNode; virtual;
        abstract;
      function CompareLessEqual(ALeft, ARight: TExprNode): TExprNode; virtual;
        abstract;
      function CompareGreater(ALeft, ARight: TExprNode): TExprNode; virtual;
        abstract;
      function CompareGreaterEqual(ALeft, ARight: TExprNode): TExprNode;
        virtual; abstract;

      function LogicalAnd(ALeft, ARight: TExprNode): TExprNode; virtual;
        abstract;
      function LogicalOr(ALeft, ARight: TExprNode): TExprNode; virtual;
        abstract;
      function LogicalXor(ALeft, ARight: TExprNode): TExprNode; virtual;
        abstract;
      function LogicalNot(AValue: TExprNode): TExprNode; virtual; abstract;
      function BitwiseAnd(ALeft, ARight: TExprNode): TExprNode; virtual;
        abstract;
      function BitwiseOr(ALeft, ARight: TExprNode): TExprNode; virtual;
        abstract;
      function BitwiseXor(ALeft, ARight: TExprNode): TExprNode; virtual;
        abstract;
      function BitwiseNot(AValue: TExprNode): TExprNode; virtual; abstract;
      function ShiftLeft(ALeft, ARight: TExprNode): TExprNode; virtual;
        abstract;
      function ShiftRight(ALeft, ARight: TExprNode): TExprNode; virtual;
        abstract;

      function LoadVar(ALoc: PFloat32): TExprNode; overload;
      function LoadVar(ALoc: PFloat64): TExprNode; overload;
{$IFDEF SUPPORTS_EXTENDED}
      function LoadVar(ALoc: PFloat80): TExprNode; overload;
{$ENDIF SUPPORTS_EXTENDED}
      function LoadConst(AValue: TFloat32): TExprNode; overload;
      function LoadConst(AValue: TFloat64): TExprNode; overload;
{$IFDEF SUPPORTS_EXTENDED}
      function LoadConst(AValue: TFloat80): TExprNode; overload;
{$ENDIF SUPPORTS_EXTENDED}
   end;

   TExprCompileParser = class(TObject)
   private
      FContext: TExprContext;
      FLexer: TExprLexer;
      FNodeFactory: TExprNodeFactory;
   protected
      function CompileExprLevel0(ASkip: Boolean): TExprNode; virtual;
      function CompileExprLevel1(ASkip: Boolean): TExprNode; virtual;
      function CompileExprLevel2(ASkip: Boolean): TExprNode; virtual;
      function CompileExprLevel3(ASkip: Boolean): TExprNode; virtual;
      function CompileFactor: TExprNode; virtual;
      function CompileIdentFactor: TExprNode; virtual;
   public
      constructor Create(ALexer: TExprLexer; ANodeFactory: TExprNodeFactory);
      function Compile: TExprNode; virtual;
      property Lexer: TExprLexer read FLexer;
      property NodeFactory: TExprNodeFactory read FNodeFactory;
      property Context: TExprContext read FContext write FContext;
   end;

   { some concrete class descendants follow... }

   TExprVirtMach = class(TObject)
   private
      FCodeList: TList;
      FConstList: TList;
   public
      constructor Create;
      destructor Destroy; override;
      procedure Add(AOp: TExprVirtMachOp);
      procedure AddConst(AOp: TExprVirtMachOp);
      procedure Clear;
      function Execute: TFloat;
   end;

   TExprVirtMachNodeFactory = class(TExprNodeFactory)
   private
      FNodeList: TList;
      function AddNode(ANode: TExprNode): TExprNode;
      procedure DoClean(AVirtMach: TExprVirtMach);
      procedure DoConsts(AVirtMach: TExprVirtMach);
      procedure DoCode(AVirtMach: TExprVirtMach);
   public
      constructor Create;
      destructor Destroy; override;

      procedure GenCode(AVirtMach: TExprVirtMach);

      function LoadVar32(ALoc: PFloat32): TExprNode; override;
      function LoadVar64(ALoc: PFloat64): TExprNode; override;
{$IFDEF SUPPORTS_EXTENDED}
      function LoadVar80(ALoc: PFloat80): TExprNode; override;
{$ENDIF SUPPORTS_EXTENDED}
      function LoadConst32(AValue: TFloat32): TExprNode; override;
      function LoadConst64(AValue: TFloat64): TExprNode; override;
{$IFDEF SUPPORTS_EXTENDED}
      function LoadConst80(AValue: TFloat80): TExprNode; override;
{$ENDIF SUPPORTS_EXTENDED}
      function CallFloatFunc(AFunc: TFloatFunc): TExprNode; override;
      function CallFloat32Func(AFunc: TFloat32Func): TExprNode; override;
      function CallFloat64Func(AFunc: TFloat64Func): TExprNode; override;
{$IFDEF SUPPORTS_EXTENDED}
      function CallFloat80Func(AFunc: TFloat80Func): TExprNode; override;
{$ENDIF SUPPORTS_EXTENDED}
      function CallUnaryFunc(AFunc: TUnaryFunc; X: TExprNode): TExprNode;
        override;
      function CallUnary32Func(AFunc: TUnary32Func; X: TExprNode): TExprNode;
        override;
      function CallUnary64Func(AFunc: TUnary64Func; X: TExprNode): TExprNode;
        override;
{$IFDEF SUPPORTS_EXTENDED}
      function CallUnary80Func(AFunc: TUnary80Func; X: TExprNode): TExprNode;
        override;
{$ENDIF SUPPORTS_EXTENDED}
      function CallBinaryFunc(AFunc: TBinaryFunc; X, Y: TExprNode): TExprNode;
        override;
      function CallBinary32Func(AFunc: TBinary32Func; X, Y: TExprNode)
        : TExprNode; override;
      function CallBinary64Func(AFunc: TBinary64Func; X, Y: TExprNode)
        : TExprNode; override;
{$IFDEF SUPPORTS_EXTENDED}
      function CallBinary80Func(AFunc: TBinary80Func; X, Y: TExprNode)
        : TExprNode; override;
{$ENDIF SUPPORTS_EXTENDED}
      function CallTernaryFunc(AFunc: TTernaryFunc; X, Y, Z: TExprNode)
        : TExprNode; override;
      function CallTernary32Func(AFunc: TTernary32Func; X, Y, Z: TExprNode)
        : TExprNode; override;
      function CallTernary64Func(AFunc: TTernary64Func; X, Y, Z: TExprNode)
        : TExprNode; override;
{$IFDEF SUPPORTS_EXTENDED}
      function CallTernary80Func(AFunc: TTernary80Func; X, Y, Z: TExprNode)
        : TExprNode; override;
{$ENDIF SUPPORTS_EXTENDED}
      function Add(ALeft, ARight: TExprNode): TExprNode; override;
      function Subtract(ALeft, ARight: TExprNode): TExprNode; override;
      function Multiply(ALeft, ARight: TExprNode): TExprNode; override;
      function Divide(ALeft, ARight: TExprNode): TExprNode; override;
      function IntegerDivide(ALeft, ARight: TExprNode): TExprNode; override;
      function Modulo(ALeft, ARight: TExprNode): TExprNode; override;
      function Negate(AValue: TExprNode): TExprNode; override;

      function Compare(ALeft, ARight: TExprNode): TExprNode; override;
      function CompareEqual(ALeft, ARight: TExprNode): TExprNode; override;
      function CompareNotEqual(ALeft, ARight: TExprNode): TExprNode; override;
      function CompareLess(ALeft, ARight: TExprNode): TExprNode; override;
      function CompareLessEqual(ALeft, ARight: TExprNode): TExprNode; override;
      function CompareGreater(ALeft, ARight: TExprNode): TExprNode; override;
      function CompareGreaterEqual(ALeft, ARight: TExprNode): TExprNode;
        override;

      function LogicalAnd(ALeft, ARight: TExprNode): TExprNode; override;
      function LogicalOr(ALeft, ARight: TExprNode): TExprNode; override;
      function LogicalXor(ALeft, ARight: TExprNode): TExprNode; override;
      function LogicalNot(AValue: TExprNode): TExprNode; override;
      function BitwiseAnd(ALeft, ARight: TExprNode): TExprNode; override;
      function BitwiseOr(ALeft, ARight: TExprNode): TExprNode; override;
      function BitwiseXor(ALeft, ARight: TExprNode): TExprNode; override;
      function BitwiseNot(AValue: TExprNode): TExprNode; override;
      function ShiftLeft(ALeft, ARight: TExprNode): TExprNode; override;
      function ShiftRight(ALeft, ARight: TExprNode): TExprNode; override;
   end;

   { some concrete symbols }

   TExprConstSym = class(TExprSym)
   private
      FValue: TFloat;
   public
      constructor Create(const AIdent: string; AValue: TFloat);
      function Evaluate: TFloat; override;
      function Compile: TExprNode; override;
   end;
{$IFDEF SUPPORTS_EXTENDED}

   TExprConst80Sym = class(TExprSym)
   private
      FValue: TFloat80;
   public
      constructor Create(const AIdent: string; AValue: TFloat80);
      function Evaluate: TFloat; override;
      function Compile: TExprNode; override;
   end;
{$ENDIF SUPPORTS_EXTENDED}

   TExprVar32Sym = class(TExprSym)
   private
      FLoc: PFloat32;
   public
      constructor Create(const AIdent: string; ALoc: PFloat32);

      function Evaluate: TFloat; override;
      function Compile: TExprNode; override;
   end;

   TExprVar64Sym = class(TExprSym)
   private
      FLoc: PFloat64;
   public
      constructor Create(const AIdent: string; ALoc: PFloat64);

      function Evaluate: TFloat; override;
      function Compile: TExprNode; override;
   end;
{$IFDEF SUPPORTS_EXTENDED}

   TExprVar80Sym = class(TExprSym)
   private
      FLoc: PFloat80;
   public
      constructor Create(const AIdent: string; ALoc: PFloat80);

      function Evaluate: TFloat; override;
      function Compile: TExprNode; override;
   end;
{$ENDIF SUPPORTS_EXTENDED}

   TExprAbstractFuncSym = class(TExprSym)
   protected
      function EvalFirstArg: TFloat;
      function EvalNextArg: TFloat;
      function CompileFirstArg: TExprNode;
      function CompileNextArg: TExprNode;
      procedure EndArgs;
   end;

   TExprFuncSym = class(TExprAbstractFuncSym)
   private
      FFunc: TFloatFunc;
   public
      constructor Create(const AIdent: string; AFunc: TFloatFunc);
      function Evaluate: TFloat; override;
      function Compile: TExprNode; override;
   end;

   TExprFloat32FuncSym = class(TExprAbstractFuncSym)
   private
      FFunc: TFloat32Func;
   public
      constructor Create(const AIdent: string; AFunc: TFloat32Func);
      function Evaluate: TFloat; override;
      function Compile: TExprNode; override;
   end;

   TExprFloat64FuncSym = class(TExprAbstractFuncSym)
   private
      FFunc: TFloat64Func;
   public
      constructor Create(const AIdent: string; AFunc: TFloat64Func);
      function Evaluate: TFloat; override;
      function Compile: TExprNode; override;
   end;
{$IFDEF SUPPORTS_EXTENDED}

   TExprFloat80FuncSym = class(TExprAbstractFuncSym)
   private
      FFunc: TFloat80Func;
   public
      constructor Create(const AIdent: string; AFunc: TFloat80Func);
      function Evaluate: TFloat; override;
      function Compile: TExprNode; override;
   end;
{$ENDIF SUPPORTS_EXTENDED}

   TExprUnaryFuncSym = class(TExprAbstractFuncSym)
   private
      FFunc: TUnaryFunc;
   public
      constructor Create(const AIdent: string; AFunc: TUnaryFunc);
      function Evaluate: TFloat; override;
      function Compile: TExprNode; override;
   end;

   TExprUnary32FuncSym = class(TExprAbstractFuncSym)
   private
      FFunc: TUnary32Func;
   public
      constructor Create(const AIdent: string; AFunc: TUnary32Func);
      function Evaluate: TFloat; override;
      function Compile: TExprNode; override;
   end;

   TExprUnary64FuncSym = class(TExprAbstractFuncSym)
   private
      FFunc: TUnary64Func;
   public
      constructor Create(const AIdent: string; AFunc: TUnary64Func);
      function Evaluate: TFloat; override;
      function Compile: TExprNode; override;
   end;
{$IFDEF SUPPORTS_EXTENDED}

   TExprUnary80FuncSym = class(TExprAbstractFuncSym)
   private
      FFunc: TUnary80Func;
   public
      constructor Create(const AIdent: string; AFunc: TUnary80Func);
      function Evaluate: TFloat; override;
      function Compile: TExprNode; override;
   end;
{$ENDIF SUPPORTS_EXTENDED}

   TExprBinaryFuncSym = class(TExprAbstractFuncSym)
   private
      FFunc: TBinaryFunc;
   public
      constructor Create(const AIdent: string; AFunc: TBinaryFunc);
      function Evaluate: TFloat; override;
      function Compile: TExprNode; override;
   end;

   TExprBinary32FuncSym = class(TExprAbstractFuncSym)
   private
      FFunc: TBinary32Func;
   public
      constructor Create(const AIdent: string; AFunc: TBinary32Func);
      function Evaluate: TFloat; override;
      function Compile: TExprNode; override;
   end;

   TExprBinary64FuncSym = class(TExprAbstractFuncSym)
   private
      FFunc: TBinary64Func;
   public
      constructor Create(const AIdent: string; AFunc: TBinary64Func);
      function Evaluate: TFloat; override;
      function Compile: TExprNode; override;
   end;
{$IFDEF SUPPORTS_EXTENDED}

   TExprBinary80FuncSym = class(TExprAbstractFuncSym)
   private
      FFunc: TBinary80Func;
   public
      constructor Create(const AIdent: string; AFunc: TBinary80Func);
      function Evaluate: TFloat; override;
      function Compile: TExprNode; override;
   end;
{$ENDIF SUPPORTS_EXTENDED}

   TExprTernaryFuncSym = class(TExprAbstractFuncSym)
   private
      FFunc: TTernaryFunc;
   public
      constructor Create(const AIdent: string; AFunc: TTernaryFunc);
      function Evaluate: TFloat; override;
      function Compile: TExprNode; override;
   end;

   TExprTernary32FuncSym = class(TExprAbstractFuncSym)
   private
      FFunc: TTernary32Func;
   public
      constructor Create(const AIdent: string; AFunc: TTernary32Func);
      function Evaluate: TFloat; override;
      function Compile: TExprNode; override;
   end;

   TExprTernary64FuncSym = class(TExprAbstractFuncSym)
   private
      FFunc: TTernary64Func;
   public
      constructor Create(const AIdent: string; AFunc: TTernary64Func);
      function Evaluate: TFloat; override;
      function Compile: TExprNode; override;
   end;
{$IFDEF SUPPORTS_EXTENDED}

   TExprTernary80FuncSym = class(TExprAbstractFuncSym)
   private
      FFunc: TTernary80Func;
   public
      constructor Create(const AIdent: string; AFunc: TTernary80Func);
      function Evaluate: TFloat; override;
      function Compile: TExprNode; override;
   end;
{$ENDIF SUPPORTS_EXTENDED}
   { TODO : change this definition to be just a normal function pointer, not
     a closure; will require a small executable memory allocater, and a
     couple of injected instructions. Similar concept to
     Forms.MakeObjectInstance.

     This will allow compiled expressions to be used as functions in
     contexts. Parameters won't be supported, though; I'll think about
     this. }

   TCompiledExpression = function: TFloat of object;

   TExpressionCompiler = class(TEasyEvaluator)
   private
      FExprHash: TStringHashMap;
   public
      constructor Create;
      destructor Destroy; override;
      function Compile(const AExpr: string): TCompiledExpression;
      procedure Remove(const AExpr: string);
      procedure Delete(ACompiledExpression: TCompiledExpression);
      procedure Clear; override;
   end;
{$IFDEF UNITVERSIONING}

const
   UnitVersioning: TUnitVersionInfo = (RCSfile:
        '$URL: https://jcl.svn.sourceforge.net/svnroot/jcl/tags/JCL-2.1-Build3536/jcl/source/common/JclExprEval.pas $';
      Revision: '$Revision: 2921 $';
      Date: '$Date: 2009-08-09 15:08:29 +0200 (dim., 09 ao没t 2009) $';
      LogPath: 'JCL\source\common'; Extra: ''; Data: nil);
{$ENDIF UNITVERSIONING}

implementation

uses
{$IFDEF SUPPORTS_INLINE}
   Windows, // inline of AnsiSameText
{$ENDIF SUPPORTS_INLINE}
   JclStrings;

// === { TExprHashContext } ===================================================











// === { TExprSetContext } ====================================================



















// === { TExprSym } ===========================================================



// === { TExprLexer } =========================================================

constructor TExprLexer.Create;
begin
   inherited Create;
   Reset;
end;

procedure TExprLexer.Reset;
begin
   NextTok;
end;

// === { TExprCompileParser } =================================================

constructor TExprCompileParser.Create(ALexer: TExprLexer;
   ANodeFactory: TExprNodeFactory);
begin
   inherited Create;
   FLexer := ALexer;
   FNodeFactory := ANodeFactory;
end;

function TExprCompileParser.Compile: TExprNode;
begin
   Result := CompileExprLevel0(False);
end;

function TExprCompileParser.CompileExprLevel0(ASkip: Boolean): TExprNode;
begin
   Result := CompileExprLevel1(ASkip);

   { Utilize some of these compound instructions to test DAG optimization
     techniques later on.

     Playing a few games after much hard work, too.
     Functional programming is fun! :-> BJK }
   while True do
      case Lexer.CurrTok of
         etEqualTo: // =
            Result := NodeFactory.CompareEqual(Result, CompileExprLevel1(True));
         etNotEqual: // <>
            Result := NodeFactory.CompareNotEqual
              (Result, CompileExprLevel1(True));
         etLessThan: // <
            Result := NodeFactory.CompareLess(Result, CompileExprLevel1(True));
         etLessEqual: // <=
            Result := NodeFactory.CompareLessEqual
              (Result, CompileExprLevel1(True));
         etGreaterThan: // >
            Result := NodeFactory.CompareGreater
              (Result, CompileExprLevel1(True));
         etGreaterEqual: // >=
            Result := NodeFactory.CompareGreaterEqual
              (Result, CompileExprLevel1(True));
         etIdentifier: // cmp
            if AnsiSameText(Lexer.TokenAsString, 'cmp') then
               Result := NodeFactory.Compare(Result, CompileExprLevel1(True))
            else
               Break;
      else
         Break;
      end;
end;

function TExprCompileParser.CompileExprLevel1(ASkip: Boolean): TExprNode;
begin
   Result := CompileExprLevel2(ASkip);

   while True do
      case Lexer.CurrTok of
         etPlus:
            Result := NodeFactory.Add(Result, CompileExprLevel2(True));
         etMinus:
            Result := NodeFactory.Subtract(Result, CompileExprLevel2(True));
         etIdentifier: // or, xor, bor, bxor
            if AnsiSameText(Lexer.TokenAsString, 'or') then
               Result := NodeFactory.LogicalOr(Result, CompileExprLevel2(True))
            else if AnsiSameText(Lexer.TokenAsString, 'xor') then
               Result := NodeFactory.LogicalXor(Result, CompileExprLevel2(True))
            else if AnsiSameText(Lexer.TokenAsString, 'bor') then
               Result := NodeFactory.BitwiseOr(Result, CompileExprLevel2(True))
            else if AnsiSameText(Lexer.TokenAsString, 'bxor') then
               Result := NodeFactory.BitwiseXor(Result, CompileExprLevel2(True))
            else
               Break;
      else
         Break;
      end;
end;

function TExprCompileParser.CompileExprLevel2(ASkip: Boolean): TExprNode;
begin
   Result := CompileExprLevel3(ASkip);

   while True do
      case Lexer.CurrTok of
         etAsterisk:
            Result := NodeFactory.Multiply(Result, CompileExprLevel3(True));
         etForwardSlash:
            Result := NodeFactory.Divide(Result, CompileExprLevel3(True));
         etIdentifier: // div, mod, and, shl, shr, band
            if AnsiSameText(Lexer.TokenAsString, 'div') then
               Result := NodeFactory.IntegerDivide
                 (Result, CompileExprLevel3(True))
            else if AnsiSameText(Lexer.TokenAsString, 'mod') then
               Result := NodeFactory.Modulo(Result, CompileExprLevel3(True))
            else if AnsiSameText(Lexer.TokenAsString, 'and') then
               Result := NodeFactory.LogicalAnd(Result, CompileExprLevel3(True))
            else if AnsiSameText(Lexer.TokenAsString, 'shl') then
               Result := NodeFactory.ShiftLeft(Result, CompileExprLevel3(True))
            else if AnsiSameText(Lexer.TokenAsString, 'shr') then
               Result := NodeFactory.ShiftRight(Result, CompileExprLevel3(True))
            else if AnsiSameText(Lexer.TokenAsString, 'band') then
               Result := NodeFactory.BitwiseAnd(Result, CompileExprLevel3(True))
            else
               Break;
      else
         Break;
      end;
end;

function TExprCompileParser.CompileExprLevel3(ASkip: Boolean): TExprNode;
begin
   if ASkip then
      Lexer.NextTok;

   case Lexer.CurrTok of
      etPlus:
         Result := CompileExprLevel3(True);
      etMinus:
         Result := NodeFactory.Negate(CompileExprLevel3(True));
      etIdentifier: // not, bnot
         if AnsiSameText(Lexer.TokenAsString, 'not') then
            Result := NodeFactory.LogicalNot(CompileExprLevel3(True))
         else if AnsiSameText(Lexer.TokenAsString, 'bnot') then
            Result := NodeFactory.BitwiseNot(CompileExprLevel3(True))
         else
            Result := CompileFactor;
   else
      Result := CompileFactor;
   end;
end;

function TExprCompileParser.CompileFactor: TExprNode;
begin
   case Lexer.CurrTok of
      etIdentifier:
         Result := CompileIdentFactor;
      etLParen:
         begin
            Result := CompileExprLevel0(True);
            if Lexer.CurrTok <> etRParen then
               raise EJclExprEvalError.CreateRes(@RsExprEvalRParenExpected);
            Lexer.NextTok;
         end;
      etNumber:
         begin
            Result := NodeFactory.LoadConst(Lexer.TokenAsNumber);
            Lexer.NextTok;
         end;
   else
      raise EJclExprEvalError.CreateRes(@RsExprEvalFactorExpected);
   end;
end;

function TExprCompileParser.CompileIdentFactor: TExprNode;
var
   Sym: TExprSym;
   oldCompileParser: TExprCompileParser;
   oldLexer: TExprLexer;
   oldNodeFactory: TExprNodeFactory;
begin
   { find symbol }
   if FContext = nil then
      raise EJclExprEvalError.CreateResFmt
        (@RsExprEvalUnknownSymbol, [Lexer.TokenAsString]);
   Sym := FContext.Find(Lexer.TokenAsString);
   if Sym = nil then
      raise EJclExprEvalError.CreateResFmt
        (@RsExprEvalUnknownSymbol, [Lexer.TokenAsString]);

   Lexer.NextTok;

   { set symbol properties }
   oldCompileParser := Sym.CompileParser;
   oldLexer := Sym.Lexer;
   oldNodeFactory := Sym.NodeFactory;
   Sym.FLexer := Lexer;
   Sym.FCompileParser := Self;
   Sym.FNodeFactory := NodeFactory;
   try
      { compile symbol }
      Result := Sym.Compile;
   finally
      Sym.FLexer := oldLexer;
      Sym.FCompileParser := oldCompileParser;
      Sym.FNodeFactory := oldNodeFactory;
   end;
end;

// === { TExprEvalParser } ====================================================

















// === { TExprSimpleLexer } ===================================================









// === { TExprNode } ==========================================================

constructor TExprNode.Create(const ADepList: array of TExprNode);
var
   I: Integer;
begin
   inherited Create;
   FDepList := TList.Create;
   for I := Low(ADepList) to High(ADepList) do
      AddDep(ADepList[I]);
end;

destructor TExprNode.Destroy;
begin
   FDepList.Free;
   inherited Destroy;
end;

procedure TExprNode.AddDep(ADep: TExprNode);
begin
   FDepList.Add(ADep);
end;

function TExprNode.GetDepCount: Integer;
begin
   Result := FDepList.Count;
end;

function TExprNode.GetDeps(AIndex: Integer): TExprNode;
begin
   Result := TExprNode(FDepList[AIndex]);
end;

// === { TExprNodeFactory } ===================================================

function TExprNodeFactory.LoadVar(ALoc: PFloat32): TExprNode;
begin
   Result := LoadVar32(ALoc);
end;

function TExprNodeFactory.LoadVar(ALoc: PFloat64): TExprNode;
begin
   Result := LoadVar64(ALoc);
end;
{$IFDEF SUPPORTS_EXTENDED}

function TExprNodeFactory.LoadVar(ALoc: PFloat80): TExprNode;
begin
   Result := LoadVar80(ALoc);
end;
{$ENDIF SUPPORTS_EXTENDED}

function TExprNodeFactory.LoadConst(AValue: TFloat32): TExprNode;
begin
   Result := LoadConst32(AValue);
end;

function TExprNodeFactory.LoadConst(AValue: TFloat64): TExprNode;
begin
   Result := LoadConst64(AValue);
end;
{$IFDEF SUPPORTS_EXTENDED}

function TExprNodeFactory.LoadConst(AValue: TFloat80): TExprNode;
begin
   Result := LoadConst80(AValue);
end;
{$ENDIF SUPPORTS_EXTENDED}
// === { TEvaluator } =========================================================







// === { TExprVirtMachOp } ====================================================



// === Virtual machine operators follow =======================================

type
   { abstract base for var readers }

   { the var readers }

   TExprVar32VmOp = class(TExprVarVmOp)
   public
      procedure Execute; override;
   end;

   TExprVar64VmOp = class(TExprVarVmOp)
   public
      procedure Execute; override;
   end;
{$IFDEF SUPPORTS_EXTENDED}

   TExprVar80VmOp = class(TExprVarVmOp)
   public
      procedure Execute; override;
   end;
{$ENDIF SUPPORTS_EXTENDED}

   { the const holder }
   TExprConstVmOp = class(TExprVirtMachOp)
   public
      constructor Create(AValue: TFloat);
      { null function }
      procedure Execute; override;
   end;

   { abstract unary operator }
   TExprUnaryVmOp = class(TExprVirtMachOp)
   protected
      FInput: PFloat;
   public
      constructor Create(AInput: PFloat);
      property Input: PFloat read FInput write FInput;
   end;

   TExprUnaryVmOpClass = class of TExprUnaryVmOp;

   { abstract binary operator }
   TExprBinaryVmOp = class(TExprVirtMachOp)
   protected
      FLeft: PFloat;
      FRight: PFloat;
   public
      constructor Create(ALeft, ARight: PFloat);
      property Left: PFloat read FLeft write FLeft;
      property Right: PFloat read FRight write FRight;
   end;

   TExprBinaryVmOpClass = class of TExprBinaryVmOp;

   { the 4 basic binary operators }

   TExprAddVmOp = class(TExprBinaryVmOp)
   public
      procedure Execute; override;
   end;

   TExprSubtractVmOp = class(TExprBinaryVmOp)
   public
      procedure Execute; override;
   end;

   TExprMultiplyVmOp = class(TExprBinaryVmOp)
   public
      procedure Execute; override;
   end;

   TExprDivideVmOp = class(TExprBinaryVmOp)
   public
      procedure Execute; override;
   end;

   TExprCompareVmOp = class(TExprBinaryVmOp)
   public
      procedure Execute; override;
   end;

   TExprGreaterVmOp = class(TExprBinaryVmOp)
   public
      procedure Execute; override;
   end;

   TExprGreaterEqualVmOp = class(TExprBinaryVmOp)
   public
      procedure Execute; override;
   end;

   TExprLessVmOp = class(TExprBinaryVmOp)
   public
      procedure Execute; override;
   end;

   TExprLessEqualVmOp = class(TExprBinaryVmOp)
   public
      procedure Execute; override;
   end;

   TExprEqualVmOp = class(TExprBinaryVmOp)
   public
      procedure Execute; override;
   end;

   TExprNotEqualVmOp = class(TExprBinaryVmOp)
   public
      procedure Execute; override;
   end;

   TExprIntegerDivideVmOp = class(TExprBinaryVmOp)
   public
      procedure Execute; override;
   end;

   TExprModuloVmOp = class(TExprBinaryVmOp)
   public
      procedure Execute; override;
   end;

   TExprShiftLeftVmOp = class(TExprBinaryVmOp)
   public
      procedure Execute; override;
   end;

   TExprShiftRightVmOp = class(TExprBinaryVmOp)
   public
      procedure Execute; override;
   end;

   TExprBitwiseAndVmOp = class(TExprBinaryVmOp)
   public
      procedure Execute; override;
   end;

   TExprBitwiseOrVmOp = class(TExprBinaryVmOp)
   public
      procedure Execute; override;
   end;

   TExprBitwiseXorVmOp = class(TExprBinaryVmOp)
   public
      procedure Execute; override;
   end;

   TExprLogicalAndVmOp = class(TExprBinaryVmOp)
   public
      procedure Execute; override;
   end;

   TExprLogicalOrVmOp = class(TExprBinaryVmOp)
   public
      procedure Execute; override;
   end;

   TExprLogicalXorVmOp = class(TExprBinaryVmOp)
   public
      procedure Execute; override;
   end;

   { the unary operators }

   TExprNegateVmOp = class(TExprUnaryVmOp)
   public
      procedure Execute; override;
   end;

   TExprLogicalNotVmOp = class(TExprUnaryVmOp)
   public
      procedure Execute; override;
   end;

   TExprBitwiseNotVmOp = class(TExprUnaryVmOp)
   public
      procedure Execute; override;
   end;

   { function calls }

   TExprCallFloatVmOp = class(TExprVirtMachOp)
   private
      FFunc: TFloatFunc;
   public
      constructor Create(AFunc: TFloatFunc);
      procedure Execute; override;
   end;

   TExprCallFloat32VmOp = class(TExprVirtMachOp)
   private
      FFunc: TFloat32Func;
   public
      constructor Create(AFunc: TFloat32Func);
      procedure Execute; override;
   end;

   TExprCallFloat64VmOp = class(TExprVirtMachOp)
   private
      FFunc: TFloat64Func;
   public
      constructor Create(AFunc: TFloat64Func);
      procedure Execute; override;
   end;
{$IFDEF SUPPORTS_EXTENDED}

   TExprCallFloat80VmOp = class(TExprVirtMachOp)
   private
      FFunc: TFloat80Func;
   public
      constructor Create(AFunc: TFloat80Func);
      procedure Execute; override;
   end;
{$ENDIF SUPPORTS_EXTENDED}

   TExprCallUnaryVmOp = class(TExprVirtMachOp)
   private
      FFunc: TUnaryFunc;
      FX: PFloat;
   public
      constructor Create(AFunc: TUnaryFunc; X: PFloat);
      procedure Execute; override;
   end;

   TExprCallUnary32VmOp = class(TExprVirtMachOp)
   private
      FFunc: TUnary32Func;
      FX: PFloat;
   public
      constructor Create(AFunc: TUnary32Func; X: PFloat);
      procedure Execute; override;
   end;

   TExprCallUnary64VmOp = class(TExprVirtMachOp)
   private
      FFunc: TUnary64Func;
      FX: PFloat;
   public
      constructor Create(AFunc: TUnary64Func; X: PFloat);
      procedure Execute; override;
   end;
{$IFDEF SUPPORTS_EXTENDED}

   TExprCallUnary80VmOp = class(TExprVirtMachOp)
   private
      FFunc: TUnary80Func;
      FX: PFloat;
   public
      constructor Create(AFunc: TUnary80Func; X: PFloat);
      procedure Execute; override;
   end;
{$ENDIF SUPPORTS_EXTENDED}

   TExprCallBinaryVmOp = class(TExprVirtMachOp)
   private
      FFunc: TBinaryFunc;
      FX, FY: PFloat;
   public
      constructor Create(AFunc: TBinaryFunc; X, Y: PFloat);
      procedure Execute; override;
   end;

   TExprCallBinary32VmOp = class(TExprVirtMachOp)
   private
      FFunc: TBinary32Func;
      FX, FY: PFloat;
   public
      constructor Create(AFunc: TBinary32Func; X, Y: PFloat);
      procedure Execute; override;
   end;

   TExprCallBinary64VmOp = class(TExprVirtMachOp)
   private
      FFunc: TBinary64Func;
      FX, FY: PFloat;
   public
      constructor Create(AFunc: TBinary64Func; X, Y: PFloat);
      procedure Execute; override;
   end;
{$IFDEF SUPPORTS_EXTENDED}

   TExprCallBinary80VmOp = class(TExprVirtMachOp)
   private
      FFunc: TBinary80Func;
      FX, FY: PFloat;
   public
      constructor Create(AFunc: TBinary80Func; X, Y: PFloat);
      procedure Execute; override;
   end;
{$ENDIF SUPPORTS_EXTENDED}

   TExprCallTernaryVmOp = class(TExprVirtMachOp)
   private
      FFunc: TTernaryFunc;
      FX, FY, FZ: PFloat;
   public
      constructor Create(AFunc: TTernaryFunc; X, Y, Z: PFloat);
      procedure Execute; override;
   end;

   TExprCallTernary32VmOp = class(TExprVirtMachOp)
   private
      FFunc: TTernary32Func;
      FX, FY, FZ: PFloat;
   public
      constructor Create(AFunc: TTernary32Func; X, Y, Z: PFloat);
      procedure Execute; override;
   end;

   TExprCallTernary64VmOp = class(TExprVirtMachOp)
   private
      FFunc: TTernary64Func;
      FX, FY, FZ: PFloat;
   public
      constructor Create(AFunc: TTernary64Func; X, Y, Z: PFloat);
      procedure Execute; override;
   end;
{$IFDEF SUPPORTS_EXTENDED}

   TExprCallTernary80VmOp = class(TExprVirtMachOp)
   private
      FFunc: TTernary80Func;
      FX, FY, FZ: PFloat;
   public
      constructor Create(AFunc: TTernary80Func; X, Y, Z: PFloat);
      procedure Execute; override;
   end;
{$ENDIF SUPPORTS_EXTENDED}
   // === { TExprVar32VmOp } =====================================================

procedure TExprVar32VmOp.Execute;
begin
   FOutput := PFloat32(FVarLoc)^;
end;

// === { TExprVar64VmOp } =====================================================

procedure TExprVar64VmOp.Execute;
begin
   FOutput := PFloat64(FVarLoc)^;
end;
{$IFDEF SUPPORTS_EXTENDED}
// === { TExprVar80VmOp } =====================================================

procedure TExprVar80VmOp.Execute;
begin
   FOutput := PFloat80(FVarLoc)^;
end;
{$ENDIF SUPPORTS_EXTENDED}
// === { TExprConstVmOp } =====================================================

constructor TExprConstVmOp.Create(AValue: TFloat);
begin
   inherited Create;
   FOutput := AValue;
end;

procedure TExprConstVmOp.Execute;
begin
end;

// === { TExprUnaryVmOp } =====================================================

constructor TExprUnaryVmOp.Create(AInput: PFloat);
begin
   inherited Create;
   FInput := AInput;
end;

// === { TExprBinaryVmOp } ====================================================

constructor TExprBinaryVmOp.Create(ALeft, ARight: PFloat);
begin
   inherited Create;
   FLeft := ALeft;
   FRight := ARight;
end;

// === { TExprAddVmOp } =======================================================
procedure TExprAddVmOp.Execute;
begin
   FOutput := FLeft^ + FRight^;
end;

// === { TExprSubtractVmOp } ==================================================

procedure TExprSubtractVmOp.Execute;
begin
   FOutput := FLeft^ - FRight^;
end;

// === { TExprMultiplyVmOp } ==================================================

procedure TExprMultiplyVmOp.Execute;
begin
   FOutput := FLeft^ * FRight^;
end;

// === { TExprDivideVmOp } ====================================================

procedure TExprDivideVmOp.Execute;
begin
   FOutput := FLeft^ / FRight^;
end;

// === { TExprCompareVmOp } ===================================================

procedure TExprCompareVmOp.Execute;
begin
   if FLeft^ < FRight^ then
      FOutput := -1.0
   else if FLeft^ > FRight^ then
      FOutput := 1.0
   else
      FOutput := 0.0;
end;

// === { TExprCmpGreaterVmOp } ================================================

procedure TExprGreaterVmOp.Execute;
begin
   if FLeft^ > FRight^ then
      FOutput := 1.0
   else
      FOutput := 0.0;
end;

// === { TExprCmpGreaterEqualVmOp } ===========================================

procedure TExprGreaterEqualVmOp.Execute;
begin
   if FLeft^ >= FRight^ then
      FOutput := 1.0
   else
      FOutput := 0.0;
end;

// === { TExprCmpLessVmOp } ===================================================

procedure TExprLessVmOp.Execute;
begin
   if FLeft^ < FRight^ then
      FOutput := 1.0
   else
      FOutput := 0.0;
end;

// === { TExprCmpLessEqualVmOp } =============================================

procedure TExprLessEqualVmOp.Execute;
begin
   if FLeft^ <= FRight^ then
      FOutput := 1.0
   else
      FOutput := 0.0;
end;

// === { TExprCmpEqualVmOp } ==================================================

procedure TExprEqualVmOp.Execute;
begin
   if FLeft^ = FRight^ then
      FOutput := 1.0
   else
      FOutput := 0.0;
end;

// === { TExprCmpNotEqualVmOp } ===============================================

procedure TExprNotEqualVmOp.Execute;
begin
   if FLeft^ <> FRight^ then
      FOutput := 1.0
   else
      FOutput := 0.0;
end;

// === { TExprDivVmOp } =======================================================

procedure TExprIntegerDivideVmOp.Execute;
begin
   FOutput := Round(FLeft^) div Round(FRight^);
end;

// === { TExprModVmOp } =======================================================

procedure TExprModuloVmOp.Execute;
begin
   FOutput := Round(FLeft^) mod Round(FRight^);
end;

// === { TExprShiftLeftVmOp } =================================================

procedure TExprShiftLeftVmOp.Execute;
begin
   FOutput := Round(FLeft^) shl Round(FRight^);
end;

// === { TExprShiftRightVmOp } ================================================

procedure TExprShiftRightVmOp.Execute;
begin
   FOutput := Round(FLeft^) shr Round(FRight^);
end;

// === { TExprBitwiseAndVmOp } ================================================

procedure TExprBitwiseAndVmOp.Execute;
begin
   FOutput := Round(FLeft^) and Round(FRight^);
end;

// === { TExprOrVmOp } ========================================================

procedure TExprBitwiseOrVmOp.Execute;
begin
   FOutput := Round(FLeft^) or Round(FRight^);
end;

// === { TExprXorVmOp } =======================================================

procedure TExprBitwiseXorVmOp.Execute;
begin
   FOutput := Round(FLeft^) xor Round(FRight^);
end;

// === { TExprLogicalAndVmOp } ================================================

procedure TExprLogicalAndVmOp.Execute;
begin
   if (FLeft^ <> 0.0) and (FRight^ <> 0) then
      FOutput := 1.0
   else
      FOutput := 0.0;
end;

// === { TExprLogicalOrVmOp } =================================================

procedure TExprLogicalOrVmOp.Execute;
begin
   if (FLeft^ <> 0.0) or (FRight^ <> 0) then
      FOutput := 1.0
   else
      FOutput := 0.0;
end;

// === { TExprLogicalXorVmOp } ================================================

procedure TExprLogicalXorVmOp.Execute;
begin
   if (FLeft^ <> 0.0) xor (FRight^ <> 0) then
      FOutput := 1.0
   else
      FOutput := 0.0;
end;

// === { TExprNegateVmOp } ====================================================

procedure TExprNegateVmOp.Execute;
begin
   FOutput := -FInput^;
end;

// === { TExprLogicalNotVmOp } ================================================

procedure TExprLogicalNotVmOp.Execute;
begin
   if FInput^ <> 0.0 then
      FOutput := 0.0
   else
      FOutput := 1.0;
end;

// === { TExprBitwiseNotVmOp } ================================================

procedure TExprBitwiseNotVmOp.Execute;
begin
   FOutput := not Round(FInput^);
end;

// === { TExprVarVmOp } =======================================================



// === { TExprCallFloatVmOp } =================================================

constructor TExprCallFloatVmOp.Create(AFunc: TFloatFunc);
begin
   inherited Create;
   FFunc := AFunc;
end;

procedure TExprCallFloatVmOp.Execute;
begin
   FOutput := FFunc;
end;

// === { TExprCallFloat32VmOp } ===============================================

constructor TExprCallFloat32VmOp.Create(AFunc: TFloat32Func);
begin
   inherited Create;
   FFunc := AFunc;
end;

procedure TExprCallFloat32VmOp.Execute;
begin
   FOutput := FFunc;
end;

// === { TExprCallFloat64VmOp } ===============================================

constructor TExprCallFloat64VmOp.Create(AFunc: TFloat64Func);
begin
   inherited Create;
   FFunc := AFunc;
end;

procedure TExprCallFloat64VmOp.Execute;
begin
   FOutput := FFunc;
end;
{$IFDEF SUPPORTS_EXTENDED}
// === { TExprCallFloat80VmOp } ===============================================

constructor TExprCallFloat80VmOp.Create(AFunc: TFloat80Func);
begin
   inherited Create;
   FFunc := AFunc;
end;

procedure TExprCallFloat80VmOp.Execute;
begin
   FOutput := FFunc;
end;
{$ENDIF SUPPORTS_EXTENDED}
// === { TExprCallUnaryVmOp } =================================================

constructor TExprCallUnaryVmOp.Create(AFunc: TUnaryFunc; X: PFloat);
begin
   inherited Create;
   FFunc := AFunc;
   FX := X;
end;

procedure TExprCallUnaryVmOp.Execute;
begin
   FOutput := FFunc(FX^);
end;

// === { TExprCallUnary32VmOp } ===============================================

constructor TExprCallUnary32VmOp.Create(AFunc: TUnary32Func; X: PFloat);
begin
   inherited Create;
   FFunc := AFunc;
   FX := X;
end;

procedure TExprCallUnary32VmOp.Execute;
begin
   FOutput := FFunc(FX^);
end;

// === { TExprCallUnary64VmOp } ===============================================

constructor TExprCallUnary64VmOp.Create(AFunc: TUnary64Func; X: PFloat);
begin
   inherited Create;
   FFunc := AFunc;
   FX := X;
end;

procedure TExprCallUnary64VmOp.Execute;
begin
   FOutput := FFunc(FX^);
end;
{$IFDEF SUPPORTS_EXTENDED}
// === { TExprCallUnary80VmOp } ===============================================

constructor TExprCallUnary80VmOp.Create(AFunc: TUnary80Func; X: PFloat);
begin
   inherited Create;
   FFunc := AFunc;
   FX := X;
end;

procedure TExprCallUnary80VmOp.Execute;
begin
   FOutput := FFunc(FX^);
end;
{$ENDIF SUPPORTS_EXTENDED}
// === { TExprCallBinaryVmOp } ================================================

constructor TExprCallBinaryVmOp.Create(AFunc: TBinaryFunc; X, Y: PFloat);
begin
   inherited Create;
   FFunc := AFunc;
   FX := X;
   FY := Y;
end;

procedure TExprCallBinaryVmOp.Execute;
begin
   FOutput := FFunc(FX^, FY^);
end;

// === { TExprCallBinary32VmOp } ==============================================

constructor TExprCallBinary32VmOp.Create(AFunc: TBinary32Func; X, Y: PFloat);
begin
   inherited Create;
   FFunc := AFunc;
   FX := X;
   FY := Y;
end;

procedure TExprCallBinary32VmOp.Execute;
begin
   FOutput := FFunc(FX^, FY^);
end;

// === { TExprCallBinary64VmOp } ==============================================

constructor TExprCallBinary64VmOp.Create(AFunc: TBinary64Func; X, Y: PFloat);
begin
   inherited Create;
   FFunc := AFunc;
   FX := X;
   FY := Y;
end;

procedure TExprCallBinary64VmOp.Execute;
begin
   FOutput := FFunc(FX^, FY^);
end;
{$IFDEF SUPPORTS_EXTENDED}
// === { TExprCallBinary80VmOp } ==============================================

constructor TExprCallBinary80VmOp.Create(AFunc: TBinary80Func; X, Y: PFloat);
begin
   inherited Create;
   FFunc := AFunc;
   FX := X;
   FY := Y;
end;

procedure TExprCallBinary80VmOp.Execute;
begin
   FOutput := FFunc(FX^, FY^);
end;
{$ENDIF SUPPORTS_EXTENDED}
// === { TExprCallTernaryVmOp } ===============================================

constructor TExprCallTernaryVmOp.Create(AFunc: TTernaryFunc; X, Y, Z: PFloat);
begin
   inherited Create;
   FFunc := AFunc;
   FX := X;
   FY := Y;
   FZ := Z;
end;

procedure TExprCallTernaryVmOp.Execute;
begin
   FOutput := FFunc(FX^, FY^, FZ^);
end;

// === { TExprCallTernary32VmOp } =============================================

constructor TExprCallTernary32VmOp.Create
  (AFunc: TTernary32Func; X, Y, Z: PFloat);
begin
   inherited Create;
   FFunc := AFunc;
   FX := X;
   FY := Y;
   FZ := Z;
end;

procedure TExprCallTernary32VmOp.Execute;
begin
   FOutput := FFunc(FX^, FY^, FZ^);
end;

// === { TExprCallTernary64VmOp } =============================================

constructor TExprCallTernary64VmOp.Create
  (AFunc: TTernary64Func; X, Y, Z: PFloat);
begin
   inherited Create;
   FFunc := AFunc;
   FX := X;
   FY := Y;
   FZ := Z;
end;

procedure TExprCallTernary64VmOp.Execute;
begin
   FOutput := FFunc(FX^, FY^, FZ^);
end;
{$IFDEF SUPPORTS_EXTENDED}
// === { TExprCallTernary80VmOp } =============================================

constructor TExprCallTernary80VmOp.Create
  (AFunc: TTernary80Func; X, Y, Z: PFloat);
begin
   inherited Create;
   FFunc := AFunc;
   FX := X;
   FY := Y;
   FZ := Z;
end;

procedure TExprCallTernary80VmOp.Execute;
begin
   FOutput := FFunc(FX^, FY^, FZ^);
end;
{$ENDIF SUPPORTS_EXTENDED}
{ End of virtual machine operators }

// === { TExprVirtMach } ======================================================

constructor TExprVirtMach.Create;
begin
   inherited Create;
   FCodeList := TList.Create;
   FConstList := TList.Create;
end;

destructor TExprVirtMach.Destroy;
begin
   FreeObjectList(FCodeList);
   FreeObjectList(FConstList);
   inherited Destroy;
end;

function TExprVirtMach.Execute: TFloat;
type
   PExprVirtMachOp = ^TExprVirtMachOp;
var
   I: Integer;
   pop: PExprVirtMachOp;
begin
   if FCodeList.Count <> 0 then
   begin
      { The code that follows is the same as this, but a lot faster
        for I := 0 to FCodeList.Count - 1 do
        TExprVirtMachOp(FCodeList[I]).Execute; }
      I := FCodeList.Count;
      pop := @FCodeList.List^[0];
      while I > 0 do
      begin
         pop^.Execute;
         Inc(pop);
         Dec(I);
      end;
      Result := TExprVirtMachOp(FCodeList[FCodeList.Count - 1]).FOutput;
   end
   else
   begin
      if (FConstList.Count = 1) then
         Result := TExprVirtMachOp(FConstList[0]).FOutput
      else
         Result := 0;
   end;
end;

procedure TExprVirtMach.Add(AOp: TExprVirtMachOp);
begin
   FCodeList.Add(AOp);
end;

procedure TExprVirtMach.AddConst(AOp: TExprVirtMachOp);
begin
   FConstList.Add(AOp);
end;

procedure TExprVirtMach.Clear;
begin
   ClearObjectList(FCodeList);
   ClearObjectList(FConstList);
end;

// === { TExprVirtMachNode } ==================================================

type
   TExprVirtMachNode = class(TExprNode)
   private
      FExprVmCode: TExprVirtMachOp;
      function GetVmDeps(AIndex: Integer): TExprVirtMachNode;
   public
      procedure GenCode(AVirtMach: TExprVirtMach); virtual; abstract;

      property ExprVmCode: TExprVirtMachOp read FExprVmCode;

      { this property saves typecasting to access ExprVmCode }
      property VmDeps[AIndex: Integer]: TExprVirtMachNode read GetVmDeps;
      default;
   end;

function TExprVirtMachNode.GetVmDeps(AIndex: Integer): TExprVirtMachNode;
begin
   Result := TExprVirtMachNode(FDepList[AIndex]);
end;

// === Concrete expression nodes for virtual machine ==========================

type
   TExprUnaryVmNode = class(TExprVirtMachNode)
   private
      FUnaryClass: TExprUnaryVmOpClass;
   public
      constructor Create(AUnaryClass: TExprUnaryVmOpClass;
         const ADeps: array of TExprNode);
      procedure GenCode(AVirtMach: TExprVirtMach); override;
   end;

   TExprBinaryVmNode = class(TExprVirtMachNode)
   private
      FBinaryClass: TExprBinaryVmOpClass;
   public
      constructor Create(ABinaryClass: TExprBinaryVmOpClass;
         const ADeps: array of TExprNode);
      procedure GenCode(AVirtMach: TExprVirtMach); override;
   end;

   TExprConstVmNode = class(TExprVirtMachNode)
   private
      FValue: TFloat;
   public
      constructor Create(AValue: TFloat);
      procedure GenCode(AVirtMach: TExprVirtMach); override;
   end;

   TExprVar32VmNode = class(TExprVirtMachNode)
   private
      FValue: PFloat32;
   public
      constructor Create(AValue: PFloat32);
      procedure GenCode(AVirtMach: TExprVirtMach); override;
   end;

   TExprVar64VmNode = class(TExprVirtMachNode)
   private
      FValue: PFloat64;
   public
      constructor Create(AValue: PFloat64);
      procedure GenCode(AVirtMach: TExprVirtMach); override;
   end;
{$IFDEF SUPPORTS_EXTENDED}

   TExprVar80VmNode = class(TExprVirtMachNode)
   private
      FValue: PFloat80;
   public
      constructor Create(AValue: PFloat80);
      procedure GenCode(AVirtMach: TExprVirtMach); override;
   end;
{$ENDIF SUPPORTS_EXTENDED}

   TExprCallFloatVmNode = class(TExprVirtMachNode)
   private
      FFunc: TFloatFunc;
   public
      constructor Create(AFunc: TFloatFunc);
      procedure GenCode(AVirtMach: TExprVirtMach); override;
   end;

   TExprCallFloat32VmNode = class(TExprVirtMachNode)
   private
      FFunc: TFloat32Func;
   public
      constructor Create(AFunc: TFloat32Func);
      procedure GenCode(AVirtMach: TExprVirtMach); override;
   end;

   TExprCallFloat64VmNode = class(TExprVirtMachNode)
   private
      FFunc: TFloat64Func;
   public
      constructor Create(AFunc: TFloat64Func);
      procedure GenCode(AVirtMach: TExprVirtMach); override;
   end;
{$IFDEF SUPPORTS_EXTENDED}

   TExprCallFloat80VmNode = class(TExprVirtMachNode)
   private
      FFunc: TFloat80Func;
   public
      constructor Create(AFunc: TFloat80Func);
      procedure GenCode(AVirtMach: TExprVirtMach); override;
   end;
{$ENDIF SUPPORTS_EXTENDED}

   TExprCallUnaryVmNode = class(TExprVirtMachNode)
   private
      FFunc: TUnaryFunc;
   public
      constructor Create(AFunc: TUnaryFunc; X: TExprNode);
      procedure GenCode(AVirtMach: TExprVirtMach); override;
   end;

   TExprCallUnary32VmNode = class(TExprVirtMachNode)
   private
      FFunc: TUnary32Func;
   public
      constructor Create(AFunc: TUnary32Func; X: TExprNode);
      procedure GenCode(AVirtMach: TExprVirtMach); override;
   end;

   TExprCallUnary64VmNode = class(TExprVirtMachNode)
   private
      FFunc: TUnary64Func;
   public
      constructor Create(AFunc: TUnary64Func; X: TExprNode);
      procedure GenCode(AVirtMach: TExprVirtMach); override;
   end;
{$IFDEF SUPPORTS_EXTENDED}

   TExprCallUnary80VmNode = class(TExprVirtMachNode)
   private
      FFunc: TUnary80Func;
   public
      constructor Create(AFunc: TUnary80Func; X: TExprNode);
      procedure GenCode(AVirtMach: TExprVirtMach); override;
   end;
{$ENDIF SUPPORTS_EXTENDED}

   TExprCallBinaryVmNode = class(TExprVirtMachNode)
   private
      FFunc: TBinaryFunc;
   public
      constructor Create(AFunc: TBinaryFunc; X, Y: TExprNode);
      procedure GenCode(AVirtMach: TExprVirtMach); override;
   end;

   TExprCallBinary32VmNode = class(TExprVirtMachNode)
   private
      FFunc: TBinary32Func;
   public
      constructor Create(AFunc: TBinary32Func; X, Y: TExprNode);
      procedure GenCode(AVirtMach: TExprVirtMach); override;
   end;

   TExprCallBinary64VmNode = class(TExprVirtMachNode)
   private
      FFunc: TBinary64Func;
   public
      constructor Create(AFunc: TBinary64Func; X, Y: TExprNode);
      procedure GenCode(AVirtMach: TExprVirtMach); override;
   end;
{$IFDEF SUPPORTS_EXTENDED}

   TExprCallBinary80VmNode = class(TExprVirtMachNode)
   private
      FFunc: TBinary80Func;
   public
      constructor Create(AFunc: TBinary80Func; X, Y: TExprNode);
      procedure GenCode(AVirtMach: TExprVirtMach); override;
   end;
{$ENDIF SUPPORTS_EXTENDED}

   TExprCallTernaryVmNode = class(TExprVirtMachNode)
   private
      FFunc: TTernaryFunc;
   public
      constructor Create(AFunc: TTernaryFunc; X, Y, Z: TExprNode);
      procedure GenCode(AVirtMach: TExprVirtMach); override;
   end;

   TExprCallTernary32VmNode = class(TExprVirtMachNode)
   private
      FFunc: TTernary32Func;
   public
      constructor Create(AFunc: TTernary32Func; X, Y, Z: TExprNode);
      procedure GenCode(AVirtMach: TExprVirtMach); override;
   end;

   TExprCallTernary64VmNode = class(TExprVirtMachNode)
   private
      FFunc: TTernary64Func;
   public
      constructor Create(AFunc: TTernary64Func; X, Y, Z: TExprNode);
      procedure GenCode(AVirtMach: TExprVirtMach); override;
   end;
{$IFDEF SUPPORTS_EXTENDED}

   TExprCallTernary80VmNode = class(TExprVirtMachNode)
   private
      FFunc: TTernary80Func;
   public
      constructor Create(AFunc: TTernary80Func; X, Y, Z: TExprNode);
      procedure GenCode(AVirtMach: TExprVirtMach); override;
   end;
{$ENDIF SUPPORTS_EXTENDED}
   // == { TExprUnaryVmNode } ====================================================

constructor TExprUnaryVmNode.Create(AUnaryClass: TExprUnaryVmOpClass;
   const ADeps: array of TExprNode);
begin
   FUnaryClass := AUnaryClass;
   inherited Create(ADeps);
   Assert(FDepList.Count = 1);
end;

procedure TExprUnaryVmNode.GenCode(AVirtMach: TExprVirtMach);
begin
   FExprVmCode := FUnaryClass.Create(VmDeps[0].ExprVmCode.OutputLoc);
   AVirtMach.Add(FExprVmCode);
end;

// === { TExprBinaryVmNode } ==================================================

constructor TExprBinaryVmNode.Create(ABinaryClass: TExprBinaryVmOpClass;
   const ADeps: array of TExprNode);
begin
   FBinaryClass := ABinaryClass;
   inherited Create(ADeps);
   Assert(FDepList.Count = 2);
end;

procedure TExprBinaryVmNode.GenCode(AVirtMach: TExprVirtMach);
begin
   FExprVmCode := FBinaryClass.Create(VmDeps[0].ExprVmCode.OutputLoc,
      VmDeps[1].ExprVmCode.OutputLoc);
   AVirtMach.Add(FExprVmCode);
end;

// === {  TExprConstVmNode } ==================================================

constructor TExprConstVmNode.Create(AValue: TFloat);
begin
   FValue := AValue;
   inherited Create([]);
end;

procedure TExprConstVmNode.GenCode(AVirtMach: TExprVirtMach);
begin
   FExprVmCode := TExprConstVmOp.Create(FValue);
   AVirtMach.AddConst(FExprVmCode);
end;

// === { TExprVar32VmNode } ===================================================

constructor TExprVar32VmNode.Create(AValue: PFloat32);
begin
   FValue := AValue;
   inherited Create([]);
end;

procedure TExprVar32VmNode.GenCode(AVirtMach: TExprVirtMach);
begin
   FExprVmCode := TExprVar32VmOp.Create(FValue);
   AVirtMach.Add(FExprVmCode);
end;

// === { TExprVar64VmNode } ===================================================

constructor TExprVar64VmNode.Create(AValue: PFloat64);
begin
   FValue := AValue;
   inherited Create([]);
end;

procedure TExprVar64VmNode.GenCode(AVirtMach: TExprVirtMach);
begin
   FExprVmCode := TExprVar64VmOp.Create(FValue);
   AVirtMach.Add(FExprVmCode);
end;
{$IFDEF SUPPORTS_EXTENDED}
// === { TExprVar80VmNode } ===================================================

constructor TExprVar80VmNode.Create(AValue: PFloat80);
begin
   FValue := AValue;
   inherited Create([]);
end;

procedure TExprVar80VmNode.GenCode(AVirtMach: TExprVirtMach);
begin
   FExprVmCode := TExprVar80VmOp.Create(FValue);
   AVirtMach.Add(FExprVmCode);
end;
{$ENDIF SUPPORTS_EXTENDED}
{ End of expression nodes for virtual machine }

// === { TExprVirtMachNodeFactory } ===========================================

constructor TExprVirtMachNodeFactory.Create;
begin
   inherited Create;
   FNodeList := TList.Create;
end;

destructor TExprVirtMachNodeFactory.Destroy;
begin
   FreeObjectList(FNodeList);
   inherited Destroy;
end;

function TExprVirtMachNodeFactory.AddNode(ANode: TExprNode): TExprNode;
begin
   Result := ANode;
   FNodeList.Add(ANode);
end;

procedure TExprVirtMachNodeFactory.GenCode(AVirtMach: TExprVirtMach);
begin
   { TODO : optimize the expression tree into a DAG (i.e. find CSEs) and
     evaluate constant subexpressions, implement strength reduction, etc. }

   { TODO : move optimization logic (as far as possible) into ancestor classes
     once tested and interfaces are solid, so that other evaluation strategies
     can take advantage of these optimizations. }

   DoClean(AVirtMach);
   DoConsts(AVirtMach);
   DoCode(AVirtMach);
end;

function TExprVirtMachNodeFactory.LoadVar32(ALoc: PFloat32): TExprNode;
begin
   Result := AddNode(TExprVar32VmNode.Create(ALoc));
end;

function TExprVirtMachNodeFactory.LoadVar64(ALoc: PFloat64): TExprNode;
begin
   Result := AddNode(TExprVar64VmNode.Create(ALoc));
end;
{$IFDEF SUPPORTS_EXTENDED}

function TExprVirtMachNodeFactory.LoadVar80(ALoc: PFloat80): TExprNode;
begin
   Result := AddNode(TExprVar80VmNode.Create(ALoc));
end;
{$ENDIF SUPPORTS_EXTENDED}

function TExprVirtMachNodeFactory.LoadConst32(AValue: TFloat32): TExprNode;
begin
   Result := AddNode(TExprConstVmNode.Create(AValue));
end;

function TExprVirtMachNodeFactory.LoadConst64(AValue: TFloat64): TExprNode;
begin
   Result := AddNode(TExprConstVmNode.Create(AValue));
end;
{$IFDEF SUPPORTS_EXTENDED}

function TExprVirtMachNodeFactory.LoadConst80(AValue: TFloat80): TExprNode;
begin
   Result := AddNode(TExprConstVmNode.Create(AValue));
end;
{$ENDIF SUPPORTS_EXTENDED}

function TExprVirtMachNodeFactory.Add(ALeft, ARight: TExprNode): TExprNode;
begin
   Result := AddNode(TExprBinaryVmNode.Create(TExprAddVmOp, [ALeft, ARight]));
end;

function TExprVirtMachNodeFactory.Subtract(ALeft, ARight: TExprNode): TExprNode;
begin
   Result := AddNode(TExprBinaryVmNode.Create
        (TExprSubtractVmOp, [ALeft, ARight]));
end;

function TExprVirtMachNodeFactory.Multiply(ALeft, ARight: TExprNode): TExprNode;
begin
   Result := AddNode(TExprBinaryVmNode.Create
        (TExprMultiplyVmOp, [ALeft, ARight]));
end;

function TExprVirtMachNodeFactory.Divide(ALeft, ARight: TExprNode): TExprNode;
begin
   Result := AddNode(TExprBinaryVmNode.Create(TExprDivideVmOp, [ALeft, ARight])
     );
end;

function TExprVirtMachNodeFactory.IntegerDivide(ALeft, ARight: TExprNode)
  : TExprNode;
begin
   Result := AddNode(TExprBinaryVmNode.Create(TExprIntegerDivideVmOp,
         [ALeft, ARight]));
end;

function TExprVirtMachNodeFactory.Modulo(ALeft, ARight: TExprNode): TExprNode;
begin
   Result := AddNode(TExprBinaryVmNode.Create(TExprModuloVmOp, [ALeft, ARight])
     );
end;

function TExprVirtMachNodeFactory.Negate(AValue: TExprNode): TExprNode;
begin
   Result := AddNode(TExprUnaryVmNode.Create(TExprNegateVmOp, [AValue]));
end;

procedure TExprVirtMachNodeFactory.DoClean(AVirtMach: TExprVirtMach);
var
   I: Integer;
begin
   { clean up in preparation for code generation }
   AVirtMach.Clear;
   for I := 0 to FNodeList.Count - 1 do
      TExprVirtMachNode(FNodeList[I]).FExprVmCode := nil;
end;

procedure TExprVirtMachNodeFactory.DoConsts(AVirtMach: TExprVirtMach);
var
   I: Integer;
   Node: TExprVirtMachNode;
begin
   { process consts }
   for I := 0 to FNodeList.Count - 1 do
   begin
      Node := TExprVirtMachNode(FNodeList[I]);
      if (Node is TExprConstVmNode) and (Node.ExprVmCode = nil) then
         Node.GenCode(AVirtMach);
   end;
end;

procedure TExprVirtMachNodeFactory.DoCode(AVirtMach: TExprVirtMach);
var
   I: Integer;
   Node: TExprVirtMachNode;
begin
   { process code }
   for I := 0 to FNodeList.Count - 1 do
   begin
      Node := TExprVirtMachNode(FNodeList[I]);
      if Node.ExprVmCode = nil then
         Node.GenCode(AVirtMach);
   end;
end;

function TExprVirtMachNodeFactory.CallFloatFunc(AFunc: TFloatFunc): TExprNode;
begin
   Result := AddNode(TExprCallFloatVmNode.Create(AFunc));
end;

function TExprVirtMachNodeFactory.CallFloat32Func(AFunc: TFloat32Func)
  : TExprNode;
begin
   Result := AddNode(TExprCallFloat32VmNode.Create(AFunc));
end;

function TExprVirtMachNodeFactory.CallFloat64Func(AFunc: TFloat64Func)
  : TExprNode;
begin
   Result := AddNode(TExprCallFloat64VmNode.Create(AFunc));
end;
{$IFDEF SUPPORTS_EXTENDED}

function TExprVirtMachNodeFactory.CallFloat80Func(AFunc: TFloat80Func)
  : TExprNode;
begin
   Result := AddNode(TExprCallFloat80VmNode.Create(AFunc));
end;
{$ENDIF SUPPORTS_EXTENDED}

function TExprVirtMachNodeFactory.CallUnaryFunc(AFunc: TUnaryFunc; X: TExprNode)
  : TExprNode;
begin
   Result := AddNode(TExprCallUnaryVmNode.Create(AFunc, X));
end;

function TExprVirtMachNodeFactory.CallUnary32Func
  (AFunc: TUnary32Func; X: TExprNode): TExprNode;
begin
   Result := AddNode(TExprCallUnary32VmNode.Create(AFunc, X));
end;

function TExprVirtMachNodeFactory.CallUnary64Func
  (AFunc: TUnary64Func; X: TExprNode): TExprNode;
begin
   Result := AddNode(TExprCallUnary64VmNode.Create(AFunc, X));
end;
{$IFDEF SUPPORTS_EXTENDED}

function TExprVirtMachNodeFactory.CallUnary80Func
  (AFunc: TUnary80Func; X: TExprNode): TExprNode;
begin
   Result := AddNode(TExprCallUnary80VmNode.Create(AFunc, X));
end;
{$ENDIF SUPPORTS_EXTENDED}

function TExprVirtMachNodeFactory.CallBinaryFunc
  (AFunc: TBinaryFunc; X, Y: TExprNode): TExprNode;
begin
   Result := AddNode(TExprCallBinaryVmNode.Create(AFunc, X, Y));
end;

function TExprVirtMachNodeFactory.CallBinary32Func
  (AFunc: TBinary32Func; X, Y: TExprNode): TExprNode;
begin
   Result := AddNode(TExprCallBinary32VmNode.Create(AFunc, X, Y));
end;

function TExprVirtMachNodeFactory.CallBinary64Func
  (AFunc: TBinary64Func; X, Y: TExprNode): TExprNode;
begin
   Result := AddNode(TExprCallBinary64VmNode.Create(AFunc, X, Y));
end;
{$IFDEF SUPPORTS_EXTENDED}

function TExprVirtMachNodeFactory.CallBinary80Func
  (AFunc: TBinary80Func; X, Y: TExprNode): TExprNode;
begin
   Result := AddNode(TExprCallBinary80VmNode.Create(AFunc, X, Y));
end;
{$ENDIF SUPPORTS_EXTENDED}

function TExprVirtMachNodeFactory.CallTernaryFunc
  (AFunc: TTernaryFunc; X, Y, Z: TExprNode): TExprNode;
begin
   Result := AddNode(TExprCallTernaryVmNode.Create(AFunc, X, Y, Z));
end;

function TExprVirtMachNodeFactory.CallTernary32Func
  (AFunc: TTernary32Func; X, Y, Z: TExprNode): TExprNode;
begin
   Result := AddNode(TExprCallTernary32VmNode.Create(AFunc, X, Y, Z));
end;

function TExprVirtMachNodeFactory.CallTernary64Func
  (AFunc: TTernary64Func; X, Y, Z: TExprNode): TExprNode;
begin
   Result := AddNode(TExprCallTernary64VmNode.Create(AFunc, X, Y, Z));
end;
{$IFDEF SUPPORTS_EXTENDED}

function TExprVirtMachNodeFactory.CallTernary80Func
  (AFunc: TTernary80Func; X, Y, Z: TExprNode): TExprNode;
begin
   Result := AddNode(TExprCallTernary80VmNode.Create(AFunc, X, Y, Z));
end;
{$ENDIF SUPPORTS_EXTENDED}

function TExprVirtMachNodeFactory.Compare(ALeft, ARight: TExprNode): TExprNode;
begin
   Result := AddNode(TExprBinaryVmNode.Create(TExprCompareVmOp, [ALeft, ARight])
     );
end;

function TExprVirtMachNodeFactory.CompareEqual(ALeft, ARight: TExprNode)
  : TExprNode;
begin
   Result := AddNode(TExprBinaryVmNode.Create(TExprEqualVmOp, [ALeft, ARight]));
end;

function TExprVirtMachNodeFactory.CompareNotEqual(ALeft, ARight: TExprNode)
  : TExprNode;
begin
   Result := AddNode(TExprBinaryVmNode.Create
        (TExprNotEqualVmOp, [ALeft, ARight]));
end;

function TExprVirtMachNodeFactory.CompareLess(ALeft, ARight: TExprNode)
  : TExprNode;
begin
   Result := AddNode(TExprBinaryVmNode.Create(TExprLessVmOp, [ALeft, ARight]));
end;

function TExprVirtMachNodeFactory.CompareLessEqual(ALeft, ARight: TExprNode)
  : TExprNode;
begin
   Result := AddNode(TExprBinaryVmNode.Create
        (TExprLessEqualVmOp, [ALeft, ARight]));
end;

function TExprVirtMachNodeFactory.CompareGreater(ALeft, ARight: TExprNode)
  : TExprNode;
begin
   Result := AddNode(TExprBinaryVmNode.Create(TExprGreaterVmOp, [ALeft, ARight])
     );
end;

function TExprVirtMachNodeFactory.CompareGreaterEqual(ALeft, ARight: TExprNode)
  : TExprNode;
begin
   Result := AddNode(TExprBinaryVmNode.Create(TExprGreaterEqualVmOp,
         [ALeft, ARight]));
end;

function TExprVirtMachNodeFactory.LogicalAnd(ALeft, ARight: TExprNode)
  : TExprNode;
begin
   Result := AddNode(TExprBinaryVmNode.Create(TExprLogicalAndVmOp,
         [ALeft, ARight]));
end;

function TExprVirtMachNodeFactory.LogicalOr(ALeft, ARight: TExprNode)
  : TExprNode;
begin
   Result := AddNode(TExprBinaryVmNode.Create
        (TExprLogicalOrVmOp, [ALeft, ARight]));
end;

function TExprVirtMachNodeFactory.LogicalXor(ALeft, ARight: TExprNode)
  : TExprNode;
begin
   Result := AddNode(TExprBinaryVmNode.Create(TExprLogicalXorVmOp,
         [ALeft, ARight]));
end;

function TExprVirtMachNodeFactory.LogicalNot(AValue: TExprNode): TExprNode;
begin
   Result := AddNode(TExprUnaryVmNode.Create(TExprLogicalNotVmOp, [AValue]));
end;

function TExprVirtMachNodeFactory.BitwiseAnd(ALeft, ARight: TExprNode)
  : TExprNode;
begin
   Result := AddNode(TExprBinaryVmNode.Create(TExprBitwiseAndVmOp,
         [ALeft, ARight]));
end;

function TExprVirtMachNodeFactory.BitwiseOr(ALeft, ARight: TExprNode)
  : TExprNode;
begin
   Result := AddNode(TExprBinaryVmNode.Create
        (TExprBitwiseOrVmOp, [ALeft, ARight]));
end;

function TExprVirtMachNodeFactory.BitwiseXor(ALeft, ARight: TExprNode)
  : TExprNode;
begin
   Result := AddNode(TExprBinaryVmNode.Create(TExprBitwiseXorVmOp,
         [ALeft, ARight]));
end;

function TExprVirtMachNodeFactory.BitwiseNot(AValue: TExprNode): TExprNode;
begin
   Result := AddNode(TExprUnaryVmNode.Create(TExprBitwiseNotVmOp, [AValue]));
end;

function TExprVirtMachNodeFactory.ShiftLeft(ALeft, ARight: TExprNode)
  : TExprNode;
begin
   Result := AddNode(TExprBinaryVmNode.Create
        (TExprShiftLeftVmOp, [ALeft, ARight]));
end;

function TExprVirtMachNodeFactory.ShiftRight(ALeft, ARight: TExprNode)
  : TExprNode;
begin
   Result := AddNode(TExprBinaryVmNode.Create(TExprShiftRightVmOp,
         [ALeft, ARight]));
end;

// === { TCompiledEvaluator } =================================================









// === { TExprVar32Sym } ======================================================

constructor TExprVar32Sym.Create(const AIdent: string; ALoc: PFloat32);
begin
   Assert(ALoc <> nil);
   FLoc := ALoc;
   inherited Create(AIdent);
end;

function TExprVar32Sym.Compile: TExprNode;
begin
   Result := NodeFactory.LoadVar32(FLoc);
end;

function TExprVar32Sym.Evaluate: TFloat;
begin
   Result := FLoc^;
end;

// === { TExprVar64Sym } ======================================================

constructor TExprVar64Sym.Create(const AIdent: string; ALoc: PFloat64);
begin
   Assert(ALoc <> nil);
   FLoc := ALoc;
   inherited Create(AIdent);
end;

function TExprVar64Sym.Compile: TExprNode;
begin
   Result := NodeFactory.LoadVar64(FLoc);
end;

function TExprVar64Sym.Evaluate: TFloat;
begin
   Result := FLoc^;
end;
{$IFDEF SUPPORTS_EXTENDED}
// === { TExprVar80Sym } ======================================================

constructor TExprVar80Sym.Create(const AIdent: string; ALoc: PFloat80);
begin
   Assert(ALoc <> nil);
   FLoc := ALoc;
   inherited Create(AIdent);
end;

function TExprVar80Sym.Compile: TExprNode;
begin
   Result := NodeFactory.LoadVar80(FLoc);
end;

function TExprVar80Sym.Evaluate: TFloat;
begin
   Result := FLoc^;
end;
{$ENDIF SUPPORTS_EXTENDED}
// === { TExprCallFloatVmNode } ===============================================

constructor TExprCallFloatVmNode.Create(AFunc: TFloatFunc);
begin
   FFunc := AFunc;
   inherited Create([]);
end;

procedure TExprCallFloatVmNode.GenCode(AVirtMach: TExprVirtMach);
begin
   FExprVmCode := TExprCallFloatVmOp.Create(FFunc);
   AVirtMach.Add(FExprVmCode);
end;

// === { TExprCallFloat32VmNode } =============================================

constructor TExprCallFloat32VmNode.Create(AFunc: TFloat32Func);
begin
   FFunc := AFunc;
   inherited Create([]);
end;

procedure TExprCallFloat32VmNode.GenCode(AVirtMach: TExprVirtMach);
begin
   FExprVmCode := TExprCallFloat32VmOp.Create(FFunc);
   AVirtMach.Add(FExprVmCode);
end;

// === { TExprCallFloat64VmNode } =============================================

constructor TExprCallFloat64VmNode.Create(AFunc: TFloat64Func);
begin
   FFunc := AFunc;
   inherited Create([]);
end;

procedure TExprCallFloat64VmNode.GenCode(AVirtMach: TExprVirtMach);
begin
   FExprVmCode := TExprCallFloat64VmOp.Create(FFunc);
   AVirtMach.Add(FExprVmCode);
end;
{$IFDEF SUPPORTS_EXTENDED}
// === { TExprCallFloat80VmNode } =============================================

constructor TExprCallFloat80VmNode.Create(AFunc: TFloat80Func);
begin
   FFunc := AFunc;
   inherited Create([]);
end;

procedure TExprCallFloat80VmNode.GenCode(AVirtMach: TExprVirtMach);
begin
   FExprVmCode := TExprCallFloat80VmOp.Create(FFunc);
   AVirtMach.Add(FExprVmCode);
end;
{$ENDIF SUPPORTS_EXTENDED}
// === { TExprCallUnaryVmNode } ===============================================

constructor TExprCallUnaryVmNode.Create(AFunc: TUnaryFunc; X: TExprNode);
begin
   FFunc := AFunc;
   inherited Create([X]);
end;

procedure TExprCallUnaryVmNode.GenCode(AVirtMach: TExprVirtMach);
begin
   FExprVmCode := TExprCallUnaryVmOp.Create
     (FFunc, VmDeps[0].ExprVmCode.OutputLoc);
   AVirtMach.Add(FExprVmCode);
end;

// === { TExprCallUnary32VmNode } =============================================

constructor TExprCallUnary32VmNode.Create(AFunc: TUnary32Func; X: TExprNode);
begin
   FFunc := AFunc;
   inherited Create([X]);
end;

procedure TExprCallUnary32VmNode.GenCode(AVirtMach: TExprVirtMach);
begin
   FExprVmCode := TExprCallUnary32VmOp.Create
     (FFunc, VmDeps[0].ExprVmCode.OutputLoc);
   AVirtMach.Add(FExprVmCode);
end;

// === { TExprCallUnary64VmNode } =============================================

constructor TExprCallUnary64VmNode.Create(AFunc: TUnary64Func; X: TExprNode);
begin
   FFunc := AFunc;
   inherited Create([X]);
end;

procedure TExprCallUnary64VmNode.GenCode(AVirtMach: TExprVirtMach);
begin
   FExprVmCode := TExprCallUnary64VmOp.Create
     (FFunc, VmDeps[0].ExprVmCode.OutputLoc);
   AVirtMach.Add(FExprVmCode);
end;
{$IFDEF SUPPORTS_EXTENDED}
// === { TExprCallUnary80VmNode } =============================================

constructor TExprCallUnary80VmNode.Create(AFunc: TUnary80Func; X: TExprNode);
begin
   FFunc := AFunc;
   inherited Create([X]);
end;

procedure TExprCallUnary80VmNode.GenCode(AVirtMach: TExprVirtMach);
begin
   FExprVmCode := TExprCallUnary80VmOp.Create
     (FFunc, VmDeps[0].ExprVmCode.OutputLoc);
   AVirtMach.Add(FExprVmCode);
end;
{$ENDIF SUPPORTS_EXTENDED}
// === { TExprCallBinaryVmNode } ==============================================

constructor TExprCallBinaryVmNode.Create(AFunc: TBinaryFunc; X, Y: TExprNode);
begin
   FFunc := AFunc;
   inherited Create([X, Y]);
end;

procedure TExprCallBinaryVmNode.GenCode(AVirtMach: TExprVirtMach);
begin
   FExprVmCode := TExprCallBinaryVmOp.Create
     (FFunc, VmDeps[0].ExprVmCode.OutputLoc, VmDeps[1].ExprVmCode.OutputLoc);
   AVirtMach.Add(FExprVmCode);
end;

// === { TExprCallBinary32VmNode } ============================================

constructor TExprCallBinary32VmNode.Create
  (AFunc: TBinary32Func; X, Y: TExprNode);
begin
   FFunc := AFunc;
   inherited Create([X, Y]);
end;

procedure TExprCallBinary32VmNode.GenCode(AVirtMach: TExprVirtMach);
begin
   FExprVmCode := TExprCallBinary32VmOp.Create
     (FFunc, VmDeps[0].ExprVmCode.OutputLoc, VmDeps[1].ExprVmCode.OutputLoc);
   AVirtMach.Add(FExprVmCode);
end;

// === { TExprCallBinary64VmNode } ============================================

constructor TExprCallBinary64VmNode.Create
  (AFunc: TBinary64Func; X, Y: TExprNode);
begin
   FFunc := AFunc;
   inherited Create([X, Y]);
end;

procedure TExprCallBinary64VmNode.GenCode(AVirtMach: TExprVirtMach);
begin
   FExprVmCode := TExprCallBinary64VmOp.Create
     (FFunc, VmDeps[0].ExprVmCode.OutputLoc, VmDeps[1].ExprVmCode.OutputLoc);
   AVirtMach.Add(FExprVmCode);
end;
{$IFDEF SUPPORTS_EXTENDED}
// === { TExprCallBinary80VmNode } ============================================

constructor TExprCallBinary80VmNode.Create
  (AFunc: TBinary80Func; X, Y: TExprNode);
begin
   FFunc := AFunc;
   inherited Create([X, Y]);
end;

procedure TExprCallBinary80VmNode.GenCode(AVirtMach: TExprVirtMach);
begin
   FExprVmCode := TExprCallBinary80VmOp.Create
     (FFunc, VmDeps[0].ExprVmCode.OutputLoc, VmDeps[1].ExprVmCode.OutputLoc);
   AVirtMach.Add(FExprVmCode);
end;
{$ENDIF SUPPORTS_EXTENDED}
// === { TExprCallTernaryVmNode } =============================================

constructor TExprCallTernaryVmNode.Create(AFunc: TTernaryFunc;
   X, Y, Z: TExprNode);
begin
   FFunc := AFunc;
   inherited Create([X, Y, Z]);
end;

procedure TExprCallTernaryVmNode.GenCode(AVirtMach: TExprVirtMach);
begin
   FExprVmCode := TExprCallTernaryVmOp.Create
     (FFunc, VmDeps[0].ExprVmCode.OutputLoc, VmDeps[1].ExprVmCode.OutputLoc,
      VmDeps[2].ExprVmCode.OutputLoc);
   AVirtMach.Add(FExprVmCode);
end;

// === { TExprCallTernary32VmNode } ===========================================

constructor TExprCallTernary32VmNode.Create(AFunc: TTernary32Func;
   X, Y, Z: TExprNode);
begin
   FFunc := AFunc;
   inherited Create([X, Y, Z]);
end;

procedure TExprCallTernary32VmNode.GenCode(AVirtMach: TExprVirtMach);
begin
   FExprVmCode := TExprCallTernary32VmOp.Create
     (FFunc, VmDeps[0].ExprVmCode.OutputLoc, VmDeps[1].ExprVmCode.OutputLoc,
      VmDeps[2].ExprVmCode.OutputLoc);
   AVirtMach.Add(FExprVmCode);
end;

// === { TExprCallTernary64VmNode } ===========================================

constructor TExprCallTernary64VmNode.Create(AFunc: TTernary64Func;
   X, Y, Z: TExprNode);
begin
   FFunc := AFunc;
   inherited Create([X, Y, Z]);
end;

procedure TExprCallTernary64VmNode.GenCode(AVirtMach: TExprVirtMach);
begin
   FExprVmCode := TExprCallTernary64VmOp.Create
     (FFunc, VmDeps[0].ExprVmCode.OutputLoc, VmDeps[1].ExprVmCode.OutputLoc,
      VmDeps[2].ExprVmCode.OutputLoc);
   AVirtMach.Add(FExprVmCode);
end;
{$IFDEF SUPPORTS_EXTENDED}
// === { TExprCallTernary80VmNode } ===========================================

constructor TExprCallTernary80VmNode.Create(AFunc: TTernary80Func;
   X, Y, Z: TExprNode);
begin
   FFunc := AFunc;
   inherited Create([X, Y, Z]);
end;

procedure TExprCallTernary80VmNode.GenCode(AVirtMach: TExprVirtMach);
begin
   FExprVmCode := TExprCallTernary80VmOp.Create
     (FFunc, VmDeps[0].ExprVmCode.OutputLoc, VmDeps[1].ExprVmCode.OutputLoc,
      VmDeps[2].ExprVmCode.OutputLoc);
   AVirtMach.Add(FExprVmCode);
end;
{$ENDIF SUPPORTS_EXTENDED}
// === { TExprAbstractFuncSym } ===============================================

function TExprAbstractFuncSym.CompileFirstArg: TExprNode;
begin
   if Lexer.CurrTok <> etLParen then
      raise EJclExprEvalError.CreateRes(@RsExprEvalFirstArg);
   Result := CompileParser.CompileExprLevel0(True);
end;

function TExprAbstractFuncSym.CompileNextArg: TExprNode;
begin
   if Lexer.CurrTok <> etComma then
      raise EJclExprEvalError.CreateRes(@RsExprEvalNextArg);
   Result := CompileParser.CompileExprLevel0(True);
end;

function TExprAbstractFuncSym.EvalFirstArg: TFloat;
begin
   if Lexer.CurrTok <> etLParen then
      raise EJclExprEvalError.CreateRes(@RsExprEvalFirstArg);
   Result := EvalParser.EvalExprLevel0(True);
end;

function TExprAbstractFuncSym.EvalNextArg: TFloat;
begin
   if Lexer.CurrTok <> etComma then
      raise EJclExprEvalError.CreateRes(@RsExprEvalNextArg);
   Result := EvalParser.EvalExprLevel0(True);
end;

procedure TExprAbstractFuncSym.EndArgs;
begin
   if Lexer.CurrTok <> etRParen then
      raise EJclExprEvalError.CreateRes(@RsExprEvalEndArgs);
   Lexer.NextTok;
end;

// === { TExprFuncSym } =======================================================

constructor TExprFuncSym.Create(const AIdent: string; AFunc: TFloatFunc);
begin
   Assert(Assigned(AFunc));
   inherited Create(AIdent);
   FFunc := AFunc;
end;

function TExprFuncSym.Compile: TExprNode;
begin
   Result := NodeFactory.CallFloatFunc(FFunc);
end;

function TExprFuncSym.Evaluate: TFloat;
begin
   Result := FFunc;
end;

// === { TExprFloat32FuncSym } ================================================

constructor TExprFloat32FuncSym.Create(const AIdent: string;
   AFunc: TFloat32Func);
begin
   Assert(Assigned(AFunc));
   inherited Create(AIdent);
   FFunc := AFunc;
end;

function TExprFloat32FuncSym.Compile: TExprNode;
begin
   Result := NodeFactory.CallFloat32Func(FFunc);
end;

function TExprFloat32FuncSym.Evaluate: TFloat;
begin
   Result := FFunc;
end;

// === { TExprFloat64FuncSym } ================================================

constructor TExprFloat64FuncSym.Create(const AIdent: string;
   AFunc: TFloat64Func);
begin
   Assert(Assigned(AFunc));
   inherited Create(AIdent);
   FFunc := AFunc;
end;

function TExprFloat64FuncSym.Compile: TExprNode;
begin
   Result := NodeFactory.CallFloat64Func(FFunc);
end;

function TExprFloat64FuncSym.Evaluate: TFloat;
begin
   Result := FFunc;
end;
{$IFDEF SUPPORTS_EXTENDED}
// === { TExprFloat80FuncSym } ================================================

constructor TExprFloat80FuncSym.Create(const AIdent: string;
   AFunc: TFloat80Func);
begin
   Assert(Assigned(AFunc));
   inherited Create(AIdent);
   FFunc := AFunc;
end;

function TExprFloat80FuncSym.Compile: TExprNode;
begin
   Result := NodeFactory.CallFloat80Func(FFunc);
end;

function TExprFloat80FuncSym.Evaluate: TFloat;
begin
   Result := FFunc;
end;
{$ENDIF SUPPORTS_EXTENDED}
// === { TExprUnaryFuncSym } ==================================================

constructor TExprUnaryFuncSym.Create(const AIdent: string; AFunc: TUnaryFunc);
begin
   Assert(Assigned(AFunc));
   inherited Create(AIdent);
   FFunc := AFunc;
end;

function TExprUnaryFuncSym.Compile: TExprNode;
var
   X: TExprNode;
begin
   X := CompileFirstArg;
   EndArgs;
   Result := NodeFactory.CallUnaryFunc(FFunc, X);
end;

function TExprUnaryFuncSym.Evaluate: TFloat;
var
   X: TFloat;
begin
   X := EvalFirstArg;
   EndArgs;
   Result := FFunc(X);
end;

// === { TExprUnary32FuncSym } ================================================

constructor TExprUnary32FuncSym.Create(const AIdent: string;
   AFunc: TUnary32Func);
begin
   Assert(Assigned(AFunc));
   inherited Create(AIdent);
   FFunc := AFunc;
end;

function TExprUnary32FuncSym.Compile: TExprNode;
var
   X: TExprNode;
begin
   X := CompileFirstArg;
   EndArgs;
   Result := NodeFactory.CallUnary32Func(FFunc, X);
end;

function TExprUnary32FuncSym.Evaluate: TFloat;
var
   X: TFloat;
begin
   X := EvalFirstArg;
   EndArgs;
   Result := FFunc(X);
end;

// === { TExprUnary64FuncSym } ================================================

constructor TExprUnary64FuncSym.Create(const AIdent: string;
   AFunc: TUnary64Func);
begin
   Assert(Assigned(AFunc));
   inherited Create(AIdent);
   FFunc := AFunc;
end;

function TExprUnary64FuncSym.Compile: TExprNode;
var
   X: TExprNode;
begin
   X := CompileFirstArg;
   EndArgs;
   Result := NodeFactory.CallUnary64Func(FFunc, X);
end;

function TExprUnary64FuncSym.Evaluate: TFloat;
var
   X: TFloat;
begin
   X := EvalFirstArg;
   EndArgs;
   Result := FFunc(X);
end;
{$IFDEF SUPPORTS_EXTENDED}
// === { TExprUnary80FuncSym } ================================================

constructor TExprUnary80FuncSym.Create(const AIdent: string;
   AFunc: TUnary80Func);
begin
   Assert(Assigned(AFunc));
   inherited Create(AIdent);
   FFunc := AFunc;
end;

function TExprUnary80FuncSym.Compile: TExprNode;
var
   X: TExprNode;
begin
   X := CompileFirstArg;
   EndArgs;
   Result := NodeFactory.CallUnary80Func(FFunc, X);
end;

function TExprUnary80FuncSym.Evaluate: TFloat;
var
   X: TFloat;
begin
   X := EvalFirstArg;
   EndArgs;
   Result := FFunc(X);
end;
{$ENDIF SUPPORTS_EXTENDED}
// === { TExprBinaryFuncSym } =================================================

constructor TExprBinaryFuncSym.Create(const AIdent: string; AFunc: TBinaryFunc);
begin
   Assert(Assigned(AFunc));
   inherited Create(AIdent);
   FFunc := AFunc;
end;

function TExprBinaryFuncSym.Compile: TExprNode;
var
   X, Y: TExprNode;
begin
   // must be called this way, because evaluation order of function
   // parameters is not defined; we need CompileFirstArg to be called
   // first.
   X := CompileFirstArg;
   Y := CompileNextArg;
   EndArgs;
   Result := NodeFactory.CallBinaryFunc(FFunc, X, Y);
end;

function TExprBinaryFuncSym.Evaluate: TFloat;
var
   X, Y: TFloat;
begin
   X := EvalFirstArg;
   Y := EvalNextArg;
   EndArgs;
   Result := FFunc(X, Y);
end;

// === { TExprBinary32FuncSym } ===============================================

constructor TExprBinary32FuncSym.Create(const AIdent: string;
   AFunc: TBinary32Func);
begin
   Assert(Assigned(AFunc));
   inherited Create(AIdent);
   FFunc := AFunc;
end;

function TExprBinary32FuncSym.Compile: TExprNode;
var
   X, Y: TExprNode;
begin
   X := CompileFirstArg;
   Y := CompileNextArg;
   EndArgs;
   Result := NodeFactory.CallBinary32Func(FFunc, X, Y);
end;

function TExprBinary32FuncSym.Evaluate: TFloat;
var
   X, Y: TFloat;
begin
   X := EvalFirstArg;
   Y := EvalNextArg;
   EndArgs;
   Result := FFunc(X, Y);
end;

// === { TExprBinary64FuncSym } ===============================================

constructor TExprBinary64FuncSym.Create(const AIdent: string;
   AFunc: TBinary64Func);
begin
   Assert(Assigned(AFunc));
   inherited Create(AIdent);
   FFunc := AFunc;
end;

function TExprBinary64FuncSym.Compile: TExprNode;
var
   X, Y: TExprNode;
begin
   X := CompileFirstArg;
   Y := CompileNextArg;
   EndArgs;
   Result := NodeFactory.CallBinary64Func(FFunc, X, Y);
end;

function TExprBinary64FuncSym.Evaluate: TFloat;
var
   X, Y: TFloat;
begin
   X := EvalFirstArg;
   Y := EvalNextArg;
   EndArgs;
   Result := FFunc(X, Y);
end;
{$IFDEF SUPPORTS_EXTENDED}
// === { TExprBinary80FuncSym } ===============================================

constructor TExprBinary80FuncSym.Create(const AIdent: string;
   AFunc: TBinary80Func);
begin
   Assert(Assigned(AFunc));
   inherited Create(AIdent);
   FFunc := AFunc;
end;

function TExprBinary80FuncSym.Compile: TExprNode;
var
   X, Y: TExprNode;
begin
   X := CompileFirstArg;
   Y := CompileNextArg;
   EndArgs;
   Result := NodeFactory.CallBinary80Func(FFunc, X, Y);
end;

function TExprBinary80FuncSym.Evaluate: TFloat;
var
   X, Y: TFloat;
begin
   X := EvalFirstArg;
   Y := EvalNextArg;
   EndArgs;
   Result := FFunc(X, Y);
end;
{$ENDIF SUPPORTS_EXTENDED}
// === { TExprTernaryFuncSym } ================================================

constructor TExprTernaryFuncSym.Create(const AIdent: string;
   AFunc: TTernaryFunc);
begin
   Assert(Assigned(AFunc));
   inherited Create(AIdent);
   FFunc := AFunc;
end;

function TExprTernaryFuncSym.Compile: TExprNode;
var
   X, Y, Z: TExprNode;
begin
   X := CompileFirstArg;
   Y := CompileNextArg;
   Z := CompileNextArg;
   EndArgs;
   Result := NodeFactory.CallTernaryFunc(FFunc, X, Y, Z);
end;

function TExprTernaryFuncSym.Evaluate: TFloat;
var
   X, Y, Z: TFloat;
begin
   X := EvalFirstArg;
   Y := EvalNextArg;
   Z := EvalNextArg;
   EndArgs;
   Result := FFunc(X, Y, Z);
end;

// === { TExprTernary32FuncSym } ==============================================

constructor TExprTernary32FuncSym.Create(const AIdent: string;
   AFunc: TTernary32Func);
begin
   Assert(Assigned(AFunc));
   inherited Create(AIdent);
   FFunc := AFunc;
end;

function TExprTernary32FuncSym.Compile: TExprNode;
var
   X, Y, Z: TExprNode;
begin
   X := CompileFirstArg;
   Y := CompileNextArg;
   Z := CompileNextArg;
   EndArgs;
   Result := NodeFactory.CallTernary32Func(FFunc, X, Y, Z);
end;

function TExprTernary32FuncSym.Evaluate: TFloat;
var
   X, Y, Z: TFloat;
begin
   X := EvalFirstArg;
   Y := EvalNextArg;
   Z := EvalNextArg;
   EndArgs;
   Result := FFunc(X, Y, Z);
end;

// === { TExprTernary64FuncSym } ==============================================

constructor TExprTernary64FuncSym.Create(const AIdent: string;
   AFunc: TTernary64Func);
begin
   Assert(Assigned(AFunc));
   inherited Create(AIdent);
   FFunc := AFunc;
end;

function TExprTernary64FuncSym.Compile: TExprNode;
var
   X, Y, Z: TExprNode;
begin
   X := CompileFirstArg;
   Y := CompileNextArg;
   Z := CompileNextArg;
   EndArgs;
   Result := NodeFactory.CallTernary64Func(FFunc, X, Y, Z);
end;

function TExprTernary64FuncSym.Evaluate: TFloat;
var
   X, Y, Z: TFloat;
begin
   X := EvalFirstArg;
   Y := EvalNextArg;
   Z := EvalNextArg;
   EndArgs;
   Result := FFunc(X, Y, Z);
end;
{$IFDEF SUPPORTS_EXTENDED}
// === { TExprTernary80FuncSym } ==============================================

constructor TExprTernary80FuncSym.Create(const AIdent: string;
   AFunc: TTernary80Func);
begin
   Assert(Assigned(AFunc));
   inherited Create(AIdent);
   FFunc := AFunc;
end;

function TExprTernary80FuncSym.Compile: TExprNode;
var
   X, Y, Z: TExprNode;
begin
   X := CompileFirstArg;
   Y := CompileNextArg;
   Z := CompileNextArg;
   EndArgs;
   Result := NodeFactory.CallTernary80Func(FFunc, X, Y, Z);
end;

function TExprTernary80FuncSym.Evaluate: TFloat;
var
   X, Y, Z: TFloat;
begin
   X := EvalFirstArg;
   Y := EvalNextArg;
   Z := EvalNextArg;
   EndArgs;
   Result := FFunc(X, Y, Z);
end;
{$ENDIF SUPPORTS_EXTENDED}
// === { TExprConstSym } ======================================================

constructor TExprConstSym.Create(const AIdent: string; AValue: TFloat);
begin
   inherited Create(AIdent);
   FValue := AValue;
end;

function TExprConstSym.Compile: TExprNode;
begin
   Result := NodeFactory.LoadConst(FValue);
end;

function TExprConstSym.Evaluate: TFloat;
begin
   Result := FValue;
end;

// === { TExprConst32Sym } ====================================================







// === { TExprConst64Sym } ====================================================
{$IFDEF SUPPORTS_EXTENDED}
// === { TExprConst80Sym } ====================================================

constructor TExprConst80Sym.Create(const AIdent: string; AValue: TFloat80);
begin
   inherited Create(AIdent);
   FValue := AValue;
end;

function TExprConst80Sym.Compile: TExprNode;
begin
   Result := NodeFactory.LoadConst(FValue);
end;

function TExprConst80Sym.Evaluate: TFloat;
begin
   Result := FValue;
end;
{$ENDIF SUPPORTS_EXTENDED}
// === { TEasyEvaluator } =====================================================
{$IFDEF SUPPORTS_EXTENDED}
{$ENDIF SUPPORTS_EXTENDED}
{$IFDEF SUPPORTS_EXTENDED}
{$ENDIF SUPPORTS_EXTENDED}
{$IFDEF SUPPORTS_EXTENDED}
{$ENDIF SUPPORTS_EXTENDED}
{$IFDEF SUPPORTS_EXTENDED}
{$ENDIF SUPPORTS_EXTENDED}
{$IFDEF SUPPORTS_EXTENDED}
{$ENDIF SUPPORTS_EXTENDED}
{$IFDEF SUPPORTS_EXTENDED}
{$ENDIF SUPPORTS_EXTENDED}
// === { TInternalCompiledExpression } ========================================

type
   TInternalCompiledExpression = class(TObject)
   private
      FVirtMach: TExprVirtMach;
      FRefCount: Integer;
   public
      constructor Create(AVirtMach: TExprVirtMach);
      destructor Destroy; override;
      property VirtMach: TExprVirtMach read FVirtMach;
      property RefCount: Integer read FRefCount write FRefCount;
   end;

constructor TInternalCompiledExpression.Create(AVirtMach: TExprVirtMach);
begin
   inherited Create;
   FVirtMach := AVirtMach;
end;

destructor TInternalCompiledExpression.Destroy;
begin
   FVirtMach.Free;
   inherited Destroy;
end;

// === { TExpressionCompiler } ================================================

constructor TExpressionCompiler.Create;
begin
   FExprHash := TStringHashMap.Create(CaseInsensitiveTraits, cExprEvalHashSize);
   inherited Create;
end;

destructor TExpressionCompiler.Destroy;
begin
   FExprHash.Iterate(nil, Iterate_FreeObjects);
   FExprHash.Free;
   inherited Destroy;
end;

function TExpressionCompiler.Compile(const AExpr: string): TCompiledExpression;
var
   Ice: TInternalCompiledExpression;
   Vm: TExprVirtMach;
   Parser: TExprCompileParser;
   Lexer: TExprSimpleLexer;
   NodeFactory: TExprVirtMachNodeFactory;
begin
   Ice := nil;
   if FExprHash.Find(AExpr, Ice) then
   begin
      // expression already exists, add reference
      Result := Ice.VirtMach.Execute;
      Ice.RefCount := Ice.RefCount + 1;
   end
   else
   begin
      // compile fresh expression
      Parser := nil;
      NodeFactory := nil;
      Lexer := TExprSimpleLexer.Create(AExpr);
      try
         NodeFactory := TExprVirtMachNodeFactory.Create;
         Parser := TExprCompileParser.Create(Lexer, NodeFactory);
         Parser.Context := InternalContextSet;
         Parser.Compile;

         Ice := nil;
         Vm := TExprVirtMach.Create;
         try
            NodeFactory.GenCode(Vm);
            Ice := TInternalCompiledExpression.Create(Vm);
            Ice.RefCount := 1;
            FExprHash.Add(AExpr, Ice);
         except
            Ice.Free;
            Vm.Free;
            raise ;
         end;
      finally
         NodeFactory.Free;
         Parser.Free;
         Lexer.Free;
      end;

      Result := Ice.VirtMach.Execute;
   end;
end;

type
   PIceFindResult = ^TIceFindResult;

   TIceFindResult = record
      Found: Boolean;
      Ce: TCompiledExpression;
      Ice: TInternalCompiledExpression;
      Expr: string;
   end;

function IterateFindIce(AUserData: Pointer; const AStr: string;
   var APtr: Pointer): Boolean;
var
   PIfr: PIceFindResult;
   Ice: TInternalCompiledExpression;
   Ce: TCompiledExpression;
begin
   PIfr := AUserData;
   Ice := APtr;
   Ce := Ice.VirtMach.Execute;

   if (TMethod(PIfr^.Ce).Code = TMethod(Ce).Code) and
     (TMethod(PIfr^.Ce).Data = TMethod(Ce).Data) then
   begin
      PIfr^.Found := True;
      PIfr^.Ice := Ice;
      PIfr^.Expr := AStr;
      Result := False;
   end
   else
      Result := True;
end;

procedure TExpressionCompiler.Delete(ACompiledExpression: TCompiledExpression);
var
   Ifr: TIceFindResult;
begin
   with Ifr do
   begin
      Found := False;
      Ce := ACompiledExpression;
      Ice := nil;
      Expr := '';
      FExprHash.Iterate(@Ifr, IterateFindIce);
      if not Found then
         raise EJclExprEvalError.CreateRes(@RsExprEvalExprPtrNotFound);
      Remove(Expr);
   end;
end;

procedure TExpressionCompiler.Remove(const AExpr: string);
var
   Ice: TInternalCompiledExpression;
begin
   Ice := nil;
   if not FExprHash.Find(AExpr, Ice) then
      raise EJclExprEvalError.CreateResFmt(@RsExprEvalExprNotFound, [AExpr]);

   Ice.RefCount := Ice.RefCount - 1;
   Assert(Ice.RefCount >= 0, LoadResString(@RsExprEvalExprRefCountAssertion));
   if Ice.RefCount = 0 then
   begin
      Ice.Free;
      FExprHash.Remove(AExpr);
   end;
end;

procedure TExpressionCompiler.Clear;
begin
   FExprHash.Iterate(nil, Iterate_FreeObjects);
   FExprHash.Clear;
   inherited Clear;
end;
{$IFDEF UNITVERSIONING}

initialization

RegisterUnitVersion(HInstance, UnitVersioning);

finalization

UnregisterUnitVersion(HInstance);
{$ENDIF UNITVERSIONING}

end.
