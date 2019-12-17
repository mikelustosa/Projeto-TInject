{####################################################################################################################
                                             Novembro de 2019
                                 TINJECT - Componente de comunicação WhatsApp
                                         (Não Oficial WhatsApp)
####################################################################################################################
    Owner.....: Mike W. Lustosa            - mikelustosa@gmail.com   - +55 81 9.9630-2385
    Developer.: Joathan Theiller           - jtheiller@hotmail.com   -
                Daniel Oliveira Rodrigues  - Dor_poa@hotmail.com     - +55 51 9.9155-9228
####################################################################################################################
  Obs:
     - Código aberto a comunidade Delphi, desde que mantenha os dados dos autores;
     - Colocar na evolução as Modificação juntamente com as informaçoes do colaborador: Data, Nova Versao, Autor;
     - Mantenha sempre a versao mais atual acima das demais;
     - Todo Commit ao repositório deverá ser declarado as mudança na UNIT e ainda o Incremento da Versão de
       compilação (último digito);

####################################################################################################################
                                  Evolução do Código
####################################################################################################################
  Autor........:
  Email........:
  Modificação..:
####################################################################################################################
}




unit uTInject;

interface

uses
  System.SysUtils, System.Classes, Vcl.Forms, Vcl.Dialogs, UBase64, uTInject.AdjustNumber,   System.MaskUtils,
  Generics.Collections,
  uTInject.Classes, uTInject.constant, uTInject.Emoticons, uTInject.Config,
  uTInject.JS, uTInject.Console;


{
###########################################################################################
                                    EVOLUÇÃO
###########################################################################################

1.0.0.10 =  17/12/2019 - Revisão Mike Lustosa - comercial.softmais@gmail.com
1.0.0.10 =  17/12/2019 - Daniel Rodrigues - Dor_poa@hotmail.com
     - Implementado o controle das pasta do FrameWork do CEF;
     - Adicionado uma classe que controla e destroi todas as THREAD ativas,
       eliminando assim qualquer PROCESSO ZUMBI(Zombie process);
     - Adicionado novas opções no DEMO;


1.0.0.9 =  04/12/2019 - Daniel Rodrigues - Dor_poa@hotmail.com
     - Opçao de configurar a formatação do numero Whats de acordo com o país;



1.0.0.8 =  03/12/2019 - Daniel Rodrigues - Dor_poa@hotmail.com
     - Ajustado problema de envio com anexos;
     - Criado pacote de instalação do componente;
     - Mostrado no DPR a possibilidade de alterarem os arquivos BIN, Locale, Etc..
}


type
  {Events}
  TGetUnReadMessages = procedure(Const Chats: TChatList) of object;
  TOnGetQrCode       = procedure(Const QrCode: TResultQRCodeClass) of object;
  TOnAllContacts     = procedure(Const AllContacts: TRetornoAllContacts) of object;
  TOnLowBattery      = procedure(Const POnAlarm, PBatteryCharge: Integer) of object;
  TOnGetStatus       = procedure(Const PStatus : TStatusType; Const PFormQrCode: TFormQrCodeType) of object;



  TInjectWhatsapp = class(TComponent)
  private
    FInjectConfig         : TInjectConfig;
    FInjectJS             : TInjectJS;
    FEmoticons            : TInjectEmoticons;
    FAdjustNumber         : TInjectAdjusteNumber;
    FQrCodeStyle          : TFormQrCodeType;
    FMyNumber             : string;
    FGetBatteryLevel      : Integer;
    Fversion              : String;
    FPediuCOntados        : Boolean;
    Fstatus               : TStatusType;
    FDestruido            : Boolean;
    { Private  declarations }
    Function  ConsolePronto:Boolean;
    procedure SetAuth(const Value: boolean);
    procedure SetOnLowBattery(const Value: TOnLowBattery);
    procedure Int_OnUpdateJS   (Sender : TObject);
    procedure Int_OnErroInterno(Sender : TObject; Const PError: String; Const PInfoAdc:String);
    procedure Int_OnResultMisc(PTypeHeader: TTypeHeader; PValue: String);
    Function  GetWhatsAppShowing:Boolean;
    procedure SetWhatsAppShowing(const Value: Boolean);

  protected
    { Protected declarations }
    FOnGetUnReadMessages  : TGetUnReadMessages;
    FOnGetAllContactList  : TOnAllContacts;
    FOnLowBattery         : TOnLowBattery;
    FOnGetBatteryLevel    : TNotifyEvent;
    FOnGetQrCode          : TOnGetQrCode;
    FOnUpdateJS           : TNotifyEvent;
    FOnGetChatList        : TGetUnReadMessages;
    FOnGetNewMessage      : TNotifyEvent;
    FOnGetMyNumber        : TNotifyEvent;
    FOnGetStatus          : TOnGetStatus;
    FOnConnected          : TNotifyEvent;
    FOnDisconnected       : TNotifyEvent;
    FOnErroInternal       : TOnErroInternal;
    procedure Loaded; override;
    Function  TestConnect:Boolean;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    Procedure   ShutDown;

    procedure ReadMessages(vID: string);

    procedure  StartQrCode(PViewForm:Boolean = true);  deprecated;
    procedure  StopQrCode;                             deprecated;

