unit BaseConfig;

interface

uses
  Classes;

type
parray=array [0..4]of pchar;
EQStrategyParamArray=array of array of  pchar;
///�����д��������
TEQStrategySubItem = record
   Lx:integer;
   Param1:string;
   Count:integer;
   bb:TThreadList
end;
//ѡ����Դ���
PEQStrategyMainItem= ^TEQStrategyMainItem;
TEQStrategyMainItem =record
   Lx:integer;
   ObjStr:string;
   ItemCount:integer;
   Items:array of TEQStrategySubItem;
end;
//��������
   PBaseConfig= ^TBaseConfig;
   TBaseConfig = class
   private
      //FID:integer;
      FExamName:string;
      FExamClasify : string;
      FLastDate :TDate;        //realy is tdatetime but used in client so not covert
      FScoreDisplayMode:string; //realy is integer but used in client so not covert
      FExamPath:string;
      FExamTime:Integer;
      FTypeTime:Integer;
      FStatusRefreshInterval:Integer;
      FModules:TStringList;
      FEQStrategies:TList;
        //list is consist of PEQStrategyMainItem;
   public
      //property ID:integer read FID;
      property ExamName:string read FExamName;
      property ExamClasify : string read FExamClasify;
      property LastDate :TDate read FLastDate;        //realy is tdatetime but used in client so not covert
      property ScoreDisplayMode:string read FScoreDisplayMode; //realy is integer but used in client so not covert
      property ExamPath:string read FExamPath;
      property ExamTime:Integer read FExamTime;
      property TypeTime:Integer read FTypeTime;
      property StatusRefreshInterval:Integer read FStatusRefreshInterval;
      property Modules:TStringList read FModules;
      property EQStrategies:TList read FEQStrategies;   //list is consist of PEQStrategyMainItem;
   public
      constructor Create();
      destructor Destroy; override;
      procedure SetConfig(AText:string);
      procedure SetModules(AText:string);
      procedure SetEQStrategies(AText:string);
      //���ַ��б��ת��ͬ��ֻת�����֣�����ѡ����Բ�ת��
      //�����ƻ������ú�ģ�飬��������ѡ����ԣ���Ϊֻ���ڷ���������Ҫѡ����ԣ�����ϵͳ�в���Ҫ��
      function ToStrings: TStringList;
      procedure FromStrings(AStrings: TStrings);
      procedure ModifyCustomConfig(AInterval:Integer;AexamPath:string);
   end;

implementation

uses SysUtils;
{ TBaseConfig }


constructor TBaseConfig.Create;
begin
  FModules :=TStringList.Create;
  FEQStrategies:=TList.Create;
end;

destructor TBaseConfig.Destroy;
var
  i:Integer;
  EQStrategyMainItem:PEQStrategyMainItem;
begin
  FModules.Free;
  for I := FEQStrategies.Count-1 downto 0 do begin
     EQStrategyMainItem := FEQStrategies[i];
     FEQStrategies.Remove(EQStrategyMainItem);
     Dispose(EQStrategyMainItem);
  end;
  FEQStrategies.Free;
  inherited;
end;

procedure TBaseConfig.SetConfig(AText: string);
var
  stringList :TStringList;
begin
  stringList :=TStringList.Create;
  try
      stringList.Text := AText;
      FExamName:=stringList.Values['����'] ;
      FExamClasify := stringList.Values['����'];
      FLastDate := StrToInt64( stringList.Values['��Ч����']);
      FScoreDisplayMode:=stringList.Values['��ʾ�ɼ�'];
      FExamPath := stringList.Values['����·��'];
      FExamTime := StrToInt(stringList.Values['����ʱ��']);
      FTypeTime := StrToInt(stringList.Values['����ʱ��']);
      FStatusRefreshInterval := StrToInt(stringList.Values['״̬���¼��']);
  finally
    stringList.free;
  end;
end;

