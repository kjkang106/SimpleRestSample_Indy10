unit UDmRestSvr;

interface

uses
  SysUtils, Classes, IdContext, IdHeaderList, IdCustomHTTPServer, IdComponent,
  IdBaseComponent, IdCustomTCPServer, IdHTTPServer,
  ExtCtrls, IdServerIOHandler, IdSSL, IdSSLOpenSSL,
  UGlobalType;

type
  TDmRestSvr = class(TDataModule)
    IdHTTPServer: TIdHTTPServer;
    IdServerIOHandlerSSLOpenSSL: TIdServerIOHandlerSSLOpenSSL;
    procedure DataModuleDestroy(Sender: TObject);
    procedure IdHTTPServerException(AContext: TIdContext;
      AException: Exception);
    procedure DataModuleCreate(Sender: TObject);
    procedure IdHTTPServerCommandGet(AContext: TIdContext;
      ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
    procedure IdHTTPServerConnect(AContext: TIdContext);
    procedure IdServerIOHandlerSSLOpenSSLGetPassword(var Password: string);
    procedure IdHTTPServerQuerySSLPort(APort: Word; var VUseSSL: Boolean);
  private
    { Private declarations }
    FSvrLogEvent    : TLogEvent;
    FTranLogEvent   : TLogEvent;
    procedure WriteSvrLog(msg: string);
    procedure WriteTranLog(msg: string);

    function  CheckAuthPass(ARequestInfo: TIdHTTPRequestInfo;
      var AResponseInfo: TIdHTTPResponseInfo): Boolean;
  public
    { Public declarations }
    procedure RestSvrActivate(Active: Boolean);

    property SvrLogEvent    : TLogEvent          read FSvrLogEvent     write FSvrLogEvent;
    property TranLogEvent   : TLogEvent          read FTranLogEvent    write FTranLogEvent;
  end;

var
  DmRestSvr: TDmRestSvr;

implementation

uses URestSvrProc, UInfoIni;

const
  AUTH_USER = 'admin';
  AUTH_PASS = '1234';

{$R *.dfm}

function TDmRestSvr.CheckAuthPass(ARequestInfo: TIdHTTPRequestInfo;
  var AResponseInfo: TIdHTTPResponseInfo): Boolean;
begin
  Result:=
    (ARequestInfo.AuthExists) and
    (CompareText(ARequestInfo.AuthUsername, AUTH_USER) = 0) and
    (CompareText(ARequestInfo.AuthPassword, AUTH_PASS) = 0);
  if not Result then
  begin
    AResponseInfo.ResponseNo  := 401;
    AResponseInfo.CustomHeaders.Values['WWW-Authenticate']:= 'Basic';
    AResponseInfo.AuthRealm   := 'Simple Rest Server';
  end;
end;

procedure TDmRestSvr.DataModuleCreate(Sender: TObject);
begin
  FSvrLogEvent := nil;
  FTranLogEvent:= nil;

  IdServerIOHandlerSSLOpenSSL.SSLOptions.KeyFile     := GetDataPath + 'SimpleRest.key';
  IdServerIOHandlerSSLOpenSSL.SSLOptions.CertFile    := GetDataPath + 'SimpleRest.crt';
  IdServerIOHandlerSSLOpenSSL.SSLOptions.RootCertFile:= GetDataPath + 'SimpleRest-RootCA.pem';
end;

procedure TDmRestSvr.DataModuleDestroy(Sender: TObject);
begin
  RestSvrActivate(False);

  FSvrLogEvent := nil;
  FTranLogEvent:= nil;
end;

procedure TDmRestSvr.IdHTTPServerCommandGet(AContext: TIdContext;
  ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
begin
  WriteTranLog(AContext.Connection.Socket.Binding.PeerIP +
    ' CommandGet : ' + ARequestInfo.URI);

  if not CheckAuthPass(ARequestInfo, AResponseInfo) then
  begin
    WriteTranLog(IntToStr(AResponseInfo.ResponseNo) + ' ' + AResponseInfo.ResponseText);
    Exit;
  end;

  if not ExecuteURI(AContext, ARequestInfo, AResponseInfo, WriteTranLog) then
    WriteTranLog(IntToStr(AResponseInfo.ResponseNo) + ' ' + AResponseInfo.ResponseText);
end;

procedure TDmRestSvr.IdHTTPServerConnect(AContext: TIdContext);
begin
  { THESE TWO LINES ARE CRITICAL TO MAKING THE IdTCPSERVER WORK WITH SSL! }
  if (AContext.Connection.IOHandler is TIdSSLIOHandlerSocketBase) then
    TIdSSLIOHandlerSocketBase(AContext.Connection.IOHandler).PassThrough:= False;
end;

procedure TDmRestSvr.IdHTTPServerException(AContext: TIdContext;
  AException: Exception);
begin
  WriteSvrLog(AContext.Connection.Socket.Binding.PeerIP +
    ' Raise Execption : ' + AException.Message);
end;

procedure TDmRestSvr.IdHTTPServerQuerySSLPort(APort: Word;
  var VUseSSL: Boolean);
begin
  VUseSSL:= (APort = 443);
end;

procedure TDmRestSvr.IdServerIOHandlerSSLOpenSSLGetPassword(
  var Password: string);
begin
  Password:= AUTH_PASS;
end;

procedure TDmRestSvr.RestSvrActivate(Active: Boolean);
begin
  if IdHTTPServer.Active = Active then
    Exit;

  //모든 연결을 끊는 과정에서 IdThread에서 Exception이 리턴 되면,
  //Log 기록시 사용하는 Synchronize에 의해 무한 루프에 빠질 수 있음
  if Active then
  begin
    IdHTTPServer.OnException := IdHTTPServerException;
  end
  else
  begin
    IdHTTPServer.OnException := nil;
  end;
  IdHTTPServer.Active:= Active;
end;

procedure TDmRestSvr.WriteSvrLog(msg: string);
begin
  if Assigned(FSvrLogEvent) then
    FSvrLogEvent(msg);
end;

procedure TDmRestSvr.WriteTranLog(msg: string);
begin
  if Assigned(FTranLogEvent) then
    FTranLogEvent(msg);
end;

end.
