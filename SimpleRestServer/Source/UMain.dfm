object FMain: TFMain
  Left = 0
  Top = 0
  Caption = 'Simple Rest Server'
  ClientHeight = 729
  ClientWidth = 1008
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnActivate = FormActivate
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 705
    Top = 49
    Height = 680
    Align = alRight
    ExplicitLeft = 480
    ExplicitTop = 256
    ExplicitHeight = 100
  end
  object PanTop: TPanel
    Left = 0
    Top = 0
    Width = 1008
    Height = 49
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    ExplicitLeft = -8
    ExplicitTop = -6
    ExplicitWidth = 784
    DesignSize = (
      1008
      49)
    object LedPower: TShape
      Left = 8
      Top = 8
      Width = 33
      Height = 41
      Shape = stCircle
    end
    object BtPower: TButton
      Left = 64
      Top = 15
      Width = 75
      Height = 25
      Caption = 'On / Off'
      TabOrder = 0
      OnClick = BtPowerClick
    end
    object BtURIList: TButton
      Left = 920
      Top = 13
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'URI List'
      TabOrder = 1
      OnClick = BtURIListClick
      ExplicitLeft = 696
    end
    object BtClear: TButton
      Left = 841
      Top = 13
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Clear'
      TabOrder = 2
      OnClick = BtClearClick
      ExplicitLeft = 617
    end
  end
  object MemoTranLog: TMemo
    Left = 0
    Top = 49
    Width = 705
    Height = 680
    Align = alClient
    Lines.Strings = (
      'MemoTranLog')
    ScrollBars = ssVertical
    TabOrder = 1
    ExplicitWidth = 501
    ExplicitHeight = 512
  end
  object MemoSvrLog: TMemo
    Left = 708
    Top = 49
    Width = 300
    Height = 680
    Align = alRight
    Lines.Strings = (
      'MemoSvrLog')
    ScrollBars = ssVertical
    TabOrder = 2
    ExplicitLeft = 728
  end
end
