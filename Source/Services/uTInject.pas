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
  uTInject.Classes, uTInject.FrmQRCode, uTInject.constant, uTInject.Emoticons, uTInject.Config,
  uTInject.JS;


{
###########################################################################################
                                    EVOLUÇÃO
###########################################################################################
1.0.0.11 =  08/12/2019 - Mike Lustosa
     - Implementado o getMyNumber função que retorna o número do telefone logado no whatsapp

1.0.0.10 =  04/12/2019 - Daniel Rodrigues - Dor_poa@hotmail.com
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
  TGetUnReadMessages = procedure(Chats: TChatList) of object;
  TOnLowBattery      = procedure(Const POnAlarm, PBatteryCharge: Integer) of object;



  TInjectWhatsapp = class(TComponent)
  private
    FInjectConfig         : TInjectConfig;
    FInjectJS             : TInjectJS;
    FEmoticons            : TInjectEmoticons;
    FAdjustNumber         : TInjectAdjusteNumber;
    FAllContacts          : TRetornoAllContacts;
    FAllChats             : TChatList;
    FQrCodeClass          : TQrCodeClass;

    FMyNumber             : string;
    FGetBatteryLevel      : Integer;
    Fversion              : String;
    FAuth                 : Boolean;
    FPediuCOntados        : Boolean;

    { Private  declarations }
    Function  ConsolePronto:Boolean;
    procedure SetAuth(const Value: boolean);
    procedure OnResultMisc(PTypeHeader: TTypeHeader; PValue: String);
    procedure SetOnLowBattery(const Value: TOnLowBattery);
    procedure Int_OnUpdateJS   (Sender : TObject);
    procedure Int_OnErroInterno(Sender : TObject; Const PError: String; Const PInfoAdc:String);
  protected
    { Protected declarations }
    FOnGetUnReadMessages  : TGetUnReadMessages;
    FOnGetContactList     : TNotifyEvent;
    FOnLowBattery         : TOnLowBattery;
    FOnGetBatteryLevel    : TNotifyEvent;
    FOnGetQrCode          : TNotifyEvent;
    FOnUpdateJS           : TNotifyEvent;
    FOnGetChatList        : TNotifyEvent;
    FOnGetNewMessage      : TNotifyEvent;
    FOnGetMyNumber        : TNotifyEvent;
    FOnGetStatus          : TNotifyEvent;
    FOnConnected          : TNotifyEvent;
    FOnDisconnected       : TNotifyEvent;
    FOnErroInternal       : TOnErroInternal;
    procedure Loaded; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    Procedure ShutDown(PClearNotifyEvent: Boolean = False);

    procedure ReadMessages(vID: string);

    procedure startQrCode;
    procedure monitorQrCode;

    Function  startWhatsapp: Boolean;
    procedure stopWhatsapp;

    procedure ShowWebApp;
    procedure send(vNum, vMess: string);
    procedure sendBase64(vBase64, vNum, vFileName, vMess: string);

    procedure GetBatteryStatus;
    procedure GetAllContacts;
    procedure GetContacts(PFind:String; Const PResult: TStrings);
    procedure GetAllChats;
    function  GetUnReadMessages: String;

    Property  BatteryLevel: Integer              Read FGetBatteryLevel;
    Property  MyNumber    : String               Read FMyNumber;
    Property  Emoticons   : TInjectEmoticons     Read FEmoticons          Write FEmoticons;
    property  AllContacts : TRetornoAllContacts  read FAllContacts        write FAllContacts;
    property  AQrCode     : TQrCodeClass         read FQrCodeClass        write FQrCodeClass;
    property  AllChats    : TChatList            read FAllChats           write FAllChats;
    property  Auth        : boolean              read FAuth               write SetAuth;
  published
    { Published declarations }
    Property Version              : String               Read Fversion;
    Property InjectJS             : TInjectJS            Read FInjectJS;
    property Config               : TInjectConfig        read FInjectConfig;
    property AjustNumber          : TInjectAdjusteNumber read FAdjustNumber;

    property OnGetContactList     : TNotifyEvent         read FOnGetContactList     write FOnGetContactList;
    property OnGetQrCode          : TNotifyEvent         read FOnGetQrCode          write FOnGetQrCode;
    property OnGetChatList        : TNotifyEvent         read FOnGetChatList        write FOnGetChatList;
    property OnGetNewMessage      : TNotifyEvent         read FOnGetNewMessage      write FOnGetNewMessage;
    property OnGetUnReadMessages  : TGetUnReadMessages   read FOnGetUnReadMessages  write FOnGetUnReadMessages;
    property OnGetStatus          : TNotifyEvent         read FOnGetStatus          write FOnGetStatus;
    property OnGetBatteryLevel    : TNotifyEvent         read FOnGetBatteryLevel    write FOnGetBatteryLevel;
    property OnGetMyNumber        : TNotifyEvent         read FOnGetMyNumber        write FOnGetMyNumber;
    property OnUpdateJS           : TNotifyEvent         read FOnUpdateJS           write FOnUpdateJS;
    property OnLowBattery         : TOnLowBattery        read FOnLowBattery         write SetOnLowBattery;
//    property OnConnected          : TNotifyEvent         read FOnConnected          write FOnConnected;
//    property OnDisConnected       : TNotifyEvent         read FOnDisconnected       write FOnDisconnected;
    property OnErroAndWarning     : TOnErroInternal      read FOnErroInternal       write FOnErroInternal;
  end;


procedure Register;


implementation

uses
  uCEFTypes,
  uTInject.Console,   uTInject.ConfigCEF, Winapi.Windows;


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

    Result := Assigned(FrmConsole);
    if not Assigned(FrmConsole) Then
    Begin
      InjectJS.UpdateNow;
      if InjectJS.Ready then
      Begin
        FrmConsole                  := TFrmConsole.Create(nil);
        FrmConsole.OnResultMisc     := OnResultMisc;
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
  FGetBatteryLevel                 := -1;
  Fversion                         := TInjectVersion;
  FInjectConfig                    := TInjectConfig.Create(self);
  FInjectConfig.Name               := 'AutoInject';
  FInjectConfig.AutoDelay          := 1000;
  FInjectConfig.SecondsMonitor     := 3;
  FInjectConfig.ControlSend        := True;
  FInjectConfig.LowBatteryis       := 30;
  FInjectConfig.ControlSendTimeSec := 8;
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
  stopWhatsapp;
  FreeAndNil(FrmConsole);
  FreeAndNil(FrmQRCode);

  FreeAndNil(FQrCodeClass);
  FreeAndNil(FAllContacts);
  FreeAndNil(FAllChats);
  FreeAndNil(FAdjustNumber);
  FreeAndNil(FInjectJS);
  FreeAndNil(FInjectConfig);
  inherited;
end;

//procedure TInjectWhatsapp.fileToBase64(vFile: string);
//begin
//  uBase64.FileToBase64(vFile);
//end;

procedure TInjectWhatsapp.GetAllContacts;
begin
  if Assigned(FrmConsole) then
  Begin
    FrmConsole.GetAllContacts;
    FPediuCOntados := true;
  end;
end;

procedure TInjectWhatsapp.GetContacts(PFind: String; const PResult: TStrings);
var
  LContato: TContactClass;
begin
  PResult.Clear;
  If Length(PFind) < 2 then
     Exit;

  PFind := Trim(PFind);
  if Assigned(FAllContacts) then
  Begin
    if (Length(FAllContacts.result) <= 0) and (not FPediuCOntados) Then
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

  for LContato in FAllContacts.result do
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

  if Assigned(GlobalCEFApp) then
     GlobalCEFApp.InjectWhatsApp := Self;

  if Config.AutoStart then
     startWhatsapp;
end;

procedure TInjectWhatsapp.monitorQrCode;
begin
  if Assigned(FrmConsole) then
     FrmConsole.monitorQRCode;
end;


procedure TInjectWhatsapp.OnResultMisc(PTypeHeader: TTypeHeader; PValue: String);
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
  If FAuth = Value Then
     Exit;

  if (Not FAuth) and (Value) then
  Begin
     if Assigned(FOnConnected) then
         FOnConnected(Self);
  end;

  if (FAuth) and (not Value) then
  Begin
     if Assigned(FOnDisconnected) then
         FOnDisconnected(Self);
  end;


  FAuth := Value;
  if Assigned(OnGetStatus ) then
     OnGetStatus(Self);
end;


procedure TInjectWhatsapp.SetOnLowBattery(const Value: TOnLowBattery);
begin
  FOnLowBattery := Value;
  if Assigned(FrmConsole) then
     FrmConsole.MonitorLowBattry := Assigned(FOnLowBattery);
end;

procedure TInjectWhatsapp.ShowWebApp;
begin
  if not startWhatsapp Then
     Exit;
  if Assigned(FrmConsole) then
     FrmConsole.Show;
end;

Procedure  TInjectWhatsapp.ShutDown(PClearNotifyEvent: Boolean = False);
var
  LVar        : Boolean;
  LaAction    : TCefCloseBrowserAction;
  LaActionForm: TCloseAction;
begin
  //Executa o SHutDown
  if PClearNotifyEvent then
  Begin
    FOnGetUnReadMessages  := Nil;
    FOnGetContactList     := Nil;
    FOnGetQrCode          := Nil;
    FOnGetChatList        := Nil;
    FOnGetNewMessage      := Nil;
    FOnGetBatteryLevel    := Nil;
    FOnGetStatus          := Nil;
    FOnLowBattery         := Nil;
  End;

  LVar        := True;
  LaAction    := cbaDelay;
  LaActionForm:= Cafree;
  try
    if  Assigned(GlobalCEFApp) and (GlobalCEFApp <> nil) Then
    Begin
      if Assigned(GlobalCEFApp.Chromium) then
      Begin
       if Assigned(GlobalCEFApp.ChromiumForm) then
          TFrmConsole(GlobalCEFApp.ChromiumForm).DisConnect;

        GlobalCEFApp.Chromium.OnClose(GlobalCEFApp.Chromium, GlobalCEFApp.Chromium.Browser,  LaAction);
        GlobalCEFApp.Chromium.CloseBrowser(True);

        //Executa fecgamento FORM
        GlobalCEFApp.ChromiumForm.OnCloseQuery(GlobalCEFApp.ChromiumForm, LVar);
        GlobalCEFApp.ChromiumForm.OnClose     (GlobalCEFApp.ChromiumForm, LaActionForm);
        GlobalCEFApp.ChromiumForm.Close;
      End;
      FPediuCOntados := False;
      FreeAndNil(FrmQRCode);
      FreeAndNil(FrmConsole);
      GlobalCEFApp.Chromium     := Nil;
    End;
  except
  end
end;


procedure TInjectWhatsapp.stopWhatsapp;
begin
  if Assigned(FrmConsole) then
  begin
    FrmConsole.DisConnect;
    FrmConsole.close;
    FreeAndNil(FrmConsole);
  end;
  FPediuCOntados := False;
end;

procedure TInjectWhatsapp.startQrCode;
begin
  If Application.Terminated Then
     Exit;

  if not startWhatsapp Then
     Exit;

  if Assigned(FrmConsole) then
  begin
    if not Assigned(FrmQRCode) then
    begin
      FrmQRCode         := TFrmQRCode.Create(nil);
      FrmQRCode.Show;
    end;
    monitorQrCode;
  end;
end;

Function TInjectWhatsapp.startWhatsapp: Boolean;
var
  I: Integer;
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

  for I := 0 to 10 do
  Begin
     Sleep(10);
     Application.ProcessMessages;
  end;
  Result := True;
end;

end.


