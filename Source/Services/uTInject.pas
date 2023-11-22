{####################################################################################################################
                              TINJECT - Componente de comunicação (Não Oficial)
                                           www.tinject.com.br
                                            Novembro de 2019
####################################################################################################################
    Owner.....: Mike W. Lustosa            - mikelustosa@gmail.com   - +55 81 9.9630-2385
    Developer.: Joathan Theiller           - jtheiller@hotmail.com   -
                Daniel Oliveira Rodrigues  - Dor_poa@hotmail.com     - +55 51 9.9155-9228
####################################################################################################################
  Obs:
     - Código aberto a comunidade Delphi, desde que mantenha os dados dos autores e mantendo sempre o nome do IDEALIZADOR
       Mike W. Lustosa;
     - Colocar na evolução as Modificação juntamente com as informaçoes do colaborador: Data, Nova Versao, Autor;
     - Mantenha sempre a versao mais atual acima das demais;
     - Todo Commit ao repositório deverá ser declarado as mudança na UNIT e ainda o Incremento da Versão de
       compilação (último digito);

####################################################################################################################
                                  Evolução do Código
####################################################################################################################
  Autor........:
  Email........:
  Data.........:
  Identificador:
  Modificação..:
####################################################################################################################
}

unit uTInject;

interface

uses
  uTInject.Classes, uTInject.constant, uTInject.Emoticons, uTInject.Config,
  uTInject.JS, uTInject.Console,
  uTInject.languages,
  uTInject.AdjustNumber, UBase64,

  System.SysUtils, System.Classes, Vcl.Forms, Vcl.Dialogs, System.MaskUtils,
  System.UiTypes,  Generics.Collections, System.TypInfo, Data.DB, Vcl.ExtCtrls,
  uTInject.Diversos, Vcl.Imaging.jpeg;


  {$IF DECLARED(FireMonkeyVersion)}
    {$DEFINE HAS_FMX}
  {$ELSE}
    {$DEFINE HAS_VCL}
  {$IFEND}

