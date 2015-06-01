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
  dxSkinValentine, dxSkinXmas2008Blue;

type
  TfrmEQImport = class(TForm)
    cxLabel3: TcxLabel;
    bedtSourceFile: TcxButtonEdit;
    cbEqType: TcxComboBox;
    cxLabel1: TcxLabel;
    btnEQImport: TcxButton;
    btnExport: TcxButton;
    procedure btnEQImportClick(Sender: TObject);
    procedure bedtSourceFilePropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure btnExportClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmEQImport: TfrmEQImport;

implementation
uses  adodb, uDmSetQuestion, uFnMt,DataUtils, DataFieldConst, tq, Commons, 
  ExamGlobal;

{$R *.dfm}

procedure TfrmEQImport.bedtSourceFilePropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  bedtSourceFile.Text:=OpenFileDialog('access���ݿ�|*.mdb');
end;

procedure TfrmEQImport.btnEQImportClick(Sender: TObject);
var
  connSource:TADOConnection;
  adsSource:TADODataSet;
  EQTypeStr:string;
  EQType:integer;
  ATQ:TTQ;
begin
  btnEQImport.Enabled := False ;
  connSource:=TADOConnection.Create(nil);
  connSource.ConnectionString:='Provider=Microsoft.Jet.OLEDB.4.0;User ID=Admin;Data Source='+
        bedtSourcefile.Text+';Mode=Share Deny None;Extended Properties="";Jet OLEDB:System database="";Jet OLEDB:Database Password='+DecryptStr(SYSDBPWD)+';Jet OLEDB:Engine Type=5;Jet OLEDB:Database Locking Mode=1;';
  connSource.LoginPrompt:=false;

  if cbEQType.Text='����ѡ����' then  begin EQTypeStr:='A%'; eqType:=1; end;
  if cbEQType.Text='����ѡ����' then  begin EQTypeStr:='X%'; eqType:=2; end;
  if cbEQType.Text='������' then   begin EQTypeStr:='C%'; eqType:=3; end;
  if cbEQType.Text='Windows������' then  begin EQTypeStr:='D%'; eqType:=4; end;
  if cbEQType.Text='Word������' then  begin EQTypeStr:='E%'; eqType:=5; end;
  if cbEQType.Text='Excel������' then  begin EQTypeStr:='F%'; eqType:=6; end;
  if cbEQType.Text='PowerPoint������' then  begin EQTypeStr:='G%'; eqType:=7; end;

  adsSource:=TADODataSet.Create(nil);
  try
     adsSource.Connection:= connSource;
     adsSource.CommandText:='select * from ���� where st_no like '+QuotedStr(EQTypeStr);
     adsSource.Active := True ;
     if not adsSource.IsEmpty and (eqType>0) then
     begin
       ATQ := TTQ.Create;
       try
           begin
             with adsSource do
             begin
               first;
               while not eof do
               begin
                  if FieldByName(DFNTQ_ISMODIFIED).AsBoolean then begin
                        ATQ.ClearData;
                       TTQ.WriteFieldValuesToTQ(adsSource,ATQ);    //��Դ���ݿ��ж����ݵ�ATQ
                       TTQ.WriteTQ2DB(ATQ,dmSetQuestion.GetTQDBConn,[rwoRedactor,rwoRedactTime]);              //��ATQ������д�뵽Ŀ�����ݿ��У�����£������
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
     adsSource.free;
     connSource.free;
  end;

  btnEQImport.Enabled := True ;
end;

procedure TfrmEQImport.btnExportClick(Sender: TObject);
var
  connSource:TADOConnection;
  adsSource:TADODataSet;
  EQTypeStr:string;
  EQType:integer;
  ATQ:TTQ;
begin
//  btnExport.Enabled := False ;
//  connSource:=TADOConnection.Create(nil);
//  connSource.ConnectionString:='Provider=Microsoft.Jet.OLEDB.4.0;User ID=Admin;Data Source='+
//        bedtSourcefile.Text+';Mode=Share Deny None;Extended Properties="";Jet OLEDB:System database="";Jet OLEDB:Database Password='+DecryptStr(SYSDBPWD)+';Jet OLEDB:Engine Type=5;Jet OLEDB:Database Locking Mode=1;';
//  connSource.LoginPrompt:=false;
//
//  if cbEQType.Text='����ѡ����' then  begin EQTypeStr:='A%'; eqType:=1; end;
//  if cbEQType.Text='����ѡ����' then  begin EQTypeStr:='X%'; eqType:=2; end;
//  if cbEQType.Text='������' then   begin EQTypeStr:='C%'; eqType:=3; end;
//  if cbEQType.Text='Windows������' then  begin EQTypeStr:='D%'; eqType:=4; end;
//  if cbEQType.Text='Word������' then  begin EQTypeStr:='E%'; eqType:=5; end;
//  if cbEQType.Text='Excel������' then  begin EQTypeStr:='F%'; eqType:=6; end;
//  if cbEQType.Text='PowerPoint������' then  begin EQTypeStr:='G%'; eqType:=7; end;
//
//  adsSource:=TADODataSet.Create(nil);
//  try
//     adsSource.Connection:= connSource;
//     adsSource.CommandText:='select * from ���� where st_no like '+QuotedStr(EQTypeStr);
//     adsSource.Active := True ;
//     if not adsSource.IsEmpty and (eqType>0) then
//     begin
//       ATQ := TTQ.Create;
//       try
//           begin
//             with adsSource do
//             begin
//               first;
//               while not eof do
//               begin
//                  if FieldByName(DFNTQ_ISMODIFIED).AsBoolean then begin
//                        ATQ.ClearData;
//                       TTQ.WriteFieldValuesToTQ(adsSource,ATQ);    //��Դ���ݿ��ж����ݵ�ATQ
//                       TTQ.WriteTQ2DB(ATQ,dmSetQuestion.GetTQDBConn,[woRedactor,woRedactTime]);              //��ATQ������д�뵽Ŀ�����ݿ��У�����£������
//                  end;
//                 next;
//               end;
//             end;
//           end
//       finally
//          ATQ.Free;
//       end;
//     end;
//  finally
//     adsSource.free;
//     connSource.free;
//  end;
//  btnExport.Enabled := True ;
end;

end.
