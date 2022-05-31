unit URestSvrProc;

interface

uses
  Classes, SysUtils,
  IdContext, IdCustomHTTPServer,
  UGlobalType;

function ExecuteURI(var AContext: TIdContext;
  var ARequestInfo: TIdHTTPRequestInfo; var AResponseInfo: TIdHTTPResponseInfo;
  ALogEvent: TLogEvent) : Boolean;

implementation

uses URestSvrClass, URestSvrObj;

function GetClsName(URI: string): string;
var
  idx: Integer;
begin
  Result:= '';
  for idx:= Low(zURIList) to High(zURIList) do
  begin
    if CompareText(zURIList[idx, 0], URI) = 0 then
    begin
      Result:= zURIList[idx, 1];
      Exit;
    end;
  end;
end;

function ExecuteURI(var AContext: TIdContext;
  var ARequestInfo: TIdHTTPRequestInfo; var AResponseInfo: TIdHTTPResponseInfo;
  ALogEvent: TLogEvent) : Boolean;
var
  ClsName: string;
  FType: TPersistentClass;
  RestSvrObj: TRestSvrObj;
begin
  Result:= False;
  ClsName:= GetClsName(ARequestInfo.URI);
  if ClsName = '' then
  begin
    AResponseInfo.ResponseNo:= 404;
    Exit;
  end;
  FType:= FindClass(ClsName);
  if FType = nil then
  begin
    AResponseInfo.ResponseNo:= 500;
    Exit;
  end;
  RestSvrObj:= TRestSvrObj(FType.Create);
  RestSvrObj.LogEvent    := ALogEvent;
  RestSvrObj.Context     := AContext;
  RestSvrObj.RequestInfo := ARequestInfo;
  RestSvrObj.ResponseInfo:= AResponseInfo;

  Result:= RestSvrObj.ExecuteURI;
end;

end.
