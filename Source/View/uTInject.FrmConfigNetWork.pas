unit uTInject.FrmConfigNetWork;

{$I cef.inc}

interface

uses
  {$IFDEF DELPHI16_UP}
     Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
     Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Samples.Spin, Vcl.ExtCtrls;
  {$ELSE}
     Windows, Messages, SysUtils, Variants, Classes, Graphics,
     Controls, Forms, Dialogs, StdCtrls, Spin, ExtCtrls;
  {$ENDIF}

type
  TFrmConfigNetWork = class(TForm)
    GroupBox1: TGroupBox;
    ProxyTypeCbx: TComboBox;
    ProxyTypeLbl: TLabel;
    ProxyServerLbl: TLabel;
    ProxyServerEdt: TEdit;
    ProxyPortLbl: TLabel;
    ProxyPortEdt: TEdit;
    ProxyUsernameLbl: TLabel;
    ProxyUsernameEdt: TEdit;
    ProxyPasswordLbl: TLabel;
    ProxyPasswordEdt: TEdit;
    ProxyScriptURLEdt: TEdit;
    ProxyScriptURLLbl: TLabel;
    ProxyByPassListEdt: TEdit;
    ProxyByPassListLbl: TLabel;
    GroupBox2: TGroupBox;
    HeaderNameEdt: TEdit;
    HeaderNameLbl: TLabel;
    HeaderValueEdt: TEdit;
    HeaderValueLbl: TLabel;
    ProxySchemeCb: TComboBox;
    MaxConnectionsPerProxyLbl: TLabel;
    MaxConnectionsPerProxyEdt: TSpinEdit;
    Panel1: TPanel;
    BntOk: TButton;
    BntCancel: TButton;
    PrtocolLbl: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure BntOkClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmConfigNetWork: TFrmConfigNetWork;

implementation

{$R *.dfm}

uses uTInject.Constant, uTInject.Diversos, uTInject.languages, System.UITypes;


procedure TFrmConfigNetWork.BntOkClick(Sender: TObject);
begin
  if MessageDlg(Text_FrmConfigNetWork_QuestionSave, mtConfirmation, [mbYes, mbNo], 0) <> mrYes then
  Begin
    ProxyTypeCbx.SetFocus;
    Exit;
  End;

  ModalResult := mrOk;
end;

procedure TFrmConfigNetWork.FormCreate(Sender: TObject);
begin
  Caption                    := Text_FrmConfigNetWork_Caption;
  ProxyTypeLbl.Caption       := Text_FrmConfigNetWork_ProxyTypeLbl ;
  ProxyServerLbl.Caption     := Text_FrmConfigNetWork_ProxyServerLbl ;
  PrtocolLbl.Caption         := Text_FrmConfigNetWork_PrtocolLbl;
  ProxyPortLbl.Caption       := Text_FrmConfigNetWork_ProxyPortLbl ;
  ProxyUsernameLbl.Caption   := Text_FrmConfigNetWork_ProxyUsernameLbl ;
  ProxyPasswordLbl.Caption   := Text_FrmConfigNetWork_ProxyPasswordLbl ;
  ProxyScriptURLLbl.Caption  := Text_FrmConfigNetWork_ProxyScriptURLLbl ;
  ProxyByPassListLbl.Caption := Text_FrmConfigNetWork_ProxyByPassListLbl ;
  GroupBox2.Caption          := Text_FrmConfigNetWork_GroupBox2;
  HeaderNameLbl.Caption      := Text_FrmConfigNetWork_HeaderNameLbl ;
  HeaderValueLbl.Caption     := Text_FrmConfigNetWork_HeaderValueLbl ;
  MaxConnectionsPerProxyLbl.Caption   := Text_FrmConfigNetWork_MaxConnectionsPerProxyLbl ;
  BntOk.Caption              := Text_FrmConfigNetWork_BntOK;
  BntCancel.Caption          := Text_FrmConfigNetWork_BntCancel;
end;

end.
