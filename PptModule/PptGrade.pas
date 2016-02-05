unit PptGrade;

interface

uses Classes, ExamGlobal,ufrmInProcess,uGrade;
    function FillSlideGradeInfo(APresentation:variant;var GradeInfo: TGradeInfo;aFillMode : TFillGradeMode): Integer;   //�õ�Ƭ����
    
    function FillAnimationSettingsGradeInfo(APresentation:variant;var GradeInfo: TGradeInfo;aFillMode : TFillGradeMode): Integer;
    function FillActionSettingsGradeInfo(APresentation:variant;var GradeInfo: TGradeInfo;aFillMode : TFillGradeMode): Integer;
    function FillFontGradeInfo(APresentation:variant;var GradeInfo: TGradeInfo;aFillMode : TFillGradeMode): Integer;
    function FillBackGroundGradeInfo(APresentation:variant;var GradeInfo: TGradeInfo;aFillMode : TFillGradeMode): Integer;
    function FillParagraphFormatGradeInfo(APresentation:variant;var GradeInfo: TGradeInfo;
      aFillMode : TFillGradeMode): Integer;
    function FillTextFrameGradeInfo(APresentation:variant;var GradeInfo: TGradeInfo;aFillMode : TFillGradeMode): Integer;


    //function FindObj:integer;
    function GetShape(APresentation:variant;strObj:string):variant;
  
    //����Word��ò���ֵ�����GradeInfo��¼
    //����������һϵ�����ຯ��      //amode: -1:standardvalue 1: examinevalue
    function FillKeyGradeInfo(APresentation:variant;var gradeinfo: TGradeInfo;aFillMode : TFillGradeMode): Integer;
    function ClosePptApp(APptApp:Variant;APresentation:Variant):integer;
    function DisConnect(APptApp:Variant;APresentation:Variant):integer;
    function Connect(var APptApp:Variant):integer;


 function FillGrades(GradeInfoStrings:TStrings;APath:string;AFileName:string; AOnProcess:TOnProcess=nil;aFillMode : TFillGradeMode = fmExamValue;ANeedCloseDoc:Boolean =true):Integer; stdcall;
 function OpenDoc(AFileName: string; var APptApp: Variant; var APresentation: Variant; out AIsDocOenped: Boolean):Integer;
 function IsFileOpened(AFileName: string; APptApp: Variant; var APresentation: Variant; out AIsDocOpened: Boolean): boolean;
implementation

uses sysutils,Variants,comobj, activex,  PptTest, Commons, ExamException, ExamResourceStrings;

function FillGrades(GradeInfoStrings:TStrings;APath:string;AFileName:string; AOnProcess:TOnProcess=nil;aFillMode : TFillGradeMode = fmExamValue;ANeedCloseDoc:Boolean =true):Integer; stdcall;
var
  I: Integer;
  GradeInfo:TGradeInfo;
  PptApp:Variant;
  Presentation:Variant;
  isDocOpened :Boolean;
  filename:string;
begin
   try
      if Assigned(AOnProcess) then
         AOnProcess(Format(RSScoring,['PowerPoint������']),0);
      PptApp := null;
      Presentation := null;
      if AFileName = NULL_STR then  AFileName := DOCNAME;
      filename := IncludeTrailingPathDelimiter(aPath)+AFileName;
      EFileNotExistException.IfFalse(FileExists(filename),Format(RSFileNotExist,[filename]));
      Connect(PptApp);
      OpenDoc(filename,PptApp, Presentation, isDocOpened );
      try
         //WordGrade.FileName:=filename;
         for I := 0 to GradeInfoStrings.Count - 1 do    // Iterate
         begin
           StrToGradeInfo(GradeInfoStrings.Strings[i],GradeInfo);
           FillKeyGradeInfo(Presentation,GradeInfo,aFillMode);
           GradeInfoStrings[i] := GradeInfoToStr(GradeInfo);

            if Assigned(AOnProcess) then AOnProcess(Format(RSScoring,['PowerPoint������']),gradeinfo.Points);
            sleep(100);
         end;    // for
      finally // wrap up
       if  (ANeedCloseDoc or not isDocOpened) then
         ClosePptApp(PptApp,Presentation)  //�˳�Word����
       else
         PptApp.Visible := True;
      end;    // try/finallyend;
   except
      on E:Exception do
         EGradeException.Toss(Format(RsGradeError,[GetModuleDllName,e.Message]));
   end; 
end;
{ TExcelGrade }

