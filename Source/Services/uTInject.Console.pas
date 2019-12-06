//TInject Criado por Mike W. Lustosa
//Códido aberto à comunidade Delphi
//mikelustosa@gmail.com

unit uTInject.Console;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, StrUtils,

  uCEFWinControl, uCEFWindowParent, uCEFChromium, uCEFChromiumCore,
  //units adicionais obrigatórias
  uTInject.Classes, uTInject, uTInject.FrmQRCode,
  uCEFInterfaces, uCEFConstants, uCEFTypes, uTInject.ConfigCEF,

  Vcl.StdCtrls, Vcl.ComCtrls, System.ImageList, Vcl.ImgList, System.JSON,
  Vcl.Buttons, Vcl.Imaging.pngimage, Rest.Json,
  Vcl.Imaging.jpeg;

  var
   vContacts :Array of String;

  const
    CEFBROWSER_CREATED          = WM_APP + $100;
    CEFBROWSER_CHILDDESTROYED   = WM_APP + $101;
    CEFBROWSER_DESTROY          = WM_APP + $102;

type
  TFrmConsole = class(TForm)
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
  protected
    // You have to handle this two messages to call NotifyMoveOrResizeStarted or some page elements will be misaligned.
    procedure WMMove(var aMessage : TWMMove); message WM_MOVE;
    procedure WMMoving(var aMessage : TMessage); message WM_MOVING;
    // You also have to handle these two messages to set GlobalCEFApp.OsmodalLoop
    procedure WMEnterMenuLoop(var aMessage: TMessage); message WM_ENTERMENULOOP;
    procedure WMExitMenuLoop(var aMessage: TMessage); message WM_EXITMENULOOP;

    procedure BrowserDestroyMsg(var aMessage : TMessage); message CEF_DESTROY;
  private
    { Private declarations }
    procedure ExecuteJS(JS: String);
    procedure LogConsoleMessage(const AMessage: String);
    procedure SetAllContacts(JsonText: String);
    procedure SetAllChats(JsonText: String);
    procedure SetUnReadMessages(JsonText: String);
    procedure SetQrCode(JsonText: String);
    procedure SetQrCodeWEB(JsonText: String);
    procedure SetBatteryLevel(JsonText: string);
    procedure loadWEBQRCode(st: string);

  public
    { Public declarations }
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
    procedure GetBatteryLevel;
    procedure monitorQRCode;
    //Para monitorar o qrcode via REST
    procedure WEBmonitorQRCode;
    procedure loadQRCode(st: string);
    procedure ReadMessages(vID: string);
    procedure ReadMessagesAndDelete(vID: string);
    procedure StartMonitor(Seconds: Integer);
    procedure StopMonitor;
  end;

var
  FrmConsole: TFrmConsole;

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

