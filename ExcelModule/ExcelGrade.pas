unit ExcelGrade;

interface

uses uGrade,Classes, ufrmInProcess, ExamGlobal;
       { TODO -ojp -cexcell : ����Ӷ�������ʽ��֧�� }
       { TODO -ojp -cexcell : �ַ��»�������}
       { TODO -ojp -cexcell : ����Ӷ�ɸѡ��֧��}
       { TODO -ojp -cexcell : ���������Ӱ������֪ʶ������� }
       { TODO -ojp -cexcell : ���ڶ�sheet����ʵ����� }
       { TODO -ojp -cexcel : ҳ��֪ʶ�㣬ҳüҳ�� }

 function FillGrades(GradeInfoStrings:TStrings;APath:string;AFileName:string; AOnProcess:TOnProcess=nil;aFillMode : TFillGradeMode = fmExamValue;ANeedCloseDoc:Boolean =true):Integer; stdcall;
 function OpenDoc(AFileName: string; var AExcelApp: Variant; var AWorkBook: Variant; var AWorkSheet: Variant; out AIsDocOpened: Boolean):Integer;
 function IsFileOpened(AFileName: string; var AExcelApp: Variant; var AWorkBook: Variant; var AWorkSheet: Variant; out AIsDocOpened: Boolean): boolean;

 function FillFontGradeInfo(AWordBook, AWorkSheet: Variant; var GradeInfo: TGradeInfo; aFillMode : TFillGradeMode): Integer;   //��������
  function FillChartGradeInfo(AWordBook, AWorkSheet: Variant; var GradeInfo: TGradeInfo; aFillMode : TFillGradeMode): Integer;   //ͼ������
  function FillCellGradeInfo(AWordBook, AWorkSheet: Variant; var GradeInfo: TGradeInfo; aFillMode : TFillGradeMode): Integer;   //��Ԫ������
  function FillSheetGradeInfo(AWordBook, AWorkSheet: Variant; var GradeInfo: TGradeInfo; aFillMode : TFillGradeMode): Integer;   //����������
  function FillBorderGradeInfo(AWordBook, AWorkSheet:Variant;var GradeInfo: TGradeInfo;aFillMode : TFillGradeMode): Integer;   //�߿�����
  function FillInteriorGradeInfo(AWordBook, AWorkSheet:Variant;var GradeInfo: TGradeInfo;aFillMode : TFillGradeMode): Integer;   //����
  function strObjtoStrings(strObj:String):TStrings;
  //����Word��ò���ֵ�����GradeInfo��¼
  //����������һϵ�����ຯ��      //afillmode: -1:standardvalue 1: examinevalue
  function FillKeyGradeInfo(AWordBook, AWorkSheet: Variant; var gradeinfo: TGradeInfo; aFillMode : TFillGradeMode): Integer;
  function connect(var AExcelApp:Variant):integer;
  function  CloseExcelApp(AExcelApp:Variant;AWorkBook:Variant):Integer;
  function DisConnect(var AExcelApp, AWorkBook, AWorkSheet: Variant):integer;
implementation

uses sysutils,Variants,comobj,ActiveX, ExcelTest, Commons, ExamException, 
  ExamResourceStrings;

function FillGrades(GradeInfoStrings:TStrings;APath:string;AFileName:string; AOnProcess:TOnProcess=nil;aFillMode : TFillGradeMode = fmExamValue;ANeedCloseDoc:Boolean =true):Integer; stdcall;
var
  I: Integer;
  GradeInfo:TGradeInfo;
  ExcelApp:Variant;
  WorkBook:Variant;
  WorkSheet:Variant;
  isDocOpened:Boolean;
  filename:string;
begin
   try
      if Assigned(AOnProcess) then
         AOnProcess(Format(RSScoring,['Excel������']),0);
      ExcelApp := null;
      WorkBook := null;
      WorkSheet:= null;
      if AFileName = NULL_STR then  AFileName := DOCNAME;
      filename := IncludeTrailingPathDelimiter(aPath)+AFileName;
      EFileNotExistException.IfFalse(FileExists(filename),Format(RSFileNotExist,[filename]));
      Connect(ExcelApp);
      OpenDoc(filename,ExcelApp, WorkBook, WorkSheet, isDocOpened );
      try
         //WordGrade.FileName:=filename;
         for I := 0 to GradeInfoStrings.Count - 1 do    // Iterate
         begin
           StrToGradeInfo(GradeInfoStrings.Strings[i],GradeInfo,'~');
           FillKeyGradeInfo(WorkBook,WorkSheet,GradeInfo,aFillMode );
           GradeInfoStrings[i] := GradeInfoToStr(GradeInfo,'~');
           if Assigned(AOnProcess) then AOnProcess(Format(RSScoring,['Excel������']),gradeinfo.Points);
           sleep(100);
         end;    // for
      finally // wrap up
       if  (ANeedCloseDoc or not isDocOpened) then
         CloseExcelApp(ExcelApp,WorkBook)  //�˳�Word����
       else ExcelApp.Visible := True;
      end;    // try/finallyend;
   except
      on E:Exception do
         EGradeException.Toss(Format(RsGradeError,[GetModuleDllName,e.Message]));
   end;