function ClosePptApp(APptApp:Variant;APresentation:Variant):integer;
begin
  APresentation:=null;
  APptApp.visible:=true;
  APptApp.quit;
  APptApp:=null;
end;

function DisConnect(APptApp:Variant;APresentation:Variant):integer;
begin
  if (not(varType(APresentation)=varEmpty))and(not(varType(APresentation)=varNull))  then   APresentation :=null;
  if  (not(varType(APptApp)=varEmpty))and(not(varType(APptApp)=varNull))  then
  begin
    APptApp.visible:=true;
    APptApp :=null
  end;
end; 

function FillFontGradeInfo(APresentation:variant;var GradeInfo: TGradeInfo;aFillMode : TFillGradeMode): Integer;
var
  value:string;
  objShape,objFont:variant;
begin
  objShape := GetShape(APresentation,gradeinfo.ObjStr);
  if not VarIsNull(objShape) then
  begin
    if objShape.hasTextFrame=-1 then
    begin
      objFont := objShape.TextFrame.TextRange.font;
      case GradeInfo.ID of
        30: value := vartostr(objFont.NameFarEast);        //������������
        31: value := vartostr(objFont.NameAscii);   //����.������������
        32: value := vartostr(objFont.size);   //����.�ֺ�
        33: value := vartostr(objFont.color); //����.��ɫ
        34: value := vartostr(objFont.bold);  //����.�Ƿ�Ӵ�
        35: value := vartostr(objFont.italic);  //����.�Ƿ���б
        36: value := vartostr(objFont.underline);  //����.�Ƿ����»���
        37: value := vartostr(objFont.shadow);  //����.�Ƿ�����Ӱ
        38: value := vartostr(objFont.emboss);  //����.�Ƿ�ͻ
        39: value := vartostr(objFont.superscript);  //����.�Ƿ����ϱ�
        40: value := vartostr(objFont.subscript);  //����.�Ƿ����±�
        41: value := vartostr(objFont.BaselineOffset);  //������.���±��ƫ��ֵ
      end;
    end
    else
    begin
      value := '����״���ı���!'
    end;
  end
  else
  begin
    value := '�޸�������״!'
  end;
  if aFillMode = fmStandValue then
    GradeInfo.StandardValue:=value
  else
    GradeInfo.ExamineValue:=value;
  result:=-1;
end;

function FillParagraphFormatGradeInfo(APresentation:variant;var GradeInfo: TGradeInfo;aFillMode:TFillGradeMode): Integer;
var
  value:string;
  objShape,objParagraph:variant;
begin
  objShape := GetShape(APresentation,gradeinfo.ObjStr);
  if not VarIsNull(objShape) then
  begin
    if objShape.hasTextFrame=-1 then
    begin
      objParagraph := objShape.TextFrame.TextRange.Paragraphformat;
      case GradeInfo.ID of
        42: value := vartostr(objParagraph.alignment);        //�����ʽ.���뷽ʽ
        43: value := vartostr(objParagraph.baselinealignment);   //�����ʽ.������뷽ʽ
        44: value := vartostr(objParagraph.spacebefore)+vartostr(objParagraph.linerulebefore);   //�����ʽ.��ǰ����
        45: value := vartostr(objParagraph.spaceafter)+vartostr(objParagraph.lineruleafter); //�����ʽ.�κ����
        46: value := vartostr(objParagraph.spacewithin)+vartostr(objParagraph.linerulewithin);  //�����ʽ.�о�
      {TODO 47֪ʶ����91֪ʶ���غϣ�Ҫ���}
        47: value := vartostr(objShape.TextFrame.Orientation);  //�����ʽ.���ַ���
        48: if objParagraph.bullet.type=1 then
              value := vartostr(objParagraph.bullet.character)  //��Ŀ���źͱ��.��������ʽ
            else
              value := '';
        49: if objParagraph.bullet.type=2 then
              value := vartostr(objParagraph.bullet.style)  //��Ŀ���źͱ��.�������ʽ
            else
              value := '';
        50: if objParagraph.bullet.type=2 then
              value := vartostr(objParagraph.bullet.startvalue)  //��Ŀ���źͱ��.�������ʼֵ
            else
              value := '';
        51: if objParagraph.bullet.type>0 then
              value := vartostr(objParagraph.bullet.font.color.rgb)  //��Ŀ���źͱ��.��ɫ
            else
              value := '';
        52: if objParagraph.bullet.type>0 then
              value := vartostr(objParagraph.bullet.relativesize)  //��Ŀ���źͱ��.��С
            else
              value := '';
      end;
    end
    else
    begin
      value := '����״���ı���!'
    end;
  end
  else
  begin
    value := '�޸�������״!'
  end;
  if aFillMode = fmStandValue then
    GradeInfo.StandardValue:=value
  else
    GradeInfo.ExamineValue:=value;
  result:=-1;
