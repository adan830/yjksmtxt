unit uSysPublic;


interface
uses cxtreeview,CheckTreeView,comctrls,classes,types,windows,adodb;
type
  TDataMode=(dmBrowse,dmModify,dmInsert,dmNew,dmDelete,dmCancel,dmSave);     //

  TNodeType=(ntSub,ntEQType,ntKnow,ntKnowRoot,ntEQ);  // 0: subject node  ;  1: Exam Question type 2: Knowledge
  //strategy tree node
  NodeDataRec = record
    nodetype: TNodeType;
    grade: Integer;
    ID: string;
    parentID: string;
    Name: string;
    subNum: Integer;
    EQNum: Integer;
    Memo: string;
    Category: Integer;
  end;

  pNodeDataRec=^NodeDataRec;
  
        {
                流输入输出基本方法
                来源于柯兄的报表单元                
        }
  TStreamIO = class
  public
   { stream read functions... }
    
    class function BoolFromStream(Stream: TStream): Boolean;
    class function ByteFromStream(Stream: TStream): Byte;
    class function IntFromStream(Stream: TStream): Integer;
    class function LongIntFromStream(Stream: TStream): LongInt;
    class function FloatFromStream(Stream: TStream): Extended;
    class function SizeFromStream(Stream: TStream): TSize;
    class function RectFromStream(Stream: TStream): TRect;
    class function ColorFromStream(Stream: TStream): COLORREF;
    class function PointFromStream(Stream: TStream): TPoint;
    class function StringFromStream(Stream: TStream): string;
    class function DateTimeFromStream(Stream : TStream) : TDateTime;
    class procedure StreamFromStream(Source, SubStream: TStream);

    { stream write functions... }

    class procedure BoolToStream(Stream: TStream; Value: Boolean);
    class procedure ByteToStream(Stream: TStream; Value: Byte);
    class procedure IntToStream(Stream: TStream; Value: Integer);
    class procedure LongIntToStream(Stream: TStream; Value: LongInt);
    class procedure FloatToStream(Stream: TStream; Value: Extended);
    class procedure SizeToStream(Stream: TStream; Value: TSize);
    class procedure RectToStream(Stream: TStream; Value: TRect);
    class procedure ColorToStream(Stream: TStream; Value: COLORREF);
    class procedure PointToStream(Stream: TStream; Value: TPoint);
    class procedure StringToStream(Stream: TStream; Value: string);
    class procedure DateTimeToStram(Stream : TStream; Value : TDateTime);
    class procedure StreamToStream(Stream, SubStream: TStream);
  end;


  //initialize treeview of category
  procedure SetTVCategoryPoint(tv:TcxTreeView);overload;
  procedure SetTVCategoryPoint(tv:TCheckTree);overload;


  //changeSubject
  procedure ChangeSubject(SubName: string);

  procedure SetKnowledgeTree(root:TTreeNode;items:TTreeNodes);
  function InsertKnowPoint(root:TTreeNode;items:TTreeNodes;ID:string): TTreeNode;

  //id to name ; id is many 
  function KnowledgePointIDToName(ID: string;SubID:Integer): string;
  function IDToNameEQType(EQTypeid: integer): string;
  function IDToNameEQDepth(EQDepthID:integer):string;
  function IDToNameSubjectTable(Subid: integer): string;

  //根据知识点树的选择，重新设置数据库试题列表
  procedure GetEQListOnKnowTree(node:TTreenode;dataset:TADODataSet);

  procedure  SaveStreamToClipboard(strm:TStream);
  //科目列表
  procedure InitSubjectList(items:TStrings);


  function GetExeFilePath:string;


  //字符串加密
  function EncryptStr(Src: String; Key: String): String;
  //字符串解密
  function DecryptStr(Src: String; Key: String): String;

implementation
uses udmMain,SysUtils,variants,clipbrd,Forms;

