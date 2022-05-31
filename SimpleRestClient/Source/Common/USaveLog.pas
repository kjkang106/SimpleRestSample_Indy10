unit USaveLog;

interface

uses
  Forms, Classes, SysUtils, DateUtils;

function GetLogPath: string;
procedure SaveLogFile(Prefix: string; Logs: TStrings);
procedure DeleteLogs(Prefix, OldDateStr: string);
procedure DeleteOldLogs;

implementation

function GetLogPath: string;
begin
  Result:= IncludeTrailingPathDelimiter(ExtractFilePath(Application.ExeName) + '..\Log');
  ForceDirectories(Result);
end;

procedure SaveLogFile(Prefix: string; Logs: TStrings);
var
  FileName: string;
begin
  if Trim(Logs.Text) = '' then
    Exit;

  FileName:= GetLogPath + PreFix + FormatDateTime('YYYYMMDDHHNNSS', Now) + '.log';
  Logs.SaveToFile(FileName, TEncoding.UTF8);
end;

procedure DeleteLogs(Prefix, OldDateStr: string);
var
  LogRoot: string;
  ReturnCode: Cardinal;
  SearchRec: TSearchRec;
  FileLength: Integer;
  FileDateStr: string;
begin
  LogRoot:= GetLogPath;

  ReturnCode := FindFirst(LogRoot + '*.log', FaAnyfile, SearchRec);
  while ReturnCode = 0 do
  begin
    if (SearchRec.Attr and FaDirectory <> FaDirectory) and
       (SearchRec.Name <> '.') and
       (SearchRec.Name <> '..') then
    begin
      FileLength := Length(SearchRec.Name);
      FileDateStr:= Copy(SearchRec.Name, FileLength - 17, 8);
      if FileDateStr < OldDateStr then
        DeleteFile(LogRoot + SearchRec.Name);
    end;
    ReturnCode := FindNext(SearchRec);
  end;
  FindClose(SearchRec);
end;

procedure DeleteOldLogs;
var
  OldDateStr: string;
begin
  OldDateStr:= FormatDateTime('YYYYMMDD', IncDay(Date, -5));
  DeleteLogs('', OldDateStr);
end;

initialization
  DeleteOldLogs;

finalization

end.
