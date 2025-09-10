unit mainu;

{$MODE Delphi}

interface

uses
  Windows, ShellAPI, MMSystem, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, ComCtrls, StdCtrls, FileCtrl, ExtCtrls, ToolWin, Buttons, IniFiles, Clipbrd, CommCtrl;

type
  TMainForm = class(TForm)
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Open1: TMenuItem;
    OpenDialog1: TOpenDialog;
    ImageList1: TImageList;
    Memo1: TMemo;
    StatusBar1: TStatusBar;
    Help1: TMenuItem;
    Info1: TMenuItem;
    View1: TMenuItem;
    Icon1: TMenuItem;
    Smallicon1: TMenuItem;
    List1: TMenuItem;
    Extract1: TMenuItem;
    N2: TMenuItem;
    Exit1: TMenuItem;
    ListView1: TListView;
    ImageList2: TImageList;
    Details1: TMenuItem;
    Extractall1: TMenuItem;
    Newpak1: TMenuItem;
    Addtopak1: TMenuItem;
    N3: TMenuItem;
    TreeView1: TTreeView;
    Splitter1: TSplitter;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    OpenPackbtn: TSpeedButton;
    ToolButton2: TToolButton;
    ExtractFilesBtn: TSpeedButton;
    ExtractDirBtn: TSpeedButton;
    ExtractAllBtn: TSpeedButton;
    ToolButton3: TToolButton;
    ViewFileBtn: TSpeedButton;
    BusyPanel: TPanel;
    Label1: TLabel;
    ProgressBar1: TProgressBar;
    FilePopupMenu: TPopupMenu;
    DirPopupMenu: TPopupMenu;
    Extract2: TMenuItem;
    PlayView1: TMenuItem;
    Remove1: TMenuItem;
    Open2: TMenuItem;
    Extract3: TMenuItem;
    ToolButton4: TToolButton;
    ImportFilesBtn: TSpeedButton;
    ImportDirBtn: TSpeedButton;
    ImportAllBtn: TSpeedButton;
    DeleteFileBtn: TSpeedButton;
    ToolButton5: TToolButton;
    NewPakBtn: TSpeedButton;
    SaveDialog1: TSaveDialog;
    Rename1: TMenuItem;
    Rename2: TMenuItem;
    SpeedButton1: TSpeedButton;
    DirUpBtn: TSpeedButton;
    ToolButton6: TToolButton;
    N4: TMenuItem;
    TreeView2: TMenuItem;
    Movetonewdirectory1: TMenuItem;
    N1: TMenuItem;
    Addtonewdirectory1: TMenuItem;
    Adddirectorytree1: TMenuItem;
    Extractcurrentdirectory1: TMenuItem;
    Messages1: TMenuItem;
    ToolButton7: TToolButton;
    StatusBar2: TMenuItem;
    N5: TMenuItem;
    Options1: TMenuItem;
    Movetonewdirectory2: TMenuItem;
    Splitter2: TSplitter;
    Edit1: TMenuItem;
    SelectAll1: TMenuItem;
    InvertSelection1: TMenuItem;
    Readme1: TMenuItem;
    MultiPopupMenu1: TPopupMenu;
    Extract4: TMenuItem;
    Movetonewdirectory3: TMenuItem;
    Remove2: TMenuItem;
    N6: TMenuItem;
    Refresh1: TMenuItem;
    procedure Open1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ListView1DblClick(Sender: TObject);
    procedure ListView1Change(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure Info1Click(Sender: TObject);
    procedure Icon1Click(Sender: TObject);
    procedure Smallicon1Click(Sender: TObject);
    procedure List1Click(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure Details1Click(Sender: TObject);
    procedure Extractall1Click(Sender: TObject);
    procedure Addtopak1Clic(Sender: TObject);
    procedure TreeView1Expanded(Sender: TObject; Node: TTreeNode);
    procedure TreeView1Collapsed(Sender: TObject; Node: TTreeNode);
    procedure TreeView1Change(Sender: TObject; Node: TTreeNode);
    procedure AddIcons;
    procedure FormCreate(Sender: TObject);
    procedure TreeView1DblClick(Sender: TObject);
    procedure ExtractFilesBtnClick(Sender: TObject);
    procedure ExtractDirBtnClick(Sender: TObject);
    procedure ViewFileBtnClick(Sender: TObject);
    procedure ShowBusy(Msg : String);
    procedure HideBusy;
    procedure ShowAddDialog(FileDir : String);
    procedure ListView1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ImportFilesBtnClick(Sender: TObject);
    procedure ImportDirBtnClick(Sender: TObject);
    procedure Extract3Click(Sender: TObject);
    procedure NewPakBtnClick(Sender: TObject);
    procedure DeleteFileBtnClick(Sender: TObject);
    procedure Rename1Click(Sender: TObject);
    procedure TreeView1DragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure TreeView1DragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure ListView1DragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure ListView1DragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure DirUpBtnClick(Sender: TObject);
    procedure TreeView2Click(Sender: TObject);
    procedure BusyPanelClick(Sender: TObject);
    procedure Messages1Click(Sender: TObject);
    procedure EnableButtons;
    procedure StatusBar2Click(Sender: TObject);
    procedure Options1Click(Sender: TObject);
    procedure ListView1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Movetonewdirectory1Click(Sender: TObject);
    procedure ImportAllBtnClick(Sender: TObject);
    procedure SelectAll1Click(Sender: TObject);
    procedure InvertSelection1Click(Sender: TObject);
    procedure Readme1Click(Sender: TObject);
    procedure Movetonewdirectory3Click(Sender: TObject);
    procedure RespondToMessage(var Msg: Tmsg; var Handled: Boolean);
    procedure Refresh1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;
  CanWrite : Boolean = true;
procedure std_write(const AFormat: string; const Args: array of const);
procedure std_error(const AFormat: string; const Args: array of const);

implementation
uses pakfiles, aboutu, addu, optu, adddiru;
{$R *.lfm}

procedure std_error(const AFormat: string; const Args: array of const);
begin
MessageDlg(Format(AFormat,Args),MtError,[MbOk],0);
end;

procedure std_write(const AFormat: string; const Args: array of const);
begin
if CanWrite then MainForm.Memo1.Lines.Add(Format(AFormat,Args));
end;

function ValidDirName(dir : string) : Boolean;
begin
result := true;
if pos('/',dir) <> 0 then
                   begin
                   std_error('%s is not a valid directory name',[dir]);
                   result := false;
                   end;
end;

function ValidFileName(filen : string) : Boolean;
begin
result := true;
if pos('/',filen) <> 0 then
                   begin
                   std_error('%s is not a valid file name',[filen]);
                   result := false;
                   end;
end;

procedure TMainForm.EnableButtons;
begin
    ExtractFilesBtn.Enabled := True;
    ExtractDirBtn.Enabled := True;
    ExtractAllBtn.Enabled := True;
    DirUpBtn.Enabled := True;
    ImportFilesBtn.Enabled := True;
    ImportDirBtn.Enabled := True;
    ImportAllBtn.Enabled := True;
    ViewFileBtn.Enabled := True;
    DeleteFileBtn.Enabled := True;
    Extract1.Enabled := true;
    ExtractAll1.Enabled := true;
    Extractcurrentdirectory1.Enabled := true;
    Addtopak1.Enabled := true;
    Addtonewdirectory1.Enabled := true;
    Adddirectorytree1.Enabled := true;
    DragAcceptFiles(MainForm.Handle, true); //only drop files when a pak is open
end;

procedure TMainForm.ShowBusy(msg : String);
begin
Label1.Caption := msg;
BusyPanel.Visible := True;
BusyPanel.Left := (Mainform.Width div 2)-(BusyPanel.Width div 2);
BusyPanel.Top := (Mainform.Height div 2)-(BusyPanel.Height div 2);
//Animate1.CommonAVI := Avi;
//Animate1.Active := True;
Application.Processmessages;
end;

procedure TMainForm.Hidebusy;
begin
BusyPanel.Visible := False;
//Animate1.Active := False;
end;

procedure TMainForm.AddIcons;
var i : integer;
    Icon : TIcon;
    buffer : string;
    cbuffer,ebuffer,tempBuffer : array [0..1024] of char;
    temp : Word;
    dummyfile : TextFile;
begin
//get the default icon
Buffer := 'dummy.qsd';

//get pak file icons
for i := 0 to NumFileTypes-1 do
         begin
         Icon := TIcon.Create;
         GetTempPath(1024,tempBuffer);
         Buffer := StrPas(tempBuffer)+'dummy'+FileTypes[i];
         assignfile(dummyfile,buffer); rewrite(dummyfile);
         writeln(dummyfile,'dummy'); closefile(dummyfile);
         temp := 1;
         //if there isn't a associated icon then use the default daipak file icon
         if FindExecutable(StrPCopy(cbuffer,buffer),'c:\',ebuffer) = 31 then
            begin
            //Icon.Free;
            ImageList1.GetIcon(0,Icon);
            ImageList1.AddIcon(Icon);
            Icon.Free;
            //
            Icon := TIcon.Create;
            ImageList2.GetIcon(0,Icon);
            ImageList2.AddIcon(Icon);
            end
            else
            begin
            Icon.handle := ExtractAssociatedIcon(HInstance,StrPCopy(cbuffer,buffer),@temp);
            if pointer(icon.handle) = nil then exit;
            ImageList1.AddIcon(Icon);
            ImageList2.AddIcon(Icon);
            end;
         Icon.Free;
         DeleteFile(buffer);
         end;
end;


procedure TMainForm.ShowAddDialog(FileDir : String);
begin
DestDir := FileDir;
AddForm.Show;
end;

procedure TMainForm.Open1Click(Sender: TObject);
begin
If OpenDialog1.Execute then
   begin
   Free_Pakfile;
   ListView1.Items.Clear;
   TreeView1.Items.Clear;
   case Init_pakfile(Opendialog1.Filename) of
               FILE_NOTFOUND : begin std_error('File not found',[nil]); exit; end;
               FILE_INVALID  : begin std_error('Invalid pak file',[nil]); exit; end;
               end;
   //PutList(ListView1,ProgressBar1);
   CreateTreeFromDir(TreeView1);
   EnableButtons;
   end;
end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
var ConfFile : TIniFile;
begin
ListView1.Items.BeginUpdate;
TreeView1.Items.BeginUpdate;
TreeView1.Items.Clear;
ListView1.Items.Clear;
TreeView1.Items.EndUpdate;
ListView1.Items.EndUpdate;            
Free_Pakfile;
//Save Configuration
ConfFile := TIniFile.Create(changefileext(application.exename,'.ini'));
ConfFile.WriteBool('Confirm','Delete',OptionsForm.CheckConfirmDelete.Checked);
ConfFile.WriteBool('Confirm','OverWrite',OptionsForm.CheckConfirmOverwrite.Checked);
ConfFile.WriteBool('Confirm','Update',OptionsForm.CheckConfirmUpdate.Checked);

ConfFile.WriteBool('Interface','Tree',TreeView1.Visible);
ConfFile.WriteBool('Interface','StatusBar',StatusBar1.Visible);
ConfFile.WriteBool('Interface','Messages',Memo1.Visible);
ConfFile.WriteInteger('Interface','IconMode',Integer(ListView1.ViewStyle));
ConfFile.Free;
end;

{procedure InterfaceExtractFile(FileName : String);
var destfile : string;
begin
   destfile := extractfiledir(PakFileName)+'\'+filenamedos(FileName);
   if fileexists(destfile) then
      if messagedlg('File already exists. Overwrite?',mtConfirmation,[mbYes,mbNo],0) = mrNo
         then exit;
   if not DirectoryExists(extractfiledir(destfile)) then
      begin
      std_write('Making directory %s',[extractfiledir(destfile)]);
      ForceDirectories(extractfiledir(destfile));
      end;
   std_write('Extracting file to %s',[destfile]);
   pakextractfile(FileName,destfile);
end;     }

procedure TMainForm.ListView1DblClick(Sender: TObject);
var TempNode : TTreeNode;
    i : integer;
begin
If ListView1.Selected <> nil then
If ListView1.Selected.ImageIndex in [2,3] then
   begin
     TempNode := TreeView1.Selected;
     if TempNode = Nil then Exit;
     if ListView1.Selected = nil then exit;
     for i := 0 to TempNode.Count-1 do
         begin
              if TempNode.Items[i].Text = ListView1.Selected.Caption then
                 begin
                 TreeView1.Selected := TempNode.Items[i];
                 exit;
                 end;
         end;
   end else
   with ListView1.Selected do
   begin
       InterfaceExtractFile(SubItems[0]);
   end;
end;

procedure TMainForm.ListView1Change(Sender: TObject; Item: TListItem;
  Change: TItemChange);
var ext : string;
begin
If ListView1.Selected = nil then exit;
if ListView1.Selected.Imageindex in [2,3] then
   ViewFileBtn.Enabled := false else ViewFileBtn.Enabled := true;
{pakassignresetfile(afile,ListView1.Selected.Caption,ofs,size,compsize,comptype);
Closefile(afile);
StatusBar1.Panels.Items[0].Text := 'File size: '+inttostr(size);
//StatusBar1.Panels.Items[1].Text := 'File offset: '+inttostr(ofs);
//StatusBar1.Panels.Items[2].Text := 'SO: '+inttostr(extradata.ofs2);
//StatusBar1.Panels.Items[3].Text := 'TO: : '+inttostr(extradata.ofs3);
//StatusBar1.Panels.Items[4].Text := 'FS2: '+inttostr(extradata.size2);
StatusBar1.Panels.Items[1].Text := 'Name: '+ListView1.Selected.Caption;
if comptype <> 0 then StatusBar1.Panels.Items[0].Text := StatusBar1.Panels.Items[0].Text +' (Uncompressed)';}
end;

procedure TMainForm.Info1Click(Sender: TObject);
begin
AboutBox.Showmodal;
//ShellAbout (MainForm.Handle,'DaiPak','Daikatana pak editor',application.icon.handle);

end;

procedure TMainForm.Icon1Click(Sender: TObject);
begin
ListView1.ViewStyle := vsIcon;
Icon1.Checked := True;
end;

procedure TMainForm.Smallicon1Click(Sender: TObject);
begin
ListView1.ViewStyle := vsSmallIcon;
SmallIcon1.Checked := True;
end;

procedure TMainForm.List1Click(Sender: TObject);
begin
ListView1.ViewStyle := vsList;
List1.Checked := True;
end;

procedure TMainForm.Exit1Click(Sender: TObject);
begin
Application.Terminate;
end;

procedure TMainForm.Details1Click(Sender: TObject);
begin
ListView1.ViewStyle := vsreport;
Details1.Checked := True;
end;

procedure TMainForm.Extractall1Click(Sender: TObject);
var i : integer;
cancel : boolean;
begin
ProgressBar1.Max := ListView1.Items.Count div 2;
ProgressBar1.Position := 0;
ShowBusy('Extracting all files (press esc. to cancel)');
cancel := False;
pakExtractAll(Cancel);
HideBusy;         
ProgressBar1.Position := 0;
end;

procedure TMainForm.Addtopak1Clic(Sender: TObject);
begin
ShowAddDialog('test/');
end;

procedure TMainForm.TreeView1Expanded(Sender: TObject; Node: TTreeNode);
begin
//Node.ImageIndex := 3;
end;

procedure TMainForm.TreeView1Collapsed(Sender: TObject; Node: TTreeNode);
begin
//Node.ImageIndex := 2;
end;

function getCurrentSelecedDir : String;
var tempnode : TTreeNode;
begin
with MainForm do
begin
tempnode := TreeView1.Selected;
if tempnode = nil then exit;
result := '';
if not(tempnode.imageindex in [2,3]) then exit;
while tempnode <> Nil do
      begin
      if tempnode.text <> '/' then //root node?
         result := tempnode.text+'/'+result;
      tempnode := tempnode.Parent;
      end;
end;
end;

function getDirFromNode(Node : TTreeNode) : String;
var tempnode : TTreeNode;
begin
tempnode := Node;
if tempnode = nil then exit;
result := '';
if not(tempnode.imageindex in [2,3]) then exit;
while tempnode <> Nil do
      begin
      if tempnode.text <> '/' then //root node?
         result := tempnode.text+'/'+result;
      tempnode := tempnode.Parent;
      end;
end;

procedure TMainForm.TreeView1Change(Sender: TObject; Node: TTreeNode);
var searchstring : string;
    tempnode : TTreeNode;
begin
//obsolete now since only directory's are added to the tree now

tempnode := Node;
searchstring := '';
if not(tempnode.imageindex in [2,3]) then begin ListView1.Items.Clear; exit; end;
{while tempnode <> Nil do
      begin
      if tempnode = node then searchstring := tempnode.text
                         else searchstring := tempnode.text+'/'+searchstring;
      tempnode := tempnode.Parent;
      end;
searchstring := searchstring+'/'; }
searchstring := getCurrentSelecedDir;
PutList(searchstring,ListView1);
StatusBar1.Panels[0].Text := 'Current dir: '+getCurrentSelecedDir;
end;

procedure TMainForm.FormCreate(Sender: TObject);
var
  ImageListHandle : THandle;
  FileInfo : TSHFileInfo;
begin
//Application.OnMessage := RespondToMessage;
AddIcons;
end;

procedure TMainForm.TreeView1DblClick(Sender: TObject);
var searchstring : string;
    tempnode,node : TTreeNode;
begin
node := TreeView1.Selected;
if node = nil then exit;
if node.imageindex in [2,3] then exit;
tempnode := Node.Parent;
searchstring := '';
while tempnode <> Nil do
      begin
      if tempnode = node then searchstring := tempnode.text
                         else searchstring := tempnode.text+'/'+searchstring;
      tempnode := tempnode.Parent;
      end;
searchstring := searchstring+Node.Text;
InterFaceExtractFile(SearchString);
end;

procedure TMainForm.ExtractFilesBtnClick(Sender: TObject);
var TempItem : TListItem;
    i : integer;
    cancel : boolean;
begin
cancel := false;
For i := 0 to ListView1.Items.Count-1 do
    begin
    TempItem := ListView1.Items[i];
    if TempItem.Selected then
       begin
       if not (TempItem.ImageIndex in [2,3]) then
       InterfaceExtractFile(TempItem.SubItems[0])
       else pakExtractDir(getCurrentSelecedDir+TempItem.Caption+'/',cancel);
       end;
    if cancel then exit;   
    end;
end;

procedure TMainForm.ExtractDirBtnClick(Sender: TObject);
var searchstring : string;
    cancel : boolean;
begin
searchstring := getCurrentSelecedDir;
CanWrite := False;
cancel := false;
ShowBusy('Extracting directory '+searchstring+' (press esc. to cancel)');
pakExtractDir(SearchString,cancel);
CanWrite := True;
if cancel = true then std_write('Action cancelled',[nil]);
HideBusy;
end;

procedure TMainForm.ViewFileBtnClick(Sender: TObject);
var SoundData : Pointer;
    FileSize,Result : Integer;
    filechar,temppath : array [0..255] of char;
    tempfile : string;
begin
if ListView1.Selected <> nil then
   if not (ListView1.Selected.ImageIndex in [2,3]) then
          begin
          if extractfileext(ListView1.Selected.SubItems[0]) = '.wav' then
             begin
             FileSize := 0;
             SoundData := PakGetFileData(ListView1.Selected.SubItems[0],FileSize);
             PlaySound(pchar(SoundData),0,SND_MEMORY);
             Freemem(SoundData);
             end
             else
             begin
             gettemppath(255,temppath);
             tempfile := temppath+'\dpkt_'+ListView1.Selected.Caption;
             pakExtractFile(ListView1.Selected.SubItems[0],tempfile);
             StrPCopy(filechar,tempfile);
             Result :=  ShellExecute(mainform.handle,nil,filechar,nil,'c:\',SW_SHOW);
             if result = SE_ERR_NOASSOC then
                std_error('There is no application associated with %s.',[extractfileext(tempfile)])
                else if result <= 32 then
                        std_error('Error launching file %s.',[ListView1.Selected.SubItems[0]]);
             MessageDlg('Click to delete the temporaly file when you have finished viewing it.',mtinformation,[mbOk],0);
             DeleteFile(tempfile);
             end;
          end;
end;

procedure TMainForm.ListView1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var p1 : TPoint;
begin
If Button = MbRight then
          begin
          P1.x := X;
          P1.y := Y;
          P1 := ListView1.ClientToScreen(P1);
          If ListView1.Selected = nil then exit;
          If ListView1.SelCount > 1 then MultiPopupMenu1.Popup(P1.x,P1.y)
             else
             If ListView1.Selected.ImageIndex in [2,3] then DirPopupMenu.Popup(P1.x,P1.y)
                else FilePopupMenu.Popup(P1.x,P1.y);
          end;
end;

procedure TMainForm.ImportFilesBtnClick(Sender: TObject);
begin
ShowAddDialog(getCurrentSelecedDir);
end;

procedure TMainForm.ImportDirBtnClick(Sender: TObject);
var ParentDir,NewDir : String;
begin
parentdir := getCurrentSelecedDir;
NewDir := 'NewDir';
if parentdir <> '' then
   begin
   if InputQuery('Add dir to '+ParentDir,'Enter the name for the new directory',
              NewDir) then
              begin
              if not ValidDirName(NewDir) then exit;
              ShowAddDialog(ParentDir+NewDir+'/');
              end;
   end
   else
   begin
   if InputQuery('Add dir to /','Enter the name for the new directory',
              NewDir) then
              begin
              if not ValidDirName(NewDir) then exit;
              ShowAddDialog(ParentDir+NewDir+'/');
              end;
   end;
end;

procedure TMainForm.Extract3Click(Sender: TObject);
var searchstring : string;
    cancel : boolean;
begin
if ListView1.Selected = nil then exit;
searchstring := getCurrentSelecedDir+ListView1.Selected.Caption+'/';
CanWrite := False;
cancel := false;
ShowBusy('Extracting directory '+searchstring+' (press esc. to cancel)');
pakExtractDir(SearchString,cancel);
CanWrite := True;
if cancel = true then std_write('Action cancelled',[nil]);
HideBusy;
end;

procedure TMainForm.NewPakBtnClick(Sender: TObject);
begin
If SaveDialog1.Execute then
   begin
   pakBeginNew(SaveDialog1.Filename);
   EnableButtons;
   end;

end;

function checkcancelled : boolean;
var keyboardstate : tkeyboardstate;
begin
result := false;
Getkeyboardstate(keyboardstate);
if getasynckeystate(VK_ESCAPE) and $0F <> 0 then begin result := true; exit; end;
if (keyboardstate[VK_ESCAPE] and $F0) <> 0 then begin result := true; exit; end;
end;

procedure TMainForm.DeleteFileBtnClick(Sender: TObject);
var TempItem : TListItem;
    i : integer;
begin
if ListView1.Selected = nil then exit;

ShowBusy('Deleting files, this can take a long time...');
for i := 0 to ListView1.Items.Count -1 do
   begin
   TempItem := ListView1.Items[i];
   If not TempItem.Selected then Continue;
   if TempItem.ImageIndex in [2,3] then
   begin
   std_write('Directory''s not supported yet.',[Nil]);
   end
   else
   begin
   if OptionsForm.CheckConfirmDelete.Checked then
      if messagedlg('Are you sure you want to delete '+
                    TempItem.SubItems[0]+'?',mtConfirmation,
                    [mbYes,mbNo],0) = mrNo then break;
   pakDeleteFile(TempItem.SubItems[0]);
   if checkcancelled then break;
   end;
   end;//for
HideBusy;
CreateTreeFromDir(MainForm.TreeView1);
end;

procedure TMainForm.Rename1Click(Sender: TObject);
var NewName,NewPath : String;
begin
if ListView1.Selected = nil then exit;
if ListView1.Selected.ImageIndex in [2,3] then
   begin
   NewName := ListView1.Selected.Caption;
   if InputQuery('Rename','Enter the new directory name.',NewName) then
      begin
      if not ValidDirName(Newname) then exit;
      pakRenamedir(getCurrentSelecedDir+ListView1.Selected.Caption+'/',
                   getCurrentSelecedDir+NewName+'/');
      pakSaveFile;
      end;
   end else
   begin
   NewName := ExtractFileName(FileNameDos(ListView1.Selected.SubItems[0]));
   if InputQuery('Rename','Enter the new file name.',NewName) then
      begin
      if not ValidFileName(Newname) then exit;
      pakRenameFile(ListView1.Selected.SubItems[0],getCurrentSelecedDir+NewName);
      pakSaveFile;
      end;
   end;
end;

procedure TMainForm.TreeView1DragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
begin
Accept := False;
If (Source.ClassType = TListView) or (Source.ClassType = TTreeView) then accept := true;
end;

procedure TMainForm.TreeView1DragDrop(Sender, Source: TObject; X,
  Y: Integer);
var RenameFile,NewName : String;
    TempNode : TTreeNode;
    i : integer;
    CurrentItem : TListItem;
    StartDir : String;
begin
If Source.ClassType = TListView then
begin
     StartDir := getCurrentSelecedDir;
     For i := 0 to TlistView(Source).Items.Count-1 do
     begin
     CurrentItem := TlistView(Source).Items[i];
     if CurrentItem = nil then continue;
     if CurrentItem.Selected = False then continue;
     if CurrentItem.ImageIndex in [2,3] then
     //directory dragging
        begin
        RenameFile := StartDir+CurrentItem.Caption;
        NewName := CurrentItem.Caption;
        TempNode := TreeView1.GetNodeAt(X,Y);
        if TempNode = Nil then break;
        //TreeView1.Selected := TempNode;
        pakRenameDir(RenameFile,getDirFromNode(TempNode)+NewName);
        end
        else
     //fille dragging
        begin
        RenameFile := CurrentItem.SubItems[0];//save it since changing the tree.seleced
                                        //wil also change listview.selected
        TempNode := TreeView1.GetNodeAt(X,Y);
        if TempNode = Nil then break;
        //TreeView1.Selected := TempNode;
        NewName := ExtractFileName(FileNameDos(RenameFile));
        pakRenameFile(RenameFile,getDirFromNode(TempNode)+NewName);
        end;
     end;//for
     pakSaveFile;//only save and update tree once
end else
begin
with source as TTreeView do
     begin
     if Selected = Nil Then Exit;
     RenameFile := getCurrentSelecedDir;
     NewName := Selected.Text;
     TempNode := TreeView1.GetNodeAt(X,Y);
     if TempNode = Nil then exit;
     TreeView1.Selected := TempNode;
     pakRenameDir(RenameFile,getCurrentSelecedDir+NewName+'/');
     pakSaveFile;
     end;
end;
end;

procedure TMainForm.ListView1DragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
begin
If Source.ClassType <> TListView then Accept := False;
end;

procedure TMainForm.ListView1DragDrop(Sender, Source: TObject; X,
  Y: Integer);
var RenameFile,NewName : String;
    TempNode,CurrentItem : TListItem;
    i : Integer;
    startdir : string;
begin
If Source.ClassType <> TListView then Exit;
with source as TListView do
     begin
     For i := 0 to Items.Count-1 do
     begin
     CurrentItem := Items[i];
     if CurrentItem.Selected = False then continue;

     //directory
     if CurrentItem.ImageIndex in [2,3] then
        begin
        RenameFile := getCurrentSelecedDir+CurrentItem.Caption;
        TempNode := ListView1.GetItemAt(X,Y);
        if TempNode = Nil then break;
        if TempNode.ImageIndex in [2,3] then
           begin
           pakRenameDir(RenameFile,
                        getCurrentSelecedDir+TempNode.Caption+'/'+
                        CurrentItem.caption);
           end else std_write('Can''t drag to a file.',[nil]);
        end

        else
      //file
        begin
        RenameFile := CurrentItem.SubItems[0];//save it since changint the tree.seleced
                                        //wil also change listview.selected
        TempNode := ListView1.GetItemAt(X,Y);
        if TempNode = Nil then break;
        if TempNode.ImageIndex in [2,3] then
           begin
           NewName := ExtractFileName(FileNameDos(RenameFile));
           pakRenameFile(RenameFile,getCurrentSelecedDir+TempNode.Caption+'/'+NewName);
           end else std_write('Can''t drag to a file.',[nil]);
        end;


     end;//for
     pakSaveFile;//only save and update the tree once
     end;
end;

procedure TMainForm.DirUpBtnClick(Sender: TObject);
begin
if TreeView1.Selected = nil then exit;
if TreeView1.Selected.Parent <> nil then
   TreeView1.Selected := TreeView1.Selected.Parent;
end;

procedure TMainForm.TreeView2Click(Sender: TObject);
begin
TreeView1.Visible := Not TreeView1.Visible;
TreeView2.Checked := TreeView1.Visible;
end;

procedure TMainForm.BusyPanelClick(Sender: TObject);
begin
HideBusy;
end;

procedure TMainForm.Messages1Click(Sender: TObject);
begin
Memo1.Visible := Not Memo1.Visible;
Messages1.Checked := Memo1.Visible;
end;

procedure TMainForm.StatusBar2Click(Sender: TObject);
begin
StatusBar1.Visible := Not StatusBar1.Visible;
StatusBar2.Checked := StatusBar1.Visible;
end;

procedure TMainForm.Options1Click(Sender: TObject);
begin
OptionsForm.ShowModal;
end;

procedure TMainForm.ListView1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
case Key of
         VK_DELETE: DeleteFileBtnClick(Sender);
         end;//case;
end;

procedure TMainForm.Movetonewdirectory1Click(Sender: TObject);
var newname : string;
begin
if ListView1.Selected = nil then exit;
if ListView1.Selected.ImageIndex in [2,3] then
   begin
   NewName := 'NewDir';
   if InputQuery('Move to new directory','Enter the new directory name.',NewName) then
      begin
      if not ValidDirName(Newname) then exit;
      pakRenamedir(getCurrentSelecedDir+ListView1.Selected.Caption+'/',
                   getCurrentSelecedDir+NewName+'/'+ListView1.Selected.Caption+'/');
      pakSaveFile;
      end;
   end else
   begin
   NewName := 'NewDir';
   if InputQuery('Move to new directory','Enter the new directory name.',NewName) then
      begin
      if not ValidDirName(Newname) then exit;
      pakRenameFile(ListView1.Selected.SubItems[0],getCurrentSelecedDir+NewName
                    +'/'+ListView1.Selected.Caption);
      pakSaveFile;
      end;
   end;
end;

procedure TMainForm.ImportAllBtnClick(Sender: TObject);
begin
AddDirForm.ShowModal;
end;

procedure TMainForm.SelectAll1Click(Sender: TObject);
var i : Integer;
begin
Activecontrol := ListView1;
for i := 0 to ListView1.Items.Count -1 do
    begin
    ListView1.Items[i].Selected := True;
    end;
end;

procedure TMainForm.InvertSelection1Click(Sender: TObject);
var i : Integer;
begin
Activecontrol := ListView1;
for i := 0 to ListView1.Items.Count -1 do
    begin
    ListView1.Items[i].Selected := not ListView1.Items[i].Selected;
    end;
end;

procedure TMainForm.Readme1Click(Sender: TObject);
var filechar : array[0..255] of char;
    filestring : string;
    result : integer;
begin
filestring := extractfiledir(application.exename)+'\readme.htm';
StrPCopy(filechar,filestring);
Result :=  ShellExecute(mainform.handle,nil,filechar,nil,'c:\',SW_SHOW);
if result = SE_ERR_NOASSOC then
   std_error('No html viewer installed, you can get those for free!!',[nil])
   else if result <= 32 then
   std_error('Error launching help',[nil]);

end;

procedure TMainForm.Movetonewdirectory3Click(Sender: TObject);
var newname : string;
    i : integer;
    TempItem : TListItem;
begin
NewName := 'NewDir';
if not InputQuery('Move to new directory','Enter the new directory name.',NewName) then exit;
for i := 0 to ListView1.Items.Count-1 do
  begin
   TempItem := ListView1.Items[i];
   if not TempItem.Selected then continue;
   if TempItem.ImageIndex in [2,3] then
   begin
      if not ValidDirName(Newname) then continue;
      pakRenamedir(getCurrentSelecedDir+TempItem.Caption+'/',
                   getCurrentSelecedDir+NewName+'/'+TempItem.Caption+'/');
   end else
   begin
      if not ValidDirName(Newname) then continue;
      pakRenameFile(TempItem.SubItems[0],getCurrentSelecedDir+NewName
                    +'/'+TempItem.Caption);
   end;
  end;
pakSaveFile;
end;

const BUFFLEN = 255;
type CHARARRAY = array[0..BUFFLEN] of char;

function getLastDir(dir : string) : string;
var i : integer;
begin
result := '';
for i := length(dir) downto 1 do
    if dir[i] <> '\' then result := dir[i]+ result else exit;
end;

procedure TMainForm.RespondToMessage(var Msg: Tmsg; var Handled: Boolean);
{ Iterate through all file names if a multi-file selection was dropped }
const
  FileIndex : Cardinal = Cardinal(-1);   { return a count of dropped files }
var                                      { $FFFF 16-bit;  $FFFFFFFF 32-bit }
  buffer : CHARARRAY;
  fname : string;
  fnum  : word;
begin
   if Msg.Message = WM_DROPFILES then
   begin
      MainForm.ShowBusy('Adding Files to pak');
      for fnum := 0 to DragQueryFile(Msg.WParam, FileIndex, NIL, BUFFLEN)-1 do
      begin
         DragQueryFile(Msg.WParam, fnum, buffer, BUFFLEN);
         fname  := StrPas(buffer);
         if DirectoryExists(fname) then
            begin
            std_write('Dropped directory %s',[fname]);
            RAddDir(fname+'\*',getCurrentSelecedDir+getLastDir(fname)+'/');
            end
            else
            begin
            std_write('Dropped file %s',[fname]);
            pakAddFile(fname,getCurrentSelecedDir+extractfilename(fname));
            end;
      end;
      pakSaveFile;
      MainForm.HideBusy;
    DragFinish(Msg.WParam);
    Handled := True;
   end;
end;
procedure TMainForm.Refresh1Click(Sender: TObject);
begin
pakSaveFile;
end;

end.