end;
{ TExcelGrade }

function  CloseExcelApp(AExcelApp:Variant;AWorkBook:Variant):Integer;
begin
  AWorkBook :=null;
  AExcelApp.quit;
  AExcelApp :=null;
end;

function  DisConnExcelApp(AExcelApp:Variant;AWorkBook:Variant):Integer;
begin
  AWorkBook :=null;
  AExcelApp :=null;
end;

function connect(var AExcelApp:Variant):integer;
var
  Unknown: IUnknown;
  ClassID: TCLSID;
begin
  if (varType(AExcelApp)=varEmpty)or(varType(AExcelApp)=varNull)  then
  begin
    ClassID := ProgIDToClassID('excel.application');
    if not Succeeded(GetActiveObject(ClassID, nil, Unknown)) then
        Unknown := CreateComObject(ClassId);
    AExcelapp:=Unknown as IDispatch ;
  end;
end;

function DisConnect(var AExcelApp, AWorkBook, AWorkSheet: Variant):integer;
begin   
  if (not(varType(AWorkSheet)=varEmpty))and(not(varType(AWorkSheet)=varNull))  then   AWorkSheet :=null;
  if  (not(varType(AWorkBook)=varEmpty))and(not(varType(AWorkBook)=varNull))  then  AWorkBook :=null;
  if  (not(varType(AExcelApp)=varEmpty))and(not(varType(AExcelApp)=varNull))  then
  begin
    AExcelApp.visible:=true;
    AExcelApp :=null
  end;
end;

function FillCellGradeInfo(AWordBook, AWorkSheet: Variant; var GradeInfo: TGradeInfo; aFillMode : TFillGradeMode): Integer;
var
  MyCell:variant;
  value : String;
begin
  MyCell:=AWorkSheet.range[GradeInfo.ObjStr,GradeInfo.ObjStr];
  case GradeInfo.ID of
    100: value := vartostr(MyCell.Formula);                 //��ʽ
    101: value := vartostr(MyCell.NumberFormat);            //���ָ�ʽ
    102: value := vartostr(MyCell.HorizontalAlignment);     //ˮƽ����
    103: value := vartostr(MyCell.VerticalAlignment);       //��ֱ����
    104: value := vartostr(MyCell.Mergecells);              //�ϲ���Ԫ��
    105: value := vartostr(MyCell.orientation);             //������ת�Ƕ�
    106: value := vartostr(MyCell.WrapText);                //�Զ�����
    107: value := vartostr(MyCell.ColumnWidth);             //�п�
    {TODO �����и�û���ã���������}
    108: value := vartostr(MyCell.RowHeight);               //�и�
    109: value := vartostr(MyCell.UseStandardwidth);                //ʹ�ñ�׼�п�
    110: value := vartostr(MyCell.UseStandardHeight);                //ʹ�ñ�׼�и�
  end;
  if aFillMode = fmStandValue then
    GradeInfo.StandardValue:=value
  else
    GradeInfo.ExamineValue:=value;
  result:=-1;  
end;

function FillChartGradeInfo(AWordBook, AWorkSheet: Variant; var GradeInfo: TGradeInfo; aFillMode : TFillGradeMode): Integer;
var
  index : integer;
  ChartObj : variant;
  value : string;
