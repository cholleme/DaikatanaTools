unit mainu;

{$MODE Delphi}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, Fast256, ExtCtrls, ExtDlgs, StdCtrls;

type

  { TForm1 }

  TForm1 = class(TForm)
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Mip7: TMenuItem;
    Mip6: TMenuItem;
    Mip5: TMenuItem;
    Mip4: TMenuItem;
    Mip3: TMenuItem;
    Mip2: TMenuItem;
    Mip1: TMenuItem;
    Mip0: TMenuItem;
    MipMenuItem: TMenuItem;
    Open1: TMenuItem;
    Export1: TMenuItem;
    OpenDialog1: TOpenDialog;
    Save1: TMenuItem;
    N1: TMenuItem;
    Import1: TMenuItem;
    SaveDialog2: TSaveDialog;
    OpenDialog2: TOpenPictureDialog;
    SaveDialog1: TSavePictureDialog;
    Label1: TLabel;
    procedure FormPaint(Sender: TObject);
    procedure Mip0Click(Sender: TObject);
    procedure Open1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Export1Click(Sender: TObject);
    procedure Import1Click(Sender: TObject);
    procedure Save1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
    activeMip : Integer;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  Batching : boolean = false;
implementation
var images : array[0..8] of Tfast256;

type tWal = array[0..0] of byte;
     pWal = ^tWal;
type tWalPalette = array[0..255,0..2] of byte;
type tPalWal = array[0..0] of byte;
     pPalWal = ^tPalWal;

type tWalHeader = packed record
        name   : array [0..31] of char;     //name of file
        palofs : integer;
        width  : integer;                   //height of file
        height : integer;                   //width of file
        mipofs : array[0..8] of integer;    //offset of unresized image
        end;


function checksize(i : integer) : boolean;
begin
if (i = 2)or(i=4)or(i=8)or(i=16)or(i=32)or(i=64)or(i=128)or(i=256) then result := true
else result := false;
end;

Procedure Flip(Bmp:TFast256);
var
y,h:   Integer;
b1,b2,
Line: PBytes;
begin
GetMem(Line,Bmp.Width);
h:=Bmp.Height-1;
b1:=Bmp.Bits;
b2:=TFast256(Bmp).Pixels[Bmp.Height-1];
for y:=0 to h div 2 do
    begin
    CopyMemory(Line,b1,Bmp.Width);
    CopyMemory(b1,b2,Bmp.Width);
    CopyMemory(b2,Line,Bmp.Width);
    b1:=Pointer(PtrUINT(b1)+Bmp.RowInc);
    b2:=Pointer(PtrUINT(b2)-Bmp.RowInc);
    end;
end;

Procedure SaveWal(Filename : string;image : Tfast256);
var
tempimgs    : array[0..8] of Tfast256;
fileBuffer  : pWal;
fileHeader  : tWalHeader;
filePalette : TWalPalette;
filebufpos,i: integer;
mipwidths   : array[0..8] of integer;
mipheights  : array[0..8] of integer;
walfile     : file;
tempstr     : string;
lastmip     : array[0..4] of integer;
const mipofs = 892;
begin
// standard mipofs = 892
// standard palofs = 120
lastmip[0] := 0;
lastmip[1] := 0;
lastmip[2] := 0;
lastmip[3] := 0;

//initialize vars
fillchar(FileHeader,SizeOf(FileHeader),0);
fillchar(FilePalette,SizeOf(FilePalette),0);
filebufpos := 0;

//start with the file
FileHeader.Name := chr(3);
tempstr := extractfilename(filename);
move(tempstr[1],FileHeader.Name[1],length(tempstr));
FileHeader.Width := image.Width;
FileHeader.Height := image.Height;

//calcultate mip scales
mipwidths[0] := FileHeader.Width;
mipheights[0] := FileHeader.Height;
for i := 1 to 8 do
      begin
      mipwidths[i] := mipwidths[i-1] div 2;
      mipheights[i] := mipheights[i-1] div 2;
      end;

//write shit to the file to get us at the right pos
AssignFile(walfile,filename);
Rewrite(walfile,1);
Getmem(FileBuffer,mipofs);
fillchar(filebuffer^,mipofs,0);
BlockWrite(walfile,filebuffer^,mipofs);
FreeMem(FileBuffer);

