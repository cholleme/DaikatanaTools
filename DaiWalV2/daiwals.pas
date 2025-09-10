unit DaiWals;

interface

type tWal = array[0..0] of byte;
     pWal = ^tWal;

Function Loadwal(filename : string;var width,height : integer) : pwal;

implementation
uses sysutils,pakfiles,modelu,optu;

type tWalPalette = array[0..255,0..2] of byte;
type tPalWal = array[0..0] of byte;
     pPalWal = ^tPalWal;

type tWalHeader = packed record
        version : byte;                      //seems to be v3
        name	: array [0..31] of char;     //name of file
        //something : byte;
        width   : integer;                   //width of file
        height  : integer;                   //height of file
        paletteofs : integer;                //offset of palette into file
        mipofs0 : integer;                   //offset of unresized image
        end;//ther is more data in header but it's not used by LoadWal

function ExtractFile(Sourcefile,Destfile : string): tError;
var pakfile : string;
    i : integer;
begin
//decompress the file to a temp file
std_write('extracting wal file('+ Sourcefile +') to '+destfile);
i := 1;
pakfile := OptionsForm.DaiPath.Text+'\pak'+inttostr(i)+'.pak';
std_write('trying '+pakfile);
//while (result <> ok) and (fileexists(pakfile) = true) do
//begin
      std_write('trying '+pakfile);
      Init_Pakfile(pakfile);
      result := pakextractfile(SourceFile,Destfile);
      Free_Pakfile;
      inc(i);
      pakfile := OptionsForm.DaiPath.Text+'\pak'+inttostr(i)+'.pak';
//end;
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

if ExtractFile(filename,'c:\daitemp.wal') <> OK then exit;

if fileexists('c:\daitemp.wal') = false then begin std_write('extracting failed'); exit; end;
AssignFile(WalFile,'c:\daitemp.wal');
Reset(WalFile,1);
//Read header
BlockRead(Walfile,WalHeader,sizeof(WalHeader));
with WalHeader do begin
//if width = 0 then width := height;
//Read palette
Seek(Walfile,124);
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
    end;
end;//with walheader
std_write('loadwall succes! '+inttostr(width)+' '+inttostr(height));
result := Dest;
end;

end.
