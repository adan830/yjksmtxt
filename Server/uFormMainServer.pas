// Todo: 需要考虑服务程序死掉情况，如何保存当前状态，如何恢复状态

unit uFormMainServer;

interface

   uses
      Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
      Dialogs, StdCtrls, ExamineesManager, DB, ExamServer, ServerUtils, cxControls, cxPC,
      cxContainer, cxEdit, cxTextEdit, cxMaskEdit, cxDropDownEdit, cxShellComboBox, cxLabel, cxSpinEdit, cxGroupBox,
      ExtCtrls, NetGlobal, ComCtrls, dxBar, cxClasses, cxStyles,
      cxCustomData, cxDataStorage, cxGridCustomView, cxGridCustomTableView, cxGridTableView, cxGridLevel, cxGrid,
      cxGridCustomPopupMenu, cxGridPopupMenu, ADODB, dxSkinsCore, dxSkinBlack, dxSkinBlue, dxSkinCaramel,
      dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide, dxSkinFoggy, dxSkinGlassOceans, dxSkiniMaginary, dxSkinLilian,
      dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMoneyTwins, dxSkinOffice2007Black, dxSkinOffice2007Blue,
      dxSkinOffice2007Green, dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinPumpkin, dxSkinSeven, dxSkinSharp,
      dxSkinSilver, dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008, dxSkinsDefaultPainters, dxSkinValentine,
      dxSkinXmas2008Blue, dxSkinscxPCPainter, cxLookAndFeelPainters, cxGraphics, cxFilter, cxData, ShlObj, cxShellCommon,
      dxSkinsdxBarPainter, cxLookAndFeels, dxSkinOffice2010Black,
      dxSkinOffice2010Blue, dxSkinOffice2010Silver, cxDBData, cxGridDBTableView,
      DBClient, dxSkinBlueprint, dxSkinDevExpressDarkStyle,
      dxSkinDevExpressStyle, dxSkinHighContrast, dxSkinMetropolis,
      dxSkinMetropolisDark, dxSkinOffice2013DarkGray, dxSkinOffice2013LightGray,
      dxSkinOffice2013White, dxSkinSevenClassic, dxSkinSharpPlus,
      dxSkinTheAsphaltWorld, dxSkinVS2010, dxSkinWhiteprint, cxPCdxBarPopupMenu,
      cxNavigator, dxBarBuiltInMenu, cxCheckGroup, cxRadioGroup, idcontext, CustomColorForm,
      CnButtons, frxClass;//,wdhintwnd;

   type
      TExamServerStatus = (essConfigChanged = 1, essReady = 10, essExamineeSelected = 11, essStarted = 12, essTeminated = 13, essInfoSaved = 14);

      TFormMainServer = class(TCustomColorForm)
         dxbrmngrMainMenu: TdxBarManager;
         dxbrmngrMainMenuBar1: TdxBar;
         mnbtnAllExamineeInfoImport: TdxBarButton;
         pgServer: TcxPageControl;
         tbshtTQBInfo: TcxTabSheet;
         grpbx3: TcxGroupBox;
         tbshtMonitor: TcxTabSheet;
         img1: TImage;
         img2: TImage;
         img3: TImage;
         tbshtConfig: TcxTabSheet;
         grpbx1: TcxGroupBox;
         lbl3: TcxLabel;
         spndtStatusRefreshInterval: TcxSpinEdit;
         lbl4: TcxLabel;
         lbl2: TcxLabel;
         txtClientFolder: TcxMaskEdit;
         grpbx2: TcxGroupBox;
         lbl1: TcxLabel;
         cbbDataFolder: TcxShellComboBox;
         cxlbl2: TcxLabel;
         txtSchoolCode: TcxMaskEdit;
         grdlvlExaminees: TcxGridLevel;
         cxGrid1: TcxGrid;
         tvExaminees: TcxGridTableView;
         cxStyleRepository1: TcxStyleRepository;
         cxStyle1: TcxStyle;
         cxStyle2: TcxStyle;
         cxStyle3: TcxStyle;
         cxStyle4: TcxStyle;
         cxStyle5: TcxStyle;
         cxStyle6: TcxStyle;
         cxStyle7: TcxStyle;
         cxStyle8: TcxStyle;
         cxStyle9: TcxStyle;
         cxStyle10: TcxStyle;
         cxStyle11: TcxStyle;
         cxStyle12: TcxStyle;
         cxStyle13: TcxStyle;
         cxStyle14: TcxStyle;
         GridTableViewStyleSheetDevExpress: TcxGridTableViewStyleSheet;
         grdPopupMenu: TcxGridPopupMenu;
         barPopupMenu: TdxBarPopupMenu;
         pmbtnReExam: TdxBarButton;
         pmbtnContinuteExam: TdxBarButton;
         mnbtnAbsent: TdxBarButton;
         mnbtnCrib: TdxBarButton;
         dxBarSeparator1: TdxBarSeparator;
         cxLabel1: TcxLabel;
         edtName: TcxTextEdit;
         cxLabel2: TcxLabel;
         cxLabel3: TcxLabel;
         cxLabel4: TcxLabel;
         edtType: TcxTextEdit;
         edtDuration: TcxTextEdit;
         edtScoreDisp: TcxTextEdit;
         cxEditStyleController1: TcxEditStyleController;
         edtStkDbFilePath: TcxTextEdit;
         lbl5: TcxLabel;
         edtTypeTime: TcxTextEdit;
         cxLabel8: TcxLabel;
         edtExamTime: TcxTextEdit;
         cxLabel7: TcxLabel;
         cxLabel9: TcxLabel;
         cbbExamBakFolder: TcxShellComboBox;
         cxGroupBox1: TcxGroupBox;
         cxLabel11: TcxLabel;
         cxLabel12: TcxLabel;
         cbbExamineePhotoFolder: TcxShellComboBox;
         radiogrpRetryModel: TcxRadioGroup;
         dxBarButton1: TdxBarButton;
         dxBarButton2: TdxBarButton;
         mnbtnNormal: TdxBarButton;
         GridPanel1: TGridPanel;
         GridPanel2: TGridPanel;
         Panel1: TPanel;
         Panel2: TPanel;
         btnSaveConfig: TCnSpeedButton;
         btnConfigCancel: TCnSpeedButton;
         btnConfigEdit: TCnSpeedButton;
         btnResetExamPwd: TCnSpeedButton;
         Report: TfrxReport;
         btnGrade: TCnSpeedButton;
         btnStart: TCnSpeedButton;
         btnEndExam: TCnSpeedButton;
         btnExamineeSelect: TCnSpeedButton;
         btnExamRecord: TCnSpeedButton;
         btnCheckZero: TCnSpeedButton;
         btnLock: TCnSpeedButton;
         btnExit: TCnSpeedButton;
         Image1: TImage;
    btnOpenFirewallPort: TCnSpeedButton;

         procedure FormCreate(Sender: TObject);

         procedure FormDestroy(Sender: TObject);

         procedure btnEndExamClick(Sender: TObject);
         procedure btnStartClick(Sender: TObject);
         procedure btnExamineeSelectClick(Sender: TObject);
         procedure tbshtConfigShow(Sender: TObject);
         procedure btnSaveConfigClick(Sender: TObject);
         procedure btnExitClick(Sender: TObject);
         procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
         procedure ConfigChange(Sender: TObject);
         procedure pgServerPageChanging(Sender: TObject; NewPage: TcxTabSheet; var AllowChange: Boolean);
         procedure btnConfigEditClick(Sender: TObject);
         procedure btnConfigCancelClick(Sender: TObject);
         procedure mnbtnAllExamineeInfoImportClick(Sender: TObject);
         procedure dxbrmngrMainMenuShowCustomizingPopup(Sender: TdxBarManager; PopupItemLinks: TdxBarItemLinks);
         procedure pmbtnReExamClick(Sender: TObject);
         procedure pmbtnContinuteExamClick(Sender: TObject);
         procedure mnbtnAbsentClick(Sender: TObject);
         procedure mnbtnCribClick(Sender: TObject);
         procedure btnExamRecordClick(Sender: TObject);
         procedure ReportGetValue(const VarName: string; var Value: Variant);
         procedure btnResetExamPwdClick(Sender: TObject);
         procedure barPopupMenuPopup(Sender: TObject);
         procedure btnLockClick(Sender: TObject);
    procedure btnOpenFirewallPortClick(Sender: TObject);
         private
            FServerStatus: TExamServerStatus;

            // FExamServer       : TExamServer;
            // FExamineesManager : TExamineesManager;
            // procedure clientListOnListChanged(const aItem: TClientbak);
            procedure InitGrdClientListHeader;
            procedure SetFormControlStatus(const AStatus: TExamServerStatus);
            procedure SetServerStatus(const Value: TExamServerStatus);
            procedure SaveConfig;
            procedure SetConfigControlStatus(const AModified: Boolean);
            procedure LoadConfigControlValue;
            procedure SetExamBaseInfo();
            function GetUnnormalExamineeInfoCDS(cdsSource: TClientDataSet): TClientDataSet;
         protected
            procedure CLMChanged(var message: TCLMChange); message CLM_Changed;
            // procedure CLMAdd(var message:TCLMChange);message CLM_Added;
            // procedure CLMDeleted(var message:TCLMChange);message CLM_Deleted;
            // procedure CLMAllChanged(var message:TCLMChange);message CLM_AllChanged;
         public
            { Public declarations }
            procedure RefreshData;
            procedure HandleException(Sender: TObject; E: Exception);

            // property ExamineesManager : TExamineesManager read FExamineesManager write FExamineesManager;
            property ServerStatus: TExamServerStatus read FServerStatus write SetServerStatus;

      end;

      /// 全局变量
      /// 客户计算机数
   const
      CLIENTNUM = 10;
      TabChar   = #9;

   var
      FormMainServer: TFormMainServer;

