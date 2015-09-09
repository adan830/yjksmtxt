unit compress;

interface

uses
   Classes, SysUtils, zlib;

/// <summary>
/// 采用ZLib压缩stream
/// 压缩结果仍由stream传回
/// 采用Zip算法
/// </summary>
/// <param name="stream">将被压缩流传入，压缩结果仍由该参数传回</param>
/// <param name="CompressionLevel">可选参数，指定压缩级别TCompressionLevel = (clNone = Integer(zcNone), clFastest, clDefault, clMax)，默认为clDefault</param>
/// <returns>返回实际压缩比</returns>
Function CompressStream(var stream : TMemoryStream; const CompressionLevel : TCompressionLevel = clDefault) : Extended;
/// <summary>
/// 解压缩由CompressStream函数压缩的流
/// 采用ZLib算法
/// </summary>
/// <param name="stream">将压缩的流传入，解压结果仍由该参数传回</param>
procedure UnCompressStream(var stream : TMemoryStream);

/// test case is in TestExamCommonsCompress /`
function FileCompression(mFileName : TFileName; mStream : TStream) : Integer;
function FileDecompression(mFileName : TFileName; mStream : TStream) : Integer;
function StrLeft(const mStr : string; mDelimiter : string) : string;
function StrRight(const mStr : string; mDelimiter : string) : string;

{ -------------------------------------------------------------------------------
  过程名:    DirectoryCompression		日期:      2009.05.04
  参数:      mDirectory:TFileName;
  out AStream:TMemoryStream
  返回值:    Integer
  说明:      注意ATream参数，传入时不能创建，因为函数内会创建
  ------------------------------------------------------------------------------- }

/// test case is in TestExamCommonsCompress
function DirectoryCompression(mDirectory : TFileName; out AStream : TMemoryStream) : Integer; // stdcall;
/// test case is in TestExamCommonsCompress
function DirectoryDecompression(ADirectory : TFileName; AMemStream : TMemoryStream) : Integer; // stdcall;

{ -------------------------------------------------------------------------------
  过程名:    UnZipExamPackFile2Dir		日期:      2009.04.29
  参数:      AFile:string; 表示解包的文件，包括路径
  ATargetPath:string;解压到位置
  AIncludeFilename:Boolean=True 是否需要包含文件名作为父文件夹
  说明:  将考生打包文件解压到指定目录中
  ------------------------------------------------------------------------------- }
procedure UnZipExamPackFile2Dir(AFile : string; ATargetPath : string; AIncludeFilename : Boolean = True);

// ==============================================================================
// 压缩考生得分信息相关函数
// ==============================================================================
// procedure CompressScoreInfo(sourceStream,targetStream:TMemoryStream);
// procedure UnCompressScoreInfo(sourceStream,targetStream:TMemoryStream);

implementation

uses Commons, ExamException, ExamResourceStrings;

const
   cBufferSize = $4096;

   /// test case is in TestExamCommonsCompress
   /// 当前可包含长度为0的文件
function FileCompression(mFileName : TFileName; mStream : TStream) : Integer;
   var
      vFileStream : TFileStream;
      vBuffer     : array [0 .. cBufferSize] of Char;
      vPosition   : Integer;
      I           : Integer;
   begin
      Result := -1;
      if not FileExists(mFileName) then
         Exit;
      if not Assigned(mStream) then
         Exit;
      vPosition := mStream.Position;
      try
         vFileStream := TFileStream.Create(mFileName, fmOpenRead or fmShareDenyNone);

         with TCompressionStream.Create(clMax, mStream) do
            try
               for I := 1 to vFileStream.Size div cBufferSize do
               begin
                  vFileStream.Read(vBuffer, cBufferSize);
                  Write(vBuffer, cBufferSize);
               end;
               I := vFileStream.Size mod cBufferSize;
               if I > 0 then
               begin
                  vFileStream.Read(vBuffer, I);
                  Write(vBuffer, I);
               end;
            finally
               Free;
               vFileStream.Free;
            end;
      except
         on E : Exception do
         begin
            raise Exception.Create('error -jp :' + E.Message);
         end;
      end;

      Result := mStream.Size - vPosition; // 增量
   end;                                   { FileCompression }

