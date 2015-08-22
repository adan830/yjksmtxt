unit AccessHelper;

interface

uses
   access2010, adodb;

type
   TAccessHelper = class
      private


      public
         class function CreateMdb(filename : string; pwd : string = '') : cardinal;

         class function CreateSysQuestionBase(mdbFile, pwd : string) : boolean;
         class function ExceuteMacro(app : TAccessApplication; strMacro : string) : boolean;
         class function SetBypassProperty(app : TAccessApplication) : boolean;
         class function AddAutoQuitForm(app : TAccessApplication) : boolean;
         class function AddAutoExecMacro(app : TAccessApplication) : boolean;
         class function GetMdbApp(mdbFile, pwd : string) : TAccessApplication;
         class procedure CloseMdbApp(app : TAccessApplication; acquit : AcQuitOption);
         class function AddTrustedLocation(path : string) : boolean;


         class function GetMdbConnection(mdbFile, pwd: string): TADOConnection;
         class function AddTable(dbConn : TADOConnection; tableSql : string) : integer;
         class function CreateTQTable(dbConn : TADOConnection) : integer;
         class function CreateExamineeTable(dbConn : TADOConnection) : integer;
         class function CreateAppendFileTable(dbConn : TADOConnection) : integer;
         class function CreateSysConfigTable(dbConn : TADOConnection) : integer;
   end;

implementation

uses comobj, system.IOUtils, system.SysUtils, system.Classes, datafieldconst, vbide2010, dao2010, office2010,
   system.Win.Registry;

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
      try
         CreateDB := CreateOleObject('ADOX.Catalog');
         CreateDB.Create(Source);
      except
         result := 2; // error: create mdb deny;
      end;
   end;

class function TAccessHelper.CreateTQTable(dbConn:TADOconnection) : integer;
   Var
      sb   : TStringBuilder;
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
         sb.Append('public Sub SetBypassProperty()'#13#10);
         sb.Append('Const DB_Boolean As Long = 1'#13#10);
         sb.Append('ChangeProperty "AllowBypassKey", DB_Boolean, False'#13#10);
         sb.Append('End Sub'#13#10);
         sb.Append('Function ChangeProperty(strPropName As String, varPropType As Variant, varPropValue As Variant) As Integer'#13#10);
         sb.Append('Dim dbs As Object, prp As Variant'#13#10);
         sb.Append('Const conPropNotFoundError = 3270'#13#10);
         sb.Append('Set dbs = CurrentDb'#13#10);
         sb.Append('On Error GoTo Change_Err'#13#10);
         sb.Append('dbs.Properties(strPropName) = varPropValue'#13#10);
         sb.Append('ChangeProperty = True'#13#10);
         sb.Append('Change_Bye:'#13#10);
         sb.Append('Exit Function'#13#10);
         sb.Append('Change_Err:'#13#10);
         sb.Append('If Err = conPropNotFoundError Then    '''' Property not found.'#13#10);
         sb.Append('Set prp = dbs.CreateProperty(strPropName, _'#13#10);
         sb.Append('varPropType, varPropValue)'#13#10);
         sb.Append('dbs.Properties.Append prp'#13#10);
         sb.Append('Resume Next'#13#10);
         sb.Append('Else'#13#10);
         sb.Append(''' Unknown error.'#13#10);
         sb.Append('ChangeProperty = False'#13#10);
         sb.Append('Resume Change_Bye'#13#10);
         sb.Append('End If'#13#10);
         sb.Append('End Function'#13#10);
         result := TAccessHelper.ExceuteMacro(app, sb.ToString);
      finally
         sb.Free;
      end;

   end;

class function TAccessHelper.CreateExamineeTable(dbConn : TADOConnection) : integer;
   Var
      sb   : TStringBuilder;
   begin
      sb := TStringBuilder.Create;
      try
         sb.Append('Create table 考生信息 (');
         sb.Append(DFNEI_EXAMINEEID + ' VarChar(11) NOT NULL,');
         sb.Append(DFNEI_EXAMINEENAME + ' VarChar(8),');
         sb.Append(DFNEI_IP + ' VarChar(15),');
         sb.Append(DFNEI_PORT + ' int,');
         sb.Append(DFNEI_STATUS + ' int,');
         sb.Append(DFNEI_REMAINTIME + ' smallint,');
         sb.Append(DFNEI_TIMESTAMP + ' DateTime,');
         sb.Append(DFNEI_SCOREINFO + ' text,');
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
         result.Connected:=true;
      except
         on E : Exception do
         begin
            result.Connected:=false;
            FreeAndNil(result);
         end;
      end;
   end;
   class function TAccessHelper.AddTable(dbConn : TADOConnection; tableSql : string) : integer;
   begin
      dbconn.Execute(tableSql,result);
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

class function TAccessHelper.CreateAppendFileTable(dbConn:TADOconnection) : integer;
   Var
      sb   : TStringBuilder;
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

class function TAccessHelper.CreateSysConfigTable(dbConn:TADOconnection) : integer;
   Var
      sb   : TStringBuilder;
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
  MyClass: TObject;
  conn:TADOConnection;
   begin
      result := true;
      try
         TAccessHelper.CreateMdb(mdbFile, pwd);
         conn:=TAccessHelper.GetMdbConnection(mdbFile,pwd);
         try
            TAccessHelper.CreateTQTable(conn);
         TAccessHelper.CreateExamineeTable(conn);
         TAccessHelper.CreateAppendFileTable(conn);
         TAccessHelper.CreateSysConfigTable(conn);
         finally
            conn.Connected:=false;
            freeandnil(conn);
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

end.
