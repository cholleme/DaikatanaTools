unit modelu;

{$MODE Delphi}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Models,Textures, Menus, GL,Viewu, ExtCtrls, StdCtrls, Inifiles ;

type
  TMainForm = class(TForm)
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Options1: TMenuItem;
    Help1: TMenuItem;
    OpenModel1: TMenuItem;
    N2: TMenuItem;
    Exit1: TMenuItem;
    OpenDialog1: TOpenDialog;
    Timer1: TTimer;
    Animate1: TMenuItem;
    About1: TMenuItem;
    View1: TMenuItem;
    Front1: TMenuItem;
    Side1: TMenuItem;
    N3d1: TMenuItem;
    N3: TMenuItem;
    Messages1: TMenuItem;
    N2Dskin1: TMenuItem;
    N5: TMenuItem;
    More1: TMenuItem;
    Skins1: TMenuItem;
    Frames1: TMenuItem;
    Weapon1: TMenuItem;
    N1: TMenuItem;
    Skybox1: TMenuItem;
    None1: TMenuItem;
    e3mtn51: TMenuItem;
    e1m11: TMenuItem;
    e2m11: TMenuItem;
    e2m31: TMenuItem;
    e4m11: TMenuItem;
    e4m31: TMenuItem;
    e4m51: TMenuItem;
    e1: TMenuItem;
    warp1: TMenuItem;
    e4m21: TMenuItem;
    e3m11: TMenuItem;
    e3m21: TMenuItem;
    e3m41: TMenuItem;
    e3m51: TMenuItem;
    e3m61: TMenuItem;
    e3mtn2a1: TMenuItem;
    e3mtn1: TMenuItem;
    black1: TMenuItem;
    e2m41: TMenuItem;
    e2m21: TMenuItem;
    procedure OpenModel1Click(Sender: TObject);
    procedure Openweapon1Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure Reload1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Animate1Click(Sender: TObject);
    procedure About1Click(Sender: TObject);
    procedure EditDefs1Click(Sender: TObject);
    procedure Front1Click(Sender: TObject);
    procedure Side1Click(Sender: TObject);
    procedure N3d1Click(Sender: TObject);
    procedure Messages1Click(Sender: TObject);
    procedure N2Dskin1Click(Sender: TObject);
    procedure Gotoframe1Click(Sender: TObject);
    procedure More1Click(Sender: TObject);
    procedure Useskin1Click(Sender: TObject);
    procedure Skins1Click(Sender: TObject);
    procedure Frames1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Weapon1Click(Sender: TObject);
    procedure black1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

procedure std_write(msg : string);
Procedure loadconfig;

var
  MainForm: TMainForm;
  MainModel : Tmodel;
  WeaponModel : Tmodel;
  angle1,angle2 : Single;
  camerazof     : single;
  camerascale   : Single = 30;
  //Frame         : Integer;
  skin : integer;
  MainModelSkinFileName : String;
implementation

uses defsu, Mesu, texu, frameu, aboutu, optu, skinu;

{$R *.lfm}
procedure std_write(msg : string);
begin
Messageform.memo1.lines.add(msg);
end;
procedure TMainForm.OpenModel1Click(Sender: TObject);
begin
if OpenDialog1.Execute then
   begin
   freemodel(@MainModel);
   FrameForm.ClearFrameList;
   frame := 0;
   std_write('Loading: '+OpenDialog1.FileName);
   loadmodel(@MainModel,OpenDialog1.FileName);
   OpenTexturesFromModel(MainModel);
   //MessageDlg('Skin Gl_index: '+inttostr(MainModel.SkinsGlindex[0]),mterror,[mbok],0);
   MainForm.Caption := 'Model viewer ['+OpenDialog1.FileName+']';
   MainModelSkinFileName := ChangeFileExt(OpenDialog1.FileName,'.tga');
   ViewForm.Invalidate;
   FrameForm.MakeFramelist(@MainModel);
   SkinForm.MakeSkinList(@MainModel);
   WireForm.FormPaint(sender);
   end;
end;

procedure TMainForm.Openweapon1Click(Sender: TObject);
begin
if OpenDialog1.Execute then
   begin
   freemodel(@WeaponModel);
   loadmodel(@WeaponModel,OpenDialog1.FileName);
   OpenModelTexture(WeaponModel,OpenDialog1.FileName,0);
   ViewForm.Invalidate;
   end;
end;

Procedure saveconfig;
var inifile : TIniFile;
begin
inifile := Tinifile.create(extractfiledir(paramstr(0))+'\daimdl.ini');

//read path
inifile.Writestring('Misc','DaiPath',OptionsForm.Daipath.Text);
//read frame form locations
inifile.WriteInteger('FrameForm','Left',frameform.left);
inifile.WriteInteger('FrameForm','Top',frameform.top);
inifile.WriteInteger('FrameForm','width',frameform.width);
inifile.WriteInteger('FrameForm','height',frameform.height);
inifile.WriteBool('FrameForm','Visible',frameform.visible);

//Write skin form locations
inifile.WriteInteger('SkinForm','Left',SkinForm.left);
inifile.WriteInteger('SkinForm','Top',SkinForm.top);
inifile.WriteInteger('SkinForm','width',SkinForm.width);
inifile.WriteInteger('SkinForm','height',SkinForm.height);
inifile.WriteBool('SkinForm','Visible',SkinForm.visible);

