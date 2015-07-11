unit uSysConfig;

interface

uses
   Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
   Dialogs, uBaseActionForm, StdCtrls, cxButtons, ExtCtrls, cxDropDownEdit,
   cxCalendar, cxMaskEdit, cxTextEdit, cxControls, cxContainer, cxEdit,
   cxLabel, DB, ADODB, cxGraphics, Menus, cxLookAndFeelPainters, dxSkinsCore, dxSkinsDefaultPainters, dxSkinBlack,
   dxSkinBlue, dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide, dxSkinFoggy, dxSkinGlassOceans,
   dxSkiniMaginary, dxSkinLilian, dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMoneyTwins,
   dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green, dxSkinOffice2007Pink, dxSkinOffice2007Silver,
   dxSkinPumpkin, dxSkinSeven, dxSkinSharp, dxSkinSilver, dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008,
   dxSkinValentine, dxSkinXmas2008Blue, cxGroupBox, cxMemo, cxClasses, cxStyles, cxGridTableView,
   cxLookAndFeels, dxSkinOffice2010Black, dxSkinOffice2010Blue,
   dxSkinOffice2010Silver, Vcl.ComCtrls, dxCore, cxDateUtils, cxRadioGroup;

type
   TfrmSysConfig = class(TBaseActionForm)
      cxLabel1: TcxLabel;
      edtName: TcxTextEdit;
      cxLabel2: TcxLabel;
      cxLabel3: TcxLabel;
      cxLabel4: TcxLabel;
      cbType: TcxComboBox;
      edtDate: TcxDateEdit;
      cbDispScore: TcxComboBox;
      Panel1: TPanel;
      btnModify: TcxButton;
      btnSave: TcxButton;
      btnExit: TcxButton;
      btnCancel: TcxButton;
      setSysConfig: TADODataSet;
      cxLabel7: TcxLabel;
      cxLabel8: TcxLabel;
      edtExamTime: TcxTextEdit;
      edtTypeTime: TcxTextEdit;
      edtExamPath: TcxTextEdit;
      cxLabel6: TcxLabel;
      cxmModules: TcxMemo;
      cxmStrategy: TcxMemo;
      cxgrpbxModules: TcxGroupBox;
      cxgrpbxStrategy: TcxGroupBox;
      cxLabel5: TcxLabel;
      edtStatusRefeshInterval: TcxTextEdit;
      cxLabel9: TcxLabel;
      edtPwd: TcxTextEdit;
      radiogrpRetryModel: TcxRadioGroup;
      cxLabel11: TcxLabel;
      procedure btnSaveClick(Sender: TObject);
      procedure btnExitClick(Sender: TObject);
      procedure btnModifyClick(Sender: TObject);
      procedure btnCancelClick(Sender: TObject);
   private
      procedure SetControlState(aAction: TFormAction); override;
      { Private declarations }
   protected

   public
      procedure InitData; override;
      procedure doBrowse(RecID: String); override;
      procedure doSave(RecID: String); override;
      { Public declarations }
   end;

var
   frmSysConfig: TfrmSysConfig;

implementation

uses uDmSetQuestion, uGrade, Commons;

{$R *.dfm}
{ TfrmSysConfig }

procedure TfrmSysConfig.doBrowse(RecID: String);
   var
      configStrings: TStringList;
   begin
      inherited;
      // �ݴ��ǣ���sysconfig��Ϊ��ʱ�����Զ����һ����¼����������ݣ�Ȼ���ٱ༭
      with setData do
      begin
         First;
         configStrings := TStringList.Create;
         try
            configStrings.Text := DecryptStr(FieldByName('Config').AsString);
            edtPwd.Text        := configStrings.Values['�����ӿ�����'];
            edtName.Text       := configStrings.Values['����'];
            cbType.Text        := configStrings.Values['����'];
            edtDate.Date       := strtoint64(configStrings.Values['��Ч����']);
            cbDispScore.Text   := configStrings.Values['��ʾ�ɼ�'];
            // edtManagePwd.Text:= configStrings.Values['��������'];
            edtExamTime.Text := configStrings.Values['����ʱ��'];
            edtTypeTime.Text := configStrings.Values['����ʱ��'];
            edtExamPath.Text := configStrings.Values['����·��'];
            // edtPhotoFolder.Text:= configStrings.Values['��Ƭ·��'];
            edtStatusRefeshInterval.Text := configStrings.Values['״̬���¼��'];
            cxmModules.Text              := DecryptStr(FieldByName('Modules').AsString);
            cxmStrategy.Text             := DecryptStr(FieldByName('Strategy').AsString);
            radiogrpRetryModel.ItemIndex := strtoint(configStrings.Values['��¼���ģʽ']);
         finally
            configStrings.Free;
         end;
      end; // with
   end;

