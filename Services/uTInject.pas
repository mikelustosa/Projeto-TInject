//TInject Criado por Mike W. Lustosa
//Códido aberto à comunidade Delphi
//mikelustosa@gmail.com


unit uTInject;

interface

uses
  System.SysUtils, System.Classes, Vcl.Forms, Vcl.Dialogs, UBase64, uClasses, u_view_qrcode;

Const
  IdeVesao = '1.0.0.6'; //  27/11/2019

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
  published
    property AutoStart    : Boolean read FAutoStart    write FAutoStart default False;
    property AutoDelete   : Boolean read FAutoDelete   write FAutoDelete;
    property AutoDelay    : integer read FAutoDelay    write FAutoDelay  default 2500;
    property SyncContacts : Boolean read FSyncContacts write FSyncContacts;
    property ShowRandom   : Boolean read FShowRandom   write FShowRandom;
  end;


  TInjectWhatsapp = class(TComponent)
  private
    FVersaoIde: String;
    { Private declarations }
  protected
    { Protected declarations }
    FResult               : TQrCodeClass;
    FAllContacts          : TRetornoAllContacts;
    FAllChats             : TChatList;
    FMySubComp1           : TMySubComp;
    FOnGetContactList     : TNotifyEvent;
    FOnGetQrCode          : TNotifyEvent;
    FOnGetChatList        : TNotifyEvent;
    FOnGetNewMessage      : TNotifyEvent;
    FOnGetUnReadMessages  : TGetUnReadMessages;
    FOnGetStatus          : TNotifyEvent;
    FContacts             : String;
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
    destructor Destroy; override;


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
    property OnGetContactList     : TNotifyEvent read FOnGetContactList write FOnGetContactList ;
    property OnGetQrCode          : TNotifyEvent read FOnGetQrCode write FOnGetQrCode;
    property OnGetChatList        : TNotifyEvent read FOnGetChatList write FOnGetChatList;
    property OnGetNewMessage      : TNotifyEvent read FOnGetNewMessage write FOnGetNewMessage;
    property OnGetUnReadMessages  : TGetUnReadMessages read FOnGetUnReadMessages write FOnGetUnReadMessages;
    property OnGetStatus          : TNotifyEvent read FOnGetStatus write FOnGetStatus;
    Property VersaoIDE: String   Read FVersaoIde;
  end;

  Function AjustaNumero(PNumero:String):String;

procedure Register;

implementation

uses
  u_servicesWhats;


procedure Register;
begin
  RegisterComponents('TInjectWhatsapp', [TInjectWhatsapp]);
end;

Function AjustaNumero(PNumero:String):String;
var
  LNumeroLimpo: String;
  i: Integer;
Begin
  Result := '';
  //Garante valores LIMPOS (sem mascaras, letras, etc) apenas NUMEROS
  For I := 1 to Length(PNumero) do
  Begin
    if PNumero[I] in ['0'..'9'] then
       LNumeroLimpo := LNumeroLimpo + PNumero[I];
  End;

  //O requisito minumo e possuir DDD + NUMERO (Fone 8 ou 9 digitos)
  if Length(LNumeroLimpo) < 10 then
     raise Exception.Create('Número inválido');

  //Testa se o numero é compativel com brasil!
  if Length(LNumeroLimpo) > 13 then
     raise Exception.Create('Número inválido');
  if Length(LNumeroLimpo) < 12 then  //Nao possui DDI
     LNumeroLimpo := '55' + LNumeroLimpo;
  Result := LNumeroLimpo +  '@c.us';
End;

{ TInjectWhatsapp }

constructor TInjectWhatsapp.Create(AOwner: TComponent);
begin
  inherited;
  FMySubComp1            := TMySubComp.Create(self);
  FMySubComp1.Name       := 'AutoInject';
  FMySubComp1.AutoDelay  := 1000;
  FMySubComp1.SetSubComponent(true);
  FVersaoIde       := IdeVesao;

  if Config.AutoStart then
     startWhatsapp;
end;

destructor TInjectWhatsapp.Destroy;
begin
  FreeAndNil(frm_servicesWhats);
  FreeAndNil(frm_view_qrcode);

  FreeAndNil(FResult);
  FreeAndNil(FAllContacts);
  FreeAndNil(FAllChats);
  FreeAndNil(FMySubComp1);
  inherited;
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
var
  lThread : TThread;
begin
  lThread := TThread.CreateAnonymousThread(procedure
      begin
//        try
          if Config.AutoDelay > 0 then
             sleep(random(Config.AutoDelay));

          TThread.Synchronize(nil, procedure
          begin
            if Assigned(frm_servicesWhats) then
            begin
              frm_servicesWhats.GetUnReadMessages;
            end;
          end);

          {
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
          }
      end);
  lThread.FreeOnTerminate := true;
  lThread.Start;
end;

procedure TInjectWhatsapp.monitorQrCode;
begin
  frm_servicesWhats.monitorQRCode;
end;

procedure TInjectWhatsapp.ReadMessages(vID: string);
begin
  if Config.AutoDelete Then
  begin
    if assigned(frm_servicesWhats) then
       frm_servicesWhats.ReadMessagesAndDelete(vID);
  end else
  Begin
    if assigned(frm_servicesWhats) then
       frm_servicesWhats.ReadMessages(vID);
  end;
end;

procedure TInjectWhatsapp.send(vNum, vMess: string);
var
  AId: String;
  lThread : TThread;
begin
  vNum := AjustaNumero(vNum);
  lThread := TThread.CreateAnonymousThread(procedure
      begin
        if Config.AutoDelay > 0 then
           sleep(random(Config.AutoDelay));

        TThread.Synchronize(nil, procedure
        begin
          if Assigned(frm_servicesWhats) then
          begin
            frm_servicesWhats.ReadMessages(vNum); //Marca como lida a mensagem
            frm_servicesWhats.Send(vNum, vMess);
          end;
        end);

      end);
  lThread.FreeOnTerminate := true;
  lThread.Start;
end;

procedure TInjectWhatsapp.sendBase64(vBase64, vNum, vFileName, vMess: string);
Var
  lThread : TThread;
begin
  inherited;
  vNum := AjustaNumero(vNum);
  lThread := TThread.CreateAnonymousThread(procedure
      begin
         if Config.AutoDelay > 0 then
            sleep(random(Config.AutoDelay));

        TThread.Synchronize(nil, procedure
        begin
          if Assigned(frm_servicesWhats) then
            frm_servicesWhats.sendBase64(vBase64,vNum, vFileName, vMess);
        end);

         {
          TThread.Synchronize(nil, procedure
          begin
            if FMySubComp1.ShowRandom then
            begin
              showMessage('Random: '+vGetDelay.ToString+' ms');
            end;
          end);
          }
      end);
  lThread.FreeOnTerminate := true;
  lThread.Start;
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