begin
  if AWorkSheet.Chartobjects.count>=strtoint(GradeInfo.ObjStr) then
  begin
    ChartObj:=AWorkSheet.chartobjects(1).chart;
  
    case GradeInfo.ID of
      50: begin
            if ChartObj.hastitle then
              value := strFilter(chartObj.ChartTitle.Caption,GetModuleDelimiterChar()) //�ı�����
            else
              value := '';
          end;
      { TODO -ojp -cexcel : ������Ҫ����֪ʶ�� }
      51: value := chartobj.charttype;  //ͼ������
      52: value := chartobj.charttype;  //����ϵ������
      53: value := chartobj.charttype;  //����ϵ�й�ʽ
      54: begin
            if ChartObj.axes(1).hastitle then
              value := chartObj.axes(1).axistitle.Caption //X����������
            else
              value := '';
          end;
      55: begin
            if ChartObj.axes(2).hastitle then
              value :=  chartObj.axes(2).axistitle.Caption //y����������
            else
              value := '';
          end;
      56: value := vartostr(chartObj.SeriesCollection.count);  //ϵ����
      57: value := vartostr(chartObj.SeriesCollection(1).formula);  //ϵ����  ��ʽ
      58: begin
            if ChartObj.haslegend then
              value := chartObj.legend.position //ͼ��λ��
            else
              value := '';
          end;
    end;
  end
  else
  begin
    value:='';
  end;
  if aFillMode = fmStandValue then
    GradeInfo.StandardValue:=value
  else
    GradeInfo.ExamineValue:=value;

  result:=-1;
end;
 { TODO -ojp -cexcell : ����16֪ʶ��������Ӱ�����⣬��֪excell���Ƿ�����ã�Ҳ���ǲ�һ�������֪ʶ�� }
function FillFontGradeInfo(AWordBook, AWorkSheet: Variant; var GradeInfo: TGradeInfo; aFillMode : TFillGradeMode): Integer;
var
  value:string;
  cell1,cell2:olevariant;
  myrange:variant;
begin
  cell1:=GradeInfo.ObjStr;
  cell2:=cell1;
  myrange :=AWorkSheet.Range[cell1,cell2];
  case GradeInfo.ID of
    10: value := vartostr(MyRange.text);   //�ı�����
    11: value := vartostr(myRange.font.name);   //���� ��
    12: value := vartostr(MyRange.font.size);   //�ֺ�
    13: value := vartostr(MyRange.font.color); //��ɫ
    14: value := vartostr(MyRange.font.italic);  //б��
    15: value := vartostr(MyRange.font.bold);  //����
    16: value := vartostr(myrange.font.shadow); //��Ӱ
    17: value := vartostr(myrange.font.underline); //�»���
  end;
  if aFillMode = fmStandValue then
    GradeInfo.StandardValue:=value
  else
    GradeInfo.ExamineValue:=value;
  result:=-1;
end;

function FillKeyGradeInfo(AWordBook, AWorkSheet: Variant; var gradeinfo: TGradeInfo; aFillMode : TFillGradeMode): Integer;
begin
  try
    case GradeInfo.ID of
       10..15    : result := FillFontGradeInfo(AWordBook,AWorkSheet,gradeinfo,aFillMode);
       20..22    : result := FillBorderGradeInfo(AWordBook,AWorkSheet,gradeinfo,aFillMode);
       30..32    : result := FillInteriorGradeInfo(AWordBook,AWorkSheet,gradeinfo,aFillMode);
       50..70    : result := FillChartGradeInfo(AWordBook,AWorkSheet,gradeinfo,aFillMode);
       100..110    : result := FillCellGradeInfo(AWordBook,AWorkSheet,gradeinfo,aFillMode);
       150..160    : result := FillSheetGradeInfo(AWordBook,AWorkSheet,gradeinfo,aFillMode);
    end;
    if aFillMode =fmExamValue then
    begin
      if GradeInfo.StandardValue=GradeInfo.ExamineValue then
        GradeInfo.IsRight:=-1
      else
        GradeInfo.IsRight:=0;
    end;

  except
   // gradeinfo.Items[0].param1:='���󣬿������ĵ�δ��';
  end;
end;

function FillSheetGradeInfo(AWordBook, AWorkSheet: Variant; var GradeInfo: TGradeInfo; aFillMode : TFillGradeMode): Integer;
var
  Mysheet:variant;
  value : String;
begin
  Mysheet:=AWorkSheet;
  case GradeInfo.ID of
    150: value := vartostr(Mysheet.name);                 //��������
    151: value := vartostr(Mysheet.standardwidth);        //�������׼�п�
    152: value := vartostr(Mysheet.standardheight);       //�������׼�и�
  end;
  if aFillMode = fmStandValue then
    GradeInfo.StandardValue:=value
  else
    GradeInfo.ExamineValue:=value;
  result:=-1;
end;

function IsFileOpened(AFileName: string; var AExcelApp: Variant; var AWorkBook: Variant; var AWorkSheet: Variant; out AIsDocOpened: Boolean): boolean;
var
  I: Integer;
  WorkBookCount:integer;
