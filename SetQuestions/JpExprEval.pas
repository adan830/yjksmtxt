unit JpExprEval;

interface

uses  Classes, JclStrHashMap, SysUtils,jclsysutils;

const
   cExprEvalHashSize = 127;

resourcestring
   RsExprEvalUnknownSymbol  = 'Parse error: Unknown symbol: ''%s''';
   RsExprEvalRParenExpected = 'Parse error: '')'' expected';
   RsExprEvalFactorExpected = 'Parse error: Factor expected';
type
   TFloat = Extended;
   TFloat32 = Single;
   TFloat64 = Double;

   EJclExprEvalError = class(Exception);

      { Forward Declarations }
      TExprLexer = class;
      TExprEvalParser = class;
      TExprSym = class;
      TExprSimpleLexer = class;

   TExprContext = class(TObject)
      public function Find(const AName: string)        : TExprSym;        virtual;         abstract;
   end;

   TExprHashContext = class(TExprContext)
   private
      FHashMap: TStringHashMap;
   public
      constructor Create(ACaseSensitive: boolean = False;
         AHashSize: Integer = 127);
      destructor Destroy; override;
      procedure Add(ASymbol: TExprSym);
      procedure Remove(const AName: string);
      function Find(const AName: string): TExprSym; override;
   end;

   TExprSetContext = class(TExprContext)
   private
      FList: TList;
      FOwnsContexts: boolean;
      function GetContexts(AIndex: Integer): TExprContext;
      function GetCount: Integer;
   public
      constructor Create(AOwnsContexts: boolean);
      destructor Destroy; override;
      procedure Add(AContext: TExprContext);
      procedure Remove(AContext: TExprContext);
      procedure Delete(AIndex: Integer);
      function Extract(AContext: TExprContext): TExprContext;
      property Count: Integer read GetCount;
      property Contexts[AIndex: Integer]: TExprContext read GetContexts;
      property InternalList: TList read FList;
      function Find(const AName: string): TExprSym; override;
   end;

   TExprToken = (
{$REGION '------'}
      // specials
      etEof, etNumber, etIdentifier,

      // user extension tokens
      etUser0, etUser1, etUser2, etUser3, etUser4, etUser5, etUser6, etUser7,
      etUser8, etUser9, etUser10, etUser11, etUser12, etUser13, etUser14,
      etUser15, etUser16, etUser17, etUser18, etUser19, etUser20, etUser21,
      etUser22, etUser23, etUser24, etUser25, etUser26, etUser27, etUser28,
      etUser29, etUser30, etUser31,

      // compound tokens
      etNotEqual, // <>
      etLessEqual, // <=
      etGreaterEqual, // >=

      // ASCII normal & ordinals

      etBang, // '!' #$21 33
      etDoubleQuote, // '"' #$22 34
      etHash, // '#' #$23 35
      etDollar, // '$' #$24 36
      etPercent, // '%' #$25 37
      etAmpersand, // '&' #$26 38
      etSingleQuote, // '''' #$27 39
      etLParen, // '(' #$28 40
      etRParen, // ')' #$29 41
      etAsterisk, // '*' #$2A 42
      etPlus, // '+' #$2B 43
      etComma, // ',' #$2C 44
      etMinus, // '-' #$2D 45
      etDot, // '.' #$2E 46
      etForwardSlash, // '/' #$2F 47

      // 48..57 - numbers...

      etColon, // ':' #$3A 58
      etSemiColon, // ';' #$3B 59
      etLessThan, // '<' #$3C 60
      etEqualTo, // '=' #$3D 61
      etGreaterThan, // '>' #$3E 62
      etQuestion, // '?' #$3F 63
      etAt, // '@' #$40 64

      // 65..90 - capital letters...

      etLBracket, // '[' #$5B 91
      etBackSlash, // '\' #$5C 92
      etRBracket, // ']' #$5D 93
      etArrow, // '^' #$5E 94
      // 95 - underscore
      etBackTick, // '`' #$60 96

      // 97..122 - small letters...

      etLBrace, // '{' #$7B 123
      etPipe, // '|' #$7C 124
      etRBrace, // '}' #$7D 125
      etTilde, // '~' #$7E 126
      et127, // '' #$7F 127
      etEuro, // '€' #$80 128
      et129, // '' #$81 129
      et130, // '? #$82 130
      et131, // '? #$83 131
      et132, // '? #$84 132
      et133, // '? #$85 133
      et134, // '? #$86 134
      et135, // '? #$87 135
      et136, // '? #$88 136
      et137, // '? #$89 137
      et138, // '? #$8A 138
      et139, // '? #$8B 139
      et140, // '? #$8C 140
      et141, // '' #$8D 141
      et142, // '? #$8E 142
      et143, // '' #$8F 143
      et144, // '' #$90 144
      et145, // '? #$91 145
      et146, // '? #$92 146
      et147, // '? #$93 147
      et148, // '? #$94 148
      et149, // '? #$95 149
      et150, // '? #$96 150
      et151, // '? #$97 151
      et152, // '? #$98 152
      et153, // '? #$99 153
      et154, // '? #$9A 154
      et155, // '? #$9B 155
      et156, // '? #$9C 156
      et157, // '' #$9D 157
      et158, // '? #$9E 158
      et159, // '? #$9F 159
      et160, // '? #$A0 160
      et161, // '? #$A1 161
      et162, // '? #$A2 162
      et163, // '? #$A3 163
      et164, // '? #$A4 164
      et165, // '? #$A5 165
      et166, // '? #$A6 166
      et167, // '? #$A7 167
      et168, // '? #$A8 168
      et169, // '? #$A9 169
      et170, // '? #$AA 170
      et171, // '? #$AB 171
      et172, // '? #$AC 172
      et173, // '? #$AD 173
      et174, // '? #$AE 174
      et175, // '? #$AF 175
      et176, // '? #$B0 176
      et177, // '? #$B1 177
      et178, // '? #$B2 178
      et179, // '? #$B3 179
      et180, // '? #$B4 180
      et181, // '? #$B5 181
      et182, // '? #$B6 182
      et183, // '? #$B7 183
      et184, // '? #$B8 184
      et185, // '? #$B9 185
      et186, // '? #$BA 186
      et187, // '? #$BB 187
      et188, // '? #$BC 188
      et189, // '? #$BD 189
      et190, // '? #$BE 190
      et191, // '? #$BF 191
      et192, // '? #$C0 192
      et193, // '? #$C1 193
      et194, // '? #$C2 194
      et195, // '? #$C3 195
      et196, // '? #$C4 196
      et197, // '? #$C5 197
      et198, // '? #$C6 198
      et199, // '? #$C7 199
      et200, // '? #$C8 200
      et201, // '? #$C9 201
      et202, // '? #$CA 202
      et203, // '? #$CB 203
      et204, // '? #$CC 204
      et205, // '? #$CD 205
      et206, // '? #$CE 206
      et207, // '? #$CF 207
      et208, // '? #$D0 208
      et209, // '? #$D1 209
      et210, // '? #$D2 210
      et211, // '? #$D3 211
      et212, // '? #$D4 212
      et213, // '? #$D5 213
      et214, // '? #$D6 214
      et215, // '? #$D7 215
      et216, // '? #$D8 216
      et217, // '? #$D9 217
      et218, // '? #$DA 218
      et219, // '? #$DB 219
      et220, // '? #$DC 220
      et221, // '? #$DD 221
      et222, // '? #$DE 222
      et223, // '? #$DF 223
      et224, // '? #$E0 224
      et225, // '? #$E1 225
      et226, // '? #$E2 226
      et227, // '? #$E3 227
      et228, // '? #$E4 228
      et229, // '? #$E5 229
      et230, // '? #$E6 230
      et231, // '? #$E7 231
      et232, // '? #$E8 232
      et233, // '? #$E9 233
      et234, // '? #$EA 234
      et235, // '? #$EB 235
      et236, // '? #$EC 236
      et237, // '? #$ED 237
      et238, // '? #$EE 238
      et239, // '? #$EF 239
      et240, // '? #$F0 240
      et241, // '? #$F1 241
      et242, // '? #$F2 242
      et243, // '? #$F3 243
      et244, // '? #$F4 244
      et245, // '? #$F5 245
      et246, // '? #$F6 246
      et247, // '? #$F7 247
      et248, // '? #$F8 248
      et249, // '? #$F9 249
      et250, // '? #$FA 250
      et251, // '? #$FB 251
      et252, // '? #$FC 252
      et253, // '? #$FD 253
      et254, // '? #$FE 254
      et255, // 'ÿ' #$FF 255
      etInvalid // invalid token type
{$ENDREGION}
   );

   TExprSym = class(TObject)
   private
      FIdent: string;
      FLexer: TExprLexer;
      FEvalParser: TExprEvalParser;
      // FCompileParser: TExprCompileParser;
      // FNodeFactory: TExprNodeFactory;
   public
      constructor Create(const AIdent: string);
      function Evaluate: TFloat; virtual; abstract;
      // function Compile: TExprNode; virtual; abstract;
      property Ident: string read FIdent;
      property Lexer: TExprLexer read FLexer write FLexer;
      // property CompileParser        : TExprCompileParser read FCompileParser write FCompileParser;
      property EvalParser: TExprEvalParser read FEvalParser write FEvalParser;
      // property NodeFactory         : TExprNodeFactory read FNodeFactory write FNodeFactory;
   end;

   TEasyEvaluator = class(TObject)
   private
      FOwnContext: TExprHashContext;
      FExtContextSet: TExprSetContext;
      FInternalContextSet: TExprSetContext;
   protected
      property InternalContextSet: TExprSetContext read FInternalContextSet;
   public
      constructor Create;
      destructor Destroy; override;

      procedure AddConst(const AName: string; AConst: TFloat32); overload;
      procedure AddConst(const AName: string; AConst: TFloat64); overload;

      procedure Remove(const AName: string);

      procedure Clear; virtual;
      property ExtContextSet: TExprSetContext read FExtContextSet;
   end;

   TEvaluator = class(TEasyEvaluator)
   private
      FLexer: TExprSimpleLexer;
      FParser: TExprEvalParser;
   public
      constructor Create;
      destructor Destroy; override;
      function Evaluate(const AExpr: string): TFloat;
   end;

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

   TExprSimpleLexer = class(TExprLexer)
   protected
      FCurrPos: PChar;
      FBuf: string;
      procedure SetBuf(const ABuf: string);
   public
      constructor Create(const ABuf: string);

      procedure NextTok; override;
      procedure Reset; override;

      property Buf: string read FBuf write SetBuf;
   end;

   TExprEvalParser = class(TObject)
   private
      FContext: TExprContext;
      FLexer: TExprLexer;
   protected
      function EvalExprLevel0(ASkip: boolean): TFloat; virtual;
      function EvalExprLevel1(ASkip: boolean): TFloat; virtual;
      function EvalExprLevel2(ASkip: boolean): TFloat; virtual;
      function EvalExprLevel3(ASkip: boolean): TFloat; virtual;
      function EvalFactor: TFloat; virtual;
      function EvalIdentFactor: TFloat; virtual;
   public
      constructor Create(ALexer: TExprLexer);
      function Evaluate: TFloat; virtual;

      property Lexer: TExprLexer read FLexer;
      property Context: TExprContext read FContext write FContext;
   end;

   TExprConst32Sym = class(TExprSym)
   private
      FValue: TFloat32;
   public
      constructor Create(const AIdent: string; AValue: TFloat32);
      function Evaluate: TFloat; override;
      // function Compile: TExprNode; override;
   end;

   TExprConst64Sym = class(TExprSym)
   private
      FValue: TFloat64;
   public
      constructor Create(const AIdent: string; AValue: TFloat64);
      function Evaluate: TFloat; override;
   end;