//    procedure monitorQrCode;

    Function  startWhatsapp: Boolean;   deprecated;
    procedure stopWhatsapp;             deprecated;

    procedure send(vNum, vMess: string);
    procedure sendBase64(vBase64, vNum, vFileName, vMess: string);

    procedure GetBatteryStatus;
    procedure GetAllContacts;
    procedure GetContacts(PFind:String; Const PResult: TStrings);
    Function  GetContact(Pindex: Integer): TContactClass;
    procedure GetAllChats;
    Function  GetChat(Pindex: Integer):TChatClass;
    function  GetUnReadMessages: String;


    Property  BatteryLevel      : Integer              Read FGetBatteryLevel;
    Property  MyNumber          : String               Read FMyNumber;
    property  Auth              : boolean              read TestConnect;
    property  Status            : TStatusType          read FStatus;
    Property  Emoticons         : TInjectEmoticons     Read FEmoticons                     Write FEmoticons;

    Procedure FormQrCodeStart(PViewForm:Boolean = true);
    Procedure FormQrCodeStop;
    property  FormQrCodeShowing : Boolean              read GetWhatsAppShowing             Write SetWhatsAppShowing;
    Procedure FormQrCodeReloader;

  published
    { Published declarations }
    Property Version              : String               Read Fversion;
    Property InjectJS             : TInjectJS            Read FInjectJS;
    property Config               : TInjectConfig        read FInjectConfig;
    property AjustNumber          : TInjectAdjusteNumber read FAdjustNumber;
    property FormQrCodeType       : TFormQrCodeType      read FQrCodeStyle          Write FQrCodeStyle;

    property OnGetAllContactList  : TOnAllContacts       read FOnGetAllContactList  write FOnGetAllContactList;
    property OnGetQrCode          : TOnGetQrCode         read FOnGetQrCode          write FOnGetQrCode;
    property OnGetChatList        : TGetUnReadMessages   read FOnGetChatList        write FOnGetChatList;
    property OnGetNewMessage      : TNotifyEvent         read FOnGetNewMessage      write FOnGetNewMessage;
    property OnGetUnReadMessages  : TGetUnReadMessages   read FOnGetUnReadMessages  write FOnGetUnReadMessages;
    property OnGetStatus          : TOnGetStatus         read FOnGetStatus          write FOnGetStatus;
    property OnGetBatteryLevel    : TNotifyEvent         read FOnGetBatteryLevel    write FOnGetBatteryLevel;
    property OnGetMyNumber        : TNotifyEvent         read FOnGetMyNumber        write FOnGetMyNumber;
    property OnUpdateJS           : TNotifyEvent         read FOnUpdateJS           write FOnUpdateJS;
    property OnLowBattery         : TOnLowBattery        read FOnLowBattery         write SetOnLowBattery;
    property OnConnected          : TNotifyEvent         read FOnConnected          write FOnConnected;
    property OnDisConnected       : TNotifyEvent         read FOnDisconnected       write FOnDisconnected;
    property OnErroAndWarning     : TOnErroInternal      read FOnErroInternal       write FOnErroInternal;
  end;


