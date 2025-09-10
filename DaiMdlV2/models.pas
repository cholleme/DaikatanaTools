unit models;

{$MODE Delphi}

interface
uses classes,CommDlg,controls,sysutils,GL,dialogs;
const maxtriangles = 4096;
      maxvertices  = 2048;
      maxtexco     = 2048;
      maxframes    = 512;
      maxskins     = 32;
Type Tvec3 = record
	x,y,z : Single;
  end;
 tmdlheader = packed record
     magic : array [0..3] of char;   // must be idp2
     version : integer;  // quake2 = version 8
     org_x : single; //origin
     org_y : single;
     org_z : single;
     //nono2      : integer;
     frameSize : integer;  //size in byes of one frame
     numSkins : integer;   // number of xxx
     numVertices : integer;
     numTexCos : integer;
     numTriangles : integer;
     numGlCommands : integer;
     numFrames : integer;
     numSurfaces : integer; // byte ofset for xxx
     offsetSkins : integer;
     offsetTexcos : integer;
     offsetTriangles : integer;
     offsetFrames : integer;
     offsetGlCommands: integer;
     offsetSurfaces : integer;
     offsetEnd : integer;
     end;

TVector3d = record
   x,y,z : integer;
   end;

TTriangleVertex = packed record
   x,y,z : byte;
   lightNormalIndex : byte;
   end;

Tframe = packed record
   scalex,scaley,scalez : single;  // scale to decode vertexes
   translatex,translatey,translatez : single;// translation to decode vertexes
   name : array [0..15] of char; // name of frame
   vertices : array[0..0]of TtriangleVertex;
   end;

 pframe = ^Tframe;

//Version2 model defs

TTriangleVertex2 = packed record
   vert : integer;
   lightNormalIndex : byte;
   end;

Tframe2 = packed record
   scalex,scaley,scalez : single;  // scale to decode vertexes
   translatex,translatey,translatez : single;// translation to decode vertexes
   name : array [0..15] of char; // name of frame
   vertices : array[0..0]of TtriangleVertex2;
   end;

 pframe2 = ^Tframe2;

TTriangle = packed record
   extra : smallint;
   num_uvframes : smallint;
   vertexIndices : array[0..2] of smallint;
   textureIndices: array[0..2] of smallint;
   end;
   
TTextureCoordinate = record
   s,t : smallint;
   end;

{ TglCommandVertex = record
   s, t : single;
   vertexIndex : integer;
end;}

 TskinName = array[0..63] of char;
 TskinNames = array[0..0] of TSkinName;
 TModelInfo = record
     version : integer;
     frameSize : integer;  //size in byes of one frame
     numSkins : integer;   // number of xxx
     //numVertices : integer;
     numTexCos : integer;
     numTriangles : integer;
     numGlCommands : integer;
     numFrames : integer;
     skinwidth,skinheight : integer;
     skinNames : ^TskinNames;
     end;

 Tmodel = record
  Info         : TModelInfo;
  Frames       : ^Tframe;
  SkinsGlIndex : array[0..32] of integer;
  GlCmds       : ^Longint;
  Texcos       : ^TTextureCoordinate;
  Triangles    : ^TTriangle;
  //frames     : array [0..maxframes] of Tframe;
  //Triangles  : array[0..maxtriangles]       of TTriangle;
  //TextureCoos: array[0..maxtexco]          of TTextureCoordinate;
  end;
 Pmodel = ^tmodel;

var
//  mdlObject : Tmdl;
  modelinit : boolean = false;
  frame,numframes,listoffset : integer;
  shadevector : array[0..2] of single;

procedure loadmodel(mdlObject : pmodel;filename : string);
procedure drawmodel(mdlObject : pmodel;aframe : integer);
procedure freemodel(mdlObject : pmodel);
procedure drawmodelnormal(mdlObject : pmodel;aframe : integer);
procedure drawmodelshadow(mdlObject : pmodel;aframe : integer);
procedure drawskin(mdlObject : pmodel;aframe : integer);

implementation

uses normals,modelu;

function DecodeVertex(int : integer) : TVector3d;
begin
result.z := int and $7FF;
result.y := (int and $1FF800) shr 11;
result.x := (int and $FFE00000) shr 21;
end;