type
  {Events}
  TOnGetIsDelivered         = Procedure(Sender : TObject; Status: string) of object;

  TOnGetCheckIsConnected    = Procedure(Sender : TObject; Connected: Boolean) of object;
  TOnGetCheckIsValidNumber  = Procedure(Sender : TObject; Number: String;  IsValid: Boolean) of object;
  TOnGetProfilePicThumb     = Procedure(Sender : TObject; Base64: String) of object;
  TGetUnReadMessages        = procedure(Const Chats: TChatList) of object;
  TGetUnReadMessagesFromMe  = procedure(Const Chats: TChatList) of object;
  TOnGetQrCode              = procedure(Const Sender: Tobject; Const QrCode: TResultQRCodeClass) of object;
  TOnAllContacts            = procedure(Const AllContacts: TRetornoAllContacts) of object;
  TOnAllGroups              = procedure(Const AllGroups: TRetornoAllGroups) of object;
  TOnAllGroupContacts       = procedure(Const Contacts: TClassAllGroupContacts) of object;
  TOnAllGroupAdmins         = procedure(Const AllGroups: TRetornoAllGroupAdmins) of object;
  TOnGetStatusMessage       = procedure(Const Result: TResponseStatusMessage) of object;
  TOnGetInviteGroup         = procedure(Const Invite : String) of object;
  TOnGetMe                  = procedure(Const vMe : TGetMeClass) of object;
  TOnNewCheckNumber         = procedure(Const vCheckNumber : TReturnCheckNumber) of object;
  TOnGetIncomingCall        = procedure(Const incomingCall: TReturnIncomingCall) of object;


  TInject = class(TComponent)
  private
    FInjectConfig           : TInjectConfig;
    FInjectJS               : TInjectJS;
    FEmoticons              : TInjectEmoticons;
    FAdjustNumber           : TInjectAdjusteNumber;
    FTranslatorInject       : TTranslatorInject;
    FDestroyTmr             : Ttimer;
    FFormQrCodeType         : TFormQrCodeType;
    FMyNumber               : string;
    FIsDelivered            : string;
    FGetBatteryLevel        : Integer;
    FGetIsConnected         : Boolean;
    Fversion                : String;
    Fstatus                 : TStatusType;
    FDestruido              : Boolean;

    FLanguageInject         : TLanguageInject;
    FOnDisconnectedBrute    : TNotifyEvent;
    { Private  declarations }
    Function  ConsolePronto:Boolean;
    procedure SetAuth(const Value: boolean);
    procedure SetOnLowBattery(const Value: TNotifyEvent);
    procedure Int_OnUpdateJS   (Sender : TObject);
    procedure Int_OnErroInterno(Sender : TObject; Const PError: String; Const PInfoAdc:String);
    Function  GetAppShowing:Boolean;
    procedure SetAppShowing(const Value: Boolean);
    procedure OnCLoseFrmInt(Sender: TObject; var CanClose: Boolean);
    procedure SetQrCodeStyle(const Value: TFormQrCodeType);
    procedure LimparQrCodeInterno;
    procedure SetLanguageInject(const Value: TLanguageInject);
    procedure SetInjectConfig(const Value: TInjectConfig);
    procedure SetdjustNumber(const Value: TInjectAdjusteNumber);
    procedure SetInjectJS(const Value: TInjectJS);
    procedure OnDestroyConsole(Sender : TObject);


  protected
    { Protected declarations }
    FOnGetUnReadMessages        : TGetUnReadMessages;
    FOnGetUnReadMessagesFromMe  : TGetUnReadMessagesFromMe;
    FOnGetAllGroupContacts      : TOnAllGroupContacts;
    FOnGetAllContactList        : TOnAllContacts;
    FOnGetAllGroupList          : TOnAllGroups;
    FOnGetAllGroupAdmins        : TOnAllGroupAdmins;
    FOnLowBattery               : TNotifyEvent;
    FOnGetBatteryLevel          : TNotifyEvent;
    FOnGetCheckIsConnected      : TOnGetCheckIsConnected;
    FOnGetCheckIsValidNumber    : TOnGetCheckIsValidNumber;
    FOnGetProfilePicThumb       : TOnGetProfilePicThumb;
    FOnGetQrCode                : TOnGetQrCode;
    FOnUpdateJS                 : TNotifyEvent;
    FOnGetChatList              : TGetUnReadMessages;
    FOnGetMyNumber              : TNotifyEvent;
    FOnGetIsDelivered           : TNotifyEvent;
    FOnGetStatus                : TNotifyEvent;
    FOnConnected                : TNotifyEvent;
    FOnDisconnected             : TNotifyEvent;
    FOnErroInternal             : TOnErroInternal;
    FOnAfterInjectJs            : TNotifyEvent;
    FOnAfterInitialize          : TNotifyEvent;
    FOnGetStatusMessage         : TOnGetStatusMessage;
    FOnGetInviteGroup           : TOnGetInviteGroup;
    FOnGetMe                    : TOnGetMe;
    FOnNewCheckNumber           : TOnNewCheckNumber;
    FOnGetIncomingCall          : TOnGetIncomingCall;

    procedure Int_OnNotificationCenter(PTypeHeader: TTypeHeader; PValue: String; Const PReturnClass : TObject= nil);

    procedure Loaded; override;

  public

    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    Procedure   ShutDown(PWarning:Boolean = True);
    Procedure   Disconnect;
    //funcao experimental para configuracao de proxy de rede(Ainda nao foi testada)
    //Olhar em uTInject.Console funcao ConfigureNetWork
    //Function    ConfigureNetwork: Boolean;
    procedure ReadMessages(vID: string);
    function  TestConnect:  Boolean;
    procedure Send(PNumberPhone, PMessage: string; PEtapa: string = '');
    procedure SendButtons(phoneNumber: string; titleText: string; buttons: string; footerText: string; etapa: string = '');
    procedure SendButtonList(phoneNumber: string; titleText1: string; titleText2: string; titleButton: string; options: string; etapa: string = '');
    procedure sendPool(PGroupID, PTitle, PSurvey: string);
    procedure deleteConversation(PNumberPhone: string);
    procedure SendContact(PPhoneDestiny, PPhoneContact: string; PNameContact: string = '');
    procedure SendFile(PNumberPhone: String; Const PFileName: String; PMessage: string = '');
    procedure SendBase64(Const vBase64: String; vNum: String;  Const vFileName, vMess: string);     deprecated; //Versao 1.0.2.0 disponivel ate Versao 1.0.6.0
    procedure SendLinkPreview(PNumberPhone, PVideoLink, PMessage: string);
    procedure SendLocation(PNumberPhone, PLat, PLng, PName, PAddress: string);
    procedure Logtout();
    procedure GetBatteryStatus;
    procedure CheckIsValidNumber(PNumberPhone: string);
    procedure NewCheckIsValidNumber(PNumberPhone : string);
    procedure CheckIsConnected;
    procedure GetAllContacts;
    procedure GetAllGroups;
    procedure GroupAddParticipant(PIDGroup, PNumber: string);
    procedure GroupRemoveParticipant(PIDGroup, PNumber: string);
    procedure GroupPromoteParticipant(PIDGroup, PNumber: string);
    procedure GroupDemoteParticipant(PIDGroup, PNumber: string);
    procedure GroupLeave(PIDGroup: string);
    procedure GroupDelete(PIDGroup: string);
    procedure ConsoleClear();
    procedure GroupJoinViaLink(PLinkGroup: string);
    procedure GroupRemoveInviteLink(PIDGroup: string);
    procedure SetProfileName(vName : String);
    procedure SetStatus(vStatus: String);
    procedure GetStatusContact(PNumber: String);
    procedure GetGroupInviteLink(PIDGroup : string);
    procedure CleanALLChat(PNumber: String);
    procedure GetMe;

    Function  GetContact(Pindex: Integer): TContactClass;  deprecated;  //Versao 1.0.2.0 disponivel ate Versao 1.0.6.0
    procedure GetAllChats;
    Function  GetChat(Pindex: Integer):TChatClass;
    function  GetUnReadMessages: String;
    function  CheckDelivered: String;
    procedure getProfilePicThumb(AProfilePicThumbURL: string);
    procedure createGroup(PGroupName, PParticipantNumber: string);
    procedure listGroupContacts(PIDGroup: string);
    Property  BatteryLevel      : Integer              Read FGetBatteryLevel;
    Property  IsConnected       : Boolean              Read FGetIsConnected;
    Property  MyNumber          : String               Read FMyNumber;

    //Mike 29/12/2020
    Property  IsDelivered       : String               Read FIsDelivered;

    property  Authenticated     : boolean              read TestConnect;
    property  Status            : TStatusType          read FStatus;
    Function  StatusToStr       : String;
    Property  Emoticons         : TInjectEmoticons     Read FEmoticons                     Write FEmoticons;
    property  FormQrCodeShowing : Boolean              read GetAppShowing                  Write SetAppShowing;
    Procedure FormQrCodeStart(PViewForm:Boolean = true);
    Procedure FormQrCodeStop;
    Procedure FormQrCodeReloader;
    Function  Auth(PRaise: Boolean = true): Boolean;
  published
    { Published declarations }
    Property Version                     : String                     read Fversion;
    Property InjectJS                    : TInjectJS                  read FInjectJS                       Write SetInjectJS;
    property Config                      : TInjectConfig              read FInjectConfig                   Write SetInjectConfig;
    property AjustNumber                 : TInjectAdjusteNumber       read FAdjustNumber                   Write SetdjustNumber;
    property FormQrCodeType              : TFormQrCodeType            read FFormQrCodeType                 Write SetQrCodeStyle                      Default Ft_Desktop;
    property LanguageInject              : TLanguageInject            read FLanguageInject                 Write SetLanguageInject                   Default TL_Portugues_BR;
    property OnGetAllContactList         : TOnAllContacts             read FOnGetAllContactList            write FOnGetAllContactList;
    property OnGetAllGroupList           : TOnAllGroups               read FOnGetAllGroupList              write FOnGetAllGroupList;
    property OnGetAllGroupAdmins         : TOnAllGroupAdmins          read FOnGetAllGroupAdmins            write FOnGetAllGroupAdmins;
    property OnAfterInjectJS             : TNotifyEvent               read FOnAfterInjectJs                write FOnAfterInjectJs;
    property OnAfterInitialize           : TNotifyEvent               read FOnAfterInitialize              write FOnAfterInitialize;
    property OnGetQrCode                 : TOnGetQrCode               read FOnGetQrCode                    write FOnGetQrCode;
    property OnGetChatList               : TGetUnReadMessages         read FOnGetChatList                  write FOnGetChatList;
    property OnGetUnReadMessages         : TGetUnReadMessages         read FOnGetUnReadMessages            write FOnGetUnReadMessages;
    property OnGetUnReadMessagesFromMe   : TGetUnReadMessagesFromMe   read FOnGetUnReadMessagesFromMe      write FOnGetUnReadMessagesFromMe;
    property OnGetAllGroupContacts       : TOnAllGroupContacts        read FOnGetAllGroupContacts          write FOnGetAllGroupContacts;
    property OnGetStatus                 : TNotifyEvent               read FOnGetStatus                    write FOnGetStatus;
    property OnGetBatteryLevel           : TNotifyEvent               read FOnGetBatteryLevel              write FOnGetBatteryLevel;
    property OnIsConnected               : TOnGetCheckIsConnected     read FOnGetCheckIsConnected          write FOnGetCheckIsConnected;
    property OnLowBattery                : TNotifyEvent               read FOnLowBattery                   write SetOnLowBattery;
    property OnGetCheckIsValidNumber     : TOnGetCheckIsValidNumber   read FOnGetCheckIsValidNumber        write FOnGetCheckIsValidNumber;
    property OnGetProfilePicThumb        : TOnGetProfilePicThumb      read FOnGetProfilePicThumb           write FOnGetProfilePicThumb;
    property OnGetMyNumber               : TNotifyEvent               read FOnGetMyNumber                  write FOnGetMyNumber;

    //Mike 29/12/2020
    property OnGetIsDelivered            : TNotifyEvent               read FOnGetIsDelivered               write FOnGetIsDelivered;


    property OnUpdateJS                  : TNotifyEvent               read FOnUpdateJS                     write FOnUpdateJS;
    property OnConnected                 : TNotifyEvent               read FOnConnected                    write FOnConnected;
    property OnDisconnected              : TNotifyEvent               read FOnDisconnected                 write FOnDisconnected;
    property OnDisconnectedBrute         : TNotifyEvent               read FOnDisconnectedBrute            write FOnDisconnectedBrute;
    property OnErroAndWarning            : TOnErroInternal            read FOnErroInternal                 write FOnErroInternal;
    property OnGetStatusMessage          : TOnGetStatusMessage        read FOnGetStatusMessage             write FOnGetStatusMessage;
    property OnGetInviteGroup            : TOnGetInviteGroup          read FOnGetInviteGroup               write FOnGetInviteGroup;
    property OnGetMe                     : TOnGetMe                   read FOnGetMe                        write FOnGetMe;
    property OnNewGetNumber              : TOnNewCheckNumber          read FOnNewCheckNumber               write FOnNewCheckNumber;
    property OnGetIncomingCall           : TOnGetIncomingCall         read FOnGetIncomingCall              write FOnGetIncomingCall;
  end;

