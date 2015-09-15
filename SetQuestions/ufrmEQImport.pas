unit ufrmEQImport;

interface

uses
   Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
   Dialogs, cxTextEdit, cxMaskEdit, cxButtonEdit, cxControls, cxContainer,
   cxEdit, cxLabel, cxLookAndFeelPainters, StdCtrls, cxButtons, cxDropDownEdit,
   cxGraphics, Menus, dxSkinsCore, dxSkinsDefaultPainters, dxSkinBlack,
   dxSkinBlue, dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide,
   dxSkinFoggy, dxSkinGlassOceans, dxSkiniMaginary, dxSkinLilian,
   dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMoneyTwins,
   dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
   dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinPumpkin, dxSkinSeven,
   dxSkinSharp, dxSkinSilver, dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008,
   dxSkinValentine, dxSkinXmas2008Blue, cxLookAndFeels;

type
   TfrmEQImport = class(TForm)
      cxLabel3 : TcxLabel;
      bedtSourceFile : TcxButtonEdit;
      cbEqType : TcxComboBox;
      cxLabel1 : TcxLabel;
      btnEQImport : TcxButton;
      btnExit : TcxButton;
    chkImportOldBase: TCheckBox;
      procedure btnEQImportClick(Sender : TObject);
      procedure bedtSourceFilePropertiesButtonClick(Sender : TObject; AButtonIndex : Integer);
      procedure btnExitClick(Sender : TObject);
      private
         { Private declarations }
      public
         { Public declarations }
   end;

var
   frmEQImport : TfrmEQImport;

implementation

uses adodb, uDmSetQuestion, uFnMt, DataUtils, DataFieldConst, tq, Commons,
   ExamGlobal;

{$R *.dfm}

procedure TfrmEQImport.bedtSourceFilePropertiesButtonClick(Sender : TObject; AButtonIndex : Integer);
   begin
      bedtSourceFile.Text := OpenFileDialog('access���ݿ�|*.mdb');
   end;

procedure TfrmEQImport.btnEQImportClick(Sender : TObject);
   var
      connSource : TADOConnection;
      adsSource  : TADODataSet;
      EQTypeStr  : string;
      EQType     : Integer;
      ATQ        : TTQ;
   begin
      if Length(bedtSourceFile.Text)=0 then
         exit;
      btnEQImport.Enabled := False;
      btnExit.Enabled     := False;
      connSource          := TADOConnection.Create(nil);
      adsSource           := TADODataSet.Create(nil);
      try
         connSource.ConnectionString := 'Provider=Microsoft.Jet.OLEDB.4.0;User ID=Admin;Data Source=' + bedtSourceFile.Text +
                 ';Mode=Share Deny None;Extended Properties="";Jet OLEDB:System database="";Jet OLEDB:Database Password=' + DecryptStr(SYSDBPWD) +
                 ';Jet OLEDB:Engine Type=5;Jet OLEDB:Database Locking Mode=1;';
         connSource.LoginPrompt := False;

         if cbEqType.Text = '����ѡ����' then
         begin
            EQTypeStr := 'A%';
            EQType    := 1;
         end;
         if cbEqType.Text = '����ѡ����' then
         begin
            EQTypeStr := 'X%';
            EQType    := 2;
         end;
         if cbEqType.Text = '������' then
         begin
            EQTypeStr := 'C%';
            EQType    := 3;
         end;
         if cbEqType.Text = 'Windows������' then
         begin
            EQTypeStr := 'D%';
            EQType    := 4;
         end;
         if cbEqType.Text = 'Word������' then
         begin
            EQTypeStr := 'E%';
            EQType    := 5;
         end;
         if cbEqType.Text = 'Excel������' then
         begin
            EQTypeStr := 'F%';
            EQType    := 6;
         end;
         if cbEqType.Text = 'PowerPoint������' then
         begin
            EQTypeStr := 'G%';
            EQType    := 7;
         end;

         adsSource.Connection  := connSource;
         adsSource.CommandText := 'select * from ���� where st_no like ' + QuotedStr(EQTypeStr);
         adsSource.Active      := True;
         if not adsSource.IsEmpty and (EQType > 0) then
         begin
            ATQ := TTQ.Create;
            try
               begin
                  with adsSource do
                  begin
                     first;
                     while not eof do
                     begin
                        if FieldByName(DFNTQ_ISMODIFIED).AsBoolean then
                        begin
                           ATQ.ClearData;
                           TTQ.WriteFieldValuesToTQ(adsSource, ATQ);                                     // ��Դ���ݿ��ж����ݵ�ATQ
                           TTQ.WriteTQ2DB(ATQ, dmSetQuestion.GetTQDBConn, [rwoRedactor, rwoRedactTime]); // ��ATQ������д�뵽Ŀ�����ݿ��У�����£������
                        end;
                        next;
                     end;
                  end;
               end
            finally
               ATQ.Free;
            end;
         end;
      finally
         adsSource.Free;
         connSource.Free;
         btnEQImport.Enabled := True;
         btnExit.Enabled     := True;
      end;

   end;

procedure TfrmEQImport.btnExitClick(Sender : TObject);
   begin
      Close;
   end;

end.
