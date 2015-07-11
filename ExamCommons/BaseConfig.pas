unit BaseConfig;

interface

uses
   Classes;

type
   parray               = array [0 .. 4] of pchar;
   EQStrategyParamArray = array of array of pchar;

   /// 策略中大项的子项
   TEQStrategySubItem = record
      Lx: integer;
      Param1: string;
      Count: integer;
      bb: TThreadList end;
      // 选题策略大项
      PEQStrategyMainItem = ^TEQStrategyMainItem;
      TEQStrategyMainItem = record Lx: integer;
      ObjStr: string;
      ItemCount: integer;
      Items: array of TEQStrategySubItem;
   end;

   // 试题库策略
   PBaseConfig = ^TBaseConfig;

   TBaseConfig = class
   private
      // FID:integer;
      FExamName             : string;
      FExamClasify          : string;
      FLastDate             : TDate;  // realy is tdatetime but used in client so not covert
      FScoreDisplayMode     : string; // realy is integer but used in client so not covert
      FExamPath             : string;
      FLoginPermissionMode  : integer;
      FRetryPwd             : string;
      FExamTime             : integer;
      FTypeTime             : integer;
      FStatusRefreshInterval: integer;
      FModules              : TStringList;
      FEQStrategies         : TList;
      // list is consist of PEQStrategyMainItem;
   public
      // property ID:integer read FID;
      property ExamName             : string read FExamName;
      property ExamClasify          : string read FExamClasify;
      property LastDate             : TDate read FLastDate; // realy is tdatetime but used in client so not covert
      property ScoreDisplayMode     : string read FScoreDisplayMode; // realy is integer but used in client so not covert
      property ExamPath             : string read FExamPath;
      property LoginPermissionMode  : integer read FLoginPermissionMode;
      property RetryPwd             : string read FRetryPwd;
      property ExamTime             : integer read FExamTime;
      property TypeTime             : integer read FTypeTime;
      property StatusRefreshInterval: integer read FStatusRefreshInterval;
      property Modules              : TStringList read FModules;
      property EQStrategies         : TList read FEQStrategies; // list is consist of PEQStrategyMainItem;
   public
      constructor Create();
      destructor Destroy; override;
      procedure SetConfig(AText: string);
      procedure SetModules(AText: string);
      procedure SetEQStrategies(AText: string);
      // 到字符列表的转换同，只转换部分，关于选题策略不转换
      // 仅复制基本配置和模块，但不复制选题策略，因为只有在服务器端需要选题策略，其它系统中不需要。
      function ToStrings: TStringList;
      procedure FromStrings(AStrings: TStrings);
      procedure ModifyCustomConfig(AInterval: integer; AexamPath: string; aLoginPermissionModel: integer);
   end;

implementation

uses SysUtils;
{ TBaseConfig }

constructor TBaseConfig.Create;
   begin
      FModules      := TStringList.Create;
      FEQStrategies := TList.Create;
   end;

destructor TBaseConfig.Destroy;
   var
      i                 : integer;
      EQStrategyMainItem: PEQStrategyMainItem;
   begin
      FModules.Free;
      for i := FEQStrategies.Count - 1 downto 0 do
      begin
         EQStrategyMainItem := FEQStrategies[i];
         FEQStrategies.Remove(EQStrategyMainItem);
         Dispose(EQStrategyMainItem);
      end;
      FEQStrategies.Free;
      inherited;
   end;

procedure TBaseConfig.SetConfig(AText: string);
   var
      stringList: TStringList;
   begin
      stringList := TStringList.Create;
      try
         stringList.Text        := AText;
         FExamName              := stringList.Values['名称'];
         FExamClasify           := stringList.Values['类型'];
         FLastDate              := StrToInt64(stringList.Values['有效日期']);
         FScoreDisplayMode      := stringList.Values['显示成绩'];
         FExamPath              := stringList.Values['考试路径'];
         FLoginPermissionMode   := strtoint(stringList.Values['登录许可模式']);
         FRetryPwd              := stringList.Values['重续延考密码'];
         FExamTime              := StrToInt(stringList.Values['考试时间']);
         FTypeTime              := StrToInt(stringList.Values['打字时间']);
         FStatusRefreshInterval := StrToInt(stringList.Values['状态更新间隔']);
      finally
         stringList.Free;
      end;
   end;

