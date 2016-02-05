unit ufrmMain;

interface

uses
   Windows,
   Messages,
   SysUtils,
   Variants,
   Classes,
   Graphics,
   Controls,
   Forms,
   Dialogs,
   ComCtrls,
   ShlObj,
   ExamGlobal,
   ufrminprocess,
   Data.DB,
   Data.Win.ADODB,
   scoreini, cxShellCommon, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit, dxSkinsCore, dxSkinsDefaultPainters, cxTextEdit,
  cxMaskEdit, cxDropDownEdit, cxShellComboBox, Vcl.StdCtrls,NetGlobal;

type
   TfrmMain = class(TForm)
      Label1: TLabel;
      Label2: TLabel;
      Label3: TLabel;
      edtStart: TEdit;
      edtEnd: TEdit;
      Button1: TButton;
      ListBox1: TListBox;
      cbKspath: TcxShellComboBox;
      Label4: TLabel;
      cbSystemDBpath: TcxShellComboBox;
      lblProgress: TLabel;
      Label7: TLabel;
      Label8: TLabel;
      Label9: TLabel;
      pb: TProgressBar;
      edtname: TEdit;
      edtzkh: TEdit;
      edtPath: TEdit;
      setExamineeBase: TADODataSet;
      connExamineeBase: TADOConnection;
      Label10: TLabel;
      procedure Button1Click(Sender: TObject);
      procedure connExamineeBaseBeforeConnect(Sender: TObject);
   private
      CurrentExaminee: TExaminee;
      pbHandle: integer; // 表示进度条对象
      procedure CreateExamEnvironment(aPath, currentID: string);
      procedure InsertExamineeRec(AExaminee: TExaminee; AScore: TScoreIni);
      // procedure OnProcess(AMessage: string; AStep: integer = 1);
   public

      { Public declarations }
   end;

procedure OnProcess(AMessage: string; AStep: integer);

var
   frmMain: TfrmMain;

implementation

uses udmMain,
   ufrmGrade,
   compress,
   datafieldconst,
   commons,
   centralgrade;

{$R *.dfm}

procedure TfrmMain.Button1Click(Sender: TObject);
var
   st, en, count: int64;
   i: integer;
   spath: string;
   currentID: string;
   currentDatFile: string;
   // AOnProcess: TOnProcess;
   centralgrade: TCentralGrade;
begin
   dm := dm1;
   st := strtoint64(edtStart.text);
   en := strtoint64(edtEnd.text);
   spath := IncludeTrailingPathDelimiter(cbKspath.AbsolutePath);
   count := en - st + 1;
   for i := 0 to count - 1 do
      begin
         currentID := inttostr(st + i);
         currentDatFile := currentID + '.dat';
         if not DirectoryExists(spath + currentID) then
            if FileExists(spath + currentDatFile) then
               begin
                  try
                     UnZipExamPackFile2Dir(spath + currentDatFile, spath);
                  except
                     on E: Exception do
                        Application.MessageBox(pwidechar(Format('解压考生文件包出错，文件包名为： %s /n 错误详细信息： %s', [currentDatFile, E.Message])),
                          '解压考生文件包错误', MB_OK + MB_ICONSTOP + MB_TOPMOST);
                  end;
               end
            else
               Continue;

         // 如果评分出错，可考虑略过，记录在列表框中
         CreateExamEnvironment(spath, currentID);
         // if not udmMain.dm1.TbKsStk.Active then
         // udmMain.dm1.TbKsStk.Active := true;
         // frmgrade.show;
         edtname.text := CurrentExaminee.Name;
         edtzkh.text := CurrentExaminee.ID;
         edtPath.text := spath + currentID;

         // AOnProcess := OnProcess;

         // pbHandle := PMBeginProcess(Application, '正在评分，请不要进行其它操作！！！', '正在开始评分！', 0, 100, -1);
         centralgrade := TCentralGrade.Create(spath + currentID, udmMain.dm1.ksconn, OnProcess);
         try
            centralgrade.SingleSelectGrade();
            centralgrade.MultiSelectGrade();
            centralgrade.TypeGrade();
            // texamclientglobal.typeFrame.HideFrame;
            centralgrade.OperationGrade();
            InsertExamineeRec(CurrentExaminee, centralgrade.Score);
            ListBox1.Items.Add(CurrentExaminee.ID + '-' + CurrentExaminee.Name + centralgrade.ErrorMessage)
         finally
            centralgrade.free;
            // PMEndProcess(pbHandle);
         end;

      end;
      lblProgress.Caption:='已完成评分！';
end;

procedure TfrmMain.CreateExamEnvironment(aPath, currentID: string);
var
   temp: TAdocommand;
   qry: TADOQuery;