{
procedure SetTVCategoryPoint(tv:TcxTreeView);
var
  stTemp: TADODataSet;
  root, node1, node2: TTreeNode;
  pNodeRec: PKnowledgeRec;

  procedure GetParent(ID:String);
  var
     i:integer;
     count:integer;
  begin
    count:=tv.Items.Count;

    for i:=0 to count-1 do
    begin
       pnoderec:=PKnowledgeRec(tv.Items[i].Data);
       if PKnowledgeRec(tv.Items[i].Data).ID=trim(ID) then
       begin
         node1:=tv.Items[i];
         exit;
       end;
       node1:=nil;
    end;
  end;

begin
  stTemp:=TADODataSet.Create(nil);
  try
     stTemp.Connection:=dmMain.cnMain;

     stTemp.CommandText:='select * from 知识点 where 科目ID=:vSub order by 级别,ID';
     stTemp.Parameters.ParamByName('vSub').Value:=dmMain.SubRec.ID;
     stTemp.Active:=true;

     stTemp.First;
     with tv.items do
     begin
        BeginUpdate;

        new(pNodeRec);
        pNoderec.typeFlag:=1;
        pNodeRec.grade:=0;
        pNodeRec.name:=dmMain.subrec.name+'知识点';
        pNodeRec.ID:='A';
        pNodeRec.ParentID:='A';
        root:=AddObject(nil,'知识点',pNodeRec);

        stTemp.Next;

        while not stTemp.Eof do
        begin
           GetParent(sttemp.fieldbyname('父ID').AsString);
           if assigned(node1) then
           begin
             new(pNodeRec);
             pNodeRec.typeFlag:=1;
             pNodeRec.grade:=sttemp.fieldbyname('级别').asinteger;
             pNodeRec.name:=sttemp.fieldbyname('知识点').asstring;
             pNodeRec.ID:=trim(sttemp.fieldbyname('ID').asstring);
             pNodeRec.ParentID:=trim(sttemp.fieldbyname('父ID').asstring);
             AddChildObject(node1,pNodeRec.name,pNodeRec);
           end;
           stTemp.Next;
        end;
             //无知识点试题类
             new(pNodeRec);
             pNodeRec.typeFlag:=1;
             pNodeRec.grade:=1;
             pNodeRec.name:='未录入知识点试题';
             pNodeRec.ID:='B';
             pNodeRec.ParentID:='A';
             AddChildObject(root,pNodeRec.name,pNodeRec);
             //全部试题类
             new(pNodeRec);
             pNodeRec.typeFlag:=1;
             pNodeRec.grade:=1;
             pNodeRec.name:='全部试题';
             pNodeRec.ID:='%';
             pNodeRec.ParentID:='A';
             AddChildObject(root,pNodeRec.name,pNodeRec);

        EndUpdate;
     end;
  finally
     stTEmp.Free;
  end;
end;
 }

procedure SetTVCategoryPoint(tv:TcxTreeView) ;
begin
  SetKnowledgeTree(nil,tv.Items);
end;