procedure Register;


implementation

uses
  uCEFTypes,   uTInject.ConfigCEF, Winapi.Windows, Winapi.Messages,
  uCEFConstants;


procedure Register;
begin
  RegisterComponents('TInjectWhatsapp', [TInjectWhatsapp]);
end;



{ TInjectWhatsapp }

procedure TInjectWhatsapp.GetBatteryStatus();
begin
  if Assigned(FrmConsole) then
     FrmConsole.GetBatteryLevel;
end;

function TInjectWhatsapp.ConsolePronto: Boolean;
begin
  try
    Result := Assigned(FrmConsole);
    if Assigned(GlobalCEFApp) then
    Begin
      if GlobalCEFApp.ErrorInt Then
         Exit;
    end;

    if not Assigned(FrmConsole) Then
    Begin
      InjectJS.UpdateNow;
      if InjectJS.Ready then
      Begin
        FDestruido                  := False;
        FrmConsole                  := TFrmConsole.Create(self);
        FrmConsole.OnResultMisc     := Int_OnResultMisc;
        FrmConsole.MonitorLowBattry := Assigned(FOnLowBattery);
        FrmConsole.OnErrorInternal  := Int_OnErroInterno;
        FrmConsole.Connect;
        Result := Assigned(FrmConsole);
      end;
    end;
  except
    Result := False;
  end
end;

constructor TInjectWhatsapp.Create(AOwner: TComponent);
begin
  inherited;
  FDestruido                       := False;
  FGetBatteryLevel                 := -1;
  FQrCodeStyle                     := Ft_Http;
  Fversion                         := TInjectVersion;
  FInjectConfig                    := TInjectConfig.Create(self);
  FInjectConfig.Name               := 'AutoInject';
  FInjectConfig.AutoDelay          := 1000;
  FInjectConfig.SecondsMonitor     := 3;
  FInjectConfig.ControlSend        := True;
  FInjectConfig.LowBatteryis       := 30;
  FInjectConfig.ControlSendTimeSec := 8;
  Fstatus                          := Whats_Disconnected;
  FInjectConfig.SetSubComponent(true);


  FAdjustNumber               := TInjectAdjusteNumber.Create(self);
  FAdjustNumber.Name          := 'AdjustNumber';
  FAdjustNumber.SetSubComponent(true);

  FInjectJS                   := TInjectJS.Create(self);
  FInjectJS.Name              := 'InjectJS';
  FInjectJS.OnUpdateJS        := Int_OnUpdateJS;
  FInjectJS.OnErrorInternal   := Int_OnErroInterno;
  FInjectJS.SetSubComponent(true);
end;

destructor TInjectWhatsapp.Destroy;
begin
  FormQrCodeStop;
  FreeAndNil(FAdjustNumber);
  FreeAndNil(FInjectJS);
  FreeAndNil(FInjectConfig);
  inherited;
end;

procedure TInjectWhatsapp.GetAllContacts;
begin
  if Assigned(FrmConsole) then
  Begin
    FrmConsole.GetAllContacts;
    FPediuCOntados := true;
  end;
end;

function TInjectWhatsapp.GetChat(Pindex: Integer): TChatClass;
begin
  Result := Nil;
  if not Assigned(FrmConsole) then
     Exit;
  if not Assigned(FrmConsole.AllChats) then
     Exit;

  Result := FrmConsole.AllChats.result[Pindex]
end;

function TInjectWhatsapp.GetContact(Pindex: Integer): TContactClass;
begin
  Result := Nil;
  if not Assigned(FrmConsole) then
     Exit;
  if not Assigned(FrmConsole.AllContacts) then
     Exit;

  Result := FrmConsole.AllContacts.result[Pindex];
end;

procedure TInjectWhatsapp.GetContacts(PFind: String; const PResult: TStrings);
var
  LContato: TContactClass;
