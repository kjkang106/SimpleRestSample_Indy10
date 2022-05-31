unit UMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls;

type
  TFMain = class(TForm)
    PanTop: TPanel;
    BtPower: TButton;
    LedPower: TShape;
    MemoTranLog: TMemo;
    MemoSvrLog: TMemo;
    BtURIList: TButton;
    BtClear: TButton;
    Splitter1: TSplitter;
    procedure BtClearClick(Sender: TObject);
    procedure BtPowerClick(Sender: TObject);
    procedure BtURIListClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    procedure WriteSvrLog(msg: string);
    procedure WriteTranLog(msg: string);
    procedure ClearTranLog;
    procedure ClearSvrLog;
  public
    { Public declarations }
  end;

var
  FMain: TFMain;

implementation

uses UDmRestSvr, URestSvrClass, USaveLog;

const
  MAX_SVR_LOG_CNT  =  500;
  MAX_TRAN_LOG_CNT = 1000;

{$R *.dfm}

{ TFMain }

procedure TFMain.BtClearClick(Sender: TObject);
begin
  ClearTranLog;
end;

procedure TFMain.BtPowerClick(Sender: TObject);
begin
  DmRestSvr.RestSvrActivate(not DmRestSvr.IdHTTPServer.Active);

  if DmRestSvr.IdHTTPServer.Active then
  begin
    ledPower.Brush.Color:= clBlue;
    WriteSvrLog('RestSvrActivate On');
  end
  else
  begin
    ledPower.Brush.Color:= clRed;
    WriteSvrLog('RestSvrActivate Off');
  end;
  ledPower.Pen.Color  := ledPower.Brush.Color;
  ledPower.Update;
end;

procedure TFMain.BtURIListClick(Sender: TObject);
var
  idx: Integer;
  StrURI: string;
begin
  StrURI:= '';
  for idx:= Low(zURIList) to High(zURIList) do
  begin
    if StrURI = '' then
      StrURI:= 'Get URIList';
    StrURI:= StrURI + sLineBreak + zURIList[idx, 0];
  end;

  if StrURI <> '' then
    WriteSvrLog(StrURI);
end;

procedure TFMain.ClearSvrLog;
begin
  SaveLogFile('LOG_', MemoSvrLog.Lines);
  MemoSvrLog.Clear;
end;

procedure TFMain.ClearTranLog;
begin
  SaveLogFile('TRAN_', MemoTranLog.Lines);
  MemoTranLog.Clear;
end;

procedure TFMain.FormActivate(Sender: TObject);
begin
  OnActivate:= nil;

  DmRestSvr.IdHTTPServer.Active     := False;
  BtPower.Click;
end;

procedure TFMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  SaveLogFile('LOG_', MemoSvrLog.Lines);
  SaveLogFile('TRAN_', MemoTranLog.Lines);
end;

procedure TFMain.FormCreate(Sender: TObject);
begin
  MemoSvrLog.Clear;
  MemoTranLog.Clear;
  DmRestSvr.SvrLogEvent := WriteSvrLog;
  DmRestSvr.TranLogEvent:= WriteTranLog;
end;

procedure TFMain.WriteSvrLog(msg: string);
begin
  TThread.Synchronize(nil,
    procedure
    begin
      if MemoSvrLog.Lines.Count > MAX_SVR_LOG_CNT then
        ClearSvrLog;
      if Trim(msg) <> '' then
        msg:= FormatDateTime('YYYY-MM-DD HH:NN:SS:ZZZ', now) + ' ' + msg;
      MemoSvrLog.Lines.Append(msg);
    end
  );
end;

procedure TFMain.WriteTranLog(msg: string);
begin
  TThread.Synchronize(nil,
    procedure
    begin
      if MemoTranLog.Lines.Count > MAX_TRAN_LOG_CNT then
        ClearTranLog;
      if Trim(msg) <> '' then
        msg:= FormatDateTime('YYYY-MM-DD HH:NN:SS:ZZZ', now) + ' ' + msg;
      MemoTranLog.Lines.Append(msg);
    end
  );
end;

end.
