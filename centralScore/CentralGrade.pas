unit CentralGrade;

interface

uses
   Classes,
   forms,
   SysUtils,
   ADODB,
   ufrmInProcess,
   scoreini,
   uGrade;

type
   TCentralGrade = class(TObject)
   private
      FDocPath: string;
      FConnClientDB: TADOConnection;
      FOnProcess: TOnProcess;

      FScore: TScoreIni;
      FModules: TModules;
   public
      ErrorMessage: string;

      property ConnClientDB: TADOConnection read FConnClientDB;
      property DocPath: string read FDocPath write FDocPath;
      property Score: TScoreIni read FScore write FScore;

      constructor Create(ADocPath: string; AConnClientDB: TADOConnection; AOnProcess: TOnProcess);
      destructor Destroy; override;

      function SingleSelectGrade: integer;
      function MultiSelectGrade: integer;
      function TypeGrade: integer;
      function OperationGrade: integer;

      procedure AddScoreInfo(AAllScoreInfo: TStringList; const EQID: string; AGradeInfoStrings: TStrings; ADelimiter: Char = ',');

      procedure UpdateScoreInfo(const AModuleName: string; const AScoreInfoStr: string);

   end;

implementation

uses
   ShellModules,
   Windows,
   Commons,
   ExamGlobal,
   DataFieldConst,
   DataUtils,
   DB,
   tq,
   Vcl.ComCtrls;

procedure TCentralGrade.AddScoreInfo(AAllScoreInfo: TStringList; const EQID: string; AGradeInfoStrings: TStrings; ADelimiter: Char = ',');
var
   AScoreInfo: TStringList;
begin
   AScoreInfo := TStringList(GradeInfoStringsToScoreInfoStrings(EQID, AGradeInfoStrings, ADelimiter));
   try
      AAllScoreInfo.AddStrings(AScoreInfo);
   finally
      AScoreInfo.Free;
   end;
end;

constructor TCentralGrade.Create(ADocPath: string; AConnClientDB: TADOConnection; AOnProcess: TOnProcess);
var
   moduleList: TStringList;
   i: integer;
begin
   inherited Create();
   FScore := TScoreIni.Create;
   moduleList := TStringList.Create;
   moduleList.Add('WindowsModule.dll');
   moduleList.Add('WordModule.dll');
   moduleList.Add('ExcelModule.dll');
   moduleList.Add('PptModule.dll');

   SetLength(FModules, moduleList.Count);
   for i := 0 to moduleList.Count - 1 do
      begin
         FModules[i] := TModuleInfo.Create;
         FModules[i].FillModuleInfo(moduleList[i]);
      end;

   self.FConnClientDB := AConnClientDB;
   self.FDocPath := ADocPath;
   FOnProcess := AOnProcess;
end;

destructor TCentralGrade.Destroy;
begin
   FreeAndNil(FScore);
   inherited;
end;

function TCentralGrade.MultiSelectGrade(): integer;
var
   fs: integer;
   str: string;
   AScoreInfo: TStringList;
   tq: TTQ;
   ADS: TDataSet;
begin
   AScoreInfo := TStringList.Create;
   tq := TTQ.Create;
   ADS := getdatasetbyprefix('X%', ConnClientDB);
   try
      with ADS do
         begin
            fs := 0;
            while not Eof do
               begin
                  tq.ClearData;
                  TTQ.ReadTQAndUnCompressFromDS(ADS, tq);
                  if FieldByName(DFNTQ_KSDA).Text = tq.ReadStAnswerStr then
                     begin
                        fs := fs + 2;
                        str := FormatSelectGradeInfo(tq.St_no, '2', FieldByName(DFNTQ_KSDA).Text, True);
                     end
                  else
                     begin
                        str := FormatSelectGradeInfo(tq.St_no, '2', FieldByName(DFNTQ_KSDA).Text, False);
                     end;
                  AScoreInfo.Add(str);
                  ADS.Next;
                  FOnProcess('正在对　多项选择题　第' + FieldByName(DFNTQ_KSDA).Text + '题　评分！', 2);
                  sleep(100);
               end;
            UpdateScoreInfo(MODULE_MULTIPLE_NAME, AScoreInfo.Text);
            // SaveScoreInto('Multiscore.txt',AScoreInfo);
            // UpdateScoreInfo(MULTISELECT_MODEL,ScoreInfoStrings.text);
         end;
   finally
      AScoreInfo.Free;
      ADS.Free;
      tq.Free;
   end;
end;

// 评分时需要解决以下异常：
// 文档不存在，提示学生改正
// word文档关闭时出错，显示文档为只读，需要另存为，可测试问题文件夹中25511101026考生文档
function TCentralGrade.OperationGrade(): integer;
var
   GradeInfoStrings: TStringList;
   dllHandle: THandle;
   delegateGrade: fnFillGrades;
   i: integer;
   ADS: TDataSet;
   tq: TTQ;
