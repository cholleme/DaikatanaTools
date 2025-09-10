//******************************************************************************
//
// Game project unit
// (c) 1999 Charles Hollemeesch
// Description: routines to make loading out op grouped(pak) files possible
//
// Quickly modified for reading daikatana pak files
//******************************************************************************

unit pakfiles;

{$MODE Delphi}

interface
uses Windows, ShellAPI, comctrls,FileCtrl,controls,dialogs;

const NumFileTypes = 10;//used for shell icon extraction
      FileTypes : array[0..NumFileTypes-1] of string[4] =
                ('.wal','.tga','.bmp','.bsp','.wav','.pcx','.txt','.dkm','.sp2','.dkf');

type tError =( OK,
               FILE_NOTFOUND,
               FILE_WRITEERROR,
               FILE_READERROR,
               FILE_INVALID
              );

var
pakfilename : string;

//basic
function  Init_pakfile(filename : string) : TError; //open a pak file
procedure Free_Pakfile; //close and free the pak file
procedure pakBeginNew(FileName : string); //begin a new pak and open it
//file
function  pakassignresetfile(var pakfile : file;filename : string;var fileoffset,filesizer,compsize,comptype : longint) : Terror;
procedure InterfaceExtractFile(FileName : String); //nice extraction of a file
function  pakExtractFile(source,dest : string) : TError; //raw extraction of a file
function  pakGetFileData(source : string;var filesize : integer) : Pointer; //get a pointer to the raw file data (free it yourself)

function  pakAddFile(FullPathName,PakPathName : string) : TError;//add fullpahtname to the pak
function  pakDeleteFile(FileName: String) : Terror;//delete the file
function  pakUpdateFile(FileName,Source : String) : TError; //update the data in the file
function  pakRenameFile(OldName,NewName : String) : TError;

//directorys
Procedure pakExtractDir(sourcefile : String;var c : Boolean); //extract an whole dir relative to the base dir
Procedure pakRemoveDir(dir : string);
Procedure pakRenamedir(dir : string;newname : string);

//whole pack
procedure pakExtractAll(var Cancel : Boolean);

procedure pakSaveFile;//save the pak header and dir after an update
//managment
function  filenamedos(fname : string) : string; //convert a pak file name to a dos file name (switch '/' with '\')
function  pakfileexists(filename : string) : boolean; //check if a file exists in the pak
//user interface
procedure PutList(filestr : string;List : TListView); //fill a lisview with the contents of the filestring (should be a dir)
procedure CreateTreeFromDir(var Tree : TTreeView); //fill a tree view with te pak file directory  structure

implementation

uses sysutils,mainu,optu;

type
  TpakHeader = record
  magic : array [0..3] of char; // Sould be "PACK"
  diroffset : cardinal;         // Position of directory from start of file
  dirsize   : cardinal;         // Size of the directory
  end;


  TpakEntry = packed record
  filename : array[0..55] of char;      // Name of the file
  offset : longint;                     // Position of the file in pak file
  size : longint;                       // Size of the uncompressed file
  compresssize   : longint;             // Size of the compressed file
  compresstype   : longint;             // Type of compression
  end;

  PPakEntry = ^Tpakentry;

  PDirTreeItem = ^TDirTreeItem;
  TDirTreeItem = record
  SubItems : PDirTreeItem;
  NextItem : PDirTreeItem;
  Name     : String;
  Index    : Integer;
  Entry    : PPakEntry;
  end;

const pakmagic1 : array[0..3] of char = ('P','A','C','K');

var
  pakEntrys : ppakEntry;
  pakHeader : Tpakheader;
  NumTreeItems : Integer = 0;
  DirRoot : TDirTreeItem;

function filenamedos(fname : string) : string;
var i : integer;
begin
for i := 1 to length(fname) do
    begin
    if fname[i] = '/' then fname[i] := '\'
    end;
filenamedos := fname;
end;

function pakfileexists(filename : string) : boolean;
var i : integer;
begin
result := false;
  for i := 0 to (pakheader.dirsize div sizeof(tpakEntry))-1 do
    if PpakEntry( pointer ( cardinal(pakEntrys) + (i * sizeof(tpakEntry)) )).filename = filename then
    begin
      //found it.
      result := true;
      exit;
    end;
//no normal file opening for DaiPak
//if fileexists(extractfiledir(pakfilename) +'\'+ filenamedos(filename)) then result := true;
end;

