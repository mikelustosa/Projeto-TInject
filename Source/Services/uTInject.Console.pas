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

  uCEFWinControl, uCEFChromiumCore,
  uCEFInterfaces, uCEFConstants, uCEFWindowParent, uCEFChromium,

  //units adicionais obrigatórias
  uTInject.Classes, uTInject, uTInject.FrmQRCode, uTInject.constant,
  uCEFTypes, uTInject.ConfigCEF, uTInject.Diversos,

  Vcl.StdCtrls, Vcl.ComCtrls, System.ImageList, Vcl.ImgList, System.JSON,
  Vcl.Buttons, Vcl.Imaging.pngimage, Rest.Json,
  Vcl.Imaging.jpeg, uTInject.ControlSend;

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
    Procedure ExecuteCommandConsole(Const PResponse: TResponseConsoleMessage);
  private
    { Private declarations }
    FCanClose     : Boolean;
    FClosing        : Boolean;
    FConectado      : Boolean;
    FTimerConnect   : TTimer;
    FTimerMonitoring: TTimer;
    FOnResultMisc   : TResulttMisc;
    FControlSend    : TControlSend;
    FCountBattery   : Integer;
    FCountBatteryMax: Integer;
    Li: integer;
    FMonitorLowBattry: Boolean;
    FOnErrorInternal: TOnErroInternal;

    Function  GetAutoBatteryLeveL: Boolean;
    Procedure ISLoggedin;
    procedure ExecuteJS(PScript: WideString;  Purl:String = 'about:blank'; pStartline: integer=0);
    procedure loadWEBQRCode(st: string);
  public
    { Public declarations }
    property  OnErrorInternal : TOnErroInternal Read FOnErrorInternal          Write FOnErrorInternal;

    Property  MonitorLowBattry : Boolean   Read FMonitorLowBattry  Write FMonitorLowBattry;
    Property  OnResultMisc : TResulttMisc  Read FOnResultMisc      Write FOnResultMisc;
    Procedure Connect;
    Procedure DisConnect;
    procedure Send(vNum, vText:string);
    procedure SendBase64(vBase64, vNum, vFileName, vText:string);
    function  ConvertBase64(vFile: string): string;
    function  caractersWhats(vText: string): string;

    procedure GetAllContacts;
    procedure GetAllChats;
    procedure GetUnreadMessages;
    procedure GetBatteryLevel;
    procedure GetMyNumber;
    procedure monitorQRCode;
    //Para monitorar o qrcode via REST
    procedure WEBmonitorQRCode;
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
  System.NetEncoding, Vcl.Dialogs;

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

function removeCaracter(texto : String) : String;
Begin
  While pos('-', Texto) <> 0 Do
    delete(Texto,pos('-', Texto),1);
  While pos('/', Texto) <> 0 Do
    delete(Texto,pos('/', Texto),1);
  While pos(',', Texto) <> 0 Do
    delete(Texto,pos(',', Texto),1);
  Result := Texto;
end;