implementation

   uses
      uDmServer, frmExamineesImport, ServerGlobal, StkRecordInfo, frmEnterForBaseImport, IOUtils, DataFieldConst, ExamException,
      Provider, DataUtils, Commons, setexampwd, system.Hash, ufrmserverlock, frxDBSet;
   {$R *.dfm}

   procedure TFormMainServer.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
      begin
         CanClose := True;
         //{$IFNDEF DEBUG}
         if TExamServerGlobal.ExamServer.Active then
         begin
            CanClose := False;
         end;
        // {$ENDIF}
      end;

   procedure TFormMainServer.FormCreate(Sender: TObject);
      begin
         Application.OnException := HandleException;
         // TExamServerGlobal.CreateClassObject();
         // GlobalDmServer:=TdmServer.Create(nil);
         // GlobalStkRecordInfo := TStkRecordInfo.CreateStkRecordInfo;
         // SetupGlobalOperateModules;
         // FExamineesManager := TExamineesManager.Create(Self.Handle);
         // FExamineesManager.SetupExamineeList;
         // FExamServer := TExamServer.Create(Self, FExamineesManager, 3000);
         TExamServerGlobal.ExamineesManager.MessageHandler := self.handle;
         InitGrdClientListHeader;
         ServerStatus := essReady;
         SetExamBaseInfo();
      end;

   procedure TFormMainServer.FormDestroy(Sender: TObject);
      begin
         // FExamServer.Scheduler.TerminateAllYarns;
         // FExamServer.Free;
         // FExamineesManager.Free;
         // TExamServerGlobal.DestroyClassObject;
         // FreeAndNil(TExamServerGlobal.Inst);
         // GlobalDmServer.Free;
         // GlobalStkRecordInfo.Free;
      end;

   procedure TFormMainServer.ReportGetValue(const VarName: string; var Value: Variant);
      var
         examTimeStr: string;
      begin
         if CompareText(VarName, 'vSchoolName') = 0 then
         begin
            Value := 'aaaaaaa';
         end;
         if CompareText(VarName, 'vCode') = 0 then
         begin
            Value := '111';
         end;
         if CompareText(VarName, 'vTotalNum') = 0 then
         begin
            Value := '25';
         end;
         if CompareText(VarName, 'vExamID') = 0 then
         begin
            DateTimeToString(examTimeStr, 'yyyymmddhhnn', Now);
            Value := examTimeStr;
         end;

      end;

   procedure TFormMainServer.InitGrdClientListHeader;
      begin
         with tvExaminees.CreateColumn do
         begin
            Index                      := ColIndexOfExamineeNo;
            Caption                    := '准考证号';
            DataBinding.ValueTypeClass := TcxStringValueType;
            width                      := 120;
            Options.Editing            := False;
         end;
         with tvExaminees.CreateColumn do
         begin
            Index                      := ColIndexOfExamineeName;
            Caption                    := '姓名';
            DataBinding.ValueTypeClass := TcxStringValueType;
            width                      := 80;
            Options.Editing            := False;
         end;
         with tvExaminees.CreateColumn do
         begin
            Index                      := ColIndexOfIP;
            Caption                    := '学生IP';
            DataBinding.ValueTypeClass := TcxStringValueType;
            width                      := 120;
            Options.Editing            := False;
         end;
         with tvExaminees.CreateColumn do
         begin
            Index                      := ColIndexOfPort;
            Caption                    := '端口';
            DataBinding.ValueTypeClass := TcxStringValueType;
            width                      := 80;
            Options.Editing            := False;
         end;
         with tvExaminees.CreateColumn do
         begin
            Index                      := ColIndexOfStatus;
            Caption                    := '状态';
            DataBinding.ValueTypeClass := TcxStringValueType;
            width                      := 120;
            Options.Editing            := False;
         end;
         with tvExaminees.CreateColumn do
         begin
            Index                      := ColIndexOfRemainTime;
            Caption                    := '剩余时间';
            DataBinding.ValueTypeClass := TcxStringValueType;
            width                      := 110;
            Options.Editing            := False;
         end;
      end;

   procedure TFormMainServer.pgServerPageChanging(Sender: TObject; NewPage: TcxTabSheet; var AllowChange: Boolean);
      begin
         if ServerStatus = essConfigChanged then
         begin
            if Application.MessageBox('你已修改了配置，是否保存？', '提示：', MB_YESNO) = IDYES then
            begin
               SaveConfig;
            end;
            // ServerStatus := essReady;
         end;
      end;

   procedure TFormMainServer.pmbtnContinuteExamClick(Sender: TObject);
      var
         Examinee: PExaminee; // Examinee will be put in the message ,so we'll dynamic alloc mem
      begin

         New(Examinee);
         with Examinee^, tvExaminees.DataController do
         begin
            ID         := Values[FocusedRecordIndex, ColIndexOfExamineeNo];
            Name       := Values[FocusedRecordIndex, ColIndexOfExamineeName];
            Status     := esAllowContinuteExam;
            RemainTime := strtoint(Values[FocusedRecordIndex, ColIndexOfRemainTime]);
            IP         := Values[FocusedRecordIndex, ColIndexOfIP];
            Port       := Values[FocusedRecordIndex, ColIndexOfPort];
         end;
         TExamServerGlobal.ExamineesManager.UpdateStatus(Examinee);
      end;

   procedure TFormMainServer.pmbtnReExamClick(Sender: TObject);
      var
         Examinee: PExaminee; // Examinee will be put in the message ,so we'll dynamic alloc mem
      begin
         New(Examinee);
         with Examinee^, tvExaminees.DataController do
         begin
            ID         := Values[FocusedRecordIndex, ColIndexOfExamineeNo];
            Name       := Values[FocusedRecordIndex, ColIndexOfExamineeName];
            Status     := esAllowReExam;
            RemainTime := strtoint(Values[FocusedRecordIndex, ColIndexOfRemainTime]);
            IP         := Values[FocusedRecordIndex, ColIndexOfIP];
            Port       := Values[FocusedRecordIndex, ColIndexOfPort];
         end;
         TExamServerGlobal.ExamineesManager.UpdateStatus(Examinee);
      end;

   // procedure TFormMainServer.GetClientInfoCommand(
   // ASender: TIdCommand);
   // var
   // ksh:string;
   // ksxm:string;
   // clientIP:string;
   // clientPort:integer;
   // begin
   // with ASender.Context.Connection.IOHandler do
   // begin
   // ksh:=ReadLn;
   // ksxm:=GetKsxmByKsh(ksh);
   // WriteLn(ksxm);
   // clientIP:=ASender.Context.Binding.PeerIP;
   // clientPort:=ASender.Context.Binding.PeerPort;
   // //FUsers.Add(clientIP,clientPort,ksh,ksxm);
   /// /      RefreshData;
   // end;
   // end;

   procedure TFormMainServer.barPopupMenuPopup(Sender: TObject);
      begin
         if TExamServerGlobal.ServerCustomConfig.LoginPermissionModel = 0 then
         begin
            pmbtnReExam.Enabled        := False;
            pmbtnContinuteExam.Enabled := False;
         end else begin
            pmbtnReExam.Enabled        := True;
            pmbtnContinuteExam.Enabled := True;
         end;
      end;

   procedure TFormMainServer.btnConfigCancelClick(Sender: TObject);
      begin
         LoadConfigControlValue;
         ServerStatus := essReady;
      end;

   procedure TFormMainServer.btnConfigEditClick(Sender: TObject);
      begin
         ServerStatus := essConfigChanged;
         SetConfigControlStatus(True);
      end;

   procedure TFormMainServer.btnEndExamClick(Sender: TObject);
      begin { TODO -ojp -cMust : 结束考试前检查连接情况 }
         try
            TExamServerGlobal.ExamServer.Active := False;
            ServerStatus                        := essTeminated;
            // 保存考生信息
            TExamServerGlobal.ExamineesManager.SaveExamineeInfo;
            ServerStatus := essInfoSaved;
         except
            on E: Exception do
               raise;
         end;
      end;

   procedure TFormMainServer.btnExamineeSelectClick(Sender: TObject);
      begin
         TExamineesImport.FormShow();
      end;

   procedure TFormMainServer.btnExamRecordClick(Sender: TObject);
      var
         examineeCDS: TClientDataSet;
         ReportDS   : TfrxDBDataset;
         // frxcom:TfrxMemoview;
         // frxmastData:TfrxMasterData;
         // frxDB:TfrxDBDataset;
      begin
         if Report = nil then
            Report := TfrxReport.Create(self);

         ReportDS := TfrxDBDataset.Create(nil);
         try
            examineeCDS := TExamServerGlobal.ExamineesManager.GetExamineesCDS;
            examineecds.SaveToFile();
            // examineeCDS.LoadFromFile('examineecds.dat');
            ReportDS.DataSet := examineeCDS;
            // examineeCDS.SaveToFile('examineecds.dat');
            ReportDS.UserName := 'reportds';
            Report.Clear;
            Report.LoadFromFile('examrecord.fr3', True);