procedure Register;


implementation

uses
  uCEFTypes, uTInject.ConfigCEF, Winapi.Windows, Winapi.Messages,
  uCEFConstants, Datasnap.DBClient, Vcl.WinXCtrls, Vcl.Controls, Vcl.StdCtrls,
  uTInject.FrmQRCode, System.NetEncoding;


procedure Register;
begin
  RegisterComponents('TInject', [TInject]);
end;

{ TInject }

procedure TInject.GetBatteryStatus();
begin
  if Assigned(FrmConsole) then
     FrmConsole.GetBatteryLevel;
end;

function TInject.Auth(PRaise: Boolean): Boolean;
begin
  Result := authenticated;

  if (not Result) and  (PRaise) then
     raise Exception.Create(Text_Status_Serv_Disconnected);
end;

//funcao experimental para configuracao de proxy de rede(Ainda nao foi testada)
//Olhar em uTInject.Console funcao ConfigureNetWork
{function TInject.ConfigureNetwork: Boolean;
begin
  Result := ConsolePronto;
  if not result then
     Exit;

  Result := FrmConsole.ConfigureNetWork;
end; }

function TInject.CheckDelivered: String;
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
               FrmConsole.CheckDelivered;
          end);

      end);
  lThread.Start;
end;

procedure TInject.CheckIsConnected;
begin
  if Assigned(FrmConsole) then
      FrmConsole.CheckIsConnected;
end;

procedure TInject.CheckIsValidNumber(PNumberPhone: string);
var
  lThread : TThread;
begin
  If Application.Terminated Then
     Exit;
  if not Assigned(FrmConsole) then
     Exit;

  PNumberPhone := AjustNumber.FormatIn(PNumberPhone);
  if pos('@', PNumberPhone) = 0 then
  Begin
    Int_OnErroInterno(Self, MSG_ExceptPhoneNumberError, PNumberPhone);
    Exit;
  end;

  lThread := TThread.CreateAnonymousThread(procedure
      begin
        TThread.Synchronize(nil, procedure
        begin
          if Assigned(FrmConsole) then
          begin
            FrmConsole.CheckIsValidNumber(PNumberPhone);
          end;
        end);

      end);

  lThread.FreeOnTerminate := true;
  lThread.Start;

end;

procedure TInject.NewCheckIsValidNumber(PNumberPhone: string);
var
  lThread : TThread;
begin
  If Application.Terminated Then
     Exit;
  if not Assigned(FrmConsole) then
     Exit;

  PNumberPhone := AjustNumber.FormatIn(PNumberPhone);
  if pos('@', PNumberPhone) = 0 then
  Begin
    Int_OnErroInterno(Self, MSG_ExceptPhoneNumberError, PNumberPhone);
    Exit;
  end;

  lThread := TThread.CreateAnonymousThread(procedure
      begin
        TThread.Synchronize(nil, procedure
        begin
          if Assigned(FrmConsole) then
          begin
            FrmConsole.NewCheckIsValidNumber(PNumberPhone);
          end;
        end);

      end);

  lThread.FreeOnTerminate := true;
  lThread.Start;

end;


procedure TInject.ConsoleClear;
begin
  if Assigned(FrmConsole) then
    FrmConsole.ConsoleClear;
end;

function TInject.ConsolePronto: Boolean;
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
      InjectJS.UpdateNow();
      if InjectJS.Ready then //Read? Get random key....
      Begin
        FDestruido                      := False;
        FrmConsole                      := TFrmConsole.Create(nil);
        FrmConsole.OwnerForm            := Self;
        FrmConsole.OnNotificationCenter := Int_OnNotificationCenter;
        FrmConsole.MonitorLowBattry     := Assigned(FOnLowBattery);
        FrmConsole.OnErrorInternal      := Int_OnErroInterno;
        FrmConsole.Connect;
      end;
    end;
    Result := Assigned(FrmConsole);
  except
    Result := False;
  end
end;

constructor TInject.Create(AOwner: TComponent);
begin
  
  inherited;
  FDestroyTmr                         := Ttimer.Create(nil);
  FDestroyTmr.Enabled                 := False;
  FDestroyTmr.Interval                := 4000;     //Tempo exigido pelo CEF
  FDestroyTmr.OnTimer                 := OnDestroyConsole;

  FTranslatorInject                   := TTranslatorInject.create;
  FDestruido                          := False;
  FGetBatteryLevel                    := -1;

  FFormQrCodeType                     := Ft_Http;
  LanguageInject                      := Tl_Portugues_BR;
  Fversion                            := TInjectVersion;
  Fstatus                             := Server_Disconnected;

  if not (csDesigning in ComponentState) then
     if not Assigned(GlobalCEFApp.IniFIle) then
        raise Exception.Create(slinebreak + MSG_Except_CefNull);

  FInjectConfig                       := TInjectConfig.Create(self);
  FInjectConfig.OnNotificationCenter  := Int_OnNotificationCenter;
  FInjectConfig.AutoDelay             := 1000;
  FInjectConfig.SecondsMonitor        := 3;
  FInjectConfig.ControlSend           := True;
  FInjectConfig.LowBatteryis          := 30;
  FInjectConfig.ControlSendTimeSec    := 8;

  FAdjustNumber                    := TInjectAdjusteNumber.Create(self);
  FInjectJS                        := TInjectJS.Create(Self);
  FInjectJS.OnUpdateJS             := Int_OnUpdateJS;
  FInjectJS.OnErrorInternal        := Int_OnErroInterno;
end;

procedure TInject.createGroup(PGroupName, PParticipantNumber: string);
var
  lThread : TThread;
begin
  If Application.Terminated Then
     Exit;
  if not Assigned(FrmConsole) then
     Exit;

  PParticipantNumber := AjustNumber.FormatIn(PParticipantNumber);
  if pos('@', PParticipantNumber) = 0 then
  Begin
    Int_OnErroInterno(Self, MSG_ExceptPhoneNumberError, PParticipantNumber);
    Exit;
  end;

  if Trim(PGroupName) = '' then
  begin
    Int_OnErroInterno(Self, MSG_WarningNothingtoSend, PParticipantNumber);
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
            FrmConsole.CreateGroup(PGroupName, PParticipantNumber);
          end;
        end);

      end);

  lThread.FreeOnTerminate := true;
  lThread.Start;
end;

procedure TInject.deleteConversation(PNumberPhone: string);
var
  lThread : TThread;
begin
  if Application.Terminated Then
     Exit;
  if not Assigned(FrmConsole) then
     Exit;

  if Assigned(FrmConsole) then
  begin
    FrmConsole.ReadMessagesAndDelete(PNumberPhone);//Deleta a conversa
  end;

end;

destructor TInject.Destroy;
begin

  FormQrCodeStop;
  FreeAndNil(FDestroyTmr);
  FreeAndNil(FTranslatorInject);
  FreeAndNil(FInjectConfig);
  FreeAndNil(FAdjustNumber);
  FreeAndNil(FInjectJS);

  inherited;
end;

procedure TInject.GetAllContacts;
begin
  if Assigned(FrmConsole) then
     FrmConsole.GetAllContacts;
end;

procedure TInject.GetAllGroups;
begin
  if Assigned(FrmConsole) then
     FrmConsole.GetAllGroups;
end;

function TInject.GetChat(Pindex: Integer): TChatClass;
begin
  Result := Nil;
  If not Assigned(FrmConsole)          then     Exit;
  If not Assigned(FrmConsole.ChatList) then     Exit;
  Result := FrmConsole.ChatList.result[Pindex]
end;

function TInject.GetContact(Pindex: Integer): TContactClass;
begin
  Result := Nil;
end;