{**************
Searches a file in a pak and puts the reading pos at the beginning in the file
if file is not found in the pakfile then it tries to load a "real" file from disk.
Pakassignresetfile returns the offset of the file in the pakfile (or zero for real files)
so that you can seek in the file
**************}
function pakassignresetfile(var pakfile : file;filename : string;var fileoffset,filesizer,compsize,comptype : longint) : Terror;
var
   found : boolean;
   i : integer;
   apakentry : ppakentry;
begin
result := OK;
//extra := 0;
  found := false;

  for i := 0 to (pakheader.dirsize div sizeof(tpakEntry))-1 do
  begin
    apakEntry := PpakEntry( pointer ( cardinal(pakEntrys) + (i * sizeof(tpakEntry)) ));
    if apakentry.filename = filename then
    begin
      //found it.
      found := true;
      break;
    end;
  end;

if found = false then
   begin
   //No normal file opening for daipak
   //try to open from a normal file
   {normalfile := extractfiledir(pakfilename) +'\'+ filenamedos(filename);
   if fileexists(normalfile) then
    begin
    assignfile(pakfile,normalfile);
    reset(pakfile,1);
    fileoffset := 0;
//    extra := 0;
    filesizer := FileSize(pakfile);
    compsize := 0;
    comptype := 0;
exit;
    end
    // not found at all so warn caller
    else }begin
         fileoffset := -1;
         comptype := -1;
         compsize := -1;
         result := FILE_NOTFOUND;
         exit;
         end;
   end;
assignfile(pakfile,pakfilename);
reset(pakfile,1);
//why offset+1 it wasn't needed for normal pak files
//Found out looking at the bmp/bsp headers
seek(pakfile,apakentry.offset);
fileoffset := apakentry.offset;
//why filesize-1 it it wasn't needed for normal pak files
//I found out that this was needed when i extracted the .sca files
//in Pak1 if i don't decrease the filesize there is a junk char at the
//end of the file
filesizer   := apakentry.size;
compsize := apakentry.compresssize;
comptype := apakentry.compresstype;
end;

procedure InterfaceExtractFile(FileName : String); //extract a file to a dir relative to the base dir
var destfile : string;
begin
   destfile := extractfiledir(PakFileName)+'\'+filenamedos(FileName);
   if fileexists(destfile) then
      if OptionsForm.CheckConfirmOverwrite.Checked then
         if messagedlg(DestFile+' already exists. Overwrite?',mtConfirmation,
                       [mbYes,mbNo],0) = mrNo
            then exit;
   if not DirectoryExists(extractfiledir(destfile)) then
      begin
      std_write('Making directory %s',[extractfiledir(destfile)]);
      ForceDirectories(extractfiledir(destfile));
      end;
   std_write('Extracting file to %s',[destfile]);
   pakextractfile(FileName,destfile);
end;

function pakextractfile(source,dest : string) : TError; //raw file extraction
var destfile : file;
    filesize : longint;
    data : ^byte;
begin
if pakfileexists(source) = True then
   begin
        assignfile(destfile,dest);
        rewrite(destfile,1);
        data :=  PakGetFileData(source,filesize);
        blockwrite(destfile,data^,filesize);
        freemem(data);
        closefile(destfile);
        result := OK;
   end
   else result := FILE_NOTFOUND;
end;

function PakGetFileData(source : string;var filesize : integer) : Pointer;
type bytearray = array[0..0] of byte;
var sourcefile : file;
    fileoffset,comptype,compsize : longint;
    //from romero code
    code : byte;
    src_pos,dst_pos: integer;
    i : integer;
    src_data : ^bytearray;
    dst_data : ^bytearray;
    offset : integer;
