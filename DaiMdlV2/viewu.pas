unit viewu;

{$MODE Delphi}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  GL,GLU, models, textures, ComCtrls;
type
  TViewForm = class(TForm)
    StatusBar1: TStatusBar;
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
    DC: HDC;
    hrc: HGLRC;
    Palette: HPALETTE;
    Angle: GLfloat;
    x,y,z,clipdist : glFloat;
    rightbutton,leftbutton : boolean;
    procedure DrawScene;
    procedure InitializeRC;
    procedure SetDCPixelFormat;
    procedure WMEraseBkgnd (var Msg : TMessage); message WM_ERASEBKGND;    
  public
    { Public declarations }
  end;

procedure LoadSkyBox(prefix : string);
  
var
  ViewForm: TViewForm;
  lastx,lasty : integer;

const
LightPos : array [0..3] of single = (0,0,-1,0);
      glfMaterialColor: Array[0..3] of GLfloat = (1.0, 1.0, 1.0, 0.2);
      glfLightAmbient : Array[0..3] of GLfloat = (0.0, 1.0, 0.0, 1.0);
      glfLightDiffuse : Array[0..3] of GLfloat = (1.0, 0.0, 1.0, 1.0);
      glfLightSpecular: Array[0..3] of GLfloat = (1.0, 1.0, 1.0, 1.0);
      glfLightPosition: Array[0..3] of GLfloat = (100.0, 100.0, 100.0, 0.0);
      
procedure OpenModelTexture(var model : Tmodel;filename : string;index : integer);
Procedure OpenTexturesFromModel(var model : Tmodel);

implementation
   uses modelu,daiwals;

procedure TViewForm.WMEraseBkGnd;
begin
  Msg.Result := 0; {oh no, never write the background}
end;

procedure TViewForm.SetDCPixelFormat;
var
  hHeap: THandle;
  nColors, i: Integer;
  lpPalette: PLogPalette;
  byRedMask, byGreenMask, byBlueMask: Byte;
  nPixelFormat: Integer;
  pfd: TPixelFormatDescriptor;
begin
  FillChar(pfd, SizeOf(pfd), 0);

  with pfd do begin
    nSize     := sizeof(pfd);                               // Size of this structure
    nVersion  := 1;                                         // Version number
    dwFlags   := PFD_DRAW_TO_WINDOW or
                 PFD_SUPPORT_OPENGL or
                 PFD_DOUBLEBUFFER;                          // Flags
    iPixelType:= PFD_TYPE_RGBA;                             // RGBA pixel values
    cColorBits:= 24;                                        // 24-bit color
    cDepthBits:= 32;                                        // 32-bit depth buffer
    iLayerType:= PFD_MAIN_PLANE;                            // Layer type
  end;

  nPixelFormat := ChoosePixelFormat(DC, @pfd);
  SetPixelFormat(DC, nPixelFormat, @pfd);

end;

var
skybox : array [0..6] of tglTexture;
skytrans : single;
skysphere : PGLUquadricObj;
skyHasClouds : boolean = false;
SkyBoxEnabled : boolean = false;

procedure LoadSkyBox(prefix : string);
var name : string;
    i : integer;
begin
for i :=  0 to 6 do
    begin
    if skybox[i].glIndex <> 0 then
       glDeleteTextures(1,@skybox[i].glIndex);
    end;
if prefix = 'none' then begin SkyBoxEnabled := false; exit; end
   else SkyBoxEnabled := true;
name := 'env/32bit/'+prefix;
LoadTgaFromPak(name+'lf.tga',skybox[0],GL_CLAMP_TO_EDGE);
LoadTgaFromPak(name+'ft.tga',skybox[1],GL_CLAMP_TO_EDGE);
LoadTgaFromPak(name+'rt.tga',skybox[2],GL_CLAMP_TO_EDGE);
LoadTgaFromPak(name+'bk.tga',skybox[3],GL_CLAMP_TO_EDGE);
LoadTgaFromPak(name+'up.tga',skybox[4],GL_CLAMP_TO_EDGE);
LoadTgaFromPak(name+'dn.tga',skybox[5],GL_CLAMP_TO_EDGE);