function FileDecompression(mFileName : TFileName; mStream : TStream) : Integer;
   var
      vFileStream : TFileStream;
      vBuffer     : array [0 .. cBufferSize] of Char;
      I           : Integer;
   begin
      Result := -1;
      if not Assigned(mStream) then
         Exit;
      ForceDirectories(ExtractFilePath(mFileName)); // 创建目录

      vFileStream := TFileStream.Create(mFileName, fmCreate or fmShareDenyWrite);

      with TDecompressionStream.Create(mStream) do
         try
            repeat
               I := Read(vBuffer, cBufferSize);
               vFileStream.Write(vBuffer, I);
            until I = 0;
            Result := vFileStream.Size;
         finally
            Free;
            vFileStream.Free;
         end;
   end; { FileDecompression }

function StrLeft(const mStr : string; mDelimiter : string) : string;
   begin
      Result := Copy(mStr, 1, Pos(mDelimiter, mStr) - 1);
   end; { StrLeft }

function StrRight(const mStr : string; mDelimiter : string) : string;
   begin
      if Pos(mDelimiter, mStr) > 0 then
         Result := Copy(mStr, Pos(mDelimiter, mStr) + Length(mDelimiter), MaxInt)
      else
         Result := '';
   end; { StrRight }

type
   TFileHead = packed record
      rIdent : array [0 .. 2] of Char; // 标识
      rVersion : Byte;                 // 版本
   end;

const
   cIdent        = 'zsf';
   cVersion      = $01;
   cErrorIdent   = -1;
   cErrorVersion = -2;

   /// test case is in TestExamCommonsCompress
   { TODO -ojiaping -c* : 当前不能包含空目录，所以要包含空目录，必须在最下层目录中包含一个文件 }
