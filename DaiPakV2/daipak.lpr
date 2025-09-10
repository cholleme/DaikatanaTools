//******************************************************************************
//
// Daikatana Pack Reader
// 1999 Charles Hollemeesch
//
//******************************************************************************

{Todo List;
Popupmenus for multiple files (use dir popup)
-Directory delete (display empty first instead)
-Update file option
-IniFile!!!
-View current dir in tree after tree update
--Eventually rewrite pak procedures using getpakentry
--Some help
}
program daipak;

{$MODE Delphi}

uses
  Forms, Interfaces,
  mainu in 'mainu.pas' {MainForm},
  pakfiles in 'pakfiles.pas',
  aboutu in 'aboutu.pas' {AboutBox},
  addu in 'addu.pas' {AddForm},
  optu in 'optu.pas' {OptionsForm},
  adddiru in 'adddiru.pas' {AddDirForm};
{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TAboutBox, AboutBox);
  Application.CreateForm(TAddForm, AddForm);
  Application.CreateForm(TOptionsForm, OptionsForm);
  Application.CreateForm(TAddDirForm, AddDirForm);
  Application.Run;
end.
