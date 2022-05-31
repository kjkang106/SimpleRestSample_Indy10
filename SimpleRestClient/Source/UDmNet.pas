unit UDmNet;

interface

uses
  SysUtils, Classes, IdAntiFreezeBase, IdAntiFreeze, IdIOHandler,
  IdIOHandlerSocket, IdIOHandlerStack, IdSSL, IdSSLOpenSSL, IdBaseComponent,
  IdComponent, IdTCPConnection, IdTCPClient, IdHTTP, IdURI, IdGlobal,
  UGlobalType;

type
  TDmNet = class(TDataModule)
    IdHTTP: TIdHTTP;
    IdSSLIOHandlerSocketOpenSSL: TIdSSLIOHandlerSocketOpenSSL;
    IdAntiFreeze: TIdAntiFreeze;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    { Private declarations }
    FLogEvent   : TLogEvent;
    procedure WriteLog(msg: string);
    function  HttpTran(Method, Url, Id, Pass, PostData: string; out OutStr: string): Integer;
  public
    { Public declarations }
    function HttpPost(Url, Id, Pass, PostData: string; out OutStr: string): Integer;
    function HttpGet (Url, Id, Pass, PostData: string; out OutStr: string): Integer;

    property LogEvent   : TLogEvent          read FLogEvent    write FLogEvent;
  end;

var
  DmNet: TDmNet;

implementation

{$R *.dfm}

procedure TDmNet.DataModuleCreate(Sender: TObject);
begin
  FLogEvent:= nil;
end;

procedure TDmNet.DataModuleDestroy(Sender: TObject);
begin
  FLogEvent:= nil;
end;

function TDmNet.HttpGet(Url, Id, Pass, PostData: string;
  out OutStr: string): Integer;
var
  Method: string;
begin
  Method:= 'GET';
  Result:= HttpTran(Method, Url, Id, Pass, PostData, OutStr);
end;

function TDmNet.HttpPost(Url, Id, Pass, PostData: string;
  out OutStr: string): Integer;
var
  Method: string;
begin
  Method:= 'POST';
  Result:= HttpTran(Method, Url, Id, Pass, PostData, OutStr);
end;

function TDmNet.HttpTran(Method, Url, Id, Pass, PostData: string;
  out OutStr: string): Integer;
var
  slSend,
  slResponse : TStringStream;
  rbStr      : RawByteString;
begin
  Result:= -1;
  if Url = '' then
    Exit;

  WriteLog('SEND - ' + PostData);
  if Method = 'POST' then
  begin
    slSend    := TStringStream.Create(PostData, TEncoding.UTF8);
  end
  else if Method = 'GET' then
  begin
    if PostData <> '' then
      Url:= TIdURI.URLEncode(Url + '?' + PostData, IndyTextEncoding_UTF8);
  end
  else
    Exit;

  slResponse:= TStringStream.Create;
  try
    if Id <> '' then
    begin
      IdHTTP.Request.BasicAuthentication:= True;
      IdHTTP.Request.Username:= Id;
      IdHTTP.Request.Password:= Pass;
    end;

    IdHTTP.ConnectTimeout  :=  5000;
    IdHTTP.ReadTimeout     := 60000;
    try
      if Method = 'GET' then
        IdHTTP.Get (Url, slResponse)
      else if Method = 'POST' then
        IdHTTP.Post(Url, slSend, slResponse);
    except
      on E: Exception do
      begin
        Result:= -2;
        OutStr:= E.Message;
        WriteLog(' Raise Execption : ' + E.Message);
        Exit;
      end;
    end;

    rbStr := '';
    slResponse.Position:= 0;
    SetLength(rbStr, slResponse.Size);
    slResponse.ReadBuffer(rbStr[1], slResponse.Size);
    SetCodePage(rbstr, 65001, False);   //Unicode

    Result:= 1;
    OutStr:= String(rbStr);
    WriteLog('RECV - ' + OutStr);
  finally
    if Method = 'POST' then
      slSend.Free;
    slResponse.Free;
  end;
end;

procedure TDmNet.WriteLog(msg: string);
begin
  if Assigned(FLogEvent) then
    FLogEvent(msg)
end;

end.