begin
if pakassignresetfile(sourcefile,source,fileoffset,filesize,compsize,comptype) = OK then
   begin
        //compressed file then decompress
        //files use run length encoding for compression
        if comptype <> 0 then
        begin
        src_pos := 0;
        dst_pos := 0;

        getmem(src_data,compsize);
        getmem(dst_data,filesize);

        seek(sourcefile,fileoffset);
	Blockread(sourcefile,src_data^,compsize);
		while true do
                        begin

			code := src_data[src_pos];
			inc(src_pos);

			// terminator
			if (code = 255) then
                           break

			else if (code < 64) then
                                begin
				// uncompressed block

				for i := -1 to code-1 do
                                       begin
					dst_data[dst_pos] := src_data[src_pos];
					inc(dst_pos);
					inc(src_pos);
                                      end;
				end

			else if (code < 128) then
                                begin
				// rlz

				for i := 62 to code-1 do
                                        begin
					dst_data[dst_pos] := 0;
					inc(dst_pos);
                                        end;
			        end
                        else if (code < 192) then
                                begin
				// run length encode

				for i := 126 to code-1 do
                                        begin
					dst_data[dst_pos] := src_data[src_pos];
					inc(dst_pos);
				        end;
				inc(src_pos);
                                end
			else if (code < 254) then
                                begin
				// reference previous data
				offset := src_data[src_pos];
				inc(src_pos);

                                for i := 190 to code-1 do
                                        begin
					dst_data[dst_pos] := dst_data[dst_pos - offset - 2];
					inc(dst_pos);
				        end;
			       end;
		end;//while;
		//blockwrite(destfile,dst_data^,filesize);
                //blockwrite(destfile,src_data^,compsize);
                freemem(src_data);
		//freemem(dst_data);
        end //if compressed
        else begin
        getmem(dst_data,filesize);
        blockread(sourcefile,dst_data^,filesize);
        end;
        closefile(sourcefile);
        result := dst_data;
   end
   else result := nil;
end;

function Init_pakfile(filename : string) : TError;
var
  pakfile : file;
begin
result := OK;
pakfilename := filename;
if fileexists(pakfilename) = false then begin result := FILE_NOTFOUND; exit; end;
assignfile(pakfile,pakfilename);
reset(pakfile,1);
//read the header
blockread(pakfile,pakheader,sizeof(pakheader));
if ((pakheader.magic[0] <> pakmagic1[0]) or
   (pakheader.magic[1] <> pakmagic1[1]) or
   (pakheader.magic[2] <> pakmagic1[2]) or
   (pakheader.magic[3] <> pakmagic1[3]) ) then result := FILE_INVALID;
std_write('Loaded '+pakfilename+' with '+inttostr(pakheader.dirsize div sizeof(tpakEntry))+' entrys',[nil]);
//allocate mem for the dir
getmem(pakEntrys,pakheader.dirsize);
//go to the dir
seek(pakfile,0);
seek(pakfile,pakheader.diroffset);
//read the dir
blockread(pakfile,pakEntrys^,pakheader.dirsize);
closefile(pakfile);
end;

Procedure RFreeDir(var Root : PDirTreeItem); forward;

procedure Free_Pakfile;
begin
//std_write('Number of allocated nodes: '+inttostr(NumTreeItems),[nil]);
RFreeDir(DirRoot.SubItems);
//std_write('Number of unfreed nodes: '+inttostr(NumTreeItems),[nil]);
freemem(pakEntrys,pakheader.dirsize);
end;

function AddPakEntry(const entry : TPakEntry) : PPakEntry;
var newpakEntrys,newEntry : pointer;
begin
getmem(newPakEntrys,pakheader.dirsize+sizeof(TpakEntry));//get mem for the new entry's
move(pakEntrys^,newPakEntrys^,pakheader.dirsize);//get the old entrys
result := pointer(cardinal(newPakEntrys)+pakheader.dirsize);
move(entry,pointer(cardinal(newPakEntrys)+pakheader.dirsize)^,sizeof(TpakEntry));//add the new
freemem(pakEntrys);//free the old
//no one knows it
pakEntrys := newPakEntrys;
pakheader.dirsize := pakheader.dirsize+sizeof(TPakEntry);
end;

procedure pakSaveFile;
var pakFile : File;
begin
std_write('Saving pack to %s',[pakFileName]);
//write new header
assignfile(pakFile,pakFileName);
reset(pakfile,1);
//write new dir
blockwrite(pakFile,pakHeader,SizeOf(pakHeader));
seek(pakfile,pakHeader.diroffset);
blockwrite(pakFile,pakEntrys^,pakHeader.DirSize);
closefile(pakFile);
CreateTreeFromDir(MainForm.TreeView1);
end;

procedure pakBeginNew(FileName : string);
var pakFile : File;
begin
Std_write('Creating %s',[filename]);
pakFileName := FileName;
move(pakmagic1,pakHeader.magic,4);
pakHeader.diroffset := SizeOf(PakHeader);
pakHeader.dirsize := 0;
getMem(pakEntrys,1);//get a lonly byte so that we don't get acces violations
//write new header
assignfile(pakFile,pakFileName);
rewrite(pakfile,1);
blockWrite(pakfile,pakHeader,sizeof(pakHeader));
closefile(pakfile);
//dir is empty so don't write it
CreateTreeFromDir(MainForm.TreeView1);
end;