function TFrmConsole.caractersWhats(vText: string): string;
begin
  vText  := StringReplace(vText, sLineBreak,'\n',[rfReplaceAll]);
  vText  := StringReplace((vText), #13,'',[rfReplaceAll]);
  vText  := StringReplace((vText), '"','\"',[rfReplaceAll]);
  vText  := StringReplace((vText), #$A, '', [rfReplaceAll]);
  Result := vText;
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


procedure TFrmConsole.ExecuteJS(PScript: WideString;  Purl:String; pStartline: integer);
begin
  if Assigned(GlobalCEFApp) then
  Begin
    if GlobalCEFApp.ErrorInt Then
       Exit;
  end;
  If Application.Terminated Then
     Exit;

  if not FConectado then
     raise Exception.Create(ConfigCEF_ExceptConnetWhats);

  if Chromium1.Browser <> nil then
  begin
     if Assigned(FControlSend) then
       if FControlSend.CanSend(PScript) Then
          Chromium1.Browser.MainFrame.ExecuteJavaScript(PScript, Purl, pStartline) else
          OnErrorInternal(self, DuplicityDetected, PScript);
  end;
end;

procedure TFrmConsole.WEBmonitorQRCode;
begin
  ExecuteJS(FrmConsole_JS_WEBmonitorQRCode);
end;

procedure TFrmConsole.monitorQRCode;
begin
  ExecuteJS(FrmConsole_JS_monitorQRCode);
end;

procedure TFrmConsole.OnTimerConnect(Sender: TObject);
var
  lNovoStatus: Boolean;
begin
   if not Assigned(GlobalCEFApp.InjectWhatsApp) then
      Exit;

  //Rotina para leitura e inject do arquivo js.abr ---- 12/10/2019 Mike
  lNovoStatus            := True;
  FTimerConnect.Enabled  := False;
  try
    If GlobalCEFApp.InjectWhatsApp.Auth then
    Begin
      ExecuteJS(GlobalCEFApp.InjectWhatsApp.InjectJS.JSScript.Text);
      GetMyNumber;

      //Auto monitorar mensagens não lidas
      StartMonitor(GlobalCEFApp.InjectWhatsApp.Config.SecondsMonitor);
      lNovoStatus    := False;
    End;
  finally
    FTimerConnect.Enabled := lNovoStatus;
  end;
end;

procedure TFrmConsole.OnTimerMonitoring(Sender: TObject);
begin
  //Testa se existe alguma desconexão por parte do aparelho...
  FTimerMonitoring.Enabled := False;
  try
    if not GlobalCEFApp.InjectWhatsApp.Auth then
       Exit;


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
var
  LQr: TResultQRCodeClass;
begin
  try
    if not (pClass is TQrCodeClass) then    Exit;
    If not assigned(FrmQRCode) then
       Exit;

    if (TQR_Http in TQrCodeClass(pClass).Tags) or (TQR_Img in TQrCodeClass(pClass).Tags) then
    Begin
      FrmQRCode.Close;
      FreeAndNil(FrmQRCode);
      Exit;
    End;


    LQr := TResultQRCodeClass(TQrCodeClass(pClass).Result);
      //e difente.. portanto.. verificamos se existe imagem la no form.. se existir caimos fora!! se nao segue o fluxo
    if not LQr.AImageDif then
    Begin
      if FrmQRCode.Timg_QrCode.Picture <> nil Then
         Exit;
    End;

    FrmQRCode.Timg_QrCode.Picture.Assign(LQr.AQrCodeImage);
    FrmQRCode.SetView(FrmQRCode.Timg_QrCode);
    loadWEBQRCode(LQr.AQrCode);
    If Assigned(GlobalCEFApp.InjectWhatsApp) Then
    Begin
      If Assigned(GlobalCEFApp.InjectWhatsApp.OnGetQrCode) then
         GlobalCEFApp.InjectWhatsApp.OnGetQrCode(Self);
    End;
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

procedure TFrmConsole.StopMonitor;
begin
  ExecuteJS(FrmConsole_JS_StopMonitor);
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
  if not FConectado then
     Exit;

  StopMonitor;
  Chromium1.CloseBrowser(True);
  GlobalCEFApp.InjectWhatsApp.Auth := False;
  FConectado                       := False;
end;

//Marca como lida e deleta a conversa
procedure TFrmConsole.ReadMessagesAndDelete(vID: string);
begin
  ReadMessages  (Trim(vID));
  DeleteMessages(Trim(vID));
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
  FCanClose := True;
  PostMessage(Handle, WM_CLOSE, 0, 0);
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
  PostMessage(Handle, FrmConsole_Browser_Created     , 0, 0);
  PostMessage(Handle, FrmConsole_Browser_ChildDestroy, 0, 0);
  PostMessage(Handle, FrmConsole_Browser_Destroy     , 0, 0);
  PostMessage(Handle, FrmConsole_Browser_Destroy2    , 0, 0);

  PostMessage(Handle, CEF_DESTROY, 0, 0);
  aAction := cbaDelay;
end;

procedure TFrmConsole.ExecuteCommandConsole( const PResponse: TResponseConsoleMessage);
var
  LOutClass  : TObject;
  LResultStr : String;
begin
  LResultStr := PResponse.Result;
  if PResponse.TypeHeader = Th_None then
  Begin
    if LResultStr <> '' then
       FOnErrorInternal(Self, ComunicJS_NotFound, LResultStr);
    exit;
  End;



  Case PResponse.TypeHeader of
    Th_getAllContacts   : Begin
                            if Assigned(GlobalCEFApp.InjectWhatsApp.AllContacts) then
                               GlobalCEFApp.InjectWhatsApp.AllContacts.Free;

                            GlobalCEFApp.InjectWhatsApp.AllContacts := TRetornoAllContacts.Create(LResultStr);
                            if Assigned(GlobalCEFApp.InjectWhatsApp.OnGetContactList ) then
                               GlobalCEFApp.InjectWhatsApp.OnGetContactList(Self);
                          End;

    Th_GetAllChats      : Begin
                            if Assigned(GlobalCEFApp.InjectWhatsApp.AllChats) then
                               GlobalCEFApp.InjectWhatsApp.AllChats.Free;

                            GlobalCEFApp.InjectWhatsApp.AllChats := TChatList.Create(LResultStr);
                            if Assigned(GlobalCEFApp.InjectWhatsApp.OnGetChatList) then
                               GlobalCEFApp.InjectWhatsApp.OnGetChatList(Self);
                          End;

    Th_getUnreadMessages: begin
                            LOutClass := TChatList.Create(LResultStr);
                            if Assigned(GlobalCEFApp.InjectWhatsApp.OnGetUnReadMessages ) then
                               GlobalCEFApp.InjectWhatsApp.OnGetUnReadMessages(TChatList(LOutClass));
                            FreeAndNil(LOutClass);
                          end;

{
    Th_getQrCodeForm :    Begin
                            try
                              LOutClass := TQrCodeClass.Create(message, [], []);
                              ProcessQrCode(LOutClass);
                            Except
                            end;
                          End;

    Th_getQrCodeWEB     : Begin
                            LOutClass := TQrCodeClass.Create(message, [], []);
                            loadWEBQRCode(TQrCodeClass(LOutClass).Result.AQrCode);
                          End;

}
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

          Th_Disconect  : Begin
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
  if (not Assigned(GlobalCEFApp.InjectWhatsApp)) or (Application.Terminated) then
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


procedure TFrmConsole.Chromium1LoadEnd(Sender: TObject;
  const browser: ICefBrowser; const frame: ICefFrame; httpStatusCode: Integer);
  begin
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

procedure TFrmConsole.Chromium1TitleChange(Sender: TObject;
  const browser: ICefBrowser; const title: ustring);
begin
  //injectJS;
  if not  Assigned(GlobalCEFApp.InjectWhatsApp) then
     Exit;

  li := li + 1;
  if li > 3 then
  begin
    GlobalCEFApp.InjectWhatsApp.Auth := true
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

    LInicio      := GetTickCount;
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
       raise Exception.Create(ConfigCEF_ExceptBrowse);
  end;
end;

function TFrmConsole.ConvertBase64(vFile: string): string;
var
  vFilestream: TMemoryStream;
  vBase64File: TBase64Encoding;
begin
  vBase64File := TBase64Encoding.Create;
  vFilestream := TMemoryStream.Create;
  try
    vFilestream.LoadFromFile(vFile);
    result :=  vBase64File.EncodeBytesToString(vFilestream.Memory, vFilestream.Size);
  finally
    FreeAndNil(vBase64File);
    FreeAndNil(vFilestream);
  end;
end;

procedure TFrmConsole.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  action     := cafree;
//  FrmConsole := nil;
end;

procedure TFrmConsole.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  CanClose := FCanClose;
  if FClosing then
  Begin
    GlobalCEFApp.QuitMessageLoop
  end else
  begin
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
    if not GlobalCEFApp.InjectWhatsApp.InjectJS.Ready then
       raise Exception.Create('Classe principal não localizada');
  End else
  begin
    raise Exception.Create('Classe principal não localizada');
  end;

  FClosing                  := False;
  FCanClose               := False;
  FCountBattery             := 0;
  FControlSend              := TControlSend.Create(Self);

  GlobalCEFApp.Chromium     := Chromium1;
  Chromium1.DefaultURL      := FrmConsole_JS_URL;
  FTimerMonitoring          := TTimer.Create(nil);
  FTimerMonitoring.Interval := 1000 * 10;  //10 segundos..
  FTimerMonitoring.Enabled  := False;
  FTimerMonitoring.OnTimer  := OnTimerMonitoring;


  FTimerConnect          := TTimer.Create(nil);
  FTimerConnect.Interval := 1000;
  FTimerConnect.Enabled  := False;
  FTimerConnect.OnTimer  := OnTimerConnect;
  //Pega Qntos ciclos o timer vai ser executado em um MINUTO...
  Lciclo                 := 60 div (FTimerMonitoring.Interval div 1000);
  FCountBatteryMax       := Lciclo * 3; //(Ser executado a +- cada 3minutos)
end;

procedure TFrmConsole.FormDestroy(Sender: TObject);
begin
  Chromium1.ShutdownDragAndDrop;
  FTimerMonitoring.Enabled  := False;

  FreeAndNil(FTimerMonitoring);
//  PostMessage(Handle, FrmConsole_Browser_ChildDestroy, 0, 0);
  FreeAndNil(FControlSend);
  FreeAndNil(FTimerConnect);
  GlobalCEFApp.Chromium     := Nil;
end;

procedure TFrmConsole.FormShow(Sender: TObject);
begin
  //if not(Chromium1.CreateBrowser(CEFWindowParent1)) then Timer1.Enabled := True;
end;

procedure TFrmConsole.Image1Click(Sender: TObject);
begin
  FrmConsole.Hide;
end;

Procedure TFrmConsole.ISLoggedin;
begin
  ExecuteJS(FrmConsole_JS_IsLoggedIn);
end;

procedure TFrmConsole.loadWEBQRCode(st: string);
var
  LInput : TMemoryStream;
  LOutput: TMemoryStream;
  stl    : TStringList;
begin
  LInput  := TMemoryStream.Create;
  LOutput := TMemoryStream.Create;
  try
    stl := TStringList.Create;
    stl.Add(copy(st, 23, length(st)));
    stl.SaveToStream(LInput);

    LInput.Position  := 0;
    TNetEncoding.Base64.Decode( LInput, LOutput );
    LOutput.Position := 0;
  finally
    FreeAndNil(LInput);
    FreeAndNil(LOutput);
  end;
end;
end.