if (prefix = 'e3m5') or (prefix = 'e4m2') or (prefix='e2m2') then
   begin
   SkyHasClouds := false;
   exit;
   end;
   
if NewFileExists(name+'tile.tga') then
   begin
   LoadTgaFromPak(name+'tile.tga',skybox[6],GL_LINEAR);
   SkyHasClouds := true;
   end else SkyHasClouds := false;
end;

procedure TViewForm.InitializeRC;
  var i,j : integer;
  temp : byte;
  begin
  //
  // Enable depth testing and backface culling.
  //
  glEnable(GL_DEPTH_TEST);
  glEnable(GL_CULL_FACE);
  //
  // Add a light to the scene.
  //
//  glLightfv(GL_LIGHT0, GL_POSITION,@glflightPosition);
  //glLightfv(GL_LIGHT0, GL_DIFFUSE, @glflightDiffuse);
// glLightfv(GL_LIGHT0, GL_AMBIENT, @glflightDiffuse);
  glEnable(GL_NORMALIZE);
  glEnable(GL_LIGHT0);

  glViewport(0,0,Width,Height);
  glMatrixMode(GL_PROJECTION);
  glLoadIdentity();
  glMatrixMode(GL_MODELVIEW);
  glLoadIdentity();
  glShadeModel(GL_SMOOTH);
  glClearColor(0.5,0.5,0.5,1.0);
  glClear(GL_COLOR_BUFFER_BIT);
  glMaterialfv(GL_FRONT_AND_BACK,GL_AMBIENT_AND_DIFFUSE,@glfMaterialColor);
  //
  // try to load a texture
  //
  glEnable(GL_CULL_FACE);
  glEnable(gl_Blend);
glBlendFunc(GL_SRC_ALPHA,GL_ONE_MINUS_SRC_ALPHA);
//   glEnable(GL_Lighting);
  glCullface(gl_front);
  glAlphaFunc(GL_GREATER,0.1);
  glEnable(GL_ALPHA_TEST);
 // LoadSkyBox('C:\Games\daikat\data\env\32bit\black');
  SkySphere := gluNewQuadric();
  gluQuadricTexture(skySphere,GLboolean(GL_TRUE)); { *Converted from gluQuadricTexture* }
  gluQuadricOrientation(skySphere,GLU_INSIDE);
end;

procedure rawDrawBox;
begin
   glbindtexture(gl_texture_2d,skybox[1].glindex);
    glBegin(GL_POLYGON);

      glTexCoord2f(0,0);
      glVertex3f(10.0, 10.0, 10.0);

      glTexCoord2f(0,1);
      glVertex3f(10.0, -10.0, 10.0);

      glTexCoord2f(1,1);
      glVertex3f(-10.0, -10.0, 10.0);

      glTexCoord2f(1,0);
      glVertex3f(-10.0, 10.0, 10.0);

    glEnd;

    //p
    glbindtexture(gl_texture_2d,skybox[3].glindex);
    glBegin(GL_POLYGON);
      glTexCoord2f(1,0);
      glVertex3f(10.0, 10.0, -10.0);

      glTexCoord2f(0,0);
      glVertex3f(-10.0, 10.0, -10.0);

      glTexCoord2f(0,1);
      glVertex3f(-10.0, -10.0, -10.0);

      glTexCoord2f(1,1);
      glVertex3f(10.0, -10.0, -10.0);

    glEnd;

    //voor achter
    glbindtexture(gl_texture_2d,skybox[0].glindex);
    glBegin(GL_POLYGON);
      glTexCoord2f(0,0);
      glVertex3f(-10.0, 10.0, 10.0);

      glTexCoord2f(0,1);
      glVertex3f(-10.0, -10.0, 10.0);

      glTexCoord2f(1,1);
      glVertex3f(-10.0, -10.0, -10.0);

      glTexCoord2f(1,0);
      glVertex3f(-10.0, 10.0, -10.0);

    glEnd;
    //p2
    glbindtexture(gl_texture_2d,skybox[2].glindex);
    glBegin(GL_POLYGON);
      glTexCoord2f(1,0);
      glVertex3f(10.0, 10.0, 10.0);

      glTexCoord2f(0,0);
      glVertex3f(10.0, 10.0, -10.0);

      glTexCoord2f(0,1);
      glVertex3f(10.0, -10.00, -10.0);

      glTexCoord2f(1,1);
      glVertex3f(10.0, -10.0, 10.0);
    glEnd;

    glbindtexture(gl_texture_2d,skybox[4].glindex);
    //boven
    glBegin(GL_POLYGON);
      glTexCoord2f(0,0);
      glVertex3f(-10.0, 10.0, -10.0);

      glTexCoord2f(0,1);
      glVertex3f(10.0, 10.0, -10.0);

      glTexCoord2f(1,1);
      glVertex3f(10.0, 10.0, 10.0);

      glTexCoord2f(1,0);
      glVertex3f(-10.0, 10.0, 10.0);

    glEnd;

    glbindtexture(gl_texture_2d,skybox[5].glindex);
{    glPushmatrix;
    glRotatef(-90,0,0,1); }
    //onder
    glBegin(GL_POLYGON);
      glTexCoord2f(0,1);
      glVertex3f(-10.0, -10.0, -10.0);

      glTexCoord2f(1,1);
      glVertex3f(-10.0, -10.0, 10.0);


      glTexCoord2f(1,0);
      glVertex3f(10.0, -10.0, 10.0);

      glTexCoord2f(0,0);
      glVertex3f(10.0, -10.0, -10.0);
    glEnd;