end;

function FillKeyGradeInfo(APresentation:variant;var gradeinfo: TGradeInfo;aFillMode:TFillGradeMode): Integer;
begin
  try
    case GradeInfo.ID of
       10..20    : result := FillSlideGradeInfo(APresentation,gradeinfo,aFillMode);
       30..41    : result := FillFontGradeInfo(APresentation,gradeinfo,aFillMode);
       42..53    : result := FillParagraphFormatGradeInfo(APresentation,gradeinfo,aFillMode);
       60..70    : result := FillAnimationSettingsGradeInfo(APresentation,gradeinfo,aFillMode);
       75..82    : result := FillActionSettingsGradeInfo(APresentation,gradeinfo,aFillMode);
       90..97    : result := FillTextFrameGradeInfo(APresentation,gradeinfo,aFillMode);
       100..112  : result := FillBackGroundGradeInfo(APresentation,gradeinfo,aFillMode);
    end;
      
    if aFillMode=fmExamValue then
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

function OpenDoc(AFileName: string; var APptApp: Variant; var APresentation: Variant; out AIsDocOenped: Boolean):Integer;
var
  i:Integer;
begin
  if not IsFileOpened(AFileName, APptApp, APresentation, AIsDocOenped)  then
  begin
     APptApp.Visible := True;
     apptApp.Presentations.Open(aFileName);
     aPresentation :=aPptApp.activePresentation;
  end;
end;

function FillSlideGradeInfo(APresentation:variant;var GradeInfo: TGradeInfo;aFillMode:TFillGradeMode): Integer;
var
  value:string;
  MySlides,SlideObj:variant;
begin
  MySlides:=APresentation.Slides;
  if GradeInfo.ID=12 then
     value := vartostr(MySlides.count)     //�õ�Ƭ����
  else
  begin
    if mySlides.count>=strtoint(GradeInfo.ObjStr) then
    begin
      SlideObj:=APresentation.Slides.item(strtoint(GradeInfo.ObjStr));
      case GradeInfo.ID of
        { TODO -ojp -cppt : ���õ��Żõ�Ƭģ������ }
        10: value := vartostr(SlideObj.parent.templateName);  //ģ�����ƣ�����������ﲻ����
        11: value := vartostr(SlideObj.layout);     //��ʽ
        //12      
        13: value := vartostr(SlideObj.SlideShowTransition.entryEffect);    //Ƭ�л���ʽ
        14: value := vartostr(SlideObj.SlideShowTransition.speed);         //Ƭ�л��ٶ�
        15: value := vartostr(SlideObj.SlideShowTransition.advanceonclick);         //Ƭ�е�����껻ҳ
        16: begin
              if SlideObj.SlideShowTransition.advanceontime=-1 then
                value := vartostr(SlideObj.SlideShowTransition.advancetime)        //Ƭ�л�ָ��ʱ�任ҳ
              else
                value := '';
            end;
        17: begin
              if SlideObj.SlideShowTransition.soundEffect.type<>0 then
                value := vartostr(SlideObj.SlideShowTransition.soundEffect.name)      // Ƭ�л�ʱ����Ч��
              else
                value := '';
            end;
        18: value := vartostr(SlideObj.SlideShowTransition.LoopSoundUntilnext);       //Ƭ�л�ʱ����Ч���Ƿ�ѭ������
        19: begin
              if SlideObj.background.fill.type=$00000004 then
                value := vartostr(SlideObj.background.fill.TextureName)       //��������
              else
                value := '';
            end;
  //      19: begin
  //            if SlideObj.hyperlinks.count=1 then
  //              value := SlideObj.hyperlinks.item(1).subaddress //������
  //            else
  //              value := '';
  //          end;
  //      20: begin
  //            if SlideObj.shapes.hastitle then
  //            begin
  //              if SlideObj.shapes.Title.AnimationSettings.animate then
  //                value := SlideObj.shapes.Title.AnimationSettings.AdvanceMode //������
  //            end
  //            else
  //              value := '';
  //          end;
      end;
    end
    else
    begin
      value:= '�޸������õ�Ƭ';
    end;
  end;
  if aFillMode = fmStandValue then
    GradeInfo.StandardValue:=value
  else
    GradeInfo.ExamineValue:=value;
  result:=-1;
