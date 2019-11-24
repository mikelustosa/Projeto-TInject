//TInject Criado por Mike W. Lustosa
//Códido aberto à comunidade Delphi
//mikelustosa@gmail.com

unit uTInject;

interface

uses
  System.SysUtils, System.Classes, Vcl.Forms, Vcl.Dialogs, UBase64, uClasses, u_view_qrcode;

  var
    vDelay: integer;
    vAutoDelete : boolean;
    FActivityContactsThread   : TThread;
    FActivityGetMessagesThread: TThread;
    FActivitySendThread       : TThread;
    FActivitySendBase64Thread : TThread;
type
  {Events}
  TGetUnReadMessages = procedure(Chats: TChatList) of object;
  TMySubComp = class(TComponent)

  public
    FAutoStart      : Boolean;
    FAutoDelete     : Boolean;
    FAutoDelay      : Integer;
    FSyncContacts   : Boolean;
    FShowRandom     : Boolean;
  private
    procedure SetAutoDelete(const Value: Boolean);
    procedure SetAutoDelay(const Value: integer);
    procedure SetSyncContacts(const Value: Boolean);
    procedure SetShowRandom(const Value: Boolean);

  published
    property AutoStart    : Boolean read FAutoStart write FAutoStart default False;
    property AutoDelete   : Boolean read FAutoDelete   write SetAutoDelete;
    property AutoDelay    : integer read FAutoDelay    write SetAutoDelay;
    property SyncContacts : Boolean read FSyncContacts write SetSyncContacts;
    property ShowRandom   : Boolean read FShowRandom   write SetShowRandom;
  end;


  TInjectWhatsapp = class(TComponent)
  private
    { Private declarations }
  protected
    { Protected declarations }
    FResult               : TQrCodeClass;
    FAllContacts          : TRetornoAllContacts;
    FAllChats             : TChatList;
    FOnGetContactList     : TNotifyEvent;
    FOnGetQrCode          : TNotifyEvent;
    FOnGetChatList        : TNotifyEvent;
    FOnGetNewMessage      : TNotifyEvent;
    FOnGetUnReadMessages  : TGetUnReadMessages;
    FOnGetStatus          : TNotifyEvent;
    FContacts             : String;
    FMySubComp1           : TMySubComp;
    FAuth                 : boolean;
  public
    const emoticonSorridente       = '😄';
    const emoticonSorridenteLingua = '😝';
    const emoticonImpressionado    = '😱';
    const emoticonIrritado         = '😤';
    const emoticonTriste           = '😢';
    const emoticonApaixonado       = '😍';
    const emoticonPapaiNoel        = '🎅';
    const emoticonViolao           = '🎸';
    const emoticonChegada          = '🏁';
    const emoticonFutebol          = '⚽';
    const emoticonNaMosca          = '🎯';
    const emoticonDinheiro         = '💵';
    const emoticonEnviarCel        = '📲';
    const emoticonEnviar           = '📩';
    const emoticonFone             = '📞';
    const emoticonOnibus           = '🚍';
    const emoticonAviao            = '✈';
    const emoticonLegal            = '👍🏻';
    const emoticonApertoDeMao      = '🤝🏻';
    const emoticonPazEAmor         = '✌🏻';
    const emoticonSono             = '😴';
    const emoticonPalmas           = '👏🏻';
    const emoticonLoiraFazerOq     = '🤷‍♀' ;
    const emoticonLoiraMaoNoRosto  = '🤦‍♀' ;
    const emoticonMacarrao         = '🍜';
    const emoticonAtendenteH       = '👨🏼‍💼';
    const emoticonAtendenteM       = '👩🏼‍💼';
    const emoticonPizza            = '🍕';
    const emoticonBebida           = '🥃';
    const emoticonRestaurante      = '🍽';
    const emoticonJoystick         = '🎮';
    const emoticonMoto             = '🏍';
    const emoticonCarro            = '🚘';
    const emoticonABarco           = '🚢';
    const emoticonHospital         = '🏥';
    const emoticonIgreja           = '⛪';
    const emoticonCartao           = '💳';
    const emoticonTuboEnsaio       = '🧪';
    const emoticonPilula           = '💊';
    const emoticonSacolaCompras    = '🛍';
    const emoticonCarrinhoCompras  = '🛒';
    const emoticonAmpulheta        = '⏳';
    const emoticonPresente         = '🎁';
    const emoticonEmail            = '📧';
    const emoticonAgendaAzul       = '📘';
    const emoticonAgendaVerde      = '📗';
    const emoticonAgendaVermelha   = '📕';
    const emoticonClipPapel        = '📎';
    const emoticonCanetaAzul       = '🖊';
    const emoticonLapis            = '✏';
    const emoticonLapisEPapel      = '📝';
    const emoticonCadeadoEChave    = '🔐';
    const emoticonLupa             = '🔎';
    const emoticonCorarao          = '❤';
    const emoticonCheck            = '✅';
    const emoticonCheck2           = '✔';
    const emoticonAtencao          = '⚠';
    const emoticonZero             = '0⃣';
    const emoticonUm               = '1⃣';
    const emoticonDois             = '2⃣';
    const emoticonTres             = '3⃣';
    const emoticonQuatro           = '4⃣';
    const emoticonCinco            = '5⃣';
    const emoticonSeis             = '6⃣';
    const emoticonSete             = '7⃣';
    const emoticonOito             = '8⃣';
    const emoticonNove             = '9⃣';
    const emoticonDez              = '🔟';
    const emoticonAterisco         = '*⃣';
    const emoticonSetaDireita      = '➡';
    const emoticonSetaEsquerda     = '⬅';
    const emoticonRelogio          = '🕒';
    const emoticonConversa         = '💬';
    const emoticonApontaCima       = '👆🏻';
    const emoticonApontaBaixo      = '👇🏻';
    const emoticonPanelaComComida  = '🥘';

    constructor Create(AOwner: TComponent); override;
    procedure ReadMessages(vID: string);
    procedure startQrCode;
    procedure monitorQrCode;
    procedure startWhatsapp;
    procedure ShowWebApp;
    procedure send(vNum, vMess: string);
    procedure sendBase64(vBase64, vNum, vFileName, vMess: string);
    procedure fileToBase64(vFile: string);
    procedure GetAllContacts;
    procedure GetAllChats;
    function GetStatus: Boolean;
    function GetUnReadMessages: String;
    property AllContacts: TRetornoAllContacts read FAllContacts write FAllContacts;
    property AQrCode: TQrCodeClass read FResult write FResult;
    property AllChats: TChatList read FAllChats write FAllChats;
    property Auth: boolean read FAuth write FAuth;
  published
    { Published declarations }
    property Config               : TMySubComp read FMySubComp1;
    property OnGetContactList     : TNotifyEvent read FOnGetContactList write FOnGetContactList;
    property OnGetQrCode          : TNotifyEvent read FOnGetQrCode write FOnGetQrCode;
    property OnGetChatList        : TNotifyEvent read FOnGetChatList write FOnGetChatList;
    property OnGetNewMessage      : TNotifyEvent read FOnGetNewMessage write FOnGetNewMessage;
    property OnGetUnReadMessages  : TGetUnReadMessages read FOnGetUnReadMessages write FOnGetUnReadMessages;
    property OnGetStatus          : TNotifyEvent read FOnGetStatus write FOnGetStatus;
  end;
  var resultado : integer;