//    glPopMatrix;
end;

procedure drawskybox;
var sunheight : glFloat;
    sunsize : glFloat;
begin
glColor3ub(255,255,255);
glCullFace(gl_BACK);

    glDisable(gl_ALPHA_TEST);
    glDepthMask(GLboolean(false)); { *Converted from glDepthMask* }
    glDisable(gl_Blend);
    rawDrawBox;
    glEnable(gl_Blend);


    //above clouds
    if skyHasClouds then
    begin
    glbindtexture(gl_texture_2d,skybox[6].glindex);
    glDisable(gl_Depth_test);

    glMatrixMode(GL_TEXTURE);
    glPushMatrix;
    skytrans := skytrans + 0.01;
    glTranslatef(skytrans,0,0);
    //glScalef(5,5,5);
    //gluSphere(skySphere,50,20,20);
    glcolor4ub(255,255,255,128);
    glBegin(GL_POLYGON);
      glTexCoord2f(0,0);
      glVertex3f(-200.0, 1.0, -200.0);

      glTexCoord2f(0,40);
      glVertex3f(200.0, 1.0, -200.0);

      glTexCoord2f(40,40);
      glVertex3f(200.0, 1.0, 200.0);

      glTexCoord2f(40,0);
      glVertex3f(-200.0,1.0, 200.0);

    glEnd;
   // glPopMatrix;

    glTranslatef(0,skytrans/2,0);
    //glScalef(5,5,5);
    //gluSphere(skySphere,50,20,20);
    glBegin(GL_POLYGON);
      glTexCoord2f(0,0);
      glVertex3f(-200.0, 1, -200.0);

      glTexCoord2f(0,80);
      glVertex3f(200.0, 1, -200.0);

      glTexCoord2f(80,80);
      glVertex3f(200.0, 1, 200.0);

      glTexCoord2f(80,0);
      glVertex3f(-200.0, 1, 200.0);

    glEnd;
    glPopMatrix;
    glEnable(gl_Depth_test);
    end;
    glDepthMask(GLboolean(GL_TRUE)); { *Converted from glDepthMask* }
    //glClear(GL_DEPTH_BUFFER_BIT);
    glcolor4ub(255,255,255,255);

    rawDrawBox;
  {  glMatrixMode(gl_ModelView);
    glPushMatrix;
    glScaleF(1.1,1.1,1.1);
    glMatrixMode(gl_Texture);
//    glBlendFunc(GL_SRC_ALPHA,GL_DST_ALPHA);
    glblendfunc(GL_SRC_ALPHA, GL_ONE);
    rawDrawBox;
    glMatrixMode(gl_ModelView);
    glPopMatrix;
    glBlendFunc(GL_SRC_ALPHA,GL_ONE_MINUS_SRC_ALPHA);}
    //links rechts
     glEnable(gl_ALPHA_TEST);
