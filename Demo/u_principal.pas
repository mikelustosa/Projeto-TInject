unit u_principal;

interface

uses

  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,  Vcl.ExtCtrls,

  //############ ATENCAO AQUI ####################
  //units adicionais obrigatórias
   uTInject.ConfigCEF, uTInject,            uTInject.Constant,    uTInject.JS,
   uTInject.Console,   uTInject.Diversos,   uTInject.AdjustNumber,  uTInject.Config,       uTInject.Classes,

  //units Opcionais (dependendo do que ira fazer)
   System.NetEncoding, System.TypInfo,
  //###############################################


  Vcl.StdCtrls, System.ImageList, Vcl.ImgList, Vcl.AppEvnts, Vcl.ComCtrls,
  Vcl.Imaging.pngimage, Vcl.Buttons, Vcl.Mask, Data.DB, Vcl.DBCtrls, Vcl.Grids,
  Vcl.DBGrids;

type
  TfrmPrincipal = class(TForm)
    TInject1: TInject;
    OpenDialog1: TOpenDialog;
    TrayIcon1: TTrayIcon;
    ImageList1: TImageList;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    memo_unReadMessagen: TMemo;
    StatusBar1: TStatusBar;
    groupEnvioMsg: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    mem_message: TMemo;
    btSendTextAndFile: TButton;
    btSendText: TButton;
    Panel1: TPanel;
    groupListaChats: TGroupBox;
    Button3: TButton;
    listaChats: TListView;
    groupListaContatos: TGroupBox;
    Splitter1: TSplitter;
    ed_num: TComboBox;
    Pnl_Config: TPanel;
    Panel2: TPanel;
    whatsOn: TImage;
    whatsOff: TImage;
    lblStatus: TLabel;
    Lbl_Avisos: TLabel;
    Timer2: TTimer;
    CheckBox5: TCheckBox;
    Label3: TLabel;
    Panel3: TPanel;
    LabeledEdit2: TLabeledEdit;
    LabeledEdit1: TLabeledEdit;
    chk_apagarMsg: TCheckBox;
    btStatusBat: TButton;
    lblNumeroConectado: TLabel;
    Label4: TLabel;
    Rdb_FormaConexao: TRadioGroup;
    SpeedButton1: TSpeedButton;
    Image1: TImage;
    Panel4: TPanel;
    Button2: TButton;
    chk_AutoResposta: TCheckBox;
    ComboBox1: TComboBox;
    Label5: TLabel;
    listaContatos: TListView;
    Pnl_FONE: TPanel;
    Edt_LengDDD: TLabeledEdit;
    Edt_LengDDI: TLabeledEdit;
    Edt_LengFone: TLabeledEdit;
    Edt_DDIPDR: TLabeledEdit;
    CheckBox4: TCheckBox;
    chk_grupos: TCheckBox;
    btSendContact: TButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    btCheckNumber: TButton;
    btIsConnected: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btSendTextClick(Sender: TObject);
    procedure btSendTextAndFileClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure TInject1GetUnReadMessages(Chats: TChatList);
    procedure listaChatsDblClick(Sender: TObject);
    procedure listaContatosDblClick(Sender: TObject);
    procedure TrayIcon1Click(Sender: TObject);
    procedure ApplicationEvents1Minimize(Sender: TObject);
    procedure TInject1GetStatus(Sender: TObject);
    procedure btStatusBatClick(Sender: TObject);
    procedure Edt_DDIPDRExit(Sender: TObject);
    procedure ed_numChange(Sender: TObject);
    procedure ed_numSelect(Sender: TObject);
    procedure TInject1GetMyNumber(Sender: TObject);
    procedure TInject1ErroAndWarning(Sender: TObject; const PError,
      PInfoAdc: string);
    procedure Timer2Timer(Sender: TObject);
    procedure TInject1GetChatList(const Chats: TChatList);
    procedure TInject1GetAllContactList(
      const AllContacts: TRetornoAllContacts);
    procedure SpeedButton1Click(Sender: TObject);
    procedure TInject1GetQrCode(COnst Sender: TObject; const QrCode: TResultQRCodeClass);
    procedure whatsOnClick(Sender: TObject);
    procedure TInject1LowBattery(Sender: TObject);
    procedure TInject1DisconnectedBrute(Sender: TObject);
    procedure chk_3Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure btSendContactClick(Sender: TObject);
    procedure listaContatosClick(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure btCheckNumberClick(Sender: TObject);
    procedure TInject1GetCheckIsValidNumber(Sender: TObject; Number: string;
      IsValid: Boolean);
    procedure btIsConnectedClick(Sender: TObject);
    procedure TInject1IsConnected(Sender: TObject; Connected: Boolean);
    procedure TInject1GetBatteryLevel(Sender: TObject);

  private
    { Private declarations }
    FIniciando: Boolean;
    Procedure ExecuteFilter;
  public
    { Public declarations }
    mensagem                              : string;
    function  VerificaPalavraChave( pMensagem, pSessao, pTelefone, pContato : String ) : Boolean;
    procedure AddChatList(ANumber: String);
    procedure AddContactList(ANumber: String);
  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

uses
  Vcl.Imaging.jpeg, Datasnap.DBClient, Winapi.ShellAPI;

{$R *.dfm}

procedure TfrmPrincipal.FormCreate(Sender: TObject);
var
  I: Integer;
begin
  ReportMemoryLeaksOnShutdown  := false;
  PageControl1.ActivePageIndex := 0;
  FIniciando := True;
  try
    ComboBox1.Items.Clear;
    for I := 0 to 3 do
    Begin
      ComboBox1.Items.Add(GetEnumName(TypeInfo(TLanguageInject), ord(TLanguageInject(i))));
    End;

    GlobalCEFApp.LogConsoleActive := true;
    ComboBox1.ItemIndex   := Integer(TInject1.LanguageInject);
    TabSheet3.TabVisible  := False;
    TabSheet4.TabVisible  := False;
    chk_apagarMsg.Checked := TInject1.Config.AutoDelete         ;
    LabeledEdit1.text     := TInject1.Config.ControlSendTimeSec.ToString ;
    LabeledEdit2.Text     := TInject1.Config.SecondsMonitor.ToString     ;
  finally
    FIniciando := False;
  end;
end;

procedure TfrmPrincipal.AddContactList(ANumber: String);
var
  Item: TListItem;
begin
  Item := listaContatos.Items.Add;
  if Length(ANumber) < 12 then
     ANumber := '55' + ANumber;
  item.Caption := ANumber;
  item.SubItems.Add(item.Caption+'SubItem 1');
  item.SubItems.Add(item.Caption+'SubItem 2');
  item.ImageIndex := 0;
end;

procedure TfrmPrincipal.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  TInject1.ShutDown;
//  FreeAndNil(GlobalCEFApp);
end;

Procedure TfrmPrincipal.AddChatList(ANumber: String);
var
  Item: TListItem;
begin
  Item := listaChats.Items.Add;
  if Length(ANumber) < 12 then
     ANumber := '55' + ANumber;
  item.Caption := ANumber;
  item.SubItems.Add(item.Caption+'SubItem 1');
  item.SubItems.Add(item.Caption+'SubItem 2');
  item.ImageIndex := 2;
end;

procedure TfrmPrincipal.ApplicationEvents1Minimize(Sender: TObject);
begin
  self.Hide();
  self.WindowState := wsMinimized;
  trayIcon1.Visible := true;
  TrayIcon1.Animate := True;
  TrayIcon1.ShowBalloonHint;
end;

procedure TfrmPrincipal.btCheckNumberClick(Sender: TObject);
begin
  if not TInject1.Auth then
     Exit;

  TInject1.CheckIsValidNumber(ed_num.Text);
end;

procedure TfrmPrincipal.btSendContactClick(Sender: TObject);
begin
  try
    if not TInject1.Auth then
       Exit;

    TInject1.sendContact(ed_num.Text, mem_message.Text);
  finally
    ed_num.SelectAll;
    ed_num.SetFocus;
  end;
end;

procedure TfrmPrincipal.btSendTextAndFileClick(Sender: TObject);
Begin
  if not OpenDialog1.Execute then
     Exit;

  try
    if not TInject1.Auth then
       exit;

    TInject1.SendFile(ed_num.Text, openDialog1.FileName,  mem_message.Text);
  finally
    ed_num.SelectAll;
    ed_num.SetFocus;
  end;
end;

procedure TfrmPrincipal.btIsConnectedClick(Sender: TObject);
begin
  if not TInject1.Auth then
     Exit;

  TInject1.CheckIsConnected();
end;

procedure TfrmPrincipal.Button2Click(Sender: TObject);
begin
  TInject1.getAllContacts;
end;

procedure TfrmPrincipal.Button3Click(Sender: TObject);
begin
  TInject1.getAllChats;
end;

procedure TfrmPrincipal.Button4Click(Sender: TObject);
begin
  if not TInject1.auth then
    exit;

   TInject1.Disconnect;
end;

procedure TfrmPrincipal.Button6Click(Sender: TObject);
begin
//Funcao experimentar para configuraca de proxy de rede(Ainda nao testada)
//  if not TInject1.ConfigureNetwork Then
//     ShowMessage('Erro ao tentar iniciar configuração');
  ShowMessage('Acesse o codigo. Access the code.');
end;

procedure TfrmPrincipal.btStatusBatClick(Sender: TObject);
begin
  if not TInject1.Auth then
     Exit;

  TInject1.GetBatteryStatus;
end;

procedure TfrmPrincipal.btSendTextClick(Sender: TObject);
begin
  try
    if not TInject1.Auth then
       Exit;

    TInject1.send(ed_num.Text, mem_message.Text);
  finally
    ed_num.SelectAll;
    ed_num.SetFocus;
  end;
end;

procedure TfrmPrincipal.Button7Click(Sender: TObject);
begin
  TInject1.GetUnReadMessages;
end;

procedure TfrmPrincipal.chk_3Click(Sender: TObject);
begin
  ExecuteFilter;
end;

procedure TfrmPrincipal.ed_numChange(Sender: TObject);
var
  LRet: TStringList;
  I: Integer;
  Ltexto: String;
begin
  //Esta processando outro CHANGE
  if not CheckBox5.Checked then
     Exit;

  if ed_num.AutoComplete = False Then
     Exit;

  {
   ##### modo 1
  TInject1.GetContacts(ComboBox1.Text, ComboBox1.Items);
  if ComboBox1.Items.Count <= 0 then
     ComboBox1.Style := csSimple else
     ComboBox1.Style := csOwnerDrawFixed;


  ##### modo 2
   }

  LRet:= TStringList.Create;
  ed_num.AutoComplete := False;
  Ltexto                 := ed_num.Text;
  try
    ed_num.Items.Clear;
    if LRet.Count <= 0 then
       ed_num.Style := csSimple else
       ed_num.Style := csDropDown;

    for I := 0 to LRet.Count -1 do
       ed_num.Items.Add(LRet.Strings[i]);
  finally
    ed_num.Text         := Ltexto;
    ed_num.SelStart     := Length(Ltexto);
    ed_num.AutoComplete := True;
    FreeAndNil(LRet);
  end;
end;

procedure TfrmPrincipal.ed_numSelect(Sender: TObject);
begin
  if not CheckBox5.Checked then
     Exit;

  if (ed_num.ItemIndex >=0) and (ed_num.Items.Count > 0) then
  Begin
    ed_num.AutoComplete := False;
    ed_num.Text         := ed_num.Items.Strings[ed_num.ItemIndex];
    ed_num.AutoComplete := True;
  End;
end;

procedure TfrmPrincipal.ExecuteFilter;
begin
//
end;

procedure TfrmPrincipal.Edt_DDIPDRExit(Sender: TObject);
begin
  if FIniciando then
     Exit;

  TInject1.Config.AutoDelete            := chk_apagarMsg.Checked;
  //TInject1.Config.AutoStart           := chk_AutoStart.Checked;

  TInject1.Config.ControlSendTimeSec    := StrToIntDef(LabeledEdit1.Text, 8);
  TInject1.Config.SecondsMonitor        := StrToIntDef(LabeledEdit2.Text, 3);


//  TInject1.Config.ShowRandom          := .Checked;
//  TInject1.Config.SyncContacts        := .Checked;

  TInject1.AjustNumber.LengthDDI         := StrToIntDef(Edt_LengDDI.text , 2);
  TInject1.AjustNumber.LengthDDD         := StrToIntDef(Edt_LengDDD.text , 2);
  TInject1.AjustNumber.LengthPhone       := StrToIntDef(Edt_LengFone.text, 8);
  TInject1.AjustNumber.DDIDefault        := StrToIntDef(Edt_DDIPDR.text  , 55);
  TInject1.AjustNumber.AllowOneDigitMore := CheckBox4.Checked;

  ExecuteFilter;

  TInject1.LanguageInject                := TLanguageInject(ComboBox1.ItemIndex);
end;

procedure TfrmPrincipal.TInject1DisconnectedBrute(Sender: TObject);
begin
  ShowMessage('Conexão foi finalizada pelo celular');
end;

procedure TfrmPrincipal.TInject1ErroAndWarning(Sender: TObject;
  const PError, PInfoAdc: string);
begin
  Timer2.Enabled        := False;
  Lbl_Avisos.Caption    := Perror + ' -> ' + PInfoAdc;
  Lbl_Avisos.Font.Color := clBlack;

  Timer2.Enabled        := True;
end;

procedure TfrmPrincipal.TInject1GetAllContactList(
  const AllContacts: TRetornoAllContacts);
var
  AContact: TContactClass;
begin
  listaContatos.Clear;

  for AContact in AllContacts.result do
  begin
    if chk_grupos.Checked = true then
    begin
      if (AContact.name = '') or (AContact.name.IsEmpty = true) then
        AddContactList(AContact.id);
    end else
    Begin
       AddContactList(AContact.id + ' ' +AContact.name);
    End;
  end;
  AContact := nil;
end;

procedure TfrmPrincipal.TInject1GetBatteryLevel(Sender: TObject);
begin
  Lbl_Avisos.Caption  := 'O telefone '  + TInject(Sender).MyNumber + ' está com '+ TInject(Sender).BatteryLevel.ToString + '% de bateria';
  btStatusBat.caption := 'Status da bateria (' + TInject(Sender).BatteryLevel.ToString + '%)';
end;

procedure TfrmPrincipal.TInject1GetChatList(const Chats: TChatList);
var
  AChat: TChatClass;
begin
  listaChats.Clear;
  for AChat in Chats.result do
    AddChatList('('+ AChat.unreadCount.ToString + ') ' + AChat.name + ' - ' + AChat.id);
end;

procedure TfrmPrincipal.TInject1GetCheckIsValidNumber(Sender: TObject;
  Number: string; IsValid: Boolean);
begin
  if IsValid then
     ShowMessage('Whatsapp Valid') else
     ShowMessage('Whatsapp Invalid') ;
end;

procedure TfrmPrincipal.TInject1GetMyNumber(Sender: TObject);
begin
  lblNumeroConectado.Caption :=   TInject(Sender).MyNumber;
end;

procedure TfrmPrincipal.TInject1GetQrCode(Const Sender: TObject;  const QrCode: TResultQRCodeClass);
begin
  if TInject1.FormQrCodeType = TFormQrCodeType(Ft_none) then
     Image1.Picture := QrCode.AQrCodeImage else
     Image1.Picture := nil; //Limpa foto
end;

procedure TfrmPrincipal.TInject1GetStatus(Sender: TObject);//Const PStatus : TStatusType; Const PFormQrCode: TFormQrCodeType);
begin
  if not Assigned(Sender) Then
     Exit;

  try
    TabSheet3.TabVisible   := (TInject(Sender).Status = Inject_Initialized);
    TabSheet4.TabVisible   := (TInject(Sender).Status = Inject_Initialized);
  Except
  end;

  if (TInject(Sender).Status = Inject_Initialized) then
  begin
    lblStatus.Caption            := 'Online';
    lblStatus.Font.Color         := $0000AE11;
    SpeedButton3.Enabled              := true;
  end else
  begin
    SpeedButton3.Enabled              := false;
    lblStatus.Caption            := 'Offline';
    lblStatus.Font.Color         := $002894FF;
  end;

  StatusBar1.Panels[1].Text  := lblStatus.Caption;
  whatsOn.Visible            := SpeedButton3.enabled;
  lblNumeroConectado.Visible := whatsOn.Visible;
  whatsOff.Visible           := Not whatsOn.Visible;


  Label3.Visible := False;
  case TInject(Sender).status of
    Server_ConnectedDown       : Label3.Caption := TInject(Sender).StatusToStr;
    Server_Disconnected        : Label3.Caption := TInject(Sender).StatusToStr;
    Server_Disconnecting       : Label3.Caption := TInject(Sender).StatusToStr;
    Server_Connected           : Label3.Caption := '';
    Server_Connecting          : Label3.Caption := TInject(Sender).StatusToStr;
    Inject_Initializing        : Label3.Caption := TInject(Sender).StatusToStr;
    Inject_Initialized         : Label3.Caption := TInject(Sender).StatusToStr;
    Server_ConnectingNoPhone   : Label3.Caption := TInject(Sender).StatusToStr;
    Server_ConnectingReaderCode: Label3.Caption := TInject(Sender).StatusToStr;
    Server_TimeOut             : Label3.Caption := TInject(Sender).StatusToStr;
    Inject_Destroying          : Label3.Caption := TInject(Sender).StatusToStr;
    Inject_Destroy             : Label3.Caption := TInject(Sender).StatusToStr;
  end;
  If Label3.Caption <> '' Then
     Label3.Visible := true;


  If TInject(Sender).Status in [Server_ConnectingNoPhone, Server_TimeOut] Then
  Begin
    if TInject(Sender).FormQrCodeType = Ft_Desktop then
    Begin
       if TInject(Sender).Status = Server_ConnectingNoPhone then
          TInject1.FormQrCodeStop;
    end else
    Begin
      if TInject(Sender).Status = Server_ConnectingNoPhone then
      Begin
        if not TInject(Sender).FormQrCodeShowing then
           TInject(Sender).FormQrCodeShowing := True;
      end else
      begin
        TInject(Sender).FormQrCodeReloader;
      end;
    end;
  end;
end;

procedure TfrmPrincipal.TInject1GetUnReadMessages(Chats: TChatList);
var
  AChat: TChatClass;
  AMessage: TMessagesClass;
  contato, telefone: string;
begin
    for AChat in Chats.result do
    begin
      for AMessage in AChat.messages do
      begin
        if not AChat.isGroup then //Não exibe mensages de grupos
        begin
          if not AMessage.sender.isMe then  //Não exibe mensages enviadas por mim
          begin
            memo_unReadMessagen.Clear;
            //memo_unReadMessagen.Lines.Add(PChar( 'Nome Contato: ' + Trim(AMessage.Sender.pushName)));
            //memo_unReadMessagen.Lines.Add(PChar( 'Chat Id     : ' + AChat.id));
            //memo_unReadMessagen.Lines.Add(PChar(AMessage.mediaData.&type) + 'Lat: '+AMessage.lat.ToString + ' Long: '+ AMessage.lng.ToString);
            memo_unReadMessagen.Lines.Add(PChar(AMessage.body));

            telefone  :=  Copy(AChat.id, 3, Pos('@', AChat.id) - 3);
            contato   :=  AMessage.Sender.pushName;
            TInject1.ReadMessages(AChat.id);

            if chk_AutoResposta.Checked then
               VerificaPalavraChave(AMessage.body, '', telefone, contato);
          end;
        end;
      end;
    end;
end;


procedure TfrmPrincipal.TInject1IsConnected(Sender: TObject;
  Connected: Boolean);
begin
  if Connected = true then
  showMessage('Conectado / Connected') else
  showMessage('Desconectado / Not connected')
end;

procedure TfrmPrincipal.TInject1LowBattery(Sender: TObject);
begin
  Timer2.Enabled        := False;
  Lbl_Avisos.Caption    := 'Alarme de BATERIA.  Você está com ' + TInject(Sender).BatteryLevel.ToString + '%';
  Lbl_Avisos.Font.Color := clRed;
  Timer2.Enabled        := True;
end;

procedure TfrmPrincipal.listaChatsDblClick(Sender: TObject);
begin
  ed_num.Text := TInject1.GetChat(listaChats.Selected.Index).id;
end;

procedure TfrmPrincipal.listaContatosClick(Sender: TObject);
begin
  mem_message.Text := Copy(listaContatos.Items[listaContatos.Selected.Index].SubItems[1], 0,
                      Pos('@', listaContatos.Items[listaContatos.Selected.Index].SubItems[1]))+'c.us';
end;

procedure TfrmPrincipal.listaContatosDblClick(Sender: TObject);
begin
  ed_num.Text :=  Copy(listaContatos.Items[listaContatos.Selected.Index].SubItems[1], 0,
                  Pos('@', listaContatos.Items[listaContatos.Selected.Index].SubItems[1]))+'c.us';
end;

procedure TfrmPrincipal.SpeedButton1Click(Sender: TObject);
begin
  if not TInject1.Auth(false) then
  Begin
    TInject1.FormQrCodeType := TFormQrCodeType(Rdb_FormaConexao.ItemIndex);
    TInject1.FormQrCodeStart;
  End;

  if not TInject1.FormQrCodeShowing then
     TInject1.FormQrCodeShowing := True;

end;

procedure TfrmPrincipal.SpeedButton2Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://mikelustosa.kpages.online/tinject', '', '', 1);
end;

procedure TfrmPrincipal.SpeedButton3Click(Sender: TObject);
begin
  if not TInject1.auth then
    exit;

   TInject1.Logtout;
   TInject1.Disconnect;
end;

procedure TfrmPrincipal.Timer2Timer(Sender: TObject);
begin
  Lbl_Avisos.Caption := '';
  Timer2.Enabled := False;
end;

procedure TfrmPrincipal.TrayIcon1Click(Sender: TObject);
begin
  TrayIcon1.Visible := False;
  Show();
  WindowState := wsNormal;
  Application.BringToFront();
end;

function TfrmPrincipal.VerificaPalavraChave(pMensagem, pSessao, pTelefone,
  pContato: String): Boolean;
begin
  Result := False;
   if ( POS('OLA', AnsiUpperCase(pMensagem))        > 0 ) or ( POS('OLÁ', AnsiUpperCase(pMensagem))       > 0 ) or
      ( POS('BOM DIA', AnsiUpperCase(pMensagem))    > 0 ) or ( POS('BOA TARDE', AnsiUpperCase(pMensagem)) > 0 ) or
      ( POS('BOA NOITE', AnsiUpperCase(pMensagem))  > 0 ) or ( POS('INÍCIO', AnsiUpperCase(pMensagem))    > 0 ) or
      ( POS('HELLO', AnsiUpperCase(pMensagem))      > 0 ) or ( POS('HI', AnsiUpperCase(pMensagem))        > 0 ) or
      ( POS('INICIO', AnsiUpperCase(pMensagem))     > 0 ) or ( POS('OI', AnsiUpperCase(pMensagem))        > 0 )then
      begin
        mensagem :=
        TInject1.Emoticons.AtendenteH+ 'Olá *'+pContato+'!*\n\n'+
        'Você está no auto atendimento do *TInject*!\n\n'+
        'Digite um número:\n\n'+
        TInject1.Emoticons.Um             +' Suporte\n\n'+
        TInject1.Emoticons.Dois           +' Consultar CEP\n\n'+
        TInject1.Emoticons.Tres           +' Financeiro\n\n'+
        TInject1.Emoticons.Quatro         +' Horários de atendimento\n\n';
        TInject1.SendFile(pTelefone, ExtractFileDir(Application.ExeName)+'\Img\softmais.png', mensagem);
        Result := True;
        exit;
      end;
   exit;
end;

procedure TfrmPrincipal.whatsOnClick(Sender: TObject);
begin
  if not TInject1.FormQrCodeShowing then
     TInject1.FormQrCodeShowing := True;
end;

end.