procedure dumpheader(const header : TMdlHeader);
begin
with header do
     begin
     std_write('magic: '+magic);
     std_write('version: '+inttostr(version));
     std_write('origin: '+floattostr(org_x)+floattostr(org_y)+floattostr(org_z));
     std_write('frameSize: '+inttostr(frameSize));
     std_write('numSkins: '+inttostr(numSkins));
     std_write('numVertices: '+inttostr(numVertices));
     std_write('numTexCoords: '+inttostr(numTexCos));
     std_write('numTriangles: '+inttostr(numTriangles));
     std_write('numGlCommands: '+inttostr(numGlCommands));
     std_write('numFrames: '+inttostr(numFrames));
     std_write('numSurfaces: '+inttostr(numSurfaces));
     std_write('offsetSkins: '+inttostr(offsetSkins));
     std_write('offsetTexCos: '+inttostr(offsetTexCos));
     std_write('offsetTriangles: '+inttostr(offsetTriangles));
     std_write('offsetFrames: '+inttostr(offsetFrames));
     std_write('offsetGlCommands: '+inttostr(offsetGlCommands));
     std_write('offsetSurfaces: '+inttostr(offsetSurfaces));
     std_write('offsetEnd: '+inttostr(offsetEnd));
     //std_write('offsetExtra2: '+inttostr(offsetExtra2));
     end;

end;

const skinssizes : array [1..6] of integer = (16,32,64,128,256,256);

const supportedversions = [1,2];

procedure LoadModel(mdlObject : pmodel;filename : string);
var
   //mdlfile : Tfilestream;
   mdlfile : File;
   Header  : TmdlHeader;
   Skins   : array[0..9] of Tskinname;
   Frames2 : pFrame2;
   i       : integer;
   point   : TVector3d;
begin
if fileexists(filename) = false then exit;

try
//mdlfile := TFileStream.Create(filename, fmOpenRead);
assignfile(mdlfile,filename);
reset(mdlfile,1);

with mdlobject^ do
begin
GlCmds := nil;
Frames := nil;
TexCos := nil;
triangles := nil;
Blockread(mdlfile,Header, Sizeof(header));

if not(Header.Version in supportedversions) then
   begin
   messagedlg('Wrong model version: '+inttostr(Header.Version),mterror,[mbok],0);
   GlCmds := nil;
   Frames := nil;
   TexCos := nil;
   triangles := nil;
   exit;
   end;

{if Header.Version = 2 then
     if messagedlg('This is a version 2 model and will not draw correctly.'+chr(13)+
                 'It may cause acces violations!'+chr(13)+
                 'Continue?',mtwarning,[mbok,mbCancel],0) = mrCancel then begin
                                                                          exit;

                                                                          end;
}
std_write('-==Warning version 2 model==-');

//Dump the header

// Load Gl commands
Getmem(GlCmds,(Header.NumGlCommands+1) * sizeof(longint));
fillchar(GlCmds^,(Header.NumGlCommands+1) * sizeof(longint),0);
seek(mdlfile,Header.OffsetGlCommands);
blockread(mdlfile,glcmds^,sizeof(longint) * header.numglcommands);

// Load the Frames
Getmem(Frames,Header.NumFrames * Header.Framesize);
seek(mdlfile,Header.OffsetFrames);
blockread(mdlfile,Frames^,Header.Framesize * Header.NumFrames);

//Load the triangles
Getmem(Triangles,Header.NumTriangles * sizeof(TTriangle));
seek(mdlfile,Header.OffsetTriangles);
blockread(mdlfile,Triangles^,Header.NumTriangles * sizeof(TTriangle));

//Load the texco's
Getmem(Texcos,Header.NumTexcos * sizeof(TTextureCoordinate));
seek(mdlfile,Header.OffsetTexcos);
blockread(mdlfile,Texcos^,Header.NumTexCos * sizeof(TTextureCoordinate));
dumpheader(header);

//Load the skins
seek(mdlfile,Header.OffsetSkins);
getmem(info.skinNames,header.numskins*64);
blockread(mdlfile,info.skinNames^,header.numskins*64);


 info.frameSize     := header.framesize;  //size in byes of one frame
 info.numSkins      := header.numSkins;   // number of xxx
 info.numGlCommands := header.numGlCommands;
 info.numFrames     := header.numFrames;
 info.numtexcos     := Header.NumTexCos;
 info.numtriangles  := Header.NumTriangles;
 info.version       := Header.Version;
