unit UMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TFMain = class(TForm)
    PanTop: TPanel;
    BtPost: TButton;
    MemoTran: TMemo;
    MemoLog: TMemo;
    Splitter1: TSplitter;
    EtHost: TEdit;
    EtURI: TEdit;
    EtUserName: TEdit;
    EtPassword: TEdit;
    PanBody: TPanel;
    MemoSendData: TMemo;
    BtClear: TButton;
    BtGet: TButton;
    procedure BtClearClick(Sender: TObject);
    procedure BtGetClick(Sender: TObject);
    procedure BtPostClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    procedure WriteTranLog(msg: string);
    procedure WriteLog(msg: string);
    procedure ClearTranLog;
    procedure ClearLog;
  public
    { Public declarations }
  end;

var
  FMain: TFMain;

implementation

uses UDmNet, USaveLog;

const
  MAX_LOG_CNT  =  500;
  MAX_TRAN_LOG_CNT = 1000;

{$R *.dfm}

procedure TFMain.BtClearClick(Sender: TObject);
begin
  ClearTranLog;
end;

procedure TFMain.BtGetClick(Sender: TObject);
var
  Url, Id, Pass, PostData: string;
  OutStr: string;
  rltCode: Integer;
begin
  if EtHost.Text = '' then
    Exit;
  Url     := EtHost.Text + EtURI.Text;
  Id      := EtUserName.Text;
  Pass    := EtPassword.Text;
  PostData:= MemoSendData.Text;

  WriteLog('GET Start');
  rltCode:= DmNet.HttpGet(Url, Id, Pass, PostData, OutStr);
  if rltCode = 1 then
    WriteLog('Success')
  else
    WriteLog('Fail');
end;

procedure TFMain.BtPostClick(Sender: TObject);
var
  Url, Id, Pass, PostData: string;
  OutStr: string;
  rltCode: Integer;
begin
  if EtHost.Text = '' then
    Exit;
  Url     := EtHost.Text + EtURI.Text;
  Id      := EtUserName.Text;
  Pass    := EtPassword.Text;
  PostData:= MemoSendData.Text;

  WriteLog('POST Start');
  rltCode:= DmNet.HttpPost(Url, Id, Pass, PostData, OutStr);
  if rltCode = 1 then
    WriteLog('Success')
  else
    WriteLog('Fail');
end;

procedure TFMain.ClearLog;
begin
  SaveLogFile('LOG_', MemoLog.Lines);
  MemoLog.Clear;
end;

procedure TFMain.ClearTranLog;
begin
  SaveLogFile('TRAN_', MemoTran.Lines);
  MemoTran.Clear;
end;

procedure TFMain.FormActivate(Sender: TObject);
begin
  OnActivate:= nil;

  DmNet.LogEvent:= WriteTranLog;
end;

procedure TFMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  SaveLogFile('LOG_', MemoLog.Lines);
  SaveLogFile('TRAN_', MemoTran.Lines);
end;

procedure TFMain.FormCreate(Sender: TObject);
begin
  MemoSendData.Clear;
  MemoTran.Clear;
  MemoLog.Clear;
end;

procedure TFMain.WriteLog(msg: string);
begin
  if MemoLog.Lines.Count > MAX_LOG_CNT then
    ClearLog;
  if Trim(msg) <> '' then
    msg:= FormatDateTime('YYYY-MM-DD HH:NN:SS:ZZZ', now) + ' ' + msg;
  MemoLog.Lines.Append(msg);
end;

procedure TFMain.WriteTranLog(msg: string);
begin
  if MemoLog.Lines.Count > MAX_TRAN_LOG_CNT then
    ClearTranLog;
  if Trim(msg) <> '' then
    msg:= FormatDateTime('YYYY-MM-DD HH:NN:SS:ZZZ', now) + ' ' + msg;
  MemoTran.Lines.Append(msg);
end;

end.
