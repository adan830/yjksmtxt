unit ServerGlobal;

interface

uses
   ServerUtils, StkRecordInfo, uGrade, uDmServer, Generics.Collections, logger;

const
   CMDCUSTOMCONFIGFILENAME = 'ServerConfig.Ini';

type
//TO-DO:端口被占用，服务打不开
   TExamServerGlobal = class
   strict private
   class var
      FAppPath: string;
      FServerCustomConfig: TServerCustomConfig;
      FOperateModules: TModules;
      FDataBAKFolder: String;
      // FExamServer : TExamServer;
      FStkRecordInfo: TStkRecordInfo;
      FDmServer: TDmServer;
   public
      class procedure CreateClassObject;
      class procedure DestroyClassObject;
      class procedure SetupGlobalVariables();
      class procedure SetupGlobalOperateModules();
   public
   class var
      Inst: TExamServerGlobal;
      logger: TLogger;
      class property GlobalApplicationPath: string read FAppPath;
      class property ServerCustomConfig: TServerCustomConfig read FServerCustomConfig write FServerCustomConfig;
      class property GlobalOperateModules: TModules read FOperateModules;
      class property GlobalDataBAKFolder: String read FDataBAKFolder write FDataBAKFolder;
      // class property GlobalExamServer : TExamServer read FExamServer;
      class property GlobalStkRecordInfo: TStkRecordInfo read FStkRecordInfo;
      class property GlobalDmServer: TDmServer read FDmServer;
   end;

implementation

uses
   SysUtils, Forms, Windows, BaseConfig;

class procedure TExamServerGlobal.CreateClassObject;
   var
      configfile: string;
   begin
      // logger := TLogger.create();
      // logger.Enabled := true;
      try
         FDmServer := TDmServer.create(nil);
         FStkRecordInfo := TStkRecordInfo.CreateStkRecordInfo;
         configfile := ExtractFilePath(Application.ExeName);
         FServerCustomConfig := TServerCustomConfig.create;
         FServerCustomConfig.SetupCustomConfig(configfile, FStkRecordInfo.BaseConfig);
         FStkRecordInfo.BaseConfig.ModifyCustomConfig(FServerCustomConfig.StatusRefreshInterval, FServerCustomConfig.ExamPath);
         SetupGlobalOperateModules;
      except
         on E: Exception do
         begin
            logger.WriteLog(E.Message);
         end;
      end;
   end;

class procedure TExamServerGlobal.DestroyClassObject;
   var
      i: Integer;
      moduleinfo: TModuleInfo;
   begin
      // for i:= FoperateModules.count - 1 downto 0 do  begin
      // moduleinfo:=FOperateModules[i];
      // FreeLibrary( moduleinfo.DllHandle);
      // moduleinfo.Free;
      // FoperateModules.Delete(i);
      // end;
      for i := 0 to high(FOperateModules) do
      begin
         moduleinfo := FOperateModules[i];
         FreeLibrary(moduleinfo.DllHandle);
         moduleinfo.Free;
      end;
      FOperateModules := nil;
      // FOperateModules.Free;// := nil;
      FStkRecordInfo.Free;
      FDmServer.Free;
      FServerCustomConfig.Free;
      // logger.Free;
      Inst := nil;
      inherited;
   end;

class procedure TExamServerGlobal.SetupGlobalOperateModules();
   var
      mc: Integer;
      i: Integer;
      // moduleinfo :TModuleInfo;
   begin
      // FOperateModules := TList<TModuleInfo>.Create;
      mc := FStkRecordInfo.BaseConfig.Modules.Count;
      SetLength(FOperateModules, mc);

      for i := 0 to mc - 1 do
      begin
         // moduleinfo :=  TModuleInfo.Create();
         // FOperateModules.Add(moduleinfo );
         // moduleinfo.FillModuleInfo(FStkRecordInfo.BaseConfig.Modules[i]);
         FOperateModules[i] := TModuleInfo.create();
         FOperateModules[i].FillModuleInfo(FStkRecordInfo.BaseConfig.Modules[i]);
         // FillModuleInfo(FOperateModules[i],FStkRecordInfo.BaseConfig.Modules[i]);
      end;
   end;

class procedure TExamServerGlobal.SetupGlobalVariables();
   begin
      FAppPath := ExtractFilePath(Application.ExeName);
      FServerCustomConfig := TServerCustomConfig.create;
      FServerCustomConfig.SetupCustomConfig(FAppPath, FStkRecordInfo.BaseConfig);
   end;

initialization

TExamServerGlobal.logger := TLogger.create();
TExamServerGlobal.logger.Enabled := true;
//Application.OnException := FExceptionHandle.HandleException;

finalization
TExamServerGlobal.logger.Free;

end.