procedure pakAddNewData(FileName : String;var entry : TpakEntry);
var pakFile : File;
    sourceFile : File;
    sourcedata : ^Byte;
begin
//open pak file
assignfile(pakFile,pakFileName);
reset(pakFile,1);
//open source file
assignfile(sourceFile,FileName);
reset(SourceFile,1);
getmem(sourceData,filesize(sourceFile));
blockRead(sourceFile,sourceData^,filesize(sourceFile));
//copy data+setup entry
seek(pakFile,pakHeader.DirOffset);
BlockWrite(pakFile,sourceData^,filesize(sourceFile));
entry.offset := pakHeader.DirOffset;
entry.size := filesize(sourceFile);
entry.compresstype := 0;
entry.compresssize := filesize(sourceFile);
pakHeader.DirOffset := pakHeader.DirOffset + filesize(sourceFile);
//cleanup
freemem(sourceData);
closefile(pakFile);
closefile(sourceFile);
end;

function pakAddFile(FullPathName,PakPathName : string) : TError;
var FileEntry : TPakEntry;
    NewEntry : PPakEntry;
begin
//setup new entry
if pakFileExists(PakPathName) then
   begin
   if OptionsForm.CheckConfirmUpdate.Checked then
      if messagedlg(PakPathName+' is already part of the pak file. Do you want to uptdate it?',
                    mtConfirmation,[mbYes,mbNo],0) = mrNo then exit;
   pakUpdateFile(PakPathName,FullPathName);
   exit;
   end;
if length(PakPathName) > 55 then begin std_error('Filename to long %s',[pakpathname]); exit; end;
std_write('Adding %s in pack as %s',[FullPathName,PakPathName]);
fillchar(FileEntry,sizeof(FileEntry),0);
move(PakPathName[1],FileEntry.filename,length(PakPathName));
  //more todo
NewEntry := AddPakEntry(FileEntry);
//add the file data to the pak
pakAddNewData(FullPathName,NewEntry^);
//saving the header and dir has to be called manually
end;

function GetPakEntry(FileName : String) : PPakEntry;
var i : Integer;
begin
result := nil;
for i := 0 to (pakheader.dirsize div sizeof(tpakEntry))-1 do
    begin
    Result := PpakEntry( pointer ( cardinal(pakEntrys) + (i * sizeof(tpakEntry)) ));
    if Result.FileName = FileName then
       exit;
    end;
end;

function  pakRenameFile(OldName,NewName : String) : TError;
var Entry : PPakEntry;
begin
std_write('Renaming %s to %s',[OldName,NewName]);
Result := OK;
Entry := GetPakEntry(OldName);
if length(NewName) > 56 then begin Result := FILE_INVALID; exit; end;
if pakFileExists(newname) then begin Result := FILE_INVALID; std_write('%s already exists',[NewName]); exit; end;
FillChar(Entry.FileName,56,0);
Move(NewName[1],Entry.FileName,length(NewName));
end;

const MAX_BLOCK_SIZE = 524288; //512 kb (=0.5 mb)

Type TBuffer = array[1..MAX_BLOCK_SIZE] of byte;

function MoveData(var handle : file;fPos,Size,Offset: Integer):boolean;
var                                 {Pos is startpos}
   Buf: ^TBuffer;                   {Size is amout to move}
   Blocksize: Integer;              {Offset is amount to move by, +/-}
   EndPos: Integer;
   check: Integer;
begin
     if (Size=0) or (Offset=0) then begin MoveData:=True; exit end;
     MoveData := False;
     New(Buf);
     std_write('moving %d bytes from %d to %d',[Size,fPos,fPos+Offset]);

     if Offset>0 then Inc(fPos,Size);
     while Size>0 do
           begin
           if Size>MAX_BLOCK_SIZE then
              BlockSize:=MAX_BLOCK_SIZE
           else
               BlockSize:=Size;
           Dec(Size,BlockSize);

           if OffSet>0 then
              Seek(Handle,fpos-BlockSize)
           else
               Seek(handle,fPos);

           BlockRead(handle,Buf^,Blocksize,check);
           if check<>BlockSize then
              begin
              std_error('Error reading file, requested %d got %d',[Blocksize,check]);
              Dispose(Buf);
              Close(handle);
              exit;
              end;

           Seek(handle,Filepos(Handle)-BlockSize+Offset);
           BlockWrite(handle,buf^,Blocksize,check);
           if check<>BlockSize then
              begin
              std_error('Error writing file, requested %d wrote %d',[Blocksize,check]);
              Dispose(Buf);
              Close(handle);
              exit;
              end;

           if Offset>0 then
              Dec(fpos,BlockSize)
           else
               Inc(fpos,BlockSize);
           end;
     Dispose(Buf);
     MoveData:=True;
