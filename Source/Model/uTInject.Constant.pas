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
unit uTInject.Constant;

interface

Uses Winapi.Messages, System.SysUtils, typinfo, REST.Json, StrUtils, EncdDecd;

Const
  //Uso GLOBAL
                                  //Version updates I=HIGH, II=MEDIUM, III=LOW, IV=VERY LOW
  TInjectVersion                  = '4.0.2.0'; //  01/11/2023  //Alterado por Mike Lustosa
  CardContact                     = '@c.us';
  CardGroup                       = '@g.us';
  CardList                        = '@broadcast';
  NomeArquivoInject               = 'js.abr';
  NomeArquivoIni                  = 'ConfTInject.ini';
  MsMaxFindJSinDesigner           = 15000;
  VersaoMinima_CF4_Major          = 78;
  VersaoMinima_CF4_Minor          = 3;
  VersaoMinima_CF4_Release        = 0;
  Versao0porCasas                 = 3;
  MinutosCOnsideradoObsoletooJS   = 50;
  Enter                           = sLineBreak;
  ConfigCEF_Path_Locales          = 'locales';
  ConfigCEF_Path_Cache            = 'cache';
  ConfigCEF_Path_UserData         = 'User Data';
  JsonOptionClassPadrao           = [joDateIsUTC, joDateFormatISO8601, joIgnoreEmptyStrings, joIgnoreEmptyArrays];
