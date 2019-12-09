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
  System.SysUtils, System.Classes, Vcl.Forms, Vcl.Dialogs, UBase64, uTInject.AdjustNumber,
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

  TInjectWhatsapp = class(TComponent)
  private
    FInjectConfig         : TInjectConfig;
    FInjectJS             : TInjectJS;
    FEmoticons            : TInjectEmoticons;
    FAdjustNumber         : TInjectAdjusteNumber;

    FAllContacts          : TRetornoAllContacts;
    FAllChats             : TChatList;
    FQrCodeClass          : TQrCodeClass;

    FVersaoIde            : String;
    FGetBatteryLevel      : string;
    FAuth                 : Boolean;
    FMonitoring           : Boolean;
    FPediuCOntados        : Boolean;

    { Private declarations }
    Function ConsolePronto:Boolean;
    procedure SetAuth(const Value: boolean);
  protected
    { Protected declarations }
    FOnGetUnReadMessages  : TGetUnReadMessages;
    FBatteryLevel         : TNotifyEvent;
    FOnGetQrCode          : TNotifyEvent;
    FOnGetChatList        : TNotifyEvent;
    FOnGetNewMessage      : TNotifyEvent;
    FOnGetBatteryLevel    : TNotifyEvent;
    FOnGetMyNumber        : TNotifyEvent;
    FOnGetStatus          : TNotifyEvent;
  public
    AGetBatteryLevel               : string;
    AGetMyNumber                   : string;
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure   ShutDown(PClearNotifyEvent: Boolean = False);

    procedure ReadMessages(vID: string);
    procedure startQrCode;
    procedure monitorQrCode;
    procedure startWhatsapp;
    procedure stopWhatsapp;
    procedure StartMonitor;
    procedure StopMonitor;
    procedure ShowWebApp;
    procedure send(vNum, vMess: string);
    procedure batteryStatus();
    procedure myNumber();
    procedure sendBase64(vBase64, vNum, vFileName, vMess: string);
//    procedure fileToBase64(vFile: string);
    procedure GetAllContacts;
    procedure GetContacts(PFind:String; Const PResult: TStrings);

    procedure GetAllChats;
    function  GetUnReadMessages: String;


    Property Emoticons : TInjectEmoticons     Read FEmoticons    Write FEmoticons;
    property AllContacts: TRetornoAllContacts read FAllContacts  write FAllContacts;
    property BatteryLevel: TNotifyEvent       read FBatteryLevel write FBatteryLevel;
    property AQrCode: TQrCodeClass            read FQrCodeClass  write FQrCodeClass;
    property AllChats: TChatList              read FAllChats     write FAllChats;
    property Auth: boolean                    read FAuth         write SetAuth;
    property Monitoring: Boolean              read FMonitoring   default False;
  published
    { Published declarations }
    Property VersaoIDE            : String               Read FVersaoIde;
    Property InjectJS             : TInjectJS            Read FInjectJS;
    property Config               : TInjectConfig        read FInjectConfig;
    property AjustNumber          : TInjectAdjusteNumber read FAdjustNumber;
    property OnGetContactList     : TNotifyEvent         read FBatteryLevel         write FBatteryLevel;
    property OnGetQrCode          : TNotifyEvent         read FOnGetQrCode          write FOnGetQrCode;
    property OnGetChatList        : TNotifyEvent         read FOnGetChatList        write FOnGetChatList;
    property OnGetNewMessage      : TNotifyEvent         read FOnGetNewMessage      write FOnGetNewMessage;
    property OnGetUnReadMessages  : TGetUnReadMessages   read FOnGetUnReadMessages  write FOnGetUnReadMessages;
    property OnGetStatus          : TNotifyEvent         read FOnGetStatus          write FOnGetStatus;
    property OnGetBatteryLevel    : TNotifyEvent         read FOnGetBatteryLevel    write FOnGetBatteryLevel;
    property OnGetMyNumber        : TNotifyEvent         read FOnGetMyNumber        write FOnGetMyNumber;
    property ABatteryLevel        : string               Read FGetBatteryLevel;
  end;


procedure Register;


implementation

uses
  uCEFTypes,
  uTInject.Console,   uTInject.ConfigCEF;