implementation

uses
  JclStrings;

constructor TEasyEvaluator.Create;
begin
   inherited Create;
   FOwnContext := TExprHashContext.Create(False, cExprEvalHashSize);
   FExtContextSet := TExprSetContext.Create(False);
   FInternalContextSet := TExprSetContext.Create(False);

   // user added names get precedence over external context's names
   FInternalContextSet.Add(FExtContextSet);
   FInternalContextSet.Add(FOwnContext);
end;

destructor TEasyEvaluator.Destroy;
begin
   FInternalContextSet.Free;
   FOwnContext.Free;
   FExtContextSet.Free;
   inherited Destroy;
end;

procedure TEasyEvaluator.AddConst(const AName: string; AConst: TFloat64);
begin
   FOwnContext.Add(TExprConst64Sym.Create(AName, AConst));
end;

procedure TEasyEvaluator.AddConst(const AName: string; AConst: TFloat32);
begin
   FOwnContext.Add(TExprConst32Sym.Create(AName, AConst));
end;

procedure TEasyEvaluator.Clear;
begin
   FOwnContext.FHashMap.Iterate(nil, Iterate_FreeObjects);
   FOwnContext.FHashMap.Clear;
end;

procedure TEasyEvaluator.Remove(const AName: string);
begin
   FOwnContext.Remove(AName);