glCullFace(gl_FRONT);
end;
//Called when user clicks a skin by clicking on load, so it can't come from the
//pack
procedure OpenModelTexture(var model : Tmodel;filename : string;index : integer);
var temp : TglTexture;
begin
if model.SkinsGlIndex[index] > 0 then begin
                                glDeleteTextures(1,@model.SkinsGlIndex[index]);
                                model.SkinsGlIndex[index] := 0;
                                std_write('Skin freed');
                                end;

if ExtractFileExt(filename) = '.dkm' then
   begin
      filename := ChangeFileExt(filename,'.tga');
   end;
temp.glindex := 0;
if ExtractFileExt(filename) = '.tga' then
      begin
//      std_write('Skin Gl_index: '+inttostr(temp.glindex));

      LoadTgaFromPak(filename,temp,GL_LINEAR);
      std_write('Skin Gl_index: '+inttostr(temp.glindex));
      model.SkinsGlIndex[index] := temp.glindex;
      exit;
      end;

if ExtractFileExt(filename) = '.bmp' then
         begin
         LoadToGltexture(filename,temp,GL_LINEAR);
         model.SkinsGlIndex[index] := temp.glindex;
         exit;
         end;
end;

//called by model loader, skins will come from the pack, if he does't find them
//in the pak it wil load from the data/skins dir
Procedure OpenTexturesFromModel(var model : Tmodel);
var temp : TglTexture;
filename : string;
i : integer;
begin
temp.glindex := 0;
for i := 0 to model.info.numskins-1 do
         begin
         if model.SkinsGlIndex[i] <> 0 then
                         begin
                         glDeleteTextures(1,@model.SkinsGlIndex[i]);
                         model.SkinsGlIndex[i] := 0;
                         end;
         filename := ChangeFileExt(model.info.skinnames[i],'.wal');
         LoadWalFromPak(filename,temp,GL_Linear);
         //aie not found (nowhere not in pak and not in dir)
         if temp.glindex = -1 then
            begin
            //the bastars have some tga's instead of wal's
            filename := ChangeFileExt(model.info.skinnames[i],'.tga');
            LoadTgaFromPak(filename,temp,GL_Linear);
            if temp.glindex = -1 then
               begin
               //still not found use white texture
               model.SkinsGlIndex[i] := 0;
               exit;
               end;
            end;
         model.SkinsGlIndex[i] := temp.glindex;
         end;
end;

procedure TViewForm.DrawScene;
const
  glfMaterialColor: Array[0..3] of GLfloat = (1.0, 1.0, 1.0, 1.0);
  sPlane : array[0..3] of glfloat = ( 0.05, 0.03, 0.0, 0.0 );
  tPlane : array[0..3] of glfloat = ( 0.0, 0.03, 0.05, 0.0 );

var
  i, j, k: GLdouble;
  size : single;
  camerax,cameray,cameraz : glfloat;
begin
  glDrawBuffer(GL_BACK);

  // Clear the color and depth buffers.
  if SkyBoxEnabled then
  begin
      glClear(GL_DEPTH_BUFFER_BIT);
      glMatrixMode(GL_MODELVIEW);
      glLoadIdentity;
      camerax := sin(angle1 / 180 * pi) * abs(cos(angle2 / 180 * pi));
      cameray := (sin(angle2 / 180 * pi));
      cameraz := cos(angle1 / 180 * pi) * abs(cos(angle2 / 180 * pi));
      gluLookat(camerax,cameray,cameraz,0,0,0,0,1,0);
      drawskybox;
      glClear(GL_DEPTH_BUFFER_BIT);
  end else glClear(GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT);

  // Camera Matrix Setup
  glMatrixMode(GL_MODELVIEW);
  glLoadIdentity;

  camerax := sin(angle1 / 180 * pi) * camerascale * abs(cos(angle2 / 180 * pi));
  cameray := (sin(angle2 / 180 * pi)* camerascale);
  cameraz := cos(angle1 / 180 * pi) * camerascale * abs(cos(angle2 / 180 * pi));
  gluLookat(camerax,cameray,cameraz,0,0,0,0,1,0);
  gltranslatef(0,camerazof,0);
  glLightfv(GL_LIGHT0, GL_POSITION,@glfLightPosition);
  glLightfv(GL_LIGHT0, GL_DIFFUSE, @glflightDiffuse);
  glLightfv(GL_LIGHT0, GL_AMBIENT, @glflightAmbient);   
  glScalef(0.3,0.3,0.3);
  // Draw model(s)
  if frame >= MainModel.Info.numframes then frame := 0;
  StatusBar1.Panels[0].Text := 'Frame: '+inttostr(frame);
  StatusBar1.Panels[1].Text := 'Zoom: '+Floattostr(camerascale);
  StatusBar1.Panels[2].Text := 'Angle1: '+Floattostr(angle1);
  StatusBar1.Panels[3].Text := 'Angle2: '+Floattostr(angle2);
  glenable(gl_texture_2d);
  if MainModel.GlCmds <> nil then begin
                         glbindtexture(gl_texture_2d,MainModel.SkinsGlIndex[skin]);
                         drawmodel(@MainModel,frame);
                        end;
  //CheckOpenGLError;
  glFlush();
  SwapBuffers(DC);
