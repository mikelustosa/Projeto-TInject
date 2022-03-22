object FrmConfigNetWork: TFrmConfigNetWork
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Preferences'
  ClientHeight = 412
  ClientWidth = 450
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  KeyPreview = True
  Padding.Left = 10
  Padding.Top = 10
  Padding.Right = 10
  Padding.Bottom = 10
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 10
    Top = 10
    Width = 430
    Height = 261
    Align = alTop
    Caption = ' Proxy '
    TabOrder = 0
    DesignSize = (
      430
      261)
    object ProxyTypeLbl: TLabel
      Left = 78
      Top = 27
      Width = 28
      Height = 13
      Alignment = taRightJustify
      Caption = 'Type'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object ProxyServerLbl: TLabel
      Left = 68
      Top = 56
      Width = 38
      Height = 13
      Alignment = taRightJustify
      Caption = 'Server'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object ProxyPortLbl: TLabel
      Left = 325
      Top = 57
      Width = 24
      Height = 13
      Alignment = taRightJustify
      Anchors = [akRight]
      Caption = 'Port'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      ExplicitTop = 58
    end
    object ProxyUsernameLbl: TLabel
      Left = 48
      Top = 83
      Width = 58
      Height = 13
      Alignment = taRightJustify
      Caption = 'Username'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object ProxyPasswordLbl: TLabel
      Left = 52
      Top = 110
      Width = 54
      Height = 13
      Alignment = taRightJustify
      Caption = 'Password'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object ProxyScriptURLLbl: TLabel
      Left = 15
      Top = 135
      Width = 58
      Height = 13
      Caption = 'Script URL'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object ProxyByPassListLbl: TLabel
      Left = 15
      Top = 176
      Width = 402
      Height = 27
      Anchors = [akLeft, akTop, akRight]
      AutoSize = False
      Caption = 'ByPass list'#13#10'qwerwqreqwrwqer'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      Layout = tlBottom
      WordWrap = True
    end
    object MaxConnectionsPerProxyLbl: TLabel
      Left = 143
      Top = 235
      Width = 185
      Height = 13
      Alignment = taRightJustify
      Anchors = [akRight]
      Caption = 'Maximum connections per proxy'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      ExplicitTop = 238
    end
    object PrtocolLbl: TLabel
      Left = 295
      Top = 28
      Width = 54
      Height = 13
      Alignment = taRightJustify
      Anchors = [akRight]
      Caption = 'Protocolo'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object ProxyTypeCbx: TComboBox
      Left = 108
      Top = 24
      Width = 170
      Height = 21
      Style = csDropDownList
      Anchors = [akLeft, akTop, akRight]
      ItemIndex = 0
      TabOrder = 0
      Text = 'Direct'
      Items.Strings = (
        'Direct'
        'Autodetect'
        'System'
        'Fixed servers'
        'PAC script')
    end
    object ProxyServerEdt: TEdit
      Left = 108
      Top = 53
      Width = 205
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 2
      ExplicitWidth = 186
    end
    object ProxyPortEdt: TEdit
      Left = 351
      Top = 53
      Width = 68
      Height = 21
      Anchors = [akTop]
      MaxLength = 5
      NumbersOnly = True
      TabOrder = 3
      Text = '80'
    end
    object ProxyUsernameEdt: TEdit
      Left = 108
      Top = 80
      Width = 311
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 4
      ExplicitWidth = 292
    end
    object ProxyPasswordEdt: TEdit
      Left = 108
      Top = 107
      Width = 311
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      PasswordChar = '*'
      TabOrder = 5
      ExplicitWidth = 292
    end
    object ProxyScriptURLEdt: TEdit
      Left = 15
      Top = 148
      Width = 404
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 6
    end
    object ProxyByPassListEdt: TEdit
      Left = 15
      Top = 205
      Width = 404
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 7
    end
    object ProxySchemeCb: TComboBox
      Left = 351
      Top = 24
      Width = 68
      Height = 21
      Style = csDropDownList
      Anchors = [akTop]
      ItemIndex = 0
      TabOrder = 1
      Text = 'HTTP'
      Items.Strings = (
        'HTTP'
        'SOCKS4'
        'SOCKS5')
    end
    object MaxConnectionsPerProxyEdt: TSpinEdit
      Left = 331
      Top = 232
      Width = 88
      Height = 22
      Anchors = [akRight, akBottom]
      MaxValue = 99
      MinValue = 7
      TabOrder = 8
      Value = 32
      ExplicitTop = 243
    end
  end
  object GroupBox2: TGroupBox
    AlignWithMargins = True
    Left = 10
    Top = 274
    Width = 430
    Height = 84
    Margins.Left = 0
    Margins.Right = 0
    Align = alTop
    Caption = ' Custom header '
    TabOrder = 1
    ExplicitTop = 265
    ExplicitWidth = 411
    DesignSize = (
      430
      84)
    object HeaderNameLbl: TLabel
      Left = 101
      Top = 26
      Width = 32
      Height = 13
      Alignment = taRightJustify
      Caption = 'Name'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object HeaderValueLbl: TLabel
      Left = 102
      Top = 53
      Width = 31
      Height = 13
      Alignment = taRightJustify
      Caption = 'Value'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object HeaderNameEdt: TEdit
      Left = 134
      Top = 23
      Width = 285
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 0
      ExplicitWidth = 266
    end
    object HeaderValueEdt: TEdit
      Left = 134
      Top = 50
      Width = 285
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 1
      ExplicitWidth = 266
    end
  end
  object Panel1: TPanel
    Left = 10
    Top = 377
    Width = 430
    Height = 25
    Align = alBottom
    BevelOuter = bvNone
    Padding.Left = 30
    Padding.Right = 30
    TabOrder = 2
    ExplicitTop = 416
    ExplicitWidth = 411
    object BntOk: TButton
      Left = 30
      Top = 0
      Width = 120
      Height = 25
      Align = alLeft
      Caption = 'Ok'
      TabOrder = 0
      OnClick = BntOkClick
    end
    object BntCancel: TButton
      Left = 280
      Top = 0
      Width = 120
      Height = 25
      Align = alRight
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 1
      ExplicitLeft = 261
    end
  end
end