//             report.DataSets.add(ReportDS);
//             Report.DataSet := ReportDS;
            // frxmastData:=report.FindObject('MastData1') as TfrxMasterData;
            // frxmastData.DataSet:=ReportDS;
            // frxcom:=Report.FindObject('ReportDS') as TfrxMemoView;
            // frxcom.DataSet:=ReportDS;
            // frxcom.DataField:='examineeID';
            Report.ShowReport();

         finally
            ReportDS.Free;
            examineeCDS.Free;
         end;

         /// 清空报表，不然在窗体第二调用时会带不出报表信息

         // if (not TFile.Exists('examrecord.fr3')) then
         // begin
         // Application.MessageBox('找不到模板: OrderPrint.frx, 请先设计模板 ');
         // Report.RegisterData(ds); // 注册数据
         // Report.SetParameterValue(" TType ", " 类型 "); // 传递参数
         // for (int i = 0; i < ds.Tables.Count; i + +)
         // report.GetDataSource(ds.Tables[i].TableName).Enabled = true;    //手动设为true，不然在设计器中看不到数据对象
         // Report.Design(); // 设计
         // return;
         // end;
         // Report.Load(frxFile);
         // Report.SetParameterValue(" TType ", " 类型 ");
         // Report.RegisterData(ds);
         // Report.Prepare();
         // Report.ShowPrepared(); // 预览显示

      end;

   procedure TFormMainServer.btnExitClick(Sender: TObject);
      begin
         Close;
      end;

   procedure TFormMainServer.btnLockClick(Sender: TObject);

      begin
         with TFormServerLock.Create(self) do
         begin
            Shadowed := True;
            if showModal = 1 then

               Free;
         end;
      end;

   procedure TFormMainServer.btnOpenFirewallPortClick(Sender: TObject);
   var
      s:string;
      r:integer;
      cmd: AnsiString;
