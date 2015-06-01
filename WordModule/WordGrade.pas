unit WordGrade;

interface

uses
  Classes,ActiveX,uGrade,word2000, ufrmInProcess,ExamGlobal;
                   { TODO -cALL : ��������Ϣ�ı��У�һ������������ַ�����Ҫ���ˣ��Ա�֤����һ�����쳣 }
                                      { TODO -cALL : ����ʱ����Щ���⣬��������� }
   function FillGrades(GradeInfoStrings:TStrings;APath:string;AFileName:string; AOnProcess:TOnProcess=nil;aFillMode : TFillGradeMode = fmExamValue;ANeedCloseDoc:Boolean =true):Integer; stdcall;

   function OpenDoc(AFileName: string; var AWordApp: TWordApplication; var AWordDoc: TWordDocument; out AIsDocOpened: Boolean):Integer;
   //amode: -1:standardvalue 1: examinevalue
   function FillKeyFontGradeInfo(AWordDoc:TWordDocument; var GradeInfo: TGradeInfo;AFillMode:TFillGradeMode): Integer;   //��������
   function FillKeyParagraphGradeInfo(AWordDoc:TWordDocument;var GradeInfo:TGradeInfo;AFillMode:TFillGradeMode) : integer; //��������
   function FillKeyTableGradeInfo(AWordDoc:TWordDocument;var GradeInfo:TGradeInfo;AFillMode:TFillGradeMode): Integer;  //�������
   function FillKeyPageGradeInfo(AWordDoc:TWordDocument;var GradeInfo:TGradeInfo;AFillMode:TFillGradeMode): Integer;
   function FillKeyHeaderFooterGradeInfo(AWordDoc:TWordDocument;var GradeInfo:TGradeInfo;AFillMode:TFillGradeMode): Integer;
   function FillKeyPageNumberGradeInfo(AWordDoc:TWordDocument;var GradeInfo:TGradeInfo;AFillMode:TFillGradeMode): Integer;
   function FillKeyFindTotalGradeInfo(AWordDoc:TWordDocument;var GradeInfo:TGradeInfo;AFillMode:TFillGradeMode): Integer;
   function FillKeyTextFrameGradeInfo(AWordDoc:TWordDocument;var GradeInfo:TGradeInfo;AFillMode:TFillGradeMode): Integer;
   function FillKeyShapeGradeInfo(AWordDoc:TWordDocument;var GradeInfo:TGradeInfo;AFillMode:TFillGradeMode): Integer;

   function FillKeyShapeFillGradeInfo(AWordDoc:TWordDocument;var GradeInfo: TGradeInfo; AFillMode:TFillGradeMode): Integer;
   function FillKeyShapeLineGradeInfo(AWordDoc:TWordDocument;var GradeInfo: TGradeInfo; AFillMode:TFillGradeMode): Integer;
   function FillKeyShapeTextEffectGradeInfo(AWordDoc:TWordDocument;var GradeInfo: TGradeInfo;AFillMode:TFillGradeMode): Integer;
   function FillKeyTextPositionGradeInfo(AWordDoc:TWordDocument;var GradeInfo: TGradeInfo;AFillMode:TFillGradeMode): integer;

   procedure FindTextObj(AFindObj:Find;FindText: olevariant);
//   procedure setFileName(const Value: string);
   function IsFileOpened(AWordApp: TWordApplication; AWordDoc: TWordDocument; AFileName: string; out AIsDocOpened: Boolean): boolean;
   function DisConnectWordApp(AWordApp:TWordApplication;AWordDoc:TWordDocument):integer;
   function CloseWordApp(AWordApp:TWordApplication;AWordDoc:TWordDocument):integer;


   //function GetCurrentOpenDocFileName:string;

   //����Word��ò���ֵ�����GradeInfo��¼
   //����������һϵ�����ຯ��
   function FillKeyGradeInfo(AWordDoc:TWordDocument;var gradeinfo: TGradeInfo;AFillMode:TFillGradeMode): Integer;

   // Destroy; override;
implementation
uses SysUtils,Variants,  WordTest, Commons, ExamException,
  ExamResourceStrings;

function FillGrades(GradeInfoStrings:TStrings;APath:string;AFileName:string; AOnProcess:TOnProcess=nil;aFillMode : TFillGradeMode = fmExamValue;ANeedCloseDoc:Boolean =true):Integer; stdcall;
var
  I: Integer;
  GradeInfo:TGradeInfo;
  WordApp:TWordApplication;
  WordDoc:TWordDocument;
  isDocOpened : Boolean;
  filename :string;
