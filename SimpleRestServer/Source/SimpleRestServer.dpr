program SimpleRestServer;

uses
  Forms,
  UMain in 'UMain.pas' {FMain},
  USaveLog in 'Common\USaveLog.pas',
  UDmRestSvr in 'Rest\UDmRestSvr.pas' {DmRestSvr: TDataModule},
  URestSvrClass in 'Rest\URestSvrClass.pas',
  URestSvrObj in 'Rest\URestSvrObj.pas',
  UDBUtil in 'Rest\DBO\UDBUtil.pas',
  UDmDB in 'Rest\DBO\UDmDB.pas' {DmDB: TDataModule},
  URest_DBO_Select in 'Rest\DBO\URest_DBO_Select.pas',
  URest_Membership_GetMemberPoint in 'Rest\MemberShip\URest_Membership_GetMemberPoint.pas',
  URest_Membership_UseMemberPoint in 'Rest\MemberShip\URest_Membership_UseMemberPoint.pas',
  UInfoIni in 'Common\UInfoIni.pas',
  UGlobalType in 'Common\UGlobalType.pas',
  URestSvrProc in 'Rest\URestSvrProc.pas',
  UJsonUtil in 'Common\UJsonUtil.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TDmRestSvr, DmRestSvr);
  Application.CreateForm(TDmDB, DmDB);
  Application.CreateForm(TFMain, FMain);
  Application.Run;
end.
