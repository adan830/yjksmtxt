unit compress;

interface
uses
  Classes, SysUtils,zlib;
 //ѹ���㷨 ����ʵ��ѹ����
Function CompressStream(var CompressedStream: TMemoryStream;const CompressionLevel: TCompressionLevel = clDefault):Extended;
///��ѹ������
procedure UnCompressStream(var UnCompressedStream: TMemoryStream);
/// test case is in TestExamCommonsCompress
function   FileCompression(mFileName:   TFileName;   mStream:   TStream):   Integer;
function   FileDecompression(mFileName:   TFileName;   mStream:   TStream):   Integer;
function   StrLeft(const   mStr:   string;   mDelimiter:   string):   string;
function   StrRight(const   mStr:   string;   mDelimiter:   string):   string;

{-------------------------------------------------------------------------------
  ������:    DirectoryCompression		����:      2009.05.04
  ����:      mDirectory:TFileName;
               out AStream:TMemoryStream
  ����ֵ:    Integer
  ˵��:      ע��ATream����������ʱ���ܴ�������Ϊ�����ڻᴴ��
-------------------------------------------------------------------------------}

/// test case is in TestExamCommonsCompress
function   DirectoryCompression(mDirectory:TFileName;out AStream:TMemoryStream):   Integer; //stdcall;
/// test case is in TestExamCommonsCompress
function   DirectoryDecompression(ADirectory:   TFileName;AMemStream:TMemoryStream):   Integer;  //stdcall;

{-------------------------------------------------------------------------------
  ������:    UnZipExamPackFile2Dir		����:      2009.04.29
  ����:      AFile:string; ��ʾ������ļ�������·��
             ATargetPath:string;��ѹ��λ��
             AIncludeFilename:Boolean=True �Ƿ���Ҫ�����ļ�����Ϊ���ļ���
  ˵��:  ����������ļ���ѹ��ָ��Ŀ¼��
-------------------------------------------------------------------------------}
procedure UnZipExamPackFile2Dir(AFile:string;ATargetPath:string;AIncludeFilename:Boolean=True);

//==============================================================================
// ѹ�������÷���Ϣ��غ���
//==============================================================================
//procedure CompressScoreInfo(sourceStream,targetStream:TMemoryStream);
//procedure UnCompressScoreInfo(sourceStream,targetStream:TMemoryStream);

implementation
uses Commons,ExamException,ExamResourceStrings;

  const   cBufferSize   =   $4096;   
/// test case is in TestExamCommonsCompress
///��ǰ�ɰ�������Ϊ0���ļ�
  function   FileCompression(mFileName:   TFileName;   mStream:   TStream):   Integer;
  var   
      vFileStream:   TFileStream;
      vBuffer:   array[0..cBufferSize]of   Char;
      vPosition:   Integer;
      I:   Integer;
  begin
      Result   :=   -1;
      if   not   FileExists(mFileName)   then   Exit;
      if   not   Assigned(mStream)   then   Exit;   
      vPosition   :=   mStream.Position;   
      try
         vFileStream   :=   TFileStream.Create(mFileName,   fmOpenRead   or   fmShareDenyNone);

         with   TCompressionStream.Create(clMax,   mStream)   do   try
             for   I   :=   1   to   vFileStream.Size   div   cBufferSize   do   begin   
                 vFileStream.Read(vBuffer,   cBufferSize);   
                 Write(vBuffer,   cBufferSize);
             end;   
             I   :=   vFileStream.Size   mod   cBufferSize;
             if   I   >   0   then   begin   
                 vFileStream.Read(vBuffer,   I);   
                 Write(vBuffer,   I);
             end;
         finally   
             Free;
             vFileStream.Free;
         end;
      except
         on E:Exception do  begin
            raise Exception.Create('error -jp :'+e.Message);
         end;
      end;   
      
      Result   :=   mStream.Size   -   vPosition;   //����   
  end;   {   FileCompression   }

  function   FileDecompression(mFileName:   TFileName;   mStream:   TStream):   Integer;
  var
      vFileStream:   TFileStream;
      vBuffer:   array[0..cBufferSize]of   Char;
      I:   Integer;
  begin
      Result   :=   -1;
      if   not   Assigned(mStream)   then   Exit;
      ForceDirectories(ExtractFilePath(mFileName));   //����Ŀ¼

      vFileStream   :=   TFileStream.Create(mFileName,   fmCreate   or   fmShareDenyWrite);

      with   TDecompressionStream.Create(mStream)   do   try
          repeat
              I   :=   Read(vBuffer,   cBufferSize);
              vFileStream.Write(vBuffer,   I);
          until   I   =   0;
          Result   :=   vFileStream.Size;
      finally
          Free;
          vFileStream.Free;
      end;
  end;   {   FileDecompression   }
    
  function   StrLeft(const   mStr:   string;   mDelimiter:   string):   string;
  begin   
      Result   :=   Copy(mStr,   1,   Pos(mDelimiter,   mStr)   -   1);
  end;   {   StrLeft   }   
    
  function   StrRight(const   mStr:   string;   mDelimiter:   string):   string;
  begin   
      if   Pos(mDelimiter,   mStr)   >   0   then
          Result   :=   Copy(mStr,   Pos(mDelimiter,   mStr)   +   Length(mDelimiter),   MaxInt)   
      else   Result   :=   '';   
  end;   {   StrRight   }   
    
  type
      TFileHead   =   packed   record   
          rIdent:   array[0..2]   of   Char;   //��ʶ   
          rVersion:   Byte;   //�汾   
      end;   
    
  const   
      cIdent   =   'zsf';   
      cVersion   =   $01;   
      cErrorIdent   =   -1;   
      cErrorVersion   =   -2;   
    
