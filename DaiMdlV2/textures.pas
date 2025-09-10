//******************************************************************************
//
// Game project unit
// (c) 1999 Charles Hollemeesch
// Description: Texture loading and handling
//
//******************************************************************************
unit textures;

{$MODE Delphi}

interface
uses GL,pakfiles;
type TglTexture = record
     width,height : word;
     glindex : GLuint;
     end;
     TTextureResult = (TTRGB,TT256);
type TgroundTextureMap = array[0..3] of TglTexture;
{texture type with
 width,height : size of texture
 glindex : index of texture for glBindtexture
 }
procedure LoadToGltexture(filename : string;var atexture : TglTexture;mode : integer);
{load a texture with
      filename : name of bmp file of texture;
      atexture : an tgltexture var;
      mode : texturing mode GL_LINEAR for standard results and GL_NEAREST for non accelerated cards}
procedure LoadToGltextureAlpha(filename : string;var atexture : TglTexture;a : byte;mode : integer);
{same but with a constant alpha cannel value}
procedure LoadToGltexture4(filename : string;var atexture : TgroundTextureMap;mode : integer);
{same but splits a 512*512 to 4 256*256 textures}
procedure LoadToGltextureTransparent(filename : string;var atexture : TglTexture;mode : integer);
procedure LoadFontTexture(filename : string;var atexture : TglTexture;mode : integer);
//procedure LoadToGltextureAlphaLuminance(filename : string;var atexture : TglTexture;mode : integer);

procedure InitGlTextureLoader;
procedure FreeGlTextureLoader;

procedure LoadTgaFromPak(filename : string;var atexture : Tgltexture;mode : integer);
procedure LoadWalFromPak(filename : string;var atexture : TglTexture;Mode : integer);

procedure BillboardLoadTgaFromPak(filename : string;var atexture : tgltexture;mode : integer);
procedure MediumAlphaTgaFromPak(filename : string;var atexture : tgltexture;mode : integer);
procedure AlphaTgaFromPak(filename : string;var atexture : tgltexture;alpha : byte;mode : integer);
procedure GrayLoadTgaFromPak(filename : string;var atexture : tgltexture;mode : integer);

implementation
uses FastBMP,GLU,dialogs,sysutils,daiwals;
type Trawbuff = array[0..512*512*4] of byte;
     pbyte = ^byte;
var init : boolean;
    rawbuff : ^Trawbuff;
    texfile : Tfastbmp;

function checksize(i : integer) : boolean;
begin
if (i = 2)or(i=4)or(i=8)or(i=16)or(i=32)or(i=64)or(i=128)or(i=256)or(i=512) then result := true
else result := false;
end;

//*********************************************
//readtga returns a pointer to the raw tga data
//*********************************************
function readtga(filename : string;var width,height,bits : integer;texresult : ttextureresult) : pbyte;
type Tpalette = array[0..255,0..2] of byte;
var
    atype : array [0..3] of byte;
    info : array [0..6] of byte;
    s : file;
    pakoffset,paksize,compsize,comptype : longint;
    palette : ^Tpalette;
    temp    : pbyte;
    i,j,k,l : integer;
begin
pakoffset := 0;
if not fileexists(filename) then
   begin
   if ExtractFile(filename,'c:\daitemp.tga') <> OK then begin
                                                     result := nil;
                                                     exit;
                                                     end;
   assignfile(s,'c:\daitemp.tga');
   end else assignfile(s,filename);
reset(s,1);
if pakoffset < 0 then begin result := nil; exit; end;
blockread(s,atype,3);
seek(s,12+pakoffset);
blockread(s,info,6);

  Width := info[0] + info[1] * 256;
  Height := info[2] + info[3] * 256;
  Bits := info[4];

  //sould check if dimension is power of 2
  // and we are loading a  supported format
if not (checksize(width) and checksize(height)) then begin result := nil; closefile(s); exit; end;
result := nil;
//those damn compressed tga's
if filesize(s) < (width*height*(bits div 8)+24) then begin closefile(s); exit; end;
if bits = 24 then
  begin
  getmem(result,width*height*3);
  blockread(s,result^,width*height*3);
  closefile(s);
  exit;
  end;
