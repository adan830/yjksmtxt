unit PptGrade;

interface

uses Classes, ExamGlobal,ufrmInProcess,uGrade;
    function FillSlideGradeInfo(APresentation:variant;var GradeInfo: TGradeInfo;aFillMode : TFillGradeMode): Integer;   //幻灯片评分
    
    function FillAnimationSettingsGradeInfo(APresentation:variant;var GradeInfo: TGradeInfo;aFillMode : TFillGradeMode): Integer;
    function FillActionSettingsGradeInfo(APresentation:variant;var GradeInfo: TGradeInfo;aFillMode : TFillGradeMode): Integer;
    function FillFontGradeInfo(APresentation:variant;var GradeInfo: TGradeInfo;aFillMode : TFillGradeMode): Integer;
    function FillBackGroundGradeInfo(APresentation:variant;var GradeInfo: TGradeInfo;aFillMode : TFillGradeMode): Integer;
    function FillParagraphFormatGradeInfo(APresentation:variant;var GradeInfo: TGradeInfo;
      aFillMode : TFillGradeMode): Integer;
    function FillTextFrameGradeInfo(APresentation:variant;var GradeInfo: TGradeInfo;aFillMode : TFillGradeMode): Integer;


    //function FindObj:integer;
    function GetShape(APresentation:variant;strObj:string):variant;
  
    //调用Word获得参数值，填充GradeInfo记录
    //本函数调用一系列子类函数      //amode: -1:standardvalue 1: examinevalue
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
         AOnProcess(Format(RSScoring,['PowerPoint操作题']),0);
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

            if Assigned(AOnProcess) then AOnProcess(Format(RSScoring,['PowerPoint操作题']),gradeinfo.Points);
            sleep(100);
         end;    // for
      finally // wrap up
       if  (ANeedCloseDoc or not isDocOpened) then
         ClosePptApp(PptApp,Presentation)  //退出Word程序
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
        30: value := vartostr(objFont.NameFarEast);        //中文字体名称
        31: value := vartostr(objFont.NameAscii);   //字体.西文字体名称
        32: value := vartostr(objFont.size);   //字体.字号
        33: value := vartostr(objFont.color); //字体.颜色
        34: value := vartostr(objFont.bold);  //字体.是否加粗
        35: value := vartostr(objFont.italic);  //字体.是否倾斜
        36: value := vartostr(objFont.underline);  //字体.是否有下划线
        37: value := vartostr(objFont.shadow);  //字体.是否有阴影
        38: value := vartostr(objFont.emboss);  //字体.是否浮突
        39: value := vartostr(objFont.superscript);  //字体.是否是上标
        40: value := vartostr(objFont.subscript);  //字体.是否是下标
        41: value := vartostr(objFont.BaselineOffset);  //字字体.上下标的偏移值
      end;
    end
    else
    begin
      value := '该形状无文本框!'
    end;
  end
  else
  begin
    value := '无该索引形状!'
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
        42: value := vartostr(objParagraph.alignment);        //段落格式.对齐方式
        43: value := vartostr(objParagraph.baselinealignment);   //段落格式.字体对齐方式
        44: value := vartostr(objParagraph.spacebefore)+vartostr(objParagraph.linerulebefore);   //段落格式.段前距离
        45: value := vartostr(objParagraph.spaceafter)+vartostr(objParagraph.lineruleafter); //段落格式.段后距离
        46: value := vartostr(objParagraph.spacewithin)+vartostr(objParagraph.linerulewithin);  //段落格式.行距
      {TODO 47知识点与91知识点重合？要检查}
        47: value := vartostr(objShape.TextFrame.Orientation);  //段落格式.文字方向
        48: if objParagraph.bullet.type=1 then
              value := vartostr(objParagraph.bullet.character)  //项目符号和编号.符号项样式
            else
              value := '';
        49: if objParagraph.bullet.type=2 then
              value := vartostr(objParagraph.bullet.style)  //项目符号和编号.编号项样式
            else
              value := '';
        50: if objParagraph.bullet.type=2 then
              value := vartostr(objParagraph.bullet.startvalue)  //项目符号和编号.编号项起始值
            else
              value := '';
        51: if objParagraph.bullet.type>0 then
              value := vartostr(objParagraph.bullet.font.color.rgb)  //项目符号和编号.颜色
            else
              value := '';
        52: if objParagraph.bullet.type>0 then
              value := vartostr(objParagraph.bullet.relativesize)  //项目符号和编号.大小
            else
              value := '';
      end;
    end
    else
    begin
      value := '该形状无文本框!'
    end;
  end
  else
  begin
    value := '无该索引形状!'
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
   // gradeinfo.Items[0].param1:='错误，可能是文档未打开';
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
     value := vartostr(MySlides.count)     //幻灯片总数
  else
  begin
    if mySlides.count>=strtoint(GradeInfo.ObjStr) then
    begin
      SlideObj:=APresentation.Slides.item(strtoint(GradeInfo.ObjStr));
      case GradeInfo.ID of
        { TODO -ojp -cppt : 设置单张幻灯片模板名称 }
        10: value := vartostr(SlideObj.parent.templateName);  //模板名称，此项放在这里不合适
        11: value := vartostr(SlideObj.layout);     //版式
        //12      
        13: value := vartostr(SlideObj.SlideShowTransition.entryEffect);    //片切换方式
        14: value := vartostr(SlideObj.SlideShowTransition.speed);         //片切换速度
        15: value := vartostr(SlideObj.SlideShowTransition.advanceonclick);         //片切单击鼠标换页
        16: begin
              if SlideObj.SlideShowTransition.advanceontime=-1 then
                value := vartostr(SlideObj.SlideShowTransition.advancetime)        //片切换指定时间换页
              else
                value := '';
            end;
        17: begin
              if SlideObj.SlideShowTransition.soundEffect.type<>0 then
                value := vartostr(SlideObj.SlideShowTransition.soundEffect.name)      // 片切换时声音效果
              else
                value := '';
            end;
        18: value := vartostr(SlideObj.SlideShowTransition.LoopSoundUntilnext);       //片切换时声音效果是否循环播放
        19: begin
              if SlideObj.background.fill.type=$00000004 then
                value := vartostr(SlideObj.background.fill.TextureName)       //背景纹理
              else
                value := '';
            end;
  //      19: begin
  //            if SlideObj.hyperlinks.count=1 then
  //              value := SlideObj.hyperlinks.item(1).subaddress //超链接
  //            else
  //              value := '';
  //          end;
  //      20: begin
  //            if SlideObj.shapes.hastitle then
  //            begin
  //              if SlideObj.shapes.Title.AnimationSettings.animate then
  //                value := SlideObj.shapes.Title.AnimationSettings.AdvanceMode //超链接
  //            end
  //            else
  //              value := '';
  //          end;
      end;
    end
    else
    begin
      value:= '无该索引幻灯片';
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
        60 : value := vartostr(objShape.animationsettings.animationorder);  //动画启动顺序
        61 :  value := vartostr(objShape.animationsettings.advanceMode);  //动画启动方式
        62 : value := vartostr(objShape.animationsettings.advancetime);  //动画启动时间
        {TODO 动画效果在2003下有很多项的值是一样的，如“进入-回旋”与“进入-展开”的值都是257}
        63 : value := vartostr(objShape.animationsettings.EntryEffect);  //动画效果
        64 : begin
                if objShape.animationsettings.soundEffect.type<>0 then
                  value := vartostr(objShape.animationsettings.soundEffect.name)      // 声音效果
                else
                  value := '';
             end;
        65 : value := vartostr(objShape.animationsettings.aftereffect);  //播放后动作
        { TODO -ojp -cppt : 播放后变颜色 }
    //    56 : value := vartostr(objShape.animationsettings.dimcolor);     //变暗颜色
        66 : value := vartostr(objShape.animationsettings.TextUnitEffect);  //引入文本方式
        67 : value := vartostr(objShape.animationsettings.TextLevelEffect);  //第几层段落分组
        68 : value := vartostr(objShape.animationsettings.AnimateTextInReverse);  //是否相反顺序
        69 : value := vartostr(objShape.animationsettings.ChartUnitEffect);  //图表引入方式
        70 : value := vartostr(objShape.animationsettings.AnimateBackground);  //网格线和图例是否显示动画
      end;
    end
    else
    begin
      value:='';
    end;      
  end
  else
  begin
    value:= '无该索引形状';
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
      { TODO -ojp -cppt : 按钮或文本超链接到文档或当前某张幻灯片 }
        75 : value := vartostr(objShape.actionsettings.item(1).action);       //鼠标单击动作类型
        76 :  begin
                if objShape.actionsettings.item(1).action=$00000007 then      //鼠标单击超链接地址
                  value :=strfilter( vartostr(objShape.actionsettings.item(1).hyperlink.address),GetModuleDelimiterChar())
                else
                  value :='';
              end;
        77 :  begin
                if objShape.actionsettings.item(1).action=$00000007 then      //鼠标单击超链接屏幕提示
                  value := vartostr(objShape.actionsettings.item(1).hyperlink.screentip)
                else
                  value :='';
              end;
        78 :  begin
                if objShape.actionsettings.item(1).soundEffect.type<>0 then
                  value := vartostr(objShape.actionsettings.item(1).soundEffect.name)      // 声音效果
                else
                  value := '';
              end;
        79 :  begin
                if objShape.actionsettings.item(1).action<>$00000000 then      //鼠标单击突出显示
                  value := vartostr(objShape.actionsettings.item(1).animateaction)
                else
                  value :='';
              end;
        80 : value := vartostr(objShape.actionsettings.item(2).action);       //鼠标移动动作类型
        81 :  begin
                if objShape.actionsettings.item(2).soundEffect.type<>0 then
                  value := vartostr(objShape.actionsettings.item(1).soundEffect.name)      // 鼠标移动声音效果
                else
                  value := '';
              end;
        82 :  begin
                if objShape.actionsettings.item(2).action<>$00000000 then      //鼠标移动突出显示
                  value := vartostr(objShape.actionsettings.item(1).animateaction)
                else
                  value :='';
              end;
      end;

  end
  else
  begin
    value:= '无该索引形状';
  end;
  if aFillMode = fmStandValue then
    GradeInfo.StandardValue:=value
  else
    GradeInfo.ExamineValue:=value;
  result:=-1;
