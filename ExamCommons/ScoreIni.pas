unit ScoreIni;

interface
uses IniFiles, Classes;

type
   TScoreIni = class(TCustomIniFile)
  private
    FSections: TStringList;
    function AddSection(const Section: string): TStrings;
    function OperateScoreValue(ScoreInfoStrings: TStrings; chr: char): Single;
  public
    constructor Create();
    destructor Destroy; override;
    procedure Clear;
    function GetTextStr: string;
    procedure LoadFormStream(AStream:TStream);
    procedure WriteString(const Section, Value: String);
    procedure EraseSection(const Section: string); override;
    procedure GetStrings(List: TStrings);
    procedure ReadSection(const Section: string; Strings: TStrings); override;
    procedure ReadSectionByIndex(const index: integer; Strings: TStrings);
    procedure SetStrings(List: TStrings);
    procedure SaveToStream(AStream:TStream);

    function GetScoreValue() : Integer;
  end;

implementation

uses
  SysUtils, uGrade,Commons, ExamGlobal;

{ TScoreIni }

constructor TScoreIni.Create();
begin
  inherited Create(FileName);
  FSections := THashedStringList.Create;
end;

destructor TScoreIni.Destroy;
begin
  if FSections <> nil then begin
    Clear;
  end;
  FSections.Free;
  inherited Destroy;
end;


function TScoreIni.AddSection(const Section: string): TStrings;
begin
  Result := THashedStringList.Create;
  try
    FSections.AddObject(Section, Result);
  except
    Result.Free;
    raise;
  end;
end;

procedure TScoreIni.Clear;
var
  I: Integer;
begin
  for I := 0 to FSections.Count - 1 do
    TObject(FSections.Objects[I]).Free;
  FSections.Clear;
end;

procedure TScoreIni.EraseSection(const Section: string);
var
  I: Integer;
begin
  I := FSections.IndexOf(Section);
  if I >= 0 then
  begin
    TStrings(FSections.Objects[I]).Free;
    FSections.Delete(I);
  end;
end;


function TScoreIni.GetScoreValue: Integer;
var
  I,j: Integer;
  ScoreInfoStrings : TStringList;
  scoreinfo : TScoreInfo;
  zf:Single;
begin
  zf := 0;
  ScoreInfoStrings := TStringList.Create;
  try
    ReadSection(MODULE_SINGLE_NAME,ScoreInfoStrings);
    for j := 0 to ScoreInfoStrings.Count - 1 do begin
        StrToScoreInfo(ScoreInfoStrings[j],scoreinfo);
        if (scoreinfo.IsRight=-1) then zf := zf + 1;
      end;
    ScoreInfoStrings.Clear;
   ReadSection(MODULE_MULTIPLE_NAME,ScoreInfoStrings);
   for j := 0 to ScoreInfoStrings.Count - 1 do begin
        StrToScoreInfo(ScoreInfoStrings[j],scoreinfo);
        if (scoreinfo.IsRight=-1) then zf := zf + 2;
      end;

    ReadSection(MODULE_KEYTYPE_NAME,ScoreInfoStrings);
    if ScoreInfoStrings.Count>0 then
        StrToScoreInfo(ScoreInfoStrings[0],scoreinfo);
    zf :=zf+ scoreinfo.Points;
    ReadSection('Windows',ScoreInfoStrings);
    zf :=zf+ OperateScoreValue(ScoreInfoStrings,',');
    ReadSection('Word',ScoreInfoStrings);
    zf :=zf+ OperateScoreValue(ScoreInfoStrings,',');
    ReadSection('Excel',ScoreInfoStrings);
    zf :=zf+ OperateScoreValue(ScoreInfoStrings,'~');
    ReadSection('Ppt',ScoreInfoStrings);
    zf :=zf+ OperateScoreValue(ScoreInfoStrings,',');
  finally
    ScoreInfoStrings.Free;
  end;
  result:=Trunc( zf);
end;


