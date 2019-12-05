//TInject Criado por Mike W. Lustosa
//Códido aberto à comunidade Delphi
//mikelustosa@gmail.com


unit uTInject;

interface

uses
  System.SysUtils, System.Classes, Vcl.Forms, Vcl.Dialogs, UBase64, uClasses, u_view_qrcode,  System.MaskUtils,
  uTInject.Emoticons;

Const
  TInjectVersion = '1.0.0.10'; //  04/12/2019  //Alterado por Daniel Rodrigues
  CardContact   = '@c.us';
  CardGroup     = '@g.us';

{
###########################################################################################
                                    EVOLUÇÃO
###########################################################################################
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
  TTypeNumber        = (TypUndefined=0, TypContact=1, TypGroup=2);

  TAjustNumber  = class(TComponent)
  private
    FLastAdjustDt: TDateTime;
    FLastAdjuste: String;
    FLastDDI: String;
    FLastDDD: String;
    FLastNumber: String;

    FAutoAdjust: Boolean;
    FDDIDefault: Integer;
    FLengthDDI: integer;
    FLengthDDD: Integer;
    FLengthPhone: Integer;
    FLastNumberFormat: String;
    FLastType: TTypeNumber;
    Procedure SetPhone(Const Pnumero:String);
  public
    constructor Create(AOwner: TComponent); override;

    Function  Format(PNum:String): String;
    property  LastType: TTypeNumber     Read FLastType;
    property  LastAdjuste : String      Read FLastAdjuste;
    property  LastDDI     : String      Read FLastDDI;
    property  LastDDD     : String      Read FLastDDD;
    property  LastNumber  : String      Read FLastNumber;
    property  LastNumberFormat: String  Read FLastNumberFormat;
    property  LastAdjustDt: TDateTime   Read FLastAdjustDt;
  published
    property AutoAdjust : Boolean   read FAutoAdjust   write FAutoAdjust default True;

    property LengthDDI  : Integer   read FLengthDDI    write FLengthDDI   default 2;
    property LengthDDD  : Integer   read FLengthDDD    write FLengthDDD   default 2;
    property LengthPhone: Integer   read FLengthPhone  write FLengthPhone default 9;
    property DDIDefault : Integer   read FDDIDefault   write FDDIDefault  Default 2;
  end;



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
    FMySubComp1           : TMySubComp;
    FAjustNumber          : TAjustNumber;
    FEmoticons            : TInjectEmoticons;

    FAllContacts          : TRetornoAllContacts;
    FAllChats             : TChatList;
    FQrCodeClass          : TQrCodeClass;

    FVersaoIde            : String;
    FGetBatteryLevel      : string;
//    FContacts             : String;
    FAuth                 : Boolean;
    FMonitoring           : Boolean;

    { Private declarations }
    procedure SetAuth(const Value: boolean);
  protected
    { Protected declarations }
    FOnGetUnReadMessages  : TGetUnReadMessages;
    FBatteryLevel         : TNotifyEvent;
    FOnGetQrCode          : TNotifyEvent;
    FOnGetChatList        : TNotifyEvent;
    FOnGetNewMessage      : TNotifyEvent;
    FOnGetBatteryLevel    : TNotifyEvent;
    FOnGetStatus          : TNotifyEvent;

  public
    AGetBatteryLevel               : string;
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

    Property Emoticons : TInjectEmoticons     Read  FEmoticons   Write FEmoticons;
    property AllContacts: TRetornoAllContacts read FAllContacts  write FAllContacts;
    property BatteryLevel: TNotifyEvent       read FBatteryLevel write FBatteryLevel;
    property AQrCode: TQrCodeClass            read FQrCodeClass  write FQrCodeClass;
    property AllChats: TChatList              read FAllChats     write FAllChats;
    property Auth: boolean                    read FAuth         write SetAuth;
    property Monitoring: Boolean              read FMonitoring   default False;
  published
    { Published declarations }
    property Config               : TMySubComp   read FMySubComp1;
    property AjustNumber          : TAjustNumber read FAjustNumber;
    property OnGetContactList     : TNotifyEvent read FBatteryLevel      write FBatteryLevel;
    property OnGetQrCode          : TNotifyEvent read FOnGetQrCode       write FOnGetQrCode;
    property OnGetChatList        : TNotifyEvent read FOnGetChatList     write FOnGetChatList;
    property OnGetNewMessage      : TNotifyEvent read FOnGetNewMessage   write FOnGetNewMessage;
    property OnGetUnReadMessages  : TGetUnReadMessages read FOnGetUnReadMessages write FOnGetUnReadMessages;
    property OnGetStatus          : TNotifyEvent read FOnGetStatus       write FOnGetStatus;
    property OnGetBatteryLevel    : TNotifyEvent read FOnGetBatteryLevel write FOnGetBatteryLevel;
    Property VersaoIDE            : String       Read FVersaoIde;
    property ABatteryLevel        : string       Read FGetBatteryLevel;
  end;


procedure Register;

implementation

uses
  u_servicesWhats;

procedure Register;
begin
  RegisterComponents('TInjectWhatsapp', [TInjectWhatsapp]);
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
  FVersaoIde                 := TInjectVersion;
  FMySubComp1                := TMySubComp.Create(self);
  FMySubComp1.Name           := 'AutoInject';
  FMySubComp1.AutoDelay      := 1000;
  FMySubComp1.SecondsMonitor := 3;
  FMySubComp1.AutoMonitor    := True;
  FMySubComp1.SetSubComponent(true);

  FAjustNumber               := TAjustNumber.Create(self);
  FAjustNumber.Name          := 'AjustNumber';
  FAjustNumber.SetSubComponent(true);

  if Config.AutoStart then
     startWhatsapp;
end;

destructor TInjectWhatsapp.Destroy;
begin
  FreeAndNil(frm_servicesWhats);
  FreeAndNil(frm_view_qrcode);
  FreeAndNil(FAjustNumber);

  FreeAndNil(FQrCodeClass);
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
  Result := False;
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
  lThread : TThread;
begin
  vNum := AjustNumber.Format(vNum);
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
  vNum := AjustNumber.Format(vNum);
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

{ TAjustNumber }

function TAjustNumber.Format(PNum: String): String;
var
  LClearNum: String;
  i: Integer;
begin
  Result := Pnum;
  try
    if not AutoAdjust then
       Exit;

    //Garante valores LIMPOS (sem mascaras, letras, etc) apenas NUMEROS
    Result := PNum;
    for I := 1 to Length(PNum) do
    begin
//      if PNum[I] in ['0'..'9'] then
      if  (CharInSet(PNum[I] ,['0'..'9'])) Then
          LClearNum := LClearNum + PNum[I];
    end;

    //O requisito minimo é possuir DDD + NUMERO (Fone 8 ou 9 digitos)
    //  if Length(LClearNum) < 10 then
    if Length(LClearNum) < (LengthDDD + LengthPhone) then
    Begin
      Result := '';
      Exit;
    End;

    //Testa se é um grupo ou Lista Transmissao
    if Length(LClearNum) <=  (LengthDDI + LengthDDD + LengthPhone + 1) Then //14 then
    begin
      if (Length(LClearNum) <= (LengthDDD + LengthPhone)) or (Length(PNum) <= (LengthDDD + LengthPhone)) then
      begin
        if Copy(LClearNum, 0, LengthDDI) <> DDIDefault.ToString then
           LClearNum := DDIDefault.ToString + LClearNum;
        Result := LClearNum +  CardContact;
      end;
    end;
  finally
    if Result = '' then
       raise Exception.Create('Número inválido');
    SetPhone(Result);
  end;
end;


procedure TAjustNumber.SetPhone(const Pnumero: String);
begin
  FLastType         := TypUndefined;
  FLastDDI          := '';
  FLastDDD          := '';
  FLastNumber       := '';
  FLastNumberFormat := '';
  FLastAdjustDt     := Now;
  FLastAdjuste      := Pnumero;
  FLastNumberFormat := Pnumero;
  if pos(CardGroup, Pnumero) > 0 then
  begin
    FLastType := TypGroup;
  end else
  Begin
    if Length(Pnumero) = (LengthDDI + LengthDDD + LengthPhone + Length(CardContact)) then
       FLastType := TypContact;
  end;

  if FLastType = TypContact then
  Begin
    FLastDDI :=  Copy(Pnumero, 0,           LengthDDI);
    FLastDDD :=  Copy(Pnumero, LengthDDI+1, LengthDDD);
    FLastNumber :=  Copy(Pnumero, LengthDDI+LengthDDD+1, LengthPhone);
    FLastNumberFormat := '+' + FLastDDI + ' (' + FLastDDD + ') ' + FormatMaskText('0\.0000\-0000;0;', FLastNumber)
  End;
end;

constructor TAjustNumber.Create(AOwner: TComponent);
begin
  inherited;
  FLastAdjuste := '';
  FLastDDI     := '';
  FLastDDD     := '';
  FLastNumber  := '';

  FAutoAdjust  := True;
  FDDIDefault  := 55;
  FLengthDDI   := 2;
  FLengthDDD   := 2;
  FLengthPhone := 8;
end;

end.