procedure TInject.getProfilePicThumb(AProfilePicThumbURL: string);
begin
  if Assigned(FrmConsole) then
    FrmConsole.GetProfilePicThumbURL(AProfilePicThumbURL);
end;

procedure TInject.GetAllChats;
begin
  if Assigned(FrmConsole) then
     FrmConsole.GetAllChats;
end;

function TInject.GetUnReadMessages: String;
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

procedure TInject.GroupAddParticipant(PIDGroup, PNumber: string);
var
  lThread : TThread;
begin
  If Application.Terminated Then
     Exit;

  if not Assigned(FrmConsole) then
     Exit;

  PNumber := AjustNumber.FormatIn(PNumber);

  if pos('@', PNumber) = 0 then
  Begin
    Int_OnErroInterno(Self, MSG_ExceptPhoneNumberError, PNumber);
    Exit;
  end;

  lThread := TThread.CreateAnonymousThread(procedure
      begin
        TThread.Synchronize(nil, procedure
        begin
          if Assigned(FrmConsole) then
          begin
            FrmConsole.GroupAddParticipant(PIDGroup, PNumber);
          end;
        end);

      end);

  lThread.FreeOnTerminate := true;
  lThread.Start;
end;

procedure TInject.groupDelete(PIDGroup: string);
var
  lThread : TThread;
begin
  If Application.Terminated Then
     Exit;

  if not Assigned(FrmConsole) then
     Exit;

  if Trim(PIDGroup) = '' then
  begin
    Int_OnErroInterno(Self, MSG_WarningNothingtoSend, PIDGroup);
    Exit;
  end;

  lThread := TThread.CreateAnonymousThread(procedure
      begin
        TThread.Synchronize(nil, procedure
        begin
          if Assigned(FrmConsole) then
          begin
            FrmConsole.GroupDelete(PIDGroup);
          end;
        end);

      end);

  lThread.FreeOnTerminate := true;
  lThread.Start;
end;

procedure TInject.GroupDemoteParticipant(PIDGroup, PNumber: string);
var
  lThread : TThread;
begin
  If Application.Terminated Then
     Exit;

  if not Assigned(FrmConsole) then
     Exit;

  PNumber := AjustNumber.FormatIn(PNumber);

  if pos('@', PNumber) = 0 then
  Begin
    Int_OnErroInterno(Self, MSG_ExceptPhoneNumberError, PNumber);
    Exit;
  end;

  lThread := TThread.CreateAnonymousThread(procedure
      begin
        TThread.Synchronize(nil, procedure
        begin
          if Assigned(FrmConsole) then
          begin
            FrmConsole.GroupDemoteParticipant(PIDGroup, PNumber);
          end;
        end);

      end);

  lThread.FreeOnTerminate := true;
  lThread.Start;
end;

procedure TInject.GroupJoinViaLink(PLinkGroup: string);
var
  lThread : TThread;
begin
  If Application.Terminated Then
     Exit;

  if not Assigned(FrmConsole) then
     Exit;

  if Trim(PLinkGroup) = '' then
  begin
    Int_OnErroInterno(Self, MSG_WarningNothingtoSend, PLinkGroup);
    Exit;
  end;

  lThread := TThread.CreateAnonymousThread(procedure
      begin
        TThread.Synchronize(nil, procedure
        begin
          if Assigned(FrmConsole) then
          begin
            FrmConsole.GroupJoinViaLink(PLinkGroup);
          end;
        end);

      end);

  lThread.FreeOnTerminate := true;
  lThread.Start;
end;

procedure TInject.groupLeave(PIDGroup: string);
var
  lThread : TThread;
begin
  If Application.Terminated Then
     Exit;

  if not Assigned(FrmConsole) then
     Exit;

  if Trim(PIDGroup) = '' then
  begin
    Int_OnErroInterno(Self, MSG_WarningNothingtoSend, PIDGroup);
    Exit;
  end;

  lThread := TThread.CreateAnonymousThread(procedure
      begin
        TThread.Synchronize(nil, procedure
        begin
          if Assigned(FrmConsole) then
          begin
            FrmConsole.GroupLeave(PIDGroup);
          end;
        end);

      end);

  lThread.FreeOnTerminate := true;
  lThread.Start;
end;

procedure TInject.GroupPromoteParticipant(PIDGroup, PNumber: string);
var
  lThread : TThread;
begin
  If Application.Terminated Then
     Exit;

  if not Assigned(FrmConsole) then
     Exit;

  PNumber := AjustNumber.FormatIn(PNumber);

  if pos('@', PNumber) = 0 then
  Begin
    Int_OnErroInterno(Self, MSG_ExceptPhoneNumberError, PNumber);
    Exit;
  end;

  lThread := TThread.CreateAnonymousThread(procedure
      begin
        TThread.Synchronize(nil, procedure
        begin
          if Assigned(FrmConsole) then
          begin
            FrmConsole.GroupPromoteParticipant(PIDGroup, PNumber);
          end;
        end);

      end);

  lThread.FreeOnTerminate := true;
  lThread.Start;
end;

procedure TInject.GroupRemoveParticipant(PIDGroup, PNumber: string);
var
  lThread : TThread;
begin
  If Application.Terminated Then
     Exit;

  if not Assigned(FrmConsole) then
     Exit;

  PNumber := AjustNumber.FormatIn(PNumber);

  if pos('@', PNumber) = 0 then
  Begin
    Int_OnErroInterno(Self, MSG_ExceptPhoneNumberError, PNumber);
    Exit;
  end;

  lThread := TThread.CreateAnonymousThread(procedure
      begin
        TThread.Synchronize(nil, procedure
        begin
          if Assigned(FrmConsole) then
          begin
            FrmConsole.GroupRemoveParticipant(PIDGroup, PNumber);
          end;
        end);

      end);

  lThread.FreeOnTerminate := true;
  lThread.Start;
end;

procedure TInject.SetProfileName(vName: String);
begin
   If Application.Terminated Then
     Exit;

  if not Assigned(FrmConsole) then
     Exit;

  FrmConsole.setNewName(vName);

end;

procedure TInject.SetStatus(vStatus: String);
begin
   If Application.Terminated Then
     Exit;

  if not Assigned(FrmConsole) then
     Exit;

  FrmConsole.setNewStatus(vStatus);
end;

procedure TInject.GetMe();
begin
   If Application.Terminated Then
     Exit;

  if not Assigned(FrmConsole) then
     Exit;

  FrmConsole.fGetMe();
end;

procedure TInject.GetStatusContact(PNumber : String);
begin
   If Application.Terminated Then
     Exit;

  if not Assigned(FrmConsole) then
     Exit;


  PNumber := AjustNumber.FormatIn(PNumber);

  if pos('@', PNumber) = 0 then
  Begin
    Int_OnErroInterno(Self, MSG_ExceptPhoneNumberError, PNumber);
    Exit;
  end;

  FrmConsole.getStatus(PNumber);
end;

procedure Tinject.GetGroupInviteLink(PIDGroup : string);
begin
  If Application.Terminated Then
     Exit;

  if not Assigned(FrmConsole) then
     Exit;

  if Trim(PIDGroup) = '' then
  begin
    Int_OnErroInterno(Self, MSG_WarningNothingtoSend, PIDGroup);
    Exit;
  end;

  FrmConsole.getGroupInviteLink(PIDGroup);
end;

procedure TInject.GroupRemoveInviteLink(PIDGroup: string);
var
  lThread : TThread;
