unit texu;

{$MODE Delphi}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, ExtDlgs, ExtCtrls;

type

  { TWireForm }

  TWireForm = class(TForm)
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Savewireframe1: TMenuItem;
    Image1: TImage;
    SavePictureDialog1: TSavePictureDialog;
    procedure FormPaint(Sender: TObject);
    procedure Savewireframe1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  WireForm: TWireForm;

implementation
uses models,modelu;
{$R *.lfm}

function gettexco(i : integer;extra : integer) : TTextureCoordinate;
var
aco : ^TTextureCoordinate;
begin
if i > mainmodel.Info.numTexCos then begin result.s := 0; result.t := 0; exit; end;
aco := pointer(cardinal(mainmodel.texcos) + i * sizeof(TTextureCoordinate));
result := aco^;
end;

const Linecolors : array [0..7] of TColor = (clBlack,clRed,clGreen,clBlue,clSilver,clAqua,clLime,clYellow);

procedure line(p1,p2 : TTextureCoordinate);
begin
WireForm.Image1.canvas.moveto(p1.s,p1.t);
WireForm.Image1.canvas.lineto(p2.s,p2.t);
end;

procedure TWireForm.FormPaint(Sender: TObject);
var atri : ^TTriangle;
    coord : TTextureCoordinate;
    i : integer;
begin
//Image1.Width := Mainmodel.Info.Skinwidth;
//Image1.Height := Mainmodel.Info.SkinHeight;
Image1.canvas.pen.color := clWhite;
WireForm.Image1.canvas.Rectangle(0,0,256,256);
if mainmodel.GlCmds = nil then exit;
for i := 0 to mainmodel.info.numtriangles-1 do
      begin
      atri := pointer(cardinal(mainmodel.triangles)+i*sizeof(TTriangle));
      Image1.canvas.pen.color := linecolors[atri.extra];
      with atri^do
      begin
//      std_write(inttostr(extra));
      line(gettexco(textureIndices[0],extra),gettexco(textureIndices[2],extra));
      line(gettexco(textureIndices[2],extra),gettexco(textureIndices[1],extra));
      line(gettexco(textureIndices[1],extra),gettexco(textureIndices[0],extra));
      end;
      end;
end;

procedure TWireForm.Savewireframe1Click(Sender: TObject);
begin
If SavePictureDialog1.Execute then
   WireForm.Image1.Picture.Bitmap.SaveToFile(SavePictureDialog1.Filename);
end;

procedure TWireForm.FormActivate(Sender: TObject);
begin
FormPaint(sender);
end;

end.