procedure SetTVCategoryPoint(tv:TCheckTree);
begin
  SetKnowledgeTree(nil,tv.Items);
{ old
var
  stTemp: TADODataSet;
  root, node1, node2: TTreeNode;
  pNodeRec: PKnowledgeRec;

  procedure GetParent(ID:String);
  var
     i:integer;
     count:integer;
  begin
    count:=tv.Items.Count;

    for i:=0 to count-1 do
    begin
       pnoderec:=PKnowledgeRec(tv.Items[i].Data);
       if PKnowledgeRec(tv.Items[i].Data).ID=trim(ID) then
       begin
         node1:=tv.Items[i];
         exit;
       end;
       node1:=nil;
    end;
  end;

begin
  stTemp:=TADODataSet.Create(nil);
  try
     stTemp.Connection:=dmMain.cnMain;

     stTemp.CommandText:='select * from 知识点 where 科目ID=:vSub order by 级别,ID';
     stTemp.Parameters.ParamByName('vSub').Value:=dmMain.SubRec.ID;
     stTemp.Active:=true;

     stTemp.First;
     with tv.items do
     begin
        BeginUpdate;

        new(pNodeRec);
        pNoderec.typeFlag:=1;
        pNodeRec.grade:=0;
        pNodeRec.name:=dmMain.subrec.name+'知识点';
        pNodeRec.ID:='A';
        pNodeRec.ParentID:='A';
        root:=AddObject(nil,'知识点',pNodeRec);

        stTemp.Next;

        while not stTemp.Eof do
        begin
           GetParent(sttemp.fieldbyname('父ID').AsString);
           if assigned(node1) then
           begin
             new(pNodeRec);
             pNodeRec.typeFlag:=1;
             pNodeRec.grade:=sttemp.fieldbyname('级别').asinteger;
             pNodeRec.name:=sttemp.fieldbyname('知识点').asstring;
             pNodeRec.ID:=trim(sttemp.fieldbyname('ID').asstring);
             pNodeRec.ParentID:=trim(sttemp.fieldbyname('父ID').asstring);
             AddChildObject(node1,pNodeRec.name,pNodeRec);
           end;
           stTemp.Next;
        end;

  
        EndUpdate;
     end;
  finally
     stTEmp.Free;
  end;
   }
end;

procedure ChangeSubject(SubName: string);
var
  stTemp:TADODataSet;
begin
  stTemp:=TADODataSet.Create(nil);
  try
     with stTemp do
     begin
       Connection:=dmMain.cnMain;
       CommandText:='select * from 科目 where 名称= :vName';
       Parameters.ParamByName('vName').Value:=subName;
       Active:=true;
       if not IsEmpty then
       begin
         //set subject record
         dmMain.subRec.ID:=fieldbyname('ID').AsInteger;
         dmMain.subRec.Name:=fieldbyname('名称').AsString;
         dmMain.subRec.Tablename:=fieldbyname('试题表名').AsString;

         //set examquest Dataset to subject table
         with dmMain.stExamQuest do
         begin
            DisableControls;
            Active:=false;
            //CommandText:='select ID,难易度,	题型ID,	分值,	知识点ID组,	使用日期,	使用次数,	修改日期 from '+dmMain.subRec.Tablename;
            CommandText:='select st.ID,st.难易度,题型ID,题型,难度,分值,知识点ID组,使用日期,使用次数,修改日期 from '+dmMain.SubRec.Tablename+' as st left join 难度  on ( st.难易度=难度.id ) left join 题型 as tx on (st.题型ID=TX.ID)';
            Active:=true;
            EnableControls;
         end;
       end
       else begin
         raise exception.Create('科目选择错误');
       end;
     end;
  finally
    stTemp.Free;
  end;
end;


procedure SetKnowledgeTree(root:TTreeNode;items:TTreeNodes);
var
  index: Integer;
  node: TTreeNode;
  node1: TTreeNode;
  stTemp: TADODataSet;
  pData: PNodeDataRec;
  value:integer;
begin
  value:=1;
  //root:=getRoot;
  if root=nil then
  begin
    if items.Count>0 then
    begin
      items.Clear;
    end;
    new(pData);
    pData.nodetype:=ntKnow;
    pData.grade:=0;
    pData.ID:='A';
    pData.parentID:='A';
    pData.Name:=dmMain.subRec.name+'知识点';
    pData.Category:=1;
    root:=items.AddObject(nil,dmMain.subRec.name+'知识点',pData);
  end;
  if root<>nil then
  begin
      if value=1 then
      begin
       // if not FAllKnowPointDisp then
        begin
           stTemp:=TADODataSet.Create(nil);
           with stTemp do
           begin
           try
             Connection:=dmMain.cnMain;
             stTemp.CommandText:='select * from 知识点 where 科目ID=:vSub order by 级别,ID';
             stTemp.Parameters.ParamByName('vSub').Value:=dmMain.SubRec.ID;
             active:=true;
  
             first;


            Items.BeginUpdate;
             try
               while (not eof)and (not IsEmpty) do
               begin
                  InsertKnowPoint(root,items,trim(sttemp.fieldbyname('ID').AsString));
                  next;
               end;
  
             finally
               Items.EndUpdate;

               Free;
             end;
  

           except
  
           end; //end dataset try end;
        end;
      end;
      end ;
      {
      else begin
        node:=node.getFirstChild;
        node1:=node;
        while node<>nil do
        begin
          node1:=node.getNextSibling;
          if  node.StateIndex=1 then
            node.Delete;
          node:=node1;
        end;
      end;
      }
  end;
