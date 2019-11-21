//TInject Criado por Mike W. Lustosa
//Códido aberto à comunidade Delphi
//mikelustosa@gmail.com

unit u_servicesWhats;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, uCEFChromium,
  uCEFWinControl, uCEFWindowParent,

  //units adicionais obrigatórias
  uCEFInterfaces, uCEFConstants, uCEFTypes, UnitCEFLoadHandlerChromium, uCEFApplication,
  Vcl.StdCtrls, Vcl.ComCtrls, System.ImageList, Vcl.ImgList, System.JSON,
  Vcl.Buttons, Vcl.Imaging.pngimage, Rest.Json, uClasses, uTInject, u_view_qrcode, Vcl.Imaging.jpeg;

  var
   vContacts :Array of String;

  const
    CEFBROWSER_CREATED          = WM_APP + $100;
    CEFBROWSER_CHILDDESTROYED   = WM_APP + $101;
    CEFBROWSER_DESTROY          = WM_APP + $102;

type
  Tfrm_servicesWhats = class(TForm)
    CEFWindowParent1: TCEFWindowParent;
    Chromium1: TChromium;
    Timer1: TTimer;
    Timer2: TTimer;
    memo_js: TMemo;
    Panel1: TPanel;
    Image2: TImage;
    Image1: TImage;
    Label1: TLabel;
    procedure Timer1Timer(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure Chromium1AfterCreated(Sender: TObject;
      const browser: ICefBrowser);
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
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Image1Click(Sender: TObject);
    procedure Chromium1ConsoleMessage(Sender: TObject;
      const browser: ICefBrowser; level: Cardinal; const message,
      source: ustring; line: Integer; out Result: Boolean);
  protected
   // Variáveis para controlar quando podemos destruir o formulário com segurança
    FCanClose : boolean;  // Defina como True em TChromium.OnBeforeClose
    FClosing  : boolean;  // Defina como True no evento CloseQuery.

    // You have to handle this two messages to call NotifyMoveOrResizeStarted or some page elements will be misaligned.
    procedure WMMove(var aMessage : TWMMove); message WM_MOVE;
    procedure WMMoving(var aMessage : TMessage); message WM_MOVING;
    // You also have to handle these two messages to set GlobalCEFApp.OsmodalLoop
    procedure WMEnterMenuLoop(var aMessage: TMessage); message WM_ENTERMENULOOP;
    procedure WMExitMenuLoop(var aMessage: TMessage); message WM_EXITMENULOOP;

    procedure BrowserDestroyMsg(var aMessage : TMessage); message CEF_DESTROY;
  private
    { Private declarations }
    procedure LogConsoleMessage(const AMessage: String);
    procedure SetAllContacts(JsonText: String);
    procedure SetAllChats(JsonText: String);
    procedure SetUnReadMessages(JsonText: String);
    procedure SetQrCode(JsonText: String);
    procedure loadWEBQRCode(st: string);

  public
    { Public declarations }
    _Inject: TInjectWhatsapp;
    JS1: string;
    _Qrcode, WEBQrCode: string;
    i: integer;
    vAuth: boolean;
    procedure Send(vNum, vText:string);
    procedure SendBase64(vBase64, vNum, vFileName, vText:string);
    function ConvertBase64(vFile: string): string;
    function caractersWhats(vText: string): string;
    procedure GetAllContacts;
    procedure GetAllChats;
    procedure GetUnreadMessages;
    procedure monitorQRCode;
    procedure loadQRCode(st: string);
    procedure ReadMessages(vID: string);
    procedure ReadMessagesAndDelete(vID: string);
  end;

var
  frm_servicesWhats: Tfrm_servicesWhats;

implementation

uses
  System.IOUtils, System.NetEncoding;

{$R *.dfm}

procedure ParseJson(aStringJson : string);
var
  LJsonArr   : TJSONArray;
  LJsonValue : TJSONValue;
  LItem     : TJSONValue;
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

function Tfrm_servicesWhats.caractersWhats(vText: string): string;
begin
  vText := StringReplace(vText, sLineBreak,'\n',[rfReplaceAll]);
  vText := StringReplace((vText), #13,'',[rfReplaceAll]);
  vText := StringReplace((vText), '"','\"',[rfReplaceAll]);
  vText := StringReplace((vText), #$A, '', [rfReplaceAll]);
  Result := vText;
end;

procedure Tfrm_servicesWhats.BrowserDestroyMsg(var aMessage : TMessage);
begin
  CEFWindowParent1.Free;
end;

procedure Tfrm_servicesWhats.WMMove(var aMessage : TWMMove);
begin
  inherited;

  if (Chromium1 <> nil) then Chromium1.NotifyMoveOrResizeStarted;
end;

procedure Tfrm_servicesWhats.WMMoving(var aMessage : TMessage);
begin
  inherited;

  if (Chromium1 <> nil) then Chromium1.NotifyMoveOrResizeStarted;
end;

procedure Tfrm_servicesWhats.WMEnterMenuLoop(var aMessage: TMessage);
begin
  inherited;

  if (aMessage.wParam = 0) and (GlobalCEFApp <> nil) then GlobalCEFApp.OsmodalLoop := True;
end;

procedure Tfrm_servicesWhats.WMExitMenuLoop(var aMessage: TMessage);
begin
  inherited;

  if (aMessage.wParam = 0) and (GlobalCEFApp <> nil) then GlobalCEFApp.OsmodalLoop := False;
end;

procedure Tfrm_servicesWhats.Chromium1AfterCreated(Sender: TObject;
  const browser: ICefBrowser);
begin
  { Agora que o navegador está totalmente inicializado, podemos enviar uma mensagem para
    o formulário principal para carregar a página inicial da web.}
  //PostMessage(Handle, CEFBROWSER_CREATED, 0, 0);
  PostMessage(Handle, CEF_AFTERCREATED, 0, 0);
end;

procedure Tfrm_servicesWhats.Chromium1BeforeClose(Sender: TObject;
  const browser: ICefBrowser);
begin
  FCanClose := True;
  PostMessage(Handle, WM_CLOSE, 0, 0);
end;

procedure Tfrm_servicesWhats.Chromium1BeforePopup(Sender: TObject;
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

procedure Tfrm_servicesWhats.Chromium1Close(Sender: TObject;
  const browser: ICefBrowser; var aAction: TCefCloseBrowserAction);
begin
  PostMessage(Handle, CEF_DESTROY, 0, 0);
  aAction := cbaDelay;
end;

procedure Tfrm_servicesWhats.Chromium1ConsoleMessage(Sender: TObject;
  const browser: ICefBrowser; level: Cardinal; const message, source: ustring;
  line: Integer; out Result: Boolean);
var
  AResponse: TResponseConsoleMessage;

  function PrettyJSON(JsonString: String):String;
  var
    AObj: TJSONObject;
  begin
    AObj := TJSONObject.ParseJSONValue(JsonString) as TJSONObject;
    result:=TJSON.Format(AObj);
    AObj.Free;
  end;
begin
    try
      AResponse := TResponseConsoleMessage.FromJsonString( message );
      if assigned(AResponse) then
      begin

        if AResponse.Name = 'getAllContacts' then
        begin
           LogConsoleMessage( PrettyJSON(AResponse.Result) );
           SetAllContacts( AResponse.Result );
        end;

        if AResponse.Name = 'getAllChats' then
        begin
           LogConsoleMessage( PrettyJSON(AResponse.Result) );
           SetAllChats( AResponse.Result );
        end;

        if AResponse.Name = 'getUnreadMessages' then
        begin
           LogConsoleMessage( PrettyJSON(AResponse.Result) );
           SetUnreadMessages( AResponse.Result );
        end;
        if AResponse.name = 'getQrCode' then
           SetQrCode( message )
      end;
    except
      on E:Exception do
      begin
        Application.MessageBox(PChar(E.Message),'TInject', mb_iconError + mb_ok);
        raise;
      end;
    end;
end;

procedure Tfrm_servicesWhats.GetAllContacts;
const
  JS = 'window.WAPI.getAllContacts();';
begin
  Chromium1.Browser.MainFrame.ExecuteJavaScript(JS, 'about:blank', 0);
end;

procedure Tfrm_servicesWhats.GetUnreadMessages;
const
  JS = 'window.WAPI.getUnreadMessages(includeMe="True", includeNotifications="True", use_unread_count="True");';
begin
  Chromium1.Browser.MainFrame.ExecuteJavaScript(JS, 'about:blank', 0);
end;

procedure Tfrm_servicesWhats.GetAllChats;
const
  JS = 'window.WAPI.getAllChats();';
begin
  Chromium1.Browser.MainFrame.ExecuteJavaScript(JS, 'about:blank', 0);
end;

procedure Tfrm_servicesWhats.Chromium1LoadEnd(Sender: TObject;
  const browser: ICefBrowser; const frame: ICefFrame; httpStatusCode: Integer);
  begin
 //Injeto o código para verificar se está logado
 // JS := 'WAPI.isLoggedIn();';
 // if Chromium1.Browser <> nil then
 //     Chromium1.Browser.MainFrame.ExecuteJavaScript(JS, 'about:blank', 0);
end;

procedure Tfrm_servicesWhats.Chromium1OpenUrlFromTab(Sender: TObject;
  const browser: ICefBrowser; const frame: ICefFrame; const targetUrl: ustring;
  targetDisposition: TCefWindowOpenDisposition; userGesture: Boolean;
  out Result: Boolean);
begin
 //Bloqueia popup do windows e novas abas
  Result := (targetDisposition in [WOD_NEW_FOREGROUND_TAB, WOD_NEW_BACKGROUND_TAB, WOD_NEW_POPUP, WOD_NEW_WINDOW]);
end;

procedure Tfrm_servicesWhats.Chromium1TitleChange(Sender: TObject;
  const browser: ICefBrowser; const title: ustring);
begin
  //injectJS;
  i := i + 1;
  if i > 3 then
  begin
    vAuth := true;
    _Inject.Auth := true
  end;
end;


function Tfrm_servicesWhats.ConvertBase64(vFile: string): string;
var
  vFilestream: TMemoryStream;
  vBase64File: TBase64Encoding;
begin
  try
    vBase64File := TBase64Encoding.Create;
    vFilestream := TMemoryStream.Create;
    vFilestream.LoadFromFile(vFile);
   finally
    result :=  vBase64File.EncodeBytesToString(vFilestream.Memory, vFilestream.Size);
  end;
end;

procedure Tfrm_servicesWhats.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  action := cafree;
  frm_servicesWhats := nil;
end;

procedure Tfrm_servicesWhats.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  CanClose := FCanClose;

  if not(FClosing) then
    begin
      FClosing := True;
      Visible  := False;
      Chromium1.CloseBrowser(True);
    end;
end;

procedure Tfrm_servicesWhats.FormCreate(Sender: TObject);
begin
  FCanClose := False;
  FClosing  := False;
  Chromium1.DefaultURL := 'https://web.whatsapp.com/';
  vAuth := false;

  if not(Chromium1.CreateBrowser(CEFWindowParent1)) then Timer1.Enabled := True;
end;

procedure Tfrm_servicesWhats.FormDestroy(Sender: TObject);
begin
  PostMessage(Handle, CEFBROWSER_CHILDDESTROYED, 0, 0);
end;

procedure Tfrm_servicesWhats.FormShow(Sender: TObject);
begin
  //if not(Chromium1.CreateBrowser(CEFWindowParent1)) then Timer1.Enabled := True;
end;

procedure Tfrm_servicesWhats.Image1Click(Sender: TObject);
begin
  frm_servicesWhats.Hide;
end;

procedure Tfrm_servicesWhats.loadQRCode(st: string);
begin
  if assigned(frm_servicesWhats) then
    frm_view_qrcode.loadQRCode(st);
end;

procedure Tfrm_servicesWhats.LogConsoleMessage(const AMessage: String);
begin
  TFile.AppendAllText(
    ExtractFilePath(Application.ExeName) + 'ConsoleMessage.log',
    AMessage,
    TEncoding.ASCII);
end;

procedure Tfrm_servicesWhats.monitorQRCode;
const JSQrCode = 'var AQrCode = document.getElementsByTagName("img")[0].getAttribute("src");console.log(JSON.stringify({"name":"getQrCode","result":{AQrCode}}));';
begin
  if Chromium1.Browser <> nil then
    Chromium1.Browser.MainFrame.ExecuteJavaScript(JSQrCode, 'about:blank', 0);
end;

//Apenas marca como lida a mensagem
procedure Tfrm_servicesWhats.ReadMessages(vID: string);
var
  js: string;
begin
  js := 'window.WAPI.sendSeen("'+Trim(vID)+'")';
    if Chromium1.Browser <> nil then
    Chromium1.Browser.MainFrame.ExecuteJavaScript(js, 'about:blank', 0);
end;

//Marca como lida e deleta a conversa
procedure Tfrm_servicesWhats.ReadMessagesAndDelete(vID: string);
var
  js: string;
begin
  js := 'window.WAPI.sendSeen("'+Trim(vID)+'")';
    if Chromium1.Browser <> nil then
    Chromium1.Browser.MainFrame.ExecuteJavaScript(js, 'about:blank', 0);


  js := 'window.WAPI.deleteConversation("'+Trim(vID)+'")';
    if Chromium1.Browser <> nil then
    Chromium1.Browser.MainFrame.ExecuteJavaScript(js, 'about:blank', 0);
end;

procedure Tfrm_servicesWhats.SendBase64(vBase64, vNum, vFileName, vText: string);
var
 js: string;
 Base64File: TStringList;
 i: integer;
 vLine: string;
begin
  vText := caractersWhats(vText);
  removeCaracter(vFileName);
  Base64File:= TStringList.Create;
  Base64File.Text := vBase64;
  for i := 0 to Base64File.Count -1  do
  begin
    vLine := vLine + Base64File[i];
  end;
  vBase64 := vLine;
  js := 'window.WAPI.sendImage("'+Trim(vBase64)+'","'+Trim(vNum)+'", "'+Trim(vFileName)+'", "'+Trim(vText)+'")';

  if Chromium1.Browser <> nil then
  begin
    Chromium1.Browser.MainFrame.ExecuteJavaScript(js, 'about:blank', 0);
  end;

  freeAndNil(vBase64);
end;

procedure Tfrm_servicesWhats.SetAllContacts(JsonText: String);
begin
  if not Assigned( _Inject ) then
     Exit;

  with _Inject do
  begin
    if Assigned(AllContacts) then
       AllContacts.Free;
    AllContacts := TRetornoAllContacts.FromJsonString( JsonText );

     //Dispara Notify
     if Assigned( OnGetContactList ) then
        OnGetContactList(Self);
  end;
end;

procedure Tfrm_servicesWhats.loadWEBQRCode(st: string);
var
  LInput: TMemoryStream;
  LOutput: TMemoryStream;
  stl: TStringList;
begin
  try
    LInput := TMemoryStream.Create;
    LOutput := TMemoryStream.Create;
    stl := TStringList.Create;
    stl.Add(copy(st, 23, length(st)));
    stl.SaveToStream(LInput);

    LInput.Position := 0;
    TNetEncoding.Base64.Decode( LInput, LOutput );
    LOutput.Position := 0;
    if LOutput.size > 0 then
      WEBQrCode := st;
  finally
   LInput.Free;
   LOutput.Free;
  end;
end;

procedure Tfrm_servicesWhats.SetQrCode(JsonText: String);
var AQrCode: TQrCodeClass;
var code: string;
begin
  if not Assigned( _Inject ) then
     Exit;

  with _Inject do
  begin
    code :=  copy(JsonText, 42, 4);
    if (code = 'http') or (code = '/img') then
    begin
      frm_view_qrcode.Timer1.Enabled := false;
      frm_view_qrcode.close;
      exit
    end;
    AQrCode := TQrCodeClass.FromJsonString( JsonText );
    _Qrcode := AQrCode.result.AQrCode;

    if assigned(frm_view_qrcode) then
    begin
      frm_view_qrcode.loadQRCode(_Qrcode);
      frm_view_qrcode.Image2.visible := false;
    end else
    begin
      //Caso seja solicitação via API REST
      loadWEBQRCode(_Qrcode);
    end;

    //Dispara Notify
    if Assigned( OnGetQrCode ) then
       OnGetQrCode(Self);
  end;
end;

procedure Tfrm_servicesWhats.SetUnReadMessages(JsonText: String);
var
  AChats: TChatList;
begin
  if not Assigned( _Inject ) then
     Exit;

  AChats := TChatList.FromJsonString( JsonText );
  try
    with _Inject do
    begin
      //Dispara Notify
      if Assigned( OnGetUnReadMessages ) then
         OnGetUnReadMessages( AChats );
    end;
  finally
    AChats.Free;
  end;
end;

procedure Tfrm_servicesWhats.SetAllChats(JsonText: String);
begin
  if not Assigned( _Inject ) then
     Exit;

  with _Inject do
  begin
    if Assigned(AllChats) then
       AllChats.Free;
    AllChats := TChatList.FromJsonString( JsonText );

     //Dispara Notify
     if Assigned( OnGetChatList ) then
        OnGetChatList(Self);
  end;
end;

procedure Tfrm_servicesWhats.Send(vNum, vText: string);
var
 JS: string;
begin
 vText := caractersWhats(vText);

 JS := 'window.WAPI.sendMessageToID("'+Trim(vNum)+'","'+Trim(vText)+'")';

 if Chromium1.Browser <> nil then
      Chromium1.Browser.MainFrame.ExecuteJavaScript(JS, 'about:blank', 0);

end;

procedure Tfrm_servicesWhats.Timer1Timer(Sender: TObject);
begin
  Timer1.Enabled := False;
  if not(Chromium1.CreateBrowser(CEFWindowParent1)) and not(Chromium1.Initialized) then
    Timer1.Enabled := True;
end;

procedure Tfrm_servicesWhats.Timer2Timer(Sender: TObject);
var
  arq: TextFile;
  linha: string;
  JS: string;
  i: integer;
begin
  //Rotina para leitura e inject do arquivo js.abr ---- 12/10/2019 Mike
    if vAuth = true then
    begin
      AssignFile(arq, ExtractFilePath(Application.ExeName) + 'js.abr');
      // desativa a diretiva de Input
      Reset(arq);
      // Abre o arquivo texto para leitura
      // ativa a diretiva de Input
      if (IOResult <> 0) then
      begin
        showmessage('Erro na leitura do arquivo js.abr. Verifique se o arquivo existe.');
      end
      else
      begin
        // verifica se o ponteiro de arquivo atingiu a marca de final de arquivo
        while (not eof(arq)) do
        begin
          readln(arq, linha);
          //Lê linha do arquivo
          memo_js.Lines.Add(linha);
        end;
        CloseFile(arq);
      end;
      //injeta o JS principal
      JS := memo_js.Text;
      Chromium1.Browser.MainFrame.ExecuteJavaScript(JS, 'about:blank', 0);
      timer2.Enabled := false;

    end;
end;

end.