end; // with

finally

closefile(mdlfile);
modelinit := true;
 end;
end;

procedure error(msg : string);
begin
messagedlg(msg,mterror,[mbok],0);
end;

function subvector(v1,v2 : Tvec3) : Tvec3;
begin
result.x := v1.x-v2.x;
result.y := v1.y-v2.y;
result.z := v1.z-v2.z;
end;

procedure vector2angle(v : Tvec3;var angle,roll : integer);
var forwardt : glfloat;
begin
if v.x >= 0 then
   angle := round( ArcTan(-v.z/v.x) * 180 / pi ) else
   angle := round( ArcTan(-v.z/v.x) * 180 / pi )+180;
angle := angle + 90;
if angle > 360 then angle := angle - 360;
if angle < 0   then angle := angle + 360;
// same sys but use pytagoras for the cos(Q) because of the rotation with T
roll := round( ArcTan(v.y / sqrt( sqr(v.x) + sqr(v.z))  ) * 180 / pi );
roll := -roll;
if roll > 360 then roll := roll - 360;
if roll < 0   then roll := roll + 360;
end;

procedure drawmodel(mdlObject : pmodel;aframe : integer);
const nextitem = 4;
var
command       : ^Longint; // = dword i hope
frameinfo     : pframe;
frameinfo2     : pframe2;
i,vert_index,test : integer;
num_verts         : longint;
temp             : pointer;
normal : tvec3;
s,t,shade        : GlFloat;
point : array[0..2] of single;
vertex : TVector3d;
begin
//glPolygonMode(GL_FRONT_AND_BACK,GL_FILL);
glEnable(GL_TEXTURE_2d);

if mdlObject.Info.Version = 2 then
   begin
   Frameinfo2 := pframe2(pointer(integer(mdlobject.frames) + mdlobject.Info.framesize*aframe))
   end
   else
   begin
   Frameinfo := pframe(pointer(integer(mdlobject.frames) + mdlobject.Info.framesize*aframe));
   end;

command := pointer(mdlobject.glcmds);
glpushmatrix;
test := 0;
while true do
 begin
    inc(test);
    num_verts := command^;
    inc(cardinal(command),nextitem);


    //what are these used for?
    //skin indexes??
    glbindtexture(gl_texture_2d,MainModel.SkinsGlIndex[command^]);
    inc(cardinal(command),nextitem);
    inc(cardinal(command),nextitem);

    if num_verts = 0 then break;
    if num_verts < 0 then
    begin
    // triangle strip
    num_verts := -num_verts;
    glBegin(GL_TRIANGLE_FAN);
    end else
    begin
    // triangle fan
    glBegin(GL_TRIANGLE_STRIP);
    end;

    for i := 0 to num_verts-1 do
        begin
        // get vertex index and data
        vert_index := command^;
        inc(cardinal(command),nextitem);// next 4 bytes integer

        // get texture coos
        s := glfloat(pointer(command^));
        inc(cardinal(command),nextitem);// next 4 bytes integer

        t := glfloat(pointer(command^));
        inc(cardinal(command),nextitem);// next 4 bytes integer


        // pump into opengl
        glTexCoord2f(s,t);
        if mdlObject.Info.Version = 1 then
           begin
                	point[0] := frameinfo.vertices[vert_index].x * frameinfo.scalex + frameinfo.translatex;
			point[1] := frameinfo.vertices[vert_index].y * frameinfo.scaley + frameinfo.translatey;
			point[2] := frameinfo.vertices[vert_index].z * frameinfo.scalez + frameinfo.translatez;
                        shade := VertexShade[frameinfo.vertices[vert_index].lightnormalindex];
                        glnormal3f(Vertexnormals[frameinfo.vertices[vert_index].lightnormalindex,1],
                                   Vertexnormals[frameinfo.vertices[vert_index].lightnormalindex,2],
                                   Vertexnormals[frameinfo.vertices[vert_index].lightnormalindex,0]);
           end
           else
           begin
                        vertex :=  DecodeVertex(frameinfo2.vertices[vert_index].vert);
                	point[0] := vertex.x * frameinfo2.scalex + frameinfo2.translatex;
			point[1] := vertex.y * frameinfo2.scaley + frameinfo2.translatey;
			point[2] := vertex.z * frameinfo2.scalez + frameinfo2.translatez;
                        shade := VertexShade[frameinfo2.vertices[vert_index].lightnormalindex];
                        glnormal3f(Vertexnormals[frameinfo2.vertices[vert_index].lightnormalindex,1],
                                   Vertexnormals[frameinfo2.vertices[vert_index].lightnormalindex,2],
                                   Vertexnormals[frameinfo2.vertices[vert_index].lightnormalindex,0]);
           end;
           glcolor3f(shade,shade,shade);
           glvertex3f(point[1],point[2],point[0]);
        end;
    glEnd;
 end;//while