//write mipmaps
for i := 0 to 8 do
      begin
      fileHeader.mipofs[i] := FilePos(walfile);
      if (mipwidths[i] > 1) and (mipheights[i]  > 1) then
         begin
         tempimgs[i] := Tfast256.create;
         tempimgs[i].setsize(mipwidths[i],mipheights[i]);
         Images[0].Resize(tempimgs[i]);
         blockwrite(walfile,tempimgs[i].pixels[0,0],mipwidths[i]*mipheights[i]);
         tempimgs[i].free;
         end else begin
                  blockwrite(walfile,lastmip,4);
                  end;
      end;

//write header
seek(walfile,0);
blockwrite(walfile,fileHeader,sizeof(TWalHeader));

//write palette
seek(walfile,120);
for i := 0 to 255 do
    begin
    filePalette[i,0] := Images[0].BMInfo.bmiColors[i].r;
    filePalette[i,1] := Images[0].BMInfo.bmiColors[i].g;
    filePalette[i,2] := Images[0].BMInfo.bmiColors[i].b;
    end;
blockwrite(walfile,filePalette,sizeof(TWalPalette));
//end
close(walfile);
end;

function Loadwal(filename : string;var width,height : integer) : pWal;
var
Source : pPalWal;
Dest   : pWal;
WalFile : file;
WalHeader : tWalHeader;
WalPalette : tWalPalette;
i,j : integer;
MipWidth, MipHeight : Integer;
bucht : array[0..10] of integer;
begin
result := nil;

AssignFile(WalFile,filename);
Reset(WalFile,1);
//Read header
BlockRead(Walfile,WalHeader,sizeof(WalHeader));
BlockRead(Walfile,Bucht,sizeof(bucht));
width := walheader.width;
height := walheader.height;
with WalHeader do begin
//Read palette
Seek(Walfile,120);
BlockRead(Walfile,WalPalette,sizeof(WalPalette));
//Read data

for i:= 0 to 8 do
    begin

    MipWidth := width >> i;
    MipHeight := height >> i;

    // Handle non square mips
    if (MipWidth=0) and (MipHeight=0) then
       begin
       Images[i].Setsize(0,0);
       Continue;
       end;

    MipWidth := Max(MipWidth,1);
    MipHeight := Max(MipHeight,1);

    Seek(Walfile,walheader.mipofs[i]);
    Images[i].Setsize(MipWidth,MipHeight);
    BlockRead(Walfile,Images[i].Pixels^[0,0],MipWidth * MipHeight);
    //Initialize the palette
    for j := 0 to 255 do
        begin
        Images[i].BMInfo.bmiColors[j].r := WalPalette[j,0];
        Images[i].BMInfo.bmiColors[j].g := WalPalette[j,1];
        Images[i].BMInfo.bmiColors[j].b := WalPalette[j,2];
        end;
    end;

end;//with walheader
result := Dest;
CloseFile(WalFile);
end;

{$R *.lfm}

procedure ConvertWal(filename : String);
var width,height : integer;
begin
loadwal(filename,width,height);
Flip(images[0]);
images[0].savetofile(changefileext(filename,'.bmp'));
end;

procedure RevertWal(filename : String);
var width,height : integer;
begin
images[0].LoadFromFile(filename,cmCut);
   if  (not checksize(images[0].width)) or (not checksize(images[0].height)) then
       begin
       MessageDlg('Width and height must be a power of 2 and <= 256',mtError,[mbOk],0);
       exit;
       end;
SaveWal(changefileext(Filename,'.wal'),images[0]);
end;

procedure TForm1.FormPaint(Sender: TObject);
begin
if batching then exit;
if images[activeMip] <> nil then
   begin
   canvas.brush.color := clBtnFace;
   canvas.pen.color := clBtnFace;
   canvas.Rectangle(0,0,clientwidth,clientheight);
   images[activeMip].draw(canvas.handle,0,0);
   end;
end;

procedure TForm1.Mip0Click(Sender: TObject);
begin
  activeMip := TMenuItem(Sender).Tag;
  Invalidate;
end;

