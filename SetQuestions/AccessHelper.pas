unit AccessHelper;

interface

uses
   access2010, adodb;

type
   TAccessHelper = class
      public
         class function CreateMdb(filename : string; pwd : string = '') : cardinal;
         class function CreateSysQuestionBase(mdbFile, pwd : string) : boolean;
         class function CreateClientBase(mdbFile, pwd : string) : boolean;
         class function EncryptionBase(mdbFile, pwd: string): boolean;

         class function GetMdbApp(mdbFile, pwd : string) : TAccessApplication;
         class procedure CloseMdbApp(app : TAccessApplication; acquit : AcQuitOption);

         class function AddTrustedLocation(path : string) : boolean;
         class function ExceuteMacro(app : TAccessApplication; strMacro : string) : boolean;
         class function SetBypassProperty(app : TAccessApplication) : boolean;
         class function AddAutoQuitForm(app : TAccessApplication) : boolean;
         class function AddAutoExecMacro(app : TAccessApplication) : boolean;

         class function GetMdbConnection(mdbFile, pwd : string) : TADOConnection;
         class function AddTable(dbConn : TADOConnection; tableSql : string) : integer;
         class function CreateTQTable(dbConn : TADOConnection) : integer;
         class function CreateExamineeTable(dbConn : TADOConnection) : integer;
         class function CreateAppendFileTable(dbConn : TADOConnection) : integer;
         class function CreateSysConfigTable(dbConn : TADOConnection) : integer;
         class function CreateSelectUseTable(dbConn : TADOConnection) : integer;
   end;

implementation

uses comobj, system.IOUtils, system.SysUtils, system.Classes, datafieldconst, vbide2010, dao2010, office2010,
   system.Win.Registry,ExamGlobal;

class function TAccessHelper.CreateMdb(filename : string; pwd : string = '') : cardinal;
   var
      Source, str_sql : string;
      CreateDB        : Variant;
   begin
      result := 0;
      // 判断数据库是否已经存在
      if Tfile.Exists(filename) then
      begin
         result := 1; // error:file already exists;
         exit;
      end;

      // 创建数据库
      Source := 'Provider=Microsoft.Jet.OLEDB.4.0;' + 'Data Source=' + filename + ';'; // Jet OLEDB:Database Password="abc";';
      if pwd <> string.empty then
         Source := Source + 'Jet OLEDB:Database Password="' + trim(pwd) + '";';
//          Source := 'Provider=Microsoft.ACe.OLEDB.12.0;' + 'Data Source=' + filename + ';'; // Jet OLEDB:Database Password="abc";';
//      if pwd <> string.empty then
//         Source := Source + 'Jet oledb:Database Password="' + trim(pwd) + '";';
      try
         CreateDB := CreateOleObject('ADOX.Catalog');
         CreateDB.Create(Source);
      except on E:Exception do
      begin
         result := 2; // error: create mdb deny;
         raise e;
      end;

      end;
   end;

class function TAccessHelper.CreateTQTable(dbConn : TADOConnection) : integer;
   Var
      sb : TStringBuilder;
   begin
      sb := TStringBuilder.Create;
      try
         sb.Append('Create table 试题 (');
         sb.Append(DFNTQ_ST_NO + ' VarChar(6) NOT NULL,');
         sb.Append(DFNTQ_CONTENT + ' image,');
         sb.Append(DFNTQ_ENVIRONMENT + ' image,');
         sb.Append(DFNTQ_STANSWER + ' image,');
         sb.Append(DFNTQ_KSDA + ' VarChar(4),');
         sb.Append(DFNTQ_COMMENT + ' image,');

          sb.Append(DFNTQ_POINTID + ' VarChar(50),');
          sb.Append(DFNTQ_DIFFICULTY + ' SmallInt,');
          sb.Append(DFNTQ_TOTALRIGHT + ' int,');
          sb.Append(DFNTQ_TOTALUSED + ' int,');
          sb.Append(DFNTQ_REDACTTIME + ' DateTime,');
          sb.Append(DFNTQ_REDACTOR + ' VarChar(8),');
          sb.Append(DFNTQ_ISMODIFIED + ' bit,');
         sb.Append('CONSTRAINT pk_StNO PRIMARY KEY (' + DFNTQ_ST_NO + '))');

         dbConn.Execute(sb.ToString, result);
      finally
         sb.Free;
      end;

   end;

