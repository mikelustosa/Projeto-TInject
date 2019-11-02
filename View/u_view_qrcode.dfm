object frm_view_qrcode: Tfrm_view_qrcode
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  Caption = 'TInject - Carregando QRCode...'
  ClientHeight = 272
  ClientWidth = 316
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Image1: TImage
    Left = 0
    Top = 0
    Width = 316
    Height = 272
    Align = alClient
    Center = True
    ExplicitLeft = 88
    ExplicitTop = 80
    ExplicitWidth = 105
    ExplicitHeight = 105
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 2000
    OnTimer = Timer1Timer
    Left = 96
    Top = 48
  end
end
