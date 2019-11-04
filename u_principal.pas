unit u_principal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uCEFWinControl, uCEFWindowParent,
  Vcl.ExtCtrls, uCEFChromium, system.JSON, uClasses,

  //############ ATENÇÃO AQUI ####################
  //units adicionais obrigatórias
  uCEFInterfaces, uCEFConstants, uCEFTypes, UnitCEFLoadHandlerChromium,
  Vcl.StdCtrls, Vcl.ComCtrls, System.ImageList, Vcl.ImgList, uTInject,
  Vcl.Imaging.pngimage, Vcl.Buttons, Vcl.WinXCtrls, System.NetEncoding,
  Vcl.Imaging.jpeg, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, FireDAC.UI.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Phys, FireDAC.Phys.MSSQL, FireDAC.Phys.MSSQLDef,
  FireDAC.VCLUI.Wait, Data.DB, FireDAC.Comp.Client, FireDAC.Comp.DataSet,
  FireDAC.Comp.UI;

  //############ ATENÇÃO AQUI ####################
  //Constantes obrigatórias para controle do destroy do TChromium
  const
  CEFBROWSER_CREATED          = WM_APP + $100;
  CEFBROWSER_CHILDDESTROYED   = WM_APP + $101;
  CEFBROWSER_DESTROY          = WM_APP + $102;

