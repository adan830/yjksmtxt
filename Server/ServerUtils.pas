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
      FExamPath             : string; // client exam path
      FServerDataPath       : string;
      FDataBakFolder        : string;
      FPhotoFolder          : string;

      FLoginPermissionModel: Integer;
      FRetryPwd      : string;
      FContPwd       : string;
      FAddTimePwd    : string;
      // FSchoolCode           : string;
      procedure setter(const Value: string);
   public
      property StatusRefreshInterval: Integer read FStatusRefreshInterval write FStatusRefreshInterval;
      property ExamPath             : string read FExamPath write FExamPath;
      // property SchoolCode           : string read FSchoolCode write FSchoolCode;
      property ServerDataPath: string read FServerDataPath write FServerDataPath;
      property DataBakFolder : string read FDataBakFolder write FDataBakFolder;
      property PhotoFolder   : string read FPhotoFolder write FPhotoFolder;

      property LoginPermissionModel: Integer read FLoginPermissionModel write FLoginPermissionModel;
      property RetryPwd      : string read FRetryPwd write FRetryPwd;
      property ContPwd       : string read FContPwd write FContPwd;
      property AddTimePwd    : string read FAddTimePwd write FAddTimePwd;

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
   Windows, SysUtils, iniFiles, ServerGlobal, commons;

procedure TServerCustomConfig.CreateExaminationRoomBakFolder(APath: string);
   var
      s          : array [0 .. 127] of char;
      i          : DWORD;
      folderName : string;
      examTimeStr: string;
   begin
      i := 128;
      if GetComputerName(@s, i) then
         folderName := s;
      DateTimeToString(examTimeStr, 'yyyymmddhhnn', Now);
      folderName := IncludeTrailingPathDelimiter(APath) + s + '_' + examTimeStr;
      if not directoryexists(folderName) then
      begin
         createdir(folderName);
         FDataBakFolder := folderName;
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
            if ConfigFile.ValueExists('Config', 'StatusRefreshInterval') then
               StatusRefreshInterval := ConfigFile.ReadInteger('Config', 'StatusRefreshInterval', ABaseConfig.StatusRefreshInterval);
            ExamPath                 := ConfigFile.ReadString('Config', 'ClientPath', ABaseConfig.ExamPath);
            // SchoolCode := ConfigFile.ReadString('Config', 'SchoolCode', '666');
            ServerDataPath := ConfigFile.ReadString('Config', 'ServerDataPath', ExcludeTrailingBackslash(AConfigFilePath));
            // FDataBakFolder := ConfigFile.ReadString('Config', 'DataBakFolder', ExcludeTrailingBackslash(AConfigFilePath));

            LoginPermissionModel := ConfigFile.ReadInteger('Config', 'ExamRetryModel', 0); // 0:Password model
            if LoginPermissionModel = 0 then
            begin
               RetryPwd   := DecryptStr(ConfigFile.ReadString('Config', 'RetryPwd', ABaseConfig.RetryPwd));
               ContPwd    := DecryptStr(ConfigFile.ReadString('Config', 'ClientPathContPwd', ABaseConfig.RetryPwd));
               AddTimePwd := DecryptStr(ConfigFile.ReadString('Config', 'ClientPathAddTimePwd', ABaseConfig.RetryPwd));
            end;
         finally
            ConfigFile.Free;
         end;
      end
      else
      begin
         StatusRefreshInterval := ABaseConfig.StatusRefreshInterval;
         // SchoolCode := '666';
         ExamPath       := ABaseConfig.ExamPath;
         ServerDataPath := ExcludeTrailingPathDelimiter(AConfigFilePath);

         LoginPermissionModel := 0; // 0:Password model
         RetryPwd       := ABaseConfig.RetryPwd;
         ContPwd        := ABaseConfig.RetryPwd;
         AddTimePwd     := ABaseConfig.RetryPwd;

         // FDataBakFolder := ExcludeTrailingPathDelimiter(AConfigFilePath);
      end;

      FPhotoFolder := IncludeTrailingPathDelimiter(ServerDataPath) + 'ExamineePhoto';
      if not directoryexists(FPhotoFolder) then
         createdir(FPhotoFolder);
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
         // ConfigFile.WriteString('Config', 'SchoolCode', SchoolCode);
         ConfigFile.WriteString('Config', 'ServerDataPath', ServerDataPath);
         // ConfigFile.WriteString('Config', 'DataBakFolder', DataBakFolder);
         // ConfigFile.WriteString('Config', 'PhotoFolder', DataBakFolder);
         if (StatusRefreshInterval > 1) and (StatusRefreshInterval <> 3) then
            ConfigFile.WriteInteger('Config', 'StatusRefreshInterval', StatusRefreshInterval);

         ConfigFile.WriteInteger('Config', 'ExamRetryModel', LoginPermissionModel); // 0:Password model
         if LoginPermissionModel = 0 then
         begin
            ConfigFile.WriteString('Config', 'RetryPwd', EncryptStr(RetryPwd));
            ConfigFile.WriteString('Config', 'ClientPathContPwd', EncryptStr(ContPwd));
            ConfigFile.WriteString('Config', 'ClientPathAddTimePwd', EncryptStr(AddTimePwd));
         end;
      finally
         ConfigFile.Free;
      end;
   end;

procedure TServerCustomConfig.setter(const Value: string);
   begin
      FContPwd := Value;
   end;

end.