procedure Register;

implementation

uses
  u_servicesWhats;


procedure Register;
begin
  RegisterComponents('TInjectWhatsapp', [TInjectWhatsapp]);
end;

{ TInjectWhatsapp }

procedure TMySubComp.SetAutoDelete(const Value: Boolean);
begin
  FAutoDelete := Value;
  vAutoDelete := FAutoDelete;
end;

procedure TMySubComp.SetShowRandom(const Value: Boolean);
begin
  FShowRandom := value;
end;

procedure TMySubComp.SetSyncContacts(const Value: Boolean);
begin
  FSyncContacts := Value;
end;

procedure TMySubComp.SetAutoDelay(const Value: Integer);
begin
  FAutoDelay := Value;
  vDelay := FAutoDelay;
end;

{ TInjectWhatsapp }

constructor TInjectWhatsapp.Create(AOwner: TComponent);
begin
  inherited;
  FMySubComp1      := TMySubComp.Create(self);
  FMySubComp1.Name := 'AutoInject';
  FMySubComp1.SetSubComponent(true);

  if Config.AutoStart then
     startWhatsapp;
end;

procedure TInjectWhatsapp.fileToBase64(vFile: string);
begin
  uBase64.FileToBase64(vFile);
end;

procedure TInjectWhatsapp.GetAllContacts;
begin
  frm_servicesWhats.GetAllContacts;
end;

procedure TInjectWhatsapp.GetAllChats;
begin
  frm_servicesWhats.GetAllChats;
