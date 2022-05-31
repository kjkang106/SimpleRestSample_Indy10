unit UDBUtil;

interface

uses
  SysUtils, DB, DBXJSON;

function GetJsonResultSet(QyRead: TDataSet): string;

implementation

uses UJsonUtil;

function GetJsonResultSet(QyRead: TDataSet): string;
var
  fi, fMax: Integer;

  JDoc: TJSONObject;
  JArray: TJSONArray;
  ArrElement: TJSONObject;
begin
  Result:= '';
  if not QyRead.Active then
    Exit;

  JDoc  := TJSONObject.Create;
  try
    AddJsonParam(JDoc, 'COUNT', QyRead.RecordCount);

    JArray:= TJSONArray.Create;
    fMax:= QyRead.FieldDefs.Count;

    while not QyRead.Eof do
    begin
      ArrElement:= TJSONObject.Create;
      for fi:= 0 to fMax - 1 do
      begin
        case QyRead.Fields[fi].DataType of
          ftInteger:
            AddJsonParam(ArrElement, QyRead.Fields[fi].FieldName, QyRead.Fields[fi].AsInteger);
          ftString:
            AddJsonParam(ArrElement, QyRead.Fields[fi].FieldName, QyRead.Fields[fi].AsString);
          ftWideString:
            AddJsonParam(ArrElement, QyRead.Fields[fi].FieldName, QyRead.Fields[fi].AsWideString);
          ftExtended:
            AddJsonParam(ArrElement, QyRead.Fields[fi].FieldName, QyRead.Fields[fi].AsExtended);
          ftTimeStamp,
          ftDate,
          ftDateTime:
            AddJsonParam(ArrElement, QyRead.Fields[fi].FieldName, FormatDateTime('YYYY-MM-DD HH:NN:SS.ZZZ', QyRead.Fields[fi].AsDateTime));
        end;
      end;
      JArray.Add(ArrElement);
      QyRead.Next;
    end;
    AddJsonParam(JDoc, 'DATA', JArray);

    Result:= JDoc.ToString;
  finally
    FreeAndNil(JDoc);
  end;
end;

end.