procedure TForm1.Open1Click(Sender: TObject);
var width,height,i,j,k : integer;
    data : pwal;
    temp : byte;
    buf : ^byte;
begin
If OpenDialog1.Execute then
   begin
   data := loadwal(opendialog1.filename,width,height);
   invalidate;
   end;
end;

Procedure BatchConvert(argument : string);
var SearchRec: TSearchRec;
    Path : String;
begin
path := extractfiledir(argument);
if path = '' then path := '.\' else path := path + '\';
if FindFirst(argument, faAnyFile, SearchRec) <> 0 then
   begin MessageDlg('No files found with '+argument,mtError,[mbok],0); exit; end;
form1.label1.visible := true;

ConvertWal(path+SearchRec.Name);
while  FindNext(SearchRec) = 0 do
       ConvertWal(path+SearchRec.Name);

FindClose(SearchRec);
form1.label1.visible := false;
end;

Procedure BatchRevert(argument : string);
var SearchRec: TSearchRec;
    Path : String;
begin
path := extractfiledir(argument);
if path = '' then path := '.\' else path := path + '\';
if FindFirst(argument, faAnyFile, SearchRec) <> 0 then
   begin MessageDlg('No files found with '+argument,mtError,[mbok],0); exit; end;
form1.label1.visible := true;

RevertWal(path+SearchRec.Name);
while  FindNext(SearchRec) = 0 do
       RevertWal(path+SearchRec.Name);

FindClose(SearchRec);
form1.label1.visible := false;
end;

procedure TForm1.FormCreate(Sender: TObject);
var width,height,i,j,k : integer;
    data : pwal;
    temp : byte;
    buf : ^byte;
begin
   for i := 0 to 8 do
       begin
       Images[i] := TFast256.Create;
       end;

   activeMip := 0;

   if paramcount <> 0 then
   begin
   if (paramstr(1) = '-c') or (paramstr(1) = '-e') then //batch conversion
      begin
      if paramcount < 2 then begin Messagedlg('No file name specified',mtError,[mbok],0); exit; end;
      batching := true; //wait to start until form is visible
      exit;
      end;
   if not fileexists(paramstr(1)) then begin messagedlg('File not found'+paramstr(1),mterror,[mbok],0); exit; end;
   data := loadwal(paramstr(1),width,height);
   invalidate;
   end;
end;

procedure TForm1.FormDestroy(Sender: TObject);
var i : integer;
begin
for i := 0 to 8 do
    begin
    Images[i].Free;
    end;
end;

procedure TForm1.Export1Click(Sender: TObject);
begin
if images[0].pixels = nil then begin messagedlg('Open an image first.',mtError,[mbOk],0); exit; end;
if savedialog1.execute then
              begin
              Flip(images[0]);
              images[0].savetofile(savedialog1.filename);
              Flip(images[0]);
              end;
end;

procedure TForm1.Import1Click(Sender: TObject);
var i, mipWidth, mipHeight : integer;
begin
if opendialog2.execute then
   begin
   images[0].LoadFromFile(opendialog2.filename,cmCut);

   // Generate mips
   for i := 1 to 8 do
       begin
       mipWidth := images[0].Width >> i;
       mipHeight := images[0].Height >> i;
       Images[i].setsize(mipWidth,mipHeight);
       Images[0].Resize(Images[i]);
       end;

   if  (not checksize(images[0].width)) or (not checksize(images[0].height)) then
       begin
       MessageDlg('Width and height must be a power of 2 and <= 256',mtError,[mbOk],0);
       images[0].setsize(0,0);
       end;
   Invalidate;
   end;
end;

procedure TForm1.Save1Click(Sender: TObject);
begin
if images[0].pixels = nil then begin messagedlg('Open an image first.',mtError,[mbOk],0); exit; end;
If SaveDialog2.Execute then
   begin
   SaveWal(SaveDialog2.Filename,images[0]);
   end;
end;

procedure TForm1.FormActivate(Sender: TObject);
begin
if batching then
   begin
   if paramstr(1) = '-c' then BatchConvert(paramstr(2))
      else if paramstr(1) = '-e' then BatchRevert(paramstr(2))
      else messagedlg('Invalid command line '+paramstr(1),mtError,[mbOk],0); exit; end;

end;

end.
