unit Mesu;

{$MODE Delphi}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TMessageform = class(TForm)
    Memo1: TMemo;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Messageform: TMessageform;

implementation

uses modelu;

{$R *.lfm}

procedure TMessageform.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
MainForm.Messages1.Checked := false;
end;

end.