end;

constructor TEvaluator.Create;
begin
   inherited Create;

   FLexer := TExprSimpleLexer.Create('');
   FParser := TExprEvalParser.Create(FLexer);

   FParser.Context := InternalContextSet;
end;

destructor TEvaluator.Destroy;
begin
   FParser.Free;
   FLexer.Free;
   inherited Destroy;
end;

function TEvaluator.Evaluate(const AExpr: string): TFloat;
begin
   FLexer.Buf := AExpr;
   Result := FParser.Evaluate;
end;

constructor TExprSym.Create(const AIdent: string);
begin
   inherited Create;
   FIdent := AIdent;
end;

constructor TExprHashContext.Create(ACaseSensitive: boolean;
   AHashSize: Integer);
begin
   inherited Create;
   if ACaseSensitive then
      FHashMap := TStringHashMap.Create(CaseSensitiveTraits, AHashSize)
   else
      FHashMap := TStringHashMap.Create(CaseInsensitiveTraits, AHashSize);
end;

destructor TExprHashContext.Destroy;
begin
   FHashMap.Iterate(nil, Iterate_FreeObjects);
   FHashMap.Free;
   inherited Destroy;
end;

procedure TExprHashContext.Add(ASymbol: TExprSym);
begin
   FHashMap.Add(ASymbol.Ident, ASymbol);