end;

procedure RemoveEntry(FileName : String);
type Tentryarray = array[0..0] of TpakEntry;
     PentryArray = ^TentryArray;
var i,j : Integer;
    Entry : PPakEntry;
    NewDir : PPakEntry;
    EntryArray,NewEntryArray : PEntryArray;
begin
EntryArray := PEntryArray(pakEntrys);
for i := 0 to (pakheader.dirsize div sizeof(tpakEntry))-1 do
    begin
    if EntryArray[i].Filename = FileName then
       begin
       GetMem(NewEntryArray,pakHeader.dirsize - sizeof(tpakEntry));
       //move first part
         for j := 0 to i-1 do
               begin
               NewEntryArray[j] := EntryArray[j];
               end;
       //move the second part
         for j := i+1 to (pakheader.dirsize div sizeof(tpakEntry))-1 do
               begin
               NewEntryArray[j-1] := EntryArray[j];
               end;
       FreeMem(pakEntrys);
       pakEntrys := ppakEntry(NewEntryArray);
       pakHeader.dirsize := pakHeader.dirsize - sizeof(tpakEntry);
       exit;
       end;
    end;
end;


procedure pakUpdateFileEntrysAfterRemove(DataOffset,DataSize : Integer);
var i : Integer;
    Entry : PPakEntry;
begin
for i := 0 to (pakheader.dirsize div sizeof(tpakEntry))-1 do
    begin
    Entry := PpakEntry( pointer ( cardinal(pakEntrys) + (i * sizeof(tpakEntry)) ));
    if Entry.offset > DataOffset+1 then
       begin
       Entry.offset := Entry.offset - DataSize;
       end;
    end;
end;

function  pakDeleteFile(FileName: String) : Terror;//delete the file
var i,EOffset,ESize : integer;
    Entry : PPakEntry;
    pakFile : File;
begin
//open the pak file
AssignFile(pakFile,pakFileName);
Reset(pakFile,1);

//get info about file to delete
Entry := GetPakEntry(FileName);
if Entry = Nil then begin Result := FILE_NOTFOUND; exit; end;
std_write('Deleting %s from pack',[FileName]);
//save some data before remove
EOffset := Entry.Offset;
ESize   := Entry.Compresssize;

//remove the current file of the dir
RemoveEntry(FileName);

//arrange the offsets of the files after the current one
pakUpdateFileEntrysAfterRemove(EOffset,ESize);

//move the old data
if not MoveData(pakFile,EOffset+ESize,FileSize(pakFile)-EOffset-ESize,-ESize)
   then begin result := FILE_WRITEERROR; exit; end;

//write the new dir/header
pakHeader.DirOffset := pakHeader.DirOffset-ESize;
seek(pakFile,0);
blockwrite(pakFile,pakHeader,SizeOf(pakHeader));
seek(pakfile,pakHeader.diroffset);
blockwrite(pakFile,pakEntrys^,pakHeader.DirSize);

//truncate the file
  //the pos is after where we wrote the dir
Truncate(pakFile);
//close the file
CloseFile(pakFile);
end;

function  pakUpdateFile(FileName,Source : String) : TError; //update the data in the file
var Entry : PPakEntry;
    SourceFile,pakFile : File;
    buffer : Pointer;
    SizeDiff : Integer;
begin
std_write('Updating %s from %s',[FileName,Source]);
result := FILE_INVALID;
Entry := GetPakEntry(FileName);
AssignFile(SourceFile,Source);
Reset(SourceFile,1);
AssignFile(pakFile,pakFileName);
Reset(pakFile,1);
//*** Warning this will not work on compressed files ******//
If FileSize(SourceFile) = Entry.CompressSize then
   begin
   getmem(buffer,entry.CompressSize);
   blockread(sourcefile,buffer^,entry.CompressSize);
   seek(pakFile,entry.offset);
   blockwrite(pakfile,buffer^,entry.CompressSize);
   freemem(buffer);
   result := OK;
   end else