begin
  If Application.Terminated Then
     Exit;

  if not Assigned(FrmConsole) then
     Exit;

  if Trim(PIDGroup) = '' then
  begin
    Int_OnErroInterno(Self, MSG_WarningNothingtoSend, PIDGroup);
    Exit;
  end;

  lThread := TThread.CreateAnonymousThread(procedure
      begin
        TThread.Synchronize(nil, procedure
        begin
          if Assigned(FrmConsole) then
          begin
            FrmConsole.revokeGroupInviteLink(PIDGroup);
          end;
        end);

      end);

  lThread.FreeOnTerminate := true;
  lThread.Start;
end;

procedure TInject.CleanALLChat(PNumber : String);
begin
   If Application.Terminated Then
     Exit;

  if not Assigned(FrmConsole) then
     Exit;


  PNumber := AjustNumber.FormatIn(PNumber);

  if pos('@', PNumber) = 0 then
  Begin
    Int_OnErroInterno(Self, MSG_ExceptPhoneNumberError, PNumber);
    Exit;
  end;

  FrmConsole.CleanChat(PNumber);
end;

procedure TInject.Int_OnErroInterno(Sender : TObject; Const PError: String; Const PInfoAdc:String);
begin
  if Assigned(FOnErroInternal) then
     FOnErroInternal(Sender, PError, PInfoAdc);
end;

procedure TInject.Int_OnUpdateJS(Sender: TObject);
begin
  if Assigned(FOnUpdateJS) then
     FOnUpdateJS(Self);
end;

procedure TInject.LimparQrCodeInterno;
var
  ltmp: TResultQRCodeClass;
begin
  if not Assigned(FOnGetQrCode) then     Exit;

  ltmp:= TResultQRCodeClass.Create(FrmConsole_JS_RetornoVazio);
  Try
    FOnGetQrCode(self, ltmp);
  Finally
    FreeAndNil(ltmp);
  end;
end;

procedure TInject.listGroupContacts(PIDGroup: string);
var
  lThread : TThread;
begin
  If Application.Terminated Then
     Exit;

  if not Assigned(FrmConsole) then
     Exit;

  if Trim(PIDGroup) = '' then
  begin
    Int_OnErroInterno(Self, MSG_WarningNothingtoSend, PIDGroup);
    Exit;
  end;

  lThread := TThread.CreateAnonymousThread(procedure
      begin
        TThread.Synchronize(nil, procedure
        begin
          if Assigned(FrmConsole) then
          begin
            FrmConsole.listGroupContacts(PIDGroup);
            FrmConsole.listGroupAdmins(PIDGroup);
          end;
        end);

      end);

  lThread.FreeOnTerminate := true;
  lThread.Start;

end;

procedure TInject.Loaded;
begin
  inherited;
  if (csDesigning in ComponentState) then
     Exit;

  if Config.AutoStart then
     FormQrCodeStart(False);
end;

procedure TInject.Logtout;
var
  lThread : TThread;
begin
  If Application.Terminated Then
     Exit;
  if not Assigned(FrmConsole) then
     Exit;

  lThread := TThread.CreateAnonymousThread(procedure
      begin
        TThread.Synchronize(nil, procedure
        begin
          if Assigned(FrmConsole) then
          begin
            FrmConsole.Logout();
          end;
        end);

      end);

  lThread.FreeOnTerminate := true;
  lThread.Start;
end;

procedure TInject.Int_OnNotificationCenter(PTypeHeader: TTypeHeader; PValue: String; Const PReturnClass : TObject);
begin
  {###########################  ###########################}
  if (PTypeHeader In [Th_AlterConfig]) then
  Begin
    if not Assigned(FrmConsole) then
       Exit;

    FrmConsole.SetZoom(Config.Zoom);
    exit;
  end;


  if (PTypeHeader In [Th_GetCheckIsValidNumber]) then
  Begin
    if not Assigned(FrmConsole) then
       Exit;

    if not Assigned(FOnGetCheckIsValidNumber) then
       Exit;


    FOnGetCheckIsValidNumber(Self,
                             TResponseCheckIsValidNumber(PReturnClass).Number,
                             TResponseCheckIsValidNumber(PReturnClass).result
                             );
    exit;
  end;



  if (PTypeHeader In [Th_GetProfilePicThumb]) then
  Begin
    if not Assigned(FrmConsole) then
       Exit;

    if not Assigned(FOnGetProfilePicThumb) then
       Exit;


    FOnGetProfilePicThumb(Self,
                          TResponseGetProfilePicThumb(PReturnClass).Base64);
    exit;
  end;


  if (PTypeHeader In [Th_GetAllChats, Th_getUnreadMessages, Th_getUnreadMessagesFromMe]) then
  Begin
    if not Assigned(PReturnClass) then
      raise Exception.Create(MSG_ExceptMisc + ' in Int_OnNotificationCenter' );

    If PTypeHeader = Th_GetAllChats Then
    Begin
      if Assigned(OnGetChatList) then
         OnGetChatList(TChatList(PReturnClass));
    end;

    If PTypeHeader = Th_getUnreadMessages Then
    Begin
      if Assigned(OnGetUnReadMessages) then
         OnGetUnReadMessages(TChatList(PReturnClass));

    end;

    If PTypeHeader = Th_getUnreadMessagesFromMe Then
    Begin
      if Assigned(OnGetUnReadMessagesFromMe) then
         OnGetUnReadMessagesFromMe(TChatList(PReturnClass));

    end;

    Exit;
  end;


  if PTypeHeader in [Th_ConnectedDown] then
  Begin
    FStatus := Server_ConnectedDown;
    if Assigned(fOnGetStatus ) then
       fOnGetStatus(Self);
    Disconnect;
    exit;
  end;


  if PTypeHeader in [Th_ForceDisconnect] then
  Begin
    if Assigned(FOnDisconnectedBrute) then
       FOnDisconnectedBrute(Self);
    Disconnect;
    exit;
  end;


  if PTypeHeader = Th_Initialized then
  Begin
    FStatus := Inject_Initialized;

    if Assigned(FOnAfterInitialize) then
       FOnAfterInitialize(Self);

    if Assigned(fOnGetStatus ) then
      fOnGetStatus(Self);
  end;


  if PTypeHeader = Th_Initializing then
  begin
    if not Assigned(FrmConsole) then
       Exit;

    FrmConsole.GetMyNumber;
    SleepNoFreeze(40);

    FrmConsole.GetAllContacts(true);
    if Assigned(fOnGetStatus ) then
       fOnGetStatus(Self);
    Exit;
  end;

  if PTypeHeader = Th_getAllGroups then
  Begin
    if Assigned(FOnGetAllGroupList) then
      FOnGetAllGroupList(TRetornoAllGroups(PReturnClass))
  end;

  if PTypeHeader = Th_getAllGroupAdmins then
  Begin
    if Assigned(FOnGetAllGroupAdmins) then
      FOnGetAllGroupAdmins(TRetornoAllGroupAdmins(PReturnClass))
  end;

  //Mike 03/06/2020
  If PTypeHeader = Th_getAllGroupContacts Then
  Begin
    if Assigned(OnGetAllGroupContacts) then
       OnGetAllGroupContacts(TClassAllGroupContacts(PReturnClass));
  end;


  if PTypeHeader = Th_getMyNumber then
  Begin
    FMyNumber := FAdjustNumber.FormatOut(PValue);
    if Assigned(FOnGetMyNumber) then
    begin
       FOnGetMyNumber(Self);
    end;
  end;


  //Mike 29/12/2020
  if PTypeHeader = Th_getIsDelivered then
  Begin
    FIsDelivered := FAdjustNumber.FormatOut(PValue);
    if Assigned(FOnGetIsDelivered) then
       FOnGetIsDelivered(Self);
  end;


  if PTypeHeader = Th_GetStatusMessage then
  Begin
   if Assigned(FOnGetStatusMessage) then
       FOnGetStatusMessage(TResponseStatusMessage(PReturnClass));
  end;

  if PTypeHeader = Th_GetMe  then
  begin
    if Assigned(FOnGetMe) then
       FOnGetMe(TGetMeClass(PReturnClass));
  end;

  if PTypeHeader = Th_NewCheckIsValidNumber  then
  begin
    if Assigned(FOnNewCheckNumber) then
       FOnNewCheckNumber(TReturnCheckNumber(PReturnClass));
  end;

  if PTypeHeader = Th_GetIncomingCall  then
  begin
    if Assigned(FOnGetIncomingCall) then
       FOnGetIncomingCall(TReturnIncomingCall(PReturnClass));
  end;


  if PTypeHeader = Th_GetBatteryLevel then
  Begin
    FGetBatteryLevel :=  StrToIntDef(PValue, -1);
    if Assigned(FOnLowBattery) then
    Begin
      if FGetBatteryLevel <= Config.LowBatteryIs Then
      Begin
        FOnLowBattery(Self);
      end else
      Begin
        if Assigned(fOnGetBatteryLevel) then
           fOnGetBatteryLevel(Self);
      end;
    end;
    Exit;
  end;


  if (PTypeHeader In [Th_GetCheckIsConnected]) then
  Begin
    if not Assigned(FrmConsole) then
       Exit;

    if not Assigned(FOnGetCheckIsConnected) then
       Exit;

    FOnGetCheckIsConnected(Self,
                             TResponseCheckIsConnected(PReturnClass).result
                             );
    exit;
  end;


  if PTypeHeader in [Th_Connected, Th_Disconnected]  then
  Begin
    if PTypeHeader = Th_Connected then
    begin
       SetAuth(True);
    end else
      begin
        SetAuth(False);
        LimparQrCodeInterno;
        Exit;
      end;
  end;


  if PTypeHeader in [Th_Abort]  then
  Begin
    Fstatus     := Server_Disconnected;
    if Assigned(fOnGetStatus) then
       fOnGetStatus(Self);
    Exit;
  end;


  if PTypeHeader in [Th_Connecting, Th_Disconnecting, Th_ConnectingNoPhone, Th_getQrCodeForm, Th_getQrCodeForm, TH_Destroy, Th_Destroying]  then
  begin
    case PTypeHeader of
      Th_Connecting            : Fstatus := Server_Connecting;
      Th_Disconnecting         : Fstatus := Server_Disconnecting;
      Th_ConnectingNoPhone     : Fstatus := Server_ConnectingNoPhone;
      TH_Destroy               : Fstatus := Inject_Destroy;
      Th_Destroying            : Fstatus := Inject_Destroying;
      Th_ConnectingFt_Desktop,
      Th_getQrCodeForm         : Fstatus := Server_ConnectingReaderCode;
    end;
    if Assigned(fOnGetStatus ) then
       fOnGetStatus(Self);
    Exit;
  end;
end;

procedure TInject.ReadMessages(vID: string);
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

procedure TInject.send(PNumberPhone, PMessage: string; PEtapa: string = '');
var
  lThread : TThread;
begin
  If Application.Terminated Then
     Exit;
  if not Assigned(FrmConsole) then
     Exit;

  PNumberPhone := AjustNumber.FormatIn(PNumberPhone);
  if pos('@', PNumberPhone) = 0 then
  Begin
    Int_OnErroInterno(Self, MSG_ExceptPhoneNumberError, PNumberPhone);
    Exit;
  end;

  if Trim(PMessage) = '' then
  begin
    Int_OnErroInterno(Self, MSG_WarningNothingtoSend, PNumberPhone);
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
            FrmConsole.ReadMessages(PNumberPhone); //Marca como lida a mensagem
            FrmConsole.Send(PNumberPhone, PMessage);
            if PEtapa <> '' then
            begin
              FrmConsole.ReadMessagesAndDelete(PNumberPhone);//Deleta a conversa
            end;
          end;
        end);

      end);
  lThread.FreeOnTerminate := true;
  lThread.Start;
