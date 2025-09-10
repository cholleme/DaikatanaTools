unit adddiru;

{$MODE Delphi}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, FileCtrl, ExtCtrls, comctrls, ShellCtrls;

type

  { TAddDirForm }

  TAddDirForm = class(TForm)
    Bevel1: TBevel;
    Label1: TLabel;
    //DirectoryListBox1: TDirectoryListBox;
    //DriveComboBox1: TDriveComboBox;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    DirLabel: TLabel;
    Label3: TLabel;
    ShellTreeView1: TShellTreeView;
    procedure BitBtn1Click(Sender: TObject);
    procedure ShellTreeView1SelectionChanged(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AddDirForm: TAddDirForm;
procedure RAddDir(path,pakPath : String);

implementation
uses mainu,pakfiles;

{$R *.lfm}

procedure RAddDir(path,pakPath : String);
var
Search : TSearchRec;
begin
if FindFirst(path,faDirectory,Search) <> 0 then
   begin FindClose(Search); exit; end;
delete(path,length(path),1);//delete the "*" at the end
while FindNext(Search) = 0 do
      begin
      If (Search.Attr and faDirectory) > 0 then
         begin
         if Search.Name <> '..' then
            begin
            std_write('Adding dir %s',[Path+Search.Name+'\*']);
            RAddDir(Path+Search.Name+'\*',pakpath+Search.Name+'/')
            end
         end
         else
         begin
         std_write('Adding file %s as %s',[Path+Search.Name,pakPath+Search.Name]);
         pakAddFile(Path+Search.Name,pakPath+Search.Name)
         end;
      end;
FindClose(Search);
end;

procedure TAddDirForm.BitBtn1Click(Sender: TObject);
begin
Close;
MainForm.ShowBusy('Adding Files to pak');
Hide;
Application.ProcessMessages;
RAddDir(DirLabel.Caption+'\*','');
pakSaveFile;
MainForm.HideBusy;
end;

procedure TAddDirForm.ShellTreeView1SelectionChanged(Sender: TObject);
begin
  DirLabel.Caption := ShellTreeView1.GetPathFromNode(ShellTreeView1.Selected);
end;

end.
