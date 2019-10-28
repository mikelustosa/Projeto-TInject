//TInject Criado por Mike W. Lustosa
//Códido aberto à comunidade Delphi
//mikelustosa@gmail.com

unit uTInject;

interface

uses
  System.SysUtils, System.Classes, Vcl.Forms, Vcl.Dialogs, UBase64, uClasses;

  var
    vDelay: integer;
    FActivityDialogThread: TThread;
type

  TMySubComp = class(TComponent)

  public
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
    FOnGetContactList: TNotifyEvent;
    FContacts: String;
    FMySubComp1: TMySubComp;
  public
    constructor Create(AOwner: TComponent); override;
    procedure startWhatsapp();
    procedure send(vNum, vMess: string);
    procedure sendBase64(vBase64, vNum, vFileName, vMess: string);
    procedure fileToBase64(vFile: string);
    function GetContacts: String;
    function GetUnReadMessages: String;
    property AllContacts: TRetornoAllContacts read FAllContacts write FAllContacts;
  published
    { Published declarations }
    property Config: TMySubComp read FMySubComp1;
    property OnGetContactList: TNotifyEvent read FOnGetContactList write FOnGetContactList;
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
end;

procedure TInjectWhatsapp.fileToBase64(vFile: string);
begin
  uBase64.FileToBase64(vFile);
end;

function TInjectWhatsapp.GetContacts: String;
begin
  FActivityDialogThread := TThread.CreateAnonymousThread(procedure
      var vGetDelay: integer;
      begin
        try

          vGetDelay := random(vDelay);

          sleep(vGetDelay);

          TThread.Synchronize(nil, procedure
          begin
            if Assigned(frm_autenticaWhats) then
            begin
              frm_servicesWhats.GetContacts;
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
  FActivityDialogThread.FreeOnTerminate := False;
  FActivityDialogThread.Start;
end;

function TInjectWhatsapp.GetUnReadMessages: String;
begin
  FActivityDialogThread := TThread.CreateAnonymousThread(procedure
      var vGetDelay: integer;
      begin
        try

          vGetDelay := random(vDelay);

          sleep(vGetDelay);

          TThread.Synchronize(nil, procedure
          begin
            if Assigned(frm_autenticaWhats) then
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
  FActivityDialogThread.FreeOnTerminate := False;
  FActivityDialogThread.Start;
end;

procedure TInjectWhatsapp.send(vNum, vMess: string);
begin
  inherited;
  FActivityDialogThread := TThread.CreateAnonymousThread(procedure
      var vGetDelay: integer;
      begin
        try

          vGetDelay := random(vDelay);

          sleep(vGetDelay);

          TThread.Synchronize(nil, procedure
          begin
            if Assigned(frm_autenticaWhats) then
            begin
              frm_servicesWhats.Send('55'+vNum+'@c.us', vMess);
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
  FActivityDialogThread.FreeOnTerminate := False;
  FActivityDialogThread.Start;
end;

procedure TInjectWhatsapp.sendBase64(vBase64, vNum, vFileName, vMess: string);
begin
  inherited;
  FActivityDialogThread := TThread.CreateAnonymousThread(procedure
      var vGetDelay: integer;
      begin
        try
          vGetDelay := random(vDelay);
          sleep(vGetDelay);

          TThread.Synchronize(nil, procedure
          begin
            if Assigned(frm_autenticaWhats) then
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
  FActivityDialogThread.FreeOnTerminate := False;
  FActivityDialogThread.Start;
end;

procedure TInjectWhatsapp.startWhatsapp;
begin
  if not Assigned(frm_servicesWhats) then
  begin
   frm_servicesWhats       := Tfrm_servicesWhats.Create(self);
   frm_servicesWhats._inject := Self;
   frm_servicesWhats.Show;
  end else
  begin
    frm_servicesWhats.Show;
  end;
end;

end.