end;

procedure TInject.SendFile(PNumberPhone: string;
  const PFileName: String; PMessage: string = '');
var
  lThread     : TThread;
  LStream     : TMemoryStream;
  LBase64File : TBase64Encoding;
  LExtension  : String;
  LBase64     : String;
begin
  If Application.Terminated Then
     Exit;
  if not Assigned(FrmConsole) then
     Exit;

  LExtension   := LowerCase(Copy(ExtractFileExt(PFileName),2,5));
  PNumberPhone := AjustNumber.FormatIn(PNumberPhone);
  if pos('@', PNumberPhone) = 0 then
  Begin
    Int_OnErroInterno(Self, 'SendFile: ' + MSG_ExceptPhoneNumberError, PNumberPhone);
    Exit;
  end;

  If not FileExists(Trim(PFileName)) then
  begin
    Int_OnErroInterno(Self, 'SendFile: ' + Format(MSG_ExceptPath, [PNumberPhone]), PNumberPhone);
    Exit;
  end;

  LStream     := TMemoryStream.Create;
  LBase64File := TBase64Encoding.Create;

  try
    try
      LStream.LoadFromFile(PFileName);
      if LStream.Size = 0 then
      Begin
        Int_OnErroInterno(Self, 'SendFile: ' + Format(MSG_WarningErrorFile, [PNumberPhone]), PNumberPhone);
        Exit;
      end;

      LStream.Position := 0;
      LBase64      := LBase64File.EncodeBytesToString(LStream.Memory, LStream.Size);
      LBase64      := StrExtFile_Base64Type(PFileName) + LBase64;
    except
      Int_OnErroInterno(Self, 'SendFile: ' + MSG_ExceptMisc, PNumberPhone);
    end;
  finally
    FreeAndNil(LStream);
    FreeAndNil(LBase64File);
  end;

  lThread := TThread.CreateAnonymousThread(procedure
      begin
         if Config.AutoDelay > 0 then
            sleep(random(Config.AutoDelay));

        TThread.Synchronize(nil, procedure
        begin
          if Assigned(FrmConsole) then
          begin
            FrmConsole.ReadMessages(PNumberPhone); //Marca como lida a mensagem
            FrmConsole.sendBase64(LBase64, PNumberPhone, PFileName, PMessage);
            //FrmConsole.sendBase64(PFileName, PNumberPhone, PFileName, PMessage);

          end;
        end);
      end);
  lThread.FreeOnTerminate := true;
  lThread.Start;
end;

procedure TInject.SendLinkPreview(PNumberPhone, PVideoLink, PMessage: string);
var
  lThread : TThread;
begin
  If Application.Terminated Then
     Exit;
  if not Assigned(FrmConsole) then
     Exit;

  PNumberPhone := AjustNumber.FormatIn(PNumberPhone);
  if pos('@', PNumberPhone) = 0 then
  Begin
    Int_OnErroInterno(Self, MSG_ExceptPhoneNumberError, PNumberPhone);
    Exit;
  end;

  if Trim(PMessage) = '' then
  begin
    Int_OnErroInterno(Self, MSG_WarningNothingtoSend, PNumberPhone);
    Exit;
  end;

  if Trim(PVideoLink) = '' then
  begin
    Int_OnErroInterno(Self, MSG_WarningNothingtoSend, PVideoLink);
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
            FrmConsole.ReadMessages(PNumberPhone); //Marca como lida a mensagem
            FrmConsole.sendLinkPreview(PNumberPhone, PVideoLink, PMessage);
          end;
        end);

      end);

  lThread.FreeOnTerminate := true;
  lThread.Start;

end;

procedure TInject.SendLocation(PNumberPhone, PLat, PLng, PName, PAddress: string);
var
  lThread : TThread;