end;

function TInjectWhatsapp.GetStatus: Boolean;
begin
  //if Assigned(frm_servicesWhats) then
  //  frm_servicesWhats.GetStatus;
end;

function TInjectWhatsapp.GetUnReadMessages: String;
begin
  FActivityGetMessagesThread := TThread.CreateAnonymousThread(procedure
      var vGetDelay: integer;
      begin
        try

          vGetDelay := random(vDelay);

          sleep(vGetDelay);

          TThread.Synchronize(nil, procedure
          begin
            if Assigned(frm_servicesWhats) then
            begin
              frm_servicesWhats.GetUnReadMessages;
            end;
          end);

          TThread.Synchronize(nil, procedure
          begin
            if FMySubComp1.ShowRandom then
            begin
              showMessage('Random: '+vGetDelay.ToString+' ms');
            end;
          end);

          finally
          begin

          end;
        end;
      end);
  FActivityGetMessagesThread.FreeOnTerminate := true;
  FActivityGetMessagesThread.Start;
end;

procedure TInjectWhatsapp.monitorQrCode;
begin
  frm_servicesWhats.monitorQRCode;
end;

procedure TInjectWhatsapp.ReadMessages(vID: string);
begin
  if vAutoDelete = true then
  begin
    if assigned(frm_servicesWhats) then
      frm_servicesWhats.ReadMessagesAndDelete(vID);
  end else if vAutoDelete = false then
  begin
    if assigned(frm_servicesWhats) then
      frm_servicesWhats.ReadMessages(vID);
  end;
end;

procedure TInjectWhatsapp.send(vNum, vMess: string);
var
  AId: String;
begin
  FActivitySendThread := TThread.CreateAnonymousThread(procedure
      var vGetDelay: integer;
      begin
        vGetDelay := random(vDelay);
        sleep(vGetDelay);

          TThread.Synchronize(nil, procedure
          begin
            if Assigned(frm_servicesWhats) then
            begin
              if (length(vNum) = 10) or (length(vNum) = 11) then
              begin
                frm_servicesWhats.ReadMessages('55'+vNum+'@c.us'); //Marca como lida a mensagem
                frm_servicesWhats.Send('55'+vNum+'@c.us', vMess);
              end else
                begin
                  AId := vNum;
                  frm_servicesWhats.ReadMessages('55'+vNum+'@c.us'); //Marca como lida a mensagem
                  frm_servicesWhats.Send(AId, vMess);
                end;
            end;
          end);

          TThread.Synchronize(nil, procedure
          begin
            if FMySubComp1.ShowRandom then
            begin
              showMessage('Random: '+vGetDelay.ToString+' ms');
            end;
          end);

      end);
  FActivitySendThread.FreeOnTerminate := true;
  FActivitySendThread.Start;
end;

procedure TInjectWhatsapp.sendBase64(vBase64, vNum, vFileName, vMess: string);
begin
  inherited;
  FActivitySendBase64Thread := TThread.CreateAnonymousThread(procedure
      var vGetDelay: integer;
      begin
          vGetDelay := random(vDelay);
          sleep(vGetDelay);

          TThread.Synchronize(nil, procedure
          begin
            if Assigned(frm_servicesWhats) then
            begin
              frm_servicesWhats.sendBase64(vBase64,'55'+vNum+'@c.us', vFileName, vMess);
            end;
          end);

          TThread.Synchronize(nil, procedure
          begin
            if FMySubComp1.ShowRandom then
            begin
              showMessage('Random: '+vGetDelay.ToString+' ms');
            end;
          end);
      end);
  FActivitySendBase64Thread.FreeOnTerminate := true;
  FActivitySendBase64Thread.Start;
end;

procedure TInjectWhatsapp.ShowWebApp;
begin
  startWhatsapp;
  frm_servicesWhats.Show;
end;

procedure TInjectWhatsapp.startQrCode;
begin
  startWhatsapp;
  if Assigned(frm_servicesWhats) then
  begin
    if not Assigned(frm_view_qrcode) then
    begin
      frm_view_qrcode         := Tfrm_view_qrcode.Create(nil);
      frm_view_qrcode.Show;
    end;
  end;
end;

procedure TInjectWhatsapp.startWhatsapp;
begin
  if not Assigned(frm_servicesWhats) then
  begin
   frm_servicesWhats         := Tfrm_servicesWhats.Create(nil);
   frm_servicesWhats._Inject := Self;
  end;
end;

end.
