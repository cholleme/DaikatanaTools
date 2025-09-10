unit addu;

{$MODE Delphi}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, FileCtrl, Buttons, ExtCtrls, pakFiles, comctrls, ShellCtrls;

type

  { TAddForm }

  TAddForm = class(TForm)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    FilterComboBox1: TFilterComboBox;
    GroupBox2: TGroupBox;
    Panel1: TPanel;
    PakFileListBox: TListBox;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Panel2: TPanel;
    Button3: TButton;
    Button1: TButton;
    Button2: TButton;
    ShellListView1: TShellListView;
    ShellTreeView1: TShellTreeView;
    procedure BitBtn2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FileListBox1DblClick(Sender: TObject);
    procedure AddFile(FileName : String);
    procedure PakFileListBoxKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure BitBtn1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AddForm: TAddForm;
  DestDir : String;
implementation

uses mainu;

{$R *.lfm}

procedure TAddForm.AddFile(FileName : String);
begin
//if it's the root dir of a drive there end up 2 \ in the filename
If (FileName[3] = '\') and (FileName[4] = '\') then delete(FileName,3,1);

if PakFileListBox.Items.IndexOf(FileName) = -1 then
   begin
   PakFileListBox.Items.Add(FileName);
   end else MessageDlg(Filename+chr(13)+
                       'There is already a file with that name',
                       mtWarning,[mbOk],0);
end;

procedure TAddForm.Button3Click(Sender: TObject);
var i : integer;
begin
For i := 0 to ShellListView1.Items.Count-1 do
    begin
        AddFile(ShellListView1.GetPathFromItem(ShellListView1.Items[i]));
    end;
end;

procedure TAddForm.BitBtn2Click(Sender: TObject);
begin
  close;
end;

procedure TAddForm.Button1Click(Sender: TObject);
var i : integer;
begin
For i := 0 to ShellListView1.Items.Count-1 do
    begin
    if ShellListView1.Items[i].Selected = true then
       begin
           AddFile(ShellListView1.GetPathFromItem(ShellListView1.Items[i]));
       end;
    end;
end;

procedure TAddForm.Button2Click(Sender: TObject);
begin
PakFileListBox.Items.Clear;
end;

procedure TAddForm.FileListBox1DblClick(Sender: TObject);
begin
if ShellListView1.ItemIndex > -1 then
   begin
        AddFile(ShellListView1.GetPathFromItem(ShellListView1.Items[ShellListView1.ItemIndex]));
   end;
end;

procedure TAddForm.PakFileListBoxKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
if Key = VK_DELETE then
   if PakFileListBox.ItemIndex > -1 then
      PakFileListBox.Items.Delete(PakFileListBox.ItemIndex);
end;

procedure TAddForm.BitBtn1Click(Sender: TObject);
var i : integer;
begin
MainForm.ShowBusy('Adding Files to pak');
Hide;
Application.Processmessages;
for i := 0 to PakFileListBox.Items.Count-1 do
    begin
    pakAddFile(PakFileListBox.items.strings[i],
               DestDir+extractfilename(PakFileListBox.items.strings[i]));
    end;
pakSaveFile;
PakFileListBox.items.clear;
//MainForm.TreeView1.Items.Clear;
//MainForm.ListView1.Items.Clear;
//Free_PakFile;
MainForm.HideBusy;
end;

procedure TAddForm.FormActivate(Sender: TObject);
begin
if DestDir = '' then Caption := 'Add files to /'
   else
   Caption := 'Add files to '+DestDir;
end;

end.