procedure TfrmSysConfig.doSave(RecID: String);
   var
      configStrings: TStringList;
   begin
      inherited;
      with setData do
      begin
         configStrings := TStringList.Create;
         try
            // configStrings.Text := DecryptStr(FieldByName('Config').AsString);
            configStrings.Values['����']   := edtName.Text;
            configStrings.Values['����']   := cbType.Text;
            configStrings.Values['��Ч����'] := inttostr(trunc(edtDate.Date));
            configStrings.Values['��ʾ�ɼ�'] := cbDispScore.Text;
            // configStrings.Values['��������']:= edtManagePwd.Text;
            configStrings.Values['����·��'] := edtExamPath.Text;
            // configStrings.Values['��Ƭ·��']:= edtPhotoFolder.Text;
            configStrings.Values['����ʱ��']   := edtExamTime.Text;
            configStrings.Values['����ʱ��']   := edtTypeTime.Text;
            configStrings.Values['״̬���¼��'] := edtStatusRefeshInterval.Text;
            configStrings.Values['��¼���ģʽ'] := inttostr(radiogrpRetryModel.ItemIndex);
            configStrings.Values['�����ӿ�����'] := edtPwd.Text;

            Edit;
            FieldByName('Config').AsString   := EncryptStr(configStrings.Text);
            FieldByName('Modules').AsString  := EncryptStr(cxmModules.Text);
            FieldByName('Strategy').AsString := EncryptStr(cxmStrategy.Text);
            Post;
         finally
            configStrings.Free;
         end;
      end; // with
   end;

procedure TfrmSysConfig.InitData;
   var
      configStrings: TStringList;
   begin
      setData        := setSysConfig;
      setData.Active := true;
      with setData do
      begin
         if isempty then
         begin
            configStrings := TStringList.Create;
            configStrings.Add('����=һ��Windows��ֽ������ϵͳ');
            configStrings.Add('����=��ʽ����'); // ��ʽ����  ģ�⿼��
            configStrings.Add('��Ч����=' + inttostr(trunc(Date())));
            configStrings.Add('��ʾ�ɼ�=��������'); // �ͻ���  ��������
            // configStrings.Add('��������=jiaping');           //����

            configStrings.Add('����ʱ��=5400');
            configStrings.Add('����ʱ��=900');
            configStrings.Add('����·��=E:\yjksmtxt\debug\test');
            configStrings.Add('��¼���ģʽ=0');
            configStrings.Add('�����ӿ�����=123');
            configStrings.Add('״̬���¼��=3');
            append;
            Edit;
            FieldByName('Config').AsString   := EncryptStr(configStrings.Text);
            FieldByName('Modules').AsString  := EncryptStr('');
            FieldByName('Strategy').AsString := EncryptStr('');
            Post;
         end;
      end; // with

      setData.First;
      inherited;
   end;

procedure TfrmSysConfig.btnSaveClick(Sender: TObject);
   begin
      inherited;
      FormAction(faSave, '');
   end;

procedure TfrmSysConfig.btnCancelClick(Sender: TObject);
   begin
      inherited;
      FormAction(faBrowse, '');
   end;

procedure TfrmSysConfig.btnExitClick(Sender: TObject);
   begin
      inherited;
      close;
   end;

procedure TfrmSysConfig.btnModifyClick(Sender: TObject);
   var
      gdData: TGradeInfo;
      aa, cc: string;
   begin
      inherited;
      FormAction(faModify, '');
   end;

procedure TfrmSysConfig.SetControlState(aAction: TFormAction);
   begin
      inherited;
      case aAction of
         faBrowse:
            begin
               btnModify.Enabled := true;
               btnSave.Enabled   := false;
               btnCancel.Enabled := false;

               edtPwd.Enabled      := false;
               edtName.Enabled     := false;
               cbType.Enabled      := false;
               edtDate.Enabled     := false;
               cbDispScore.Enabled := false;
               // edtManagePwd.Enabled := false;
               edtExamTime.Enabled        := false;
               edtTypeTime.Enabled        := false;
               edtExamPath.Enabled        := false;
               edtPwd.Enabled             := false;
               radiogrpRetryModel.Enabled := false;
               // edtPhotoFolder.Enabled := False;
               cxmModules.Enabled              := false;
               cxmStrategy.Enabled             := false;
               edtStatusRefeshInterval.Enabled := false;
            end;
         faAppend, faModify:
            begin
               btnModify.Enabled := false;
               btnSave.Enabled   := true;
               btnCancel.Enabled := true;

               edtPwd.Enabled      := true;
               edtName.Enabled     := true;
               cbType.Enabled      := true;
               edtDate.Enabled     := true;
               cbDispScore.Enabled := true;
               // edtManagePwd.Enabled := True;
               edtExamTime.Enabled        := true;
               edtTypeTime.Enabled        := true;
               edtExamPath.Enabled        := true;
               edtPwd.Enabled             := true;
               radiogrpRetryModel.Enabled := true;
               // edtPhotoFolder.Enabled := true;
               cxmModules.Enabled              := true;
               cxmStrategy.Enabled             := true;
               edtStatusRefeshInterval.Enabled := true;
            end;
         faSave, faCancel:
            begin
               btnModify.Enabled := true;
               btnSave.Enabled   := false;
               btnCancel.Enabled := false;

               edtPwd.Enabled      := false;
               edtName.Enabled     := false;
               cbType.Enabled      := false;
               edtDate.Enabled     := false;
               cbDispScore.Enabled := false;
               // edtManagePwd.Enabled := false;
               edtExamTime.Enabled        := false;
               edtTypeTime.Enabled        := false;
               edtExamPath.Enabled        := false;
               edtPwd.Enabled             := false;
               radiogrpRetryModel.Enabled := false;
               // edtPhotoFolder.Enabled := False;
               cxmModules.Enabled              := false;
               cxmStrategy.Enabled             := false;
               edtStatusRefeshInterval.Enabled := false;
            end;
      end;
   end;

end.