class function TAccessHelper.ExceuteMacro(app : TAccessApplication; strMacro : string) : boolean;
   var
      V : VBComponent;
   begin
      app.AutomationSecurity := msoAutomationSecurityForceDisable;
      V                      := app.VBE.ActiveVBProject.VBComponents.Add(1);
      V.CodeModule.AddFromString(strMacro);
      app.DoCmd.Save(acModule, '模块1');
      app.Run('SetBypassProperty');
   end;

class function TAccessHelper.AddAutoExecMacro(app : TAccessApplication) : boolean;
   var
      mm : Module;
   begin

      mm := app.Modules[0];
      mm.InsertText('public Sub AutoExec'#13#10 + 'Application.Quit'#13#10 + 'End Sub'#13#10);
   end;

class function TAccessHelper.AddAutoQuitForm(app : TAccessApplication) : boolean;
   var
      form : accessForm;
      V    : VBComponent;
      bb   : dao2010.Property_;
      nn   : string;
      vv   : Variant;
      I    : integer;
   begin
      form := app.CreateForm();
      form.Module.InsertText('Private Sub Form_Open(Cancel As Integer)'#13#10 + 'Application.Quit'#13#10 + 'End Sub'#13#10);
      form.RecordSource := 'sysconfig';
      // app.DoCmd.OpenForm('窗体1', acNormal, varNull, varNull, acFormPropertySettings, acWindowNormal, varNull);
      bb := app.CurrentDb.CreateProperty('StartupForm', dbtext, '窗体1', 0 { *A_add* } );
      app.CurrentDb.Properties.Append(bb);
      app.DoCmd.Save(acform, '窗体1');
      // app.CurrentDb.Properties['StartupForm']:='Form1';
      // vv:=app.GetOption('StartupForm');
      // for I := 0 to app.CurrentDb.Properties.Count - 1 do
      // begin
      // //bb :=app.CurrentDb.CreateProperty('StartupForm', dbtext, 'Form1',);//bb := app.CurrentDb.Properties[I]; // .Item['StartUpForm']; //[i];//
      // try
      // nn := bb.name;
      // vv := bb.value;
      // except
      // on E : Exception do
      // end;
      // end;
   end;

class function TAccessHelper.SetBypassProperty(app : TAccessApplication) : boolean;
   var
      sb : TStringBuilder;
   begin
      sb := TStringBuilder.Create();
      try
         sb.Append('public Sub SetBypassProperty()'+EOL);
         sb.Append('Const DB_Boolean As Long = 1'+EOL);
         sb.Append('ChangeProperty "AllowBypassKey", DB_Boolean, False'+EOL);
         sb.Append('End Sub'+EOL);
         sb.Append('Function ChangeProperty(strPropName As String, varPropType As Variant, varPropValue As Variant) As Integer'+EOL);
         sb.Append('Dim dbs As Object, prp As Variant'+EOL);
         sb.Append('Const conPropNotFoundError = 3270'+EOL);
         sb.Append('Set dbs = CurrentDb'+EOL);
         sb.Append('On Error GoTo Change_Err'+EOL);
         sb.Append('dbs.Properties(strPropName) = varPropValue'+EOL);
         sb.Append('ChangeProperty = True'+EOL);
         sb.Append('Change_Bye:'+EOL);
         sb.Append('Exit Function'+EOL);
         sb.Append('Change_Err:'+EOL);
         sb.Append('If Err = conPropNotFoundError Then    '''' Property not found.'+EOL);
         sb.Append('Set prp = dbs.CreateProperty(strPropName, _'+EOL);
         sb.Append('varPropType, varPropValue)'+EOL);
         sb.Append('dbs.Properties.Append prp'+EOL);
         sb.Append('Resume Next'+EOL);
         sb.Append('Else'+EOL);
         sb.Append(''' Unknown error.'+EOL);
         sb.Append('ChangeProperty = False'+EOL);
         sb.Append('Resume Change_Bye'+EOL);
         sb.Append('End If'+EOL);
         sb.Append('End Function'+EOL);
         result := TAccessHelper.ExceuteMacro(app, sb.ToString);
      finally
         sb.Free;
      end;

   end;

class function TAccessHelper.CreateExamineeTable(dbConn : TADOConnection) : integer;
   Var
      sb : TStringBuilder;
   begin
      sb := TStringBuilder.Create;
      try
         sb.Append('Create table 考生信息 (');
         sb.Append(DFNEI_EXAMINEEID + ' VarChar(24) NOT NULL,');
         sb.Append(DFNEI_EXAMINEENAME + ' VarChar(20),');
         sb.Append(DFNEI_IP + ' VarChar(15),');
         sb.Append(DFNEI_PORT + ' int,');
         sb.Append(DFNEI_STATUS + ' VarChar(20),');
         sb.Append(DFNEI_REMAINTIME + ' VarChar(20),');
         sb.Append(DFNEI_TIMESTAMP + ' VarChar(24),');
         sb.Append(DFNEI_SCOREINFO + ' image,');
         // sb.Append(DFNEI_SCORE + ' image,');   // 只用在汇总成绩表中
         sb.Append('CONSTRAINT pk_ExamineeID PRIMARY KEY (' + DFNEI_EXAMINEEID + '))');
         dbConn.Execute(sb.ToString, result);
      finally
         sb.Free;
      end;
   end;

class function TAccessHelper.GetMdbConnection(mdbFile, pwd : string) : TADOConnection;
   Const
      SConnectionString = 'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=%s;' + 'Jet OLEDB:Database Password=%s;';
   begin
      result := TADOConnection.Create(nil);
      try
         result.ConnectionString := format(SConnectionString, [mdbFile, pwd]);
         result.LoginPrompt      := false;
         result.Connected        := true;
      except
         on E : Exception do
         begin
            result.Connected := false;
            FreeAndNil(result);
         end;
      end;
   end;

class function TAccessHelper.AddTable(dbConn : TADOConnection; tableSql : string) : integer;
   begin
      dbConn.Execute(tableSql, result);
   end;

class function TAccessHelper.GetMdbApp(mdbFile, pwd : string) : TAccessApplication;
   begin
      result := TAccessApplication.Create(nil);
      try
         result.Visible := false;
         result.OpenCurrentDatabase(mdbFile, true, pwd);
      except
         on E : Exception do
         begin
            result.Quit(acQuitSaveNone);
            FreeAndNil(result);
         end;
      end;
   end;

class procedure TAccessHelper.CloseMdbApp(app : TAccessApplication; acquit : AcQuitOption);
   begin
      app.Quit(acquit);
      FreeAndNil(app);
   end;

class function TAccessHelper.CreateAppendFileTable(dbConn : TADOConnection) : integer;
   Var
      sb : TStringBuilder;
   begin
      sb := TStringBuilder.Create;
      try
         sb.Append('Create table 附加文件 (');
         sb.Append('[GUID] smallint NOT NULL,');
         sb.Append('FileName VarChar(100),');
         sb.Append('FileStream image,');
         sb.Append('CONSTRAINT pk_appendfileid PRIMARY KEY ( [GUID] ))');

         dbConn.Execute(sb.ToString, result);
      finally
         sb.Free;
      end;
   end;

class function TAccessHelper.CreateClientBase(mdbFile, pwd: string): boolean;
var
      MyClass : TObject;
      conn    : TADOConnection;
   begin
      result := true;
      try
         TAccessHelper.CreateMdb(mdbFile, pwd);
         conn := TAccessHelper.GetMdbConnection(mdbFile, pwd);
         try
            TAccessHelper.CreateTQTable(conn);
            TAccessHelper.CreateExamineeTable(conn);
         finally
            conn.Connected := false;
            FreeAndNil(conn);
         end;
      except
         on E : Exception do
            result := false;
      end;
end;


class function TAccessHelper.CreateSelectUseTable(dbConn : TADOConnection) : integer;
   Var
      sb : TStringBuilder;
   begin
      sb := TStringBuilder.Create;
      try
         sb.Append('Create table [选用] (');
         sb.Append('[名称]' + ' VarChar(50) NOT NULL PRIMARY KEY,');
         sb.Append('[是否选用]' + ' bit,');
         sb.Append('[单项选择题]' + ' text,');
         sb.Append('[多项选择题]' + ' text,');
         sb.Append('[打字题]' + ' text,');
         sb.Append('[Win操作题]' + ' text,');
         sb.Append('[Word操作题]' + ' text,');
         sb.Append('[Excel操作题]' + ' text,');
         sb.Append('[Ppt操作题]' + ' text,');
         sb.Append('[选用信息]' + ' text)');
         // sb.Append('CONSTRAINT pk_ExamineeID PRIMARY KEY ([名称]))');
         dbConn.Execute(sb.ToString, result);
      finally
         sb.Free;
      end;
   end;

class function TAccessHelper.CreateSysConfigTable(dbConn : TADOConnection) : integer;
   Var
      sb : TStringBuilder;
   begin
      sb := TStringBuilder.Create;
      try
         sb.Append('Create table SysConfig (');
         sb.Append('[ID] AUTOINCREMENT primary key,');
         sb.Append('[Config] image,');
         sb.Append('[Strategy] image,');
         sb.Append('[Modules] image)');
         // sb.Append('CONSTRAINT pk_SysconfigID PRIMARY KEY ( [ID] ))');

         dbConn.Execute(sb.ToString, result);
      finally
         sb.Free;
      end;
   end;

class function TAccessHelper.CreateSysQuestionBase(mdbFile, pwd : string) : boolean;
   var
      MyClass : TObject;
      conn    : TADOConnection;
   begin
      result := true;
      try
         TAccessHelper.CreateMdb(mdbFile, pwd);
         conn := TAccessHelper.GetMdbConnection(mdbFile, pwd);
         try
            TAccessHelper.CreateTQTable(conn);
            TAccessHelper.CreateExamineeTable(conn);
            TAccessHelper.CreateAppendFileTable(conn);
            TAccessHelper.CreateSysConfigTable(conn);
            TAccessHelper.CreateSelectUseTable(conn);
         finally
            conn.Connected := false;
            FreeAndNil(conn);
         end;
      except
         on E : Exception do
            result := false;
      end;
   end;

class function TAccessHelper.AddTrustedLocation(path : string) : boolean;
   const
      key = 'Software\Microsoft\Office\14.0\Access\Security\Trusted Locations\Location';
   Var
      reg   : TRegistry;
      index : integer;
   begin
      result := false;
      reg    := TRegistry.Create();
      try
         index := 1;
         while reg.KeyExists(key + IntToStr(index)) do
            index := index + 1;

         if (reg.OpenKey(key + IntToStr(index), true)) then
         begin
            reg.WriteString('Path', IncludeTrailingPathDelimiter(path));
         end;
         reg.CloseKey();
         result := true;
      finally
         reg.Free;
      end;
   end;

   class function TAccessHelper.EncryptionBase(mdbFile, pwd : string) : boolean;
      var
      app : TAccessApplication;
   begin
      app := taccesshelper.GetMdbApp(mdbFile, pwd);
      try
         taccesshelper.AddAutoQuitForm(app);
         taccesshelper.SetBypassProperty(app);
      finally
         taccesshelper.CloseMdbApp(app, acQuitSaveAll);
      end;

   end;

end.
