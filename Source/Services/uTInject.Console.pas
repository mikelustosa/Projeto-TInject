{####################################################################################################################
                         TINJECT - Componente de comunicação WhatsApp (Não Oficial WhatsApp)
                                           www.tinject.com.br
                                            Novembro de 2019
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
unit uTInject.Console;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.ExtCtrls, StrUtils,

  uCEFWinControl, uCEFChromiumCore,   uCEFTypes,
  uCEFInterfaces, uCEFConstants,      uCEFWindowParent, uCEFChromium,

  //units adicionais obrigatórias
  uTInject.Classes,  uTInject.constant, uTInject.Diversos,


  Vcl.StdCtrls, Vcl.ComCtrls, System.ImageList, Vcl.ImgList, System.JSON,
  Vcl.Buttons, Vcl.Imaging.pngimage, Rest.Json,
  Vcl.Imaging.jpeg, uTInject.ControlSend, uCEFSentinel, uTInject.FrmQRCode;

var
 vContacts :Array of String;


type
  TFrmConsole = class(TForm)
    CEFWindowParent1: TCEFWindowParent;
    Chromium1: TChromium;
    Panel1: TPanel;
    Image2: TImage;
    Image1: TImage;
    Label1: TLabel;
    CEFSentinel1: TCEFSentinel;
    procedure Chromium1AfterCreated(Sender: TObject;      const browser: ICefBrowser);
    procedure Chromium1BeforeClose(Sender: TObject; const browser: ICefBrowser);
    procedure Chromium1BeforePopup(Sender: TObject; const browser: ICefBrowser;
      const frame: ICefFrame; const targetUrl, targetFrameName: ustring;
      targetDisposition: TCefWindowOpenDisposition; userGesture: Boolean;
      const popupFeatures: TCefPopupFeatures; var windowInfo: TCefWindowInfo;
      var client: ICefClient; var settings: TCefBrowserSettings;
      var extra_info: ICefDictionaryValue; var noJavascriptAccess,
      Result: Boolean);
    procedure Chromium1Close(Sender: TObject; const browser: ICefBrowser;
      var aAction: TCefCloseBrowserAction);
    procedure Chromium1LoadEnd(Sender: TObject; const browser: ICefBrowser;
      const frame: ICefFrame; httpStatusCode: Integer);
    procedure Chromium1OpenUrlFromTab(Sender: TObject;
      const browser: ICefBrowser; const frame: ICefFrame;
      const targetUrl: ustring; targetDisposition: TCefWindowOpenDisposition;
      userGesture: Boolean; out Result: Boolean);
    procedure Chromium1TitleChange(Sender: TObject; const browser: ICefBrowser;
      const title: ustring);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Image1Click(Sender: TObject);
    procedure Chromium1ConsoleMessage(Sender: TObject;
      const browser: ICefBrowser; level: Cardinal; const message,
      source: ustring; line: Integer; out Result: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    Procedure ProcessQrCode(Var pClass: TObject);
    procedure Chromium1Jsdialog(Sender: TObject; const browser: ICefBrowser;
      const originUrl: ustring; dialogType: TCefJsDialogType; const messageText,
      defaultPromptText: ustring; const callback: ICefJsDialogCallback;
      out suppressMessage, Result: Boolean);
    procedure Chromium1TextResultAvailable(Sender: TObject;
      const aText: ustring);
    procedure CEFSentinel1Close(Sender: TObject);
  protected
    // You have to handle this two messages to call NotifyMoveOrResizeStarted or some page elements will be misaligned.
    procedure WMMove(var aMessage : TWMMove); message WM_MOVE;
    procedure WMMoving(var aMessage : TMessage); message WM_MOVING;
    // You also have to handle these two messages to set GlobalCEFApp.OsmodalLoop
    procedure WMEnterMenuLoop(var aMessage: TMessage); message WM_ENTERMENULOOP;
    procedure WMExitMenuLoop(var aMessage: TMessage); message WM_EXITMENULOOP;

    procedure BrowserDestroyMsg(var aMessage : TMessage); message CEF_DESTROY;
    Procedure OnTimerMonitoring(Sender: TObject);
    procedure OnTimerConnect(Sender: TObject);
    procedure OnTimerGetQrCode(Sender: TObject);
    Procedure ExecuteCommandConsole(Const PResponse: TResponseConsoleMessage);

  private
    { Private declarations }
    FCanClose       : Boolean;
    FClosing        : Boolean;
    FConectado      : Boolean;
    FTimerConnect   : TTimer;
    FTimerMonitoring: TTimer;
    FOnResultMisc   : TResulttMisc;
    FControlSend    : TControlSend;
    FCountBattery   : Integer;
    FCountBatteryMax: Integer;
    FrmQRCode       : TFrmQRCode;
    FFormType       : TFormQrCodeType;


    FAllContacts : TRetornoAllContacts  ;
    FAQrCode     : TResultQRCodeClass   ;
    FChatList    : TChatList            ;


    Li: integer;
    FMonitorLowBattry: Boolean;
    FOnErrorInternal: TOnErroInternal;
    Function  GetAutoBatteryLeveL: Boolean;
    Procedure ISLoggedin;
    procedure ExecuteJS(PScript: WideString; PCanRepeat: Boolean = false; Purl:String = 'about:blank'; pStartline: integer=0);
    procedure QRCodeForm_Start;
    procedure QRCodeWeb_Start;
  public
    { Public declarations }

    Procedure StartQrCode(PQrCodeType :TFormQrCodeType; PViewForm:Boolean);
    Procedure StopQrCode(PQrCodeType: TFormQrCodeType);

    Property  FormQrCode : TFrmQRCode              Read FrmQRCode;


    property  OnErrorInternal : TOnErroInternal   Read FOnErrorInternal          Write FOnErrorInternal;
    Property  AllContacts : TRetornoAllContacts   Read FAllContacts;
    Property  AQrCode     : TResultQRCodeClass    Read FAQrCode;
    Property  AllChats    : TChatList             Read FChatList;

    Property  MonitorLowBattry : Boolean   Read FMonitorLowBattry  Write FMonitorLowBattry;
    Property  OnResultMisc : TResulttMisc  Read FOnResultMisc      Write FOnResultMisc;
    Procedure Connect;
    Procedure DisConnect;
    procedure Send(vNum, vText:string);
    procedure SendBase64(vBase64, vNum, vFileName, vText:string);

    procedure ReloaderWeb;

    procedure GetAllContacts;
    procedure GetAllChats;
    procedure GetUnreadMessages;
    procedure GetBatteryLevel;
    procedure GetMyNumber;

    //Para monitorar o qrcode via REST
    procedure ReadMessages(vID: string);
    procedure DeleteMessages(vID: string);
    procedure ReadMessagesAndDelete(vID: string);

    procedure StartMonitor(Seconds: Integer);
    procedure StopMonitor;
  end;

var
  FrmConsole: TFrmConsole;

implementation

uses
  System.NetEncoding, Vcl.Dialogs, uTInject.ConfigCEF, uTInject;

{$R *.dfm}

procedure ParseJson(aStringJson : string);
var
  LJsonArr   : TJSONArray;
  LJsonValue : TJSONValue;
  LItem      : TJSONValue;
begin
   LJsonArr    := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(aStringJson),0) as TJSONArray;
   for LJsonValue in LJsonArr do
   begin
     for LItem in TJSONArray(LJsonValue) do
         Writeln(Format('%s : %s',[TJSONPair(LItem).JsonString.Value, TJSONPair(LItem).JsonValue.Value]));
     Writeln;
   end;
end;


procedure TFrmConsole.BrowserDestroyMsg(var aMessage : TMessage);
begin
  CEFWindowParent1.Free;
end;

procedure TFrmConsole.WMMove(var aMessage : TWMMove);
begin
  inherited;
  if (Chromium1 <> nil) then
     Chromium1.NotifyMoveOrResizeStarted;
end;

procedure TFrmConsole.WMMoving(var aMessage : TMessage);
begin
  inherited;
  if (Chromium1 <> nil) then
     Chromium1.NotifyMoveOrResizeStarted;
end;


procedure TFrmConsole.ExecuteJS(PScript: WideString;   PCanRepeat: Boolean;  Purl:String; pStartline: integer);
begin
  if Assigned(GlobalCEFApp) then
  Begin
    if GlobalCEFApp.ErrorInt Then
       Exit;
  end;

  if not FConectado then
     raise Exception.Create(ConfigCEF_ExceptConnetWhats);

  if Chromium1.Browser <> nil then
  begin
     //Testa para saber se esta controlando os envio..
     if TInjectWhatsapp(Owner).Config.ControlSend then
     Begin
       //Mesmo que controle se o comando e do tipo ser ignorado, ele envia igual...
       if (not PCanRepeat) Then
       Begin
         if Assigned(FControlSend) then
         Begin
            if not FControlSend.CanSend(PScript) Then
            Begin
              //Ja enviado
              OnErrorInternal(self, DuplicityDetected, PScript);
              Exit;
            End;
         End;
       End;
     End;

     //Chegou ate aqui é porque pode enviar
     Chromium1.Browser.MainFrame.ExecuteJavaScript(PScript, Purl, pStartline)
  end;
end;

procedure TFrmConsole.QRCodeWeb_Start;
begin
  ExecuteJS(FrmConsole_JS_WEBmonitorQRCode);
end;

procedure TFrmConsole.QRCodeForm_Start;
begin
  ExecuteJS(FrmConsole_JS_monitorQRCode, true);
end;


procedure TFrmConsole.OnTimerConnect(Sender: TObject);
var
  lNovoStatus: Boolean;
begin
  //Rotina para leitura e inject do arquivo js.abr ---- 12/10/2019 Mike
  lNovoStatus            := True;
  FTimerConnect.Enabled  := False;
  try
    If TInjectWhatsapp(oWNER).Status = Whats_Connected then
    Begin
      ExecuteJS(TInjectWhatsapp(Owner).InjectJS.JSScript.Text);
      GetMyNumber;

      //Auto monitorar mensagens não lidas
      StartMonitor(TInjectWhatsapp(Owner).Config.SecondsMonitor);
      lNovoStatus    := False;
    End;
  finally
    FTimerConnect.Enabled := lNovoStatus;
  end;
end;

procedure TFrmConsole.OnTimerGetQrCode(Sender: TObject);
begin
  TTimer(Sender).Enabled := False;
  try
    try
      if (FFormType = Ft_Desktop) Then
        QRCodeForm_Start else
        QRCodeWeb_Start;
    Except
    end;
  finally
    TTimer(Sender).Enabled := True;
  end;
end;

procedure TFrmConsole.OnTimerMonitoring(Sender: TObject);
begin
  //Testa se existe alguma desconexão por parte do aparelho...
  if Application.Terminated then
     Exit;

  FTimerMonitoring.Enabled := False;
  try
    if not TInjectWhatsapp(Owner).Auth then
    begin
      Chromium1.RetrieveHTML;
      Exit;
    end;


    If MonitorLowBattry THen
    Begin
      if GetAutoBatteryLeveL then
         GetBatteryLevel;
    End;


    //Falta implementar isso...]
    ISLoggedin;
  finally
    FTimerMonitoring.Enabled := FConectado;
  end;
end;

procedure TFrmConsole.ProcessQrCode(var pClass: TObject);
begin
   //Retorno do CODIGO QRCODE..
   //Se a janela estiver aberta ele envia a imagem..
  if not (pClass is TQrCodeClass) then
     Exit;

  if (TQR_Http in TQrCodeClass(pClass).Tags) or (TQR_Img in TQrCodeClass(pClass).Tags) then
  Begin
    FrmQRCode.hide;
    Exit;
  End;

  try
   if Assigned(FAQrCode) then
      FreeAndNil(FAQrCode);

    FAQrCode := TResultQRCodeClass(TQrCodeClass(pClass).Result);
    //e difente.. portanto.. verificamos se existe imagem la no form.. se existir caimos fora!! se nao segue o fluxo
    if not FAQrCode.AImageDif then
    Begin
      if FrmQRCode.Timg_QrCode.Picture <> nil Then
         Exit;
    End;

    FrmQRCode.Timg_QrCode.Picture.Assign(FAQrCode.AQrCodeImage);
    FrmQRCode.SetView(FrmQRCode.Timg_QrCode);

    loadWEBQRCode(FAQrCode.AQrCode);
    If Assigned(TInjectWhatsapp(Owner).OnGetQrCode) then
       TInjectWhatsapp(Owner).OnGetQrCode(FAQrCode);
  Except
    FrmQRCode.SetView(FrmQRCode.Timg_Animacao);
    //pode receber um ABORT;
  end;
end;

procedure TFrmConsole.GetAllContacts;
begin
  ExecuteJS(FrmConsole_JS_GetAllContacts);
end;

function TFrmConsole.GetAutoBatteryLeveL: Boolean;
begin
  Result        := False;
  if not FConectado then
     Exit;

  Inc(FCountBattery);
  if FCountBattery >  FCountBatteryMax then
  Begin
    Result        := true;
    FCountBattery := 0;
  End;
end;

procedure TFrmConsole.GetBatteryLevel;
begin
  ExecuteJS(FrmConsole_JS_GetBatteryLevel);
end;

procedure TFrmConsole.GetMyNumber;
begin
  ExecuteJS(FrmConsole_JS_GetMyNumber);
end;

procedure TFrmConsole.GetUnreadMessages;
begin
  ExecuteJS(FrmConsole_JS_GetUnreadMessages);
end;

procedure TFrmConsole.GetAllChats;
begin
  ExecuteJS(FrmConsole_JS_GetAllChats);
end;

procedure TFrmConsole.StartMonitor(Seconds: Integer);
var
  LJS: String;
begin
  LJS := FrmConsole_JS_VAR_StartMonitor;
  ExecuteJS(FrmConsole_JS_AlterVar(LJS, '#TEMPO#' , Seconds.ToString));
end;

procedure TFrmConsole.StartQrCode(PQrCodeType: TFormQrCodeType; PViewForm: Boolean);
begin
  FFormType := PQrCodeType;
  if PQrCodeType = Ft_Http then
  begin
    FrmQRCode.hide;

    If Assigned(OnResultMisc) then
       OnResultMisc(Th_ConnectingFt_HTTP, '');
    QRCodeWeb_Start;
    if PViewForm then
       Show;
  end Else
  Begin
    SleepNoFreeze(30);
    If Assigned(OnResultMisc) then
       OnResultMisc(Th_ConnectingFt_Desktop, '');
    if not FrmQRCode.Showing then
      FrmQRCode.ShowForm;
  end;
end;

procedure TFrmConsole.StopMonitor;
begin
  ExecuteJS(FrmConsole_JS_StopMonitor);
end;

procedure TFrmConsole.StopQrCode(PQrCodeType: TFormQrCodeType);
begin
  FrmQRCode.HIDE;
  if PQrCodeType = Ft_Http then
     DisConnect;
end;

procedure TFrmConsole.ReadMessages(vID: string);
var
  LJS: String;
begin
  LJS := FrmConsole_JS_VAR_ReadMessages;
  ExecuteJS(FrmConsole_JS_AlterVar(LJS, '#MSG_PHONE#' , Trim(vID)));
end;

procedure TFrmConsole.DeleteMessages(vID: string);
var
  LJS: String;
begin
  LJS := FrmConsole_JS_VAR_DeleteMessages;
  ExecuteJS(FrmConsole_JS_AlterVar(LJS, '#MSG_PHONE#', Trim(vID)));
end;

Procedure TFrmConsole.DisConnect;
begin
  try
    if not FConectado then
       Exit;

    GlobalCEFApp.QuitMessageLoop;
    StopMonitor;
    FTimerConnect.Enabled    := False;
    FTimerMonitoring.Enabled := False;

    Chromium1.StopLoad;
    Chromium1.Browser.StopLoad;
    Chromium1.CloseBrowser(True);
  Except

  end;
  FConectado                       := False;
end;

//Marca como lida e deleta a conversa
procedure TFrmConsole.ReadMessagesAndDelete(vID: string);
begin
  ReadMessages  (Trim(vID));
  DeleteMessages(Trim(vID));
end;

procedure TFrmConsole.ReloaderWeb;
begin
  if not FConectado then
     Exit;

  Chromium1.StopLoad;
  Chromium1.Browser.ReloadIgnoreCache;
end;

procedure TFrmConsole.SendBase64(vBase64, vNum, vFileName, vText: string);
var
  Ljs, LLine: string;
  LBase64: TStringList;
  i: integer;
begin
  if not FConectado then
    raise Exception.Create(ConfigCEF_ExceptConnetWhats);

  vText           := caractersWhats(vText);
  removeCaracter(vFileName);
  LBase64         := TStringList.Create;
  TRY
    LBase64.Text := vBase64;
    for i := 0 to LBase64.Count -1  do
       LLine := LLine + LBase64[i];
    vBase64 := LLine;

    LJS := FrmConsole_JS_VAR_SendBase64;
    FrmConsole_JS_AlterVar(LJS, '#MSG_PHONE#',       Trim(vNum));
    FrmConsole_JS_AlterVar(LJS, '#MSG_NOMEARQUIVO#', Trim(vFileName));
    FrmConsole_JS_AlterVar(LJS, '#MSG_CORPO#',       Trim(vText));
    FrmConsole_JS_AlterVar(LJS, '#MSG_BASE64#',      Trim(vBase64));
    ExecuteJS(LJS);
  FINALLY
    freeAndNil(LBase64);
  END;
end;

procedure TFrmConsole.Send(vNum, vText: string);
var
  Ljs: string;
begin
  if not FConectado then
    raise Exception.Create(ConfigCEF_ExceptConnetWhats);

  vText := caractersWhats(vText);
  LJS   := FrmConsole_JS_VAR_SendMsg;
  FrmConsole_JS_AlterVar(LJS, '#MSG_PHONE#',       Trim(vNum));
  FrmConsole_JS_AlterVar(LJS, '#MSG_CORPO#',       Trim(vText));
  ExecuteJS(LJS);
end;


procedure TFrmConsole.WMEnterMenuLoop(var aMessage: TMessage);
begin
  inherited;
  if (aMessage.wParam = 0) and (GlobalCEFApp <> nil) then
     GlobalCEFApp.OsmodalLoop := True;
end;

procedure TFrmConsole.WMExitMenuLoop(var aMessage: TMessage);
begin
  inherited;
  if (aMessage.wParam = 0) and (GlobalCEFApp <> nil) then
     GlobalCEFApp.OsmodalLoop := False;
end;

procedure TFrmConsole.CEFSentinel1Close(Sender: TObject);
begin
  FCanClose := True;
  PostMessage(Handle, WM_CLOSE, 0, 0);
end;

procedure TFrmConsole.Chromium1AfterCreated(Sender: TObject;
  const browser: ICefBrowser);
begin
  { Agora que o navegador está totalmente inicializado, podemos enviar uma mensagem para
    o formulário principal para carregar a página inicial da web.}
  //PostMessage(Handle, CEFBROWSER_CREATED, 0, 0);
  FTimerConnect.Enabled  := True;
  PostMessage(Handle, CEF_AFTERCREATED, 0, 0);
end;

procedure TFrmConsole.Chromium1BeforeClose(Sender: TObject;
  const browser: ICefBrowser);
begin
  CEFSentinel1.Start;
//  PostMessage(Handle, WM_CLOSE, 0, 0);
end;

procedure TFrmConsole.Chromium1BeforePopup(Sender: TObject;
  const browser: ICefBrowser; const frame: ICefFrame; const targetUrl,
  targetFrameName: ustring; targetDisposition: TCefWindowOpenDisposition;
  userGesture: Boolean; const popupFeatures: TCefPopupFeatures;
  var windowInfo: TCefWindowInfo; var client: ICefClient;
  var settings: TCefBrowserSettings; var extra_info: ICefDictionaryValue;
  var noJavascriptAccess, Result: Boolean);
begin
// bloqueia todas as janelas pop-up e novas guias
  Result := (targetDisposition in [WOD_NEW_FOREGROUND_TAB, WOD_NEW_BACKGROUND_TAB, WOD_NEW_POPUP, WOD_NEW_WINDOW]);
end;

procedure TFrmConsole.Chromium1Close(Sender: TObject;
  const browser: ICefBrowser; var aAction: TCefCloseBrowserAction);
begin
//  PostMessage(Handle, FrmConsole_Browser_Created     , 0, 0);
//  PostMessage(Handle, FrmConsole_Browser_ChildDestroy, 0, 0);
//  PostMessage(Handle, FrmConsole_Browser_Destroy     , 0, 0);
//  PostMessage(Handle, FrmConsole_Browser_Destroy2    , 0, 0);

  Chromium1.ShutdownDragAndDrop;
  If Assigned(OnResultMisc) then
     OnResultMisc(Th_Disconnected, '');
  aAction := cbaDelay;
end;

procedure TFrmConsole.ExecuteCommandConsole( const PResponse: TResponseConsoleMessage);
var
  LOutClass  : TObject;
  LResultStr : String;
begin
  LResultStr := PResponse.Result;
  if (PResponse.TypeHeader = Th_None) then
  Begin
    if LResultStr <> '' then
       FOnErrorInternal(Self, ComunicJS_NotFound, LResultStr);
    exit;
  End;

  if (LResultStr = '') and (PResponse.JsonString = '') then
     Exit;

   If not (PResponse.TypeHeader in [Th_getQrCodeForm, Th_getQrCodeWEB]) Then
      FrmQRCode.Hide;


   Case PResponse.TypeHeader of
    Th_getAllContacts   : Begin
                            if Assigned(FAllContacts) then
                               FAllContacts.Free;

                            FAllContacts := TRetornoAllContacts.Create(LResultStr);
                            if Assigned(TInjectWhatsapp(Owner).OnGetAllContactList ) then
                               TInjectWhatsapp(Owner).OnGetAllContactList(FAllContacts);
                          End;

    Th_GetAllChats      : Begin
                            if Assigned(FChatList) then
                               FChatList.Free;

                            FChatList := TChatList.Create(LResultStr);
                            if Assigned(TInjectWhatsapp(Owner).OnGetChatList) then
                               TInjectWhatsapp(Owner).OnGetChatList(FChatList);
                          End;

    Th_getUnreadMessages: begin
                            LOutClass := TChatList.Create(LResultStr);
                            if Assigned(TInjectWhatsapp(Owner).OnGetUnReadMessages ) then
                               TInjectWhatsapp(Owner).OnGetUnReadMessages(TChatList(LOutClass));
                            FreeAndNil(LOutClass);
                          end;


    Th_getQrCodeWEB,
    Th_getQrCodeForm :    Begin
                            LOutClass := TQrCodeClass.Create(PResponse.JsonString, [], []);
                            ProcessQrCode(LOutClass);
                            If Assigned(OnResultMisc) then
                               OnResultMisc(Th_getQrCodeWEB, '');
                          End;


    Th_GetBatteryLevel  : begin
                            If Assigned(FOnResultMisc) Then
                            Begin
                              LOutClass := TResponseBattery.Create(LResultStr);
                              if Assigned(FOnResultMisc) then
                                 FOnResultMisc(PResponse.TypeHeader, TResponseBattery(LOutClass).Result);
                              FreeAndNil(LOutClass);
                            End;
                          end;

    Th_getMyNumber      : Begin
                            If Assigned(FOnResultMisc) Then
                            Begin
                              LOutClass := TResponseMyNumber.Create(LResultStr);
                              if Assigned(FOnResultMisc) then
                                 FOnResultMisc(PResponse.TypeHeader, TResponseMyNumber(LOutClass).Result);
                              FreeAndNil(LOutClass);
                            End;
                          End;

       Th_Disconnected  : Begin
                            DisConnect;
                          End;

   end;

end;



procedure TFrmConsole.Chromium1ConsoleMessage(Sender: TObject;
  const browser: ICefBrowser; level: Cardinal; const message, source: ustring;
  line: Integer; out Result: Boolean);
var
  AResponse  : TResponseConsoleMessage;
begin
  if (trim(message) = '') or (message = JSRetornoVazio) then
      Exit;

  AResponse := TResponseConsoleMessage.Create( message );
  try
    if AResponse = nil then
       Exit;
    ExecuteCommandConsole(AResponse);
    if Assigned(FControlSend) then
       FControlSend.Release;

  finally
    FreeAndNil(AResponse);
  end;
end;


procedure TFrmConsole.Chromium1Jsdialog(Sender: TObject;
  const browser: ICefBrowser; const originUrl: ustring;
  dialogType: TCefJsDialogType; const messageText, defaultPromptText: ustring;
  const callback: ICefJsDialogCallback; out suppressMessage, Result: Boolean);
begin
//  LogAdd(originUrl  +' - ' + messageText, ' Jsdialog');
//  ShowMessage(messageText);
end;

procedure TFrmConsole.Chromium1LoadEnd(Sender: TObject;
  const browser: ICefBrowser; const frame: ICefFrame; httpStatusCode: Integer);
  begin
//  LogAdd(browser.MainFrame.Url, 'CAPTURANDO');
//  Chromium1.RetrieveHTML;

 //Injeto o código para verificar se está logado
 // JS := 'WAPI.isLoggedIn();';
 // if Chromium1.Browser <> nil then
 //     Chromium1.Browser.MainFrame.ExecuteJavaScript(JS, 'about:blank', 0);
end;

procedure TFrmConsole.Chromium1OpenUrlFromTab(Sender: TObject;
  const browser: ICefBrowser; const frame: ICefFrame; const targetUrl: ustring;
  targetDisposition: TCefWindowOpenDisposition; userGesture: Boolean;
  out Result: Boolean);
begin
 //Bloqueia popup do windows e novas abas
  Result := (targetDisposition in [WOD_NEW_FOREGROUND_TAB, WOD_NEW_BACKGROUND_TAB, WOD_NEW_POPUP, WOD_NEW_WINDOW]);
end;

procedure TFrmConsole.Chromium1TextResultAvailable(Sender: TObject;
  const aText: ustring);
var
  Ltmp: String;
begin
  if not FConectado then
     eXIT;

  Ltmp:= LowerCase(Copy(aText, 3500, 1000));
  LogAdd(atext, 'PAGINA');

  if pos(FrmConsole_Browser_ContextPhoneOff, Ltmp) > 0 Then
  Begin
    If Assigned(OnResultMisc) then
       OnResultMisc(Th_ConnectingNoPhone, '');
  End;
end;

procedure TFrmConsole.Chromium1TitleChange(Sender: TObject;
  const browser: ICefBrowser; const title: ustring);
begin
  //injectJS;
  li := li + 1;
  if li > 3 then
  begin
    If Assigned(OnResultMisc) then
       OnResultMisc(Th_Connected, '');
  end;
end;

Procedure TFrmConsole.Connect;
var
  LInicio: Cardinal;
begin
  if Assigned(GlobalCEFApp) then
  Begin
    if GlobalCEFApp.ErrorInt Then
       Exit;
  end;

  try
    if FConectado then
       Exit;

    If Assigned(OnResultMisc) then
       OnResultMisc(Th_Connecting, '');

    LInicio    := GetTickCount;
    FConectado := Chromium1.CreateBrowser(CEFWindowParent1);
    Repeat
      FConectado := (Chromium1.Initialized);
      if not FConectado then
      Begin
        Sleep(10);
        Application.ProcessMessages;
        if (GetTickCount - LInicio) >= 15000 then
           Break;
      End;
    Until FConectado;
  finally
    FTimerMonitoring.Enabled  := FConectado;
    if not FConectado then
    begin
      If Assigned(OnResultMisc) then
         OnResultMisc(Th_Disconnected, '');
      raise Exception.Create(ConfigCEF_ExceptBrowse);
    end;
  end;
end;



procedure TFrmConsole.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
 action     := cafree;
end;

procedure TFrmConsole.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  CanClose := FCanClose;
  if not FClosing then
  Begin
    GlobalCEFApp.QuitMessageLoop;
    FClosing := True;
    Visible  := False;
    DisConnect;
  end;
end;

procedure TFrmConsole.FormCreate(Sender: TObject);
var
  Lciclo: Integer;
begin
  if GlobalCEFApp <> nil then
  Begin
    if not TInjectWhatsapp(Owner).InjectJS.Ready then
       raise Exception.Create('Classe principal não localizada');
  End else
  begin
    raise Exception.Create('Classe principal não localizada');
  end;

  FClosing                  := False;
  FCanClose                 := False;
  FCountBattery             := 0;
  FControlSend              := TControlSend.Create(Self);
  FrmQRCode                         := TFrmQRCode.Create(Self);
  FrmQRCode.FTimerGetQrCode.OnTimer := OnTimerGetQrCode;
  FrmQRCode.hide;

  GlobalCEFApp.Chromium     := Chromium1;
  Chromium1.DefaultURL      := FrmConsole_JS_URL;
  FTimerMonitoring          := TTimer.Create(nil);
  FTimerMonitoring.Interval := 1000 * 10;  //10 segundos..
  FTimerMonitoring.Enabled  := False;
  FTimerMonitoring.OnTimer  := OnTimerMonitoring;


  FTimerConnect            := TTimer.Create(nil);
  FTimerConnect.Interval   := 1000;
  FTimerConnect.Enabled    := False;
  FTimerConnect.OnTimer    := OnTimerConnect;

  //Pega Qntos ciclos o timer vai ser executado em um MINUTO...
  Lciclo                 := 60 div (FTimerMonitoring.Interval div 1000);
  FCountBatteryMax       := Lciclo * 3; //(Ser executado a +- cada 3minutos)
end;

procedure TFrmConsole.FormDestroy(Sender: TObject);
begin
  FrmQRCode.PodeFechar := True;
  FrmQRCode.close;
  FreeAndNil(FAQrCode);

  FTimerMonitoring.Enabled  := False;

  FreeAndNil(FTimerMonitoring);

  FreeAndNil(FAllContacts);
  FreeAndNil(FChatList);

  FreeAndNil(FControlSend);
  FreeAndNil(FTimerConnect);

  GlobalCEFApp.Chromium := Nil;
  If Assigned(OnResultMisc) then
     OnResultMisc(TH_Destroy, '');
end;


procedure TFrmConsole.FormShow(Sender: TObject);
begin
  //if not(Chromium1.CreateBrowser(CEFWindowParent1)) then Timer1.Enabled := True;
end;

procedure TFrmConsole.Image1Click(Sender: TObject);
begin
  Hide;
end;

Procedure TFrmConsole.ISLoggedin;
begin
  ExecuteJS(FrmConsole_JS_IsLoggedIn);
end;


end.