//  ConsoleRetornText_Disconect     = 'failed: WebSocket is closed before the connection is established';
  FrmConsole_Browser_ContextPhoneOff = '<div class="_1fpj- app-wrapper-web">';

  FrmConsole_Browser_Created            = WM_APP + $100;
  FrmConsole_Browser_Direto             = WM_APP + $101;
  TInjectJS_JSUrlPadrao                 = 'https://raw.githubusercontent.com/mikelustosa/Projeto-TInject/master/Source/JS/js.abr';
  TInjectJS_JSLinhasMInimas             = 1400;
  FrmConsole_JS_RetornoVazio            = '{"result":[]}';
  FrmConsole_JS_Ignorar                 = '{"name":"getUnreadMessages","result":"{\"result\":[]}"}';
  FrmConsole_JS_URL                     = 'https://web.whatsapp.com/';
  FrmConsole_JS_GetAllContacts          = 'window.WAPI.getAllContacts();';
  FrmConsole_JS_GetBatteryLevel         = 'window.WAPI.getBatteryLevel();';
  FrmConsole_JS_GetMyNumber             = 'getMyNumber();';
  FrmConsole_JS_GetUnreadMessages       = 'window.WAPI.getUnreadMessages(includeMe="True", includeNotifications="True", use_unread_count="True");';
  FrmConsole_JS_GetAllChats             = 'window.WAPI.getAllChats();';
  FrmConsole_JS_checkDelivered          = 'window.WAPI.getDelivered();';
  FrmConsole_JS_WEBmonitorQRCode        = 'try {let AQrCode = document.getElementsByTagName("canvas")[0].toDataURL("image/png");console.log(JSON.stringify({"name":"getQrCodeWEB","result":{AQrCode}}));}catch(e){console.log("carregando qrcode...")}';
  FrmConsole_JS_refreshOnlyQRCode       = '';
  FrmConsole_JS_monitorQRCode           = 'try {let AQrCode = document.getElementsByTagName("canvas")[0].toDataURL("image/png");console.log(JSON.stringify({"name":"getQrCode","result":{AQrCode}}));}catch(e){console.log("Carregando qrcode web")}';
  FrmConsole_JS_StopMonitor             = 'stopMonitor();';
  FrmConsole_JS_IsLoggedIn              = 'WAPI.isLoggedIn();';
  FrmConsole_JS_VAR_StartMonitor        = 'startMonitor(intervalSeconds=<#TEMPO#>)';
  FrmConsole_JS_VAR_ReadMessages        = 'window.WAPI.sendSeen("<#MSG_PHONE#>")';
  FrmConsole_JS_VAR_DeleteMessages      = 'window.WAPI.deleteConversation("<#MSG_PHONE#>")';
  FrmConsole_JS_VAR_SendBase64          = 'window.WAPI.sendImage("<#MSG_BASE64#>","<#MSG_PHONE#>", "<#MSG_NOMEARQUIVO#>", "<#MSG_CORPO#>")';
  FrmConsole_JS_VAR_SendSurvey          = 'window.WAPI.sendPool("<#MSG_GROUPID#>","<#MSG_TITLE#>", <#MSG_SURVEY#>)';
  FrmConsole_JS_VAR_SendMsg             = 'window.WAPI.sendMessageToID("<#MSG_PHONE#>","<#MSG_CORPO#>")';
  FrmConsole_JS_VAR_SendButtons         = 'window.WAPI.sendButtons("<#MSG_PHONE#>","<#MSG_TITLE#>",<#MSG_BUTTONS#>,"<#MSG_FOOTER#>")';
  FrmConsole_JS_VAR_SendButtonList      = 'window.WAPI.sendOptions("<#MSG_PHONE#>","<#MSG_TITLE1#>","","<#MSG_TITLE2#>","<#MSG_TITLEBUTTON#>",<#MSG_OPTIONS#>)';
  FrmConsole_JS_VAR_SendLinkPreview     = 'window.WAPI.sendLinkWithAutoPreview("<#MSG_PHONE#>", "<#MSG_LINK#>", "<#MSG_CORPO#>")';
  FrmConsole_JS_VAR_SendLocation        = 'window.WAPI.sendLocation("<#MSG_PHONE#>",{lat:"<#MSG_LAT#>",lng:"<#MSG_LNG#>",name:"<#MSG_NAME#>",address:"<#MSG_ADDRESS#>",});';
  FrmConsole_JS_VAR_Logout              = 'localStorage.clear(); location.reload();';
  FrmConsole_JS_VAR_SendContact         = 'window.WAPI.sendContact("<#MSG_PHONE_DEST#>", "<#MSG_PHONE#>")';
  FrmConsole_JS_VAR_CheckIsValidNumber  = 'window.WAPI.isValidNumber("<#MSG_PHONE#>")'+
                                        '.then(result => SetConsoleMessage("GetCheckIsValidNumber", JSON.stringify(result)))'+
                                        '.catch(error => SetConsoleMessage("GetCheckIsValidNumber", JSON.stringify(error)));';
  FrmConsole_JS_VAR_IsConnected         = 'window.WAPI.isConnected();';

  FrmConsole_JS_VAR_ProfilePicThumb     = 'function convertImgToBase64URL(url, callback, outputFormat){ '+

                                          'var img = new Image();          '+
                                          'img.crossOrigin = "Anonymous";  '+
                                          'img.onload = function(){        '+
                                          '    var canvas = document.createElement("CANVAS"), '+
                                          '    ctx = canvas.getContext("2d"), dataURL;        '+
                                          '    canvas.height = img.height;                    '+
                                          '    canvas.width = img.width;                      '+
                                          '    ctx.drawImage(img, 0, 0);                      '+
                                          '    dataURL = canvas.toDataURL(outputFormat);      '+
                                          '    callback(dataURL);                             '+
                                          '    canvas = null;                                 '+
                                          '};                                                 '+
                                          'img.src = url;                                     '+
                                          '};';


  FrmConsole_JS_VAR_getProfilePicThumb      = 'window.WAPI.teste("<#PROFILE_PICTHUMB_URL#>");';
  FrmConsole_JS_VAR_CreateGroup             = 'window.WAPI.createGroup("<#GROUP_NAME#>", "<#PARTICIPANT_NUMBER#>");setTimeout(function(){ window.WAPI.getAllGroups(); }, 3000);';
  Frmconsole_JS_consoleClear                = 'console.clear();';
  FrmConsole_JS_GetAllGroups                = 'window.WAPI.getAllGroups();';
  FrmConsole_JS_GetGroupAdmins              = 'window.WAPI.getGroupAdmins("<#GROUP_ID#>");';
  FrmConsole_JS_VAR_listGroupContacts       = 'window.WAPI.getGroupParticipantIDs("<#GROUP_ID#>");';
  FrmConsole_JS_VAR_groupAddParticipant     = 'window.WAPI.addParticipant("<#GROUP_ID#>", "<#PARTICIPANT_NUMBER#>");setTimeout(function(){ window.WAPI.getGroupParticipantIDs("<#GROUP_ID#>"); }, 3000);';
  FrmConsole_JS_VAR_groupRemoveParticipant  = 'window.WAPI.removeParticipant("<#GROUP_ID#>", "<#PARTICIPANT_NUMBER#>");setTimeout(function(){ window.WAPI.getGroupParticipantIDs("<#GROUP_ID#>"); }, 3000);';
  FrmConsole_JS_VAR_groupPromoteParticipant = 'window.WAPI.promoteParticipant("<#GROUP_ID#>", "<#PARTICIPANT_NUMBER#>");setTimeout(function(){ window.WAPI.getGroupAdmins("<#GROUP_ID#>"); }, 3000);';
  FrmConsole_JS_VAR_groupDemoteParticipant  = 'window.WAPI.demoteParticipant("<#GROUP_ID#>", "<#PARTICIPANT_NUMBER#>");setTimeout(function(){ window.WAPI.getGroupAdmins("<#GROUP_ID#>"); }, 3000);';
  FrmConsole_JS_VAR_groupLeave              = 'window.WAPI.leaveGroup("<#GROUP_ID#>");';
  FrmConsole_JS_VAR_groupDelete             = 'window.WAPI.deleteConversation("<#GROUP_ID#>");setTimeout(function(){ window.WAPI.getAllGroups(); }, 3000);';
  FrmConsole_JS_VAR_groupJoinViaLink        = 'window.WAPI.joinGroupViaLink("<#GROUP_LINK#>");setTimeout(function(){ window.WAPI.getAllGroups(); }, 3000);';
  FrmConsole_JS_VAR_setProfileName          = 'window.WAPI.setMyName("<#NEW_NAME#>");';
  FrmConsole_JS_VAR_setMyStatus             = 'window.WAPI.setMyStatus("<#NEW_STATUS#>");';
  FrmConsole_JS_VAR_getStatus               = 'window.WAPI.getStatus("<#PHONE#>");';
  FrmConsole_JS_VAR_ClearChat               = 'window.WAPI.clearChat("<#PHONE#>");';
  FrmConsole_JS_VAR_getMe                   = 'window.WAPI.getMe();';
  FrmConsole_JS_VAR_getGroupInviteLink      = 'window.WAPI.getGroupInviteLink("<#GROUP_ID#>");';
  FrmConsole_JS_VAR_removeGroupInviteLink   = 'window.WAPI.revokeGroupInviteLink("<#GROUP_ID#>");';
  FrmConsole_JS_VAR_checkNumberStatus       = 'window.WAPI.checkNumberStatus("<#PHONE#>");';


