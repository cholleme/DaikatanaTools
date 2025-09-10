program modelview;

{$MODE Delphi}

uses
  Forms, Interfaces,
  modelu in 'modelu.pas' {MainForm},
  viewu in 'viewu.pas' {ViewForm},
  models in 'models.pas',
  pakfiles in 'pakfiles.pas',  
  Mesu in 'Mesu.pas' {Messageform},
  texu in 'texu.pas' {WireForm},
  frameu in 'frameu.pas' {FrameForm},
  aboutu in 'aboutu.pas' {AboutBox},
  daiwals in 'daiwals.pas',
  optu in 'optu.pas' {OptionsForm},
  textures in 'textures.pas',
  skinu in 'skinu.pas' {SkinForm};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TViewForm, ViewForm);
  Application.CreateForm(TMessageform, Messageform);
  Application.CreateForm(TWireForm, WireForm);
  Application.CreateForm(TFrameForm, FrameForm);
  Application.CreateForm(TAboutBox, AboutBox);
  Application.CreateForm(TOptionsForm, OptionsForm);
  Application.CreateForm(TSkinForm, SkinForm);
  Application.Run;
end.
