unit ServerUtils;

interface

uses
  Messages,NetGlobal,BaseConfig;

  type
   /// client list change message structor
   TCLMChange = record
    Msg: Cardinal;
    Item: PExaminee;
    Unused: Integer;
    Result: Longint;
  end;
  //ø…∂®÷∆≈‰÷√
  TServerCustomConfig =class
    private
      FStatusRefreshInterval:integer;
      FExamPath:string;
      FSchoolCode:string;
      FServerDataPath:string;
      FDataBakFolder :string;
    public
      property StatusRefreshInterval:integer read FStatusRefreshInterval write FStatusRefreshInterval;
      property ExamPath:string read FExamPath write FExamPath;
      property SchoolCode:string read FSchoolCode write FSchoolCode;
      property ServerDataPath:string read FServerDataPath write FServerDataPath;
      property DataBakFolder :string read FDataBakFolder write FDataBakFolder;
      procedure SetupCustomConfig(AConfigFilePath:string;ABaseConfig:TBaseConfig);
      procedure SaveCustomConfig(AConfigFile: string);
      procedure CreateExaminationRoomBakFolder(APath:string);
   end;

   /// client list change message
   const
      CLM_Changed= WM_APP+0;
//      CLM_Added    = WM_APP+1;
//      CLM_Deleted = WM_APP+2;
//      CLM_AllChanged= WM_APP+3;



implementation

uses
  Windows, SysUtils, iniFiles, ServerGlobal;

procedure TServerCustomConfig.CreateExaminationRoomBakFolder(APath:string);
var
  s:array [0..127] of char;
  i:DWORD;
  folderName:string;
  SysTime: TsystemTime;
begin
  I:=128;
  if GetComputerName(@s,i) then
      folderName := s;
  GetLocalTime(SysTime);
  folderName:=folderName+'_'+format('%.4d%.2d%.2d_%.2d%.2d',[SysTime.wYear,SysTime.wMonth,SysTime.wDay,SysTime.wHour,SysTime.wMinute]);
  if not directoryexists(APath+'\'+folderName) then
  begin
     createdir(APath+'\'+folderName);
     FDataBakFolder:= APath+'\'+folderName;
  end;

end;

procedure TServerCustomConfig.SetupCustomConfig(AConfigFilePath:string;ABaseConfig:TBaseConfig);
var
   ConfigFile:TIniFile;
begin
   if fileexists(AConfigFilePath+CMDCUSTOMCONFIGFILENAME) then
   begin
      ConfigFile := TIniFile.Create(AConfigFilePath+CMDCUSTOMCONFIGFILENAME);
      try
         StatusRefreshInterval:=ConfigFile.ReadInteger('Config','StatusRefreshInterval',abaseconfig.StatusRefreshInterval);
         ExamPath :=ConfigFile.ReadString('Config','ClientPath',abaseconfig.ExamPath);
         SchoolCode := ConfigFile.ReadString('Config','SchoolCode','666');
         ServerDataPath := ConfigFile.ReadString('Config','ServerDataPath',ExcludeTrailingBackslash( AConfigFilePath));
         FDataBakFolder := ConfigFile.ReadString('Config','DataBakFolder',ExcludeTrailingBackslash( AConfigFilePath));
      finally
         ConfigFile.Free;
      end;
   end else begin
      StatusRefreshInterval:=abaseconfig.StatusRefreshInterval;
      schoolCode := '666';
      ExamPath :=abaseconfig.ExamPath;
      ServerDataPath := ExcludeTrailingBackslash( AConfigFilePath);
      FDataBakFolder := ExcludeTrailingBackslash( AConfigFilePath);
   end;
end;

procedure TServerCustomConfig.SaveCustomConfig(AConfigFile:string);
var
   ConfigFile:TIniFile;
begin

   ConfigFile:= TIniFile.Create( AConfigFile+'ServerConfig.ini');
   try
      ConfigFile.WriteInteger('Config','StatusRefreshInterval',StatusRefreshInterval);
      ConfigFile.WriteString('Config','ClientPath',ExamPath);
      ConfigFile.WriteString('Config','SchoolCode',SchoolCode);
      ConfigFile.WriteString('Config','ServerDataPath',ServerDataPath);
      ConfigFile.WriteString('Config','DataBakFolder',DataBakFolder);
   finally
      ConfigFile.Free;
   end;
end;
end.
