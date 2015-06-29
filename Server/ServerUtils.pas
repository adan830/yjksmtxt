unit ServerUtils;

interface

uses
   Messages, NetGlobal, BaseConfig;

type
   /// client list change message structor
   TCLMChange = record
      Msg: Cardinal;
      Item: PExaminee;
      Unused: Integer;
      Result: Longint;
   end;

   // ¿É¶¨ÖÆÅäÖÃ
   TServerCustomConfig = class
   private
      FStatusRefreshInterval: Integer;
      FExamPath: string;
      FSchoolCode: string;
      FServerDataPath: string;
      FDataBakFolder: string;
      FPhotoFolder: string;
   public
      property StatusRefreshInterval: Integer read FStatusRefreshInterval write FStatusRefreshInterval;
      property ExamPath: string read FExamPath write FExamPath;
      property SchoolCode: string read FSchoolCode write FSchoolCode;
      property ServerDataPath: string read FServerDataPath write FServerDataPath;
      property DataBakFolder: string read FDataBakFolder write FDataBakFolder;
      property PhotoFolder: string read FPhotoFolder write FPhotoFolder;
      procedure SetupCustomConfig(AConfigFilePath: string; ABaseConfig: TBaseConfig);
      procedure SaveCustomConfig(AConfigFile: string);
      procedure CreateExaminationRoomBakFolder(APath: string);
   end;

   /// client list change message
const
   CLM_Changed = WM_APP + 0;
   // CLM_Added    = WM_APP+1;
   // CLM_Deleted = WM_APP+2;
   // CLM_AllChanged= WM_APP+3;

implementation

uses
   Windows, SysUtils, iniFiles, ServerGlobal;

procedure TServerCustomConfig.CreateExaminationRoomBakFolder(APath: string);
   var
      s: array [0 .. 127] of char;
      i: DWORD;
      folderName: string;
      SysTime: TsystemTime;
   begin
      i := 128;
      if GetComputerName(@s, i) then
         folderName := s;
      GetLocalTime(SysTime);
      folderName := folderName + '_' + format('%.4d%.2d%.2d_%.2d%.2d', [SysTime.wYear, SysTime.wMonth, SysTime.wDay, SysTime.wHour, SysTime.wMinute]);
      if not directoryexists(APath + '\' + folderName) then
      begin
         createdir(APath + '\' + folderName);
         FDataBakFolder := APath + '\' + folderName;
      end;

   end;

procedure TServerCustomConfig.SetupCustomConfig(AConfigFilePath: string; ABaseConfig: TBaseConfig);
   var
      ConfigFile: TIniFile;
   begin
      if fileexists(AConfigFilePath + CMDCUSTOMCONFIGFILENAME) then
      begin
         ConfigFile := TIniFile.Create(AConfigFilePath + CMDCUSTOMCONFIGFILENAME);
         try
            if ConfigFile.ValueExists('Config','StatusRefreshInterval') then
               StatusRefreshInterval := ConfigFile.ReadInteger('Config', 'StatusRefreshInterval', ABaseConfig.StatusRefreshInterval);
            ExamPath := ConfigFile.ReadString('Config', 'ClientPath', ABaseConfig.ExamPath);
            SchoolCode := ConfigFile.ReadString('Config', 'SchoolCode', '666');
            ServerDataPath := ConfigFile.ReadString('Config', 'ServerDataPath', ExcludeTrailingBackslash(AConfigFilePath));
            FDataBakFolder := ConfigFile.ReadString('Config', 'DataBakFolder', ExcludeTrailingBackslash(AConfigFilePath));
            FPhotoFolder:=  ConfigFile.ReadString('Config', 'PhotoFolder', ExcludeTrailingBackslash(AConfigFilePath));
         finally
            ConfigFile.Free;
         end;
      end
      else
      begin
         StatusRefreshInterval := ABaseConfig.StatusRefreshInterval;
         SchoolCode := '666';
         ExamPath := ABaseConfig.ExamPath;
         ServerDataPath := ExcludeTrailingBackslash(AConfigFilePath);
         FDataBakFolder := ExcludeTrailingBackslash(AConfigFilePath);
         FPhotoFolder := ExcludeTrailingBackslash(AConfigFilePath);
      end;
   end;
 //
 //
 procedure TServerCustomConfig.SaveCustomConfig(AConfigFile: string);
   var
      ConfigFile: TIniFile;
   begin

      ConfigFile := TIniFile.Create(AConfigFile + 'ServerConfig.ini');
      try
         ConfigFile.WriteString('Config', 'ClientPath', ExamPath);
         ConfigFile.WriteString('Config', 'SchoolCode', SchoolCode);
         ConfigFile.WriteString('Config', 'ServerDataPath', ServerDataPath);
         ConfigFile.WriteString('Config', 'DataBakFolder', DataBakFolder);
         ConfigFile.WriteString('Config', 'PhotoFolder', DataBakFolder);
         if (StatusRefreshInterval>1) and (StatusRefreshInterval<>3) then
            ConfigFile.WriteInteger('Config', 'StatusRefreshInterval', StatusRefreshInterval);
      finally
         ConfigFile.Free;
      end;
   end;

end.