end;



  function InsertKnowPoint(root:TTreeNode;items:TTreeNodes;ID:string): TTreeNode;
var
  i: Integer;
  stTemp: TADODataSet;
  node: TTreeNode;
  pData: PNodeDataRec;
  
  function FindNode(ID:string): TTreeNode;
  var
    node2:TTreeNode;
    pData:PNodeDataRec;
  begin
    result:=nil;
    if ID='A' then
    begin
      result:=root;
      exit;
    end;

    if root.HasChildren then
    begin
      node2:=root.getNext;
      result:=nil;
      while (node2<>nil)and (PNodeDataRec(node2.data).NodeType=ntKnow) do
      begin
        if pNodeDataRec(node2.data).ID=ID then
        begin
          result:=node2;
          exit;
        end;
        node2:=node2.getnext;
      end;
    end
    else begin
      result:=nil;
    end;
  
  
  end;
  
  function GetKnowData(subID:integer;KnowID:string): pNodeDataRec;
  var
    stTemp:TADODataSet;
    pData:PNodeDataRec;
  begin
    stTemp:=TADODataSet.Create(nil);
    try
       stTemp.Connection:=dmMain.cnMain;
  
       stTemp.CommandText:='select * from 知识点 where (科目ID=:vSub) and (ID=:vID)';
       stTemp.Parameters.ParamByName('vSub').Value:=subID;
       stTemp.Parameters.ParamByName('vID').Value:=KnowID;
       stTemp.Active:=true;
  
       stTemp.First;
       if (not stTemp.IsEmpty) and (not stTemp.Eof) then
       begin
          new(pData);
          pData.nodetype:=ntKnow;
          pData.grade:=sttemp.fieldbyname('级别').AsInteger;
          pData.ID:=trim(sttemp.fieldbyname('ID').AsString);
          pData.parentID:=trim(sttemp.fieldbyname('父ID').AsString);
          pData.Name:=trim(sttemp.fieldbyname('知识点').AsString);
          pData.Category:=sttemp.fieldbyname('分类').AsInteger;
          result:=pData;
       end;
    finally
       stTemp.Free;
    end;
  end;

begin
  pData:=GetKnowData(dmMain.SubRec.ID,ID);
  node:=FindNode(pData.ID);
  if node<>nil then
  begin
     result:=node;
  end
  else begin

     node:=FindNode(pData.parentID);

     if node=nil then
     begin
        node:=InsertKnowPoint(root,items,pData.parentID);
     end;
     
     result:=Items.AddChildObject(node,pData.name,pData);
  end;
end;

function KnowledgePointIDToName(ID: string;SubID:integer): string;
var
  strlist:TStringList;
  stTemp:TADODataSet;
  i:integer;
begin
  stTemp:=TADODataSet.Create(nil);
  strList:=TSTringList.Create;
  ExtractStrings([','],[' '],pchar(Id),strlist);
  with stTemp do
  begin
    Connection:=dmMain.cnMain;
    CommandText:='select * from 知识点 where (科目ID=:vSub) and (ID=:vID)';
    Parameters.ParamByName('vsub').Value:=SubID;
    try
      for i:=0 to strlist.Count-1 do
      begin
        Parameters.ParamByName('vID').Value:=strlist[i];
        active:=true;
        first;
        if not eof and not IsEmpty then
        begin
          result:=result+fieldbyname('知识点').AsString+',';
        end;
        Active:=false;
      end;
    finally
      strlist.Free;
      stTemp.Free;
    end;
  end;

