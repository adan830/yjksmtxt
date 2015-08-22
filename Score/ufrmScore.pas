unit ufrmScore;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cxStyles, cxCustomData, cxGraphics, cxFilter, cxData, cxDataStorage,
  cxEdit, DB, cxDBData, cxLookAndFeelPainters, StdCtrls, cxButtons,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGridLevel,
  cxClasses, cxControls, cxGridCustomView, cxGrid, cxMemo, cxBlobEdit,
  cxDropDownEdit;

type
  TfrmScore = class(TForm)
    tvscore: TcxGridDBTableView;
    cxGrid1Level1: TcxGridLevel;
    cxGrid1: TcxGrid;
    cxButton1: TcxButton;
    cxButton2: TcxButton;
    tvscorezkh: TcxGridDBColumn;
    tvscorexm: TcxGridDBColumn;
    tvscorezsj: TcxGridDBColumn;
    tvscorestatus: TcxGridDBColumn;
    tvscorexz1_fs: TcxGridDBColumn;
    tvscorepd_fs: TcxGridDBColumn;
    tvscoredz_fs: TcxGridDBColumn;
    tvscorewin_fs: TcxGridDBColumn;
    tvscoreword_fs: TcxGridDBColumn;
    tvscoreexcel_fs: TcxGridDBColumn;
    tvscoreppt_fs: TcxGridDBColumn;
    tvscoreie_fs: TcxGridDBColumn;
    tvscorezf: TcxGridDBColumn;
    tvscorexzinfo: TcxGridDBColumn;
    tvscorepdinfo: TcxGridDBColumn;
    tvscoredzinfo: TcxGridDBColumn;
    tvscorewininfo: TcxGridDBColumn;
    tvscorewordinfo: TcxGridDBColumn;
    tvscoreexcelinfo: TcxGridDBColumn;
    tvscorepptinfo: TcxGridDBColumn;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure cxButton1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmScore: TfrmScore;

implementation

uses udmMain;

{$R *.dfm}

procedure TfrmScore.cxButton1Click(Sender: TObject);
begin
  dmMain.dsScore.DataSet := dmMain.cdsScore;
  dmMain.cdsScore.Active := false;
  dmMain.cdsScore.IndexFieldNames:='zkh';
  dmmain.cdsScore.Active := true;
end;

procedure TfrmScore.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  dmmain.dsScore.DataSet:=nil;
end;

end.