glpopmatrix;
end;

procedure drawskin(mdlObject : pmodel;aframe : integer);
const nextitem = 4;
var
command       : ^Longint; // = dword i hope
frameinfo     : pframe;
i,vert_index,test : integer;
num_verts         : longint;
temp             : pointer;
normal : tvec3;
s,t,s2,t2,shade        : GlFloat;
point : array[0..2] of single;
begin
glPolygonMode(GL_FRONT_AND_BACK,GL_LINE);
glDisable(GL_CULL_FACE);
Frameinfo := pframe(pointer(integer(mdlobject.frames) + mdlobject.Info.framesize*aframe));
//frameinfo := mdlObject.Frames[aframe];
command := pointer(mdlobject.glcmds);
//won := 0;
glpushmatrix;
//glscalef(frameinfo.scaley,frameinfo.scalez,frameinfo.scalex);
//gltranslatef(frameinfo.translatey,frameinfo.translatez,frameinfo.translatex);

test := 0;
//inc(cardinal(command),nextitem*4);
s := 1;
t := 1;
while true do
 begin
    inc(test);
    num_verts := command^;
//    std_write('Verts: '+inttostr(num_verts));
    //break;
    inc(cardinal(command),nextitem);

    if num_verts = 0 then break;
    if num_verts < 0 then
    begin
    // triangle strip
    num_verts := -num_verts;
    glBegin(GL_LINE_LOOP);
    end else
    begin
    // triangle fan
    glBegin(GL_LINE_STRIP);
    end;

    for i := 0 to num_verts-1 do
        begin
        // get texture coos
        s := glfloat(pointer(command^));
        inc(cardinal(command),nextitem);// next 4 bytes integer

        t := glfloat(pointer(command^));
        inc(cardinal(command),nextitem);// next 4 bytes integer

        // get vertex index and data
        vert_index := command^;
        inc(cardinal(command),nextitem);// next 4 bytes integer
        shade := VertexShade[frameinfo.vertices[vert_index].lightnormalindex];

        // pump into opengl
        //glTexCoord2f(s,t);
        glcolor3f(shade,shade,shade);
                	point[0] := frameinfo.vertices[vert_index].x * frameinfo.scalex + frameinfo.translatex;
			point[1] := frameinfo.vertices[vert_index].y * frameinfo.scaley + frameinfo.translatey;
			point[2] := frameinfo.vertices[vert_index].z * frameinfo.scalez + frameinfo.translatez;

        //move(VertexNormals[frameinfo.vertices[vert_index].lightnormalindex],normal,sizeof(single)*3);
        //glnormal3f(normal.y,normal.z,normal.x);
        glvertex3f(s*20,t*20,0);
        //glvertex3f(point[1],point[2],point[0]);
        end;
        //glvertex3f(s*20,t*20,0);
    glEnd;
    inc(cardinal(command),nextitem);
    inc(cardinal(command),nextitem);
 end;//while
//std_write('Iter: '+inttostr(test));
{i := 1;
error(frameinfo.name+chr(13)+
floattostr(frameinfo.scalex)+' '+floattostr(frameinfo.scaley)+' '+floattostr(frameinfo.scalez)
+chr(13)+inttostr(frameinfo.vertices[i].x)+' '+inttostr(frameinfo.vertices[i].y)+' '+inttostr(frameinfo.vertices[i].z));}
//error(inttostr(won)+'/'+inttostr(mdlObject.Header.NumTriangles));
glpopmatrix;
glEnable(GL_CULL_FACE);
end;