end;

procedure TExprHashContext.Remove(const AName: string);
begin
   TObject(FHashMap.Remove(AName)).Free;
end;

function TExprHashContext.Find(const AName: string): TExprSym;
begin
   Result := nil;
   if not FHashMap.Find(AName, Result) then
      Result := nil;
end;

constructor TExprSetContext.Create(AOwnsContexts: boolean);
begin
   inherited Create;
   FOwnsContexts := AOwnsContexts;
   FList := TList.Create;
end;

destructor TExprSetContext.Destroy;
begin
   if FOwnsContexts then
      ClearObjectList(FList);
   FList.Free;
   inherited Destroy;
end;

procedure TExprSetContext.Add(AContext: TExprContext);
begin
   FList.Add(AContext);
end;

procedure TExprSetContext.Delete(AIndex: Integer);
begin
   if FOwnsContexts then
      TObject(FList[AIndex]).Free;
   FList.Delete(AIndex);
end;

function TExprSetContext.Extract(AContext: TExprContext): TExprContext;
begin
   Result := AContext;
   FList.Remove(AContext);
end;

function TExprSetContext.Find(const AName: string): TExprSym;
var
   I: Integer;
begin
   Result := nil;
   for I := Count - 1 downto 0 do
   begin
      Result := Contexts[I].Find(AName);
      if Result <> nil then
         Break;
   end;
end;

function TExprSetContext.GetContexts(AIndex: Integer): TExprContext;
begin
   Result := TExprContext(FList[AIndex]);
end;

