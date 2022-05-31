object FMain: TFMain
  Left = 0
  Top = 0
  Caption = 'Simple Rest Client'
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
    Top = 73
    Height = 656
    Align = alRight
    ExplicitLeft = 392
    ExplicitTop = 256
    ExplicitHeight = 100
  end
  object PanTop: TPanel
    Left = 0
    Top = 0
    Width = 1008
    Height = 73
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    ExplicitLeft = -104
    ExplicitTop = -32
    ExplicitWidth = 784
    DesignSize = (
      1008
      73)
    object BtPost: TButton
      Left = 839
      Top = 10
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Post'
      TabOrder = 0
      OnClick = BtPostClick
      ExplicitLeft = 615
    end
    object EtHost: TEdit
      Left = 16
      Top = 12
      Width = 201
      Height = 21
      TabOrder = 1
      Text = 'https://localhost'
    end
    object EtURI: TEdit
      Left = 223
      Top = 12
      Width = 201
      Height = 21
      TabOrder = 2
      Text = '/DBO/Select'
    end
    object EtUserName: TEdit
      Left = 16
      Top = 39
      Width = 201
      Height = 21
      TabOrder = 3
      Text = 'admin'
    end
    object EtPassword: TEdit
      Left = 223
      Top = 39
      Width = 201
      Height = 21
      TabOrder = 4
      Text = '1234'
    end
    object BtClear: TButton
      Left = 758
      Top = 10
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Clear'
      TabOrder = 5
      OnClick = BtClearClick
      ExplicitLeft = 534
    end
    object BtGet: TButton
      Left = 920
      Top = 10
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Get'
      TabOrder = 6
      OnClick = BtGetClick
      ExplicitLeft = 696
    end
  end
  object MemoLog: TMemo
    Left = 708
    Top = 73
    Width = 300
    Height = 656
    Align = alRight
    Lines.Strings = (
      'MemoLog')
    ScrollBars = ssVertical
    TabOrder = 1
    ExplicitLeft = 728
  end
  object PanBody: TPanel
    Left = 0
    Top = 73
    Width = 705
    Height = 656
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 2
    ExplicitWidth = 596
    ExplicitHeight = 488
    object MemoTran: TMemo
      Left = 0
      Top = 89
      Width = 705
      Height = 567
      Align = alClient
      Lines.Strings = (
        'MemoTran')
      ScrollBars = ssVertical
      TabOrder = 0
      ExplicitWidth = 501
      ExplicitHeight = 399
    end
    object MemoSendData: TMemo
      Left = 0
      Top = 0
      Width = 705
      Height = 89
      Align = alTop
      Lines.Strings = (
        'MemoSendData')
      ScrollBars = ssVertical
      TabOrder = 1
      ExplicitWidth = 501
    end
  end
end
