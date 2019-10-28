//TInject Criado por Mike W. Lustosa
//Códido aberto à comunidade Delphi
//mikelustosa@gmail.com

unit uTInject;

interface

uses
  System.SysUtils, System.Classes, Vcl.Forms, Vcl.Dialogs, UBase64, uClasses;

  var
    vDelay: integer;
    FActivityContactsThread   : TThread;
    FActivityGetMessagesThread: TThread;
    FActivitySendThread       : TThread;
    FActivitySendBase64Thread : TThread;
type
  {Events}
  TGetUnReadMessages = procedure(Chats: TChatList) of object;

  TMySubComp = class(TComponent)

  public
    FAutoStart: Boolean;
    FAutoInject     :Boolean;
    FAutoDelay      :Integer;
    FSyncContacts   :Boolean;
    FShowRandom     :Boolean;
  private
    procedure SetAutoInject(const Value: Boolean);
    procedure SetAutoDelay(const Value: integer);
    procedure SetSyncContacts(const Value: Boolean);
    procedure SetShowRandom(const Value: Boolean);

  published
    property AutoStart: Boolean read FAutoStart write FAutoStart default False;
    property AutoInject   :Boolean read FAutoInject   write SetAutoInject;
    property AutoDelay    :integer read FAutoDelay    write SetAutoDelay;
    property SyncContacts :Boolean read FSyncContacts write SetSyncContacts;
    property ShowRandom   :Boolean read FShowRandom   write SetShowRandom;
  end;


  TInjectWhatsapp = class(TComponent)
  private
    { Private declarations }
  protected
    { Protected declarations }
    FAllContacts: TRetornoAllContacts;
    FAllChats: TChatList;
    FOnGetContactList : TNotifyEvent;
    FOnGetChatList: TNotifyEvent;
    FOnGetNewMessage  : TNotifyEvent;
    FOnGetUnReadMessages: TGetUnReadMessages;
    FOnGetStatus      : TNotifyEvent;
    FContacts: String;
    FMySubComp1: TMySubComp;
    FAuth: boolean;
  public
    constructor Create(AOwner: TComponent); override;
    procedure startWhatsapp();
    procedure ShowWebApp;
    procedure send(vNum, vMess: string);
    procedure sendBase64(vBase64, vNum, vFileName, vMess: string);
    procedure fileToBase64(vFile: string);
    procedure GetAllContacts;
    procedure GetAllChats;
    function GetStatus: Boolean;
    function GetUnReadMessages: String;
    property AllContacts: TRetornoAllContacts read FAllContacts write FAllContacts;
    property AllChats: TChatList read FAllChats write FAllChats;
    property Auth: boolean read FAuth write FAuth;
  published
    { Published declarations }
    property Config: TMySubComp read FMySubComp1;
    property OnGetContactList: TNotifyEvent read FOnGetContactList write FOnGetContactList;
    property OnGetChatList: TNotifyEvent read FOnGetChatList write FOnGetChatList;
    property OnGetNewMessage: TNotifyEvent read FOnGetNewMessage write FOnGetNewMessage;
    property OnGetUnReadMessages: TGetUnReadMessages read FOnGetUnReadMessages write FOnGetUnReadMessages;
    property OnGetStatus: TNotifyEvent read FOnGetStatus write FOnGetStatus;
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

procedure TMySubComp.SetAutoInject(const Value: Boolean);
begin
  FAutoInject := Value;
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
  FMySubComp1 := TMySubComp.Create(self);
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
//   FActivityStatusThread := TThread.CreateAnonymousThread(procedure
//      var vGetDelay: integer;
//      begin
//        try
//          TThread.Synchronize(nil, procedure
//          begin
//            if Assigned(frm_servicesWhats) then
//            begin
//              frm_servicesWhats.GetStatus;
//            end;
//          end);
//
//          finally
//          begin
//
//          end;
//        end;
//      end);
//  FActivityStatusThread.FreeOnTerminate := False;
//  FActivityStatusThread.Start;
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
  FActivityGetMessagesThread.FreeOnTerminate := False;
  FActivityGetMessagesThread.Start;
end;

procedure TInjectWhatsapp.send(vNum, vMess: string);
var
  AId: String;
begin
  inherited;
  FActivitySendThread := TThread.CreateAnonymousThread(procedure
      var vGetDelay: integer;
      begin
        try

          vGetDelay := random(vDelay);

          sleep(vGetDelay);

          TThread.Synchronize(nil, procedure
          begin
            if Assigned(frm_servicesWhats) then
            begin
              AId := vNum;
              if Pos(vNum,'@') = -1 then
                 AId := '55'+vNum+'@c.us';

              frm_servicesWhats.Send(AId, vMess);
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
  FActivitySendThread.FreeOnTerminate := False;
  FActivitySendThread.Start;
end;

procedure TInjectWhatsapp.sendBase64(vBase64, vNum, vFileName, vMess: string);
begin
  inherited;
  FActivitySendBase64Thread := TThread.CreateAnonymousThread(procedure
      var vGetDelay: integer;
      begin
        try
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

          finally
          begin

          end;
        end;
      end);
  FActivitySendBase64Thread.FreeOnTerminate := False;
  FActivitySendBase64Thread.Start;
end;

procedure TInjectWhatsapp.ShowWebApp;
begin
  startWhatsapp;
  frm_servicesWhats.Show;
end;

procedure TInjectWhatsapp.startWhatsapp;
begin
  if not Assigned(frm_servicesWhats) then
  begin
   frm_servicesWhats         := Tfrm_servicesWhats.Create(self);
   frm_servicesWhats._Inject := Self;
  end;
end;

end.

