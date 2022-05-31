unit URestSvrObj;

interface

uses
  Classes, SysUtils, IdContext, IdCustomHTTPServer, IdURI,
  UGlobalType;

type
  TRestSvrObj = class(TPersistent)
  protected
  public
    FContext     : TIdContext;
    FRequestInfo : TIdHTTPRequestInfo;
    FResponseInfo: TIdHTTPResponseInfo;
    FLogEvent    : TLogEvent;

    constructor Create; virtual;
    destructor Destroy; virtual;

    procedure WriteLog(msg: string);
    procedure GetReqParam(out ReqParam: string);
    procedure SetRtnContents(RtnContent: string);
    function ExecuteURI: Boolean; virtual; abstract;

    property Context     : TIdContext            read FContext       write FContext;
    property RequestInfo : TIdHTTPRequestInfo    read FRequestInfo   write FRequestInfo;
    property ResponseInfo: TIdHTTPResponseInfo   read FResponseInfo  write FResponseInfo;
    property LogEvent    : TLogEvent             read FLogEvent      write FLogEvent;

  end;

implementation

{ TRestSvrObj }

constructor TRestSvrObj.Create;
begin
  FContext     := nil;
  FRequestInfo := nil;
  FResponseInfo:= nil;
  FLogEvent    := nil;
end;

destructor TRestSvrObj.Destroy;
begin
  FContext     := nil;
  FRequestInfo := nil;
  FResponseInfo:= nil;
  FLogEvent    := nil;
end;

procedure TRestSvrObj.GetReqParam(out ReqParam: string);
var
  slParams: TStringStream;
begin
  if RequestInfo = nil then
    Exit;

  if Assigned(RequestInfo.PostStream) then
  begin
    slParams:= TStringStream.Create;
    try
      slParams.LoadFromStream(RequestInfo.PostStream);
      ReqParam:= slParams.DataString;
    finally
      FreeAndNil(slParams);
    end;
  end
  else if RequestInfo.QueryParams <> '' then
  begin
    ReqParam:= TIdURI.URLDecode(RequestInfo.QueryParams);
  end
  else
    ReqParam:= '';

  WriteLog('Received - ' + ReqParam);
end;

procedure TRestSvrObj.SetRtnContents(RtnContent: string);
begin
  ResponseInfo.ContentType  := 'application/json';
  ResponseInfo.CharSet      := 'utf-8';
  ResponseInfo.ContentStream:= TStringStream.Create(RtnContent, TEncoding.UTF8);

  WriteLog('Response - ' + RtnContent);
end;

procedure TRestSvrObj.WriteLog(msg: string);
begin
  if Assigned(FLogEvent) then
    FLogEvent(msg);
end;

end.
