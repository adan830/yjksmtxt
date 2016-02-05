program centralScore;

uses
  Forms,
  ufrmMain in 'ufrmMain.pas' {frmMain},
  ufrmGrade in 'ufrmGrade.pas' {frmGrade},
  publicunit in 'publicunit.pas',
  udmMain in 'udmMain.pas' {dm1: TDataModule},
  CentralGrade in 'CentralGrade.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(Tdm1, dm1);
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TfrmGrade, frmGrade);
  //Application.CreateForm(TTypeForm1, TypeForm1);
  Application.Run;
end.