begin
   CurrentExaminee.ClearData;
   aPath := IncludeTrailingPathDelimiter(aPath) + currentID;
   try
      // if dm.ksstatus=-2 then
      begin
         udmMain.dm1.ksconn.Connected := false;
         if FileExists(IncludeTrailingPathDelimiter(aPath) + '考生题库.dat') then
            begin
               udmMain.dm1.ksconn.ConnectionString := 'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=' + IncludeTrailingPathDelimiter(aPath)
                 + '考生题库.dat;Persist Security Info=False;Jet OLEDB:Database Password=jiaping';
            end
         else
            raise Exception.Create(Format('在 %s 下找不到 考生试题库.dat文件！请检查', [aPath]));
         udmMain.dm1.ksconn.Connected := true;
         qry := TADOQuery.Create(nil);
         try
            with qry, CurrentExaminee do
               begin
                  Connection := udmMain.dm1.ksconn;

                  SQL.Add('select * from ' + TBANAME_EXAMDB_INFO);
                  qry.Active := true;
                  qry.First;
                  ID := DecryptStr(qry.FieldValues[DFNEI_EXAMINEEID]);
                  Name := DecryptStr(qry.FieldValues[DFNEI_EXAMINEENAME]);
                  // Sex := DecryptStr(qry.FieldValues[DFNEI_EXAMINEESEX]);
                  RemainTime := strtoint(DecryptStr(qry.FieldValues[DFNEI_REMAINTIME]));
               end;
         finally
            qry.free;
         end;
         if CurrentExaminee.ID <> currentID then
            raise Exception.Create(Format('考生题库.dat中考生号：%s 与当前号:%s 不一致！请检查', [CurrentExaminee.ID, currentID]));

         // udmMain.dm1.TbKsxxk.Active := false;
         // udmMain.dm1.TbKsxxk.Connection := udmMain.dm1.ksconn;
         // udmMain.dm1.TbKsxxk.Active := true;
         // udmMain.dm1.TbKsxxk.First;
         //
         // udmMain.dm1.kszkh := DecryptStr(udmMain.dm1.TbKsxxk.fieldbyname(DFNEI_EXAMINEEID).AsString);
         // udmMain.dm1.ksxm := DecryptStr(udmMain.dm1.TbKsxxk.fieldbyname(DFNEI_EXAMINEENAME).AsString);
         // udmMain.dm1.KsPath := aPath;

         // udmMain.dm.TbKsxxk.AppendRecord([udmMain.dm.kszkh,udmMain.dm.ksxm,udmMain.dm.kssj,1]);
      end;
      // temp := TAdocommand.Create(self);
      // try
      // temp.Connection := udmMain.dm1.sysconn;
      // temp.CommandText :=
      // 'insert into 考生信息 (zkh,xm,zsj,status,xz1_fs,pd_fs,dz_fs,win_fs,word_fs,excel_fs,ppt_fs,zf) values(:zkh,:xm,:zsj,:status,:xz,:pd,:dz,:win,:word,:excel,:ppt,:zf)';
      // temp.Parameters.ParamByName('zkh').Value := udmMain.dm1.TbKsxxk.FieldValues['zkh'];
      // temp.Parameters.ParamByName('xm').Value := udmMain.dm1.TbKsxxk.FieldValues['xm'];
      // temp.Parameters.ParamByName('zsj').Value := 0; // dm1.TbKsxxk.FieldValues['zsj'];
      // temp.Parameters.ParamByName('status').Value := '0A70'; // dm1.TbKsxxk.FieldValues['status'];
      // temp.Parameters.ParamByName('xz').Value := '0A70'; // dm1.TbKsxxk.FieldValues['xz1_fs'];
      // temp.Parameters.ParamByName('pd').Value := '0A70'; // dm1.TbKsxxk.FieldValues['pd_fs'];
      // temp.Parameters.ParamByName('dz').Value := '0A70'; // dm1.TbKsxxk.FieldValues['dz_fs'];
      // temp.Parameters.ParamByName('win').Value := '0A70'; // dm1.TbKsxxk.FieldValues['win_fs'];
      // temp.Parameters.ParamByName('word').Value := '0A70'; // dm1.TbKsxxk.FieldValues['word_fs'];
      // temp.Parameters.ParamByName('excel').Value := '0A70'; // dm1.TbKsxxk.FieldValues['excel_fs'];
      // temp.Parameters.ParamByName('ppt').Value := '0A70'; // dm1.TbKsxxk.FieldValues['ppt_fs'];
      // temp.Parameters.ParamByName('zf').Value := '0A70'; // dm1.TbKsxxk.FieldValues['zf'];
      // temp.Execute;
      // finally
      // temp.Free;
      // end;

      // dm1.TbMainFile.close;
      udmMain.dm1.TbKsxxk.close;

   except
      Application.NormalizeTopMosts;
      Application.MessageBox('生成考试环境出现问题，请重新进入系统', '提示:', MB_OK);
      Application.RestoreTopMosts;

   end;

   // dm.ksstatus表示考试状态 -1：重考 -2：续考 -3：无效
   // try
   // if dm.ksstatus=-2 then
   // begin
   // dm.ksconn.ConnectionString:='Provider=Microsoft.Jet.OLEDB.4.0;Data Source='+dm.kspath+'\考生题库.dat;Persist Security Info=False;Jet OLEDB:Database Password=jiaping';
   // dm.ksconn.Connected:=true;
   // dm.TbKsxxk.Active:=false;
   // dm.TbKsxxk.Connection:=dm.ksconn;
   // dm.TbKsxxk.Active:=true;
   // dm.TbKsxxk.AppendRecord([dm.kszkh,dm.ksxm,dm.kssj]);      //以备上报评分时获得考生信息
   // dm.ksStatus:=1;
   // end
   // else
   // begin
   // createKsstk;                  //建立考生试题库并切换考生信息到考生数据库
   // CreateWindowsExamEnvironment(dm.KsPath);
   // CreateWordExamEnvironment;
   // CreateExcelExamEnvironment;
   // CreatePptExamEnvironment;
   // ClearScore;       // 清除系统考生信息中得分
   // { raise ERangeError.CreateFmt('%d is not within the valid range of %d..%d', [1, 1, 1]);  }
   // end;
   // updateExamState(dm.ksStatus);
   // dm.TbMainFile.close;
   // dm.TbKsxxk.close;
   // modalResult:=1;
   // except
   // application.NormalizeTopMosts;
   // application.MessageBox('生成考试环境出现问题，请重新进入系统', '提示:', mb_ok);
   // application.RestoreTopMosts;
   // modalResult:=-1;
   // end;
