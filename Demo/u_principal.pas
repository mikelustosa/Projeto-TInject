unit u_principal;

interface

uses

  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,  Vcl.ExtCtrls,

  //############ ATENÇÃO AQUI ####################
  //units adicionais obrigatórias
   uTInject.ConfigCEF, uCEFWinControl,  uTInject,

  //units Opcionais (dependendo do que irá fazer)
   System.NetEncoding, uTInject.Classes,
  //###############################################

  Vcl.StdCtrls, System.ImageList, Vcl.ImgList, Vcl.AppEvnts, Vcl.ComCtrls,
  Vcl.Imaging.pngimage, Vcl.Buttons, IdBaseComponent, IdAntiFreezeBase,
  IdAntiFreeze, Vcl.Mask, uTInject.Constant;

type
  TfrmPrincipal = class(TForm)
    InjectWhatsapp1: TInjectWhatsapp;
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
    ButtonSelecionarArquivo: TButton;
    btEnviaTextoArq: TButton;
    btEnviaTexto: TButton;
    GroupBox4: TGroupBox;
    btStatusBat: TButton;
    Panel1: TPanel;
    groupListaChats: TGroupBox;
    Button3: TButton;
    listaChats: TListView;
    groupListaContatos: TGroupBox;
    listaContatos: TListView;
    Button2: TButton;
    Splitter1: TSplitter;
    ed_num: TComboBox;
    Pnl_Config: TPanel;
    Label8: TLabel;
    chk_grupos: TCheckBox;
    chk_apagarMsg: TCheckBox;
    chk_AutoResposta: TCheckBox;
    edtDelay: TEdit;
    CheckBox1: TCheckBox;
    Pnl_FONE: TPanel;
    Edt_LengDDD: TLabeledEdit;
    Edt_LengDDI: TLabeledEdit;
    Edt_LengFone: TLabeledEdit;
    Edt_DDIPDR: TLabeledEdit;
    CheckBox2: TCheckBox;
    LabeledEdit1: TLabeledEdit;
    LabeledEdit2: TLabeledEdit;
    CheckBox3: TCheckBox;
    LabeledEdit3: TLabeledEdit;
    chk_AutoStart: TCheckBox;
    LabeledEdit4: TLabeledEdit;
    Panel2: TPanel;
    whatsOn: TImage;
    whatsOff: TImage;
    imgQrcode: TImage;
    lblStatus: TLabel;
    lblQrcode: TLabel;
    lblNumeroConectado: TLabel;
    CheckBox4: TCheckBox;
    Lbl_Avisos: TLabel;
    Timer2: TTimer;
    CheckBox5: TCheckBox;
    Button1: TButton;
    Button4: TButton;
    Label3: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure whatsOnClick(Sender: TObject);
    procedure whatsOffClick(Sender: TObject);
    procedure btEnviaTextoClick(Sender: TObject);
    procedure btEnviaTextoArqClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure InjectWhatsapp1GetUnReadMessages(Chats: TChatList);
    procedure listaChatsDblClick(Sender: TObject);
    procedure listaContatosDblClick(Sender: TObject);
    procedure TrayIcon1Click(Sender: TObject);
    procedure ApplicationEvents1Minimize(Sender: TObject);
    procedure btn_clearClick(Sender: TObject);
    procedure imgQrcodeClick(Sender: TObject);
    procedure InjectWhatsapp1GetStatus(Const PStatus : TStatusType; Const PFormQrCode: TFormQrCodeType);
    procedure edtDelayKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ButtonSelecionarArquivoClick(Sender: TObject);
    procedure btStatusBatClick(Sender: TObject);
    procedure InjectWhatsapp1GetBatteryLevel(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure Edt_DDIPDRExit(Sender: TObject);
    procedure ed_numChange(Sender: TObject);
    procedure ed_numSelect(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure InjectWhatsapp1GetMyNumber(Sender: TObject);
    procedure InjectWhatsapp1LowBattery(Const POnAlarm, PBatteryCharge: Integer);
    procedure InjectWhatsapp1ErroAndWarning(Sender: TObject; const PError,
      PInfoAdc: string);
    procedure Timer2Timer(Sender: TObject);
    procedure InjectWhatsapp1GetAllContactList(
      const AllContacts: TRetornoAllContacts);
    procedure InjectWhatsapp1GetChatList(const Chats: TChatList);
  private
    { Private declarations }
//    idMessageGlobal: string;
    vExtension,  vFileName: string;
    vBase64File: TBase64Encoding;
    procedure CarregarContatos;
    procedure CarregarChats;
  public
    { Public declarations }
    vBase64Str, vFileNameURL              : string;

    //Video aula
    mensagem                              : string;
    arrayFila                             : array [0..0] of string;
    arraySessao                           : array [0..0] of string;
    arrayTimer                            : array [0..0] of string;
    arrayFilaEspera                       : array [0..0] of string;
    function  VerificaPalavraChave( pMensagem, pSessao, pTelefone, pContato : String ) : Boolean;
    //Video aula

    procedure AddContactList(ANumber: String);
    procedure AddChatList(ANumber: String);

  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

uses
  uTInject.Console, System.StrUtils, uTInject.Diversos;

{$R *.dfm}

procedure TfrmPrincipal.FormCreate(Sender: TObject);
begin
//  ReportMemoryLeaksOnShutdown  := True;

//  idMessageGlobal              := 'start';
  PageControl1.ActivePageIndex := 0;

  //Define os padrões DO BRASIL
//  InjectWhatsapp1.AjustNumber.AutoAdjust := True;
 // InjectWhatsapp1.AjustNumber.LengthDDI  := 2;
 // InjectWhatsapp1.AjustNumber.LengthDDD  := 2;
 // InjectWhatsapp1.AjustNumber.LengthPhone:= 8; //Whats antigo e 8 digitos
 // InjectWhatsapp1.AjustNumber.DDIDefault := 55;
  TabSheet3.TabVisible                   := False;
  TabSheet4.TabVisible                   := False;

  edtDelay.Text         := injectWhatsapp1.Config.AutoDelay.ToString          ;
  chk_apagarMsg.Checked := injectWhatsapp1.Config.AutoDelete         ;
  chk_AutoStart.Checked := injectWhatsapp1.Config.AutoStart          ;
  CheckBox2.Checked     := InjectWhatsapp1.Config.ControlSend        ;
  LabeledEdit1.text     := InjectWhatsapp1.Config.ControlSendTimeSec.ToString ;
  LabeledEdit2.Text     := InjectWhatsapp1.Config.SecondsMonitor.ToString     ;
  LabeledEdit4.Text     := InjectWhatsapp1.Config.LowBatteryIs.ToString;

//  injectWhatsapp1.Config.ShowRandom          := .Checked;
//  injectWhatsapp1.Config.SyncContacts        := .Checked;

  CheckBox3.Checked := InjectWhatsapp1.InjectJS.AutoUpdate       ;
  LabeledEdit3.Text := InjectWhatsapp1.InjectJS.AutoUpdateTimeOut.ToString;

  CheckBox1.Checked :=  injectWhatsapp1.AjustNumber.AutoAdjust   ;
  Edt_LengDDI.text  := InjectWhatsapp1.AjustNumber.LengthDDI.ToString     ;
  Edt_LengDDD.text  := InjectWhatsapp1.AjustNumber.LengthDDD.ToString     ;
  Edt_LengFone.text := InjectWhatsapp1.AjustNumber.LengthPhone.ToString   ;
  Edt_DDIPDR.text   := InjectWhatsapp1.AjustNumber.DDIDefault.ToString    ;
  CheckBox4.Checked  := InjectWhatsapp1.AjustNumber.AllowOneDigitMore      ;
end;

procedure TfrmPrincipal.FormClose(Sender: TObject; var Action: TCloseAction);
begin
//  Halt;
  InjectWhatsapp1.ShutDown;
  application.Terminate;
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

procedure TfrmPrincipal.ApplicationEvents1Minimize(Sender: TObject);
begin
  self.Hide();
  self.WindowState := wsMinimized;
  trayIcon1.Visible := true;
  TrayIcon1.Animate := True;
  TrayIcon1.ShowBalloonHint;
end;

procedure TfrmPrincipal.btn_clearClick(Sender: TObject);
var
  i: integer;
begin
  for i := 0 to  length(arrayTimer) -1 do
  begin
    if arrayTimer[i] <> '' then
    begin
      if (time - strToTime(arrayTimer[i])) >= strToTime('00:00:10') then
      begin
        mensagem := 'Seu número *'+arrayFila[i]+'* foi removido da fila de atendimento.\n\n*Obrigado* por entrar em _contato_ e até breve!';
        injectWhatsapp1.send(arrayFila[i], mensagem);
        arrayFila[i]    := '';
        arraySessao[i]  := '';
        arrayTimer[i]   := '';
      end;
    end;
  end;
end;


procedure TfrmPrincipal.btEnviaTextoArqClick(Sender: TObject);
begin
  try
    if not GlobalCEFApp.InjectWhatsApp.Auth then
    begin
      application.MessageBox('Você não está autenticado.','TInject', mb_iconwarning + mb_ok);
      abort;
    end;

    if (Trim(ed_num.Text) = '') or (Trim(mem_message.Text) = '') or (vBase64Str = '') then
    begin
      application.MessageBox('Não existe nenhum conteudo a ser enviado.','TInject', mb_iconwarning + mb_ok);
      abort;
    end;


    if vBase64File <> nil then
    begin
      InjectWhatsapp1.sendBase64(vBase64Str, ed_num.Text, vFileName, mem_message.Text);
      //sleep(1000);
      //InjectWhatsapp1.send(ed_num.Text, mem_message.Text);
      vBase64File := nil;
      mem_message.SelectAll;
//      application.MessageBox('Arquivo enviado com sucesso!','TInject whatsapp', mb_iconAsterisk + mb_ok);
    end;
  finally
    ed_num.SelectAll;
    ed_num.SetFocus;
  end;
end;

procedure TfrmPrincipal.Button1Click(Sender: TObject);
begin
  if not InjectWhatsapp1.Auth then
  Begin
    application.MessageBox('Você não está conectado.','TInject', mb_iconwarning + mb_ok);
    abort;
  End;

  InjectWhatsapp1.ShutDown();
end;

procedure TfrmPrincipal.Button2Click(Sender: TObject);
begin
  CarregarContatos;
end;

procedure TfrmPrincipal.Button3Click(Sender: TObject);
begin
  CarregarChats;
end;

procedure TfrmPrincipal.btStatusBatClick(Sender: TObject);
begin
  if not GlobalCEFApp.InjectWhatsApp.Auth then
  begin
    application.MessageBox('Você não está autenticado.','TInject', mb_iconwarning + mb_ok);
    abort;
  end;

  InjectWhatsapp1.GetBatteryStatus;
end;

procedure TfrmPrincipal.btEnviaTextoClick(Sender: TObject);
begin
  try
    if not GlobalCEFApp.InjectWhatsApp.Auth then
    begin
      application.MessageBox('Você não está autenticado.','TInject', mb_iconwarning + mb_ok);
      abort;
    end;

    if (Trim(ed_num.Text) = '') or (Trim(mem_message.Text) = '') then
    begin
      application.MessageBox('Não existe nenhum conteudo a ser enviado.','TInject', mb_iconwarning + mb_ok);
      abort;
    end;

    InjectWhatsapp1.send(ed_num.Text, mem_message.Text);
    mem_message.SelectAll;
  finally
    ed_num.SelectAll;
    ed_num.SetFocus;
  end;
end;

procedure TfrmPrincipal.Button7Click(Sender: TObject);
begin
  InjectWhatsapp1.GetUnReadMessages;
end;

procedure TfrmPrincipal.ButtonSelecionarArquivoClick(Sender: TObject);
var
  vFilestream: TMemoryStream;
  caminhoArquivo : String;
begin
  if OpenDialog1.Execute then
  begin
    vBase64File := TBase64Encoding.Create;
    vFilestream := TMemoryStream.Create;
    vFilestream.LoadFromFile(openDialog1.FileName);
    vExtension := LowerCase(Copy(ExtractFileExt(openDialog1.FileName),2,5));
    vFileName  := ExtractFileName(openDialog1.FileName);
    vFileNameURL := dateToStr(date)+timeToStr(time)+'.'+vExtension;
    if (vExtension = 'pdf') or (vExtension = 'rar')  or (vExtension = 'zip') then
    begin
      vBase64Str := 'data:application/'+vExtension+';base64,'+ String(vBase64File.EncodeBytesToString(vFilestream.Memory, vFilestream.Size));
    end else
    Begin
      if (vExtension = 'mp4') or (vExtension = 'mp3') then
         vBase64Str := 'data:application/'+vExtension+';base64,'+ String(vBase64File.EncodeBytesToString(vFilestream.Memory, vFilestream.Size))  Else
         vBase64Str := 'data:image/'+vExtension+';base64,' + String(vBase64File.EncodeBytesToString(vFilestream.Memory, vFilestream.Size));
    End;
    caminhoArquivo := openDialog1.FileName;
    vFilestream.Free;
  end;
end;

procedure TfrmPrincipal.CarregarChats;
begin
  InjectWhatsapp1.getAllChats;
end;

procedure TfrmPrincipal.CarregarContatos;
begin
  InjectWhatsapp1.getAllContacts;
end;

procedure TfrmPrincipal.CheckBox1Click(Sender: TObject);
begin
  Pnl_FONE.Enabled  := CheckBox1.Checked;
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
  InjectWhatsapp1.GetContacts(ComboBox1.Text, ComboBox1.Items);
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
    InjectWhatsapp1.GetContacts(Ltexto, LRet);
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

procedure TfrmPrincipal.edtDelayKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if edtDelay.Text = '' then
  begin
    edtDelay.Text := '0';
  end else
  begin
    injectWhatsapp1.Config.AutoDelay := strToInt(edtDelay.Text);
  end;
end;

procedure TfrmPrincipal.Edt_DDIPDRExit(Sender: TObject);
begin
  injectWhatsapp1.Config.AutoDelay           := StrToIntDef(edtDelay.Text, 5);
  injectWhatsapp1.Config.AutoDelete          := chk_apagarMsg.Checked;
  injectWhatsapp1.Config.AutoStart           := chk_AutoStart.Checked;
  InjectWhatsapp1.Config.ControlSend         := CheckBox2.Checked;
  InjectWhatsapp1.Config.ControlSendTimeSec  := StrToIntDef(LabeledEdit1.Text, 8);
  InjectWhatsapp1.Config.SecondsMonitor      := StrToIntDef(LabeledEdit2.Text, 3);
  InjectWhatsapp1.Config.LowBatteryIs        := StrToIntDef(LabeledEdit4.Text, 30);

//  injectWhatsapp1.Config.ShowRandom          := .Checked;
//  injectWhatsapp1.Config.SyncContacts        := .Checked;

  InjectWhatsapp1.InjectJS.AutoUpdate        := CheckBox3.Checked;
  InjectWhatsapp1.InjectJS.AutoUpdateTimeOut := StrToIntDef(LabeledEdit3.Text, 4);

  injectWhatsapp1.AjustNumber.AutoAdjust     := CheckBox1.Checked;
  InjectWhatsapp1.AjustNumber.LengthDDI      := StrToIntDef(Edt_LengDDI.text , 2);
  InjectWhatsapp1.AjustNumber.LengthDDD      := StrToIntDef(Edt_LengDDD.text , 2);
  InjectWhatsapp1.AjustNumber.LengthPhone    := StrToIntDef(Edt_LengFone.text, 8);
  InjectWhatsapp1.AjustNumber.DDIDefault     := StrToIntDef(Edt_DDIPDR.text  , 55);
  InjectWhatsapp1.AjustNumber.AllowOneDigitMore := CheckBox4.Checked;
end;

Procedure TfrmPrincipal.imgQrcodeClick(Sender: TObject);
begin
  InjectWhatsapp1.FormQrCodeType := Ft_Desktop;
  InjectWhatsapp1.FormQrCodeStart;
end;

procedure TfrmPrincipal.InjectWhatsapp1ErroAndWarning(Sender: TObject;
  const PError, PInfoAdc: string);
begin
  Timer2.Enabled := False;
  Lbl_Avisos.Caption := Perror + ' -> ' + PInfoAdc;
  Lbl_Avisos.Font.Color := clBlack;

  Timer2.Enabled := True;
end;

procedure TfrmPrincipal.InjectWhatsapp1GetAllContactList(
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
       AddContactList(AContact.id)
    end
    else
        AddContactList(AContact.id + ' ' +AContact.name);
  end;
end;

procedure TfrmPrincipal.InjectWhatsapp1GetBatteryLevel(Sender: TObject);
begin
  btStatusBat.caption := 'Nível da bateria: '+ TInjectWhatsapp(Sender).BatteryLevel.ToString + '%';
end;

procedure TfrmPrincipal.InjectWhatsapp1GetChatList(const Chats: TChatList);
var
  AChat: TChatClass;
begin
  listaChats.Clear;
  for AChat in Chats.result do
  begin
    AddChatList('('+ AChat.unreadCount.ToString + ') '
               + AChat.name
               + ' - ' + AChat.id);
  end;
end;

procedure TfrmPrincipal.InjectWhatsapp1GetMyNumber(Sender: TObject);
begin
  lblNumeroConectado.Caption :=   TInjectWhatsapp(Sender).MyNumber;
end;

procedure TfrmPrincipal.InjectWhatsapp1GetStatus(Const PStatus : TStatusType; Const PFormQrCode: TFormQrCodeType);
begin
  try
    TabSheet3.TabVisible   := (PStatus = Whats_Connected);
    TabSheet4.TabVisible   := (PStatus = Whats_Connected);
  Except
  end;

  if (PStatus = Whats_Connected) then
  begin
    lblStatus.Caption            := 'Online';
    lblStatus.Font.Color         := $0000AE11;
  end
  else
  begin
    lblStatus.Caption            := 'Offline';
    lblStatus.Font.Color         := $002894FF;
  end;
  whatsOn.Visible            := (PStatus = Whats_Connected);
  lblNumeroConectado.Visible := whatsOn.Visible;
  whatsOff.Visible           := Not whatsOn.Visible;
  lblQrcode.Visible          := whatsOff.Visible;
  imgQrcode.Visible          := whatsOff.Visible;


  Label3.Visible := False;
  case pstatus of
    Whats_Disconnected        : Label3.Caption := '';
    Whats_Disconnecting       : Label3.Caption := '';
    Whats_Connected           : Label3.Caption := '';
    Whats_Connecting          : Label3.Caption := 'Aguarde, Conectando..';
    Whats_ConnectingNoPhone   : Label3.Caption := 'Telefone Desligado';
    Whats_ConnectingReaderCode: Label3.Caption := 'Aguardando Leitura QRCODE';
    Whats_TimeOut             : Label3.Caption := 'Timeout Leitura';
    Whats_Destroying          : Label3.Caption := 'Finalizando Sessão';
    Whats_Destroy             : Label3.Visible := False;
  end;
  If Label3.Caption <> '' Then
     Label3.Visible := true;


  If PStatus in [Whats_ConnectingNoPhone, Whats_TimeOut] Then
  Begin
    if PFormQrCode = Ft_Desktop then
    Begin
       if PStatus = Whats_ConnectingNoPhone then
          InjectWhatsapp1.FormQrCodeStop;
    end else
    Begin
      if InjectWhatsapp1.Status = Whats_ConnectingNoPhone then
      Begin
        if not InjectWhatsapp1.FormQrCodeShowing then
           InjectWhatsapp1.FormQrCodeShowing := True;
      end else
      begin
        InjectWhatsapp1.FormQrCodeReloader;
      end;
    end;
  end;
end;

procedure TfrmPrincipal.InjectWhatsapp1GetUnReadMessages(Chats: TChatList);
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
            memo_unReadMessagen.Lines.Add(PChar(AMessage.body));
            //memo_unReadMessagen.Lines.Add(PChar( 'ID Message  : ' + AMessage.t.ToString));
            //memo_unReadMessagen.Lines.Add('__________________________________');
            telefone  :=  Copy(AChat.id, 3, Pos('@', AChat.id) - 3);
            contato   := AMessage.Sender.pushName;
            injectWhatsapp1.ReadMessages(AChat.id);

            if chk_AutoResposta.Checked then
               VerificaPalavraChave(AMessage.body, '', telefone, contato);
          end;
        end;
      end;
    end;
end;

procedure TfrmPrincipal.InjectWhatsapp1LowBattery(Const POnAlarm, PBatteryCharge: Integer);
begin
  Timer2.Enabled        := False;
  Lbl_Avisos.Caption    := 'Alarme de BATERIA.  Você está com ' + (PBatteryCharge).ToString + '%';
  Lbl_Avisos.Font.Color := clRed;
  Timer2.Enabled        := True;
end;

procedure TfrmPrincipal.listaChatsDblClick(Sender: TObject);
begin
  ed_num.Text := InjectWhatsapp1.GetChat(listaChats.Selected.Index).id;
end;

procedure TfrmPrincipal.listaContatosDblClick(Sender: TObject);
begin
  ed_num.Text := InjectWhatsapp1.GetContact(listaContatos.Selected.Index).id;
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
        InjectWhatsapp1.Emoticons.AtendenteH+ 'Olá *'+pContato+'!*\n\n'+
        'Você está no auto atendimento do *TInject*!\n\n'+
        'Digite um número:\n\n'+
        InjectWhatsapp1.Emoticons.Um             +' Suporte\n\n'+
        InjectWhatsapp1.Emoticons.Dois           +' Consultar CEP\n\n'+
        InjectWhatsapp1.Emoticons.Tres           +' Financeiro\n\n'+
        InjectWhatsapp1.Emoticons.Quatro         +' Horários de atendimento\n\n';
        vBase64Str := 'data:image/png;base64,' + convertBase64(ExtractFileDir(Application.ExeName)+'\Img\softmais.png');
        InjectWhatsapp1.sendBase64(vBase64Str, pTelefone, '', mensagem);
        Result := True;
        exit;
      end;
   exit;
end;

procedure TfrmPrincipal.whatsOffClick(Sender: TObject);
begin
  InjectWhatsapp1.FormQrCodeType := Ft_Http;
  InjectWhatsapp1.FormQrCodeStart;
end;

procedure TfrmPrincipal.whatsOnClick(Sender: TObject);
begin
 if not InjectWhatsapp1.FormQrCodeShowing then
    InjectWhatsapp1.FormQrCodeShowing := True;
end;

end.
