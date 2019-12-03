//TInject Criado por Mike W. Lustosa
//Códido aberto à comunidade Delphi
//mikelustosa@gmail.com


unit uTInject;

interface

uses
  System.SysUtils, System.Classes, Vcl.Forms, Vcl.Dialogs, UBase64, uClasses, u_view_qrcode,
  uTInject.Emoticons;

Const
  TInjectVersion = '1.0.0.7'; //  27/11/2019  //Alterado por Mike

type
  {Events}
  TGetUnReadMessages = procedure(Chats: TChatList) of object;

  TMySubComp = class(TComponent)
  public
    FAutoStart      : Boolean;
    FAutoMonitor    : Boolean;
    FSecondsMonitor : Integer;
    FAutoDelete     : Boolean;
    FAutoDelay      : Integer;
    FSyncContacts   : Boolean;
    FShowRandom     : Boolean;
  private
    procedure SetAutoMonitor(const Value: Boolean);
    procedure SetSecondsMonitor(const Value: Integer);
  published
    property AutoStart    : Boolean read FAutoStart    write FAutoStart default False;
    property AutoMonitor  : boolean read FAutoMonitor  write SetAutoMonitor          default True;
    property SecondsMonitor: Integer read FSecondsMonitor write SetSecondsMonitor default 3;
    property AutoDelete   : Boolean read FAutoDelete   write FAutoDelete;
    property AutoDelay    : integer read FAutoDelay    write FAutoDelay  default 2500;
    property SyncContacts : Boolean read FSyncContacts write FSyncContacts;
    property ShowRandom   : Boolean read FShowRandom   write FShowRandom;
  end;


  TInjectWhatsapp = class(TComponent)
  private
    FVersaoIde: String;
    { Private declarations }
    procedure SetAuth(const Value: boolean);
  protected
    { Protected declarations }
    FResult               : TQrCodeClass;
    FAllContacts          : TRetornoAllContacts;
    FAllChats             : TChatList;
    FMySubComp1           : TMySubComp;
    FBatteryLevel         : TNotifyEvent;
    FGetBatteryLevel      : string;
    FOnGetQrCode          : TNotifyEvent;
    FOnGetChatList        : TNotifyEvent;
    FOnGetNewMessage      : TNotifyEvent;
    FOnGetBatteryLevel    : TNotifyEvent;
    FOnGetUnReadMessages  : TGetUnReadMessages;
    FOnGetStatus          : TNotifyEvent;
    FContacts             : String;
    FAuth                 : Boolean;
    FMonitoring           : Boolean;
  public
    AGetBatteryLevel               : string;
    Emoticons: TInjectEmoticons;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ReadMessages(vID: string);
    procedure startQrCode;
    procedure monitorQrCode;
    procedure startWhatsapp;
    procedure StartMonitor;
    procedure StopMonitor;
    procedure ShowWebApp;
    procedure send(vNum, vMess: string);
    procedure batteryStatus();
    procedure sendBase64(vBase64, vNum, vFileName, vMess: string);
    procedure fileToBase64(vFile: string);
    procedure GetAllContacts;
    procedure GetAllChats;
    function GetStatus: Boolean;
    function GetUnReadMessages: String;
    property AllContacts: TRetornoAllContacts read FAllContacts write FAllContacts;
    property BatteryLevel: TNotifyEvent read FBatteryLevel write FBatteryLevel;
    property AQrCode: TQrCodeClass read FResult write FResult;
    property AllChats: TChatList read FAllChats write FAllChats;
    property Auth: boolean read FAuth write SetAuth;
    property Monitoring: Boolean read FMonitoring default False;
  published
    { Published declarations }
    property Config               : TMySubComp read FMySubComp1;
    property OnGetContactList     : TNotifyEvent read FBatteryLevel write FBatteryLevel;
    property OnGetQrCode          : TNotifyEvent read FOnGetQrCode write FOnGetQrCode;
    property OnGetChatList        : TNotifyEvent read FOnGetChatList write FOnGetChatList;
    property OnGetNewMessage      : TNotifyEvent read FOnGetNewMessage write FOnGetNewMessage;
    property OnGetUnReadMessages  : TGetUnReadMessages read FOnGetUnReadMessages write FOnGetUnReadMessages;
    property OnGetStatus          : TNotifyEvent read FOnGetStatus write FOnGetStatus;
    property OnGetBatteryLevel    : TNotifyEvent read FOnGetBatteryLevel write FOnGetBatteryLevel;
    Property VersaoIDE            : String Read FVersaoIde;
    property ABatteryLevel        : string Read FGetBatteryLevel;
  end;

  Function AdjustNumber(PNum:String):String;

