unit frmEnterForBaseImport;

interface

uses
   Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
   Dialogs, cxEdit, DB,
   ADODB, StdCtrls, cxGridLevel, cxGridCustomTableView, cxGridTableView,
   cxGridDBTableView, cxClasses, cxControls, cxGridCustomView, cxGrid, Mask,
   cxContainer, cxLabel, cxStyles, dxSkinsCore, dxSkinBlack, dxSkinBlue,
   dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom,
   dxSkinDarkSide, dxSkinFoggy, dxSkinGlassOceans, dxSkiniMaginary,
   dxSkinLilian, dxSkinLiquidSky, dxSkinLondonLiquidSky,
   dxSkinMcSkin, dxSkinMoneyTwins, dxSkinOffice2007Black, dxSkinOffice2007Blue,
   dxSkinOffice2007Green,
   dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinPumpkin, dxSkinSeven,
   dxSkinSharp, dxSkinSilver, dxSkinSpringTime,
   dxSkinStardust, dxSkinSummer2008, dxSkinsDefaultPainters, dxSkinValentine,
   dxSkinXmas2008Blue, dxSkinscxPCPainter,
   cxCustomData, cxGraphics, cxFilter, cxData, cxDataStorage, cxDBData,
   cxLookAndFeels, cxLookAndFeelPainters, dxSkinBlueprint,
   dxSkinDevExpressDarkStyle, dxSkinDevExpressStyle, dxSkinHighContrast,
   dxSkinMetropolis, dxSkinMetropolisDark, dxSkinOffice2010Black,
   dxSkinOffice2010Blue, dxSkinOffice2010Silver, dxSkinOffice2013DarkGray,
   dxSkinOffice2013LightGray, dxSkinOffice2013White, dxSkinSevenClassic,
   dxSkinSharpPlus, dxSkinTheAsphaltWorld, dxSkinVS2010, dxSkinWhiteprint,
   cxNavigator, Datasnap.DBClient;

type
   TEnterForBaseImport = class(TForm)
      lbl6: TLabel;
      lbl8: TLabel;
      lbl9: TLabel;
      btnAllImport: TButton;
      medtStart: TMaskEdit;
      medtEnd: TMaskEdit;
      lbl7: TLabel;
      grdAllExaminees: TcxGrid;
      tvExaminees: TcxGridDBTableView;
      grdlvlAllExaminees: TcxGridLevel;
      grdEnterFor: TcxGrid;
      gvEnterFor: TcxGridDBTableView;
      clmnGrid1DBTableView1ExamineeNo: TcxGridDBColumn;
      clmnGrid1DBTableView1ExamineeName: TcxGridDBColumn;
      grdlvlGrid1Level1: TcxGridLevel;
      lbl1: TLabel;
      edtBmk: TEdit;
      btn2: TButton;
      dlgOpen1: TOpenDialog;
      lbl5: TLabel;
      dsksxxk: TDataSource;
      connkwxxk: TADOConnection;
      tblkwxxk: TADOTable;
      dskwxxk: TDataSource;
      clmnExamineesDecryptedID: TcxGridDBColumn;
      clmnExamineesDecryptedName: TcxGridDBColumn;
      lblHelp: TcxLabel;
      setExamineeBase: TADODataSet;
      wdstrngfldExamineeBaseExamineeID: TWideStringField;
      wdstrngfldExamineeBaseExamineeName: TWideStringField;
      wdstrngfldExamineeBaseStatus: TWideStringField;
      strngfldExamineeBaseDecryptedID: TStringField;
      strngfldExamineeBaseDecryptedName: TStringField;
      gvEnterForColumnExamineeSex: TcxGridDBColumn;
      clmnExamineesDecryptedSex: TcxGridDBColumn;
      setExamineeBaseExamineeSex: TStringField;
      setExamineeBaseDecryptedSex: TStringField;
    cdsExaminees: TClientDataSet;
      procedure btn2Click(Sender: TObject);
      procedure btnAllImportClick(Sender: TObject);
      procedure FormCreate(Sender: TObject);
      procedure cdsExamineesCalcFields(DataSet: TDataSet);
      procedure setExamineeBaseCalcFields(DataSet: TDataSet);
   private
      { Private declarations }
   public
      class procedure FormShow(); static;
   end;

var
   EnterForBaseImport: TEnterForBaseImport;

implementation

uses
   Commons, uDmServer, DataFieldConst;

{$R *.dfm}
{ TEnterForBaseImport }

procedure TEnterForBaseImport.btn2Click(Sender: TObject);
var
   str: string;
begin
   if dlgOpen1.Execute then
   begin
      edtBmk.Text := dlgOpen1.FileName;
      connkwxxk.Connected := false;
      // str:= 'Provider=MSDASQL.1;Persist Security Info=False;Extended Properties="DSN=Visual FoxPro Database;UID=;SourceDB='+
      // ExtractFiledir(edtBmk.Text)+';SourceType=DBF;Exclusive=No;BackgroundFetch=Yes;Collate=Machine;Null=Yes;Deleted=Yes;"';
      str := 'Provider=Microsoft.ACE.OLEDB.12.0;Data Source=' +
        ExtractFiledir(edtBmk.Text) +
        ';Extended Properties=dBASE IV;User ID=Admin;';
      connkwxxk.ConnectionString := str;
      tblkwxxk.TableName := ExtractFileName(edtBmk.Text);
      tblkwxxk.active := true;
   end;

