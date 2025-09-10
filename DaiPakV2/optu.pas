unit optu;

{$MODE Delphi}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, comctrls, IniFiles;

type
  TOptionsForm = class(TForm)
    CheckConfirmDelete: TCheckBox;
    CheckConfirmOverwrite: TCheckBox;
    CheckConfirmUpdate: TCheckBox;
    BitBtn1: TBitBtn;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  OptionsForm: TOptionsForm;

implementation

uses mainu;

{$R *.lfm}

procedure TOptionsForm.FormCreate(Sender: TObject);
var ConfFile : TIniFile;
begin
ConfFile := TIniFile.Create(changefileext(application.exename,'.ini'));

OptionsForm.CheckConfirmDelete.Checked :=
                                       ConfFile.ReadBool('Confirm','Delete',True);

OptionsForm.CheckConfirmOverwrite.Checked :=
                                       ConfFile.ReadBool('Confirm','OverWrite',True);

OptionsForm.CheckConfirmUpdate.Checked :=
                                       ConfFile.ReadBool('Confirm','Update',True);
With MainForm Do
begin
TreeView1.Visible := ConfFile.ReadBool('Interface','Tree',True);
TreeView2.Checked := TreeView1.Visible;

StatusBar1.Visible := ConfFile.ReadBool('Interface','StatusBar',True);
StatusBar2.Checked := StatusBar1.Visible;

Memo1.Visible := ConfFile.ReadBool('Interface','Messages',True);
Messages1.Checked := Memo1.Visible;

ListView1.ViewStyle :=
                    TViewStyle(ConfFile.ReadInteger('Interface','IconMode',integer(vsList)));
case ListView1.ViewStyle of
     vsIcon     : Icon1.Checked := True;
     vsSmallIcon: SmallIcon1.Checked := True;
     vsList     : List1.Checked := True;
     vsReport   : Details1.Checked := True;
     end;//case
end;
ConfFile.Free;
end;

end.