procedure Register;
begin
  RegisterComponents('TInjectWhatsapp', [TInjectWhatsapp]);
end;



{ TInjectWhatsapp }

procedure TInjectWhatsapp.batteryStatus();
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
  FVersaoIde                   := TInjectVersion;
  FInjectConfig                := TInjectConfig.Create(self);
  FInjectConfig.Name           := 'AutoInject';
  FInjectConfig.AutoDelay      := 1000;
  FInjectConfig.SecondsMonitor := 3;
  FInjectConfig.AutoMonitor    := True;
  FInjectConfig.SetSubComponent(true);

  FAdjustNumber               := TInjectAdjusteNumber.Create(self);
  FAdjustNumber.Name          := 'AdjustNumber';
  FAdjustNumber.SetSubComponent(true);


  FInjectJS                   := TInjectJS.Create(self);
  FInjectJS.Name              := 'InjectJS';
  FInjectJS.SetSubComponent(true);

  if (csDesigning in ComponentState) then
     Exit;
  if Assigned(GlobalCEFApp) then
     GlobalCEFApp.InjectWhatsApp := Self;

//  if Config.AutoStart then
//     startWhatsapp;
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
  If Application.Terminated Then
     Exit;
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
  if Length(PFind) < 2 then
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
  If Application.Terminated Then
     Exit;
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

procedure TInjectWhatsapp.monitorQrCode;
begin
  If Application.Terminated Then
     Exit;
  if Assigned(FrmConsole) then
     FrmConsole.monitorQRCode;
end;


procedure TInjectWhatsapp.myNumber;
begin
  if Assigned(FrmConsole) then
     FrmConsole.GetMyNumber;
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

  vNum := AjustNumber.Format(vNum);
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

  vNum := AjustNumber.Format(vNum);
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
  If Application.Terminated Then
     Exit;

  FAuth := Value;
  if Assigned( OnGetStatus ) then
     OnGetStatus( Self );
end;


Procedure TInjectWhatsapp.ShowWebApp;
begin
  If Application.Terminated Then
     Exit;

  startWhatsapp;
  if Assigned(FrmConsole) then
     FrmConsole.Show;
end;

procedure TInjectWhatsapp.ShutDown(PClearNotifyEvent: Boolean = False);
var
  LVar        : Boolean;
  LaAction    : TCefCloseBrowserAction;
  LaActionForm: TCloseAction;
begin
  //Executa o SHutDown
  if PClearNotifyEvent then
  Begin
    FOnGetUnReadMessages  := Nil;
    FBatteryLevel         := Nil;
    FOnGetQrCode          := Nil;
    FOnGetChatList        := Nil;
    FOnGetNewMessage      := Nil;
    FOnGetBatteryLevel    := Nil;
    FOnGetStatus          := Nil;
  End;

  LVar        := True;
  LaAction    := cbaDelay;
  LaActionForm:= Cafree;
  if  Assigned(GlobalCEFApp) and (GlobalCEFApp <> nil) Then
  Begin
    if Assigned(GlobalCEFApp.Chromium) then
    Begin
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
end;

procedure TInjectWhatsapp.StartMonitor;
begin
  If Application.Terminated Then
     Exit;
  if not Assigned(FrmConsole) then
     Exit;

  if FMonitoring then Exit;

  FMonitoring := not Monitoring;
  FrmConsole.StartMonitor( Config.SecondsMonitor );
end;

procedure TInjectWhatsapp.StopMonitor;
begin
  If Application.Terminated Then
     Exit;
  if not Assigned(FrmConsole) then
     Exit;

  if not FMonitoring then Exit;

  FMonitoring := not Monitoring;
  FrmConsole.StopMonitor;
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

  startWhatsapp;
  if Assigned(FrmConsole) then
  begin
    if not Assigned(FrmQRCode) then
    begin
      FrmQRCode         := TFrmQRCode.Create(nil);
      FrmQRCode.Show;
    end;
  end;
end;

procedure TInjectWhatsapp.startWhatsapp;
begin
  If Application.Terminated Then
     Exit;

  if not ConsolePronto then
     raise Exception.Create(ConfigCEF_ExceptConsoleNaoPronto);
end;

end.