begin
  if not Assigned(FrmConsole) then
     Exit;

  PResult.Clear;
  If Length(PFind) < 2 then
     Exit;

  PFind := Trim(PFind);
  if Assigned(FrmConsole.AllContacts) then
  Begin
    if (Length(FrmConsole.AllContacts.result) <= 0) and (not FPediuCOntados) Then
    Begin
      //nao buscou ainda os contatos
      GetAllContacts;
      Exit;
    end;
  end else
  begin
    //nao buscou ainda os contatos
    GetAllContacts;
    Exit;
  end;

  for LContato in FrmConsole.AllContacts.result do
  Begin
    if (pos(PFind, LContato.formattedName) > 0) or (pos(PFind, LContato.id) > 0) then
    Begin
       if (LContato.name = '') or (LContato.name.IsEmpty = true) then
          PResult.Add(LContato.id) else
          PResult.Add(LContato.id + ' ' +LContato.name)
    end;
  end;
end;

procedure TInjectWhatsapp.GetAllChats;
begin
  if Assigned(FrmConsole) then
     FrmConsole.GetAllChats;
end;


function TInjectWhatsapp.GetUnReadMessages: String;
var
  lThread : TThread;
begin
  If Application.Terminated Then
     Exit;
  if not Assigned(FrmConsole) then
     Exit;

  lThread := TThread.CreateAnonymousThread(procedure
      begin
          if Config.AutoDelay > 0 then
             sleep(random(Config.AutoDelay));

          TThread.Synchronize(nil, procedure
          begin
            if Assigned(FrmConsole) then
               FrmConsole.GetUnReadMessages;
          end);

      end);
  lThread.FreeOnTerminate := true;
  lThread.Start;
end;

procedure TInjectWhatsapp.Int_OnErroInterno(Sender : TObject; Const PError: String; Const PInfoAdc:String);
begin
  if Assigned(FOnErroInternal) then
     FOnErroInternal(Sender, PError, PInfoAdc);
end;

procedure TInjectWhatsapp.Int_OnUpdateJS(Sender: TObject);
begin
  if Assigned(FOnUpdateJS) then
     FOnUpdateJS(Self);
end;

procedure TInjectWhatsapp.Loaded;
begin
  inherited;
  if (csDesigning in ComponentState) then
     Exit;

//  if Assigned(GlobalCEFApp) then
//     GlobalCEFApp.InjectWhatsApp := Self;

  if Config.AutoStart then
     FormQrCodeStart(False);
end;


procedure TInjectWhatsapp.Int_OnResultMisc(PTypeHeader: TTypeHeader; PValue: String);
begin
  if PTypeHeader = Th_getMyNumber then
  Begin
    FMyNumber := FAdjustNumber.FormatOut(PValue);
    if Assigned(OnGetMyNumber) then
       OnGetMyNumber(Self);
  end;

  if PTypeHeader = Th_GetBatteryLevel then
  Begin
    FGetBatteryLevel :=  StrToIntDef(PValue, -1);
    if Assigned(FOnLowBattery) then
    Begin
      if FGetBatteryLevel <= Config.LowBatteryIs Then
      Begin
        FOnLowBattery(Config.LowBatteryIs, FGetBatteryLevel);
      end else
      Begin
        if Assigned(OnGetBatteryLevel) then
           OnGetBatteryLevel(Self);
      end
    end
  end ;


  if PTypeHeader in [Th_Connected, Th_Disconnected]  then
  Begin
    if PTypeHeader = Th_Connected then
       SetAuth(True) else
       SetAuth(False);
  end;

  if PTypeHeader in [Th_Connecting, Th_Disconnecting, Th_ConnectingNoPhone, Th_getQrCodeForm, Th_getQrCodeForm, TH_Destroy ]  then
  begin
    case PTypeHeader of
      Th_Connecting            : Fstatus := Whats_Connecting;
      Th_Disconnecting         : Fstatus := Whats_Disconnecting;
      Th_ConnectingNoPhone     : Fstatus := Whats_ConnectingNoPhone;
      TH_Destroy               : Fstatus := Whats_Destroy;
      Th_ConnectingFt_Desktop,
      Th_getQrCodeForm         : Fstatus := Whats_ConnectingReaderCode;
    end;


    if Assigned(OnGetStatus ) then
       OnGetStatus(Fstatus, FQrCodeStyle);
  end;

end;