//if the file size is different we will have to move all the data in the pak!!!
   If FileSize(SourceFile) < Entry.CompressSize then
   begin
   SizeDiff := Entry.CompressSize-FileSize(SourceFile);
   MoveData(pakFile,Entry.Offset+Entry.CompressSize,
                    FileSize(pakFile)-Entry.Offset-Entry.CompressSize,
                    -SizeDiff);
   pakUpdateFileEntrysAfterRemove(Entry.Offset,SizeDiff);
   getmem(buffer,FileSize(SourceFile));
   blockread(sourcefile,buffer^,FileSize(SourceFile));
   seek(pakFile,entry.offset);
   blockwrite(pakfile,buffer^,FileSize(SourceFile));
   freemem(buffer);
   entry.size :=  FileSize(SourceFile);
   entry.CompressSize := entry.size;
   entry.compresstype := 0;
   result := OK;
   pakHeader.diroffset := pakHeader.diroffset-SizeDiff;
   end else// it's larger
   begin
   SizeDiff := FileSize(SourceFile) - Entry.CompressSize;
   MoveData(pakFile,Entry.Offset+Entry.CompressSize,
                    FileSize(pakFile)-Entry.Offset-Entry.CompressSize,
                    SizeDiff);
   pakUpdateFileEntrysAfterRemove(Entry.Offset,-SizeDiff);
   getmem(buffer,FileSize(SourceFile));
   blockread(sourcefile,buffer^,FileSize(SourceFile));
   seek(pakFile,entry.offset);
   blockwrite(pakfile,buffer^,FileSize(SourceFile));
   freemem(buffer);
   entry.size :=  FileSize(SourceFile);
   entry.CompressSize := entry.size;
   entry.compresstype := 0;
   result := OK;
   pakHeader.diroffset := pakHeader.diroffset+SizeDiff;
   end;

seek(pakFile,0);
blockwrite(pakFile,pakHeader,SizeOf(pakHeader));
seek(pakfile,pakHeader.diroffset);
blockwrite(pakFile,pakEntrys^,pakHeader.DirSize);

//truncate the file
  //the pos is after where we wrote the dir
Truncate(pakFile);
closefile(pakFile);
closefile(sourcefile);
end;

Procedure pakRemoveDir(dir : string);
begin
end;

Procedure pakRenamedir(dir : string;newname : string);
var i : Integer;
    entry : PpakEntry;
    comparestr,entryname : String;
begin
//find and update all matching files
std_write('Renaming directory %s to %s',[dir,newname]);
for i := 0 to (pakheader.dirsize div sizeof(tpakEntry))-1 do
    begin
    Entry := PpakEntry( pointer ( cardinal(pakEntrys) + (i * sizeof(tpakEntry)) ));
    comparestr := copy(Entry.filename,1,length(dir));
    if comparestr = dir then
       begin
       entryname := newname+copy(Entry.filename,length(dir)+1,maxint);
       if length(entryname) <= 56 then
          begin
          if pakFileExists(entryname) then begin std_write('%s already exists',[entryname]); continue; end;
          fillchar(entry.filename,sizeof(entry.filename),0);
          move(entryname[1],entry.filename,length(entryname));
          end else begin std_error('Filename to long. %s',[entryname]); continue; end;
       end;
    end;
//update the tree view and save it
end;

{***************************
Dirtree Creation

The directory is extracted from the file entrys in the pak file, it is made up
of a linked list of items, due to the structure of the pak files empty dir's
cannot exist, therefor the entry field of a directory is always nil and the
SubItems field is never nil, this is a good way to check if a node is a dir
****************************}

//extract the first directory of the file name (does not remove it from the orig)
function GetFirstDir(FileName : string) : string;
begin
result := copy(FileName,1,pos('/',FileName)-1);
end;

function GetNewTreeItem : PDirTreeItem;
begin
    new(result);
    result.index := NumTreeItems;
    result.entry := nil;
    Inc(NumTreeItems);
end;

procedure RemoveTreeItem(item : PDirTreeItem);
begin
    Dispose(Item);
    Dec(NumTreeItems);
end;

//add a node at the same level as Node
function AddNext(var Node : TDirTreeItem;Name : String) : PDirTreeItem;
begin
if node.nextitem <> nil then std_write('Warning old NextItem overwritten',[nil]);
Node.NextItem := GetNewTreeItem;
Result := Node.NextItem;
Node.NextItem.Name := Name;
Node.NextItem.NextItem := Nil;
Node.NextItem.SubItems := Nil;
end;

//ad a Not at a sub level of Node
function AddSub(var Node : TDirTreeItem;Name : String) : PDirTreeItem;
begin
if node.SubItems <> nil then std_write('Warning old SubItems overwritten',[nil]);
Node.SubItems := GetNewTreeItem;
Result := Node.SubItems;
Node.SubItems.Name := Name;
Node.SubItems.NextItem := Nil;
Node.SubItems.SubItems := Nil;
end;