resourcestring
  MSG_ConfigCEF_ExceptNotFoundJS       = '';
  MSG_ConfigCEF_ExceptNotFoundPATH     = '';
  MSG_ConfigCEF_ExceptConnection       = '';
  MSG_ConfigCEF_ExceptBrowse           = '';
  MSG_ConfigCEF_ExceptConnetServ       = '';
  MSG_ConfigCEF_ExceptConsoleNaoPronto = '';
  MSG_ConfigCEF_ExceptVersaoErrada     = '';
  MSG_ConfigCEF_ExceptVersaoErrada_L2  = '';
  MSG_ExceptSetBatteryLow              = '';
  MSG_ExceptOnAlterQrCodeStyle         = '';
  MSG_ExceptConfigVersaoCompInvalida   = '';
  MSG_ExceptUpdate                     = '';
  MSG_WarningDuplicityDetected         = '';
  MSG_ExceptJS_ABRUnknown              = '';
  MSG_ExceptNotAssignedOnGetQrCode     = '';
  Text_FrmClose_Caption                = '';
  Text_FrmClose_Label                  = '';
  Text_FrmClose_WarningClose           = '';
  Text_FrmQRCode_CaptionStart          = '';
  Text_FrmQRCode_CaptionSucess         = 'Gerando QRCode...';
  Text_FrmQRCode_OnCLose               = '';
  MSG_ExceptPhoneNumberError           = '';
  MSG_ExceptAlterDesigner              = '';
  MSG_ExceptCOntactNotFound            = '';
  MSG_ExceptCOntactSaveFile            = '';
  MSG_ExceptAlterInicialized           = '';
  MSG_ExceptErrorLocateForm            = '';
  MSG_ExceptPath                       = '';
  MSG_ExceptGlobalCef                  = '';
  MSG_WarningClosing                   = '';
  MSG_ExceptMisc                       = '';
  Text_FrmConsole_Caption              = 'TInject component';
  Text_FrmConsole_LblMsg               = '';
  MSG_WarningClassUnknown              = '';
  MSG_Exceptlibeay32dll                = '';
  Text_Vcard_Comments1                 = '';
  Text_Vcard_Comments2                 = '';
  Text_Vcard_Comments3                 = '';
  MSG_WarningQrCodeStart1              = '';
  Text_Status_Serv_Initialized         = '';
  Text_Status_Serv_Initializing        = '';
  Text_Status_Serv_Disconnected        = '';
  Text_Status_Serv_Disconnecting       = '';
  Text_Status_Serv_Connected           = '';
  Text_Status_Serv_ConnectedDown       = '';
  Text_Status_Serv_Connecting          = '';
  Text_Status_Serv_ConnectingNoPhone   = '';
  Text_Status_Serv_ConnectingReaderQR  = '';
  Text_Status_Serv_TimeOut             = '';
  Text_Status_Serv_Destroying          = '';
  Text_Status_Serv_Destroy             = '';
  MSG_WarningNothingtoSend             = '';
  MSG_WarningErrorFile                 = '';
  MSG_Except_Data_TypeObj              = '';
  MSG_Except_DATA_ConnectRepass        = '';
  MSG_Except_DATA_ConnectionNull       = '';
  MSG_Except_AtribuicaoInvalida        = '';
  MSG_WarningDeveloper                 = '';
  Text_DefaultPathDown                 = '';
  Text_DefaultError                    = '';
  MSG_Except_SaveAttached              = '';
  MSG_Except_CefNull                   = '';
  Text_System_memUse                   = '';
  Text_System_memTot                   = '';
  Text_System_memFree                  = '';
  Text_System_memLoad                  = '';

  Text_FrmConfigNetWork_Caption        = '';
  Text_FrmConfigNetWork_ProxyTypeLbl   = '';
  Text_FrmConfigNetWork_ProxyServerLbl = '';
  Text_FrmConfigNetWork_ProxyPortLbl   = '';
  Text_FrmConfigNetWork_ProxyUsernameLbl            = '';
  Text_FrmConfigNetWork_ProxyPasswordLbl            = '';
  Text_FrmConfigNetWork_ProxyScriptURLLbl           = '';
  Text_FrmConfigNetWork_ProxyByPassListLbl          = '';
  Text_FrmConfigNetWork_MaxConnectionsPerProxyLbl   = '';
  Text_FrmConfigNetWork_GroupBox2        = '';
  Text_FrmConfigNetWork_HeaderNameLbl    = '';
  Text_FrmConfigNetWork_HeaderValueLbl   = '';
  Text_FrmConfigNetWork_BntOK            = '';
  Text_FrmConfigNetWork_BntCancel        = '';
  Text_FrmConfigNetWork_QuestionSave     = '';
  Text_FrmConfigNetWork_PrtocolLbl       = '';
