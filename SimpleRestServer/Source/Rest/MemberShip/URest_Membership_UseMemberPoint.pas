unit URest_Membership_UseMemberPoint;

interface

uses
  Classes, SysUtils, IdCustomHTTPServer, IdURI,
  URestSvrObj;

type
  TRest_Membership_UseMemberPoint = class(TRestSvrObj)
  private
  protected
  public
    constructor Create; override;
    destructor Destroy; override;

    function ExecuteURI: Boolean; override;
  end;

implementation

{ TRest_Membership_UseMemberPoint }

constructor TRest_Membership_UseMemberPoint.Create;
begin
  inherited;

end;

destructor TRest_Membership_UseMemberPoint.Destroy;
begin

  inherited;
end;

function TRest_Membership_UseMemberPoint.ExecuteURI: Boolean;
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

  ResponseInfo.ResponseNo   := 200;
  RtnContent:=
    '{"RES_CD":"00000",' +
     '"RES_MSG":"정상적으로 처리 되었습니다."}';

  if ResponseInfo.ResponseNo = 200 then
  begin
    Result:= True;
    SetRtnContents(RtnContent);
  end;
end;

end.