procedure TBaseConfig.SetEQStrategies(AText: string);
var
  stringList :TStringList;
  i:Integer;
  EQStrategyMainItem:PEQStrategyMainItem;

    procedure ParseStrToStrategyMainItem(commandstring: string;  var AEGStrategyMainItem:TEQStrategyMainItem);
    var
      temp,temp1:pchar;
      index:integer;
      FontItemCount:integer;
    begin
      temp:=pchar(commandstring);
      temp1:=temp;
      temp:=strscan(temp,',');
      temp[0]:=#0;
      temp:=temp+1;
      AEGStrategyMainItem.Lx:=strtoint(temp1);

      temp1:=temp;
      temp:=strscan(temp,',');
      temp[0]:=#0;
      temp:=temp+1;
      AEGStrategyMainItem.ObjStr:=temp1;

      temp1:=temp;
      temp:=strscan(temp,',');
      temp[0]:=#0;
      temp:=temp+1;
      AEGStrategyMainItem.ItemCount:=strtoint(temp1);

      setlength(AEGStrategyMainItem.items,AEGStrategyMainItem.ItemCount);
    //  FontItemCount:=3;
    //  index:=0;
      with AEGStrategyMainItem do
      begin
        for index:=0 to ItemCount-1 do
        begin
          temp1:=temp;
          temp:=strscan(temp,',');
          temp[0]:=#0;
          temp:=temp+1;
          Items[index].Lx:=strtoint(temp1);

          temp1:=temp;
          temp:=strscan(temp,',');
          temp[0]:=#0;
          temp:=temp+1;
          Items[index].Param1:=temp1;

          temp1:=temp;
          temp:=strscan(temp,',');
          temp[0]:=#0;
          temp:=temp+1;
          Items[index].Count:=strtoint(temp1);
        end;
      end;
    end;
begin
  stringList :=TStringList.Create;
  for I := FEQStrategies.Count-1 downto 0 do begin
     EQStrategyMainItem := FEQStrategies[i];
     FEQStrategies.Remove(EQStrategyMainItem);
     Dispose(EQStrategyMainItem);
  end;

  FEQStrategies.Clear;
  try
    stringList.Text := AText;
    for i := 0 to stringList.Count-1 do
    begin
       new(EQStrategyMainItem);
       ParseStrToStrategyMainItem(stringList[i],EQStrategyMainItem^);
       FEQStrategies.Add(EQStrategyMainItem);
    end;
  finally
    stringList.free;
  end;
end;

procedure TBaseConfig.SetModules(AText: string);
begin
   FModules.Clear;
   FModules.Text :=AText;
end;

function  TBaseConfig.ToStrings() : TStringList;
var
   i:Integer;
begin
     Result := TStringList.Create;
     Result.Add(FExamName);
     Result.Add(FExamClasify);
     Result.Add( inttostr(trunc(FLastDate)));
     Result.Add(FScoreDisplayMode);
     Result.Add(FExamPath);  //ABaseConfig.ExamPath ���ڷ�����������
     Result.Add(IntToStr(FStatusRefreshInterval));
     Result.Add(IntToStr(FExamTime));
     Result.Add(IntToStr(FTypeTime));
     for i := 0 to Modules.Count-1 do begin
        Result.Add(FModules[i]);
     end;
end;

procedure TBaseConfig.FromStrings(AStrings :TStrings);
var
   i:Integer;
begin
   FExamName := AStrings[0];
   FExamClasify := AStrings[1];
   FLastDate := strtoint64(AStrings[2]);
   FScoreDisplayMode := (AStrings[3]);
   FExamPath := AStrings[4];
   FStatusRefreshInterval :=StrToInt(AStrings[5]);
   FExamTime :=StrToInt(AStrings[6]);
   FTypeTime :=StrToInt(AStrings[7]);
   if (AStrings.Count>=8)and (FModules=nil) then  FModules:=TStringList.Create;
   for i := 8 to AStrings.Count-1 do begin
     FModules.Add(AStrings[i]);
   end;
end;

procedure TBaseConfig.ModifyCustomConfig(AInterval: Integer; AexamPath: string);
begin
  FStatusRefreshInterval := AInterval;
  FExamPath := AexamPath;
end;

end.