if bits = 32 then
  begin
  getmem(result,width*height*4);
  blockread(s,result^,width*height*4);
  closefile(s);
  exit;
  end;
if bits = 8 then
  begin
  if texresult = TT256 then
  begin
       getmem(result,width*height);
       //skip the palette wich is 256*3 bytes long
       //we are interpreting the data as transparent map so colors anre unimportant
       seek(s,filepos(s)+768);
       blockread(s,result^,width*height);
       bits := 8;
  end else
  begin
       new(palette);
       blockread(s,palette[0,0],768);
       getmem(temp,width*height);
       getmem(result,width*height*3);
       blockread(s,temp^,width*height);
       //convert the palette to an rgb texture
       for i := 0 to width-1 do
           for j := 0 to height-1 do
               begin
               k := (i+j*width);
               l := (i+j*width)*3;
               move(palette[pbyte(integer(temp)+k)^,0],pbyte(integer(result)+l)^,3);
               end;
       bits := 24;        
       freemem(temp);
       dispose(palette);
  end;
  exit;
  end;
  closefile(s);
end;

procedure LoadTgaFromPak(filename : string;var atexture : tgltexture;mode : integer);
type
    trawbuff = array[0..512*512*4] of byte;
var
    imageData : pbyte;
    imageWidth, imageHeight : integer;
    imageBits : integer;
    i,j,k : longint;
    temp : byte;
    rawbuff  : ^Trawbuff;
begin
  //atexture.glindex := -1;
  imagedata := readtga(filename,imagewidth,imageheight,imagebits,TTRGB);
  if (imagedata = nil) then
                     begin
                     fillchar(atexture,0,sizeof(atexture));
                     exit;
                     end;


  new(rawbuff);
  if (imagebits = 24) or (imagebits = 8) then
  begin
  for i:=0 to imagewidth-1 do //swap blue with red to go from bgr to rgb
   for j:=0 to imageheight-1 do
    begin
      k := (i+j*imagewidth)*3;
      move(pbyte(pointer(cardinal(imagedata)+(((imageheight-1-j)*imagewidth)+i)*3))^,rawbuff^[k],3);
      Temp:=rawbuff^[k];
      rawbuff^[k]:=rawbuff^[k+2];
      rawbuff^[k+2]:=Temp;
    end;
  end else
  if imagebits=32 then
  for i:=0 to imagewidth-1 do //swap blue with red to go from bgr to rgb
   for j:=0 to imageheight-1 do
    begin
      k := (i+j*imagewidth)*4;
      move(pbyte(pointer(cardinal(imagedata)+(((imageheight-1-j)*imagewidth)+i)*4))^,rawbuff^[k],4);
      Temp:=rawbuff^[k];
      rawbuff^[k]:=rawbuff^[k+2];
      rawbuff^[k+2]:=Temp;
    end;

glGenTextures(1,@atexture.Glindex);
atexture.width := imageWidth;
atexture.height := imageHeight;
glBindtexture(GL_TEXTURE_2D,atexture.glindex);
glPixelStorei(GL_UNPACK_ALIGNMENT, 1);
if (mode = gl_CLAMP) or (mode = GL_CLAMP_TO_EDGE) then
   begin
   glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, mode);
   glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, mode);
   mode := GL_LINEAR;
   end;
glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, Mode);
glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, Mode);
if (imagebits = 24) or (imagebits = 8) then
   glTexImage2D(GL_TEXTURE_2D, 0, 3, imageWidth, imageHeight, 0, GL_RGB,GL_UNSIGNED_BYTE, rawbuff^)
else if imagebits = 32 then
   glTexImage2D(GL_TEXTURE_2D, 0, 4, imageWidth, imageHeight, 0, GL_RGBA,GL_UNSIGNED_BYTE, rawbuff^);
{ buffer.setsize(imagewidth,imageheight);
 move(imagedata^,buffer.pixels[0,0],imagewidth*imageheight*3);
 for i := 0 to imagewidth-1 do
     for j := 0 to imageheight-1 do
         begin
         move(rawbuff[(i+j*imagewidth)*3],buffer.pixels[j,i],3);
         end;
buffer.draw(form1.canvas.handle,0,0); }

