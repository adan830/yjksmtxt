unit ServerUtils;

interface

uses
   Messages, NetGlobal, BaseConfig;

type
   /// client list change message structor
   TCLMChange = record
      Msg : Cardinal;
      Item : PExaminee;
      Unused : Integer;
      Result : Longint;
   end;

   // ¿É¶¨ÖÆÅäÖÃ
   TServerCustomConfig = class
   private
      FStatusRefreshInterval : Integer;
      FExamPath              : string; // client exam path
      FServerDataPath        : string;
      FDataBakFolder         : string;
      FPhotoFolder           : string;

      FLoginPermissionModel : Integer;
      FRetryPwd             : string;
      FContPwd              : string;
      FAddTimePwd           : string;
      FAdminPwd             : string;
      // FSchoolCode           : string;
      procedure setter(const Value : string);
   public
      property StatusRefreshInterval : Integer read FStatusRefreshInterval write FStatusRefreshInterval;
      property ExamPath              : string read FExamPath write FExamPath;
      // property SchoolCode           : string read FSchoolCode write FSchoolCode;
      property ServerDataPath : string read FServerDataPath write FServerDataPath;
      property DataBakFolder  : string read FDataBakFolder write FDataBakFolder;
      property PhotoFolder    : string read FPhotoFolder write FPhotoFolder;

      property LoginPermissionModel : Integer read FLoginPermissionModel write FLoginPermissionModel;
      property RetryPwd             : string read FRetryPwd write FRetryPwd;
      property ContPwd              : string read FContPwd write FContPwd;
      property AddTimePwd           : string read FAddTimePwd write FAddTimePwd;
      property AdminPwd             : string read FAdminPwd write FAdminPwd;

      procedure SetupCustomConfig(AConfigFilePath : string; ABaseConfig : TBaseConfig);
      procedure SaveCustomConfig(AConfigFile : string);
      procedure CreateExaminationRoomBakFolder(APath : string);
   end;

   /// client list change message
const
   CLM_Changed = WM_APP + 0;
   // CLM_Added    = WM_APP+1;
   // CLM_Deleted = WM_APP+2;
   // CLM_AllChanged= WM_APP+3;
   CONFIGNAME_SERVERDATAPATH        = 'ServerDataPath';
   CONFIGNAME_CLIENTEXAMPATH        = 'ClientExamPath';
   CONFIGNAME_STATUSREFRESHINTERVAL = 'StatusRefreshInterval';
   CONFIGNAME_LOGINPERMISSIONMODE   = 'LoginPermissionMode';
   CONFIGNAME_RETRYPWD              = 'RetryPwd';
   CONFIGNAME_CONTINUEPWD           = 'ContinuePwd';
   CONFIGNAME_ADDTIMEPWD            = 'AddTimePwd';
   CONFIGNAME_ADMINPWD              = 'AdminPwd';

implementation

uses
   Windows, SysUtils, iniFiles, ServerGlobal, commons, system.Hash;

procedure TServerCustomConfig.CreateExaminationRoomBakFolder(APath : string);
   var
      s           : array [0 .. 127] of char;
      i           : DWORD;
      folderName  : string;
      examTimeStr : string;
   begin
      // i := 128;
      // if GetComputerName(@s, i) then
      // folderName := s;
      // DateTimeToString(examTimeStr, 'yyyymmddhhnn', Now);
      // folderName := IncludeTrailingPathDelimiter(APath) + s + '_' + examTimeStr;
      folderName := IncludeTrailingPathDelimiter(APath) + 'DataBak';
      if not directoryexists(folderName) then
      begin
         createdir(folderName);
         FDataBakFolder := folderName;
      end;
   end;