end;
{$R *.lfm}

procedure TViewForm.FormCreate(Sender: TObject);
var
  VersionStr: PAnsiChar;
  RendererStr: PAnsiChar;
  VendorStr: PAnsiChar;
begin
  // Create a rendering context.
  DC := GetDC(Handle);
  SetDCPixelFormat;
  hrc := wglCreateContext(DC);
  wglMakeCurrent(DC, hrc);

  VersionStr := PAnsiChar(glGetString(GL_VERSION));
  RendererStr := PAnsiChar(glGetString(GL_RENDERER));
  VendorStr := PAnsiChar(glGetString(GL_VENDOR));

  //std_write('OpenGL Version: '+string(VersionStr));
  //std_write('OpenGL Renderer: '+string(RendererStr));
  //std_write('OpenGL Vendor: '+string(VendorStr));

  InitializeRC;
end;

procedure TViewForm.FormResize(Sender: TObject);
begin
  // Redefine the viewing volume and viewport when the window size changes.
  glMatrixMode(GL_PROJECTION);
  glLoadIdentity;
  gluPerspective(60.0,           // Field-of-view angle
                 Width / Height,      // Aspect ratio of viewing volume
                 0.5,            // Distance to near clipping plane
                 3000);          // Distance to far clipping plane
  glViewport(0, 0, Width, Height);
  InvalidateRect(Handle, nil, False);
end;

procedure TViewForm.FormDestroy(Sender: TObject);
begin
  // Clean up and terminate.
  gluDeleteQuadric(skysphere);
  wglMakeCurrent(0, 0);
  wglDeleteContext(hrc);
  ReleaseDC(Handle, DC);
end;

procedure TViewForm.FormPaint(Sender: TObject);
var ps : TPAINTSTRUCT;
begin
  BeginPaint(Handle, ps);
  DrawScene;
  EndPaint(Handle, ps)
end;

procedure TViewForm.FormMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var dx,dy : integer;
begin
dx := x - lastx;
dy := y - lasty;
lastx := x;
lasty := y;

if leftbutton and (not rightbutton) then
   begin
       angle1 := angle1 + dx;
       angle2 := angle2 + dy;
       if angle2 > 360 then angle2 := angle2-360;
       if angle1 > 360 then angle1 := angle1-360;
       if angle2 < 0 then angle2 := angle2+360;
       if angle1 < 0 then angle1 := angle1+360;
       Invalidate;
   end else
   if rightbutton and (not leftbutton) then
   begin
       camerascale := camerascale + dx*0.5;
       Invalidate;
   end;
if rightbutton and leftbutton then
   begin
       camerazof := camerazof + dx;
       Invalidate;
   end;
end;

procedure TViewForm.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
if button = mbright then rightbutton := true;
if button = mbleft then leftbutton := true;
end;

procedure TViewForm.FormMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
if button = mbright then rightbutton := false;
if button = mbleft then leftbutton := false;
end;

procedure TViewForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
if key = VK_return then
         begin
         Inc(frame);
         end else if key = VK_UP then camerazof :=  camerazof +1
             else if key = VK_DOWN then camerazof :=  camerazof -1;
Invalidate;
end;

end.