function DirectoryCompression(mDirectory : TFileName; out AStream : TMemoryStream) : Integer;
   var
      vFileInfo       : TStrings;
      vFileInfoSize   : Integer;
      vFileInfoBuffer : PChar;
      vFileHead       : TFileHead;

      vMemoryStream : TMemoryStream;
      vFileStream   : TFileStream;

      procedure pAppendFile(mSubFile : TFileName);
         begin
            vFileInfo.Append(Format('%s|%d', [StringReplace(mSubFile, mDirectory + '\', '', [rfReplaceAll, rfIgnoreCase]), FileCompression(mSubFile, vMemoryStream)]));
            Inc(Result);
         end; { pAppendFile }

      procedure pSearchFile(mPath : TFileName);
         var
            vSearchRec : TSearchRec;
            K          : Integer;
            attr       : Integer;
         begin
            attr := faAnyFile;
            K    := FindFirst(mPath + '\*.*', attr, vSearchRec);
            while K = 0 do
            begin
               if (vSearchRec.attr and faDirectory > 0) and (Pos(vSearchRec.Name, '..') = 0) then
                  pSearchFile(mPath + '\' + vSearchRec.Name)
               else if Pos(vSearchRec.Name, '..') = 0 then
                  pAppendFile(mPath + '\' + vSearchRec.Name);
               K := FindNext(vSearchRec);
            end;
            FindClose(vSearchRec);
         end; { pSearchFile }

   begin
      Result := 0;
      if not DirectoryExists(mDirectory) then
         Exit;
      vFileInfo     := TStringList.Create;
      vMemoryStream := TMemoryStream.Create;
      mDirectory    := ExcludeTrailingPathDelimiter(mDirectory);

      AStream := TMemoryStream.Create;
      try
         pSearchFile(mDirectory);
         vFileInfoBuffer := vFileInfo.GetText;
         vFileInfoSize   := StrLen(vFileInfoBuffer) * sizeof(Char);

         { DONE   -oZswang   -c添加   :   写入头文件信息 }
         vFileHead.rIdent   := cIdent;
         vFileHead.rVersion := cVersion;
         AStream.Write(vFileHead, sizeof(vFileHead));

         AStream.Write(vFileInfoSize, sizeof(vFileInfoSize));
         AStream.Write(vFileInfoBuffer^, vFileInfoSize);
         vMemoryStream.Position := 0;
         AStream.CopyFrom(vMemoryStream, vMemoryStream.Size);
      finally
         vFileInfo.Free;
         vMemoryStream.Free;
         StrDispose(vFileInfoBuffer);
         // AStream.Free;
      end;
   end; { DirectoryCompression }

/// test case is in TestExamCommonsCompress
{ TODO -ojiaping -c* : 当前不能包含空目录，所以要包含空目录，必须在最下层目录中包含一个文件 }
function DirectoryDecompression(ADirectory : TFileName; AMemStream : TMemoryStream) : Integer;
   var
      vFileInfo     : TStrings;
      vFileInfoSize : Integer;
      vFileHead     : TFileHead;

      vMemoryStream : TMemoryStream;
      vFileStream   : TFileStream;
      I             : Integer;
   begin
      Result        := 0;
      vFileInfo     := TStringList.Create;
      vMemoryStream := TMemoryStream.Create;
      ADirectory    := ExcludeTrailingPathDelimiter(ADirectory);
      // AMemStream   :=   TFileStream.Create(mFileName,   fmOpenRead   or   fmShareDenyNone);
      try
         if AMemStream.Size < sizeof(vFileHead) then
            Exit;
         { DONE   -oZswang   -c添加   :   读取头文件信息 }
         AMemStream.Position := 0;
         AMemStream.Read(vFileHead, sizeof(vFileHead));
         if vFileHead.rIdent <> cIdent then
            Result := cErrorIdent;
         if vFileHead.rVersion <> cVersion then
            Result := cErrorVersion;
         if Result <> 0 then
            Exit;

         AMemStream.Read(vFileInfoSize, sizeof(vFileInfoSize));
         vMemoryStream.CopyFrom(AMemStream, vFileInfoSize);
         vMemoryStream.Position := 0;
         //
         vFileInfo.LoadFromStream(vMemoryStream, TEncoding.Unicode);

         for I := 0 to vFileInfo.Count - 1 do
         begin
            vMemoryStream.Clear;
            vMemoryStream.CopyFrom(AMemStream, StrToIntDef(StrRight(vFileInfo[I], '|'), 0));
            vMemoryStream.Position := 0;
            FileDecompression(ADirectory + '\' + StrLeft(vFileInfo[I], '|'), vMemoryStream);
         end;
         Result := vFileInfo.Count;
      finally
         vFileInfo.Free;
         vMemoryStream.Free;
         // AMemStream.Free;
      end;
   end; { DirectoryDeompression }

Function CompressStream(var stream : TMemoryStream; const CompressionLevel : TCompressionLevel = clDefault) : Extended;
   var
      LZip       : TCompressionStream;
      tempStream : TMemoryStream;
      Count      : Integer;
   Begin
      Count := stream.Size;
      if Count = 0 then // 错误
      begin
         Result := -1;
         Exit;
      end;

       tempStream := TMemoryStream.Create;
      LZip       := TCompressionStream.Create(CompressionLevel, tempStream);
      Try
         stream.SaveToStream(LZip);
         LZip.Free;
         stream.Clear;
         stream.WriteBuffer(Count, sizeof(Count));
         stream.CopyFrom(tempStream, 0);
         Result := stream.Size / Count;
      finally
         tempStream.Free;
      end;
   end;

procedure UnCompressStream(var stream : TMemoryStream);
   var
      Count        : Integer;
      LUnzip : TDecompressionStream;
      Buffer       : PChar;
   begin
      if stream.Size > 0 then
      begin
         stream.Position := 0;
         stream.ReadBuffer(Count, sizeof(Count));
         try
            Getmem(Buffer, Count);
            LUnzip := TDecompressionStream.Create(stream);
            try
               LUnzip.Read(Buffer^, Count);
            finally
               freeandnil(LUnzip);
            end;
            stream.Clear;
            stream.WriteBuffer(Buffer^, Count);
            stream.Position := 0;
         finally
            freemem(Buffer);
         end;
      end;
   end;

procedure UnZipExamPackFile2Dir(AFile : string; ATargetPath : string; AIncludeFilename : Boolean = True);
   var
      AStream : TMemoryStream;
      path    : string;
   begin
      EDirNotExistException.IfFalse(DirectoryExists(ATargetPath), Format(RSDirNotExist, [ATargetPath]));
      EFileNotExistException.IfFalse(FileExists(AFile), Format(RSFileNotExist, [AFile]));
      path := ATargetPath;
      if AIncludeFilename then
      begin
         path := IncludeTrailingPathDelimiter(ATargetPath) + StrLeft(ExtractFileName(AFile), '.');
         if DirectoryExists(path) then
         begin
            EDirDeleteException.IfFalse(deletedir(path) > 0, Format(RSDirDeleteError, [path]));
         end;
         EDirCreateException.IfFalse(createdir(path), Format(RSDirCreateError, [path]));
      end;
      AStream := TMemoryStream.Create;
      try
         AStream.LoadFromFile(AFile);
         DirectoryDecompression(path, AStream);
      finally
         AStream.Free;
      end;
   end;
// procedure CompressScoreInfo(sourceStream,targetStream:TMemoryStream);
// begin
//
// end;
//
// procedure UnCompressScoreInfo(sourceStream,targetStream:TMemoryStream);
// begin
//
// end;

end.