end;

{ TStreamIO }

class function TStreamIO.BoolFromStream(Stream: TStream): Boolean;
begin
  Stream.ReadBuffer(Result, SizeOf(Result));
end;

class procedure TStreamIO.BoolToStream(Stream: TStream; Value: Boolean);
begin
  Stream.WriteBuffer(Value, SizeOf(Value));
end;

class function TStreamIO.ByteFromStream(Stream: TStream): Byte;
begin
  Stream.ReadBuffer(Result, SizeOf(Result));
end;

class procedure TStreamIO.ByteToStream(Stream: TStream; Value: Byte);
begin
  Stream.WriteBuffer(Value, SizeOf(Value));
end;

class function TStreamIO.ColorFromStream(Stream: TStream): COLORREF;
begin
  Stream.ReadBuffer(Result, SizeOf(Result));
end;

class procedure TStreamIO.ColorToStream(Stream: TStream; Value: COLORREF);
begin
  Stream.WriteBuffer(Value, SizeOf(Value));
end;

class function TStreamIO.DateTimeFromStream(Stream: TStream): TDateTime;
begin
  Stream.ReadBuffer(result, SizeOf(result));
end;

class procedure TStreamIO.DateTimeToStram(Stream: TStream;
  Value: TDateTime);
begin
  Stream.WriteBuffer(Value, SizeOf(Value));
end;

class function TStreamIO.FloatFromStream(Stream: TStream): Extended;
begin
  Stream.ReadBuffer(Result, SizeOf(Result));
end;

class procedure TStreamIO.FloatToStream(Stream: TStream; Value: Extended);
begin
  Stream.WriteBuffer(Value, SizeOf(Value));
end;

class function TStreamIO.IntFromStream(Stream: TStream): Integer;
begin
  Stream.ReadBuffer(Result, SizeOf(Result));
end;

class procedure TStreamIO.IntToStream(Stream: TStream; Value: Integer);
begin
  Stream.WriteBuffer(Value, SizeOf(Value));
end;

class function TStreamIO.LongIntFromStream(Stream: TStream): LongInt;
begin
  Stream.ReadBuffer(Result, SizeOf(Result));
end;

class procedure TStreamIO.LongIntToStream(Stream: TStream; Value: Integer);
begin
  Stream.WriteBuffer(Value, SizeOf(Value));
end;

class function TStreamIO.PointFromStream(Stream: TStream): TPoint;
begin
  Stream.ReadBuffer(Result, SizeOf(Result));
end;

class procedure TStreamIO.PointToStream(Stream: TStream; Value: TPoint);
begin
  Stream.WriteBuffer(Value, SizeOf(Value));
end;

class function TStreamIO.RectFromStream(Stream: TStream): TRect;
begin
  Stream.ReadBuffer(Result, SizeOf(Result));
end;

class procedure TStreamIO.RectToStream(Stream: TStream; Value: TRect);
begin
  Stream.WriteBuffer(Value, SizeOf(Value));
end;

class function TStreamIO.SizeFromStream(Stream: TStream): TSize;
begin
  Stream.ReadBuffer(Result, SizeOf(Result));
end;

class procedure TStreamIO.SizeToStream(Stream: TStream; Value: TSize);
begin
  Stream.WriteBuffer(Value, SizeOf(Value));
end;

class procedure TStreamIO.StreamFromStream(Source, SubStream: TStream);
var
  StreamSize: Integer;
begin
  StreamSize := IntFromStream(Source);
  if StreamSize > 0 then
    SubStream.CopyFrom(Source, StreamSize);