begin
  If Application.Terminated Then
     Exit;
  if not Assigned(FrmConsole) then
     Exit;

  PNumberPhone := AjustNumber.FormatIn(PNumberPhone);
  if pos('@', PNumberPhone) = 0 then
  Begin
    Int_OnErroInterno(Self, MSG_ExceptPhoneNumberError, PNumberPhone);
    Exit;
  end;

//  if Trim(PMessage) = '' then
//  begin
//    Int_OnErroInterno(Self, MSG_WarningNothingtoSend, PNumberPhone);
//    Exit;
//  end;

  if (Trim(PLat) = '') or (Trim(PLng) = '') then
  begin
    Int_OnErroInterno(Self, MSG_WarningNothingtoSend, PLat+PLng);
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
            FrmConsole.ReadMessages(PNumberPhone); //Marca como lida a mensagem
            FrmConsole.sendLocation(PNumberPhone, PLat, PLng, PName, PAddress);
          end;
        end);

      end);

  lThread.FreeOnTerminate := true;
  lThread.Start;

end;

procedure TInject.sendPool(PGroupID, PTitle, PSurvey: string);
var
  lThread : TThread;
begin
  If Application.Terminated Then
     Exit;
  if not Assigned(FrmConsole) then
     Exit;

  PGroupID := AjustNumber.FormatIn(PGroupID);

  if pos('@', PGroupID) = 0 then
  Begin
    Int_OnErroInterno(Self, MSG_ExceptPhoneNumberError, PGroupID);
    Exit;
  end;

  if Trim(PTitle) = '' then
  begin
    Int_OnErroInterno(Self, MSG_WarningNothingtoSend, PTitle);
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
            FrmConsole.sendPool(PGroupID, PTitle, PSurvey);
          end;
        end);

      end);

  lThread.FreeOnTerminate := true;
  lThread.Start;

end;

procedure TInject.sendBase64(Const vBase64: String; vNum: String;  Const vFileName, vMess: string);
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
    Int_OnErroInterno(Self, MSG_ExceptPhoneNumberError, vNum);
    Exit;
  end;

  if (Trim(vBase64) = '') then
  begin
    Int_OnErroInterno(Self, MSG_WarningNothingtoSend, vNum);
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


procedure TInject.SendButtons(phoneNumber, titleText, buttons,
  footerText: string; etapa: string = '');
var
  lThread : TThread;
begin
  If Application.Terminated Then
     Exit;
  if not Assigned(FrmConsole) then
     Exit;

  phoneNumber := AjustNumber.FormatIn(phoneNumber);
  if pos('@', phoneNumber) = 0 then
  Begin
    Int_OnErroInterno(Self, MSG_ExceptPhoneNumberError, phoneNumber);
    Exit;
  end;

  if Trim(titleText) = '' then
  begin
    Int_OnErroInterno(Self, MSG_WarningNothingtoSend, phoneNumber);
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
            FrmConsole.ReadMessages(phoneNumber); //Marca como lida a mensagem
            FrmConsole.SendButtons(phoneNumber, titleText, buttons, footerText);
            if etapa <> '' then
            begin
              FrmConsole.ReadMessagesAndDelete(phoneNumber);//Deleta a conversa
            end;
          end;
        end);

      end);
  lThread.FreeOnTerminate := true;
  lThread.Start;

end;

procedure TInject.SendButtonList(phoneNumber: string; titleText1: string; titleText2: string; titleButton: string; options: string;
  etapa: string = '');
var
  lThread : TThread;
begin
  If Application.Terminated Then
     Exit;
  if not Assigned(FrmConsole) then
     Exit;

  phoneNumber := AjustNumber.FormatIn(phoneNumber);
  if pos('@', phoneNumber) = 0 then
  Begin
    Int_OnErroInterno(Self, MSG_ExceptPhoneNumberError, phoneNumber);
    Exit;
  end;

  if (Trim(titleText1) = '') or  (Trim(titleText2) = '') or (Trim(titleButton) = '') then
  begin
    Int_OnErroInterno(Self, MSG_WarningNothingtoSend, phoneNumber);
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
            FrmConsole.ReadMessages(phoneNumber); //Marca como lida a mensagem
            FrmConsole.SendButtonList(phoneNumber, titleText1, titleText2, titleButton, options);
            if etapa <> '' then
            begin
              FrmConsole.ReadMessagesAndDelete(phoneNumber);//Deleta a conversa
            end;
          end;
        end);

      end);
  lThread.FreeOnTerminate := true;
  lThread.Start;

end;

procedure TInject.SendContact(PPhoneDestiny, PPhoneContact: string; PNameContact: string = '');
var
  lThread : TThread;
begin
  If Application.Terminated Then
     Exit;
  if not Assigned(FrmConsole) then
     Exit;

  PPhoneDestiny := AjustNumber.FormatIn(PPhoneDestiny);

  if (pos('@', PPhoneDestiny) = 0) then
  Begin
    Int_OnErroInterno(Self, MSG_ExceptPhoneNumberError, PPhoneDestiny);
    Exit;
  end;

  if Trim(PPhoneContact) = '' then
  begin
    Int_OnErroInterno(Self, MSG_WarningNothingtoSend, PPhoneContact);
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
            FrmConsole.SendContact(PPhoneDestiny, PPhoneContact, PNameContact);
          end;
        end);

      end);

  lThread.FreeOnTerminate := true;
  lThread.Start;

end;

procedure TInject.SetAuth(const Value: boolean);
begin
  if Value then
  Begin
    If (Fstatus = Server_Connected) = Value Then
       Exit;
  end;

  if (Not (Fstatus = Server_Connected)) and (Value) then
  Begin
    Fstatus := Server_Connected;
    if Assigned(FrmConsole) then
       FrmConsole.FormQrCode.FTimerGetQrCode.Enabled := False;

     if Assigned(FOnConnected) then
         FOnConnected(Self);
  end;

  if ((Fstatus = Server_Connected)) and (not Value) then
  Begin
    Fstatus := Server_Disconnected;
    if Assigned(FrmConsole) then
       FrmConsole.DisConnect;

    if Assigned(FOnDisconnected) then
       FOnDisconnected(Self);
  end;

  if Assigned(OnGetStatus ) then
  Begin
    OnGetStatus(Self);
  end;
end;

procedure TInject.SetdjustNumber(const Value: TInjectAdjusteNumber);
begin
  FAdjustNumber.Assign(Value);
end;

procedure TInject.SetInjectConfig(const Value: TInjectConfig);
begin
  FInjectConfig.Assign(Value);
end;

procedure TInject.SetInjectJS(const Value: TInjectJS);
begin
  FInjectJS.Assign(Value);
end;

procedure TInject.SetLanguageInject(const Value: TLanguageInject);
begin
  FLanguageInject := Value;
  FTranslatorInject.SetTranslator(Value);
end;

procedure TInject.SetOnLowBattery(const Value: TNotifyEvent);
begin
  FOnLowBattery := Value;
  if Assigned(FrmConsole) then
     FrmConsole.MonitorLowBattry := Assigned(FOnLowBattery);
end;

procedure TInject.SetQrCodeStyle(const Value: TFormQrCodeType);
begin
  if FFormQrCodeType = Value Then
     Exit;

  if (Status = Inject_Initialized) then
     raise Exception.Create(MSG_ExceptOnAlterQrCodeStyle);
  try
    LimparQrCodeInterno;
    if Assigned(FrmConsole) then
       FrmConsole.StopWebBrowser;
  finally
    FFormQrCodeType := Value;
    Fstatus      := Server_Disconnected;
  end;
end;

procedure  TInject.Disconnect;
Var
  Ltime  : Cardinal;
  LForced: Boolean;
