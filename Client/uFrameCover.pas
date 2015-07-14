unit uFrameCover;

interface

uses
   Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
   Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, CnButtons, Vcl.ExtCtrls, Vcl.StdCtrls, JvExControls, JvSpeedButton;

type
   TFrameCover = class(TFrame)
      Panel1 : TPanel;
      btnStartExam : TJvSpeedButton;
    GridPanel1: TGridPanel;
    Panel2: TPanel;
    imgExaminee: TImage;
    txtExamineeName: TStaticText;
    txtExamineeNo: TStaticText;
    txtExamineeSex: TStaticText;
      procedure btnStartExamClick(Sender : TObject);
   private
      { Private declarations }
   public
      { Public declarations }
   end;

implementation

uses
   examClientGlobal;

{$R *.dfm}

procedure TFrameCover.btnStartExamClick(Sender : TObject);
   begin
      TexamClientGlobal.ClientMainForm.CloseCover;
   end;

end.
