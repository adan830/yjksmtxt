unit SelectGrade;

interface
uses
   Classes,forms, SysUtils, ADODB, ufrmInProcess;

function SingleSelectGrade(AOnPreccess: TOnProcess):integer;
function MultiSelectGrade(AOnPreccess: TOnProcess):integer;

//Grade for Operation Test question
function OperationGrade(AOnProcess : TOnProcess;const AConn: TADOConnection;AExamPath:TFileName):Integer;

procedure AddScoreInfo(AAllScoreInfo: TStringList; const EQID: string; AGradeInfoStrings: TStrings;ADelimiter:Char=',');

procedure UpdateScoreInfo(const AModuleName: string; const AScoreInfoStr: string);

implementation

uses
  ExamClientGlobal, uGrade, ShellModules, Windows,Commons, ScoreIni,
  ExamGlobal, DataFieldConst, DataUtils, DB, tq;

procedure AddScoreInfo(AAllScoreInfo: TStringList; const EQID: string; AGradeInfoStrings: TStrings;ADelimiter:Char=',');
var
   AScoreInfo:TStringList;
begin
   AScoreInfo :=TStringList(GradeInfoStringsToScoreInfoStrings(EQID,AGradeInfoStrings,ADelimiter));
   try
      AAllScoreInfo.AddStrings( AScoreInfo);
   finally
      AScoreInfo.Free;
   end;
end;
function SingleSelectGrade(AOnPreccess: TOnProcess):integer;
var
  fs:integer;
  str:string;
  tq : TTQ;
  AScoreInfo :TStringList;
  ADS : TDataSet;
begin
  AScoreInfo:=TstringList.Create;
  tq := TTQ.Create;
  ads := getdatasetbyprefix('A%',TExamClientGlobal.ConnClientDB);
  try
    with  ADS do begin
      fs:=0;
      while not Eof do
      begin
        tq.ClearData;
        TTQ.ReadTQAndUnCompressFromDS(ADS,tq);

        if FieldByName(DFNTQ_KSDA).Text = tq.ReadStAnswerStr then
        begin
          fs:=fs+1;
          str:=FormatSelectGradeInfo(tq.St_no,FieldByName(DFNTQ_KSDA).Text,True);
        end
        else
        begin
          str:=FormatSelectGradeInfo(tq.St_no,FieldByName(DFNTQ_KSDA).Text,False);
        end;
        AScoreInfo.Add(str);
        ads.Next;
        //PMOnProcess(AApp,pbHandle,'正在对　单项选择题　评分！');
        AOnPreccess('正在对　单项选择题　第'+tq.St_no+'题　评分！');

        sleep(100);
      end;
      UpdateScoreInfo(MODULE_SINGLE_NAME,AScoreInfo.Text);
  //      SaveScoreInto('siglescore.txt',AScoreInfo);
  //    UpdateScoreInfo(SINGLESELECT_MODEL,AScoreInfo.text);
    end;       
  finally // wrap up
     AScoreInfo.Free;
     ads.free;
     tq.free;
  end;    // try/finally
end;

function MultiSelectGrade(AOnPreccess: TOnProcess):integer;
var
  fs:integer;
  str:string;
  AScoreInfo:TStringList;
  tq : TTQ;
  ADS : TDataSet;
begin
   AScoreInfo:=TstringList.Create;
   tq := TTQ.Create;
   ads := getdatasetbyprefix('X%',TExamClientGlobal.ConnClientDB);
   try
     with  ADS do begin
        fs:=0;
        while not Eof do
        begin
          tq.ClearData;
          TTQ.ReadTQAndUnCompressFromDS(ADS,tq);
          if FieldByName(DFNTQ_KSDA).Text = tq.ReadStAnswerStr  then
          begin
            fs:=fs+2;
            str:=FormatSelectGradeInfo(tq.St_no,FieldByName(DFNTQ_KSDA).Text,true);
          end
          else
          begin
            str:=FormatSelectGradeInfo(tq.St_no,FieldByName(DFNTQ_KSDA).Text,False);
          end;
          AScoreInfo.Add(str);
          ADS.Next;
          AOnPreccess('正在对　多项选择题　第'+FieldByName(DFNTQ_KSDA).Text+'题　评分！',2);
          sleep(100);
        end;
        UpdateScoreInfo(MODULE_MULTIPLE_NAME,AScoreInfo.Text);
          //SaveScoreInto('Multiscore.txt',AScoreInfo);
    //    UpdateScoreInfo(MULTISELECT_MODEL,ScoreInfoStrings.text);
     end;
   finally
      AScoreInfo.Free;
      ads.free;
      tq.free;
   end;
end;

function OperationGrade(AOnProcess : TOnProcess;const AConn: TADOConnection;AExamPath:TFileName):Integer;
var
   GradeInfoStrings : TStringList;
   dllHandle :THandle;
   delegateGrade : fnFillGrades;
   i:integer;
   ads : TDataSet;
   tq : TTQ;
begin
   GradeInfoStrings := TStringList.Create;
   tq := TTQ.Create;
   try
      for i := 0 to length(TExamClientGlobal.Modules)-1 do
      begin
         with TExamClientGlobal.Modules[i] do
         begin
            ads := GetDataSetByPreFix(Prefix + '%',AConn);
            try
              if not ads.IsEmpty then begin
                tq.ClearData;
                TTQ.ReadTQAndUnCompressFromDS(ads,tq);
                tq.ReadStAnswerToStrings(GradeInfoStrings);
                @delegateGrade := GetProcAddress(dllHandle,FN_FILLGRADES);
                delegateGrade(GradeInfoStrings,TExamClientGlobal.ExamPath,DocName,AOnProcess);
              end;
              with GradeInfoStringsToScoreInfoStrings(tq.St_no,GradeInfoStrings,DelimiterChar) do begin
                UpdateScoreInfo(Name,Text);
                Free;
              end;                
            finally
              ads.Free;
              GradeInfoStrings.Clear;
            end; 
         end;
      end;
   finally
     GradeInfoStrings.Free;
     tq.Free;
   end;
end;

procedure UpdateScoreInfo(const AModuleName: string; const AScoreInfoStr: string);
begin
     TExamClientGlobal.Score.WriteString(AModuleName,AScoreInfoStr);
end;
end.