begin
  If Status In [Server_Disconnecting, Inject_Destroying] Then
     raise Exception.Create(MSG_WarningClosing);

  if FDestruido then
     Exit;

  FDestruido := true;
  Ltime      := GetTickCount;
  if Assigned(FrmConsole) then
  Begin
    LForced:= False;
    PostMessage(FrmConsole.Handle, FrmConsole_Browser_Direto, 0, 0);
    Repeat
      SleepNoFreeze(10);
      //Time OutLimite para o componente FORCAR a finalizacao
      if ((GetTickCount - Ltime) >= 6000) and (Not LForced) and (Status <> Inject_Destroy)  then
      Begin
         LForced := true;
         FrmConsole.CEFSentinel1.Start;
         SleepNoFreeze(1000);
         FrmConsole.Chromium1.ShutdownDragAndDrop;
         PostMessage(FrmConsole.Handle, CEF_DESTROY, 0, 0);
      end
    Until Status = Inject_Destroy;
  end;

  //Tempo exigido pelo CEF para pder finalizar sem AV
  FDestroyTmr.Enabled := True;
end;


function TInject.TestConnect: Boolean;
begin
  Result := (Fstatus = Inject_Initialized);
end;

function TInject.GetAppShowing: Boolean;
var
  lForm: Tform;
begin
  Result := False;
  lForm  := nil;
  try
    try
      case FFormQrCodeType of
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

procedure TInject.SetAppShowing(const Value: Boolean);
var
  lForm: Tform;
begin
  lForm := Nil;
  try
    case FFormQrCodeType of
      Ft_None    : Begin
                     if Status = Inject_Initialized then
                        lForm := FrmConsole;
                   end;

      Ft_Desktop : lForm := FrmConsole.FormQrCode;
      Ft_Http    : lForm := FrmConsole;
    end;
  finally
    if Assigned(lForm) then
    Begin
      if lForm is  TFrmQRCode then
         TFrmQRCode(lForm).ShowForm(FFormQrCodeType) else
         lForm.Show;
    end else
    Begin
      if FFormQrCodeType <> Ft_None then
         raise Exception.Create(MSG_ExceptMisc);
    end;
  end;
end;

Procedure TInject.OnCLoseFrmInt(Sender: TObject; var CanClose: Boolean);
Begin
  CanClose := Fstatus = Inject_Destroy;
end;

procedure TInject.OnDestroyConsole(Sender: TObject);
begin
  FDestroyTmr.Enabled := False;
  try
    if Assigned  (FrmConsole) then
       FrmConsole := Nil;
  except
  end;
end;

procedure TInject.ShutDown(PWarning:Boolean);
Var
  LForm  : Tform;
  LPanel1: Tpanel;
  LAbel1 : TLabel;
  LActivityIndicator1: TActivityIndicator;
begin
  if PWarning then
  Begin
    if MessageDlg(Text_FrmClose_WarningClose, mtConfirmation, [mbYes, mbNo], 0) <> mrYes then
       Abort;
  end;


  LForm := Tform.Create(Nil);
  try
    LForm.BorderStyle                 := bsDialog;
    LForm.BorderIcons                 := [biMinimize,biMaximize];
    LForm.FormStyle                   := fsStayOnTop;
    LForm.Caption                     := Text_FrmClose_Caption;
    LForm.Height                      := 124;
    LForm.Width                       := 298;
    LForm.Position                    := poScreenCenter;
    LForm.Visible                     := False;
    LForm.OnCloseQuery                := OnCLoseFrmInt;

    LPanel1                           := Tpanel.Create(LForm);
    LPanel1.Parent                    := LForm;
    LPanel1.ShowCaption               := False;
    LPanel1.BevelOuter                := bvNone;
    LPanel1.Width                     := 81;
    LPanel1.Align                     := alLeft;

    LActivityIndicator1               := TActivityIndicator.Create(LPanel1);
    LActivityIndicator1.Parent        := LPanel1;
    LActivityIndicator1.IndicatorSize := aisXLarge;
    LActivityIndicator1.Animate       := True;
    LActivityIndicator1.Left          := (LPanel1.Width  - LActivityIndicator1.Width)  div 2;
    LActivityIndicator1.Top           := (LPanel1.Height - LActivityIndicator1.Height) div 2;

    LAbel1                            := TLabel.Create(LForm);
    LAbel1.Parent                     := LForm;
    LAbel1.Align                      := alClient;
    LAbel1.Alignment                  := taCenter;
    LAbel1.Layout                     := tlCenter;
    LAbel1.Font.Size                  := 10;
    LAbel1.WordWrap                   := True;
    LAbel1.Caption                    := Text_FrmClose_Label;
    LAbel1.AlignWithMargins           := true;
    LForm.Visible                     := True;

//    Causando problema no FMX
//    {$IFDEF HAS_VCL}
//    Application.MainForm.Visible      := False;
//    {$ENDIF}

    LForm.Show;

    Disconnect;
    LForm.close;
  finally
    if assigned(LForm) then
      FreeAndNil(LForm);
    sleepNoFreeze(5000);
    if assigned(GlobalCEFApp) then
      FreeAndNil(GlobalCEFApp);
    sleepNoFreeze(5000);
    try
      if CallTerminateProcs then PostQuitMessage(0);
    except
    end
  end
end;

procedure TInject.FormQrCodeReloader;
begin
  if not Assigned(FrmConsole) then
     Exit;

  FrmConsole.ReloaderWeb;
end;


procedure TInject.FormQrCodeStart(PViewForm: Boolean);
var
   LState: Boolean;
begin
  if Application.Terminated Then
     Exit;
  LState := Assigned(FrmConsole);

  if Status in [Inject_Destroying, Server_Disconnecting] then
  begin
    Application.MessageBox(PWideChar(MSG_WarningQrCodeStart1), PWideChar(Application.Title), MB_ICONERROR + mb_ok);
    Exit;
  end;

  if Status in [Server_Disconnected, Inject_Destroy] then
  begin
    if not ConsolePronto then
    begin
      Application.MessageBox(PWideChar(MSG_ConfigCEF_ExceptConsoleNaoPronto), PWideChar(Application.Title), MB_ICONERROR + mb_ok);
      Exit;
    end;
    //Reseta o FORMULARIO
    if LState Then
       FormQrCodeReloader;
  end else
    begin
      //Ja esta logado. chamou apenas por chamar ou porque nao esta visivel..
      PViewForm :=true
    end;

  //Faz uma parada forçada para que tudo seja concluido
  SleepNoFreeze(30);
  FrmConsole.StartQrCode(FormQrCodeType, PViewForm);
end;

procedure TInject.FormQrCodeStop;
begin
  if not Assigned(FrmConsole) then
     Exit;

  FrmConsole.StopQrCode(FormQrCodeType);
end;


function TInject.StatusToStr: String;
begin
  case Fstatus of
    Inject_Initialized         : Result := Text_Status_Serv_Initialized;
    Inject_Initializing        : Result := Text_Status_Serv_Initializing;
    Server_Disconnected        : Result := Text_Status_Serv_Disconnected;
    Server_Disconnecting       : Result := Text_Status_Serv_Disconnecting;
    Server_Connected           : Result := Text_Status_Serv_Connected;
    Server_ConnectedDown       : Result := Text_Status_Serv_ConnectedDown;
    Server_Connecting          : Result := Text_Status_Serv_Connecting;
    Server_ConnectingNoPhone   : Result := Text_Status_Serv_ConnectingNoPhone;
    Server_ConnectingReaderCode: Result := Text_Status_Serv_ConnectingReaderQR;
    Server_TimeOut             : Result := Text_Status_Serv_TimeOut;
    Inject_Destroying          : Result := Text_Status_Serv_Destroying;
    Inject_Destroy             : Result := Text_Status_Serv_Destroy;
  end;
end;


end.