end;

class procedure TStreamIO.StreamToStream(Stream, SubStream: TStream);
var
  StreamSize: Integer;
begin
  StreamSize := SubStream.Size;
  IntToStream(Stream, StreamSize);
  if StreamSize > 0 then
  begin
    SubStream.Seek(0, soFromBeginning);
    Stream.CopyFrom(SubStream, StreamSize);
  end;
end;

class function TStreamIO.StringFromStream(Stream: TStream): string;
var
  ALength: Integer;
begin
  ALength := IntFromStream(Stream);
  if ALength > 0 then
  begin
    SetLength(Result, ALength);
    Stream.ReadBuffer(Result[1], ALength);
  end;
end;

class procedure TStreamIO.StringToStream(Stream: TStream; Value: string);
begin
  IntToStream(Stream, Length(Value));
  Stream.WriteBuffer(Value[1], Length(Value));
end;


function IDToNameEQType(EQTypeid: integer): string;
var
  stTemp:TADODataSet;
begin
  stTemp:=TADODataSet.Create(nil);
  try
    stTemp.Connection:=dmmain.cnMain;
    stTemp.CommandText := 'select * from 题型 where ID= :vid';
    stTemp.Parameters.ParamByName('vid').Value:=EQTypeid;
    stTemp.Active:=true;

    if not sttemp.IsEmpty then
    begin
      result:=stTemp.fieldbyname('题型').AsString;
    end
    else begin
      Result:=null;
    end;    
  finally // wrap up
    stTemp.Free;
  end;    // try/finally


end;
function IDToNameSubjectTable(Subid: integer): string;
var
  stTemp:TADODataSet;
begin
  stTemp:=TADODataSet.Create(nil);
  try
    stTemp.Connection:=dmmain.cnMain;
    stTemp.CommandText := 'select * from 科目 where ID= :vid';
    stTemp.Parameters.ParamByName('vid').Value:=subid;
    stTemp.Active:=true;

    if not sttemp.IsEmpty then
    begin
      result:=stTemp.fieldbyname('名称').AsString;
    end
    else begin
      Result:=null;
    end;    
  finally // wrap up
    stTemp.Free;
  end;    // try/finally


end;


function IDToNameEQDepth(EQDepthID:integer):string;
var
  stTemp:TADODataSet;
begin
  stTemp:=TADODataSet.Create(nil);
  try
    stTemp.Connection:=dmmain.cnMain;
    stTemp.CommandText := 'select * from 难度 where ID= :vid';
    stTemp.Parameters.ParamByName('vid').Value:=EQdepthid;
    stTemp.Active:=true;

    if not sttemp.IsEmpty then
    begin
      result:=stTemp.fieldbyname('难度').AsString;
    end
    else begin
      Result:=null;
    end;



  finally // wrap up
    stTemp.Free;
  end;    // try/finally
end;

procedure  SaveStreamToClipboard(strm:TStream);
var
  MyFormat : Word;
  hClip:THandle;
  hMem:Pointer;

const
  formatname='Rich Text Format';
begin
  Clipboard.Clear;
  hClip:=globalalloc(GMEM_MOVEABLE + GMEM_DDESHARE,strm.Size);
  hmem:=globallock(hClip);
  strm.Position:=0;
  strm.read(hmem^,strm.size);
  globalunlock(hClip);
  myformat:=RegisterClipboardFormat(pchar(formatname));
  clipboard.SetAsHandle(myFormat,hclip);
end;

procedure InitSubjectList(items:TStrings);
var
  setTemp:TADODataSet;
begin
  setTemp:=TADODataSet.Create(nil);
  try
    setTemp.Connection:=dmMain.cnMain;
    setTemp.CommandText:='select * from 科目';
    settemp.Active:=true;
    setTemp.first;
    while not settemp.Eof do
    begin
      Items.Add(setTemp.fieldbyname('名称').AsString);
      setTemp.Next;
    end;

  finally
    setTemp.Free;
  end;
