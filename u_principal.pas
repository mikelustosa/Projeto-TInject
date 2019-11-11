unit u_principal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uCEFWinControl, uCEFWindowParent,
  Vcl.ExtCtrls, uCEFChromium, system.JSON, uClasses,

  //############ ATENÇÃO AQUI ####################
  //############ ATENÇÃO AQUI ####################
  //############ ATENÇÃO AQUI ####################
  //units adicionais obrigatórias
  uCEFApplication, uCefMiscFunctions, uCEFInterfaces, uCEFConstants, uCEFTypes, UnitCEFLoadHandlerChromium,
  Vcl.StdCtrls, Vcl.ComCtrls, System.ImageList, Vcl.ImgList, uTInject,
  Vcl.Imaging.pngimage, Vcl.Buttons, Vcl.WinXCtrls, System.NetEncoding,
  Vcl.Imaging.jpeg, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, FireDAC.UI.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Phys, FireDAC.Phys.MSSQL, FireDAC.Phys.MSSQLDef,
  FireDAC.VCLUI.Wait, Data.DB, FireDAC.Comp.Client, FireDAC.Comp.DataSet,
  FireDAC.Comp.UI, Vcl.AppEvnts;

  //############ ATENÇÃO AQUI ####################
  //############ ATENÇÃO AQUI ####################
  //############ ATENÇÃO AQUI ####################
  //############ Inclua essas variáveis em seus projetos
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
    chk_apagarMsg: TCheckBox;
    Label9: TLabel;
    TrayIcon1: TTrayIcon;
    ApplicationEvents1: TApplicationEvents;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Timer1Timer(Sender: TObject);
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
    procedure chk_apagarMsgClick(Sender: TObject);
    procedure TrayIcon1Click(Sender: TObject);
    procedure ApplicationEvents1Minimize(Sender: TObject);
    procedure btn_clearClick(Sender: TObject);

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
    nOpcao                                : string;
    JS1, JS2, contato , fone              : string;
    vBase64Str, vFileNameURL              : string;

    //Video aula
    mensagem                              : string;
    arrayFila                             : array [0..1] of string;
    arraySessao                           : array [0..1] of string;
    arrayTimer                            : array [0..1] of string;
    arrayFilaEspera                       : array [0..1] of string;
    function  VerificaPalavraChave( pMensagem, pSessao, pTelefone, pContato : String ) : Boolean;
    //Video aula

    procedure AddContactList(ANumber: String);
    procedure AddChatList(ANumber: String);

  end;

var
  frm_principal: Tfrm_principal;

implementation

uses
  u_servicesWhats, System.StrUtils;

{$R *.dfm}

function DiaSemana(Data:TDateTime): String;
{Retorna dia da semana}
var
  NoDia : Integer;
  DiaDaSemana : array [1..7] of String[13];
begin
{ Dias da Semana }
  DiaDasemana [1]:= 'Domingo';
  DiaDasemana [2]:= 'Segunda-feira';
  DiaDasemana [3]:= 'Terça-feira';
  DiaDasemana [4]:= 'Quarta-feira';
  DiaDasemana [5]:= 'Quinta-feira';
  DiaDasemana [6]:= 'Sexta-feira';
  DiaDasemana [7]:= 'Sábado';
  NoDia:=DayOfWeek(Data);
  DiaSemana:=DiaDasemana[NoDia];
end;

procedure Tfrm_principal.FormCreate(Sender: TObject);
begin
  idMessageGlobal := 'start';
  //InjectWhatsapp1.startWhatsapp;
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

procedure Tfrm_principal.ApplicationEvents1Minimize(Sender: TObject);
begin
  self.Hide();
  self.WindowState := wsMinimized;
  trayIcon1.Visible := true;
  TrayIcon1.Animate := True;
  TrayIcon1.ShowBalloonHint;
end;