end;

//        50:if SlideObj.shapes.hastitle then
//         if SlideObj.shapes.title.TextFrame.textRange.text=Items[index].Param1 then   //幻灯片标题文本
//            begin
//              FPoints:=FPoints+Items[index].Points;
//            end;
//        80:if SlideObj.shapes.hastitle then
//         if SlideObj.shapes.title.TextFrame.textRange.font.name=Items[index].Param1 then   //幻灯片标题文本
//            begin
//              FPoints:=FPoints+Items[index].Points;
//            end;
//        81:if SlideObj.shapes.hastitle then
//         if SlideObj.shapes.title.TextFrame.textRange.font.size=strtoint(Items[index].Param1) then   //幻灯片标题文本
//            begin
//              FPoints:=FPoints+Items[index].Points;
//            end;
//        86: if SlideObj.shapes.hastitle then
//         if SlideObj.shapes.title.TextFrame.textRange.paragraphformat.alignment=strtoint(Items[index].Param1) then   // 对齐方式
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
//        foundtext := txtrng.find('结构');
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
              value := vartostr(objFillFormat.forecolor.rgb)    //背景.填充背景色
           else
              value := 'Null';
      101: if objFillFormat.type=$00000001 then
              value := vartostr(objFillFormat.transparency)    //背景.透明度
           else
              value := 'Null';
      102: if objFillFormat.type=$00000003 then
              value := vartostr(objFillFormat.GradientColorType)    //背景.过渡颜色类型
           else
              value := 'Null';
      103: if objFillFormat.type=$00000003 then
              if (objFillFormat.gradientcolortype=$00000001)or(objFillFormat.gradientcolortype=$00000002) then
                 value := vartostr(objFillFormat.forecolor.rgb)    //背景.过渡颜色一
              else
                 value :='null'
           else
              value := 'Null';
      104: if objFillFormat.type=$00000003 then
              if objFillFormat.gradientcolortype=$00000002 then
                 value := vartostr(objFillFormat.backcolor.rgb)    //背景.过渡颜色二
              else
                 value :='null'
           else
              value := 'Null';
      105: if objFillFormat.type=$00000003 then
              if objFillFormat.gradientcolortype=$00000003 then
                 value := vartostr(objFillFormat.PresetGradientType)    //背景.预设过渡类型
              else
                 value :='null'
           else
              value := 'Null';