function TFrmConsole.caractersWhats(vText: string): string;
begin
  vText := StringReplace(vText, sLineBreak,'\n',[rfReplaceAll]);
  vText := StringReplace((vText), #13,'',[rfReplaceAll]);
  vText := StringReplace((vText), '"','\"',[rfReplaceAll]);
  vText := StringReplace((vText), #$A, '', [rfReplaceAll]);
  Result := vText;
end;

procedure TFrmConsole.BrowserDestroyMsg(var aMessage : TMessage);
begin
  CEFWindowParent1.Free;
end;

procedure TFrmConsole.WMMove(var aMessage : TWMMove);
begin
  inherited;
  if (Chromium1 <> nil) then Chromium1.NotifyMoveOrResizeStarted;
end;

procedure TFrmConsole.WMMoving(var aMessage : TMessage);
begin
  inherited;

  if (Chromium1 <> nil) then Chromium1.NotifyMoveOrResizeStarted;
end;

//Usado para requisições REST
procedure TFrmConsole.WEBmonitorQRCode;
const JSQrCode = 'var AQrCode = document.getElementsByTagName("img")[0].getAttribute("src");console.log(JSON.stringify({"name":"getQrCodeWEB","result":{AQrCode}}));';
begin
  if Chromium1.Browser <> nil then
    Chromium1.Browser.MainFrame.ExecuteJavaScript(JSQrCode, 'about:blank', 0);
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
  PostMessage(Handle, CEF_AFTERCREATED, 0, 0);
end;

procedure TFrmConsole.Chromium1BeforeClose(Sender: TObject;
  const browser: ICefBrowser);
begin
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
  PostMessage(Handle, CEF_DESTROY, 0, 0);
  aAction := cbaDelay;
end;

procedure TFrmConsole.Chromium1ConsoleMessage(Sender: TObject;
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
    begin
      AResponse := TResponseConsoleMessage.FromJsonString( message );

      if AResponse = nil then Exit;

      try
        try
          if(AResponse.Result <> '{"result":[]}') then
          begin
            if assigned(AResponse) then
            begin
              if AResponse.Name = 'getAllContacts' then
              begin

                 begin
                  LogConsoleMessage( PrettyJSON(AResponse.Result) );
                  SetAllContacts( AResponse.Result );
                 end;
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

              if AResponse.Name = 'getBatteryLevel' then
              begin
                if POS('undefined', AResponse.Result ) <= 0 then
                begin
                  LogConsoleMessage( PrettyJSON(AResponse.Result) );
                  SetBatteryLevel( AResponse.Result );
                end;
              end;

              if AResponse.name = 'getQrCode' then
              begin
                SetQrCode( message );
              end;

              if AResponse.name = 'getQrCodeWEB' then
              begin
                SetQrCodeWEB( message );
              end;
            end;
          end;
          finally
            FreeAndNil(AResponse);
          end;
        except
          on E:Exception do
          begin
            Application.MessageBox(PChar(E.Message),'TInject', mb_iconError + mb_ok);
            raise;
          end;
        end;
    end;
end;

procedure TFrmConsole.GetAllContacts;
const
  JS = 'window.WAPI.getAllContacts();';
begin
  Chromium1.Browser.MainFrame.ExecuteJavaScript(JS, 'about:blank', 0);
end;

procedure TFrmConsole.GetBatteryLevel;
const
  JS = 'window.WAPI.getBatteryLevel();';
begin
  Chromium1.Browser.MainFrame.ExecuteJavaScript(JS, 'about:blank', 0);
end;

procedure TFrmConsole.GetUnreadMessages;
const
  JS = 'window.WAPI.getUnreadMessages(includeMe="True", includeNotifications="True", use_unread_count="True");';
begin
  Chromium1.Browser.MainFrame.ExecuteJavaScript(JS, 'about:blank', 0);
end;

procedure TFrmConsole.GetAllChats;
const
  JS = 'window.WAPI.getAllChats();';
begin
  Chromium1.Browser.MainFrame.ExecuteJavaScript(JS, 'about:blank', 0);
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

  i := i + 1;
  if i > 3 then
  begin
    vAuth        := true;
    GlobalCEFApp.InjectWhatsApp.Auth := true
  end;
end;

procedure TFrmConsole.ExecuteJS(JS: String);
begin
  if Chromium1.Browser <> nil then
     Chromium1.Browser.MainFrame.ExecuteJavaScript(JS, 'about:blank', 0);
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

//    vBase64File.Free;
//    vFilestream.Free;
  end;
end;

procedure TFrmConsole.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  action     := cafree;
  FrmConsole := nil;
end;

procedure TFrmConsole.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  CanClose := True;

  if CanClose then
  begin
    Visible  := False;
    Chromium1.CloseBrowser(True);
  end;
end;

procedure TFrmConsole.FormCreate(Sender: TObject);
begin
  Chromium1.DefaultURL := 'https://web.whatsapp.com/';
  vAuth := false;

  if not(Chromium1.CreateBrowser(CEFWindowParent1)) then
     Timer1.Enabled := True;
  if GlobalCEFApp <> nil then
     GlobalCEFApp.Chromium :=  Chromium1;
end;

procedure TFrmConsole.FormDestroy(Sender: TObject);
begin
  PostMessage(Handle, CEFBROWSER_CHILDDESTROYED, 0, 0);
end;

procedure TFrmConsole.FormShow(Sender: TObject);
begin
  //if not(Chromium1.CreateBrowser(CEFWindowParent1)) then Timer1.Enabled := True;
end;

procedure TFrmConsole.Image1Click(Sender: TObject);
begin
  FrmConsole.Hide;
end;

procedure TFrmConsole.loadQRCode(st: string);
begin
  if assigned(FrmConsole) then
    FrmQRCode.loadQRCode(st);
end;

procedure TFrmConsole.LogConsoleMessage(const AMessage: String);
begin
  TFile.AppendAllText(
    ExtractFilePath(Application.ExeName) + 'ConsoleMessage.log',
    AMessage,
    TEncoding.ASCII);
end;

procedure TFrmConsole.monitorQRCode;
 const
   JSQrCode = 'var AQrCode = document.getElementsByTagName("img")[0].getAttribute("src");console.log(JSON.stringify({"name":"getQrCode","result":{AQrCode}}));';
begin
  if Chromium1.Browser <> nil then
      Chromium1.Browser.MainFrame.ExecuteJavaScript(JSQrCode, 'about:blank', 0);
end;

//Apenas marca como lida a mensagem
procedure TFrmConsole.ReadMessages(vID: string);
begin
 if Chromium1.Browser <> nil then
      Chromium1.Browser.MainFrame.ExecuteJavaScript( 'window.WAPI.sendSeen("'+Trim(vID)+'")', 'about:blank', 0);
end;

//Marca como lida e deleta a conversa
procedure TFrmConsole.ReadMessagesAndDelete(vID: string);
begin
  if Chromium1.Browser <> nil then
      Chromium1.Browser.MainFrame.ExecuteJavaScript('window.WAPI.sendSeen("'+Trim(vID)+'")', 'about:blank', 0);

  if Chromium1.Browser <> nil then
      Chromium1.Browser.MainFrame.ExecuteJavaScript('window.WAPI.deleteConversation("'+Trim(vID)+'")', 'about:blank', 0);
end;

procedure TFrmConsole.SendBase64(vBase64, vNum, vFileName, vText: string);
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

  freeAndNil(Base64File);
end;

procedure TFrmConsole.StartMonitor(Seconds: Integer);
begin
  ExecuteJS('startMonitor(intervalSeconds=' + IntToStr( Seconds ) + ')');
end;

procedure TFrmConsole.StopMonitor;
begin
  ExecuteJS('stopMonitor()');
end;

procedure TFrmConsole.SetAllContacts(JsonText: String);
begin
  if not Assigned(GlobalCEFApp.InjectWhatsApp) then
     Exit;

  with GlobalCEFApp.InjectWhatsApp do
  begin
    if Assigned(AllContacts) then
       AllContacts.Free;
    AllContacts := TRetornoAllContacts.FromJsonString( JsonText );

     //Dispara Notify
     if Assigned( OnGetContactList ) then
        OnGetContactList(Self);
  end;
end;

procedure TFrmConsole.SetBatteryLevel(JsonText: string);
var
  AJson: TJSONObject;
begin
  if not Assigned( GlobalCEFApp.InjectWhatsApp ) then
       Exit;

    with GlobalCEFApp.InjectWhatsApp do
    begin
      AJson := TJSonObject.ParseJSONValue(JsonText) as TJSONObject;

      AGetBatteryLevel := ( AJson.getValue('result').toJSON );

       //Dispara Notify
      if Assigned( OnGetBatteryLevel ) then
          OnGetBatteryLevel(Self);
    end;
end;

procedure TFrmConsole.loadWEBQRCode(st: string);
var
  LInput: TMemoryStream;
  LOutput: TMemoryStream;
  stl: TStringList;
begin
  LInput  := TMemoryStream.Create;
  LOutput := TMemoryStream.Create;
  try
    stl := TStringList.Create;
    stl.Add(copy(st, 23, length(st)));
    stl.SaveToStream(LInput);

    LInput.Position := 0;
    TNetEncoding.Base64.Decode( LInput, LOutput );
    LOutput.Position := 0;
    if LOutput.size > 0 then
      WEBQrCode := st;
  finally
    FreeAndNil(LInput);
    FreeAndNil(LOutput);
//   LInput.Free;
//   LOutput.Free;
  end;
end;

procedure TFrmConsole.SetQrCode(JsonText: String);
var
  LQrCode: TQrCodeClass;
  LCode :String;
begin
  if not Assigned( GlobalCEFApp.InjectWhatsApp ) then
     Exit;
  if not Assigned( FrmQRCode ) then
     Exit;

  with GlobalCEFApp.InjectWhatsApp do
  begin
    LCode :=  copy(JsonText, 42, 4);
    if (LCode = 'http') or (LCode = '/img') then
    begin
      FrmQRCode.Timer1.Enabled := false;
      FrmQRCode.close;
      exit
    end;

    LQrCode := TQrCodeClass.FromJsonString( JsonText );
    try
      _Qrcode := LQrCode.result.AQrCode;
      if assigned(FrmQRCode) then
      begin
        FrmQRCode.loadQRCode(_Qrcode);
        FrmQRCode.Image2.visible := false;
      end else
      begin
        //Caso seja solicitação via API REST
        loadWEBQRCode(_Qrcode);
      end;

      //Dispara Notify
      if Assigned( OnGetQrCode ) then
         OnGetQrCode(Self);
    finally
      FreeAndNil(LQrCode);
    end;
  end;
end;

procedure TFrmConsole.SetQrCodeWEB(JsonText: String);
var
   code: string;
begin
  if not Assigned( GlobalCEFApp.InjectWhatsApp ) then Exit;

  //if not Assigned( frm_view_qrcode ) then Exit;

  with GlobalCEFApp.InjectWhatsApp do
  begin
    code :=  copy(JsonText, 42, 4);
    if (code = 'http') or (code = '/img') then
    begin
      FrmQRCode.Timer1.Enabled := false;
      FrmQRCode.close;
      exit
    end;
    AQrCode := TQrCodeClass.FromJsonString( JsonText );
    _Qrcode := AQrCode.result.AQrCode;

    loadWEBQRCode(_Qrcode);
  end;

end;

procedure TFrmConsole.SetUnReadMessages(JsonText: String);
var
  AChats: TChatList;
begin
  if not Assigned( GlobalCEFApp.InjectWhatsApp ) then
     Exit;

  AChats := TChatList.FromJsonString( JsonText );
  try
    with GlobalCEFApp.InjectWhatsApp do
    begin
      //Dispara Notify
      if Assigned( OnGetUnReadMessages ) then
         OnGetUnReadMessages( AChats );
    end;
  finally
    AChats.Free;
  end;
end;

procedure TFrmConsole.SetAllChats(JsonText: String);
begin
  if not Assigned( GlobalCEFApp.InjectWhatsApp ) then
     Exit;

  with GlobalCEFApp.InjectWhatsApp do
  begin
    if Assigned(AllChats) then
       AllChats.Free;
    AllChats := TChatList.FromJsonString( JsonText );

     //Dispara Notify
     if Assigned( OnGetChatList ) then
        OnGetChatList(Self);
  end;
end;

procedure TFrmConsole.Send(vNum, vText: string);
begin
 vText := caractersWhats(vText);
 if Chromium1.Browser <> nil then
    Chromium1.Browser.MainFrame.ExecuteJavaScript( 'window.WAPI.sendMessageToID("'+Trim(vNum)+'","'+Trim(vText)+'")', 'about:blank', 0);
end;

procedure TFrmConsole.Timer1Timer(Sender: TObject);
begin
  Timer1.Enabled := False;
  if not(Chromium1.CreateBrowser(CEFWindowParent1)) and not(Chromium1.Initialized) then
    Timer1.Enabled := True;
end;

procedure TFrmConsole.Timer2Timer(Sender: TObject);
var
  arq: TextFile;
  linha: string;
  JS: string;
begin
  //Rotina para leitura e inject do arquivo js.abr ---- 12/10/2019 Mike
    if vAuth = true then
    begin
//      ShowMessage(GlobalCEFApp.PathInjectJS);
      AssignFile(arq, GlobalCEFApp.PathInjectJS);
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

        //injeta o JS principal
        JS := memo_js.Text;
        Chromium1.Browser.MainFrame.ExecuteJavaScript(JS, 'about:blank', 0);

        //Auto monitorar mensagens não lidas
        if GlobalCEFApp.InjectWhatsApp.Config.AutoMonitor then
          GlobalCEFApp.InjectWhatsApp.StartMonitor;

        timer2.Enabled := false;
      end;
    end;
end;

end.