procedure Tfrm_principal.btn_clearClick(Sender: TObject);
var i, j, f, controle: integer;
begin
  controle := 1;
  for i := 0 to  length(arrayTimer) -1 do
  begin
    if arrayTimer[i] <> '' then
    begin
      if (time - strToTime(arrayTimer[i])) >= strToTime('00:00:10') then
      begin
        mensagem := 'Seu número *'+arrayFila[i]+'* foi removido da fila de atendimento.\n\nFoi namorar, perdeu o lugar! 🤷‍♂';
        injectWhatsapp1.send(arrayFila[i], mensagem);
        arrayFila[i]    := '';
        arraySessao[i]  := '';
        arrayTimer[i]   := '';
        controle := 0;
      end;
    end;
  end;
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

procedure Tfrm_principal.chk_apagarMsgClick(Sender: TObject);
begin
 if chk_apagarMsg.Checked then
  injectWhatsapp1.Config.FAutoDelete := true
 else
  injectWhatsapp1.Config.FAutoDelete := false;
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
//  frm_servicesWhats.loadQRCode(frm_servicesWhats._Qrcode);
end;

procedure Tfrm_principal.InjectWhatsapp1GetUnReadMessages(Chats: TChatList);
var
  AChat: TChatClass;
  AMessage: TMessagesClass;
  contato, telefone: string;
begin
    for AChat in Chats.result do
    begin
      for AMessage in AChat.messages do
      begin
          if AMessage.sender.isMe = false then  //Não exibe mensages enviadas por mim
          begin
            if AMessage.isGroupMsg = false then //Não exibe mensages de grupos
            begin
              //memo_unReadMessagen.Clear;
              memo_unReadMessagen.Lines.Add(PChar( 'Nome Contato: ' + Trim(AMessage.Sender.pushName)));
              memo_unReadMessagen.Lines.Add(PChar( 'Chat Id     : ' + AChat.id));
              memo_unReadMessagen.Lines.Add(PChar( 'Mensagem    : ' + AMessage.body));
              memo_unReadMessagen.Lines.Add(PChar( 'ID Message  : ' + AMessage.t.ToString));
              memo_unReadMessagen.Lines.Add('__________________________________');
              telefone  :=  Copy(AChat.id, 3, Pos('@', AChat.id) - 3);
              contato   := AMessage.Sender.pushName;
              injectWhatsapp1.ReadMessages(AChat.id);
              VerificaPalavraChave(AMessage.body, '', telefone, contato);
            end;
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

procedure Tfrm_principal.TrayIcon1Click(Sender: TObject);
begin
  TrayIcon1.Visible := False;
  Show();
  WindowState := wsNormal;
  Application.BringToFront();
end;

function Tfrm_principal.VerificaPalavraChave(pMensagem, pSessao, pTelefone,
  pContato: String): Boolean;
begin
  if  ( POS('OLA', AnsiUpperCase(pMensagem))        > 0 ) or ( POS('OLÁ', AnsiUpperCase(pMensagem))       > 0 ) or
      ( POS('BOM DIA', AnsiUpperCase(pMensagem))    > 0 ) or ( POS('BOA TARDE', AnsiUpperCase(pMensagem)) > 0 ) or
      ( POS('BOA NOITE', AnsiUpperCase(pMensagem))  > 0 ) or ( POS('INÍCIO', AnsiUpperCase(pMensagem))    > 0 ) or
      ( POS('INICIO', AnsiUpperCase(pMensagem))     > 0 ) or ( POS('OI', AnsiUpperCase(pMensagem))        > 0 )then
          begin
            mensagem :=
            InjectWhatsapp1.emoticonAtendenteH+ 'Olá *'+pContato+'!*\n\n'+
            'Você está no auto atendimento da\n*Softmais Sistemas do Brasil*\n\n';
            vBase64Str := 'data:image/png;base64,' +frm_servicesWhats.convertBase64(ExtractFileDir(Application.ExeName)+'\Img\softmais.png');
            InjectWhatsapp1.sendBase64(vBase64Str, pTelefone, '', mensagem);
            exit;
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
