unit ExcelGrade;

interface

uses uGrade,Classes, ufrmInProcess, ExamGlobal;
       { TODO -ojp -cexcell : 需添加对条件格式的支持 }
       { TODO -ojp -cexcell : 字符下划线无用}
       { TODO -ojp -cexcell : 需添加对筛选的支持}
       { TODO -ojp -cexcell : 关于排序会影响其它知识点的问题 }
       { TODO -ojp -cexcell : 关于多sheet表访问的问题 }
       { TODO -ojp -cexcel : 页面知识点，页眉页脚 }

 function FillGrades(GradeInfoStrings:TStrings;APath:string;AFileName:string; AOnProcess:TOnProcess=nil;aFillMode : TFillGradeMode = fmExamValue;ANeedCloseDoc:Boolean =true):Integer; stdcall;
 function OpenDoc(AFileName: string; var AExcelApp: Variant; var AWorkBook: Variant; var AWorkSheet: Variant; out AIsDocOpened: Boolean):Integer;
 function IsFileOpened(AFileName: string; var AExcelApp: Variant; var AWorkBook: Variant; var AWorkSheet: Variant; out AIsDocOpened: Boolean): boolean;

 function FillFontGradeInfo(AWordBook, AWorkSheet: Variant; var GradeInfo: TGradeInfo; aFillMode : TFillGradeMode): Integer;   //字体评分
  function FillChartGradeInfo(AWordBook, AWorkSheet: Variant; var GradeInfo: TGradeInfo; aFillMode : TFillGradeMode): Integer;   //图表评分
  function FillCellGradeInfo(AWordBook, AWorkSheet: Variant; var GradeInfo: TGradeInfo; aFillMode : TFillGradeMode): Integer;   //单元格评分
  function FillSheetGradeInfo(AWordBook, AWorkSheet: Variant; var GradeInfo: TGradeInfo; aFillMode : TFillGradeMode): Integer;   //工作表评分
  function FillBorderGradeInfo(AWordBook, AWorkSheet:Variant;var GradeInfo: TGradeInfo;aFillMode : TFillGradeMode): Integer;   //边框评分
  function FillInteriorGradeInfo(AWordBook, AWorkSheet:Variant;var GradeInfo: TGradeInfo;aFillMode : TFillGradeMode): Integer;   //底纹
  function strObjtoStrings(strObj:String):TStrings;
  //调用Word获得参数值，填充GradeInfo记录
  //本函数调用一系列子类函数      //afillmode: -1:standardvalue 1: examinevalue
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
         AOnProcess(Format(RSScoring,['Excel操作题']),0);
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
           if Assigned(AOnProcess) then AOnProcess(Format(RSScoring,['Excel操作题']),gradeinfo.Points);
           sleep(100);
         end;    // for
      finally // wrap up
       if  (ANeedCloseDoc or not isDocOpened) then
         CloseExcelApp(ExcelApp,WorkBook)  //退出Word程序
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
    100: value := vartostr(MyCell.Formula);                 //公式
    101: value := vartostr(MyCell.NumberFormat);            //数字格式
    102: value := vartostr(MyCell.HorizontalAlignment);     //水平对齐
    103: value := vartostr(MyCell.VerticalAlignment);       //垂直对齐
    104: value := vartostr(MyCell.Mergecells);              //合并单元格
    105: value := vartostr(MyCell.orientation);             //文字旋转角度
    106: value := vartostr(MyCell.WrapText);                //自动换行
    107: value := vartostr(MyCell.ColumnWidth);             //列宽
    {TODO 设置行高没有用？？？？？}
    108: value := vartostr(MyCell.RowHeight);               //行高
    109: value := vartostr(MyCell.UseStandardwidth);                //使用标准列宽
    110: value := vartostr(MyCell.UseStandardHeight);                //使用标准行高
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
              value := strFilter(chartObj.ChartTitle.Caption,GetModuleDelimiterChar()) //文本内容
            else
              value := '';
          end;
      { TODO -ojp -cexcel : 这里需要完善知识点 }
      51: value := chartobj.charttype;  //图表类型
      52: value := chartobj.charttype;  //数据系列名称
      53: value := chartobj.charttype;  //数据系列公式
      54: begin
            if ChartObj.axes(1).hastitle then
              value := chartObj.axes(1).axistitle.Caption //X坐标轴名称
            else
              value := '';
          end;
      55: begin
            if ChartObj.axes(2).hastitle then
              value :=  chartObj.axes(2).axistitle.Caption //y坐标轴名称
            else
              value := '';
          end;
      56: value := vartostr(chartObj.SeriesCollection.count);  //系列数
      57: value := vartostr(chartObj.SeriesCollection(1).formula);  //系列数  公式
      58: begin
            if ChartObj.haslegend then
              value := chartObj.legend.position //图例位置
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
 { TODO -ojp -cexcell : 关于16知识点字体阴影的问题，不知excell中是否可设置，也就是不一定有这个知识点 }
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
    10: value := vartostr(MyRange.text);   //文本内容
    11: value := vartostr(myRange.font.name);   //字体 名
    12: value := vartostr(MyRange.font.size);   //字号
    13: value := vartostr(MyRange.font.color); //颜色
    14: value := vartostr(MyRange.font.italic);  //斜体
    15: value := vartostr(MyRange.font.bold);  //粗体
    16: value := vartostr(myrange.font.shadow); //阴影
    17: value := vartostr(myrange.font.underline); //下划线
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
   // gradeinfo.Items[0].param1:='错误，可能是文档未打开';
  end;
end;

function FillSheetGradeInfo(AWordBook, AWorkSheet: Variant; var GradeInfo: TGradeInfo; aFillMode : TFillGradeMode): Integer;
var
  Mysheet:variant;
  value : String;
begin
  Mysheet:=AWorkSheet;
  case GradeInfo.ID of
    150: value := vartostr(Mysheet.name);                 //工作表名
    151: value := vartostr(Mysheet.standardwidth);        //工作表标准列宽
    152: value := vartostr(Mysheet.standardheight);       //工作表标准行高
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
          1: edgeindex := $00000008;   // 上
          2: edgeindex := $00000009;   // 下
          3: edgeindex := $00000007;   // 左
          4: edgeindex := $0000000A;   // 右
          5: edgeindex := $0000000C;   // 内横线
          6: edgeindex := $0000000B;   // 内竖线
//          7:
//          8:
        end;    // case
      end
      else
      begin
        edgeindex :=0 ;     //整体统一边框
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
    30: value := vartostr(objInterior.color);   //底纹颜色
    31: value := vartostr(objInterior.pattern);   //底纹图案
    32: value := vartostr(objInterior.PatternColor);   //底纹图案颜色
  end;
  if aFillMode = fmStandValue then
    GradeInfo.StandardValue:=value
  else
    GradeInfo.ExamineValue:=value;
  result:=-1;
end;

end.