end;

function FillAnimationSettingsGradeInfo(APresentation:variant;var GradeInfo: TGradeInfo;aFillMode:TFillGradeMode): Integer;
var
  value:string;
  objShape:variant;
begin
  objShape := GetShape(APresentation,gradeinfo.ObjStr);

  if vartype(objShape)<>varNull then
  begin
    if objShape.animationsettings.animate=-1 then
    begin
      case GradeInfo.ID of
        60 : value := vartostr(objShape.animationsettings.animationorder);  //��������˳��
        61 :  value := vartostr(objShape.animationsettings.advanceMode);  //����������ʽ
        62 : value := vartostr(objShape.animationsettings.advancetime);  //��������ʱ��
        {TODO ����Ч����2003���кܶ����ֵ��һ���ģ��硰����-�������롰����-չ������ֵ����257}
        63 : value := vartostr(objShape.animationsettings.EntryEffect);  //����Ч��
        64 : begin
                if objShape.animationsettings.soundEffect.type<>0 then
                  value := vartostr(objShape.animationsettings.soundEffect.name)      // ����Ч��
                else
                  value := '';
             end;
        65 : value := vartostr(objShape.animationsettings.aftereffect);  //���ź���
        { TODO -ojp -cppt : ���ź����ɫ }
    //    56 : value := vartostr(objShape.animationsettings.dimcolor);     //�䰵��ɫ
        66 : value := vartostr(objShape.animationsettings.TextUnitEffect);  //�����ı���ʽ
        67 : value := vartostr(objShape.animationsettings.TextLevelEffect);  //�ڼ���������
        68 : value := vartostr(objShape.animationsettings.AnimateTextInReverse);  //�Ƿ��෴˳��
        69 : value := vartostr(objShape.animationsettings.ChartUnitEffect);  //ͼ�����뷽ʽ
        70 : value := vartostr(objShape.animationsettings.AnimateBackground);  //�����ߺ�ͼ���Ƿ���ʾ����
      end;
    end
    else
    begin
      value:='';
    end;      
  end
  else
  begin
    value:= '�޸�������״';
  end;
  if aFillMode = fmStandValue then
    GradeInfo.StandardValue:=value
  else
    GradeInfo.ExamineValue:=value;
  result:=-1;
end;

function FillActionSettingsGradeInfo(APresentation:variant;var GradeInfo: TGradeInfo;aFillMode:TFillGradeMode): Integer;
var
  value:string;
  objShape:variant;
begin
  objShape := GetShape(APresentation,gradeinfo.ObjStr);

  if vartype(objShape)<>varNull then
  begin
      case GradeInfo.ID of
      { TODO -ojp -cppt : ��ť���ı������ӵ��ĵ���ǰĳ�Żõ�Ƭ }
        75 : value := vartostr(objShape.actionsettings.item(1).action);       //��굥����������
        76 :  begin
                if objShape.actionsettings.item(1).action=$00000007 then      //��굥�������ӵ�ַ
                  value :=strfilter( vartostr(objShape.actionsettings.item(1).hyperlink.address),GetModuleDelimiterChar())
                else
                  value :='';
              end;
        77 :  begin
                if objShape.actionsettings.item(1).action=$00000007 then      //��굥����������Ļ��ʾ
                  value := vartostr(objShape.actionsettings.item(1).hyperlink.screentip)
                else
                  value :='';
              end;
        78 :  begin
                if objShape.actionsettings.item(1).soundEffect.type<>0 then
                  value := vartostr(objShape.actionsettings.item(1).soundEffect.name)      // ����Ч��
                else
                  value := '';
              end;
        79 :  begin
                if objShape.actionsettings.item(1).action<>$00000000 then      //��굥��ͻ����ʾ
                  value := vartostr(objShape.actionsettings.item(1).animateaction)
                else
                  value :='';
              end;
        80 : value := vartostr(objShape.actionsettings.item(2).action);       //����ƶ���������
        81 :  begin
                if objShape.actionsettings.item(2).soundEffect.type<>0 then
                  value := vartostr(objShape.actionsettings.item(1).soundEffect.name)      // ����ƶ�����Ч��
                else
                  value := '';
              end;
        82 :  begin
                if objShape.actionsettings.item(2).action<>$00000000 then      //����ƶ�ͻ����ʾ
                  value := vartostr(objShape.actionsettings.item(1).animateaction)
                else
                  value :='';
              end;
      end;

  end
  else
  begin
    value:= '�޸�������״';
  end;
  if aFillMode = fmStandValue then
    GradeInfo.StandardValue:=value
  else
    GradeInfo.ExamineValue:=value;
  result:=-1;
