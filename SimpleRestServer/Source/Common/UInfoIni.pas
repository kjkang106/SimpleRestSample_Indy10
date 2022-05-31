unit UInfoIni;

interface

uses
  Forms, SysUtils, IniFiles;

type
  TDBInfo = record
    DriverID: string;
    UserName: string;
    Password: string;
    Host    : string;
    Port    : string;
    DBName  : string;
  end;
  TInfoIni = record
    DBInfo  : TDBInfo;
  end;

var
  InfoIni: TInfoIni;

function GetDataPath: string;
procedure LoadIni;
procedure SaveIni;

implementation

function GetDataPath: string;
begin
  Result:= IncludeTrailingPathDelimiter(ExtractFilePath(Application.ExeName) + '..\Data');
  ForceDirectories(Result);
end;

procedure LoadIni;
var
  IniFile: string;
  Ini: TIniFile;
begin
  IniFile:= GetDataPath + 'InfoIni.ini';

  InfoIni:= Default(TInfoIni);
  Ini:= TIniFile.Create(IniFile);
  try
    InfoIni.DBInfo.DriverID:= Ini.ReadString('DBInfo', 'DriverID', '');
    InfoIni.DBInfo.UserName:= Ini.ReadString('DBInfo', 'UserName', '');
    InfoIni.DBInfo.Password:= Ini.ReadString('DBInfo', 'Password', '');
    InfoIni.DBInfo.Host    := Ini.ReadString('DBInfo', 'Host'    , '');
    InfoIni.DBInfo.Port    := Ini.ReadString('DBInfo', 'Port'    , '');
    InfoIni.DBInfo.DBName  := Ini.ReadString('DBInfo', 'DBName'  , '');
  finally
    Ini.Free;
  end;
end;

procedure SaveIni;
var
  IniFile: string;
  Ini: TIniFile;
begin
  IniFile:= GetDataPath + 'InfoIni.ini';

  Ini:= TIniFile.Create(IniFile);
  try
    Ini.WriteString('DBInfo', 'DriverID', InfoIni.DBInfo.DriverID);
    Ini.WriteString('DBInfo', 'UserName', InfoIni.DBInfo.UserName);
    Ini.WriteString('DBInfo', 'Password', InfoIni.DBInfo.Password);
    Ini.WriteString('DBInfo', 'Host'    , InfoIni.DBInfo.Host    );
    Ini.WriteString('DBInfo', 'Port'    , InfoIni.DBInfo.Port    );
    Ini.WriteString('DBInfo', 'DBName'  , InfoIni.DBInfo.DBName  );
  finally
    Ini.Free;
  end;
end;

initialization
  LoadIni;

finalization
  SaveIni;

end.
