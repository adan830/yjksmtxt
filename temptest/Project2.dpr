program Project2;

uses
  fastMM4,
  Vcl.Forms,
  Unit2 in 'Unit2.pas' {Form2};

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown:=DebugHook<>0;
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