begin
   cmd:='netsh.exe advfirewall firewall delete rule name=ExamServer';
   r:=WinExec(pansichar(cmd),SW_Hide);
   //Application.MessageBox(pwidechar( r.ToString()),'result');
   cmd:='netsh.exe advfirewall firewall add rule name=ExamServer profile=any dir=in action=allow protocol=tcp localport=3000';
   r:=WinExec(pansichar(cmd),SW_Hide);
   //Application.MessageBox(pwidechar( r.ToString()),'result');
end;

procedure TFormMainServer.btnResetExamPwdClick(Sender: TObject);
      var
         resetExamPwdForm: TResetExamPwdForm;
         mr              : integer;
      begin
         resetExamPwdForm := TResetExamPwdForm.Create(nil);
         try
            mr := resetExamPwdForm.showModal;
            if mr = mrYes then
            begin
               if TExamServerGlobal.ServerCustomConfig.LoginPermissionModel = 0 then
               begin
                  TExamServerGlobal.ServerCustomConfig.RetryPwd   := THashMD5.GetHashString(trim(resetExamPwdForm.edtRetryPwd.Text));
                  TExamServerGlobal.ServerCustomConfig.ContPwd    := THashMD5.GetHashString(trim(resetExamPwdForm.edtContPwd.Text));
                  TExamServerGlobal.ServerCustomConfig.AddTimePwd := THashMD5.GetHashString(trim(resetExamPwdForm.edtAddTimePwd.Text));
               end;
               TExamServerGlobal.ServerCustomConfig.AdminPwd := THashMD5.GetHashString(trim(resetExamPwdForm.edtAdminPwd.Text));
            end;
         finally
            resetExamPwdForm.Free;
         end;
      end;

   procedure TFormMainServer.btnSaveConfigClick(Sender: TObject);
      begin
         SaveConfig;
      end;

   procedure TFormMainServer.btnStartClick(Sender: TObject);
      var
         kc: string;
      begin
         TExamServerGlobal.GlobalStkRecordInfo.SetupExamineeTestFilePacks(TExamServerGlobal.ExamineesManager.Count, TExamServerGlobal.ServerCustomConfig.ServerDataPath +
                    '\tempdir');
         TExamServerGlobal.ExamServer.Active := True;
         TExamServerGlobal.ExamineesManager.EnableTimer(True);
         ServerStatus := essStarted;
         // TExamServerGlobal.ServerCustomConfig.CreateExaminationRoomBakFolder(TExamServerGlobal.ServerCustomConfig.ServerDataPath);
      end;

   function TFormMainServer.GetUnnormalExamineeInfoCDS(cdsSource: TClientDataSet): TClientDataSet;
      var
         i: integer;

         procedure changestatusvalue();
            begin
               if Result.FieldValues['Status'] = '0' then
                  Result.FieldValues['Status'] := '未考试'
               else if Result.FieldValues['Status'] = '' then
                  Result.FieldValues['Status'] := '未考试'
               else if Result.FieldValues['Status'] = '1' then
                  Result.FieldValues['Status'] := '重考'
               else if Result.FieldValues['Status'] = '2' then
                  Result.FieldValues['Status'] := '续考'
               else if Result.FieldValues['Status'] = '10' then
                  Result.FieldValues['Status'] := '考试异常'
               else if Result.FieldValues['Status'] = '11' then
                  Result.FieldValues['Status'] := '评分异常'
               else if Result.FieldValues['Status'] = '20' then
                  Result.FieldValues['Status'] := '已登录'
               else if Result.FieldValues['Status'] = '21' then
                  Result.FieldValues['Status'] := '获取试卷'
               else if Result.FieldValues['Status'] = '22' then
                  Result.FieldValues['Status'] := '考试中'
               else if Result.FieldValues['Status'] = '30' then
                  Result.FieldValues['Status'] := '评分中'
               else if Result.FieldValues['Status'] = '33' then
                  Result.FieldValues['Status'] := '提交成绩'
               else if Result.FieldValues['Status'] = '39' then
                  Result.FieldValues['Status'] := '错误'
               else if Result.FieldValues['Status'] = '40' then
                  Result.FieldValues['Status'] := '正常'
               else if Result.FieldValues['Status'] = '41' then
                  Result.FieldValues['Status'] := '缺考'
               else if Result.FieldValues['Status'] = '42' then
                  Result.FieldValues['Status'] := '作弊'
               else
            end;

      begin
         cdsSource.Filter   := 'status<>40';
         cdsSource.Filtered := True;

         Result := TClientDataSet.Create(nil);
         Result.FieldDefs.Clear;
         with Result.FieldDefs.AddFieldDef do
         begin
            Name     := 'ExamineeID';
            Size     := 24;
            DataType := ftString;
         end;
         with Result.FieldDefs.AddFieldDef do
         begin
            Name     := 'ExamineeName';
            Size     := 20;
            DataType := ftString;
         end;
         with Result.FieldDefs.AddFieldDef do
         begin
            Name     := 'Status';
            Size     := 20;
            DataType := ftString;
         end;
         with Result.FieldDefs.AddFieldDef do
         begin
            Name     := 'RemainTime';
            Size     := 20;
            DataType := ftString;
         end;
         with Result.FieldDefs.AddFieldDef do
         begin
            Name     := 'stamp';
            Size     := 20;
            DataType := ftString;
         end;
         Result.IndexFieldNames := 'examineeID';
         // 动态创建数据集
         Result.CreateDataSet;
         // 激活和打开该数据集
         Result.Open;
         Result.Active := True;
         with cdsSource Do
         begin
            first;
            while Not eof DO
            begin
               Result.Insert;
               For i := 0 to Result.FieldDefs.Count - 1 DO
               begin
                  if (FindField(Result.FieldDefs[i].Name)) <> nil then
                     Result.Fields[i].Value := FieldByName(Result.FieldDefs[i].Name).Value;
               end;
               changestatusvalue();
               Result.post;
               next;
            end;
         end;
      end;

   procedure TFormMainServer.RefreshData;
      var
         myList  : TList;
         Examinee: TExaminee;
         i       : integer;
      begin
         with tvExaminees.DataController do
         begin
            myList := TExamServerGlobal.ExamineesManager.ExamineesList.LockList;
            BeginUpdate;
            try
               RecordCount := myList.Count;
               for i       := 0 to myList.Count - 1 do
               begin
                  Examinee                          := TExaminee(myList[i]^);
                  Values[i, ColIndexOfExamineeNo]   := Examinee.ID;
                  Values[i, ColIndexOfExamineeName] := Examinee.Name;
                  Values[i, ColIndexOfIP]           := Examinee.IP;
                  Values[i, ColIndexOfPort]         := inttostr(Examinee.Port);
                  Values[i, ColIndexOfRemainTime]   := inttostr(Examinee.RemainTime);
                  Values[i, ColIndexOfStatus]       := GetStatusDisplayValue(Examinee.Status)
               end;
            finally
               TExamServerGlobal.ExamineesManager.ExamineesList.unlocklist;
               EndUpdate;
            end;
         end;
      end;

   procedure TFormMainServer.LoadConfigControlValue;
      begin
         txtClientFolder.Text := TExamServerGlobal.ServerCustomConfig.ExamPath;
         cbbDataFolder.Text   := TExamServerGlobal.ServerCustomConfig.ServerDataPath;
         // radiogrpRetryModel.ItemIndex := TExamServerGlobal.ServerCustomConfig.LoginPermissionModel;
         // spndtStatusRefreshInterval.Value := TExamServerGlobal.ServerCustomConfig.StatusRefreshInterval;
         // txtSchoolCode.Text := TExamServerGlobal.ServerCustomConfig.SchoolCode;
         // cbbExamBakFolder.Text := TExamServerGlobal.ServerCustomConfig.DataBakFolder;
         // cbbExamineePhotoFolder.Text := TExamServerGlobal.ServerCustomConfig.PhotoFolder;
      end;

   procedure TFormMainServer.mnbtnAbsentClick(Sender: TObject);
      var
         Examinee: PExaminee; // Examinee will be put in the message ,so we'll dynamic alloc mem
      begin
         New(Examinee);
         with Examinee^, tvExaminees.DataController do
         begin
            ID         := Values[FocusedRecordIndex, ColIndexOfExamineeNo];
            Name       := Values[FocusedRecordIndex, ColIndexOfExamineeName];
            Status     := esAbsent;
            RemainTime := strtoint(Values[FocusedRecordIndex, ColIndexOfRemainTime]);
            IP         := Values[FocusedRecordIndex, ColIndexOfIP];
            Port       := Values[FocusedRecordIndex, ColIndexOfPort];
         end;
         TExamServerGlobal.ExamineesManager.UpdateStatus(Examinee);
      end;

   procedure TFormMainServer.mnbtnAllExamineeInfoImportClick(Sender: TObject);
      begin
         TEnterForBaseImport.FormShow;
      end;

   procedure TFormMainServer.mnbtnCribClick(Sender: TObject);
      var
         Examinee: PExaminee; // Examinee will be put in the message ,so we'll dynamic alloc mem
      begin
         New(Examinee);
         with Examinee^, tvExaminees.DataController do
         begin
            ID         := Values[FocusedRecordIndex, ColIndexOfExamineeNo];
            Name       := Values[FocusedRecordIndex, ColIndexOfExamineeName];
            Status     := esCheat;
            RemainTime := strtoint(Values[FocusedRecordIndex, ColIndexOfRemainTime]);
            IP         := Values[FocusedRecordIndex, ColIndexOfIP];
            Port       := Values[FocusedRecordIndex, ColIndexOfPort];
         end;
         TExamServerGlobal.ExamineesManager.UpdateStatus(Examinee);
      end;

   procedure TFormMainServer.SetConfigControlStatus(const AModified: Boolean);
      begin
         // spndtStatusRefreshInterval.Enabled := AModified;
         txtClientFolder.Properties.ReadOnly := not AModified;
         // txtSchoolCode.Enabled := AModified;
         cbbDataFolder.Properties.ReadOnly := not AModified;
         cbbExamBakFolder.Enabled       := AModified;
         cbbExamineePhotoFolder.Enabled := AModified;

         btnConfigEdit.Enabled   := not AModified;
         btnConfigCancel.Enabled := AModified;
         btnSaveConfig.Enabled   := AModified;

         radiogrpRetryModel.Properties.ReadOnly := not AModified;

         // if AModified and (radiogrpRetryModel.ItemIndex = 0) then
         // btnResetExamPwd.Enabled := AModified
         // else
         btnResetExamPwd.Enabled := not AModified;
         // //spndtStatusRefreshInterval.Enabled := AModified;
         // txtClientFolder.Properties.ReadOnly:=not  AModified;
         /// /      txtSchoolCode.Properties.ReadOnly:=not  AModified;
         // cbbDataFolder.Properties.ReadOnly:=not  AModified;
         // cbbExamBakFolder.Properties.ReadOnly:=not  AModified;
         // cbbExamineePhotoFolder.Properties.ReadOnly:=not  AModified;
         //
         // btnConfigEdit.Enabled := not AModified;
         // btnConfigCancel.Enabled := AModified;
         // btnSaveConfig.Enabled := AModified;
      end;

   // ==============================================================================
   // 显示系统数据库相关信息
   // ==============================================================================
   procedure TFormMainServer.SetExamBaseInfo;
      begin
         with TExamServerGlobal.GlobalStkRecordInfo.BaseConfig do
         begin
            edtName.Text          := ExamName;
            edtType.Text          := ExamClasify;
            edtDuration.Text      := DateToStr(LastDate);
            edtScoreDisp.Text     := ScoreDisplayMode;
            edtExamTime.Text      := inttostr(ExamTime);
            edtTypeTime.Text      := inttostr(TypeTime);
            edtStkDbFilePath.Text := TExamServerGlobal.GlobalDmServer.StkDbFilePath;
         end;
      end;

   procedure TFormMainServer.SaveConfig;
      var
         filename: string;
         error   : bool;
      begin
         filename := ExtractFilePath(Application.ExeName);
         with TExamServerGlobal.ServerCustomConfig do
         begin
            ExamPath             := txtClientFolder.Text;
            ServerDataPath       := cbbDataFolder.Text;
            LoginPermissionModel := radiogrpRetryModel.ItemIndex;

            // StatusRefreshInterval := strtoint(spndtStatusRefreshInterval.Text);
            // SchoolCode := txtSchoolCode.Text;
            // DataBakFolder := cbbExamBakFolder.Text;
            // PhotoFolder:=cbbExamineePhotoFolder.text;
         end;
         TExamServerGlobal.ServerCustomConfig.SaveCustomConfig(filename);
         TExamServerGlobal.GlobalStkRecordInfo.BaseConfig.ModifyCustomConfig(TExamServerGlobal.ServerCustomConfig.StatusRefreshInterval,
            TExamServerGlobal.ServerCustomConfig.ExamPath, TExamServerGlobal.ServerCustomConfig.LoginPermissionModel);
         ServerStatus := essReady;
      end;

   procedure TFormMainServer.SetFormControlStatus(const AStatus: TExamServerStatus);
         procedure SetReady;
            begin
               btnExit.Enabled           := True;
               btnExamineeSelect.Enabled := True;
               btnStart.Enabled          := False;
               btnEndExam.Enabled        := False;
               btnExamRecord.Enabled:=false;
               // btnSaveExamineeInfo.Enabled := False;

               SetConfigControlStatus(False);
            end;
         procedure SetSelected;
            begin
               btnExit.Enabled           := True;
               btnExamineeSelect.Enabled := True;
               btnStart.Enabled          := true;
               btnEndExam.Enabled        := false;
               btnExamRecord.Enabled:=false;
               // btnSaveExamineeInfo.Enabled := False;

               SetConfigControlStatus(False);
            end;
         procedure SetExamining;
            begin
               btnExit.Enabled           := False;
               btnStart.Enabled          := False;
               btnExamineeSelect.Enabled := False;
               btnEndExam.Enabled        := False;
               // btnSaveExamineeInfo.Enabled := False;
               btnConfigEdit.Enabled   := False;
               btnResetExamPwd.Enabled := False;
               case ServerStatus of
                  essExamineeSelected:
                     begin
                        btnStart.Enabled          := True;
                        btnExamineeSelect.Enabled := True;
                     end;
                  essStarted:
                     btnEndExam.Enabled := True;
                  // essTeminated :
                  // btnSaveExamineeInfo.Enabled := True;
                  essInfoSaved:
                     btnExit.Enabled := True;
               end;
            end;
            procedure SetEndExam;
            begin
               btnExit.Enabled           := False;
               btnStart.Enabled          := False;
               btnExamineeSelect.Enabled := False;
               btnEndExam.Enabled        := False;
               btnExamRecord.Enabled:=true;
               // btnSaveExamineeInfo.Enabled := False;
               btnConfigEdit.Enabled   := False;
               btnResetExamPwd.Enabled := False;
               case ServerStatus of
                  essExamineeSelected:
                     begin
                        btnStart.Enabled          := True;
                        btnExamineeSelect.Enabled := True;
                     end;
                  essStarted:
                     btnEndExam.Enabled := True;
                  // essTeminated :
                  // btnSaveExamineeInfo.Enabled := True;
                  essInfoSaved:
                     btnExit.Enabled := True;
               end;
            end;

         procedure SetConfigChange;
            begin
               btnSaveConfig.Enabled := True;
            end;

      begin
         case AStatus of
            essConfigChanged:
               SetConfigChange;
            essReady:
               SetReady;
            essExamineeSelected:
               SetSelected;
             essStarted:
               SetExamining;
                essTeminated, essInfoSaved:
                setEndExam;

         end;
      end;

   procedure TFormMainServer.SetServerStatus(const Value: TExamServerStatus);
      begin
         FServerStatus := Value;
         SetFormControlStatus(Value);
      end;

   procedure TFormMainServer.tbshtConfigShow(Sender: TObject);
      begin
         LoadConfigControlValue;
      end;

   procedure TFormMainServer.ConfigChange(Sender: TObject);
      begin
         if FServerStatus = essConfigChanged then
            Exit;
         if (Sender as TcxCustomEdit).EditModified then
            ServerStatus := essConfigChanged;
      end;

   procedure TFormMainServer.dxbrmngrMainMenuShowCustomizingPopup(Sender: TdxBarManager; PopupItemLinks: TdxBarItemLinks);
      begin

      end;

   // procedure TFormMainServer.clientListOnListChanged(const aItem:TClientbak);
   // var
   // myList:TList;
   // item:TClientbak;
   // i:integer;
   // begin
   /// /   with grdExaminees do
   /// /   begin
   /// /     myList:=FExamineesManager.ClientsList.LockList;
   /// /     try
   /// /
   /// /         RowCount:=myList.Count;
   /// /         for I := 0 to myList.Count - 1 do
   /// /         begin
   /// /            item:=TClientbak(myList[i]  );
   /// /
   /// /            Cells[ColIndexOfID,i]:=inttostr(item.ID);
   /// /            Cells[ColIndexOfExamineeNo,i]:=item.ExamineeNo;
   /// /            Cells[ColIndexOfExamineeName,i]:=item.ExamineeName;
   /// /            Cells[ColIndexOfIP,i]:=item.IP;
   /// /            Cells[ColIndexOfPort,i]:=inttostr(item.Port);
   /// /            Cells[ColIndexOfClientName,i]:=item.ExamineeName;
   /// /            Cells[ColIndexOfRemainTime,i]:=inttostr(item.RemainTime);
   /// /            case item.Status of
   /// /               csDisConnected:   Cells[ColIndexOfStatus,i]:='断开';
   /// /               csConnected:      Cells[ColIndexOfStatus,i]:='连接';
   /// /               csGetTestPaper:   Cells[ColIndexOfStatus,i]:='正在获取试卷';
   /// /               csExamining:      Cells[ColIndexOfStatus,i]:='考试中...';
   /// /               csSutmitAchievement: Cells[ColIndexOfStatus,i]:='提交成绩';
   /// /               csExamEnded:      Cells[ColIndexOfStatus,i]:='考试结束';
   /// /            end;
   /// /         end;
   /// /
   /// /     finally
   /// /        FExamineesManager.ClientsList.unlocklist;
   /// /
   /// /     end;
   /// /  end;
   /// /
   // end;



   // procedure TFormMainServer.CLMAdd(var Message: TCLMChange);
   // begin
   // with grdExaminees,Message do
   // begin
   // RowCount:=RowCount+1;
   // Cells[ColIndexOfExamineeNo,RowCount-1]:=Item.ID;
   // Cells[ColIndexOfExamineeName,RowCount-1]:=Item.Name;
   // Cells[ColIndexOfIP,RowCount-1]:=Item.IP;
   // Cells[ColIndexOfPort,RowCount-1]:=inttostr(Item.Port);
   // Cells[ColIndexOfRemainTime,RowCount-1]:=inttostr(Item.RemainTime);
   // Cells[ColIndexOfStatus,RowCount-1]:= GetStatusDisplayValue(Item.Status);
   // end;
   // end;
   //
   // procedure TFormMainServer.CLMAllChanged(var message: TCLMChange);
   // var
   // index,i:integer;
   // begin
   // with grdExaminees,Message do
   // begin
   //
   /// /      if Item.Ksh<>'' then
   /// /         index := grdClientList.Cols[IndexOfKsh].IndexOf(Item.Ksh)
   /// /      else
   //
   /// / deleted row must ksh is empty
   // begin
   // index:=-1;
   // for i := 0 to RowCount-1 do
   // begin
   // if (Cells[ColIndexOfIP,i]= Item.IP)and (Cells[ColIndexOfPort,i]= inttostr(Item.Port)) then
   // begin
   // index:=i;
   // break;
   // end;
   // end;
   // end;
   //
   // if (index<>-1) then begin
   // for i := index to RowCount-1 do
   // begin
   //
   // Cells[ColIndexOfExamineeNo,i]:=Cells[ColIndexOfExamineeNo,i+1];
   // Cells[ColIndexOfExamineeName,i]:=Cells[ColIndexOfExamineeName,i+1];
   // Cells[ColIndexOfIP,i]:=Cells[ColIndexOfIP,i+1];
   // Cells[ColIndexOfPort,i]:=Cells[ColIndexOfPort,i+1];
   //
   // Cells[ColIndexOfRemainTime,i]:=Cells[ColIndexOfRemainTime,i+1];
   // Cells[ColIndexOfStatus,i]:=Cells[ColIndexOfStatus,i+1];
   // end;
   // RowCount:=RowCount-1;
   // end;
   // end;
   // end;
   /// /
   // procedure TFormMainServer.CLMDeleted(var message: TCLMChange);
   // var
   // index,i:integer;
   // begin
   // with grdExaminees,Message do
   // begin
   // if Item.ID<>'' then
   // index := grdExaminees.Cols[ColIndexOfExamineeNo].IndexOf(Item.ID)
   // else
   // begin
   // index:=-1;
   // for i := 0 to RowCount-1 do
   // begin
   // if (Cells[ColIndexOfIP,i]= Item.IP)and (Cells[ColIndexOfPort,i]= inttostr(Item.Port)) then
   // begin
   // index:=i;
   // break;
   // end;
   // end;
   // end;
   //
   // if (index<>-1) then begin
   // for i := index to RowCount-1 do
   // begin
   //
   // Cells[ColIndexOfExamineeNo,i]:=Cells[ColIndexOfExamineeNo,i+1];
   // Cells[ColIndexOfExamineeName,i]:=Cells[ColIndexOfExamineeName,i+1];
   // Cells[ColIndexOfIP,i]:=Cells[ColIndexOfIP,i+1];
   // Cells[ColIndexOfPort,i]:=Cells[ColIndexOfPort,i+1];
   //
   // Cells[ColIndexOfRemainTime,i]:=Cells[ColIndexOfRemainTime,i+1];
   // Cells[ColIndexOfStatus,i]:=Cells[ColIndexOfStatus,i+1];
   // end;
   // RowCount:=RowCount-1;
   // Dispose(item);
   // end;
   // end;
   // end;

   procedure TFormMainServer.CLMChanged(var message: TCLMChange);
      var
         index, i: integer;
      begin
         // don't dispose examinee ,because the item is managed by examineemanager,it is not be deleted ,moved
         // Dispose(message.Item);
         with tvExaminees.DataController, Message do
         begin

            index := -1;
            for i := 0 to RowCount - 1 do
            begin
               if Values[i, ColIndexOfExamineeNo] = Item.ID then
               begin
                  index := i;
                  break;
               end;
            end;

            if (index <> -1) then
            begin

               // Cells[ColIndexOfExamineeNo,index]:=Item.ExamineeNo;
               // Cells[ColIndexOfExamineeName,index]:=Item.ExamineeName;
               Values[index, ColIndexOfIP]         := Item.IP;
               Values[index, ColIndexOfPort]       := inttostr(Item.Port);
               Values[index, ColIndexOfRemainTime] := inttostr(Item.RemainTime);
               Values[index, ColIndexOfStatus]     := GetStatusDisplayValue(Item.Status);
            end;
         end;
         // don't dispose examinee ,because the item is managed by examineemanager,it is not be deleted ,moved
         Dispose(message.Item);
      end;

   procedure TFormMainServer.HandleException(Sender: TObject; E: Exception);
      begin
         TExamServerGlobal.logger.WriteLog(E.message);
         Application.ShowException(E);
      end;

end.