//dump the tree (debug)
procedure TraverseTree(var Node : TDirTreeItem);
var TempNode : PDirTreeItem;
begin
TempNode := @Node;

while tempnode <> nil do
begin
std_write(TempNode.Name+' %d',[TempNode.Index]);
If TempNode.SubItems <> Nil then
     begin
     TraverseTree(TempNode.SubItems^);
     end;
TempNode := TempNode.NextItem;
end;

end;

//create the first level of the dirtree structure
Procedure CreateFirstLevel; //add all the files equal to the root
var i,j : integer;
    entry : PPakEntry;
    temp : PDirTreeItem;
begin
DirRoot.NextItem := Nil;
DirRoot.SubItems := Nil;
DirRoot.Name := 'Root';
j := (pakheader.dirsize div sizeof(tpakEntry))-1;
temp := AddSub(DirRoot,pakEntrys^.filename);
temp.entry := PakEntrys;
for i := 1 to j do
    begin
    entry := PpakEntry( pointer ( cardinal(pakEntrys) + (i * sizeof(tpakEntry)) ));
    temp := AddNext(temp^,entry.filename);
    temp.entry := entry;
    end;
end;

//recursively create the whore tree structure
procedure CreateSecondLevel(TheRoot : PDirTreeItem);
var temp,lasttemp,dircont,newroot : PDirTreeItem;
    dir : string;
label a;
begin

while true do
begin
temp := TheRoot.subitems;
while temp <> nil do
      begin
      dir := getfirstdir(temp.name);//get the dir name of the first file
      if dir <> '' then goto a;
      temp := temp.nextitem;
      end;
      Break; //er is geen dir meer gevonden dus stoppen maar
a:
dircont := AddSub(temp^,copy(temp.name,pos('/',temp.name)+1,maxint ));//create a sub node for the first file
dircont.entry := temp.entry;
NewRoot := Temp;
temp.name := dir;//rename the old first file to the directory
temp.entry := nil;

lasttemp := temp;
temp := temp.nextitem;

      while temp <> nil do
      begin
      if getfirstdir(temp.name) = dir then //Get it out of the list and add to subnode
         begin
         //add it in the sub dir
         dircont := addnext(dircont^,copy(temp.name,pos('/',temp.name)+1,maxint));
         dircont.entry := temp.entry;
         //remove it from the higher dir
         lasttemp.nextitem := temp.nextitem; //vorige next naar de next van de gefreede pointer
         RemoveTreeItem(temp);
         temp := lasttemp.nextitem;
         continue;
         end;
      lasttemp := temp;
      temp := temp.nextitem;
      end;
CreateSecondLevel(NewRoot);
end;

end;

Procedure RFreeDir(var Root : PDirTreeItem);
var Temp,OldTemp : pDirTreeItem;
begin
//Tree.Items.AddChild(RootNode,Root.Name);
Temp := Root;
while Temp <> nil do
      begin
      if Temp.SubItems <> nil then //only add directorys to the tree
         begin
         RFreeDir(Temp^.SubItems);
         end;
      OldTemp := Temp;
      Temp := Temp.nextItem;
      RemoveTreeItem(oldtemp);
      end;
root := nil;      
end;

//used by CreateTreeFromDir
Procedure RCreateTreeFromDir(var Tree : TTreeView;var RootNode : TTreeNode;var Root : TDirTreeItem);
var temp : pDirTreeItem;
    tempnode : TTreeNode;
begin
//Tree.Items.AddChild(RootNode,Root.Name);
temp := @Root;
while temp <> nil do
      begin
      if Temp.SubItems <> nil then //only add directorys to the tree
         begin
         if temp = @root then TempNode := Tree.Items.AddChildFirst(RootNode,temp.Name)
                         else TempNode := Tree.Items.AddChild(RootNode,temp.Name);
         TempNode.ImageIndex := 2;
         TempNode.SelectedIndex := 3;
         RCreateTreeFromDir(Tree,TempNode,temp^.SubItems^);
         end;
      temp := temp.nextItem;
      end;
end;

