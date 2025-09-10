//******************************************************************************
//
// Game project unit
// (c) 1999 Charles Hollemeesch
// Description: routines to make loading out op grouped(pak) files possible
//
// Quickly modified for reading daikatana pak files
{  Difference with usual pak files

              Every entry in the dir is 72 bytes instead of 64 bytes
                    56 bytes filename
                    4  bytes(long) offset in pack
                    4  bytes(long) size of file
                    4  bytes(long) ??? is sometimes the same as size
                    4  bytes(long?) ??? is always [0,0,0,0]
The file offset seems to be ok because extracted files have a valid header but
the filesize remains a problem.
Extracted bmp/tga's wil not be read(By Paint Shop Pro 6.0)
}
//******************************************************************************

unit pakfiles;

{$MODE Delphi}

interface
uses comctrls;
type tError =( OK,
               FILE_NOTFOUND,
               FILE_WRITEERROR,
               FILE_READERROR,
               FILE_INVALID
              );

var
pakfilename : string;
strangesize : boolean;
extradata : record
            size2 : longint;
            ofs2 : word;
            ofs3 : word;
            end;

function pakassignresetfile(var pakfile : file;filename : string;var fileoffset,filesizer,compsize,comptype : longint) : Terror;
function pakextractfile(source,dest : string) : TError;
function Init_pakfile(filename : string) : TError;
function pakfileexists(filename : string) : boolean;
function pakExclusivepakfileexists(filename : string) : boolean;
Procedure PutList(List : TListView;pbar : TProgressBar);
procedure Free_Pakfile;
function filenamedos(fname : string) : string;

implementation
uses sysutils,dialogs,modelu;
type
  TpakHeader = record
  magic : array [0..3] of char; // Sould be "PACK"
  diroffset : cardinal;         // Position of directory from start of file
  dirsize   : cardinal;         // Size of the directory
  end;


  TpakEntry = packed record
  filename : array[0..55] of char;
  offset : longint;                      // Position of the file in pak file
  size : longint;                       // Size of the uncompressed file
  compresssize   : longint;             // Size of the compressed file
  compresstype   : longint;             // Type of compression
  end;

  PPakEntry = ^Tpakentry;

const pakmagic1 : array[0..3] of char = ('P','A','C','K');

var
  pakEntrys : ppakEntry;
  pakheader : Tpakheader;

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

if fileexists(extractfiledir(pakfilename) +'\'+ filenamedos(filename)) then result := true;
end;

function pakExclusivepakfileexists(filename : string) : boolean;
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
   normalfile : string;
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
   //try to open from a normal file
   normalfile := extractfiledir(pakfilename) +'\'+ filenamedos(filename);
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
    else begin
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

function pakextractfile(source,dest : string) : TError;
type bytearray = array[0..0] of byte;
var sourcefile,destfile : file;
    fileoffset,filesize,comptype,compsize : longint;
    data               : ^byte;
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
        assignfile(destfile,dest);
        rewrite(destfile,1);

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
		blockwrite(destfile,dst_data^,filesize);
                //blockwrite(destfile,src_data^,compsize);
                freemem(src_data);
		freemem(dst_data);
        end //if compressed
        else begin
        getmem(data,filesize);
        blockread(sourcefile,data^,filesize);
        blockwrite(destfile,data^,filesize);
        freemem(data);
        end;

        closefile(destfile);
        closefile(sourcefile);
        result := OK;
   end
   else result := FILE_NOTFOUND;
end;

function Init_pakfile(filename : string) : TError;
var
  pakfile : file;
  apakEntry : PpakEntry;
  i : integer;
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
//std_write('Loaded '+pakfilename+' with '+inttostr(pakheader.dirsize div sizeof(tpakEntry))+' entrys',[nil]);
//allocate mem for the dir
getmem(pakEntrys,pakheader.dirsize);
//go to the dir
seek(pakfile,0);
seek(pakfile,pakheader.diroffset);
//read the dir
blockread(pakfile,pakEntrys^,pakheader.dirsize);
closefile(pakfile);
end;

procedure Free_Pakfile;
begin
freemem(pakEntrys,pakheader.dirsize);
end;

Procedure PutList(List : TListView;pbar : TProgressBar);
var ListItem : TListItem;
   i,j : integer;
   entry : ppakentry;
begin
//ListItem := List.Items.Add;
//ListItem.Caption := PakFileName;
//std_write('Creating file list please wait',[nil]);
j := (pakheader.dirsize div sizeof(tpakEntry))-1;
PBar.Max := (j div 50)+1;
Pbar.Position := 0;
//More than 200 is slow for testing pak1.pak
//if j > 200 then j := 200;
List.AllocBy := j;
List.Items.BeginUpdate;
 for i := 0 to j do
    begin
    if (i mod 50) = 0 then Pbar.Position := Pbar.Position + 1;
    entry := PpakEntry( pointer ( cardinal(pakEntrys) + (i * sizeof(tpakEntry)) ));
    ListItem := List.Items.Add;
    ListItem.Caption := entry.filename;
    ListItem.SubItems.Add(floattostrf(entry.size / 1024,ffFixed,5,1)+'kb');
    if entry.compresstype <> 0 then
       begin
       Listitem.Imageindex := 1;
       ListItem.SubItems.Add(inttostr(100-round((entry.compresssize / entry.size)*100))+'%');
       end else ListItem.SubItems.Add('0%');
    end;
List.Items.EndUpdate;
Pbar.Position := 0;
end;    
end.
