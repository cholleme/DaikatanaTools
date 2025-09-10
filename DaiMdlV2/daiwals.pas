unit DaiWals;

{$MODE Delphi}

interface
uses pakfiles;

type tWal = array[0..0] of byte;
     pWal = ^tWal;

Function Loadwal(filename : string;var width,height : integer) : pwal;
function ExtractFile(Sourcefile,Destfile : string): tError;
function FullPath(filename : string) : string;
function Exclusivepakfileexists(filename : string) : boolean;//only if it's really in the pak and not in a sub dir
function NewFileExists(filename : string) : boolean;//only if it's really in the pak and not in a sub dir

implementation
uses windows,sysutils,modelu,optu;

type tWalPalette = array[0..255,0..2] of byte;
type tPalWal = array[0..0] of byte;
     pPalWal = ^tPalWal;

type tWalHeader = packed record
        name	: array [0..31] of char;      //name of file
        palofs   : integer;                   //width of file
        width  : integer;                     //height of file
        height : integer;                     //offset of palette into file
        mipofs0 : integer;                    //offset of unresized image
        end;//ther is more data in header but it's not used by LoadWal

function FullPath(filename : string) : string;
begin
result := OptionsForm.DaiPath.Text+'\'+ filenamedos(filename);
end;

function Exclusivepakfileexists(filename : string) : boolean;//only if it's really in the pak and not in a sub dir
var pakfile : string;
   // pdes,psour : PChar;
    i : integer;
begin
result := false;
for i := 1 to 256 do
      begin
      pakfile := OptionsForm.DaiPath.Text+'\pak'+inttostr(i)+'.pak';
      if fileexists(pakfile) = false then break;
      //std_write('trying '+pakfile);
      Init_Pakfile(pakfile);
      if pakExclusivepakfileexists(filename) then
          begin result := true; break; Free_Pakfile; end;
      Free_Pakfile;
      end;
end;

function NewFileExists(filename : string) : boolean;//only if it's really in the pak and not in a sub dir
var pakfile : string;
   // pdes,psour : PChar;
    i : integer;
begin
result := false;
if fileexists(OptionsForm.DaiPath.Text+'\'+filenamedos(filename)) then
   begin
   result := true;
   exit;
   end;
for i := 1 to 256 do
      begin
      pakfile := OptionsForm.DaiPath.Text+'\pak'+inttostr(i)+'.pak';
      if fileexists(pakfile) = false then break;
      //std_write('trying '+pakfile);
      Init_Pakfile(pakfile);
      if pakExclusivepakfileexists(filename) then
          begin result := true; break; Free_Pakfile; end;
      Free_Pakfile;
      end;
end;

function ExtractFile(Sourcefile,Destfile : string): tError;
var pakfile : string;
    pdes,psour : PChar;
    i : integer;
begin
result := FILE_NOTFOUND;

//if the file already exists load that one
if fileexists(OptionsForm.DaiPath.Text+'\'+filenamedos(Sourcefile)) then
   begin
        std_write('using existing file "'+ OptionsForm.DaiPath.Text+'\'+filenamedos(Sourcefile) +'"');
        pdes := PChar(DestFile);
        psour := PChar(OptionsForm.DaiPath.Text+'\'+filenamedos(Sourcefile));
        deletefile(destfile);
        copyfile(psour,pdes,False);
        result := OK;
        exit;
   end;
//decompress the file to a temp file
std_write('extracting "'+ Sourcefile +'" to "'+destfile+'"');
//std_write('trying '+pakfile);

i := 1;
for i := 1 to 256 do
      begin
      pakfile := OptionsForm.DaiPath.Text+'\pak'+inttostr(i)+'.pak';
      if fileexists(pakfile) = false then break;
      std_write('trying '+pakfile);
      Init_Pakfile(pakfile);
      if pakextractfile(SourceFile,Destfile) = ok then
          begin result := OK; break; Free_Pakfile; end;
      Free_Pakfile;
      end;
if Result <> OK then std_write('not found: '+Sourcefile);
end;



function Loadwal(filename : string;var width,height : integer) : pWal;
var
Source : pPalWal;
Dest   : pWal;
WalFile : file;
WalHeader : tWalHeader;
WalPalette : tWalPalette;
i : integer;
begin
result := nil;

if ExtractFile(filename,'c:\daitemp.wal') <> OK then begin
                                                     std_write('File not found: '+Filename);
                                                     exit;
                                                     end;

if fileexists('c:\daitemp.wal') = false then begin std_write('extracting failed'); exit; end;

AssignFile(WalFile,'c:\daitemp.wal');
Reset(WalFile,1);
//Read header
BlockRead(Walfile,WalHeader,sizeof(WalHeader));
width := walheader.width;
height := walheader.height;
with WalHeader do begin
//if width = 0 then width := height;
//Read palette
Seek(Walfile,120);
BlockRead(Walfile,WalPalette,sizeof(WalPalette));
//Read data
Seek(Walfile,892);
GetMem(Source,Width * Height);
BlockRead(Walfile,Source^,Width * Height);
//Convert to rgb
GetMem(Dest,Width * Height * 3);
for i := 0 to width*height-1 do
    begin
    move(WalPalette[Source^[i],0],Dest^[i*3],3);
    {if (WalPalette[Source^[i],0] = 255) and  (WalPalette[Source^[i],2] = 255) then
       begin
       Dest^[(i*4)+3] := 0;
       Dest^[(i*4)] := 128;
       Dest^[(i*4)+1] := 128;
       Dest^[(i*4)+2] := 128;
       end
    else Dest^[(i*4)+3] := 255;    }
    end;
end;//with walheader
result := Dest;
CloseFile(WalFile);
end;

end.