dispose(rawbuff);
freemem(imagedata);


end;

procedure LoadWalFromPak(filename : string;var atexture : tgltexture;mode : integer);
var
    imageData : pWal;
    Width, Height : integer;
begin
  atexture.glindex := -1;   
  imagedata := Loadwal(filename,width,height);
  if imagedata = nil then exit;

glGenTextures(1,@atexture.Glindex);
atexture.width := Width;
atexture.height := Height;
glBindtexture(GL_TEXTURE_2D,atexture.glindex);
glPixelStorei(GL_UNPACK_ALIGNMENT, 1);
glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, Mode);
glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, Mode);
glTexImage2D(GL_TEXTURE_2D, 0, 3, Width, Height, 0, GL_RGB,GL_UNSIGNED_BYTE, imagedata^);
freemem(imagedata);
end;

procedure GrayLoadTgaFromPak(filename : string;var atexture : tgltexture;mode : integer);
type
    trawbuff = array[0..512*512*3] of byte;
var
    imageData : pbyte;
    imageWidth, imageHeight : integer;
    imageBits : integer;
    i,j,k : longint;
    temp : byte;
    rawbuff  : ^Trawbuff;
begin

  imagedata := readtga(filename,imagewidth,imageheight,imagebits,TT256);
  if (imagedata = nil) or (imagebits <> 8) then
                     begin
                     fillchar(atexture,0,sizeof(atexture));
                     exit;
                     end;

new(rawbuff);
move(imagedata^,rawbuff^,imagewidth*imageheight);
   for i:=0 to imagewidth-1 do //swap blue with red to go from bgr to rgb
   for j:=0 to imageheight-1 do
    begin
//    k := (i+j*imagewidth)*3;
//    move(pbyte(pointer(cardinal(imagedata)+(((imageheight-1-j)*imagewidth)+i)*3))^,rawbuff^[k],3);

      k := (i+j*imagewidth)*2;
      rawbuff^[k] := pbyte(pointer(cardinal(imagedata)+(((imageheight-1-j)*imagewidth)+i)))^;
      rawbuff^[k+1] := rawbuff^[k];
      rawbuff^[k+2] := rawbuff^[k];
      rawbuff^[k+3] := rawbuff^[k];
    end;
   glGenTextures(1,@atexture.Glindex);
   glBindtexture(GL_TEXTURE_2D,atexture.glindex);
   glPixelStorei(GL_UNPACK_ALIGNMENT, 1);
   glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
   glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
   glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, Mode);
   glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, Mode);
   glTexImage2D(GL_TEXTURE_2D, 0, 2, imagewidth,imageheight, 0, GL_LUMINANCE_ALPHA, GL_UNSIGNED_BYTE,rawbuff^);

{ buffer.setsize(imagewidth,imageheight);
 move(imagedata^,buffer.pixels[0,0],imagewidth*imageheight*3);
 for i := 0 to imagewidth-1 do
     for j := 0 to imageheight-1 do
         begin
         move(rawbuff[(i+j*imagewidth)*3],buffer.pixels[j,i],3);
         end;
buffer.draw(form1.canvas.handle,0,0); }
dispose(rawbuff);

freemem(imagedata);


end;

procedure BillboardLoadTgaFromPak(filename : string;var atexture : tgltexture;mode : integer);
type
    trawbuff = array[0..512*512*4] of byte;
var
    imageData : pbyte;
    imageWidth, imageHeight : integer;
    imageBits : integer;
    i,j,k : longint;
    temp : byte;
    rawbuff  : ^Trawbuff;
