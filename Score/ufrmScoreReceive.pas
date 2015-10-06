unit ufrmScoreReceive;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cxLookAndFeelPainters, cxLabel, cxControls, cxContainer, cxEdit,
  cxTextEdit, cxMaskEdit, cxButtonEdit, StdCtrls, cxButtons, ExtCtrls, Menus, dxSkinsCore, dxSkinsDefaultPainters, 
  DBClient, DB, dxSkinBlack, dxSkinBlue, dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide, dxSkinFoggy,
  dxSkinGlassOceans, dxSkiniMaginary, dxSkinLilian, dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin,
  dxSkinMoneyTwins, dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green, dxSkinOffice2007Pink,
  dxSkinOffice2007Silver, dxSkinPumpkin, dxSkinSeven, dxSkinSharp, dxSkinSilver, dxSkinSpringTime, dxSkinStardust,
  dxSkinSummer2008, dxSkinValentine, dxSkinXmas2008Blue, cxGraphics,
  cxLookAndFeels, dxSkinOffice2010Black, dxSkinOffice2010Blue,
  dxSkinOffice2010Silver;

type
  TfrmScoreReceive = class(TForm)
    btnScore: TcxButton;
    edtSource: TcxButtonEdit;
    cxLabel1: TcxLabel;
    OpenDialog1: TOpenDialog;
    edtInsertNum: TcxTextEdit;
    edtUpdateNum: TcxTextEdit;
    cxLabel2: TcxLabel;
    cxLabel3: TcxLabel;
    Timer1: TTimer;
    edtTime: TcxTextEdit;
    edtRecno: TcxTextEdit;
    cxLabel4: TcxLabel;
    procedure Timer1Timer(Sender: TObject);
    procedure edtSourceClick(Sender: TObject);
    procedure btnScoreClick(Sender: TObject);
  private
//    procedure DecryptExamineeInfoCDS(cds: TClientDataSet);
    function GetScoreValue(const scoreStream: TMemoryStream): Integer;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmScoreReceive: TfrmScoreReceive;

implementation

uses udmMain, uPubFn, DataFieldConst, Commons, compress, ScoreIni,datautils;

{$R *.dfm}

procedure TfrmScoreReceive.btnScoreClick(Sender: TObject);
var
  scoreStream : TMemoryStream;
  score : Integer;
  function myStrToint(const str:string):Integer;
  begin
    if str='' then begin
      result :=0;
      Exit;
    end;
    result := StrToInt(str);
  end;
  procedure SoureToTotal(const cdsSource : TClientDataSet;var cdsTotal :TClientDataSet;const score:Integer);//;const scoreStream:TMemoryStream);
  begin
    with cdsTotal do
    begin
      Edit;
      FieldValues[DFNEI_EXAMINEENAME] := cdsSource.FieldValues[DFNEI_EXAMINEENAME];
      FieldValues[DFNEI_EXAMINEESEX] := cdsSource.FieldValues[DFNEI_EXAMINEESEX];
      FieldValues[DFNEI_IP] := cdsSource.FieldValues[DFNEI_IP];
      FieldValues[DFNEI_PORT] := cdsSource.FieldValues[DFNEI_PORT];
      { TODO : need complete }
      FieldValues[DFNEI_STATUS] := myStrToint(cdsSource.FieldValues[DFNEI_STATUS]);
      FieldValues[DFNEI_REMAINTIME] := cdsSource.FieldValues[DFNEI_REMAINTIME];
      FieldValues[DFNEI_TIMESTAMP] := cdsSource.FieldValues[DFNEI_TIMESTAMP];
      FieldValues[DFNEI_SCORE] := score;
      //scoreStream.Position :=0;
      //(FieldByName(DFNEI_SCOREINFO) as TBlobField).LoadFromStream(scoreStream);
      (FieldByName(DFNEI_SCOREINFO) as TBlobField).Assign(cdsSource);
      post;
    end;
  end;
begin
  edtUpdateNum.Text:='0';
  edtInsertNum.Text :='0';
  edtTime.Text :='0';
  btnScore.Enabled := false ;
  if edtSource.Text<>'' then begin
    //清空当前数据集
    if dmMain.cdsSource.Active then begin
      dmMain.connSource.Connected:=false;
      //dmMain.cdsSource.EmptyDataSet;
      dmMain.cdsSource.Active := false;
    end;
    //设置源数据集
    if SetSourceConn(edtSource.Text) then begin
      dmmain.cdsSource.IndexFieldNames :='';
      DecryptExamineeInfoCDS(dmMain.cdsSource,true);
      dmmain.cdsSource.IndexFieldNames :=DFNEI_EXAMINEEID;
    end;      
  end else application.MessageBox('上报库路径为空','错误');
  //打开汇总成绩库
  dmMain.cdsScore.Active := false;
  dmMain.dsScore.DataSet:=nil;
  dmMain.cdsScore.Active := true;
  dmMain.cdsScore.IndexFieldNames := DFNEI_EXAMINEEID;
   Timer1.Enabled := true;
  scoreStream := TMemoryStream.Create;
  try
    with dmMain.cdsSource do begin
      first;
      while not eof do begin
        edtRecno.Text := inttostr(dmMain.cdsSource.RecNo);    //显示当前源数据库记录号
        application.ProcessMessages;
        scoreStream.Clear;
        (fieldbyname(DFNEI_SCOREINFO) as TBlobField).SaveToStream(scoreStream);
        //UnCompressStream(scorestream);
        score := GetScoreValue(scoreStream);
        if dmMain.cdsScore.Locate(DFNEI_EXAMINEEID,dmMain.cdsSource.FieldValues[DFNEI_EXAMINEEID],[ loCaseInsensitive ]) then  begin
          //更新数据
          if score >dmMain.cdsScore.FieldByName(DFNEI_SCORE).AsInteger then
          begin
            SoureToTotal(dmMain.cdsSource,dmMain.cdsScore,score);//,scoreStream);
            edtUpdateNum.Text := inttostr(strtoint(edtUpdateNum.Text)+1); //显示更新记录数
          end;
        end else  begin    //添加新数据
             dmMain.cdsScore.AppendRecord([FieldValues[DFNEI_EXAMINEEID] ]);
             SoureToTotal(dmMain.cdsSource,dmMain.cdsScore,score);//,scoreStream);
             edtInsertNum.Text := inttostr(strtoint(edtInsertNum.Text)+1); //显示添加记录数
        end;
        next;
      end;
       if  dmmain.cdsScore.ApplyUpdates(0) =0 then    begin
         Timer1.Enabled := false;
         application.MessageBox('update complete','info')
       end   else   begin
         Timer1.Enabled := false;
         application.MessageBox('update error','error');
       end;
    end;
  finally
    scoreStream.Free;
    btnScore.Enabled := true ;
  end;
end;

procedure TfrmScoreReceive.edtSourceClick(Sender: TObject);
begin
  if  opendialog1.Execute then
    edtSource.Text := OpenDialog1.FileName
  else
    edtsource.Text := '';
end;

procedure TfrmScoreReceive.Timer1Timer(Sender: TObject);
begin
   edtTime.Text :=  inttostr(strtoint(edttime.text)+1);
end;


function TfrmScoreReceive.GetScoreValue(const scoreStream: TMemoryStream) : Integer;
var
  ScoreIni:TScoreIni;
begin
  ScoreIni := TScoreIni.Create;
  try
    ScoreIni.LoadFormStream(scoreStream);
    result  := ScoreIni.GetScoreValue;
  finally
    ScoreIni.Free;
  end;
end;

end.