procedure TServerCustomConfig.SetupCustomConfig(AConfigFilePath : string; ABaseConfig : TBaseConfig);
   var
      ConfigFile : TIniFile;
   begin
      if fileexists(AConfigFilePath + CMDCUSTOMCONFIGFILENAME) then
      begin
         ConfigFile := TIniFile.Create(AConfigFilePath + CMDCUSTOMCONFIGFILENAME);
         try
            if ConfigFile.ValueExists('Config', CONFIGNAME_STATUSREFRESHINTERVAL) then
               StatusRefreshInterval := ConfigFile.ReadInteger('Config', CONFIGNAME_STATUSREFRESHINTERVAL, ABaseConfig.StatusRefreshInterval)
            else
               StatusRefreshInterval := ABaseConfig.StatusRefreshInterval;

            if ConfigFile.ValueExists('Config', CONFIGNAME_CLIENTEXAMPATH) then
               ExamPath := ConfigFile.ReadString('Config', CONFIGNAME_CLIENTEXAMPATH, ABaseConfig.ExamPath)
            else
               ExamPath := ABaseConfig.ExamPath;

            if ConfigFile.ValueExists('Config', CONFIGNAME_SERVERDATAPATH) then
               ServerDataPath := ConfigFile.ReadString('Config', CONFIGNAME_SERVERDATAPATH, ExcludeTrailingBackslash(AConfigFilePath))
            else
               ServerDataPath := ExcludeTrailingBackslash(AConfigFilePath);

            if ConfigFile.ValueExists('Config', CONFIGNAME_LOGINPERMISSIONMODE) then
               LoginPermissionModel := ConfigFile.ReadInteger('Config', CONFIGNAME_LOGINPERMISSIONMODE, ABaseConfig.LoginPermissionMode) // 0:Password model
            else
               LoginPermissionModel := ABaseConfig.LoginPermissionMode;

            if LoginPermissionModel = 0 then
            begin
               RetryPwd   := ConfigFile.ReadString('Config', CONFIGNAME_RETRYPWD, THashMD5.GetHashString(ABaseConfig.RetryPwd));
               ContPwd    := ConfigFile.ReadString('Config', CONFIGNAME_CONTINUEPWD, THashMD5.GetHashString(ABaseConfig.RetryPwd));
               AddTimePwd := ConfigFile.ReadString('Config', CONFIGNAME_ADDTIMEPWD, THashMD5.GetHashString(ABaseConfig.RetryPwd));
            end;
            AdminPwd := ConfigFile.ReadString('Config', CONFIGNAME_ADMINpWD, THashMD5.GetHashString(ABaseConfig.RetryPwd));
            // SchoolCode := ConfigFile.ReadString('Config', 'SchoolCode', '666');
         finally
            ConfigFile.Free;
         end;
      end
      else
      begin
         StatusRefreshInterval := ABaseConfig.StatusRefreshInterval;

         ExamPath             := ABaseConfig.ExamPath;
         ServerDataPath       := ExcludeTrailingPathDelimiter(AConfigFilePath);
         LoginPermissionModel := ABaseConfig.LoginPermissionMode;
         RetryPwd             := THashMD5.GetHashString(ABaseConfig.RetryPwd);
         ContPwd              := THashMD5.GetHashString(ABaseConfig.RetryPwd);
         AddTimePwd           := THashMD5.GetHashString(ABaseConfig.RetryPwd);
         AdminPwd             := THashMD5.GetHashString(ABaseConfig.RetryPwd);
         // SchoolCode := '666';
      end;

      DataBakFolder := IncludeTrailingPathDelimiter(ServerDataPath) + 'DataBak';
      FPhotoFolder  := IncludeTrailingPathDelimiter(ServerDataPath) + 'ExamineePhoto';
      if not directoryexists(DataBakFolder) then
         createdir(DataBakFolder);
      if not directoryexists(FPhotoFolder) then
         createdir(FPhotoFolder);
   end;

//
//
procedure TServerCustomConfig.SaveCustomConfig(AConfigFile : string);
   var
      ConfigFile : TIniFile;
   begin

      ConfigFile := TIniFile.Create(AConfigFile + CMDCUSTOMCONFIGFILENAME);
      try
         ConfigFile.WriteString('Config', CONFIGNAME_CLIENTEXAMPATH, ExamPath);
         // ConfigFile.WriteString('Config', 'SchoolCode', SchoolCode);
         ConfigFile.WriteString('Config', CONFIGNAME_SERVERDATAPATH, ServerDataPath);
         // ConfigFile.WriteString('Config', 'DataBakFolder', DataBakFolder);
         // ConfigFile.WriteString('Config', 'PhotoFolder', DataBakFolder);
         if (StatusRefreshInterval > 1) and (StatusRefreshInterval <> 3) then
            ConfigFile.WriteInteger('Config', CONFIGNAME_STATUSREFRESHINTERVAL, StatusRefreshInterval);

         ConfigFile.WriteInteger('Config', CONFIGNAME_LOGINPERMISSIONMODE, LoginPermissionModel); // 0:Password model
         if LoginPermissionModel = 0 then
         begin
            ConfigFile.WriteString('Config', CONFIGNAME_RETRYPWD, RetryPwd);
            ConfigFile.WriteString('Config', CONFIGNAME_CONTINUEPWD, ContPwd);
            ConfigFile.WriteString('Config', CONFIGNAME_ADDTIMEPWD, AddTimePwd);
         end;
         ConfigFile.WriteString('Config', CONFIGNAME_ADMINPWD, AdminPwd);
      finally
         ConfigFile.Free;
      end;
   end;

procedure TServerCustomConfig.setter(const Value : string);
   begin
      FContPwd := Value;
   end;

end.