//  Text_FrmQRCode_OnCLose                 = '';
//  Text_FrmQRCode_OnCLose                 = '';
//  Text_FrmQRCode_OnCLose                 = '';
//  Text_FrmQRCode_OnCLose                 = '';
//  Text_FrmQRCode_OnCLose                 = '';
//  Text_FrmQRCode_OnCLose                 = '';
//  Text_FrmQRCode_OnCLose                 = '';
//  Text_FrmQRCode_OnCLose                 = '';
//  Text_FrmQRCode_OnCLose                 = '';
//  Text_FrmQRCode_OnCLose                 = '';
//  Text_FrmQRCode_OnCLose                 = '';
//  Text_FrmQRCode_OnCLose                 = '';
//  Text_FrmQRCode_OnCLose                 = '';
//  Text_FrmQRCode_OnCLose                 = '';
//  Text_FrmQRCode_OnCLose                 = '';

type
    TLanguageInject       = (TL_Portugues_BR=0,  TL_English=1, TL_Espanol=2, TL_Farsi=3);
    TConnectionDBType     = (TCon_None=0, TCon_Memory=1,  TCon_FireDAC=2, TCon_DBExpress=3, TCon_ADO=4);

    TFormQrCodeType       = (Ft_Desktop=0,       Ft_Http=1,    Ft_None=2);  //Form ou RestDataWare
    TSendFile_Image       = (Tsf_Jpg=0, Tsf_Jpeg=1, Tsf_Tif=2, Tsf_Ico=3, Tsf_Bmp=4, Tsf_Png=5, Tsf_Raw=6);
    TSendFile_Audio       = (Tsf_Mp3=0);

    TStatusType           = (Inject_Initialized,            Inject_Initializing,       Inject_Destroying,      Inject_Destroy,
                             Server_Disconnected,           Server_Disconnecting,
                             Server_Connected,              Server_ConnectedDown,
                             Server_Connecting,             Server_ConnectingNoPhone,
                             Server_ConnectingReaderCode,   Server_TimeOut
                            );

    TTypeHeader = (Th_None = 0,
                   //Eventos de Retornos
                   Th_GetAllContacts=1,         Th_GetAllChats=2,                      Th_GetUnreadMessages=3,    Th_getUnreadMessagesFromMe=4, Th_GetAllGroupContacts=5,
                   Th_GetBatteryLevel=6,        Th_GetQrCodeForm=7,                    Th_GetQrCodeWEB=8,
                   Th_GetMyNumber=9,            Th_OnChangeConnect=10,                  Th_getIsDelivered=11,
                   Th_GetReserv2=12,            Th_GetReserv3=13,                      Th_GetReserv4=14,
                   Th_GetReserv5=15,            Th_GetReserv6=16,                      Th_GetReserv7=17,
                   Th_GetCheckIsValidNumber=18, Th_GetCheckIsConnected=19,             Th_GetProfilePicThumb=20,  Th_getAllGroups=21, Th_getAllGroupAdmins=22,

                   //Eventos Conexao
                   Th_Disconnected=23,          Th_Disconnecting=24,                   Th_Connected=25,
                   Th_ConnectedDown=26,         Th_Connecting=27,                      Th_ConnectingFt_Desktop=28,
                   Th_ConnectingFt_HTTP=29,     Th_ConnectingNoPhone=30,               Th_Destroy=31,
                   Th_Destroying=32,            Th_NewSyncContact=33,                  Th_Initializing=34,
                   Th_Initialized=35,           Th_Abort=36,                           Th_ForceDisconnect=37,
                   Th_AlterConfig=38,

                   Th_GetStatusMessage=39, Th_GetGroupInviteLink=40, Th_GetMe=41, Th_NewCheckIsValidNumber=42, Th_GetIncomingCall=43
                   );

    Function   VerificaCompatibilidadeVersao(PVersaoExterna:String; PversaoInterna:String):Boolean;
    Function   FrmConsole_JS_AlterVar(var PScript:String;  PNomeVar: String;  Const PValor:String):String;
    function   StrToTypeHeader(PText: string): TTypeHeader;
    Procedure  SleepNoFreeze(PTimeOut:Integer);
    Function   StrExtFile_Base64Type(PFileName: String): String;
    function   FileToBase64_(const fileName: string): string;