procedure TBaseConfig.SetEQStrategies(AText: string);
   var
      stringList        : TStringList;
      i                 : integer;
      EQStrategyMainItem: PEQStrategyMainItem;

      procedure ParseStrToStrategyMainItem(commandstring: string; var AEGStrategyMainItem: TEQStrategyMainItem);
         var
            temp, temp1  : pchar;
            index        : integer;
            FontItemCount: integer;
         begin
            temp                   := pchar(commandstring);
            temp1                  := temp;
            temp                   := strscan(temp, ',');
            temp[0]                := #0;
            temp                   := temp + 1;
            AEGStrategyMainItem.Lx := StrToInt(temp1);

            temp1                      := temp;
            temp                       := strscan(temp, ',');
            temp[0]                    := #0;
            temp                       := temp + 1;
            AEGStrategyMainItem.ObjStr := temp1;

            temp1                         := temp;
            temp                          := strscan(temp, ',');
            temp[0]                       := #0;
            temp                          := temp + 1;
            AEGStrategyMainItem.ItemCount := StrToInt(temp1);

            setlength(AEGStrategyMainItem.Items, AEGStrategyMainItem.ItemCount);
            // FontItemCount:=3;
            // index:=0;
            with AEGStrategyMainItem do
            begin
               for index := 0 to ItemCount - 1 do
               begin
                  temp1           := temp;
                  temp            := strscan(temp, ',');
                  temp[0]         := #0;
                  temp            := temp + 1;
                  Items[index].Lx := StrToInt(temp1);

                  temp1               := temp;
                  temp                := strscan(temp, ',');
                  temp[0]             := #0;
                  temp                := temp + 1;
                  Items[index].Param1 := temp1;

                  temp1              := temp;
                  temp               := strscan(temp, ',');
                  temp[0]            := #0;
                  temp               := temp + 1;
                  Items[index].Count := StrToInt(temp1);
               end;
            end;
         end;

   begin
      stringList := TStringList.Create;
      for i      := FEQStrategies.Count - 1 downto 0 do
      begin
         EQStrategyMainItem := FEQStrategies[i];
         FEQStrategies.Remove(EQStrategyMainItem);
         Dispose(EQStrategyMainItem);
      end;

      FEQStrategies.Clear;
      try
         stringList.Text := AText;
         for i           := 0 to stringList.Count - 1 do
         begin
            new(EQStrategyMainItem);
            ParseStrToStrategyMainItem(stringList[i], EQStrategyMainItem^);
            FEQStrategies.Add(EQStrategyMainItem);
         end;
      finally
         stringList.Free;
      end;
   end;

procedure TBaseConfig.SetModules(AText: string);
   begin
      FModules.Clear;
      FModules.Text := AText;
   end;

function TBaseConfig.ToStrings(): TStringList;
   var
      i: integer;
   begin
      Result := TStringList.Create;
      Result.Add(FExamName);
      Result.Add(FExamClasify);
      Result.Add(inttostr(trunc(FLastDate)));
      Result.Add(FScoreDisplayMode);
      Result.Add(FExamPath); // ABaseConfig.ExamPath 可在服务器端配置
      Result.Add(inttostr(FLoginPermissionMode));
      Result.Add(FRetryPwd); // ABaseConfig.FRetryPwd 可在服务器端配置
      Result.Add(inttostr(FStatusRefreshInterval));
      Result.Add(inttostr(FExamTime));
      Result.Add(inttostr(FTypeTime));
      for i := 0 to Modules.Count - 1 do
      begin
         Result.Add(FModules[i]);
      end;
   end;

procedure TBaseConfig.FromStrings(AStrings: TStrings);
   var
      i: integer;
   begin
      FExamName              := AStrings[0];
      FExamClasify           := AStrings[1];
      FLastDate              := StrToInt64(AStrings[2]);
      FScoreDisplayMode      := (AStrings[3]);
      FExamPath              := AStrings[4];
      FLoginPermissionMode   := StrToInt64(AStrings[5]);
      FRetryPwd              := AStrings[6];
      FStatusRefreshInterval := StrToInt(AStrings[7]);
      FExamTime              := StrToInt(AStrings[8]);
      FTypeTime              := StrToInt(AStrings[9]);
      if (AStrings.Count >= 10) and (FModules = nil) then
         FModules := TStringList.Create;
      for i       := 10 to AStrings.Count - 1 do
      begin
         FModules.Add(AStrings[i]);
      end;
   end;

procedure TBaseConfig.ModifyCustomConfig(AInterval: integer; AexamPath: string; aLoginPermissionModel: integer);
   begin
      FStatusRefreshInterval := AInterval;
      FExamPath              := AexamPath;
      FLoginPermissionMode   := aLoginPermissionModel;
   end;

end.