procedure drawmodelshadow(mdlObject : pmodel;aframe : integer);
const nextitem = 4;
var
command       : ^Longint; // = dword i hope
frameinfo     : pframe;
num_verts,i,vert_index : integer;
temp             : pointer;
s,t,shade        : GlFloat;
point :          array[0..2] of single;
height,lheight : single;
begin
Frameinfo := pframe(pointer(integer(mdlobject.frames) + mdlobject.Info.framesize*aframe));
//frameinfo := mdlObject.Frames[aframe];
command := pointer(mdlobject.glcmds);
//won := 0;
glpushmatrix;
lheight := 3;
height := - lheight + 1.0;
//glscalef(frameinfo.scaley,frameinfo.scalez,frameinfo.scalex);
//gltranslatef(frameinfo.translatey,frameinfo.translatez,frameinfo.translatex);
while true do
 begin
    num_verts := command^;
    inc(cardinal(command),nextitem);

    if num_verts = 0 then break;
    if num_verts < 0 then
    begin
    // triangle strip
    num_verts := -num_verts;
    glBegin(GL_TRIANGLE_FAN);
    end else
    begin
    // triangle fan
    glBegin(GL_TRIANGLE_STRIP);
    end;

    for i := 0 to num_verts-1 do
        begin
        // get texture coos
        //s := glfloat(command^);
        //inc(cardinal(command),nextitem);// next 4 bytes integer

        //t := glfloat(command^);
        //inc(cardinal(command),nextitem);// next 4 bytes integer
        inc(cardinal(command),nextitem*2);


        // get vertex index and data
        vert_index := command^;
        inc(cardinal(command),nextitem);// next 4 bytes integer
        // pump into opengl
        		point[0] := frameinfo.vertices[vert_index].x * frameinfo.scalex + frameinfo.translatex;
			point[1] := frameinfo.vertices[vert_index].y * frameinfo.scaley + frameinfo.translatey;
			point[2] := frameinfo.vertices[vert_index].z * frameinfo.scalez + frameinfo.translatez;

			point[0] := point[0] - shadevector[0]*(point[2]+lheight);
			point[1] := point[1] - shadevector[1]*(point[2]+lheight);
			point[2] := height;
         //glTexCoord2f(s,t);
         //glcolor3f(1,1,1);
        glVertex3f(point[1],point[2],point[0]);
        {(frameinfo.vertices[vert_index].y * frameinfo.scaley) + frameinfo.translatey,
        (frameinfo.vertices[vert_index].z * frameinfo.scalez) + frameinfo.translatez,
        (frameinfo.vertices[vert_index].x * frameinfo.scalex) + frameinfo.translatex);}
        end;
    glEnd;
end;//while
{i := 1;
error(frameinfo.name+chr(13)+
floattostr(frameinfo.scalex)+' '+floattostr(frameinfo.scaley)+' '+floattostr(frameinfo.scalez)
+chr(13)+inttostr(frameinfo.vertices[i].x)+' '+inttostr(frameinfo.vertices[i].y)+' '+inttostr(frameinfo.vertices[i].z));}
//error(inttostr(won)+'/'+inttostr(mdlObject.Header.NumTriangles));
glpopmatrix;
end;

procedure freemodel(mdlObject : pmodel);
begin
modelinit := false;
freemem(mdlObject.Frames,mdlObject.Info.Framesize * mdlObject.Info.NumFrames);
freemem(mdlObject.GlCmds,mdlObject.Info.NumGlCommands * sizeof(longint));
freemem(mdlObject.Texcos);
freemem(mdlObject.Triangles);
end;




type tvect = array[0..2] of glfloat;

procedure crossprod(var dest : tvect;u : tvect;vx,vy,vz : glfloat);
begin
dest[0] := u[1]*vz-u[2]*vy;
dest[1] := u[0]*vz-u[2]*vx;
dest[2] := u[0]*vy-u[1]*vx;
end;