end;

//        50:if SlideObj.shapes.hastitle then
//         if SlideObj.shapes.title.TextFrame.textRange.text=Items[index].Param1 then   //�õ�Ƭ�����ı�
//            begin
//              FPoints:=FPoints+Items[index].Points;
//            end;
//        80:if SlideObj.shapes.hastitle then
//         if SlideObj.shapes.title.TextFrame.textRange.font.name=Items[index].Param1 then   //�õ�Ƭ�����ı�
//            begin
//              FPoints:=FPoints+Items[index].Points;
//            end;
//        81:if SlideObj.shapes.hastitle then
//         if SlideObj.shapes.title.TextFrame.textRange.font.size=strtoint(Items[index].Param1) then   //�õ�Ƭ�����ı�
//            begin
//              FPoints:=FPoints+Items[index].Points;
//            end;
//        86: if SlideObj.shapes.hastitle then
//         if SlideObj.shapes.title.TextFrame.textRange.paragraphformat.alignment=strtoint(Items[index].Param1) then   // ���뷽ʽ
//            begin
//              FPoints:=FPoints+Items[index].Points;
//            end;


function Connect(var APptApp:Variant):integer;
var
  Unknown: IUnknown;
  ClassID: TCLSID;
begin
  if (varType(APptApp)=varEmpty)or(varType(APptApp)=varNull)  then
  begin
    ClassID := ProgIDToClassID('powerpoint.application');
    if not Succeeded(GetActiveObject(ClassID, nil, Unknown)) then
        Unknown := CreateComObject(ClassId);
    APptapp:=Unknown as IDispatch ;
  end;
end;

function IsFileOpened(AFileName: string; APptApp: Variant; var APresentation: Variant; out AIsDocOpened: Boolean): boolean;
var
  I: Integer;
  PresentationCount:integer;
