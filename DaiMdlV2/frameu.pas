unit frameu;

{$MODE Delphi}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls,models, Buttons;

type
  TFrameForm = class(TForm)
    ListBox1: TListBox;
    procedure ListBox1DblClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure MakeFrameList(mdl : Pmodel);
    procedure ClearFrameList;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrameForm: TFrameForm;

implementation

uses viewu, modelu;
{$R *.lfm}
procedure TFrameForm.MakeFrameList(mdl : Pmodel);
var i : integer;
    frameinfo : PFrame;
begin
ListBox1.Items.Clear;
if mdl.glcmds = nil then exit;
for i := 0 to mdl.Info.numframes-1 do
    begin
    Frameinfo := pframe(pointer(cardinal(mdl.frames) + mdl.Info.framesize*i));
    ListBox1.Items.Add(Frameinfo.name);
    end;
end;

procedure TFrameForm.ClearFrameList;
begin
ListBox1.Clear;
end;

procedure TFrameForm.ListBox1DblClick(Sender: TObject);
begin
if ListBox1.itemindex = -1 then exit;
frame := ListBox1.Itemindex;
//FrameForm.Close;
ViewForm.Invalidate;
end;

procedure TFrameForm.Button1Click(Sender: TObject);
begin
if ListBox1.itemindex <> -1 then frame := ListBox1.Itemindex;
FrameForm.Close;
ViewForm.Invalidate;
end;

procedure TFrameForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
MainForm.Frames1.Checked := false;
end;

end.
