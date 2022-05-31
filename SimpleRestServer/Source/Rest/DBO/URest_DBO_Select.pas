unit URest_DBO_Select;

interface

uses
  Classes, SysUtils, IdCustomHTTPServer, IdURI,
  URestSvrObj;

type
  TRest_DBO_Select = class(TRestSvrObj)
  private
  protected
  public
    constructor Create; override;
    destructor Destroy; override;

    function ExecuteURI: Boolean; override;
  end;

implementation

uses UDmDB, UInfoIni, UDBUtil;


{ TRest_DBO_Select }

constructor TRest_DBO_Select.Create;
begin
  inherited;

end;

destructor TRest_DBO_Select.Destroy;
begin

  inherited;
end;

function TRest_DBO_Select.ExecuteURI: Boolean;
var
  ReqParam: string;
  RtnContent: string;
begin
  Result:= False;
//  if RequestInfo.CommandType <> hcPOST then
//  begin
//    ResponseInfo.ResponseNo:= 405;
//    Exit;
//  end;

  GetReqParam(ReqParam);

  if Trim(ReqParam) = '' then
  begin
    if InfoIni.DBInfo.DriverID = 'Ora' then
      ReqParam:= 'SELECT sysdate AS SVRDTM FROM DUAL'
    else
      ReqParam:= 'SELECT GETDATE() AS SVRDTM';
  end;
  if CompareText('SELECT', Copy(ReqParam, 1, 6)) <> 0 then
  begin
    ResponseInfo.ResponseNo:= 400;
    Exit;
  end;

  if DmDB.DbConnect then
  begin
    if DmDB.OpenSQL(DmDB.adqRead, ReqParam) then
    begin
      ResponseInfo.ResponseNo:= 200;
      RtnContent:= GetJsonResultSet(DmDB.adqRead);
    end
    else
    begin
      ResponseInfo.ResponseNo:= 400;
      WriteLog(DmDB.ErrMsg);
    end;
    DmDB.adqRead.Close;
  end
  else
  begin
    ResponseInfo.ResponseNo:= 500;
    WriteLog(DmDB.ErrMsg);
  end;

  if ResponseInfo.ResponseNo = 200 then
  begin
    Result:= True;
    SetRtnContents(RtnContent);
  end;
end;

end.