begin

  imagedata := readtga(filename,imagewidth,imageheight,imagebits,TTRGB);
  if (imagedata = nil) or (imagebits <> 24) then
                     begin
                     fillchar(atexture,0,sizeof(atexture));
                     exit;
                     end;

  new(rawbuff);
  for i:=0 to imagewidth-1 do //swap blue with red to go from bgr to rgb
   for j:=0 to imageheight-1 do
    begin
      k := (i+j*imagewidth)*4;
      move(pbyte(pointer(cardinal(imagedata)+(((imageheight-1-j)*imagewidth)+i)*3))^,rawbuff^[k],3);
      Temp:=rawbuff^[k];
      rawbuff^[k]:=rawbuff^[k+2];
      rawbuff^[k+2]:=Temp;
      if (rawbuff^[k] = 128) and (rawbuff^[k+1] = 128 ) and (rawbuff^[k+2] = 128) then
                      rawbuff^[k+3] := 0 else rawbuff^[k+3] := 255;
    end;
glGenTextures(1,@atexture.Glindex);
atexture.width := imageWidth;
atexture.height := imageHeight;
glBindtexture(GL_TEXTURE_2D,atexture.glindex);
glPixelStorei(GL_UNPACK_ALIGNMENT, 1);
glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, Mode);
glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, Mode);
glTexImage2D(GL_TEXTURE_2D, 0, GL_RGB5_A1, imageWidth, imageHeight, 0, GL_RGBA,GL_UNSIGNED_BYTE, rawbuff^);
{ buffer.setsize(imagewidth,imageheight);
 move(imagedata^,buffer.pixels[0,0],imagewidth*imageheight*3);
 for i := 0 to imagewidth-1 do
     for j := 0 to imageheight-1 do
         begin
         move(rawbuff[(i+j*imagewidth)*3],buffer.pixels[j,i],3);
         end;
buffer.draw(form1.canvas.handle,0,0); }

dispose(rawbuff);
freemem(imagedata);
end;

procedure MediumAlphaTgaFromPak(filename : string;var atexture : tgltexture;mode : integer);
type
    trawbuff = array[0..512*512*4] of byte;
var
    imageData : pbyte;
    imageWidth, imageHeight : integer;
    imageBits : integer;
    i,j,k : longint;
    temp : byte;
    rawbuff  : ^Trawbuff;
begin

  imagedata := readtga(filename,imagewidth,imageheight,imagebits,TTRGB);
  if (imagedata = nil) or (imagebits <> 24) then
                     begin
                     fillchar(atexture,0,sizeof(atexture));
                     exit;
                     end;

  new(rawbuff);
  fillchar(rawbuff^,sizeof(rawbuff^),128);
  for i:=0 to imagewidth-1 do //swap blue with red to go from bgr to rgb
   for j:=0 to imageheight-1 do
    begin
      k := (i+j*imagewidth)*4;
      move(pbyte(pointer(cardinal(imagedata)+(((imageheight-1-j)*imagewidth)+i)*3))^,rawbuff^[k],3);
      Temp:=rawbuff^[k];
      rawbuff^[k]:=rawbuff^[k+2];
      rawbuff^[k+2]:=Temp;
      rawbuff^[k+3]:= (rawbuff^[k] + rawbuff^[k+1] + rawbuff^[k+2]) div 3
      //rawbuff^[k+3] := 255;
    end;
glGenTextures(1,@atexture.Glindex);
atexture.width := imageWidth;
atexture.height := imageHeight;
glBindtexture(GL_TEXTURE_2D,atexture.glindex);
glPixelStorei(GL_UNPACK_ALIGNMENT, 1);
glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, Mode);
glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, Mode);
glTexImage2D(GL_TEXTURE_2D, 0, 4, imageWidth, imageHeight, 0, GL_RGBA,GL_UNSIGNED_BYTE, rawbuff^);
dispose(rawbuff);
freemem(imagedata);
end;

procedure AlphaTgaFromPak(filename : string;var atexture : tgltexture;alpha : byte;mode : integer);
type
    trawbuff = array[0..512*512*4] of byte;
var
    imageData : pbyte;
    imageWidth, imageHeight : integer;
    imageBits : integer;
    i,j,k : longint;
    temp : byte;
    rawbuff  : ^Trawbuff;
