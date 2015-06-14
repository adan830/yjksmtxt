unit FrameTQModule;

interface

uses
	Vcl.Forms, FrameTQButtons, System.Classes,Commons, Vcl.Controls;

type
	TFrameTQModule = class(TFrame)
	private
		hasTQButtons: Boolean;
    moduleID:TExamModule;
		frameTQButtons: TFrameTQButtons;
    tqList:TList;
    procedure SetupTqList;

	public
		constructor Create(AOwner: TComponent);override ;
	 	//constructor Create(AOwner: TComponent;em:TExamModule); overload;
    destructor Destroy; override;
	end;

implementation

uses
  ExamGlobal,Data.DB,tq,DataUtils,System.SysUtils,
  DataFieldConst, System.Variants, FrameworkUtils;
{ TFrameTQModule }

constructor TFrameTQModule.Create(AOwner: TComponent);
begin
	inherited;

end;



//constructor TFrameTQModule.Create(AOwner: TComponent;em: TExamModule);
//begin
////todo: ---
//	inherited Create(AOwner);
//  moduleID:=em;
//
//  tqList:=TList.Create;
//  SetupTqList;
//  if hasTQButtons then
//  begin
//		frameTQButtons := TFrameTqbuttons.Create(self);
//    FrameTQButtons.Count:=tqList.Count;
//  end;
//end;

destructor TFrameTQModule.Destroy;
begin
	if frameTQButtons<>nil then
  	frameTQButtons.Free;
  tqList.Free;
  inherited;
end;

procedure TFrameTQModule.SetupTqList;
var
  i,rs:integer;
  mynodePtr:PTQTreeNode;
  ds : TDataSet;
  stPrefix:string;
begin
      stPrefix:=ExamModuleToStPrefixWildCard(self.moduleID);
     // ds := getdatasetbyprefix(stPrefix,TExamClientGlobal.ConnClientDB);
      try
        rs:=ds.RecordCount;
        DS.First;
        for  i:=1 to rs do
        begin
         with ds do
         begin
          new(mynodePtr);
          mynodePtr.TQ := TTQ.Create;
          TTQ.WriteFieldValuesToTQ(DS,mynodePtr^.TQ);

          mynodePtr^.TQ.UnCompressTQ();
          mynodePtr^.CodeText := '第'+inttostr(i)+'小题:';
          mynodeptr^.txFlag:=False;  //已弃用
          if FieldValues[DFNTQ_KSDA]=null then
          begin
             mynodePtr^.ksda:='';
             mynodePtr^.flag:=false;
          end
          else
          begin
             mynodePtr^.ksda:=FieldValues[DFNTQ_KSDA];
             mynodePtr^.flag:=true;
          end;
            tqList.Add(mynodePtr);
          Next;
         end;
        end;
      finally
        ds.Free;
      end;
end;

end.