function TExprSetContext.GetCount: Integer;
begin
   Result := FList.Count;
end;

procedure TExprSetContext.Remove(AContext: TExprContext);
begin
   FList.Remove(AContext);
   if FOwnsContexts then
      AContext.Free;
end;

constructor TExprLexer.Create;
begin
   inherited Create;
   Reset;
end;

procedure TExprLexer.Reset;
begin
   NextTok;
end;

constructor TExprSimpleLexer.Create(const ABuf: string);
begin
   FBuf := ABuf;
   inherited Create;
end;

procedure TExprSimpleLexer.NextTok;
const
   CharToTokenMap: array [AnsiChar] of TExprToken = (
      { #0..#31 }
      etInvalid, etInvalid, etInvalid, etInvalid, etInvalid, etInvalid,
      etInvalid, etInvalid, etInvalid, etInvalid, etInvalid, etInvalid,
      etInvalid, etInvalid, etInvalid, etInvalid, etInvalid, etInvalid,
      etInvalid, etInvalid, etInvalid, etInvalid, etInvalid, etInvalid,
      etInvalid, etInvalid, etInvalid, etInvalid, etInvalid, etInvalid,
      etInvalid, etInvalid,
      { #32 } etInvalid,
      { #33 } etBang, { #34 } etDoubleQuote, { #35 } etHash, { #36 } etDollar,
      { #37 } etPercent, { #38 } etAmpersand, { #39 } etSingleQuote,
      { #40 } etLParen,
      { #41 } etRParen, { #42 } etAsterisk, { #43 } etPlus, { #44 } etComma,
      { #45 } etMinus, { #46 } etDot, { #47 } etForwardSlash,
      // 48..57 - numbers...
      etInvalid, etInvalid, etInvalid, etInvalid, etInvalid, etInvalid,
      etInvalid, etInvalid, etInvalid, etInvalid,
      { #58 } etColon, { #59 } etSemiColon, { #60 } etLessThan,
      { #61 } etEqualTo,
      { #62 } etGreaterThan, { #63 } etQuestion, { #64 } etAt,
      // 65..90 - capital letters...
      etInvalid, etInvalid, etInvalid, etInvalid, etInvalid, etInvalid,
      etInvalid, etInvalid, etInvalid, etInvalid, etInvalid, etInvalid,
      etInvalid, etInvalid, etInvalid, etInvalid, etInvalid, etInvalid,
      etInvalid, etInvalid, etInvalid, etInvalid, etInvalid, etInvalid,
      etInvalid, etInvalid,
      { #91 } etLBracket, { #92 } etBackSlash, { #93 } etRBracket,
      { #94 } etArrow, etInvalid, // 95 - underscore
      { #96 } etBackTick,
      // 97..122 - small letters...
      etInvalid, etInvalid, etInvalid, etInvalid, etInvalid, etInvalid,
      etInvalid, etInvalid, etInvalid, etInvalid, etInvalid, etInvalid,
      etInvalid, etInvalid, etInvalid, etInvalid, etInvalid, etInvalid,
      etInvalid, etInvalid, etInvalid, etInvalid, etInvalid, etInvalid,
      etInvalid, etInvalid,
      { #123 } etLBrace,
      { #124 } etPipe, { #125 } etRBrace, { #126 } etTilde, { #127 } et127,
      { #128 } etEuro, { #129 } et129, { #130 } et130, { #131 } et131,
      { #132 } et132, { #133 } et133, { #134 } et134, { #135 } et135,
      { #136 } et136, { #137 } et137, { #138 } et138, { #139 } et139,
      { #140 } et140, { #141 } et141, { #142 } et142, { #143 } et143,
      { #144 } et144, { #145 } et145, { #146 } et146, { #147 } et147,
      { #148 } et148, { #149 } et149, { #150 } et150, { #151 } et151,
      { #152 } et152, { #153 } et153, { #154 } et154, { #155 } et155,
      { #156 } et156, { #157 } et157, { #158 } et158, { #159 } et159,
      { #160 } et160, { #161 } et161, { #162 } et162, { #163 } et163,
      { #164 } et164, { #165 } et165, { #166 } et166, { #167 } et167,
      { #168 } et168, { #169 } et169, { #170 } et170, { #171 } et171,
      { #172 } et172, { #173 } et173, { #174 } et174, { #175 } et175,
      { #176 } et176, { #177 } et177, { #178 } et178, { #179 } et179,
      { #180 } et180, { #181 } et181, { #182 } et182, { #183 } et183,
      { #184 } et184, { #185 } et185, { #186 } et186, { #187 } et187,
      { #188 } et188, { #189 } et189, { #190 } et190, { #191 } et191,
      { #192 } et192, { #193 } et193, { #194 } et194, { #195 } et195,
      { #196 } et196, { #197 } et197, { #198 } et198, { #199 } et199,
      { #200 } et200, { #201 } et201, { #202 } et202, { #203 } et203,
      { #204 } et204, { #205 } et205, { #206 } et206, { #207 } et207,
      { #208 } et208, { #209 } et209, { #210 } et210, { #211 } et211,
      { #212 } et212, { #213 } et213, { #214 } et214, { #215 } et215,
      { #216 } et216, { #217 } et217, { #218 } et218, { #219 } et219,
      { #220 } et220, { #221 } et221, { #222 } et222, { #223 } et223,
      { #224 } et224, { #225 } et225, { #226 } et226, { #227 } et227,
      { #228 } et228, { #229 } et229, { #230 } et230, { #231 } et231,
      { #232 } et232, { #233 } et233, { #234 } et234, { #235 } et235,
      { #236 } et236, { #237 } et237, { #238 } et238, { #239 } et239,
      { #240 } et240, { #241 } et241, { #242 } et242, { #243 } et243,
      { #244 } et244, { #245 } et245, { #246 } et246, { #247 } et247,
      { #248 } et248, { #249 } et249, { #250 } et250, { #251 } et251,
      { #252 } et252, { #253 } et253, { #254 } et254, { #255 } et255);
var
   { register variable optimization }
   cp: PChar;
   start: PChar;
begin
   cp := FCurrPos;

   { skip whitespace }
   while CharIsWhiteSpace(cp^) do
      Inc(cp);

   { determine token type }
   case cp^ of
      #0:
         FCurrTok := etEof;
      'a' .. 'z', 'A' .. 'Z', '_':
         begin
            start := cp;
            Inc(cp);
            while CharIsValidIdentifierLetter(cp^) do
               Inc(cp);
            SetString(FTokenAsString, start, cp - start);
            FCurrTok := etIdentifier;
         end;
      '0' .. '9':
         begin
            start := cp;

            { read in integer part of mantissa }
            while CharIsDigit(cp^) do
               Inc(cp);

            { check for and read in fraction part of mantissa }
            if (cp^ = '.') or (cp^ = DecimalSeparator) then
            begin
               Inc(cp);
               while CharIsDigit(cp^) do
                  Inc(cp);
            end;

            { check for and read in exponent }
            if (cp^ = 'e') or (cp^ = 'E') then
            begin
               Inc(cp);
               if (cp^ = '+') or (cp^ = '-') then
                  Inc(cp);
               while CharIsDigit(cp^) do
                  Inc(cp);
            end;

            { evaluate number }
            SetString(FTokenAsString, start, cp - start);
            FTokenAsNumber := StrToFloat(FTokenAsString);

            FCurrTok := etNumber;
         end;
      '<':
         begin
            Inc(cp);
            case cp^ of
               '=':
                  begin
                     FCurrTok := etLessEqual;
                     Inc(cp);
                  end;
               '>':
                  begin
                     FCurrTok := etNotEqual;
                     Inc(cp);
                  end;
            else
               FCurrTok := etLessThan;
            end;
         end;
      '>':
         begin
            Inc(cp);
            if cp^ = '=' then
            begin
               FCurrTok := etGreaterEqual;
               Inc(cp);
            end
            else
               FCurrTok := etGreaterThan;
         end;
   else
      { map character to token }
      FCurrTok := CharToTokenMap[AnsiChar(cp^)];
      Inc(cp);
   end;

   FCurrPos := cp;
end;

procedure TExprSimpleLexer.Reset;
begin
   FCurrPos := PChar(FBuf);
   inherited Reset;
end;

procedure TExprSimpleLexer.SetBuf(const ABuf: string);
begin
   FBuf := ABuf;
   Reset;
end;

constructor TExprEvalParser.Create(ALexer: TExprLexer);
begin
   inherited Create;
   FLexer := ALexer;
end;

function TExprEvalParser.Evaluate: TFloat;
begin
   Result := EvalExprLevel0(False);

   if (Lexer.CurrTok <> etEof) then
   begin
      raise EJclExprEvalError.CreateResFmt
        (@RsExprEvalUnknownSymbol, [Lexer.TokenAsString]);
   end;
end;

function TExprEvalParser.EvalExprLevel0(ASkip: boolean): TFloat;
var
   RightValue: TFloat;
begin
   Result := EvalExprLevel1(ASkip);

   while True do
      case Lexer.CurrTok of
         etEqualTo: // =
            if Result = EvalExprLevel1(True) then
               Result := 1.0
            else
               Result := 0.0;
         etNotEqual: // <>
            if Result <> EvalExprLevel1(True) then
               Result := 1.0
            else
               Result := 0.0;
         etLessThan: // <
            if Result < EvalExprLevel1(True) then
               Result := 1.0
            else
               Result := 0.0;
         etLessEqual: // <=
            if Result <= EvalExprLevel1(True) then
               Result := 1.0
            else
               Result := 0.0;
         etGreaterThan: // >
            if Result > EvalExprLevel1(True) then
               Result := 1.0
            else
               Result := 0.0;
         etGreaterEqual: // >=
            if Result >= EvalExprLevel1(True) then
               Result := 1.0
            else
               Result := 0.0;
         etIdentifier: // cmp
            if AnsiSameText(Lexer.TokenAsString, 'cmp') then
            begin
               RightValue := EvalExprLevel1(True);
               if Result > RightValue then
                  Result := 1.0
               else if Result = RightValue then
                  Result := 0.0
               else
                  Result := -1.0;
            end
            else
               Break;
      else
         Break;
      end;
end;

function TExprEvalParser.EvalExprLevel1(ASkip: boolean): TFloat;
begin
   Result := EvalExprLevel2(ASkip);

   while True do
      case Lexer.CurrTok of
         etPlus:
            Result := Result + EvalExprLevel2(True);
         etMinus:
            Result := Result - EvalExprLevel2(True);
         etIdentifier: // or, xor, bor, bxor
            if AnsiSameText(Lexer.TokenAsString, 'or') then
            begin
               if (EvalExprLevel2(True) <> 0) or (Result <> 0) then
                  // prevent boolean optimisations, EvalTerm must be called
                  Result := 1.0
               else
                  Result := 0.0;
            end
            else if AnsiSameText(Lexer.TokenAsString, 'xor') then
            begin
               if (Result <> 0) xor (EvalExprLevel2(True) <> 0) then
                  Result := 1.0
               else
                  Result := 0.0;
            end
            else if AnsiSameText(Lexer.TokenAsString, 'bor') then
               Result := Round(Result) or Round(EvalExprLevel2(True))
            else if AnsiSameText(Lexer.TokenAsString, 'bxor') then
               Result := Round(Result) xor Round(EvalExprLevel2(True))
            else
               Break;
      else
         Break;
      end;
end;

function TExprEvalParser.EvalExprLevel2(ASkip: boolean): TFloat;
begin
   Result := EvalExprLevel3(ASkip);

   while True do
      case Lexer.CurrTok of
         etAsterisk:
            Result := Result * EvalExprLevel3(True);
         etForwardSlash:
            Result := Result / EvalExprLevel3(True);
         etIdentifier: // div, mod, and, shl, shr, band
            if AnsiSameText(Lexer.TokenAsString, 'div') then
               Result := Round(Result) div Round(EvalExprLevel3(True))
            else if AnsiSameText(Lexer.TokenAsString, 'mod') then
               Result := Round(Result) mod Round(EvalExprLevel3(True))
            else if AnsiSameText(Lexer.TokenAsString, 'and') then
            begin
               if (EvalExprLevel3(True) <> 0) and (Result <> 0) then
                  // prevent boolean optimisations, EvalTerm must be called
                  Result := 1.0
               else
                  Result := 0.0;
            end
            else if AnsiSameText(Lexer.TokenAsString, 'shl') then
               Result := Round(Result) shl Round(EvalExprLevel3(True))
            else if AnsiSameText(Lexer.TokenAsString, 'shr') then
               Result := Round(Result) shr Round(EvalExprLevel3(True))
            else if AnsiSameText(Lexer.TokenAsString, 'band') then
               Result := Round(Result) and Round(EvalExprLevel3(True))
            else
               Break;
      else
         Break;
      end;
end;

function TExprEvalParser.EvalExprLevel3(ASkip: boolean): TFloat;
begin
   if ASkip then
      Lexer.NextTok;

   case Lexer.CurrTok of
      etPlus:
         Result := EvalExprLevel3(True);
      etMinus:
         Result := -EvalExprLevel3(True);
      etIdentifier: // not, bnot
         if AnsiSameText(Lexer.TokenAsString, 'not') then
         begin
            if EvalExprLevel3(True) <> 0.0 then
               Result := 0.0
            else
               Result := 1.0;
         end
         else if AnsiSameText(Lexer.TokenAsString, 'bnot') then
            Result := not Round(EvalExprLevel3(True))
         else
            Result := EvalFactor;
   else
      Result := EvalFactor;
   end;
end;

function TExprEvalParser.EvalFactor: TFloat;
begin
   case Lexer.CurrTok of
      etIdentifier:
         Result := EvalIdentFactor;
      etLParen:
         begin
            Result := EvalExprLevel0(True);
            if Lexer.CurrTok <> etRParen then
               raise EJclExprEvalError.CreateRes(@RsExprEvalRParenExpected);
            Lexer.NextTok;
         end;
      etNumber:
         begin
            Result := Lexer.TokenAsNumber;
            Lexer.NextTok;
         end;
   else
      raise EJclExprEvalError.CreateRes(@RsExprEvalFactorExpected);
   end;
end;

function TExprEvalParser.EvalIdentFactor: TFloat;
var
   Sym: TExprSym;
   oldEvalParser: TExprEvalParser;
   oldLexer: TExprLexer;
begin
   { find symbol }
   if Context = nil then
      raise EJclExprEvalError.CreateResFmt
        (@RsExprEvalUnknownSymbol, [Lexer.TokenAsString]);
   Sym := FContext.Find(Lexer.TokenAsString);
   if Sym = nil then
      raise EJclExprEvalError.CreateResFmt
        (@RsExprEvalUnknownSymbol, [Lexer.TokenAsString]);

   Lexer.NextTok;

   { set symbol properties }
   oldEvalParser := Sym.FEvalParser;
   oldLexer := Sym.Lexer;
   Sym.FLexer := Lexer;
   Sym.FEvalParser := Self;
   try
      { evaluate symbol }
      Result := Sym.Evaluate;
   finally
      Sym.FLexer := oldLexer;
      Sym.FEvalParser := oldEvalParser;
   end;
end;

constructor TExprConst32Sym.Create(const AIdent: string; AValue: TFloat32);
begin
   inherited Create(AIdent);
   FValue := AValue;
end;

// function TExprConst32Sym.Compile: TExprNode;
// begin
// Result := NodeFactory.LoadConst(FValue);
// end;

function TExprConst32Sym.Evaluate: TFloat;
begin
   Result := FValue;
end;

constructor TExprConst64Sym.Create(const AIdent: string; AValue: TFloat64);
begin
   inherited Create(AIdent);
   FValue := AValue;
end;


function TExprConst64Sym.Evaluate: TFloat;
begin
   Result := FValue;
end;

end.