end;



procedure GetEQListOnKnowTree(node:TTreeNode;dataset:TADODataSet);
var
  pData: PNodeDataRec;
begin
  with dataset do
  begin
    DisableControls;
    Active:=false;
    if not (node.Data=nil) then
    begin
      pData:=PNodeDataRec(node.Data);

      if pData.ID='A' then
         CommandText:='select st.ID,st.难易度,题型ID,题型,难度,分值,知识点ID组,使用日期,使用次数,修改日期 from '+dmMain.SubRec.Tablename+' as st left join 难度  on ( st.难易度=难度.id ) left join 题型 as tx on (st.题型ID=TX.ID)  '
      else begin
         CommandText:='select st.ID,st.难易度,题型ID,题型,难度,分值,知识点ID组,使用日期,使用次数,修改日期 from '+dmMain.SubRec.Tablename+' as st left join 难度  on ( st.难易度=难度.id ) left join 题型 as tx on (st.题型ID=TX.ID)  where  (st.知识点ID组 like :vZsd)';
        Parameters.ParamByName('vZsd').Value:=trim(pData.ID)+'%';
      end;
    end
    else begin
      CommandText:='select st.ID,st.难易度,题型ID,题型,难度,分值,知识点ID组,使用日期,使用次数,修改日期 from '+dmMain.SubRec.Tablename+' as st left join 难度  on ( st.难易度=难度.id ) left join 题型 as tx on (st.题型ID=TX.ID)  ';
    end;
    Active:=true;
    EnableControls;
  end;
end;

function GetExeFilePath:string;
begin
  result:=ExtractFilePath(application.exeName);
end;

//字符串加密
function EncryptStr(Src: String; Key: String): String;

var
  KeyLen :Integer;
  KeyPos :Integer;
  offset :Integer;
  dest :string;
  SrcPos :Integer;
  SrcAsc :Integer;
  Range :Integer;
begin
  KeyLen:=Length(Key);
  if KeyLen = 0 then
    key:='jiaping';
  KeyPos:=0;
  Range:=256;

  Randomize;
  offset:=Random(Range);
  dest:=format('%1.2x',[offset]);
  for SrcPos := 1 to Length(Src) do
  begin
    SrcAsc:=(Ord(Src[SrcPos]) + offset) MOD 255;
    if KeyPos < KeyLen then
      KeyPos:= KeyPos + 1
    else
      KeyPos:=1;
    SrcAsc:= SrcAsc xor Ord(Key[KeyPos]);
    dest:=dest + format('%1.2x',[SrcAsc]);
    offset:=SrcAsc;
  end;
  Result:=Dest;
end;


//字符串解密
function DecryptStr(Src: String; Key: String): String;
var
  KeyLen :Integer;
  KeyPos :Integer;
  offset :Integer;
  noff:Integer;
  dest :string;
  SrcPos :Integer;
  SrcAsc :Integer;
  sTemp:string;
begin
  KeyLen:=Length(Key);
  if KeyLen = 0 then
    key:='jiaping';
  KeyPos:=0;
  dest:='';
  sTemp:='$'+src[1]+src[2];
  offset:=strtoint(sTemp);
  for SrcPos := 2 to Length(Src) div 2 do
  begin
    if KeyPos < KeyLen then
      KeyPos:= KeyPos + 1
    else
      KeyPos:=1;
    SrcAsc:=strtoint('$'+src[SrcPos*2-1]+src[SrcPos*2]);
    noff:=SrcAsc;
    SrcAsc:= SrcAsc xor Ord(Key[KeyPos]);

    if SrcAsc<offset then
      srcasc:=SrcAsc+255;
    SrcAsc:=SrcAsc-offset;
    dest:=dest + chr(SrcAsc);
    offset:=noff;
  end;
  Result:=Dest;
end;


end.
