unit uTInject.Constant;

interface

Uses Winapi.Messages;

Const
  //Uso GLOBAL
  TInjectVersion = '1.0.0.10'; //  04/12/2019  //Alterado por Daniel Rodrigues

  CardContact           = '@c.us';
  CardGroup             = '@g.us';
  NomeArquivoInject     = 'js.abr';
  MsMaxFindJSinDesigner = 5000;

  //Usados em ConfigCEF
  ConfigCEF_ExceptNotFoundJS      = 'Arquivo ' + NomeArquivoInject + ' não localizado';
  ConfigCEF_ExceptNotFoundPATH    = 'Não é possível realizar essa operação após a inicialização do componente';
  ConfigCEF_ExceptConnection      = 'Erro ao conectar com componente';
  ConfigCEF_ExceptBrowse          = 'Erro ao criar browser';
  ConfigCEF_ExceptConnetWhats     = 'Você não está conectado ao WhatsApp';
  ConfigCEF_ExceptConsoleNaoPronto= 'Console ainda não obteve os comandos de INJECT JS';

  ConfigCEF_Path_Locales          = 'locales';
  ConfigCEF_Path_Cache            = 'cache';
  ConfigCEF_Path_UserData         = 'User Data';


  //Usado no TInjectJS
  TInjectJS_JSUrlPadrao            = 'http://www.tinject.com.br/viewtopic.php?f=7&t=9&sid=1a66463a3f4b11e30683834555f17417';
  TInjectJS_JSLinhasMInimas        = 50;


  //Usados em FrmConsole
  FrmConsole_Browser_Created       = WM_APP + $100;
  FrmConsole_Browser_ChildDestroy  = WM_APP + $101;
  FrmConsole_Browser_Destroy       = WM_APP + $102;

  FrmConsole_JS_URL                = 'https://web.whatsapp.com/';
  FrmConsole_JS_GetAllContacts     = 'window.WAPI.getAllContacts();';
  FrmConsole_JS_GetBatteryLevel    = 'window.WAPI.getBatteryLevel();';
  FrmConsole_JS_GetUnreadMessages  = 'window.WAPI.getUnreadMessages(includeMe="True", includeNotifications="True", use_unread_count="True");';
  FrmConsole_JS_GetAllChats        = 'window.WAPI.getAllChats();';
  FrmConsole_JS_WEBmonitorQRCode   = 'var AQrCode = document.getElementsByTagName("img")[0].getAttribute("src");console.log(JSON.stringify({"name":"getQrCodeWEB","result":{AQrCode}}));';
  FrmConsole_JS_monitorQRCode      = 'var AQrCode = document.getElementsByTagName("img")[0].getAttribute("src");console.log(JSON.stringify({"name":"getQrCode","result":{AQrCode}}));';
  FrmConsole_JS_StopMonitor        = 'stopMonitor()';
  FrmConsole_JS_VAR_StartMonitor   = 'startMonitor(intervalSeconds=<#TEMPO#>)';
  FrmConsole_JS_VAR_ReadMessages   = 'window.WAPI.sendSeen("<#MSG_PHONE#>")';
  FrmConsole_JS_VAR_DeleteMessages = 'window.WAPI.deleteConversation("<#MSG_PHONE#>")';
  FrmConsole_JS_VAR_SendBase64     = 'window.WAPI.sendImage("<#MSG_BASE64#>","<#MSG_PHONE#>", "<#MSG_NOMEARQUIVO#>", "<#MSG_CORPO#>")';
  FrmConsole_JS_VAR_SendMsg        = 'window.WAPI.sendMessageToID("<#MSG_PHONE#>","<#MSG_CORPO#>")';
  //FrmConsole_JS_VAR_
  //FrmConsole_JS_VAR_
  //FrmConsole_JS_
  //FrmConsole_JS_
  //FrmConsole_JS_  
  //FrmConsole_JS_
  
  Function FrmConsole_JS_AlterVar(var PScript:String;  PNomeVar: String;  Const PValor:String):String;
  

implementation

uses
  System.SysUtils, System.JSON;

Function FrmConsole_JS_AlterVar(var PScript:String;  PNomeVar: String;  Const PValor:String):String;
Begin
  //Ele pode trazer montado em PSCRIPT ou no retorno

  If PNomeVar = '' Then Exit;
  if pos('<', PNomeVar) = 0 Then
     PNomeVar := '<'+PNomeVar;
  if pos('>', PNomeVar) = 0 Then
     PNomeVar := PNomeVar + '>';
  PScript := StringReplace(PScript, PNomeVar, PValor, [rfReplaceAll, rfIgnoreCase]);
  result  := PScript;
end;




end.