implementation

uses
  System.JSON, System.Classes, Vcl.Dialogs, Vcl.Forms, Winapi.Windows;


Function VerificaCompatibilidadeVersao(PVersaoExterna:String; PversaoInterna:String):Boolean;
Var
  LVersionInt : TStringList;
  LVersionExt : TStringList;
  LInt, LExt: String;
  I: Integer;
Begin
  LVersionInt := TStringList.Create;
  LVersionExt := TStringList.Create;
  try
    PVersaoExterna   := StringReplace(PVersaoExterna, ',', '.',    [rfReplaceAll, rfIgnoreCase]);
    PversaoInterna   := StringReplace(PversaoInterna, ',', '.',    [rfReplaceAll, rfIgnoreCase]);

    ExtractStrings(['.'],[], PWideChar(PversaoInterna), LVersionInt);
    ExtractStrings(['.'],[], PWideChar(PVersaoExterna), LVersionExt);
    for I := 0 to LVersionInt.count -1 do
      LInt := LInt + Copy(LVersionInt.Strings[i] + '00000000', 0, Versao0porCasas);

    for I := 0 to LVersionExt.count -1 do
      LExt := LExt + Copy(LVersionExt.Strings[i] + '00000000', 0, Versao0porCasas);

  finally
    Result := Not (StrToInt64def(LExt, 0) > StrToInt64def(LInt, 0));
    FreeAndNil(LVersionInt);
    FreeAndNil(LVersionExt);
  end;