begin
   try
      if Assigned(AOnProcess) then
         AOnProcess(Format(RSScoring,['Word������']),0);
      WordApp := nil;
      WordDoc := nil;
      if AFileName = NULL_STR then  AFileName := DOCNAME;
      filename := IncludeTrailingPathDelimiter(aPath)+AFileName;
      EFileNotExistException.IfFalse(FileExists(filename),Format(RSFileNotExist,[filename]));
      OpenDoc(filename,WordApp, WordDoc, isDocOpened);
      try
         for I := 0 to GradeInfoStrings.Count - 1 do    // Iterate
         begin
           StrToGradeInfo(GradeInfoStrings.Strings[i],GradeInfo);
           FillKeyGradeInfo(WordDoc,GradeInfo,aFillMode);
           GradeInfoStrings[i] := GradeInfoToStr(GradeInfo);
           if Assigned(AOnProcess) then AOnProcess(Format(RSScoring,['Word������']),gradeinfo.Points);
           sleep(100);
         end;
      finally
       if  (ANeedCloseDoc or not isDocOpened) then
         CloseWordApp(WordApp,WordDoc)  //�˳�Word����
       else begin
          WordApp.Visible := True;
          DisConnectWordApp(WordApp,worddoc);
          //CloseWordApp(WordApp,WordDoc)
       end;
      end;
   except
      on E:Exception do
         EGradeException.Toss(Format(RsGradeError,[GetModuleDllName,e.Message]));
   end;  

end;

function FillKeyGradeInfo(AWordDoc:TWordDocument;var gradeinfo: TGradeInfo;AFillMode:TFillGradeMode): Integer;
begin
  try
    case GradeInfo.ID of
       1..50    : result := FillKeyFontGradeInfo(AWordDoc,gradeinfo,AFillMode);
       51..100  : result := FillKeyParagraphGradeInfo(AWordDoc,gradeinfo,AFillMode);
       131..135 : FillKeyPageGradeInfo(AWordDoc,gradeinfo,AFillMode);
       181..186 : FillKeyPageNumberGradeInfo(AWordDoc,gradeinfo,AFillMode);
       191..194 : FillKeyHeaderFooterGradeInfo(AWordDoc,gradeinfo,AFillMode);
       151..180 : FillKeyTableGradeInfo(AWordDoc,gradeinfo,AFillMode);
        201     : FillKeyFindTotalGradeInfo(AWordDoc,gradeinfo,AFillMode);
       300..306 : FillKeyTextFrameGradeInfo(AWordDoc,GradeInfo,AFillMode);
       320..359 : FillKeyShapeGradeInfo(AWordDoc,GradeInfo,AFillMode);
       360..375 : FillKeyShapeFillGradeInfo(AWordDoc,GradeInfo,AFillMode);
       380..389 : FillKeyShapeLineGradeInfo(AWordDoc,GradeInfo,AFillMode);
       400..415 : FillKeyShapeTextEffectGradeInfo(AWordDoc,GradeInfo,AFillMode);
       450..451 : FillKeyTextPositionGradeInfo(AWordDoc,gradeinfo,AFillMode);
    end;
    if AFillMode=fmExamValue then
    begin
      if GradeInfo.StandardValue=GradeInfo.ExamineValue then
        GradeInfo.IsRight:=-1
      else
        GradeInfo.IsRight:=0;
    end;

  except
   // gradeinfo.Items[0].param1:='���󣬿������ĵ�δ��';
  end;
  result := -1;
end;

function FillKeyFontGradeInfo(AWordDoc:TWordDocument; var GradeInfo:TGradeInfo;AFillMode:TFillGradeMode): Integer;
var
  index: Integer;
  value:string;
  RangeObj :WordRange;
  FindObj :Find;
begin
  if GradeInfo.ID  in [1..50] then
  begin
    RangeObj:=AWordDoc.Content;
    FindObj:=RangeObj.find;
    FindTextObj(FindObj,GradeInfo.ObjStr);
  end;
  if FindObj.Found then
  begin
    case GradeInfo.ID of
      11: value:= RangeObj.Font.name;
      12: value:=FloatToStrF(RangeObj.Font.Size, ffFixed, 8, 3);
      13: value:=inttostr(RangeObj.Font.ColorIndex);
      14: value:=inttostr( RangeObj.Font.Italic);
      15: value:=inttostr( RangeObj.Font.Bold);
      16: value:= FloatToStrF(RangeObj.Font.Spacing, ffFixed, 8, 3);
      17: value:= inttostr(RangeObj.Font.Scaling);
      18: value:=inttostr(RangeObj.Font.Underline);
      30: value:=inttostr(RangeObj.shading.ForegroundPatternColorIndex);
      31: value:=inttostr(RangeObj.Shading.Texture);
      32: value:=inttostr(RangeObj.Shading.BackgroundPatternColorIndex);
    end;
    if AFillMode = fmStandValue then
      GradeInfo.StandardValue:=value
    else
      GradeInfo.ExamineValue:=value;
  end;
  result:=-1;