//      106: if objFillFormat.type=$00000003 then
//              value := vartostr(objFillFormat.gradientdegree)    //背景.过渡颜色深浅
//           else
//              value := 'Null';
      107: if objFillFormat.type=$00000003 then
              value := vartostr(objFillFormat.GradientStyle)    //背景.过渡底纹样式
           else
              value := 'Null';
      108: if objFillFormat.type=$00000003 then
              value := vartostr(objFillFormat.GradientVariant)    //背景.过渡变形
           else
              value := 'Null';
      109: if objFillFormat.type= $00000004 then
              value := vartostr(objFillFormat.texturename)    //背景.纹理
           else
               value := 'Null';
      110: if objFillFormat.type= $00000002 then
              value := vartostr(objFillFormat.pattern)    //背景.图案样式
           else
               value := 'Null';
      111: if objFillFormat.type= $00000002 then
              value := vartostr(objFillFormat.forecolor.rgb)    //背景.图案前景
           else
               value := 'Null';
      112: if objFillFormat.type= $00000002 then
              value := vartostr(objFillFormat.backcolor.rgb)    //背景.图案背景
           else
               value := 'Null';
    end;
  end
  else
  begin
    value := '无该索引的形状!'
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
                { TODO -ojp : 添加检查enter }
        90: value :=StrFilter(vartostr(objTextFrame.Textrange.text));        //文本框.文本内容
        91: value := vartostr(objTextFrame.orientation);   //文本框.文本方向
        92: value := vartostr(objTextFrame.HorizontalAnchor)+vartostr(objTextFrame.VerticalAnchor);   //文本框.文本锁定点
        93: value := vartostr(objTextFrame.margintop); //文本框.内部上边距
        94: value := vartostr(objTextFrame.marginbottom); //文本框.内部下边距
        95: value := vartostr(objTextFrame.marginleft); //文本框.内部左边距
        96: value := vartostr(objTextFrame.marginright); //文本框.内部右边距
        97: value := vartostr(objTextFrame.wordwrap); // 文本框.自动换行
      end;
    end
    else
    begin
      value := '该形状无文本框!'
    end
  end
  else
  begin
    value := '无该索引形状!'
  end;
  if aFillMode = fmStandValue then
    GradeInfo.StandardValue:=value
  else
    GradeInfo.ExamineValue:=value;
  result:=-1;
end;

end.
