unit URestSvrClass;

interface

uses
  Classes;

const
  zURIList : array[0..2, 0..1] of string = (
      ('/Membership/getMemberPoint', 'TRest_Membership_GetMemberPoint'),
      ('/Membership/useMemberPoint', 'TRest_Membership_UseMemberPoint'),
      ('/DBO/Select'               , 'TRest_DBO_Select')
    );

implementation

uses URest_Membership_GetMemberPoint, URest_Membership_UseMemberPoint,
  URest_DBO_Select;

initialization
  RegisterClass(TRest_Membership_GetMemberPoint);
  RegisterClass(TRest_Membership_UseMemberPoint);
  RegisterClass(TRest_DBO_Select);

finalization

end.