end;

function OpenDoc(AFileName: string; var AWordApp: TWordApplication; var AWordDoc: TWordDocument; out AIsDocOpened: Boolean):Integer;
var fn,confirmconversions,
    readonly,addtorecentfiles,
    passAWordDocument,passwordtemplate,revert,
    writepassAWordDocument,writepasswordtemplate,
    format,encoding,visible,index:olevariant;
    savechanges,originalformat,routeDocument:olevariant;
begin
   fn := AFileName;
  //����ĵ�δ�򿪣����
  //���filename=''ʱ��Ҫ���� ��������
  if AWordApp=nil then
     AWordApp:=Twordapplication.Create(nil);
  if AWordDoc=nil then
     AWordDoc:=TWordDocument.Create(nil);
  AWordApp.Visible:=false;
  if not IsFileOpened(AWordApp, AWordDoc, AFileName, AIsDocOpened ) then
  begin
      confirmconversions:=true;
      readonly:=false;
      addtorecentfiles:=true;
      passAWordDocument:='';
      passwordtemplate:='';
      revert:=true;
      writepassAWordDocument:='';
      writepasswordtemplate:='';
      format:=wdOpenFormatAuto;
      encoding:=true;
      visible:=true;
      index:=1;
      AWordDoc.ConnectTo(AWordApp.Documents.Open(fn,confirmconversions,readonly,
                      addtorecentfiles,passAWordDocument,passwordtemplate,
                      revert,writepassAWordDocument,writepasswordtemplate,
                      format,encoding,visible));
  end;
end;

procedure FindTextObj(AFindObj:Find;FindText:olevariant);
var
  MatchCase,
  MatchWholeWord,
  MatchWildcards,
  MatchSoundsLike,
  MatchAllWordForms,
  findforward,
  Wrap,
  Format,
  ReplaceWith,
  Replace      : OLEVariant;
  //MatchKashida,MatchDiacritics, MatchAlefHamza, MatchControl:olevariant;
begin
  MatchCase:=false; //case sensitive
  MatchWholeWord:=false;
  MatchWildcards:=false;
  MatchSoundsLike:=false;
  MatchAllWordForms:=false;
  findforward:=true;
  Wrap:=wdFindstop;
  Format:=false;
  ReplaceWith:='';
  Replace:=wdReplaceNone;
    // MatchKashida,MatchDiacritics, MatchAlefHamza, MatchControl;
     //RangeObj:=WordstDoc.Content;
     //WordFindobj:=Rangeobj.Find;
  AFindObj.Executeold(FindText,MatchCase, MatchWholeWord, MatchWildcards, MatchSoundsLike,
                  MatchAllWordForms, findforward, Wrap, Format, ReplaceWith, Replace);
end;

//function GetCurrentOpenDocFileName: string;
//begin
//  if AWordDoc<>nil  then
//  begin
//    result:=AWordDoc.path+'\'+AWordDoc.name;
//  end
//  else
//  begin
//    result:=''  ;
//  end;
//end;
function IsFileOpened(AWordApp: TWordApplication; AWordDoc: TWordDocument; AFileName: string; out AIsDocOpened: Boolean): boolean;
var
  I: Integer;
  docCount:integer;
  index:olevariant;
  doc:_Document;