end;

procedure TfrmMain.InsertExamineeRec(AExaminee: TExaminee; AScore: TScoreIni);
var
   dfstr: string;
   sqlstr: string;
   ScoreStream: TMemoryStream;
begin
   if not setExamineeBase.Active then
      setExamineeBase.Active := true;

   ScoreStream := TMemoryStream.Create;
   try
      AScore.SaveToStream(ScoreStream);
      CompressStream(ScoreStream);
      setExamineeBase.AppendRecord([EncryptStr(CurrentExaminee.ID), EncryptStr(CurrentExaminee.Name)]);
      //, EncryptStr(CurrentExaminee.Sex),
//        EncryptStr(CurrentExaminee.IP), EncryptStr(inttostr(CurrentExaminee.Port)), EncryptStr(inttostr(ord(CurrentExaminee.Status))),
//        EncryptStr(inttostr(CurrentExaminee.RemainTime)), EncryptStr(DateTimeToStr(CurrentExaminee.TimeStamp))]);
      setExamineeBase.Edit;
      ScoreStream.Position := 0;
      (setExamineeBase.FieldByName(DFNEI_SCOREINFO) as TBlobField).LoadFromStream(ScoreStream);
      setExamineeBase.Post;
   finally
      ScoreStream.free;
   end;
end;

procedure TfrmMain.connExamineeBaseBeforeConnect(Sender: TObject);
var
   path: string;
begin
   path := ExtractFilePath(Application.ExeName);
   if not FileExists(path + '成绩库.mdb') then
      raise Exception.Create(Format('系统未能在 %s 中找到 %s 文件！' + examglobal.CR + '程序将退出！', [path, '成绩库.mdb']));
   // if FileExists(path + '成绩库.mdb') then
   // begin
   connExamineeBase.ConnectionString := 'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=' + path + '\成绩库.mdb' +
     ';Persist Security Info=False;Jet OLEDB:Database Password=' + DecryptStr(SYSDBPWD);
   // end
   // else
   // begin
   // Application.MessageBox(PChar(Format('系统未能在 %s 中找到 %s 文件！' + ExamGlobal.CR + '请选择成绩库，或重新配置服务系统路径！', [path, '成绩库.mdb'])), '未找到成绩库',
   // MB_OK + MB_ICONINFORMATION + MB_TOPMOST);
   // Application.Terminate;
   // dlgOpen1.Title := '请选择系统题库：';
   // dlgOpen1.InitialDir := path;
   // dlgOpen1.FileName := '成绩库.mdb';
   // if dlgOpen1.Execute() then
   // begin
   // StkDbFilePath := dlgOpen1.FileName;
   // connExamineeBase.ConnectionString := 'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=' + dlgOpen1.FileName +
   // ';Persist Security Info=False;Jet OLEDB:Database Password=' + DecryptStr(SYSDBPWD);
   // end
   // else
   // begin
   // { TODO : 是否要退出程序，还是继续 }
   // end;
   // end;
end;

// procedure OnProcess(AMessage: string; AStep: integer);
// begin
// PMOnProcess(frmMain.pbHandle, AMessage, AStep);
// end;

procedure OnProcess(AMessage: string; AStep: integer);
begin

   // PMOnProcess(frmMain.pbHandle, AMessage, AStep);

   if AMessage <> '' then
      frmMain.lblProgress.Caption := AMessage;

   // if ShowPosition then
   // frmInProcess.Info := frmInProcess.Info + '（' + IntToStr(frmInProcess.pb.Position) + '\' + IntToStr(frmInProcess.pb.Max) + '）';

   // if Position <> -1 then
   // frmInProcess.Position := Position
   // else
   frmMain.pb.StepBy(AStep);

   Application.ProcessMessages;

   // if frmInProcess.Canceled then
   // Canceled := true;

end;

end.