procedure drawmodelnormal(mdlObject : pmodel;aframe : integer);
const nextitem = 4;
var
command       : ^Longint; // = dword i hope
frameinfo     : pframe;
num_verts,i,vert_index : integer;
temp             : pointer;
s,t             : GlFloat;
vertcount : integer;
vert,norm : tvect;
shade : glfloat;
begin
Frameinfo := pframe(pointer(integer(mdlobject.frames) + mdlobject.Info.framesize*aframe));
//frameinfo := mdlObject.Frames[aframe];
command := pointer(mdlobject.glcmds);
//won := 0;
while command^ <> 0 do
 begin
    if command^ > 0 then
    begin
    // triangle strip
    num_verts := command^;
    inc(cardinal(command),nextitem);// next 4 bytes integer
    glBegin(GL_TRIANGLE_STRIP);
    vertcount := 0;
    for i := 0 to num_verts-1 do
        begin
        // get texture coos
        s := glfloat(pointer(command^));
        inc(cardinal(command),nextitem);// next 4 bytes integer

        t := glfloat(pointer(command^));
        inc(cardinal(command),nextitem);// next 4 bytes integer
        // get vertex index
        vert_index := command^;
        inc(cardinal(command),nextitem);// next 4 bytes integer
        //glTexCoord2f(s,t);


        vert[0] := (frameinfo.vertices[vert_index].y * frameinfo.scaley) + frameinfo.translatey;
        vert[1] := (frameinfo.vertices[vert_index].z * frameinfo.scalez) + frameinfo.translatez;
        vert[2] := (frameinfo.vertices[vert_index].x * frameinfo.scalex) + frameinfo.translatex;

        glnormal3f(Vertexnormals[frameinfo.vertices[vert_index].lightnormalindex,1],
                   Vertexnormals[frameinfo.vertices[vert_index].lightnormalindex,2],
                   Vertexnormals[frameinfo.vertices[vert_index].lightnormalindex,0]);
        {glVertex3f(
        (frameinfo.vertices[vert_index].y * frameinfo.scaley) + frameinfo.translatey,
        (frameinfo.vertices[vert_index].z * frameinfo.scalez) + frameinfo.translatez,
        (frameinfo.vertices[vert_index].x * frameinfo.scalex) + frameinfo.translatex);
        }
        glvertex3fv(@vert);
        end;
    glEnd;
    end else
    begin
    // triangle fan
    num_verts := -command^;
    inc(cardinal(command),nextitem);// next 4 bytes integer
    glBegin(GL_TRIANGLE_FAN);
    vertcount := 0;
    for i := 0 to num_verts-1 do
        begin
        // get texture coos
        s := glfloat(pointer(command^));
        inc(cardinal(command),nextitem);// next 4 bytes integer

        t := glfloat(pointer(command^));
        inc(cardinal(command),nextitem);// next 4 bytes integer
        // get vertex index
        vert_index := command^;
        inc(cardinal(command),nextitem);// next 4 bytes integer
        //glTexCoord2f(s,t);

        vert[0] := (frameinfo.vertices[vert_index].y * frameinfo.scaley) + frameinfo.translatey;
        vert[1] := (frameinfo.vertices[vert_index].z * frameinfo.scalez) + frameinfo.translatez;
        vert[2] := (frameinfo.vertices[vert_index].x * frameinfo.scalex) + frameinfo.translatex;

        glnormal3fv(@Vertexnormals[frameinfo.vertices[vert_index].lightnormalindex,0]);

        glvertex3fv(@vert);
        {glVertex3f(
        (frameinfo.vertices[vert_index].y * frameinfo.scaley) + frameinfo.translatey,
        (frameinfo.vertices[vert_index].z * frameinfo.scalez) + frameinfo.translatez,
        (frameinfo.vertices[vert_index].x * frameinfo.scalex) + frameinfo.translatex);}
        end;
    glEnd;
    end;

 end;//while
{i := 1;
error(frameinfo.name+chr(13)+
floattostr(frameinfo.scalex)+' '+floattostr(frameinfo.scaley)+' '+floattostr(frameinfo.scalez)
+chr(13)+inttostr(frameinfo.vertices[i].x)+' '+inttostr(frameinfo.vertices[i].y)+' '+inttostr(frameinfo.vertices[i].z));}
//error(inttostr(won)+'/'+inttostr(mdlObject.Header.NumTriangles));
end;


end.
