program SimpleRestClient;

uses
  Forms,
  UMain in 'UMain.pas' {FMain},
  UDmNet in 'UDmNet.pas' {DmNet: TDataModule},
  UGlobalType in 'Common\UGlobalType.pas',
  USaveLog in 'Common\USaveLog.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TDmNet, DmNet);
  Application.CreateForm(TFMain, FMain);
  Application.Run;
end.