procedure Register;

implementation

uses
  u_servicesWhats;

procedure Register;
begin
  RegisterComponents('TInjectWhatsapp', [TInjectWhatsapp]);
end;

function AdjustNumber(PNum:String):String;
var
  LClearNum: String;
  i: Integer;
begin
  Result := '';
  //Garante valores LIMPOS (sem mascaras, letras, etc) apenas NUMEROS
  for I := 1 to Length(PNum) do
  begin
    if PNum[I] in ['0'..'9'] then
       LClearNum := LClearNum + PNum[I];
  end;

  //O requisito minimo é possuir DDD + NUMERO (Fone 8 ou 9 digitos)
  if Length(LClearNum) < 10 then
     raise Exception.Create('Número inválido');

  //Testa se o numero é compativel com brasil!
  if Length(LClearNum) > 13 then
     raise Exception.Create('Número inválido');
  if Length(LClearNum) < 12 then  //Nao possui DDI
     LClearNum := '55' + LClearNum;
  Result := LClearNum +  '@c.us';
end;

procedure TMySubComp.SetAutoMonitor(const Value: boolean);
begin
  FAutoMonitor := Value;
  if SecondsMonitor < 1 then
     SecondsMonitor := 3; //Default Value;
end;

procedure TMySubComp.SetSecondsMonitor(const Value: Integer);
begin
  FSecondsMonitor := Value;

  //Não permitir que fique zero ou negativo.
  if Value < 1 then
     FSecondsMonitor := 3;
end;

{ TInjectWhatsapp }

procedure TInjectWhatsapp.batteryStatus();
begin
  if Assigned(frm_servicesWhats) then
    frm_servicesWhats.GetBatteryLevel;
end;

constructor TInjectWhatsapp.Create(AOwner: TComponent);
begin
  inherited;
  FMySubComp1            := TMySubComp.Create(self);
  FMySubComp1.Name       := 'AutoInject';
  FMySubComp1.AutoDelay  := 1000;

  FMySubComp1.SecondsMonitor := 3;
  FMySubComp1.AutoMonitor := True;

  FMySubComp1.SetSubComponent(true);
  FVersaoIde       := TInjectVersion;

  //Default


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
          if Config.AutoDelay > 0 then
             sleep(random(Config.AutoDelay));

          TThread.Synchronize(nil, procedure
          begin
            if Assigned(frm_servicesWhats) then
            begin
              frm_servicesWhats.GetUnReadMessages;
            end;
          end);

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
  vNum := AdjustNumber(vNum);
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
  //vNum := AdjustNumber(vNum);
  lThread := TThread.CreateAnonymousThread(procedure
      begin
         if Config.AutoDelay > 0 then
            sleep(random(Config.AutoDelay));

        TThread.Synchronize(nil, procedure
        begin
          if Assigned(frm_servicesWhats) then
          begin
            frm_servicesWhats.ReadMessages(vNum); //Marca como lida a mensagem
            frm_servicesWhats.sendBase64(vBase64, vNum, vFileName, vMess);
          end;
        end);

      end);
  lThread.FreeOnTerminate := true;
  lThread.Start;
end;

procedure TInjectWhatsapp.SetAuth(const Value: boolean);
begin
  FAuth := Value;
  if Assigned( OnGetStatus ) then
     OnGetStatus( Self );
end;

procedure TInjectWhatsapp.ShowWebApp;
begin
  startWhatsapp;
  frm_servicesWhats.Show;
end;

procedure TInjectWhatsapp.StartMonitor;
begin
  if FMonitoring then Exit;

  if Assigned(frm_servicesWhats) then
  begin
    FMonitoring := not Monitoring;
    frm_servicesWhats.StartMonitor( Config.SecondsMonitor );
  end;
end;

procedure TInjectWhatsapp.StopMonitor;
begin
  if not FMonitoring then Exit;

  if Assigned(frm_servicesWhats) then
  begin
    FMonitoring := not Monitoring;
    frm_servicesWhats.StopMonitor;
  end;
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