end;

procedure TEnterForBaseImport.btnAllImportClick(Sender: TObject);
var
   stkh, endkh: int64;
   i, dd, cc: integer;
   aa: string;
begin
   if (trim(edtBmk.Text) = '') then Exit;

   if setExamineeBase.RecordCount>0 then
     btnAllImport.Enabled:=false;
//   begin
//      if Application.MessageBox('�ɼ��������м�¼����ȷ��Ҫɾ����','',MB_YESNO)=mrYes then
//      begin
//         setExamineeBase.DeleteRecords();
//      end;
//   end;
   with tblkwxxk do
   begin
       First;
       while not Eof do
       begin
        setExamineeBase.AppendRecord([EncryptStr(FieldByName('׼��֤��').AsString),EncryptStr(FieldByName('����').AsString),EncryptStr(FieldByName('�Ա�').AsString)]);
        tblkwxxk.Next;
        end;
       end;
//      cc := 0;
//         if not(trim(medtStart.Text) = '') and not(trim(medtEnd.Text) = '') then
//         begin
//            stkh := strtoint64(medtStart.Text);
//
//            endkh := strtoint64(medtEnd.Text);
//
//            dd := endkh - stkh + 1;
//            if (dd <= 0) or (dd > 60) then
//               application.MessageBox('��ʼ�Ŵ�����ֹ�Ż�Χ̫��', '����', 0)
//            else if dd <= 0 then
//               application.MessageBox('��ʼ�Ŵ�����ֹ�ţ�', '����', 0)
//            else
//            begin
//               for i := 1 to dd do
//               begin
//                  if not setExamineeBase.Locate(DFNEI_DECRYPTEDID,
//                    inttostr(stkh + i - 1), [loCaseInsensitive]) then
//
//                  begin
//                     if tblkwxxk.Locate('׼��֤��', inttostr(stkh + i - 1),[loCaseInsensitive]) then
//                     begin
//                        setExamineeBase.AppendRecord
//                          ([EncryptStr(tblkwxxk.FieldByName('׼��֤��').AsString),
//                          EncryptStr(tblkwxxk.FieldByName('����').AsString),
//                          EncryptStr(FieldByName('�Ա�').AsString)]);
//                        cc := cc + 1;
//                     end;
//                  end;
//               end;
//            end;
//         end;


end;

procedure TEnterForBaseImport.cdsExamineesCalcFields(DataSet: TDataSet);
begin
   // ==============================================================================
   // ������ܵ������ֶ�Ҫ�뵼��ʱ�����������ֶ�Ҫ��Ӧ�����ٲ��ܶ�
   // ==============================================================================
   with DataSet do
   begin
      FieldValues[DFNEI_DECRYPTEDID] :=
        DecryptStr(FieldByName(DFNEI_EXAMINEEID).AsString);
      FieldValues[DFNEI_DECRYPTEDNAME] :=
        DecryptStr(FieldByName(DFNEI_EXAMINEENAME).AsString);
      // FieldValues[DFNEI_DECRYPTEDSTATUS] := DecryptStr(FieldByName(DFNEI_STATUS).AsString);
   end;
end;

procedure TEnterForBaseImport.FormCreate(Sender: TObject);
begin
   setExamineeBase.CommandText := SQLSTR_GETALLEXAMINEES;

   setExamineeBase.active := true;
//   setExamineeBase.Sort:= 'DecryptedID ASC';
    if setExamineeBase.RecordCount>0 then btnAllImport.Enabled := False;
end;

class procedure TEnterForBaseImport.FormShow;
var
   frm: TEnterForBaseImport;
begin
   frm := TEnterForBaseImport.Create(nil);
   try
      frm.ShowModal;
   finally
      frm.Free;
   end;
end;

procedure TEnterForBaseImport.setExamineeBaseCalcFields(DataSet: TDataSet);
begin
   // ==============================================================================
   // ������ܵ������ֶ�Ҫ�뵼��ʱ�����������ֶ�Ҫ��Ӧ�����ٲ��ܶ�
   // ==============================================================================
   with DataSet do
   begin
      FieldValues[DFNEI_DECRYPTEDID] :=
        DecryptStr(FieldByName(DFNEI_EXAMINEEID).AsString);
      FieldValues[DFNEI_DECRYPTEDNAME] :=
        DecryptStr(FieldByName(DFNEI_EXAMINEENAME).AsString);
      FieldValues[DFNEI_DECRYPTEDSEX] :=
        DecryptStr(FieldByName(DFNEI_EXAMINEESEX).AsString);
      // FieldValues[DFNEI_DECRYPTEDSTATUS] := DecryptStr(FieldByName(DFNEI_STATUS).AsString);
   end;
end;

end.