begin
  result:=false;
  AIsDocOpened := False;
  docCount:=AWordApp.Documents.Count;
  if  docCount>0 then
   begin
     for I := 1 to docCount do    // Iterate
     begin
       index:=i;
       doc:=AWordApp.documents.item(index);
       if AFileName=(Doc.path+'\'+Doc.name) then
       begin
         AWordDoc.ConnectTo(doc);
         result:=true;
         AIsDocOpened := True;
         exit;
       end;
     end;    // for
   end;
end;

function FillKeyParagraphGradeInfo(AWordDoc:TWordDocument;var GradeInfo: TGradeInfo;AFillMode:TFillGradeMode): integer;
var
  index: Integer;
  value:string;
  RangeObj :WordRange;
  FindObj :Find;
begin
  RangeObj:=AWordDoc.Content;
  FindObj:=RangeObj.find;
  FindTextObj(FindObj,GradeInfo.ObjStr);
  if FindObj.Found then
  begin
    case GradeInfo.ID  of
        51: value :=floattostrf(RangeObj.ParagraphFormat.LeftIndent,ffFixed,8,3);
        52: value :=floattostrf(RangeObj.ParagraphFormat.RightIndent,ffFixed,8,3);
        53: value :=inttostr(RangeObj.ParagraphFormat.Alignment);
        54: value :=floattostrf(RangeObj.ParagraphFormat.SpaceBefore,ffFixed,8,3);
        55: value :=floattostrf(RangeObj.ParagraphFormat.SpaceAfter,ffFixed,8,3);
        56: value :=floattostrf(RangeObj.ParagraphFormat.linespacing,ffFixed,8,3);
        57: value :=floattostrf(RangeObj.ParagraphFormat.firstlineindent,ffFixed,8,3);
        
        58: value :=inttostr(RangeObj.Paragraphs.First.DropCap.Position);
        59: if RangeObj.Paragraphs.First.DropCap.Position>0 then
               value := RangeObj.Paragraphs.First.DropCap.FontName
            else  value := 'NULL';
        60: if RangeObj.Paragraphs.First.DropCap.Position>0 then
               value := inttostr(RangeObj.Paragraphs.First.DropCap.LinesToDrop)
            else  value := 'NULL';
        61: if RangeObj.Paragraphs.First.DropCap.Position>0 then
               value := floattostrf(RangeObj.Paragraphs.First.DropCap.DistanceFromText,ffFixed,8,3)
            else  value := 'NULL';

        71: value :=inttostr(RangeObj.PageSetup.TextColumns.Count);
        72: value :=inttostr(RangeObj.PageSetup.TextColumns.evenlyspaced);
        73: if (RangeObj.PageSetup.TextColumns.Count>1) and (RangeObj.PageSetup.TextColumns.evenlyspaced=-1) then
              value :=floattostrf(RangeObj.PageSetup.TextColumns.Spacing,ffFixed,8,3)
            else
              value := 'NULL';
        74: if (RangeObj.PageSetup.TextColumns.Count>1) and (RangeObj.PageSetup.TextColumns.evenlyspaced=-1) then
              value :=floattostrf(RangeObj.PageSetup.TextColumns.width,ffFixed,8,3)
            else
              value := 'NULL';
        75: if (RangeObj.PageSetup.TextColumns.Count>1) and (RangeObj.PageSetup.TextColumns.evenlyspaced=-1) then
              value :=inttostr(RangeObj.PageSetup.TextColumns.linebetween)
            else
              value := 'NULL';
        76: value :=floattostrf(RangeObj.PageSetup.TextColumns.item(1).Width,ffFixed,8,3);
        77: if (RangeObj.PageSetup.TextColumns.Count>1) then
               value :=floattostrf(RangeObj.PageSetup.TextColumns.item(1).SpaceAfter,ffFixed,8,3)
            else
               value := 'NULL';
        78: if (RangeObj.PageSetup.TextColumns.Count>1) then
               value :=floattostrf(RangeObj.PageSetup.TextColumns.item(2).Width,ffFixed,8,3)
            else
               value := 'NULL';
        79: if (RangeObj.PageSetup.TextColumns.Count>2) then
               value :=floattostrf(RangeObj.PageSetup.TextColumns.item(2).SpaceAfter,ffFixed,8,3)
            else
               value := 'NULL';

        90: value :=inttostr(RangeObj.ParagraphFormat.Borders.Enable);
        91: value :=inttostr(RangeObj.ParagraphFormat.Borders.OutsideLineStyle);
        92: value :=inttostr(RangeObj.ParagraphFormat.Borders.OutsideLineWidth);
        93: value :=inttostr(RangeObj.ParagraphFormat.Borders.OutsideColorIndex);
        95: value :=inttostr(RangeObj.ParagraphFormat.Borders.distancefromleft);
    end;
    if aFillMode = fmStandValue then
    begin
      GradeInfo.StandardValue:=value;
    end
    else
    begin
      GradeInfo.ExamineValue:=value;
    end;
  end;
end;

function FillKeyTextPositionGradeInfo(AWordDoc:TWordDocument; var GradeInfo: TGradeInfo;AFillMode:TFillGradeMode): integer;
var
  index: Integer;
  value:string;
  objstrings:TStringList;
  mc:olevariant;    //��������ƶ���Ŀ
  tempRange:Wordrange;
  RangeObj :WordRange;
  FindObj :Find;
begin
  RangeObj:=AWordDoc.Content;
  FindObj:=RangeObj.find;  
  try
    case GradeInfo.ID  of
      450:begin
            objStrings:=TStringList.Create;
            objstrings.Delimiter:='-';
            objstrings.DelimitedText:=GradeInfo.ObjStr;
            if objstrings.Count=2 then
            begin
              FindTextObj(FindObj,objstrings.strings[0]);
              if FindObj.Found then
              begin        
                 mc:=1;
                 tempRange:= RangeObj.Paragraphs.First.Next(mc).Range;
                 FindObj:=tempRange.Find;
                 FindTextObj(FindObj,objstrings.Strings[1]);
                 if FindObj.Found then
                    value:='True'
                 else
                    value:='False';                     
            
                
              end else value:='False';
            end  else value:='False';
          end;
      end;
  finally // wrap up
    objstrings.free;
  end;    // try/finally
   if aFillMode = fmStandValue then
    GradeInfo.StandardValue:=value
  else
    GradeInfo.ExamineValue:=value;
end;
      

function FillKeyTableGradeInfo(AWordDoc:TWordDocument;var GradeInfo: TGradeInfo;AFillMode:TFillGradeMode):integer;
var
  index,tbcount: Integer;
  value:string;
  tb: table;
begin
  tbcount :=AWordDoc.Tables.Count;
  if (tbcount>0) and (trim(GradeInfo.ObjStr)<>'') then
  begin
    index := strtoint(GradeInfo.ObjStr);
    tb := AWordDoc.Tables.Item(index);
    case GradeInfo.ID  of    //
        151: value :=inttostr(tbcount);
        152: value :=inttostr(tb.Rows.Count);
        153: value :=inttostr(tb.Columns.Count);
        154: value :=FloatToStrF(tb.Columns.item(2).preferredwidth,ffFixed,8,3);
        160: value :=inttostr(tb.Borders.enable);
        161: value :=inttostr(tb.Borders.outsidelinestyle);
        162: value :=inttostr(tb.Borders.outsidelinewidth);
        164: value :=inttostr(tb.Borders.outsidecolorindex);
        165: value :=inttostr(tb.Borders.insidelinestyle);
        166: value :=inttostr(tb.Borders.insidelinewidth);
        168: value :=inttostr(tb.Borders.insidecolorindex);
    end;    // case
  end
  else
      value := '0';
  if aFillMode = fmStandValue then
    GradeInfo.StandardValue:=value
  else
    GradeInfo.ExamineValue:=value;
end;




function FillKeyPageGradeInfo(AWordDoc:TWordDocument;var GradeInfo: TGradeInfo;AFillMode:TFillGradeMode):integer;
var
  index: Integer;
  value:string;
  page:word2000.pagesetup;
begin
  page:=AWordDoc.pagesetup;
  case GradeInfo.ID  of
    131: value :=inttostr(page.papersize);
    132: value :=FloatToStrF(page.topmargin, ffFixed, 8, 3);
    133: value :=FloatToStrF(page.bottomMargin, ffFixed, 8, 3);
    134: value :=FloatToStrF(page.leftMargin, ffFixed, 8, 3);
    135: value :=FloatToStrF(page.rightMargin, ffFixed, 8, 3);
  end;
  if aFillMode = fmStandValue then
    GradeInfo.StandardValue:=value
  else
    GradeInfo.ExamineValue:=value;
end;

function FillKeyPageNumberGradeInfo(AWordDoc:TWordDocument;var GradeInfo: TGradeInfo;AFillMode:TFillGradeMode):integer;
var
  index: Integer;
  value:string;
  pn: PageNumbers;
begin
  if GradeInfo.ID in [181..183] then
    pn:=AWordDoc.Sections.item(1).Headers.item(1).PageNumbers;
  if GradeInfo.ID in [184..186] then
    pn:=AWordDoc.Sections.item(1).footers.item(1).PageNumbers;

  case GradeInfo.ID  of
     181,184: value:=inttostr(pn.Count);
     182,185: value:=inttostr(pn.StartingNumber);
     183,186: begin
                if pn.Count>0 then                 
                  value:=inttostr(pn.Item(1).Alignment)
                else
                  value :='-1';
              end;
  end;
  if aFillMode = fmStandValue then
    GradeInfo.StandardValue:=value
  else
    GradeInfo.ExamineValue:=value;
end;

function FillKeyFindTotalGradeInfo(AWordDoc:TWordDocument;var GradeInfo: TGradeInfo;AFillMode:TFillGradeMode):integer;
var
  index: Integer;
  FindText: string;
  num: Integer;
  value:string;
  RangeObj :WordRange;
  FindObj :Find;
begin
  RangeObj:=AWordDoc.Content;
  FindObj:=RangeObj.find;
  FindTextObj(FindObj,GradeInfo.ObjStr);
  case GradeInfo.ID  of
    201: begin
           FindText:=GradeInfo.ObjStr ;
           num:=0;
           FindTextObj(FindObj,FindText);
           while FindObj.Found do
           begin
             num:=num+1;
             FindTextObj(FindObj,FindText);
           end;
           value :=inttostr(num);
         end;
  end;
  if aFillMode = fmStandValue then
    GradeInfo.StandardValue:=value
  else
    GradeInfo.ExamineValue:=value;
end;

function FillKeyHeaderFooterGradeInfo(AWordDoc:TWordDocument;var GradeInfo: TGradeInfo;AFillMode:TFillGradeMode):integer;
var
  index: Integer;
  MyRange: Variant;
  value:string;
begin
  MyRange:=AWordDoc.Sections.Item(1).Headers.Item(1).Range;
  case GradeInfo.ID  of
     191,193: value :=trim(MyRange.text);
     192,194: value :=inttostr(MyRange.ParagraphFormat.alignment);
  end;
  if aFillMode = fmStandValue then
    GradeInfo.StandardValue:=value
  else
    GradeInfo.ExamineValue:=value;
end;


function DisConnectWordApp(AWordApp:TWordApplication;AWordDoc:TWordDocument):integer;
begin
  if AWordDoc<>nil then
  begin
    AWordDoc.Disconnect;
    FreeAndNil(AWordDoc);
  end;
  if AWordApp<>nil then
  begin
    AWordApp.Visible:=true;
    AWordApp.Disconnect;
    FreeAndNil(AWordapp);
  end;
end;

function CloseWordApp(AWordApp:TWordApplication;AWordDoc:TWordDocument):integer;
begin
  if AWordDoc<>nil then
  begin
    AWordDoc.Close;
    FreeAndNil(AWordDoc);
    Sleep(500);
  end;
  if AWordApp<>nil then
  begin
    AWordApp.Visible:=true;
    AWordApp.Quit;
    FreeAndNil(AWordapp);
    Sleep(500);
  end;
end;

function FillKeyTextFrameGradeInfo(AWordDoc:TWordDocument;var GradeInfo: TGradeInfo;AFillMode:TFillGradeMode):integer;
var
  index: olevariant;
  value:string;
  textFrameObj:TextFrame;
  shapeObj:Shape;
begin
  index:=strtoint(GradeInfo.ObjStr);
  if AWordDoc.Shapes.Count>=index then
  begin
    shapeObj:= AWordDoc.Shapes.Item(index);
    if shapeobj.TextFrame.HasText=-1 then
      textFrameObj:=shapeobj.TextFrame;
  end;

  if textFrameobj<>nil then
  begin
    case GradeInfo.ID  of

        300: value := inttostr(shapeobj.type_);        //�����ɿ�����ͼ�ζ���ϲ�
        301: value := floattostrf(textFrameObj.MarginTop,ffFixed,8,3);
        302: value := floattostrf(textFrameObj.MarginLeft,ffFixed,8,3);
        303: value := floattostrf(textFrameObj.MarginBottom,ffFixed,8,3);
        304: value := floattostrf(textFrameObj.Marginright,ffFixed,8,3);
        305: value := inttostr(textFrameObj.Orientation);
        306: value := textFrameObj.TextRange.Text;


    end;
  end
  else
    value := 'NULL';

  if aFillMode = fmStandValue then
    GradeInfo.StandardValue:=value
  else
    GradeInfo.ExamineValue:=value;
end;

function FillKeyShapeGradeInfo(AWordDoc:TWordDocument;var GradeInfo: TGradeInfo;AFillMode:TFillGradeMode):integer;
var
  index: olevariant;
  value:string;
  shapeObj:Shape;
begin
  index:=strtoint(GradeInfo.ObjStr);
  if AWordDoc.Shapes.Count>=index then
    shapeObj:= AWordDoc.Shapes.Item(index);


  if shapeObj<>nil then
  begin
    case GradeInfo.ID  of

        320: value := shapeObj.Anchor.Words.Item(1).Text;
        321: value := inttostr(shapeObj.LockAnchor);
        
        323: value := inttostr(shapeobj.RelativeHorizontalPosition);
        324: value := inttostr(shapeobj.RelativeVerticalPosition);
        325: value := floattostrf(shapeobj.top,ffFixed,8,3);
        326: value := floattostrf(shapeobj.left,ffFixed,8,3);

        330: value := inttostr(shapeobj.WrapFormat.type_);
        331: value := inttostr(shapeobj.WrapFormat.Side);
        332: value := floattostrf(shapeobj.WrapFormat.DistanceTop,ffFixed,8,3);
        333: value := floattostrf(shapeobj.WrapFormat.DistanceLeft,ffFixed,8,3);
        334: value := floattostrf(shapeobj.WrapFormat.DistanceBottom,ffFixed,8,3);
        335: value := floattostrf(shapeobj.WrapFormat.Distanceright,ffFixed,8,3);
        336: value := inttostr(shapeobj.WrapFormat.AllowOverlap);

        340: value := inttostr(shapeobj.LockAspectRatio);
        341: value := floattostrf(shapeobj.height,ffFixed,8,3);
        342: value := floattostrf(shapeobj.width,ffFixed,8,3);
        343: value := floattostrf(shapeobj.Rotation,ffFixed,8,3);

        350: if shapeobj.type_ in [$0000000D] then value := floattostrf(shapeobj.PictureFormat.CropLeft,ffFixed,8,3) else value := 'NULL';
        351: if shapeobj.type_ in [$0000000D] then value := floattostrf(shapeobj.PictureFormat.CropTop,ffFixed,8,3) else value := 'NULL';
        352: if shapeobj.type_ in [$0000000D] then value := floattostrf(shapeobj.PictureFormat.Cropright,ffFixed,8,3) else value := 'NULL';
        353: if shapeobj.type_ in [$0000000D] then value := floattostrf(shapeobj.PictureFormat.Cropbottom,ffFixed,8,3) else value := 'NULL';
        354: if shapeobj.type_ in [$0000000D] then value := inttostr(shapeobj.PictureFormat.ColorType) else value := 'NULL';
        355: if shapeobj.type_ in [$0000000D] then value := floattostrf(shapeobj.PictureFormat.Brightness,ffFixed,8,3) else value := 'NULL';
        356: if shapeobj.type_ in [$0000000D] then value := floattostrf(shapeobj.PictureFormat.Contrast,ffFixed,8,3) else value := 'NULL';
        357: if (shapeobj.type_ in [$0000000D]) and (shapeobj.PictureFormat.TransparentBackground=-1) then value := inttostr(shapeobj.PictureFormat.TransparencyColor) else value := 'NULL';

    end;
  end
  else
    value := 'NULL';
  if aFillMode = fmStandValue then
    GradeInfo.StandardValue:=value
  else
    GradeInfo.ExamineValue:=value;
end;

function FillKeyShapeFillGradeInfo(AWordDoc:TWordDocument;var GradeInfo: TGradeInfo;AFillMode:TFillGradeMode):integer;
var
  index: olevariant;
  value:string;
  shapeObj:Shape;
  FillFormatObj:fillformat;
begin
  index:=strtoint(GradeInfo.ObjStr);
  if AWordDoc.Shapes.Count>=index then
    shapeObj:= AWordDoc.Shapes.Item(index);


  if shapeObj<>nil then
  begin
    FillFormatobj := Shapeobj.Fill;
    case GradeInfo.ID of
      360: if FillFormatobj.type_=$00000001 then
              value := vartostr(FillFormatobj.forecolor.rgb)    //����.��䱳��ɫ
           else
              value := 'Null';
      361: if FillFormatobj.type_=$00000001 then
              value := vartostr(FillFormatobj.transparency)    //����.͸����
           else
              value := 'Null';
      362: if FillFormatobj.type_=$00000003 then
              value := vartostr(FillFormatobj.GradientColorType)    //����.������ɫ����
           else
              value := 'Null';
      363: if FillFormatobj.type_=$00000003 then
              if (FillFormatobj.gradientcolortype=$00000001)or(FillFormatobj.gradientcolortype=$00000002) then
                 value := vartostr(FillFormatobj.forecolor.rgb)    //����.������ɫһ
              else
                 value :='null'
           else
              value := 'Null';
      364: if FillFormatobj.type_=$00000003 then
              if FillFormatobj.gradientcolortype=$00000002 then
                 value := vartostr(FillFormatobj.backcolor.rgb)    //����.������ɫ��
              else
                 value :='null'
           else
              value := 'Null';
      365: if FillFormatobj.type_=$00000003 then
              if FillFormatobj.gradientcolortype=$00000003 then
                 value := vartostr(FillFormatobj.PresetGradientType)    //����.Ԥ���������
              else
                 value :='null'
           else
              value := 'Null';
//      106: if FillFormatobj.type=$00000003 then
//              value := vartostr(FillFormatobj.gradientdegree)    //����.������ɫ��ǳ
//           else
//              value := 'Null';
      367: if FillFormatobj.type_=$00000003 then
              value := vartostr(FillFormatobj.GradientStyle)    //����.���ɵ�����ʽ
           else
              value := 'Null';
      368: if FillFormatobj.type_=$00000003 then
              value := vartostr(FillFormatobj.GradientVariant)    //����.���ɱ���
           else
              value := 'Null';
      369: if FillFormatobj.type_= $00000004 then
              value := vartostr(FillFormatobj.texturename)    //����.����
           else
               value := 'Null';
      370: if FillFormatobj.type_= $00000002 then
              value := vartostr(FillFormatobj.pattern)    //����.ͼ����ʽ
           else
               value := 'Null';
      371: if FillFormatobj.type_= $00000002 then
              value := vartostr(FillFormatobj.forecolor.rgb)    //����.ͼ��ǰ��
           else
               value := 'Null';
      372: if FillFormatobj.type_= $00000002 then
              value := vartostr(FillFormatobj.backcolor.rgb)    //����.ͼ������
           else
               value := 'Null';
    end;
  end
  else
  begin
    value := '�޸���������״!'
  end;
  if aFillMode = fmStandValue then
    GradeInfo.StandardValue:=value
  else
    GradeInfo.ExamineValue:=value;
end;
function FillKeyShapeLineGradeInfo(AWordDoc:TWordDocument;var GradeInfo: TGradeInfo;AFillMode:TFillGradeMode):integer;
var
  index: olevariant;
  value:string;
  shapeObj:Shape;
  LineFormatObj:Lineformat;
begin
  index:=strtoint(GradeInfo.ObjStr);
  if AWordDoc.Shapes.Count>=index then
    shapeObj:= AWordDoc.Shapes.Item(index);


  if shapeObj<>nil then
  begin
    lineFormatobj := Shapeobj.line;
    case GradeInfo.ID of
      380: value := inttostr(lineFormatobj.forecolor.rgb);    
      381: value := inttostr(lineFormatobj.style);
      382: value := inttostr(lineFormatobj.dashstyle);
      383: value := floattostrf(lineFormatobj.Weight,ffFixed,8,3);
      384: value := inttostr(lineFormatobj.Pattern);
      385: value := inttostr(lineFormatobj.BackColor.RGB);
    end;
  end
  else
  begin
    value := '�޸���������״!'
  end;
  if aFillMode = fmStandValue then
    GradeInfo.StandardValue:=value
  else
    GradeInfo.ExamineValue:=value;
end;

function FillKeyShapeTextEffectGradeInfo(AWordDoc:TWordDocument;var GradeInfo: TGradeInfo;AFillMode:TFillGradeMode):integer;
var
  index: olevariant;
  value:string;
  shapeObj:Shape;
  textEffectObj:texteffectformat;
begin
  index:=strtoint(GradeInfo.ObjStr);
  if AWordDoc.Shapes.Count>=index then
  begin
    shapeObj:= AWordDoc.Shapes.Item(index);
    if shapeobj.type_=$0000000F then
    textEffectObj:= shapeobj.TextEffect;
  end;     
  if textEffectObj<>nil then
  begin
    case GradeInfo.ID of
      400: value := textEffectObj.Text;
      401: value := textEffectObj.FontName;
      402: value := inttostr(textEffectObj.FontItalic);
      403: value := inttostr(textEffectObj.FontBold);
      404: value := floattostrf(textEffectObj.FontSize,ffFixed,8,3);
      405: value := inttostr(texteffectobj.NormalizedHeight);
      406: value := inttostr(texteffectobj.PresetTextEffect);
      407: value := inttostr(texteffectobj.PresetShape);
      408: value := inttostr(texteffectobj.RotatedChars);
      409: value := floattostrf(textEffectObj.Tracking,ffFixed,8,3);
      410: value := inttostr(texteffectobj.KernedPairs);
    end;
  end
  else
  begin
    value := '�޸���������״!'
  end;
  if aFillMode = fmStandValue then
    GradeInfo.StandardValue:=value
  else
    GradeInfo.ExamineValue:=value;

end;

initialization
   Coinitialize(nil);
finalization
   CoUninitialize;

end.