begin
  result:=false;
  AIsDocOpened := False;
  if (varType(AWorkBook)=varEmpty)or(varType(AWorkBook)=varNull)  then
  begin
    WorkBookCount:=AExcelApp.Workbooks.Count;
    if  WorkBookCount>0 then
     begin
       for I := 1 to WorkBookCount do    // Iterate
       begin
         AWorkBook := AExcelApp.WorkBooks.item[i];
         if AFileName=(AWorkBook.path+'\'+AWorkBook.name) then
         begin
           result:=true;
           AIsDocOpened := True;
           if (varType(AWorkSheet)=varEmpty)or(varType(AWorkSheet)=varNull) then
              AWorkSheet:=AWorkBook.worksheets.item[1];
           exit;
         end;
       end;    // for
       AWorkBook:=null;
       AWorkSheet:=null;
     end;
  end
  else
  begin
    result:=true;
    AIsDocOpened := True;
  end;
end;


function OpenDoc(AFileName: string; var AExcelApp: Variant; var AWorkBook: Variant; var AWorkSheet: Variant; out AIsDocOpened: Boolean):Integer;
begin
  if not IsFileOpened(AFileName, AExcelApp, AWorkBook, AWorkSheet,AIsDocOpened )  then
  begin
     AExcelApp.WorkBooks.Open(AFileName);
     AWorkBook :=AExcelApp.activeWorkBook;
     AWorkSheet:=AExcelApp.activeWorkBook.activeSheet;
  end;
end;

function FillBorderGradeInfo(AWordBook, AWorkSheet:Variant;var GradeInfo: TGradeInfo;aFillMode : TFillGradeMode): Integer;
var
  value:string;
  cell1,cell2:olevariant;
  myrange:variant;
  objstrings:TStrings;
  edgeindex:cardinal;
begin
  objstrings := strObjtoStrings(gradeinfo.ObjStr);
  if objstrings<>nil then
  begin
    cell1:=objstrings.Strings[0];
    cell2:=cell1;
    myrange := AWorkSheet.Range[cell1,cell2];
    try
      if objstrings.Count=2 then
      begin
        case strtoint(objstrings.Strings[1]) of    //
          1: edgeindex := $00000008;   // ��
          2: edgeindex := $00000009;   // ��
          3: edgeindex := $00000007;   // ��
          4: edgeindex := $0000000A;   // ��
          5: edgeindex := $0000000C;   // �ں���
          6: edgeindex := $0000000B;   // ������
//          7:
//          8:
        end;    // case
      end
      else
      begin
        edgeindex :=0 ;     //����ͳһ�߿�
      end;
    finally // wrap up
      objstrings.Free;
    end;    // try/finally
    case gradeinfo.ID of    //
      20: begin
            if edgeindex=0 then
            begin
              value := vartostr(myrange.borders.linestyle);
            end
            else
            begin
              value := vartostr(myrange.borders.item[edgeindex].linestyle);
            end;
          end;
     
      21: begin
            if edgeindex=0 then
            begin
              value := vartostr(myrange.borders.color);
            end
            else
            begin
              value := vartostr(myrange.borders.item[edgeindex].color);
            end;
          end;
      22: begin
            if edgeindex=0 then
            begin
              value := vartostr(myrange.borders.weight);
            end
            else
            begin
              value := vartostr(myrange.borders.item[edgeindex].weight);
            end;
          end;
    end;    // case
  end;
  if aFillMode = fmStandValue then
    GradeInfo.StandardValue:=value
  else
    GradeInfo.ExamineValue:=value;
  result:=-1;
end;

function strObjtoStrings(strObj: String): TStrings;
var
  ObjStrings:TStringList;
begin
  result := nil;
  objstrings:=TStringlist.Create;
  try
    objstrings.Delimiter:='-';
    objstrings.DelimitedText:=strObj;
    result := objstrings;
  except // wrap up
    objstrings.Free;
  end;    // try/except
end;

function FillInteriorGradeInfo(AWordBook, AWorkSheet:Variant;var GradeInfo: TGradeInfo;aFillMode : TFillGradeMode): Integer;
var
  value:string;
  cell1,cell2:olevariant;
  objInterior:variant;
begin
  cell1:=GradeInfo.ObjStr;
  cell2:=cell1;
  objInterior := AWorkSheet.Range[cell1,cell2].interior;
  case GradeInfo.ID of
    30: value := vartostr(objInterior.color);   //������ɫ
    31: value := vartostr(objInterior.pattern);   //����ͼ��
    32: value := vartostr(objInterior.PatternColor);   //����ͼ����ɫ
  end;
  if aFillMode = fmStandValue then
    GradeInfo.StandardValue:=value
  else
    GradeInfo.ExamineValue:=value;
  result:=-1;
end;

end.