begin
   GradeInfoStrings := TStringList.Create;
   tq := TTQ.Create;
   try
      for i := 0 to length(FModules) - 1 do
         begin
            with FModules[i] do
               begin
                  if ( DocName<>'') and (not FileExists(IncludeTrailingPathDelimiter(FDocPath) + DocName)) then
                  begin
                     ErrorMessage:=errorMessage+EOL + docname+'文件不存在';
                     break;
                  end;

                     ADS := getdatasetbyprefix(Prefix + '%', ConnClientDB);
                  try
                     if not ADS.IsEmpty then
                        begin
                           tq.ClearData;
                           TTQ.ReadTQAndUnCompressFromDS(ADS, tq);
                           tq.ReadStAnswerToStrings(GradeInfoStrings);
                           @delegateGrade := GetProcAddress(dllHandle, FN_FILLGRADES);
                           delegateGrade(GradeInfoStrings, FDocPath, DocName, FOnProcess);
                        end;
                     with GradeInfoStringsToScoreInfoStrings(tq.St_no, GradeInfoStrings, DelimiterChar) do
                        begin
                           UpdateScoreInfo(Name, Text);
                           Free;
                        end;
                  finally
                     ADS.Free;
                     GradeInfoStrings.Clear;
                  end;
               end;
         end;
   finally
      GradeInfoStrings.Free;
      tq.Free;
   end;
end;

function TCentralGrade.SingleSelectGrade(): integer;
var
   fs: integer;
   str: string;
   tq: TTQ;
   AScoreInfo: TStringList;
   ADS: TDataSet;
begin
   AScoreInfo := TStringList.Create;
   tq := TTQ.Create;
   ADS := getdatasetbyprefix('A%', ConnClientDB);
   try
      with ADS do
         begin
            fs := 0;
            while not Eof do
               begin
                  tq.ClearData;
                  TTQ.ReadTQAndUnCompressFromDS(ADS, tq);

                  if FieldByName(DFNTQ_KSDA).Text = tq.ReadStAnswerStr then
                     begin
                        fs := fs + 1;
                        str := FormatSelectGradeInfo(tq.St_no, '1', FieldByName(DFNTQ_KSDA).Text, True);
                     end
                  else
                     begin
                        str := FormatSelectGradeInfo(tq.St_no, '1', FieldByName(DFNTQ_KSDA).Text, False);
                     end;
                  AScoreInfo.Add(str);
                  ADS.Next;
                  // PMOnProcess(AApp,pbHandle,'正在对　单项选择题　评分！');
                  FOnProcess('正在对　单项选择题　第' + tq.St_no + '题　评分！');

                  sleep(100);
               end;
            UpdateScoreInfo(MODULE_SINGLE_NAME, AScoreInfo.Text);
            // SaveScoreInto('siglescore.txt',AScoreInfo);
            // UpdateScoreInfo(SINGLESELECT_MODEL,AScoreInfo.text);
         end;
   finally // wrap up
      AScoreInfo.Free;
      ADS.Free;
      tq.Free;
   end; // try/finally
end;

function TCentralGrade.TypeGrade: integer;
var
   tq: TTQ;
   ADS: TDataSet;
   sourceRich: TRichEdit;
   sourceStr, ksStr: string;
   wordnum, correctnum, i: integer;
begin
   tq := TTQ.Create;
   ADS := getdatasetbyprefix('C%', FConnClientDB);
   try
      tq.ClearData;
      TTQ.ReadTQAndUnCompressFromDS(ADS, tq);
      sourceRich := TRichEdit.Create(Application.MainForm);
      sourceRich.Visible := False;
      sourceRich.Parent := Application.MainForm;
      tq.ReadContentToStrings(sourceRich.Lines);
      sourceStr := sourceRich.Text;

      tq.ReadEnvironmentToStrings(sourceRich.Lines);
      ksStr := sourceRich.Text;

      wordnum := length(sourceStr);
      if length(ksStr) < wordnum then
         wordnum := length(ksStr);

      correctnum := 0;
      for i := 1 to wordnum do
         begin
            if ksStr[i] = sourceStr[i] then
               correctnum := correctnum + 1;
         end;
      wordnum := length(sourceStr);
      if (wordnum > 0) then
         wordnum := round((correctnum / wordnum) * 10);


      if wordnum < 0 then
         begin
            wordnum := 0;
         end;
      UpdateScoreInfo(MODULE_KEYTYPE_NAME, tq.St_no + ',1,type,' + inttostr(wordnum) + ',,,-1,');
   finally // wrap up
      ADS.Free;
      tq.Free;
   end; // try/finally
end;

procedure TCentralGrade.UpdateScoreInfo(const AModuleName, AScoreInfoStr: string);
begin
   Score.WriteString(AModuleName, AScoreInfoStr);
end;

end.