begin
  result:=false;
  AIsDocOpened := False;
  if (varType(APresentation)=varEmpty)or(varType(APresentation)=varNull)  then
  begin
    PresentationCount:=APptApp.Presentations.Count;
    if  PresentationCount>0 then
     begin
       for I := 1 to PresentationCount do    // Iterate
       begin
         APresentation := APptApp.Presentations.item(i);
         if AFileName=(APresentation.path+'\'+APresentation.name) then
         begin
           result:=true;
           AIsDocOpened := True;
           exit;
         end;           
       end;    // for
       APresentation:=null;
     end;
  end
  else
  begin
    result:=true;
    AIsDocOpened := True;
  end;
end;
//
//function FindObj: integer;
//var
//  I,j: Integer;
//  slidecount,shapecount:Integer;
//  slideObj,ShapeObj,txtRng,foundText:variant;
//begin
//  slidecount:=Presentation.slides.count;
//  for I := 1 to slideCount do    // Iterate
//  begin
//    slideObj := Presentation.slides.item(i);
//    shapecount := slideobj.shapes.count;
//    for J := 1 to ShapeCount do    // Iterate
//    begin
//      shapeobj:= SlideObj.shapes.item(J);
//      if ShapeObj.hasTextFrame=-1 then
//      begin
//        txtRng := shapeobj.textFrame.textRange;
//        foundtext := txtrng.find('�ṹ');
//        if not VarIsClear(foundText) then
//          foundtext.Font.italic := True ;
//      end;
//    end;    // for
//  end;    // for    
//end;

function GetShape(APresentation:variant;strObj: string): variant;
var
  objSlide: variant;
  objstrings:TStringList;
  SlideIndex,ShapeIndex:integer;
begin
  result:=null;
  objStrings:=TStringList.Create;
  try
    objstrings.Delimiter:='-';
    objstrings.DelimitedText:=strObj;  
    if objstrings.Count=2 then
    begin
      SlideIndex:=strtoint(objstrings.strings[0]);
      ShapeIndex:=strtoint(objstrings.strings[1]);
      if APresentation.slides.count>=slideindex then
      begin
        objSlide:=APresentation.slides.item(slideIndex);
        if objSlide.shapes.count>=ShapeIndex then
           result := objslide.shapes.item(ShapeIndex);
      end;
    end;
  finally // wrap up
    objstrings.free;
  end;    // try/finally
end;

function FillBackGroundGradeInfo(APresentation:variant;var GradeInfo: TGradeInfo; aFillMode:TFillGradeMode): Integer;
var
  value:string;
  objShape,objFillFormat:variant;
begin
  objShape := GetShape(APresentation,gradeinfo.ObjStr);
  if not VarIsNull(objShape) then
  begin
    objFillFormat := objShape.Fill;
    case GradeInfo.ID of
      100: if objFillFormat.type=$00000001 then
              value := vartostr(objFillFormat.forecolor.rgb)    //����.��䱳��ɫ
           else
              value := 'Null';
      101: if objFillFormat.type=$00000001 then
              value := vartostr(objFillFormat.transparency)    //����.͸����
           else
              value := 'Null';
      102: if objFillFormat.type=$00000003 then
              value := vartostr(objFillFormat.GradientColorType)    //����.������ɫ����
           else
              value := 'Null';
      103: if objFillFormat.type=$00000003 then
              if (objFillFormat.gradientcolortype=$00000001)or(objFillFormat.gradientcolortype=$00000002) then
                 value := vartostr(objFillFormat.forecolor.rgb)    //����.������ɫһ
              else
                 value :='null'
           else
              value := 'Null';
      104: if objFillFormat.type=$00000003 then
              if objFillFormat.gradientcolortype=$00000002 then
                 value := vartostr(objFillFormat.backcolor.rgb)    //����.������ɫ��
              else
                 value :='null'
           else
              value := 'Null';
      105: if objFillFormat.type=$00000003 then
              if objFillFormat.gradientcolortype=$00000003 then
                 value := vartostr(objFillFormat.PresetGradientType)    //����.Ԥ���������
              else
                 value :='null'
           else
              value := 'Null';
//      106: if objFillFormat.type=$00000003 then
//              value := vartostr(objFillFormat.gradientdegree)    //����.������ɫ��ǳ
//           else
//              value := 'Null';
      107: if objFillFormat.type=$00000003 then
              value := vartostr(objFillFormat.GradientStyle)    //����.���ɵ�����ʽ
           else
              value := 'Null';
      108: if objFillFormat.type=$00000003 then
              value := vartostr(objFillFormat.GradientVariant)    //����.���ɱ���
           else
              value := 'Null';
      109: if objFillFormat.type= $00000004 then
              value := vartostr(objFillFormat.texturename)    //����.����
           else
               value := 'Null';
      110: if objFillFormat.type= $00000002 then
              value := vartostr(objFillFormat.pattern)    //����.ͼ����ʽ
           else
               value := 'Null';
      111: if objFillFormat.type= $00000002 then
              value := vartostr(objFillFormat.forecolor.rgb)    //����.ͼ��ǰ��
           else
               value := 'Null';
      112: if objFillFormat.type= $00000002 then
              value := vartostr(objFillFormat.backcolor.rgb)    //����.ͼ������
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
  result:=-1;
end;

function FillTextFrameGradeInfo(APresentation:Variant;var GradeInfo: TGradeInfo;aFillMode:TFillGradeMode): Integer;
var
  value:string;
  objShape,objTextFrame:variant;
begin
  objShape := GetShape(APresentation,gradeinfo.ObjStr);
  if not VarIsNull(objShape) then
  begin
    if objShape.hasTextFrame=-1 then
    begin
      objTextFrame := objShape.TextFrame;
      case GradeInfo.ID of
                { TODO -ojp : ��Ӽ��enter }
        90: value :=StrFilter(vartostr(objTextFrame.Textrange.text));        //�ı���.�ı�����
        91: value := vartostr(objTextFrame.orientation);   //�ı���.�ı�����
        92: value := vartostr(objTextFrame.HorizontalAnchor)+vartostr(objTextFrame.VerticalAnchor);   //�ı���.�ı�������
        93: value := vartostr(objTextFrame.margintop); //�ı���.�ڲ��ϱ߾�
        94: value := vartostr(objTextFrame.marginbottom); //�ı���.�ڲ��±߾�
        95: value := vartostr(objTextFrame.marginleft); //�ı���.�ڲ���߾�
        96: value := vartostr(objTextFrame.marginright); //�ı���.�ڲ��ұ߾�
        97: value := vartostr(objTextFrame.wordwrap); // �ı���.�Զ�����
      end;
    end
    else
    begin
      value := '����״���ı���!'
    end
  end
  else
  begin
    value := '�޸�������״!'
  end;
  if aFillMode = fmStandValue then
    GradeInfo.StandardValue:=value
  else
    GradeInfo.ExamineValue:=value;
  result:=-1;
end;

end.