begin

  imagedata := readtga(filename,imagewidth,imageheight,imagebits,TTRGB);
  if (imagedata = nil) or (imagebits <> 24) then
                     begin
                     fillchar(atexture,0,sizeof(atexture));
                     exit;
                     end;

  new(rawbuff);
  fillchar(rawbuff^,sizeof(rawbuff^),128);
  for i:=0 to imagewidth-1 do //swap blue with red to go from bgr to rgb
   for j:=0 to imageheight-1 do
    begin
      k := (i+j*imagewidth)*4;
      move(pbyte(pointer(cardinal(imagedata)+(((imageheight-1-j)*imagewidth)+i)*3))^,rawbuff^[k],3);
      Temp:=rawbuff^[k];
      rawbuff^[k]:=rawbuff^[k+2];
      rawbuff^[k+2]:=Temp;
      rawbuff^[k+3]:= alpha;
      //rawbuff^[k+3] := 255;
    end;
glGenTextures(1,@atexture.Glindex);
atexture.width := imageWidth;
atexture.height := imageHeight;
glBindtexture(GL_TEXTURE_2D,atexture.glindex);
glPixelStorei(GL_UNPACK_ALIGNMENT, 1);
glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, Mode);
glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, Mode);
glTexImage2D(GL_TEXTURE_2D, 0, 4, imageWidth, imageHeight, 0, GL_RGBA,GL_UNSIGNED_BYTE, rawbuff^);
dispose(rawbuff);
freemem(imagedata);
end;


procedure InitGlTextureLoader;
begin
new(rawbuff);
texfile := tfastbmp.create;
init := true;
end;

procedure FreeGlTextureLoader;
begin
dispose(rawbuff);
texfile.free;
init := false;
end;

procedure LoadToGltexture(filename : string;var atexture : TglTexture;mode : integer);
var wasinit : boolean;
    i,j,k : longint;
    temp : byte;
begin
  // check for init if none then init
  if init = false then
          begin
          InitGltextureLoader;
          wasinit := false;
          end else wasinit := true;

  texfile.loadfromfile(filename);
 if (texfile.width <= 256) and (texfile.height <= 256) then
 begin
   atexture.width := texfile.width;
   atexture.height := texfile.height;
   //move(texfile.pixels[0,0],rawbuff^[0],texfile.width*texfile.height*3);
   for i:=0 to texfile.width-1 do //swap blue with red to go from bgr to rgb
   for j:=0 to texfile.height-1 do
    begin
      k := (i+j*texfile.width)*3;
      move(texfile.pixels[j,i],rawbuff^[k],3);
      Temp:=rawbuff^[k];
      rawbuff^[k]:=rawbuff^[k+2];
      rawbuff^[k+2]:=Temp;
    end;
   glGenTextures(1,@atexture.Glindex);
   glBindtexture(GL_TEXTURE_2D,atexture.glindex);
   glPixelStorei(GL_UNPACK_ALIGNMENT, 1);
   glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
   glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
   glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, Mode);
   glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, Mode);
   glTexImage2D(GL_TEXTURE_2D, 0, 3, texfile.width,texfile.height, 0, GL_RGB, GL_UNSIGNED_BYTE,rawbuff^);
  end;
  // if wasn't init before exec of proc then free now
  //http://trant.sgi.com/opengl/docs/man_pages/hardcopy/GL/html/gl/teximage2d.html
  if wasinit = false then FreeGlTextureLoader;
  //glTexSubImage2D
end;

procedure LoadToGltextureAlpha(filename : string;var atexture : TglTexture;a : byte;mode : integer);
var wasinit : boolean;
    i,j,k : longint;
    temp : byte;