//Write message form locations
inifile.WriteInteger('Messageform','Left',Messageform.left);
inifile.WriteInteger('Messageform','Top',Messageform.top );
inifile.WriteInteger('Messageform','width',Messageform.width );
inifile.WriteInteger('Messageform','height',Messageform.height);
inifile.WriteBool('Messageform','Visible',Messageform.visible);
inifile.free;
end;

Procedure loadconfig;
var inifile : TIniFile;
begin

inifile := Tinifile.create(extractfiledir(paramstr(0))+'\daimdl.ini');

//read path
OptionsForm.Daipath.Text := inifile.readstring('Misc','DaiPath','c:\Program Files\Daikatana\data');
if not fileExists(extractfiledir(paramstr(0))+'\daimdl.ini') then
   begin
   OptionsForm.ShowModal;
   end;
MainForm.Opendialog1.FileName := OptionsForm.Daipath.Text;
//read frame form locations
frameform.left := inifile.ReadInteger('FrameForm','Left',0);
frameform.top := inifile.ReadInteger('FrameForm','Top',100);
frameform.width := inifile.ReadInteger('FrameForm','width',170);
frameform.height := inifile.ReadInteger('FrameForm','height',270);
frameform.visible := inifile.ReadBool('FrameForm','Visible',False);
MainForm.Frames1.Checked := frameform.visible;

//read skin form locations
SkinForm.left := inifile.ReadInteger('SkinForm','Left',0);
SkinForm.top := inifile.ReadInteger('SkinForm','Top',300);
SkinForm.width := inifile.ReadInteger('SkinForm','width',270);
SkinForm.height := inifile.ReadInteger('SkinForm','height',145);
SkinForm.visible := inifile.ReadBool('SkinForm','Visible',False);
MainForm.Skins1.Checked := SkinForm.visible;
//read message form locations
Messageform.left := inifile.ReadInteger('Messageform','Left',0);
Messageform.top := inifile.ReadInteger('Messageform','Top',0);
Messageform.width := inifile.ReadInteger('Messageform','width',260);
Messageform.height := inifile.ReadInteger('Messageform','height',100);
Messageform.visible := inifile.ReadBool('Messageform','Visible',False);
MainForm.Messages1.Checked := MessageForm.visible;
inifile.free;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
freemodel(@MainModel);
freemodel(@WeaponModel);
end;

procedure TMainForm.Exit1Click(Sender: TObject);
begin
Application.Terminate;
end;

procedure TMainForm.Reload1Click(Sender: TObject);
begin
OpenModelTexture(MainModel,MainModelSkinFileName,0);
ViewForm.Invalidate;
end;

procedure TMainForm.Timer1Timer(Sender: TObject);
begin
inc(frame);
ViewForm.Invalidate;
end;

procedure TMainForm.Animate1Click(Sender: TObject);
begin
Animate1.Checked := not Animate1.Checked;
Timer1.Enabled := Animate1.Checked;
end;

procedure TMainForm.About1Click(Sender: TObject);
begin
AboutBox.showmodal;
end;

procedure TMainForm.EditDefs1Click(Sender: TObject);
begin
DefsForm.Showmodal;
end;

procedure TMainForm.Front1Click(Sender: TObject);
begin
angle1 := 0;
angle2 := 0;
camerascale := 30;
camerazof := 0;
ViewForm.Invalidate;
end;

procedure TMainForm.Side1Click(Sender: TObject);
begin
angle1 := 90;
angle2 := 0;
camerascale := 30;
camerazof := 0;
ViewForm.Invalidate;
end;

procedure TMainForm.N3d1Click(Sender: TObject);
begin
angle1 := 45;
angle2 := 45;
camerascale := 30;
camerazof := 0;
ViewForm.Invalidate;
end;

procedure TMainForm.Messages1Click(Sender: TObject);
begin
Messages1.Checked := not Messages1.Checked;
if messages1.Checked then Messageform.Show else Messageform.Hide;
end;

procedure TMainForm.N2Dskin1Click(Sender: TObject);
begin
WireForm.Show;
end;

procedure TMainForm.Gotoframe1Click(Sender: TObject);
begin
FrameForm.Show;
end;

procedure TMainForm.More1Click(Sender: TObject);
begin
OptionsForm.Showmodal;
end;

procedure TMainForm.Useskin1Click(Sender: TObject);
begin
SkinForm.Show;
end;

procedure TMainForm.Skins1Click(Sender: TObject);
begin
Skins1.Checked := not Skins1.Checked;
if Skins1.Checked then SkinForm.Show else SkinForm.Hide;
end;

procedure TMainForm.Frames1Click(Sender: TObject);
begin
Frames1.Checked := not Frames1.Checked;
if Frames1.Checked then FrameForm.Show else FrameForm.Hide;
end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
saveconfig;
end;

procedure TMainForm.Weapon1Click(Sender: TObject);
begin
angle1 := 175;
angle2 := 4;
camerascale := 1;
camerazof := 0;
ViewForm.Invalidate;
end;

procedure TMainForm.black1Click(Sender: TObject);
begin
with Sender as TMenuItem do
     begin
     LoadSkyBox(Caption);
     Checked := true;
     end;
ViewForm.Invalidate;
end;

end.