function TScoreIni.OperateScoreValue(ScoreInfoStrings: TStrings;chr:char): Single;
var
  I: Integer;
  Score : single;
  scoreInfo:TScoreInfo;
  strTemp:string;
begin
  score := 0;
  for I := 1 to ScoreInfoStrings.Count  do    // Iterate
  begin
    strTemp:=string.Copy( ScoreInfoStrings.Strings[i-1]);
    StrToScoreInfo(strTemp,scoreinfo,chr);
    if scoreinfo.IsRight=-1 then
    begin
      Score := score + scoreInfo.points;
    end
  end;    // for
  score:= score/10;
  result := Score;
end;

procedure TScoreIni.GetStrings(List: TStrings);
var
  I, J: Integer;
  Strings: TStrings;
begin
  List.BeginUpdate;
  try
    for I := 0 to FSections.Count - 1 do
    begin
      List.Add('[' + FSections[I] + ']');
      Strings := TStrings(FSections.Objects[I]);
      for J := 0 to Strings.Count - 1 do List.Add(Strings[J]);
      List.Add('');
    end;
  finally
    List.EndUpdate;
  end;
end;

function TScoreIni.GetTextStr():string;
var
  list:TStringList;
begin
  list :=TStringList.Create;
  try
    GetStrings(list);
    result:= list.Text;
  finally
    list.Free;
  end;
end;

procedure TScoreIni.LoadFormStream(AStream:TStream);
var
  List: TStringList;
begin
  if AStream <> nil  then
  begin
    List := TStringList.Create;
    try
      List.LoadFromStream(AStream);
      SetStrings(List);
    finally
      List.Free;
    end;
  end
  else
    Clear;
end;

procedure TScoreIni.ReadSection(const Section: string;
  Strings: TStrings);
var
  I, J: Integer;
  SectionStrings: TStrings;
begin
  Strings.BeginUpdate;
  try
    Strings.Clear;
    I := FSections.IndexOf(Section);
    if I >= 0 then
    begin
      SectionStrings := TStrings(FSections.Objects[I]);
      for J := 0 to SectionStrings.Count - 1 do
        Strings.Add(SectionStrings[J]);
    end;
  finally
    Strings.EndUpdate;
  end;
end;

procedure TScoreIni.ReadSectionByIndex(const index: integer; Strings: TStrings);
var
  J: Integer;
  SectionStrings: TStrings;
begin
  Strings.BeginUpdate;
  try
    Strings.Clear;
    if index >= 0 then
    begin
      SectionStrings := TStrings(FSections.Objects[index]);
      for J := 0 to SectionStrings.Count - 1 do
        Strings.Add(SectionStrings[J]);
    end;
  finally
    Strings.EndUpdate;
  end;
end;

procedure TScoreIni.SetStrings(List: TStrings);
var
  I, J: Integer;
  S: string;
  Strings: TStrings;
begin
  Clear;
  Strings := nil;
  for I := 0 to List.Count - 1 do
  begin
    S := Trim(List[I]);
    if (S <> '') and (S[1] <> ';') then
      if (S[1] = '[') and (S[Length(S)] = ']') then
      begin
        Delete(S, 1, 1);
        SetLength(S, Length(S)-1);
        Strings := AddSection(Trim(S));
      end
      else
        if Strings <> nil then
            Strings.Add(S);
  end;
end;

procedure TScoreIni.SaveToStream(AStream:TStream);
var
  List: TStringList;
begin
  List := TStringList.Create;
  try
    GetStrings(List);
    List.SaveToStream(AStream);
  finally
    List.Free;
  end;
end;

procedure TScoreIni.WriteString(const Section, Value: String);
var
  I: Integer;
  Strings: TStrings;
begin
  I := FSections.IndexOf(Section);
  if I >= 0 then
    Strings := TStrings(FSections.Objects[I])
  else
    Strings := AddSection(Section);
  Strings.Text := Value;
end;


end.