begin
  // check for init if none then init
  if init = false then
          begin
          InitGltextureLoader;
          wasinit := false;
          end else wasinit := true;

  texfile.loadfromfile(filename);
  if (texfile.width <= 256) and (texfile.height <= 256) then
  begin
   atexture.width := texfile.width;
   atexture.height := texfile.height;
   for i := 0 to texfile.width-1 do
     for j := 0 to texfile.height-1 do
     begin
        k := (i+j*texfile.width)*4;
        move(texfile.pixels[j,i],rawbuff^[k],3);
        Temp:=rawbuff^[k];
        rawbuff^[k]:=rawbuff^[k+2];
        rawbuff^[k+2]:=Temp;
        rawbuff^[k+3]:= a;
      end;
   glGenTextures(1,@atexture.Glindex);
   glBindtexture(GL_TEXTURE_2D,atexture.glindex);
   glPixelStorei(GL_UNPACK_ALIGNMENT, 1);
   glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
   glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
   glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, Mode);
   glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, Mode);
   glTexImage2D(GL_TEXTURE_2D, 0, 4, texfile.width,texfile.height, 0, GL_RGBA, GL_UNSIGNED_BYTE,rawbuff^);
  end;
  // if wasn't init before exec of proc then free now
  if wasinit = false then FreeGlTextureLoader;
end;

procedure LoadToGltexture4(filename : string;var atexture : TgroundTextureMap;mode : integer);
var wasinit : boolean;
   // i,j,i1,j1,k : longint;
   // temp : byte;
   // xofs,yofs,temptex : longint;
    counter : integer;
begin
  // check for init if none then init
  //xofs := 0;
  //yofs := 0;
  if init = false then
          begin
          InitGltextureLoader;
          wasinit := false;
          end else wasinit := true;
 for counter := 0 to 3 do
     if fileexists(filename+inttostr(counter)+'.bmp') then
     Loadtogltexture(filename+inttostr(counter)+'.bmp',atexture[counter],mode);

{
  texfile.loadfromfile(filename);
 if (texfile.width = 512) and (texfile.height = 512) then
 begin
   for counter := 0 to 3 do
   begin
     case counter of
          0 : begin xofs := 0; yofs := 0; end;
          1 : begin xofs := 255; yofs := 0; end;
          2 : begin xofs := 255; yofs := 255; end;
          3 : begin xofs := 0; yofs := 255; end;
      end; //case    
     atexture[counter].width := 256;
     atexture[counter].height := 256;
     for i:=0 to 255 do //swap blue with red to go from bgr to rgb
      for j:=0 to 255 do
      begin
      i1 := i + xofs;
      j1 := j + yofs;
      k := (i+j*256)*3;
      move(texfile.pixels[j1,i1],rawbuff^[k],3);
      Temp:=rawbuff^[k];
      rawbuff^[k]:=rawbuff^[k+2];
      rawbuff^[k+2]:=Temp;
     end;
    // glGenTextures(1,@atexture[counter].Glindex);
     glGenTextures(1,@temptex);
     atexture[counter].glindex := temptex;

     glBindtexture(GL_TEXTURE_2D,atexture[counter].glindex);
     glPixelStorei(GL_UNPACK_ALIGNMENT, 1);
     glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP);
     glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP);
     glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, Mode);
     glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, Mode);
      glTexImage2D(GL_TEXTURE_2D, 0, 3, atexture[counter].width,atexture[counter].height, 0, GL_RGB, GL_UNSIGNED_BYTE,rawbuff^);

   end;//for counter
  end;  }
  // if wasn't init before exec of proc then free now
  if wasinit = false then FreeGlTextureLoader;
end;


procedure LoadToGltextureTransparent(filename : string;var atexture : TglTexture;mode : integer);
var wasinit : boolean;
    i,j,k : longint;
    temp : byte;
begin
  // check for init if none then init
  if init = false then
          begin
          InitGltextureLoader;
          wasinit := false;
          end else wasinit := true;

  texfile.loadfromfile(filename);
  if (texfile.width <= 256) and (texfile.height <= 256) then
  begin
   atexture.width := texfile.width;
   atexture.height := texfile.height;
   for i := 0 to texfile.width-1 do
     for j := 0 to texfile.height-1 do
     begin
        k := (i+j*texfile.width)*4;
        move(texfile.pixels[j,i],rawbuff^[k],3);
        Temp:=rawbuff^[k];
        rawbuff^[k]:=rawbuff^[k+2];
        rawbuff^[k+2]:=Temp;
        if (rawbuff^[k]=128) and (rawbuff^[k+1]=128) and (rawbuff^[k+2]=128)
        then
        rawbuff^[k+3]:= 0
        else rawbuff^[k+3]:= 255
        end;
   glGenTextures(1,@atexture.Glindex);
   glBindtexture(GL_TEXTURE_2D,atexture.glindex);
   glPixelStorei(GL_UNPACK_ALIGNMENT, 1);
   glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
   glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
   glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, Mode);
   glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, Mode);
   glTexImage2D(GL_TEXTURE_2D, 0, GL_RGB5_A1, texfile.width,texfile.height, 0, GL_RGBA, GL_UNSIGNED_BYTE,rawbuff^);
  end;
  // if wasn't init before exec of proc then free now
  if wasinit = false then FreeGlTextureLoader;