type
  Tfrm_principal = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    ed_num: TEdit;
    Memo1: TMemo;
    listaContatos: TListView;
    ImageList1: TImageList;
    Image1: TImage;
    Button6: TButton;
    mem_message: TMemo;
    Button4: TButton;
    Image2: TImage;
    whatsOff: TImage;
    whatsOn: TImage;
    Timer1: TTimer;
    Label5: TLabel;
    GroupBox1: TGroupBox;
    Label6: TLabel;
    TrackBar1: TTrackBar;
    lbl_track: TLabel;
    sw_delay: TToggleSwitch;
    Label7: TLabel;
    InjectWhatsapp1: TInjectWhatsapp;
    OpenDialog1: TOpenDialog;
    Button1: TButton;
    Button2: TButton;
    sw_grupos: TToggleSwitch;
    Label3: TLabel;
    Label8: TLabel;
    listaChats: TListView;
    Button3: TButton;
    memo_unReadMessagen: TMemo;
    Button8: TButton;
    Label4: TLabel;
    Image3: TImage;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Chromium1BeforeClose(Sender: TObject; const browser: ICefBrowser);
    procedure Timer1Timer(Sender: TObject);
    procedure Chromium1AfterCreated(Sender: TObject;
      const browser: ICefBrowser);
    procedure Chromium1BeforePopup(Sender: TObject; const browser: ICefBrowser;
      const frame: ICefFrame; const targetUrl, targetFrameName: ustring;
      targetDisposition: TCefWindowOpenDisposition; userGesture: Boolean;
      const popupFeatures: TCefPopupFeatures; var windowInfo: TCefWindowInfo;
      var client: ICefClient; var settings: TCefBrowserSettings;
      var extra_info: ICefDictionaryValue; var noJavascriptAccess,
      Result: Boolean);
    procedure Chromium1Close(Sender: TObject; const browser: ICefBrowser;
      var aAction: TCefCloseBrowserAction);
    procedure Chromium1ConsoleMessage(Sender: TObject;
      const browser: ICefBrowser; level: Cardinal; const message,
      source: ustring; line: Integer; out Result: Boolean);
    procedure Chromium1OpenUrlFromTab(Sender: TObject;
      const browser: ICefBrowser; const frame: ICefFrame;
      const targetUrl: ustring; targetDisposition: TCefWindowOpenDisposition;
      userGesture: Boolean; out Result: Boolean);
    procedure Chromium1LoadEnd(Sender: TObject; const browser: ICefBrowser;
      const frame: ICefFrame; httpStatusCode: Integer);
    procedure TrackBar1Change(Sender: TObject);
    procedure sw_delayClick(Sender: TObject);
    procedure whatsOnClick(Sender: TObject);
    procedure whatsOffClick(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure InjectWhatsapp1GetContactList(Sender: TObject);
    procedure InjectWhatsapp1GetChatList(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure InjectWhatsapp1GetUnReadMessages(Chats: TChatList);
    procedure listaChatsDblClick(Sender: TObject);
    procedure listaContatosDblClick(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure InjectWhatsapp1GetQrCode(Sender: TObject);

  protected

    //############ ATENÇÃO AQUI ####################
    //############ ATENÇÃO AQUI ####################
    //############ ATENÇÃO AQUI ####################
    // Inclua essas variáveis e procedures em seus projetos, ajudam à monitorar o destroy correto do TChromium.
    FCanClose : boolean;  // Defina como True em TChromium.OnBeforeClose
    FClosing  : boolean;  // Defina como True no evento CloseQuery.
    procedure WMMove(var aMessage : TWMMove); message WM_MOVE;
    procedure WMMoving(var aMessage : TMessage); message WM_MOVING;
    procedure WMEnterMenuLoop(var aMessage: TMessage); message WM_ENTERMENULOOP;
    procedure WMExitMenuLoop(var aMessage: TMessage); message WM_EXITMENULOOP;
    procedure BrowserCreated(var aMessage : TMessage); message CEF_AFTERCREATED;
    procedure BrowserDestroyMsg(var aMessage : TMessage); message CEF_DESTROY;

  private
    { Private declarations }
    idMessageLocal, idMessageGlobal: string;
    vSessao, vSessao2: integer;
    ChromiumStarted: Boolean;
    vExtension, vBase64, vFileName, IDMessage: string;
    vBase64File: TBase64Encoding;
    procedure CarregarContatos;
    procedure CarregarChats;
  public
    { Public declarations }
    var arrayFila:          array [0..1] of string;
    var arraySessao:        array [0..1] of string;
    var arrayTimer:         array [0..1] of string;
    var arrayFilaEspera:    array [0..1] of string;
    JS1, JS2, contato, mensagem, clienteAtendimento:string;
    cMsg, vNomeContato, vTelefoneContato: string;
    //vSessao: integer;
    nOpcao: string;
    pContato2: string;
    vBase64Str, vFileNameURL: string;
    i: integer;
    procedure AddContactList(ANumber: String);
    procedure AddChatList(ANumber: String);
    function  VerificaPalavraChave(pMensagem, pContato, pTelefone, idMsg: String) : Boolean;
  end;

var
  frm_principal: Tfrm_principal;

implementation

uses
  uCEFApplication, uCefMiscFunctions, u_servicesWhats, System.StrUtils;

{$R *.dfm}

procedure Tfrm_principal.FormCreate(Sender: TObject);
begin
  idMessageGlobal := 'start';
  InjectWhatsapp1.startWhatsapp;
end;

procedure Tfrm_principal.FormShow(Sender: TObject);
begin
  timer1.Enabled := true;
end;

procedure Tfrm_principal.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    application.Terminate;
end;

procedure Tfrm_principal.AddChatList(ANumber: String);
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

procedure Tfrm_principal.AddContactList(ANumber: String);
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

procedure Tfrm_principal.BrowserCreated(var aMessage : TMessage);
begin
  Caption            := '🎯 TInject  || Versão BETA || Envio de mensagem de texto e de imagens png base64 - Contribuições para o projeto entrar em contato: whatsapp (81) 9.96302385 Mike';
  frm_principal.WindowState := wsMaximized;
end;

procedure Tfrm_principal.BrowserDestroyMsg(var aMessage : TMessage);
begin
  //CEFWindowParent1.Free;
end;

procedure Tfrm_principal.WMMove(var aMessage : TWMMove);
begin
  inherited;
end;

procedure Tfrm_principal.WMMoving(var aMessage : TMessage);
begin
  inherited;
end;

procedure Tfrm_principal.WMEnterMenuLoop(var aMessage: TMessage);
begin
  inherited;

  if (aMessage.wParam = 0) and (GlobalCEFApp <> nil) then GlobalCEFApp.OsmodalLoop := True;
end;

procedure Tfrm_principal.WMExitMenuLoop(var aMessage: TMessage);
begin
  inherited;

  if (aMessage.wParam = 0) and (GlobalCEFApp <> nil) then GlobalCEFApp.OsmodalLoop := False;
end;


procedure Tfrm_principal.Button1Click(Sender: TObject);
begin
  if (not Assigned(frm_servicesWhats)) or (Assigned(frm_servicesWhats) and (frm_servicesWhats.vAuth = false)) then
  begin
    application.MessageBox('Você não está autenticado.','TInject', mb_iconwarning + mb_ok);
    abort;
  end;

  if vBase64File <> nil then
  begin
    InjectWhatsapp1.sendBase64(vBase64Str, ed_num.Text, vFileName, mem_message.Text);
    sleep(1000);
    InjectWhatsapp1.send(ed_num.Text, mem_message.Text);
    vBase64File := nil;
    application.MessageBox('Arquivo enviado com sucesso!','TInject whatsapp', mb_iconAsterisk + mb_ok);
  end;
end;

procedure Tfrm_principal.Button2Click(Sender: TObject);
begin
  CarregarContatos;
end;

procedure Tfrm_principal.Button3Click(Sender: TObject);
begin
  CarregarChats;
end;

procedure Tfrm_principal.Button4Click(Sender: TObject);
var
  vFilestream: TMemoryStream;
begin
  if OpenDialog1.Execute then
  begin
    vBase64File := TBase64Encoding.Create;
    vFilestream := TMemoryStream.Create;
    vFilestream.LoadFromFile(openDialog1.FileName);

    vExtension := Copy(ExtractFileExt(openDialog1.FileName),2,5);

    vFileName  := ExtractFileName(openDialog1.FileName);
    vFileNameURL := dateToStr(date)+timeToStr(time)+'.'+vExtension;
    if vExtension = 'pdf' then
    begin
      vBase64Str := 'data:application/'+vExtension+';base64,'+vBase64File.EncodeBytesToString(vFilestream.Memory, vFilestream.Size);
    end else
      if vExtension = 'mp4' then
      begin
        vBase64Str := 'data:application/'+vExtension+';base64,'+vBase64File.EncodeBytesToString(vFilestream.Memory, vFilestream.Size);
      end else
        if vExtension = 'mp3' then
        begin
          vBase64Str := 'data:audio/'+vExtension+';base64,'+vBase64File.EncodeBytesToString(vFilestream.Memory, vFilestream.Size);
        end else
        if vExtension = 'rar' then
        begin
          vBase64Str := 'data:application/'+vExtension+';base64,'+vBase64File.EncodeBytesToString(vFilestream.Memory, vFilestream.Size);
        end else
          begin
            vBase64Str := 'data:image/'+vExtension+';base64,'+vBase64File.EncodeBytesToString(vFilestream.Memory, vFilestream.Size);
          end;

    vFilestream.Free;
  end;
end;

procedure Tfrm_principal.Button6Click(Sender: TObject);
begin
  if (not Assigned(frm_servicesWhats)) or (Assigned(frm_servicesWhats) and (frm_servicesWhats.vAuth = false)) then
  begin
    application.MessageBox('Você não está autenticado.','TInject', mb_iconwarning + mb_ok);
    abort;
  end;

  InjectWhatsapp1.send(ed_num.Text, mem_message.Text);
  application.MessageBox('Mensage enviada com sucesso!','TInject', mb_iconAsterisk + mb_ok);
end;

procedure Tfrm_principal.Button7Click(Sender: TObject);
begin
  InjectWhatsapp1.GetUnReadMessages;
end;

procedure Tfrm_principal.Button8Click(Sender: TObject);
begin
  InjectWhatsapp1.startQrCode;
end;

procedure Tfrm_principal.CarregarChats;
begin
  InjectWhatsapp1.getAllChats;
end;

procedure Tfrm_principal.CarregarContatos;
begin
  InjectWhatsapp1.getAllContacts;
end;

procedure Tfrm_principal.Chromium1AfterCreated(Sender: TObject;
  const browser: ICefBrowser);
begin
  { Agora que o navegador está totalmente inicializado, podemos enviar uma mensagem para
    o formulário principal para carregar a página inicial da web.}
  PostMessage(Handle, CEF_AFTERCREATED, 0, 0);
end;

procedure Tfrm_principal.Chromium1BeforeClose(Sender: TObject;
  const browser: ICefBrowser);
begin
  FCanClose := True;
  PostMessage(Handle, WM_CLOSE, 0, 0);
end;

procedure Tfrm_principal.Chromium1BeforePopup(Sender: TObject;
  const browser: ICefBrowser; const frame: ICefFrame; const targetUrl,
  targetFrameName: ustring; targetDisposition: TCefWindowOpenDisposition;
  userGesture: Boolean; const popupFeatures: TCefPopupFeatures;
  var windowInfo: TCefWindowInfo; var client: ICefClient;
  var settings: TCefBrowserSettings; var extra_info: ICefDictionaryValue;
  var noJavascriptAccess, Result: Boolean);
begin
  // bloqueia todas as janelas pop-up e novas guias
  Result := (targetDisposition in [WOD_NEW_FOREGROUND_TAB, WOD_NEW_BACKGROUND_TAB, WOD_NEW_POPUP, WOD_NEW_WINDOW]);
end;

procedure Tfrm_principal.Chromium1Close(Sender: TObject;
  const browser: ICefBrowser; var aAction: TCefCloseBrowserAction);
begin
  PostMessage(Handle, CEF_DESTROY, 0, 0);
  aAction := cbaDelay;
end;

procedure Tfrm_principal.Chromium1ConsoleMessage(Sender: TObject;
  const browser: ICefBrowser; level: Cardinal; const message, source: ustring;
  line: Integer; out Result: Boolean);
var
  Json: TJSONObject;
begin
 {Aqui devemos pegar o log do console e criar um JSon para percorrer as mensagens recebidas
 pelo whatsApp}
    try
      Json := TJSONObject.Create;
      Json.Parse(TEncoding.UTF8.GetBytes(string(message)), 0);
      Memo1.Lines.Add('Nova mensagem: '+Json.ToString);

    if Json <> nil then
    begin
      Json.Free;
    end;
    finally
      //Json.Free;
    end;
end;

procedure Tfrm_principal.Chromium1LoadEnd(Sender: TObject;
  const browser: ICefBrowser; const frame: ICefFrame; httpStatusCode: Integer);
begin
  //Aqui possível rotina para verificar se usuário está logado e código foi injetado
end;

procedure Tfrm_principal.Chromium1OpenUrlFromTab(Sender: TObject;
  const browser: ICefBrowser; const frame: ICefFrame; const targetUrl: ustring;
  targetDisposition: TCefWindowOpenDisposition; userGesture: Boolean;
  out Result: Boolean);
begin
  //Bloqueia popup do windows e novas abas
  Result := (targetDisposition in [WOD_NEW_FOREGROUND_TAB, WOD_NEW_BACKGROUND_TAB, WOD_NEW_POPUP, WOD_NEW_WINDOW]);
end;

procedure Tfrm_principal.InjectWhatsapp1GetChatList(Sender: TObject);
var
  AChat: TChatClass;
begin
  listaChats.Clear;

  for AChat in InjectWhatsapp1.AllChats.result do
  begin
    AddChatList('('+ AChat.unreadCount.ToString + ') '
               + AChat.name
               + ' - ' + AChat.id);
  end;
end;

procedure Tfrm_principal.InjectWhatsapp1GetContactList(Sender: TObject);
var
  AContact: TContactClass;
begin
  listaContatos.Clear;

  for AContact in InjectWhatsapp1.AllContacts.result do
  begin
    if sw_grupos.isON then
    begin
     if (AContact.name = '') or (AContact.name.IsEmpty = true) then
       AddContactList(AContact.id)
    end
    else
        AddContactList(AContact.id + ' ' +AContact.name);
  end;
end;

procedure Tfrm_principal.InjectWhatsapp1GetQrCode(Sender: TObject);
begin
  frm_servicesWhats.loadQRCode(frm_servicesWhats._Qrcode);
end;

procedure Tfrm_principal.InjectWhatsapp1GetUnReadMessages(Chats: TChatList);
var
  AChat: TChatClass;
  AMessage: TMessagesClass;
  contato, telefone: string;
  vFind: boolean;
  i, j, f, k: integer;
begin
    vFind := false;
    for AChat in Chats.result do
    begin
      for AMessage in AChat.messages do
      begin
          if AMessage.sender.isMe = false then
          begin
            memo_unReadMessagen.Clear;
            memo_unReadMessagen.Lines.Add(PChar( 'Contato: ' + Trim(AMessage.Sender.pushName)));
            memo_unReadMessagen.Lines.Add(PChar( 'Chat Id: ' + AChat.presence.id));
            memo_unReadMessagen.Lines.Add(PChar( 'Fone: ' + contato));
            //memo_unReadMessagen.Lines.Add(PChar( 'LastReceivedKey: ' + AMessage.chat.lastReceivedKey.ToJsonString));
            memo_unReadMessagen.Lines.Add(PChar( 'Mensagem: ' + AMessage.body));
            //memo_unReadMessagen.Lines.Add(PChar( 'Mensagem: ' + AMessage.ack.ToString));
            //memo_unReadMessagen.Lines.Add(PChar( 'Mensagem: ' + AMessage.chat.id));
            //memo_unReadMessagen.Lines.Add(PChar( 'Mensagem: ' + AMessage.chatId));

            //memo_unReadMessagen.Lines.Add(PChar( 'Mensagem: ' + AMessage.chat.t.ToString));
            //memo_unReadMessagen.Lines.Add(PChar( 'Mensagem: ' + AMessage.chat.GetHashCode.ToString));
            //memo_unReadMessagen.Lines.Add(PChar( 'Mensagem: ' + AMessage.chat.t.ToString));
            memo_unReadMessagen.Lines.Add(PChar( 'ID Message: ' + AMessage.t.ToString));
            telefone  :=  Copy(AChat.id, 3, Pos('@', AChat.id) - 3);
            contato   := AMessage.Sender.pushName;

            VerificaPalavraChave(AMessage.body, contato, telefone, idMessageLocal);
          end;
      end;
    end;
end;

procedure Tfrm_principal.listaChatsDblClick(Sender: TObject);
begin
  ed_num.Text := InjectWhatsapp1.AllChats.result[ listaChats.Selected.Index ].id;
end;

procedure Tfrm_principal.listaContatosDblClick(Sender: TObject);
begin
  ed_num.Text := InjectWhatsapp1.AllContacts.result[ listaContatos.Selected.Index ].id;
end;

procedure Tfrm_principal.Timer1Timer(Sender: TObject);
begin
  if Assigned(frm_servicesWhats) then
  begin
    if frm_servicesWhats.vAuth = true then
    begin
      whatsOn.Visible := true;
      whatsOff.Visible := false;
    end else
    begin
      whatsOff.Visible := true;
      whatsOn.Visible := false;
    end;
  end;
end;

procedure Tfrm_principal.sw_delayClick(Sender: TObject);
begin
  if sw_delay.IsOn then
  begin
    InjectWhatsapp1.Config.ShowRandom := true;
  end else
  begin
    InjectWhatsapp1.Config.ShowRandom := false;
  end;
end;

procedure Tfrm_principal.TrackBar1Change(Sender: TObject);
begin
  lbl_track.Caption := intToStr(TrackBar1.Position);
  InjectWhatsapp1.Config.AutoDelay := TrackBar1.Position;
end;

function Tfrm_principal.VerificaPalavraChave(pMensagem, pContato, pTelefone, idMsg: String): Boolean;
begin
  vNomeContato := pContato;

  if ( POS('MUITO OBRIGADO', AnsiUpperCase(pMensagem) ) > 0 ) or ( POS('OBG', AnsiUpperCase(pMensagem) ) > 0 ) or
     ( POS('OBRIGADO', AnsiUpperCase(pMensagem) ) > 0 ) or ( POS('OBRIGADA', AnsiUpperCase(pMensagem) ) > 0 ) or
     ( POS('VALEU', AnsiUpperCase(pMensagem) ) > 0 ) or ( POS('VALEU MANO', AnsiUpperCase(pMensagem) ) > 0) or
     ( POS('VALEU MESMO', AnsiUpperCase(pMensagem) ) > 0 ) or ( POS('XAU', AnsiUpperCase(pMensagem) ) > 0 ) then
  begin
    mensagem := '👩🏼‍💼Eu que agradeço '+pContato+'! Até breve!.\n\nwww.softmaisbrasil.com.br';
    InjectWhatsapp1.send(pTelefone, mensagem);
<<<<<<< HEAD
    //sleep(2000);
=======
    sleep(2000);
>>>>>>> 39dc63882170becbc41e516e14a86cc66b547245
    vBase64Str := 'data:image/jpg;base64,'+frm_servicesWhats.convertBase64(ExtractFileDir(Application.ExeName)+'\Img\TInject.jpeg');
    InjectWhatsapp1.sendBase64(vBase64Str, pTelefone, 'Imagem', '*Volte sempre!*');
    exit;
  end else
  if ( POS('LINDA', AnsiUpperCase(pMensagem) ) > 0 ) or ( POS('GOSTOSO', AnsiUpperCase(pMensagem) ) > 0 ) or
     ( POS('SEXO', AnsiUpperCase(pMensagem) ) > 0 ) or ( POS('TESÃO', AnsiUpperCase(pMensagem) ) > 0 ) or
     ( POS('VOCÊ É CASADA?', AnsiUpperCase(pMensagem) ) > 0 ) or ( POS('É CASADO?', AnsiUpperCase(pMensagem) ) > 0 ) or
     ( POS('TEM NAMORADA?', AnsiUpperCase(pMensagem) ) > 0 ) or ( POS('VOCÊ NAMORA?', AnsiUpperCase(pMensagem) ) > 0 ) or
     ( POS('TENS NAMORADA?', AnsiUpperCase(pMensagem) ) > 0 ) or ( POS('GOSTEI DE VOCÊ', AnsiUpperCase(pMensagem) ) > 0 ) or
     ( POS('VC CASADO?', AnsiUpperCase(pMensagem) ) > 0 ) or ( POS('VC NAMORA?', AnsiUpperCase(pMensagem) ) > 0 ) or
     ( POS('SEXY', AnsiUpperCase(pMensagem) ) > 0 ) or ( POS('GOZAR', AnsiUpperCase(pMensagem) ) > 0 ) then
  begin
    mensagem := 'Hum...'+pContato + '...Assim fico sem jeito rsrs! Mas o assunto aqui é *profissional* tá bom?';
    InjectWhatsapp1.send(pTelefone, mensagem);
    //sleep(2000);
    mensagem := 'Vamos tentar novamente ok?\n\n';
    InjectWhatsapp1.send(pTelefone, mensagem);
    //sleep(1000);
    mensagem := '🙍🏼‍♀Você está no chatBot demo do *TJInject*!';
    InjectWhatsapp1.send(pTelefone, mensagem);
    exit;
  end  else
  if ( POS('IDIOTA', AnsiUpperCase(pMensagem) ) > 0 ) or ( POS('CASADA?', AnsiUpperCase(pMensagem) ) > 0 ) or
     ( POS('GAY', AnsiUpperCase(pMensagem) ) > 0 ) or ( POS('VIADO', AnsiUpperCase(pMensagem) ) > 0 ) or
     ( POS('BICHA', AnsiUpperCase(pMensagem) ) > 0 ) or ( POS('BESTA', AnsiUpperCase(pMensagem) ) > 0 ) or
     ( POS('CU', AnsiUpperCase(pMensagem) ) > 0 ) or ( POS('VAI TOMAR NO CÚ', AnsiUpperCase(pMensagem) ) > 0 ) or
     ( POS('TE FODE', AnsiUpperCase(pMensagem) ) > 0 ) or ( POS('VAI TOMAR NO CU', AnsiUpperCase(pMensagem) ) > 0 ) or
     ( POS('VAI DAR O CU', AnsiUpperCase(pMensagem) ) > 0 ) or ( POS('VAI DAR TEU CU', AnsiUpperCase(pMensagem) ) > 0 ) or
     ( POS('FILHO DA PUTA', AnsiUpperCase(pMensagem) ) > 0 ) or ( POS('FILHO DE RAPARIGA', AnsiUpperCase(pMensagem) ) > 0 ) or
     ( POS('TE FODE CARALHO', AnsiUpperCase(pMensagem) ) > 0 ) or ( POS('FRANGO', AnsiUpperCase(pMensagem) ) > 0 ) or
     ( POS('FRANGO SAFADO', AnsiUpperCase(pMensagem) ) > 0 ) or ( POS('PUTO', AnsiUpperCase(pMensagem) ) > 0 ) or
     ( POS('VAI SE FODER', AnsiUpperCase(pMensagem) ) > 0 ) or ( POS('PUTA', AnsiUpperCase(pMensagem) ) > 0 ) or
     ( POS('VAI TE FUDER', AnsiUpperCase(pMensagem) ) > 0 ) or ( POS('SAPATONA', AnsiUpperCase(pMensagem) ) > 0 ) then
  begin
    if (AnsiUpperCase(pMensagem) = 'IDIOTA') then
    begin
      mensagem := '🤦🏼‍♀'+ pContato + ', *Que coisa feia!* Pode *parar* ok?. O foco é seu *atendimento*!';
      InjectWhatsapp1.send(pTelefone, mensagem);
      //sleep(2000);
      mensagem := '🤷🏼‍♀ Vamos tentar só mais *uma* vez..\n\n';
      InjectWhatsapp1.send(pTelefone, mensagem);
      //sleep(1000);
      mensagem := '🙍🏼‍♀Você está no chatBot demo do *TJInject*!';
      InjectWhatsapp1.send(pTelefone, mensagem);
      exit;
    end;

    if (AnsiUpperCase(pMensagem) = 'CASADA?') then
    begin
      mensagem := '🤷🏼‍♀'+pContato + ', *NÃO* sou casada. O foco é seu *atendimento* ok?';
      InjectWhatsapp1.send(pTelefone, mensagem);
      //sleep(1000);
      mensagem := 'Vamos tentar novamente ok?\n\n';
      InjectWhatsapp1.send(pTelefone, mensagem);
      //sleep(1000);
      mensagem := '🙍🏼‍♀Você está no chatBot demo do *TJInject*!';
      InjectWhatsapp1.send(pTelefone, mensagem);
      exit;
    end;

    mensagem := pContato + ', *NÃO* use palavras desse nível. Respeite para ser respeitado ok?';
    InjectWhatsapp1.send(pTelefone, mensagem);
    //sleep(1000);
    mensagem := '🤷🏼‍♀ Vamos tentar novamente ok?\n\n';
    InjectWhatsapp1.send(pTelefone, mensagem);
    //sleep(1000);
    mensagem := '🙍🏼‍♀Você está no chatBot demo do *TJInject*!';
    InjectWhatsapp1.send(pTelefone, mensagem);
    exit;
  end else

  if ( POS('OI', AnsiUpperCase(pMensagem)) > 0 ) or ( POS('OLÁ', AnsiUpperCase(pMensagem)) > 0 ) or
          ( POS('OLA', AnsiUpperCase(pMensagem)) > 0 ) then
  begin
    mensagem := '🙋🏼‍♀ Olá *' + pContato + '*! Já identifiquei seu contato: *' + pTelefone + '*';
    InjectWhatsapp1.send(pTelefone, mensagem);
    //sleep(1000);
    mensagem := '🙍🏼‍♀Você está no chatBot demo do *TJInject*!';
    InjectWhatsapp1.send(pTelefone, mensagem);
    exit;
  end else
  if ( POS('PREVISÃO DO TEMPO', AnsiUpperCase(pMensagem)) > 0 ) then
  begin
    mensagem := pContato + ', 🌤 Em Recife, a previsão é de tempo parcialmente nublado com _máximas_ de *34º* e _mínimas_ de *29º*.';
    InjectWhatsapp1.send(pTelefone, mensagem);
    //sleep(1000);
    mensagem := '🙍🏼‍♀Você está no chatBot demo do *TJInject*!';
    InjectWhatsapp1.send(pTelefone, mensagem);
    exit;
  end else
  if ( POS('MORRE DIABO', AnsiUpperCase(pMensagem)) > 0 )  then
  begin
    mensagem := '🙋🏼‍♀'+pContato + '... Vou orar por você viu! aff...';
    InjectWhatsapp1.send(pTelefone, mensagem);
    //sleep(2000);
    mensagem := '🙍🏼‍♀Você está no chatBot demo do *TJInject*!';
    InjectWhatsapp1.send(pTelefone, mensagem);
    exit;
  end else
  if ( POS('BOM DIA', AnsiUpperCase(pMensagem)) > 0 ) or ( POS('BOA TARDE', AnsiUpperCase(pMensagem)) > 0 ) or
          ( POS('BOA NOITE', AnsiUpperCase(pMensagem)) > 0 ) then
  begin
    if (AnsiUpperCase(pMensagem) = 'BOM DIA') then
    begin
      mensagem := '🙋🏼‍♀ Bom dia *' + pContato + '*! Já identifiquei seu contato: *' + pTelefone + '*';
      InjectWhatsapp1.send(pTelefone, mensagem);
      //sleep(1000);
      mensagem := '🙍🏼‍♀Você está no chatBot demo do *TJInject*!';
      InjectWhatsapp1.send(pTelefone, mensagem);
      exit;
    end else
    if (AnsiUpperCase(pMensagem) = 'BOA TARDE') then
    begin
      mensagem := '🙋🏼‍♀ Boa tarde *' + pContato + '*! Já identifiquei seu contato: *' + pTelefone + '*';
      InjectWhatsapp1.send(pTelefone, mensagem);
      //sleep(1000);
      mensagem := '🙍🏼‍♀Você está no chatBot demo do *TJInject*!';
      InjectWhatsapp1.send(pTelefone, mensagem);
      exit;
    end else
    if (AnsiUpperCase(pMensagem) = 'BOA NOITE') then
    begin
      mensagem := '🙋🏼‍♀ Boa noite *' + pContato + '*! Já identifiquei seu contato: *' + pTelefone + '*';
      InjectWhatsapp1.send(pTelefone, mensagem);
      //sleep(1000);
      mensagem := '🙍🏼‍♀Você está no chatBot demo do *TJInject*!';
      InjectWhatsapp1.send(pTelefone, mensagem);
      exit;
    end;
  end;
end;

procedure Tfrm_principal.whatsOffClick(Sender: TObject);
begin
  InjectWhatsapp1.ShowWebApp;
end;

procedure Tfrm_principal.whatsOnClick(Sender: TObject);
begin
  InjectWhatsapp1.ShowWebApp;
end;

end.