//create TTreeview nodes from the directory tree for the user interface
Procedure CreateTreeFromDir(Var Tree : TTreeView);
var  TempNode : TTreeNode;
begin
 RFreeDir(DirRoot.SubItems);
 Tree.Items.BeginUpdate;
 Tree.Items.Clear;
 TempNode := Tree.Items.Add(nil,'/');
 TempNode.Imageindex := 2;
 TempNode.Selectedindex := 2;
 if pakHeader.DirSize > 0 then
    begin
    CreateFirstLevel;
    CreateSecondLevel(@DirRoot);
    //TraverseTree(DirRoot);
    RCreateTreeFromDir(Tree,TempNode,DirRoot.SubItems^);
    end;
 Tree.Items.EndUpdate;
 Tree.Selected := TempNode;
end;

//get the first file node of the files in dir (use nextitem to find the next file)
Function RGetFirstFile(Dir : String;Root : PDirTreeItem) : PDirTreeItem;
var temp : PDirTreeItem;
    tempdir : string;
begin
result := nil;
temp := root;
tempdir := GetFirstDir(Dir); //get the dir we search for
if tempdir = '' then begin Result := root; exit; end;
Delete(Dir,1,Pos('/',Dir)); //we are going to do a recurse search with what's left
while temp <> nil do
      begin
      If Temp.Name = TempDir then
         begin
         if Temp.SubItems <> nil then
            Result := RGetFirstFile(Dir,Temp.SubItems)
            else std_write('Error: Empty dir',[nil]);
         Exit;//there can be only one dir with the same name
         end;
      temp := temp.nextitem;
      end;
end;


//get the imagedindex of the icon of the file for the listview item imageindex field
function GetAssociatedIcon(Filename : String) : Integer;
var i : integer;
begin
for i := 0 to NumFileTypes-1 do
    begin
    if extractfileext(filename) = FileTypes[i] then
       begin
       result := 4+i;
       exit;
       end;
    end;
result := 0;
end;

//fill lisview.items with the file in the filestr dir
Procedure PutList(filestr : string;List : TListView);
var ListItem : TListItem;
    thefile : PDirTreeitem;
begin
thefile := RGetFirstFile(FileStr,DirRoot.SubItems);
List.Items.BeginUpdate;
List.Items.Clear;
while thefile <> nil do
      begin
      ListItem := List.Items.Add;
      ListItem.Caption := thefile.name;
      if thefile.entry = nil then begin
                                  Thefile := thefile.nextitem;
                                  Listitem.Imageindex := 2;
                                  continue;
                                  end;
      ListItem.SubItems.Add(thefile.entry.Filename);
      ListItem.SubItems.Add(floattostrf(thefile.entry.size / 1024,ffFixed,5,1)+'kb');
      Listitem.ImageIndex := GetAssociatedIcon(thefile.name);
      if thefile.entry.compresstype <> 0 then
       begin
       //Listitem.Imageindex := 1;
       ListItem.SubItems.Add(inttostr(100-round((thefile.entry.compresssize / thefile.entry.size)*100))+'%');
       end else ListItem.SubItems.Add('0%');
      thefile := Thefile.NextItem;
    end;
List.Items.EndUpdate;
end;

function checkcancelled : boolean;
var keyboardstate : tkeyboardstate;
begin
result := false;
Getkeyboardstate(keyboardstate);
if getasynckeystate(VK_ESCAPE) and $0F <> 0 then begin result := true; exit; end;
if (keyboardstate[VK_ESCAPE] and $F0) <> 0 then begin result := true; exit; end;
end;

//extract a whole dir and all it's subdirectory's
Procedure pakExtractDir(sourcefile : String;var c : Boolean);
var thefile : PDirTreeitem;
begin
std_write('Extracting directory %s',[sourcefile]);
thefile := RGetFirstFile(sourcefile,DirRoot.SubItems);
while thefile <> nil do
      begin
      if thefile.entry <> nil then begin
                                   InterfaceExtractFile(thefile.entry.filename);
                                   end else
                                       begin
                                       pakExtractDir(sourcefile+thefile.name+'/',c);
                                       if c = true then exit;
                                       end;

      if checkcancelled then begin c := True; exit; end;
      thefile := Thefile.NextItem;
     end;
end;

procedure pakExtractAll(var Cancel : Boolean);
var i : Integer;
    entry : ppakEntry;
begin
 entry := nil;
for i := 0 to (pakheader.dirsize div sizeof(tpakEntry))-1 do
    begin
     entry := PpakEntry( pointer ( cardinal(pakEntrys) + (i * sizeof(tpakEntry)) ));
     InterFaceExtractFile(entry.filename);
     Cancel := checkcancelled;
     if cancel then exit;
    end;
end;

end.