/// test case is in TestExamCommonsCompress
{ TODO -ojiaping -c* : ��ǰ���ܰ�����Ŀ¼������Ҫ������Ŀ¼�����������²�Ŀ¼�а���һ���ļ� }
  function   DirectoryCompression(mDirectory:TFileName;out AStream:TMemoryStream):   Integer;
  var
      vFileInfo:   TStrings;
      vFileInfoSize:   Integer;
      vFileInfoBuffer:   PChar;
      vFileHead:   TFileHead;   
    
      vMemoryStream:   TMemoryStream;   
      vFileStream:   TFileStream;   

      procedure   pAppendFile(mSubFile:   TFileName);   
      begin
          vFileInfo.Append(Format('%s|%d',
              [StringReplace(mSubFile,   mDirectory   +   '\',   '',   [rfReplaceAll,   rfIgnoreCase]),   
                  FileCompression(mSubFile,   vMemoryStream)]));
          Inc(Result);
      end;   {   pAppendFile   }

      procedure   pSearchFile(mPath:   TFileName);   
      var   
          vSearchRec:   TSearchRec;
          K:   Integer;
          attr:Integer;
      begin
          attr:= faAnyFile ;
          K   :=   FindFirst(mPath   +   '\*.*',   attr,   vSearchRec);
          while   K   =   0   do   begin
              if   (vSearchRec.Attr   and   faDirectory   >   0)   and (Pos(vSearchRec.Name,   '..')   =   0)   then
                  pSearchFile(mPath   +   '\'   +   vSearchRec.Name)
              else   if   Pos(vSearchRec.Name,   '..')   =   0   then
                  pAppendFile(mPath   +   '\'   +   vSearchRec.Name);
              K   :=   FindNext(vSearchRec);
          end;
          FindClose(vSearchRec);
      end;   {   pSearchFile   }
  begin   
      Result   :=   0;
      if   not   DirectoryExists(mDirectory)   then   Exit;   
      vFileInfo   :=   TStringList.Create;   
      vMemoryStream   :=   TMemoryStream.Create;   
      mDirectory   :=   ExcludeTrailingPathDelimiter(mDirectory);
    
      AStream := TMemoryStream.Create;
      try   
          pSearchFile(mDirectory);   
          vFileInfoBuffer   :=   vFileInfo.GetText;
          vFileInfoSize   :=   StrLen(vFileInfoBuffer)*sizeof(Char);
    
          {   DONE   -oZswang   -c���   :   д��ͷ�ļ���Ϣ   }
          vFileHead.rIdent   :=   cIdent;   
          vFileHead.rVersion   :=   cVersion;
          AStream.Write(vFileHead,   SizeOf(vFileHead));

          AStream.Write(vFileInfoSize,   SizeOf(vFileInfoSize));
          AStream.Write(vFileInfoBuffer^,   vFileInfoSize);
          vMemoryStream.Position   :=   0;   
          AStream.CopyFrom(vMemoryStream,   vMemoryStream.Size);   
      finally
          vFileInfo.Free;   
          vMemoryStream.Free;
          StrDispose(vFileInfoBuffer);
          //AStream.Free;
      end;   
  end;   {   DirectoryCompression   }

  /// test case is in TestExamCommonsCompress
  { TODO -ojiaping -c* : ��ǰ���ܰ�����Ŀ¼������Ҫ������Ŀ¼�����������²�Ŀ¼�а���һ���ļ� }
  function   DirectoryDecompression(ADirectory:TFileName;AMemStream:TMemoryStream):   Integer;
  var
      vFileInfo:   TStrings;
      vFileInfoSize:   Integer;   
      vFileHead:   TFileHead;
    
      vMemoryStream:   TMemoryStream;   
      vFileStream:   TFileStream;   
      I:   Integer;   
  begin   
      Result   :=   0;
      vFileInfo   :=   TStringList.Create;
      vMemoryStream   :=   TMemoryStream.Create;
      ADirectory   :=   ExcludeTrailingPathDelimiter(ADirectory);   
      //AMemStream   :=   TFileStream.Create(mFileName,   fmOpenRead   or   fmShareDenyNone);
      try   
          if   AMemStream.Size   <   SizeOf(vFileHead)   then   Exit;
          {   DONE   -oZswang   -c���   :   ��ȡͷ�ļ���Ϣ   }   
          AMemStream.Position := 0;
          AMemStream.Read(vFileHead,   SizeOf(vFileHead));
          if   vFileHead.rIdent   <>   cIdent   then   Result   :=   cErrorIdent;   
          if   vFileHead.rVersion   <>   cVersion   then   Result   :=   cErrorVersion;   
          if   Result   <>   0   then   Exit;   
    
          AMemStream.Read(vFileInfoSize,   SizeOf(vFileInfoSize));
          vMemoryStream.CopyFrom(AMemStream,   vFileInfoSize);
          vMemoryStream.Position   :=   0;
          //
          vFileInfo.LoadFromStream(vMemoryStream,TEncoding.Unicode);
    
          for   I   :=   0   to   vFileInfo.Count   -   1   do   begin
              vMemoryStream.Clear;
              vMemoryStream.CopyFrom(AMemStream,StrToIntDef(StrRight(vFileInfo[I],   '|'),   0));
              vMemoryStream.Position   :=   0;
              FileDecompression(ADirectory   +   '\'   +   StrLeft(vFileInfo[I],   '|'),
                  vMemoryStream);   
          end;   
          Result   :=   vFileInfo.Count;   
      finally   
          vFileInfo.Free;
          vMemoryStream.Free;
          //AMemStream.Free;   
      end;   
  end;   {   DirectoryDeompression   }

  //ѹ���㷨 ����ʵ��ѹ����

Function CompressStream(var CompressedStream: TMemoryStream;const CompressionLevel: TCompressionLevel = clDefault):Extended;
var
      SourceStream: TCompressionStream;
      DestStream: TMemoryStream;
      Count: Integer;
Begin
      Count := CompressedStream.Size;
      if Count=0 then     //����
        begin
          Result:=-1;
          Exit;
        end;

      DestStream := TMemoryStream.Create;
      SourceStream:=TCompressionStream.Create(CompressionLevel, DestStream);
      Try
        CompressedStream.SaveToStream(SourceStream);
        SourceStream.Free;
        CompressedStream.Clear;
        CompressedStream.WriteBuffer(Count, SizeOf(Count));
        CompressedStream.CopyFrom(DestStream, 0);
        Result:=CompressedStream.Size/Count;
      finally
        DestStream.Free;
      end;
end;


///��ѹ������
procedure UnCompressStream(var UnCompressedStream: TMemoryStream);
var
    Count: integer;
    SourceStream: TDecompressionStream;
    Buffer: pchar;
begin
    if UnCompressedStream.Size >0  then begin  
      UnCompressedStream.Position:=0;
      UnCompressedStream.ReadBuffer(Count, sizeof(Count));
      try
         Getmem(Buffer, Count);
         SourceStream := TDecompressionStream.Create(UnCompressedStream);
         try
            SourceStream.Read(Buffer^, Count);
         finally
            freeandnil(SourceStream);
         end;
         UnCompressedStream.Clear;
         UnCompressedStream.WriteBuffer(Buffer^,Count);
         UnCompressedStream.Position:=0;
      finally
         freemem(Buffer);
      end;
    end;
end;


procedure UnZipExamPackFile2Dir(AFile:string;ATargetPath:string;AIncludeFilename:Boolean=True);
var
   AStream:TMemoryStream;
   path:string;
begin
   EDirNotExistException.IfFalse(directoryexists(ATargetPath),Format(RSDirNotExist,[ATargetPath]));
   EFileNotExistException.IfFalse(fileexists(AFile),Format(RSFileNotExist,[AFile]));
   path := ATargetPath;
   if AIncludeFileName then begin
      path := IncludeTrailingPathDelimiter(ATargetPath)+StrLeft( ExtractFileName(AFile),'.');
      if directoryexists(path) then  begin
         EDirDeleteException.IfFalse(deletedir(path)>0,Format(RSDirDeleteError,[path]));
      end;
      EDirCreateException.IfFalse(createdir(path),Format(RSDirCreateError,[path]));
   end;
   AStream := TMemoryStream.Create;
   try
      AStream.LoadFromFile(AFile);
      DirectoryDecompression(path,AStream );
   finally
     AStream.Free;
   end;
end;
//procedure CompressScoreInfo(sourceStream,targetStream:TMemoryStream);
//begin
//
//end;
//
//procedure UnCompressScoreInfo(sourceStream,targetStream:TMemoryStream);
//begin
//
//end;

end.