End;


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


Procedure SleepNoFreeze(PtimeOut:Integer);
var
  LIni: Cardinal;
  Lpass : Integer;
Begin
  LIni := GetTickCount;
  Lpass:= 0;
  Application.ProcessMessages;
  Repeat
    inc(Lpass);
    Sleep(1);
    if (Lpass > 10) then
    Begin
      Lpass:= 0;
      Application.ProcessMessages;
    end;
  Until (GetTickCount - LIni) >= Cardinal(PtimeOut) ;
End;


function FileToBase64_(const fileName: string): string;
var
  FileStream: TFileStream;
  MemoryStream: TMemoryStream;
  mimeType: string;
begin
  FileStream := TFileStream.Create(fileName, fmOpenRead);
  MemoryStream := TMemoryStream.Create;
  try
    MemoryStream.CopyFrom(FileStream, 0);
    mimeType := StrExtFile_Base64Type(fileName);

    Result := mimeType + EncodeBase64(MemoryStream.Memory, MemoryStream.Size);
  finally
    MemoryStream.Free;
    FileStream.Free;
  end;
end;


Function  StrExtFile_Base64Type(PFileName: String): String;
var
  I: Integer;
  LExt: String;
  Ltmp: String;
Begin
  LExt   := LowerCase(Copy(ExtractFileExt(PFileName),2,50));

  case AnsiIndexStr(LExt, ['mp4', 'mp3', 'ogg', 'avi', 'mpeg']) of
      0: begin result := 'data:application/mp4;base64,'; exit; end;
      1: begin result := 'data:audio/mp3;base64,'; exit; end;
      2: begin result := 'data:audio/ogg;base64,'; exit; end;
      3: begin result := 'data:video/avi;base64,'; exit; end;
      4: begin result := 'data:video/mpeg;base64,'; exit; end;
    end;

  Result := 'data:application/';

  try
    for I := 0 to 6 do
    begin
      Ltmp := LowerCase(Copy(GetEnumName(TypeInfo(TSendFile_Image), ord(TSendFile_Image(i))), 3, 50));
      if pos(LExt, Ltmp) > 0 Then
      Begin
        Result := 'data:image/';
        Exit;
      end
    end;

    for I := 0 to 0 do
    begin
      Ltmp := LowerCase(Copy(GetEnumName(TypeInfo(TSendFile_Audio), ord(TSendFile_Audio(i))), 3, 50));
      if pos(LExt, Ltmp) > 0 Then
      Begin
        Result := 'data:audio/';
        Exit;
      end
    end;

  finally
     Result :=  Result + LExt + ';base64,' ;
  end;
End;

function StrToTypeHeader(PText: string): TTypeHeader;
const LmaxCount = 43;
var
  I: Integer;
  LNome: String;
Begin
  PText   := LowerCase(Trim(Ptext));
  Result  := Th_None;
  if Trim(PText) = '' then
     Exit;
  for I := 0 to LmaxCount do
  Begin
    LNome   := LowerCase(GetEnumName(TypeInfo(TTypeHeader), ord(TTypeHeader(i))));
    LNome   := Copy(LNome, 4, 50); //tira o TH_
    if PText = LNome then
    Begin
      Result := TTypeHeader(i);
      break;
    End;
  End;

  if Result  = Th_None Then
  Begin
    //Acha por semelhança
    for I := 0 to LmaxCount do
    Begin
      LNome   := LowerCase(GetEnumName(TypeInfo(TTypeHeader), ord(TTypeHeader(i))));
      if POs(LowerCase(PText), LNome) > 0 then
      Begin
        Result := TTypeHeader(i);
        break;
      End;
    End;
  End;
End;



end.


