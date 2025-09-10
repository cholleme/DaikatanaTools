unit skinu;

{$MODE Delphi}

interface

uses
  Windows, ShellAPI, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons,models, ExtCtrls;

type
  TSkinForm = class(TForm)
    ListBox1: TListBox;
    OpenDialog1: TOpenDialog;
    Panel1: TPanel;
    BitBtn2: TBitBtn;
    BitBtn1: TBitBtn;
    BitBtn3: TBitBtn;
    procedure MakeSkinList(mdl : Pmodel);
    procedure ListBox1DblClick(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  SkinForm: TSkinForm;

implementation

uses frameu, viewu,modelu, daiwals;

Procedure TSkinForm.MakeSkinList(mdl : Pmodel);
var i : integer;
    new : string;
begin
ListBox1.Items.Clear;
if mdl.GlCmds = nil then exit;
for i := 0 to mdl.Info.numskins-1 do
    begin
       if extractfileExt(mdl.info.skinnames^[i]) = '.bmp' then
          new := changeFileExt(mdl.info.skinnames^[i],'.wal')
       else new := mdl.info.skinnames^[i];

    if Exclusivepakfileexists(new) then
       begin
       ListBox1.Items.Add('[Pakfile]'+new)
       end
       else
       begin
       ListBox1.Items.Add(FullPath(new));
       end;
    end;
end;

{$R *.lfm}

procedure TSkinForm.ListBox1DblClick(Sender: TObject);
begin
if ListBox1.itemindex = -1 then exit;
skin := ListBox1.Itemindex;
FrameForm.Close;
ViewForm.Invalidate;
end;

procedure TSkinForm.BitBtn2Click(Sender: TObject);
begin
if ListBox1.itemindex = -1 then
   begin
   messagedlg('Please select a skin first',mterror,[mbOk],0);
   exit;
   end
else
  If OpenDialog1.Execute then
       begin
       OpenModelTexture(MainModel,Opendialog1.Filename,ListBox1.itemindex);
       Listbox1.Items.strings[ListBox1.itemindex] := Opendialog1.Filename;
       ViewForm.Invalidate;
       end;
end;

procedure TSkinForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
MainForm.Skins1.Checked := false;
end;

procedure TSkinForm.FormCreate(Sender: TObject);
begin
loadconfig;
end;

procedure TSkinForm.BitBtn1Click(Sender: TObject);
begin
if MainModel.GlCmds = nil then
   begin
   messagedlg('Please load a model',mterror,[mbOk],0);
   exit;
   end
else
       begin
       OpenTexturesFromModel(MainModel);
       ListBox1.Clear;
       MakeSkinList(@MainModel);
       ViewForm.Invalidate;
       end;
end;

procedure TSkinForm.BitBtn3Click(Sender: TObject);
var
winbestand : array [0..255] of char ;
toexec,source     : String;
result : integer;
begin
if Listbox1.itemindex < 0 then
                          begin
                          messagedlg('Please select a skin',mterror,[mbOk],0);
                          exit;
                          end;
source := Listbox1.Items.strings[ListBox1.itemindex];

//It is not in a pak file so we don't have to extract it
if source[1] <> '['  then
   begin
   if extractfileext(source) = '.wal' then
      begin
      toexec := extractfiledir(paramstr(0))+'\daiwal.exe '+source;
      if winexec(StrPCopy(winbestand, toexec),sw_show) < 31 then messagedlg('Windows'+
         ' could not launch DaiWAL',mterror,[mbok],0);
      end
   else begin
      StrPCopy(winbestand,source);
      Result :=  ShellExecute(mainform.handle,nil,winbestand,nil,'c:\',SW_SHOW);
      if result = SE_ERR_NOASSOC then
         messagedlg('There is no application associated with '+extractfileext(source),mterror,[mbOk],0)
      else if result <= 32 then
         messagedlg('Error launching file '+source,mterror,[mbOk],0);
      end;
   exit;
   end;

//delete the [pakfile] prefix
delete(source,1,9);
ExtractFile(Source,'c:\daitemp'+extractfileext(source));
   if extractfileext(source) = '.wal' then
      begin
      toexec := extractfiledir(paramstr(0))+'\daiwal.exe c:\daitemp.wal';
      if winexec(StrPCopy(winbestand, toexec),sw_show) < 31 then messagedlg('Windows'+
         ' could not launch DaiWAL',mterror,[mbok],0);
      end
   else begin
      StrPCopy(winbestand,'c:\daitemp'+extractfileext(source));
      Result :=  ShellExecute(mainform.handle,nil,winbestand,nil,'c:\',SW_SHOW);
      if result = SE_ERR_NOASSOC then
         messagedlg('There is no application associated with '+extractfileext(source),mterror,[mbOk],0)
      else if result <= 32 then
         messagedlg('Error launching file '+source,mterror,[mbOk],0);
   end;
end;

end.