procedure TInjectWhatsapp.ReadMessages(vID: string);
begin
  If Application.Terminated Then
     Exit;
  if not Assigned(FrmConsole) then
     Exit;

  if Config.AutoDelete Then
  begin
    if assigned(FrmConsole) then
       FrmConsole.ReadMessagesAndDelete(vID);
  end else
  Begin
    if assigned(FrmConsole) then
       FrmConsole.ReadMessages(vID);
  end;
end;

procedure TInjectWhatsapp.send(vNum, vMess: string);
var
  lThread : TThread;
begin
  If Application.Terminated Then
     Exit;
  if not Assigned(FrmConsole) then
     Exit;

  vNum := AjustNumber.FormatIn(vNum);
  if pos('@', vNum) = 0 then
  Begin
    Int_OnErroInterno(Self, 'Número inválido', vNum);
    Exit;
  end;

  lThread := TThread.CreateAnonymousThread(procedure
      begin
        if Config.AutoDelay > 0 then
           sleep(random(Config.AutoDelay));

        TThread.Synchronize(nil, procedure
        begin
          if Assigned(FrmConsole) then
          begin
            FrmConsole.ReadMessages(vNum); //Marca como lida a mensagem
            FrmConsole.Send(vNum, vMess);
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
  If Application.Terminated Then
     Exit;
  if not Assigned(FrmConsole) then
     Exit;

  vNum := AjustNumber.FormatIn(vNum);
  if pos('@', vNum) = 0 then
  Begin
    Int_OnErroInterno(Self, 'Número inválido', vNum);
    Exit;
  end;

  lThread := TThread.CreateAnonymousThread(procedure
      begin
         if Config.AutoDelay > 0 then
            sleep(random(Config.AutoDelay));

        TThread.Synchronize(nil, procedure
        begin
          if Assigned(FrmConsole) then
          begin
            FrmConsole.ReadMessages(vNum); //Marca como lida a mensagem
            FrmConsole.sendBase64(vBase64, vNum, vFileName, vMess);
          end;
        end);
      end);
  lThread.FreeOnTerminate := true;
  lThread.Start;
end;

procedure TInjectWhatsapp.SetAuth(const Value: boolean);
begin
  If TestConnect = Value Then
     Exit;

  if (Not TestConnect) and (Value) then
  Begin
    Fstatus := Whats_Connected;
     if Assigned(FOnConnected) then
         FOnConnected(Self);
  end;

  if (TestConnect) and (not Value) then
  Begin
    Fstatus := Whats_Disconnected;
    if Assigned(FrmConsole) then
       FrmConsole.DisConnect;

    if Assigned(FOnDisconnected) then
       FOnDisconnected(Self);
  end;

  if Assigned(OnGetStatus ) then
  Begin
    OnGetStatus(Fstatus, FQrCodeStyle);
  end;
end;


procedure TInjectWhatsapp.SetOnLowBattery(const Value: TOnLowBattery);
begin
  FOnLowBattery := Value;
  if Assigned(FrmConsole) then
     FrmConsole.MonitorLowBattry := Assigned(FOnLowBattery);
end;



procedure  TInjectWhatsapp.ShutDown;
var
  LIni: Cardinal;
  LHandle: HWND;
begin
  if FDestruido then
     Exit;
  if Status <> Whats_Disconnected then
  Begin
    FDestruido := true;
    if Assigned(FrmConsole) then
    Begin
      try
        LHandle := FrmConsole.Handle;
      Except
        Exit;
      end;
      FrmConsole.DisConnect;
      Fstatus := Whats_Disconnecting;
      LIni    := GetTickCount;
      PostMessage(LHandle, WM_CLOSE, 0, 0);
      Repeat
        SleepNoFreeze(20);
        if (GetTickCount - LIni) >= 3000 then //Retirado do EXEMPLO do CEF para dar tempo de todas as thread recebem a ordem de finalização
           Break;
      Until Status = Whats_Disconnected;
      FPediuCOntados := False;
    end;

    FStatus := Whats_Destroying;
    PostMessage(LHandle, CEF_DESTROY, 0, 0);
    Repeat
      SleepNoFreeze(10);
    Until Status = Whats_Destroy;
  end;
  GlobalCEFApp.Chromium     := Nil;
  FrmConsole := Nil;
 end;

procedure TInjectWhatsapp.stopWhatsapp;
begin
  if Assigned(FrmConsole) then
    FrmConsole.DisConnect;
  FPediuCOntados := False;
end;


function TInjectWhatsapp.TestConnect: Boolean;
begin
  Result := (Fstatus = Whats_Connected);
end;

function TInjectWhatsapp.GetWhatsAppShowing: Boolean;
var
  lForm: Tform;
begin
  Result := False;
  lForm  := nil;
  try
    try
      case FQrCodeStyle of
        Ft_Desktop : lForm := FrmConsole.FormQrCode;
        Ft_Http    : lForm := FrmConsole;
      end;
    finally
     if Assigned(lForm) then
        Result := lForm.Showing;
    end;
  except
    Result := False;
  end;
end;

procedure TInjectWhatsapp.SetWhatsAppShowing(const Value: Boolean);
var
  lForm: Tform;
begin
  lForm := Nil;
  try
    case FQrCodeStyle of
      Ft_Desktop : Begin
                     if Status = Whats_Connected then
                        lForm := FrmConsole else
                        lForm := FrmConsole.FormQrCode;
                   end;
      Ft_Http    : lForm := FrmConsole;
    end;

  finally
   if Assigned(lForm) then
      lForm.Show else
      raise Exception.Create('Formulário não inicializado');
  end;
end;


procedure TInjectWhatsapp.FormQrCodeReloader;
begin
  if not Assigned(FrmConsole) then
     Exit;

  FrmConsole.ReloaderWeb;
end;


procedure TInjectWhatsapp.FormQrCodeStart(PViewForm: Boolean);
Var
   LState: Boolean;
begin
  If Application.Terminated Then
     Exit;
  LState := Assigned(FrmConsole);

  if Status in [Whats_Destroying, Whats_Disconnecting] then
  Begin
    Application.MessageBox(PWideChar('A sessão anterior ainda está sendo finalizada, tente novamente mais tarde'), PWideChar(Application.Title), MB_ICONERROR + mb_ok);
    Exit;
  end;


  if Status in [Whats_Disconnected, Whats_Destroy] then
  Begin
    if not ConsolePronto then
    Begin
      Application.MessageBox(PWideChar(ConfigCEF_ExceptConsoleNaoPronto), PWideChar(Application.Title), MB_ICONERROR + mb_ok);
      Exit;
    end;

    //Reseta o FORMULARIO
    if LState Then
       FormQrCodeReloader;
  End else
  Begin
    //Ja esta logado!!! chamou apenas por chamar!! ou porque nao esta visivel..
    PViewForm :=true
  end;

  //Faz uma parada forçada para que tudo seja concluido
  SleepNoFreeze(30);
  FrmConsole.StartQrCode(FormQrCodeType, PViewForm);
end;

procedure TInjectWhatsapp.FormQrCodeStop;
begin
  if not Assigned(FrmConsole) then
     Exit;
  FrmConsole.StopQrCode(FormQrCodeType);
  FPediuCOntados := False;
end;

procedure TInjectWhatsapp.StartQrCode(PViewForm:Boolean);
begin
  If (Application.Terminated) and (not startWhatsapp) Then
     Exit;
  if not Assigned(FrmConsole) then
     Exit;

  SleepNoFreeze(10);
  FrmConsole.StartQrCode(FormQrCodeType, PViewForm);
end;

Function TInjectWhatsapp.startWhatsapp: Boolean;
begin
  Result := False;
  If Application.Terminated Then
     Exit;

  if not ConsolePronto then
  Begin
    Application.MessageBox(PWideChar(ConfigCEF_ExceptConsoleNaoPronto), PWideChar(Application.Title), MB_ICONERROR + mb_ok);
    Exit;
  end;
  //Faz uma parada forçada para que tudo seja concluido
  SleepNoFreeze(30);
  Result := True;
end;

procedure TInjectWhatsapp.StopQrCode;
begin
  If (Application.Terminated) and (not startWhatsapp) Then
     Exit;
  if not Assigned(FrmConsole) then
     Exit;


  FrmConsole.StopQrCode(FQrCodeStyle);

end;

end.