end;

procedure LoadFontTexture(filename : string;var atexture : TglTexture;mode : integer);
var wasinit : boolean;
    i,j,k : longint;
    temp : byte;
begin
  // check for init if none then init
  if init = false then
          begin
          InitGltextureLoader;
          wasinit := false;
          end else wasinit := true;

  texfile.loadfromfile(filename);
  if (texfile.width <= 256) and (texfile.height <= 256) then
  begin
   atexture.width := texfile.width;
   atexture.height := texfile.height;
   for i := 0 to texfile.width-1 do
     for j := 0 to texfile.height-1 do
     begin
        k := (i*texfile.height+j)*4;
        move(texfile.pixels[i,j],rawbuff^[k],3);
        Temp:=rawbuff^[k];
        rawbuff^[k]:=rawbuff^[k+2];
        rawbuff^[k+2]:=Temp;
        if (rawbuff^[k]=128) and (rawbuff^[k+1]=128) and (rawbuff^[k+2]=128)
        then
        rawbuff^[k+3]:= 0
        else rawbuff^[k+3]:= 255
        end;
   glGenTextures(1,@atexture.Glindex);
   glBindtexture(GL_TEXTURE_2D,atexture.glindex);
   glPixelStorei(GL_UNPACK_ALIGNMENT, 1);
   glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
   glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
   glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, Mode);
   glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, Mode);
   glTexImage2D(GL_TEXTURE_2D, 0, 4, texfile.width,texfile.height, 0, GL_RGBA, GL_UNSIGNED_BYTE,rawbuff^);
  end;
  // if wasn't init before exec of proc then free now
  if wasinit = false then FreeGlTextureLoader;
end;
{
procedure LoadToGltextureAlphaLuminance(filename : string;var atexture : TglTexture;mode : integer);
var texfile : TFast256;
    rawbuff : ^Trawbuff;
    i,j,k : integer;
begin
  // check for init if none then init
  new(rawbuff);
  texfile := tfast256.create;
  texfile.loadfromfile(filename,CmGray);
 if (texfile.width <= 256) and (texfile.height <= 256) then
 begin
   atexture.width := texfile.width;
   atexture.height := texfile.height;
   move(texfile.pixels[0,0],rawbuff^[0],texfile.width*texfile.height);
   for i:=0 to texfile.width-1 do //swap blue with red to go from bgr to rgb
   for j:=0 to texfile.height-1 do
    begin
      k := (i+(texfile.width*j))*2;
      rawbuff^[k] := texfile.pixels[j,i];
      rawbuff^[k+1] := rawbuff^[k];
      rawbuff^[k+2] := rawbuff^[k];
      rawbuff^[k+3] := rawbuff^[k];
    end;
   glGenTextures(1,@atexture.Glindex);
   glBindtexture(GL_TEXTURE_2D,atexture.glindex);
   glPixelStorei(GL_UNPACK_ALIGNMENT, 1);
   glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
   glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
   glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, Mode);
   glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, Mode);
   glTexImage2D(GL_TEXTURE_2D, 0, 2, texfile.width,texfile.height, 0, GL_LUMINANCE_ALPHA, GL_UNSIGNED_BYTE,rawbuff^);
  end;
  // if wasn't init before exec of proc then free now
 Dispose(rawbuff);
 texfile.free
end;}


end.
