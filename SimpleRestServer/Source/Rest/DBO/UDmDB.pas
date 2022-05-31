unit UDmDB;

interface

uses
  SysUtils, Classes, Windows,
  uADGUIxIntf, uADGUIxFormsWait, uADStanIntf, uADStanOption,
  uADStanError, uADPhysIntf, uADStanDef, uADStanPool, uADStanAsync,
  uADPhysManager, uADStanParam, uADDatSManager, uADDAptIntf, uADDAptManager, DB,
  uADCompDataSet, uADCompClient, uADPhysOracle, uADCompGUIx, uADPhysODBCBase,
  uADPhysMSSQL,
  UGlobalType;

type
  TDmDB = class(TDataModule)
    ADGUIxWaitCursor1: TADGUIxWaitCursor;
    ADPhysOracleDriverLink1: TADPhysOracleDriverLink;
    ADConnection: TADConnection;
    adqExe: TADQuery;
    adqRead: TADQuery;
    ADPhysMSSQLDriverLink1: TADPhysMSSQLDriverLink;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    { Private declarations }
    FLogEvent: TLogEvent;
    FErrMsg : string;

    procedure SetOraConnectionStr(id, pw, host, port, sname: string);
    procedure SetMsSqlConnectionStr(id, pw, host, dbname: string);
  public
    { Public declarations }
    procedure WriteLog(msg: string);

    function DbConnect: Boolean;
    function OpenSQL(AQry: TADQuery; ASQL: string): boolean;
    function ExecuteSQL(AQry: TADQuery; ASQL: string): boolean;

    property LogEvent   : TLogEvent       read FLogEvent      write FLogEvent;
    property ErrMsg     : string          read FErrMsg        write FErrMsg;
  end;

var
  DmDB: TDmDB;

implementation

uses UInfoIni;

{$R *.dfm}

{ TDmDB }

procedure TDmDB.DataModuleCreate(Sender: TObject);
begin
  FLogEvent:= nil;
  FErrMsg  := '';
end;

procedure TDmDB.DataModuleDestroy(Sender: TObject);
begin
  FLogEvent:= nil;
end;

function TDmDB.DbConnect: Boolean;
begin
  Result:= False;
  WriteLog('ADConnection Connect Start');
  if not ADConnection.Connected then
  begin
    if InfoIni.DBInfo.DriverID = 'Ora' then
      SetOraConnectionStr(
        InfoIni.DBInfo.UserName,
        InfoIni.DBInfo.Password,
        InfoIni.DBInfo.Host,
        InfoIni.DBInfo.Port,
        InfoIni.DBInfo.DBName
      )
    else
      SetMsSqlConnectionStr(
        InfoIni.DBInfo.UserName,
        InfoIni.DBInfo.Password,
        InfoIni.DBInfo.Host,
        InfoIni.DBInfo.DBName
      );
    try
      ADConnection.Connected:= True;
    except
      on E: Exception do
      begin
        FErrMsg:= E.Message;
        Exit;
      end;
    end;
  end;

  if not ADConnection.Connected then
  begin
    WriteLog('DB 연결 실패');
    Exit;
  end;

  Result:= True;
  WriteLog('ADConnection Connected');
end;

function TDmDB.ExecuteSQL(AQry: TADQuery; ASQL: string): boolean;
var
  tick: Cardinal;
begin
  Result := False;
  FErrMsg:= '';

  AQry.Close;
  if ASQL <> '' then
  begin
    AQry.Sql.Clear;
    AQry.Sql.Append(ASQL);
  end;

  WriteLog(AQry.SQL.Text);

  tick:= GetTickCount;
  try
    AQry.ExecSQL;
    Result:= True;
    WriteLog(IntToStr(GetTickCount - tick) + 'ms] ExecSQL Result = ' + IntToStr(Ord(Result)) );
  except
    on E: Exception do
    begin
      WriteLog(E.Message);
      FErrMsg:= E.Message;
    end;
  end;
end;

function TDmDB.OpenSQL(AQry: TADQuery; ASQL: string): boolean;
var
  tick: Cardinal;
begin
  Result := False;
  FErrMsg:= '';

  AQry.Close;
  if ASQL <> '' then
  begin
    AQry.Sql.Clear;
    AQry.Sql.Append(ASQL);
  end;

  WriteLog(AQry.SQL.Text);

  tick:= GetTickCount;
  try
    AQry.Open;
    if AQry.Active and (AQry.RecordCount > 0) then
    begin
      Result:= True;
      AQry.FetchAll;   //Default가 OnDemand, 50개임 -> 임의로 생성한 쿼리 레코드 갯수가 많은 경우 DB lock이 걸림
    end;
    WriteLog(IntToStr(GetTickCount - tick) + 'ms] Open Result = ' + IntToStr(Ord(Result)) );
  except
    on E: Exception do
    begin
      WriteLog(E.Message);
      FErrMsg:= E.Message;
      AQry.Close;
    end;
  end;
end;

procedure TDmDB.SetMsSqlConnectionStr(id, pw, host, dbname: string);
begin
  ADConnection.Params.Clear;
  ADConnection.Params.Append('DriverID=MSSQL');
  if id = '' then
    ADConnection.Params.Append('OSAuthent=Yes')
  else
  begin
    ADConnection.Params.Append('User_Name=' + id);
    ADConnection.Params.Append('Password='  + pw);
  end;
  ADConnection.Params.Append('SERVER='    + host);
  ADConnection.Params.Append('DATABASE='  + dbname);
end;

procedure TDmDB.SetOraConnectionStr(id, pw, host, port, sname: string);
begin
  ADConnection.Params.Clear;
  ADConnection.Params.Append('DriverID=Ora');
  ADConnection.Params.Append('User_Name=' + id);
  ADConnection.Params.Append('Password=' + pw);
  ADConnection.Params.Append('AuthMode=Normal');
  ADConnection.Params.Append('Database=' +
    '(DESCRIPTION =' +
    '  (ADDRESS =' +
    '    (PROTOCOL = TCP)' +
    '    (HOST = ' + host + ')' +
    '    (PORT = ' + port + ')' +
    '  )' +
    '  (CONNECT_DATA =' +
    '    (SERVICE_NAME = ' + sname + ')' +
    '  )' +
    ')');
end;

procedure TDmDB.WriteLog(msg: string);
begin
  if Assigned(FLogEvent) then
    FLogEvent(msg);
end;

end.
