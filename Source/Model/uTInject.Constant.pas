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
unit uTInject.Constant;

interface

Uses Winapi.Messages, System.SysUtils;

Const
  //Uso GLOBAL
  TInjectVersion                  = '1.0.0.11'; //  04/12/2019  //Alterado por Daniel Rodrigues
  CardContact                     = '@c.us';
  CardGroup                       = '@g.us';
  NomeArquivoInject               = 'js.abr';
  NomeArquivoIni                  = 'ConfTinject.ini';
  MsMaxFindJSinDesigner           = 5000;
  VersaoMinima_CF4_Major          = 78;
  VersaoMinima_CF4_Minor          = 3;
  VersaoMinima_CF4_Release        = 0;

  Versao0porCasas                 = 3;
  MinutosCOnsideradoObsoletooJS   = 50;
  ConfigCEF_Path_Locales          = 'locales';
  ConfigCEF_Path_Cache            = 'cache';
  ConfigCEF_Path_UserData         = 'User Data';

  //Usados em ConfigCEF
  ConfigCEF_ExceptNotFoundJS      = 'Arquivo ' + NomeArquivoInject + ' não localizado';
  ConfigCEF_ExceptNotFoundPATH    = 'Não é possível realizar essa operação após a inicialização do componente';
  ConfigCEF_ExceptConnection      = 'Erro ao conectar com componente';
  ConfigCEF_ExceptBrowse          = 'Erro ao criar browser';
  ConfigCEF_ExceptConnetWhats     = 'Você não está conectado ao WhatsApp';
  ConfigCEF_ExceptConsoleNaoPronto= 'Console ainda não obteve os comandos de INJECT JS';
  ConfigCEF_ExceptVersaoErrada    = 'Sua versão do CEF4 não é compatível, por favor, atualize suas biblioteca em https://github.com/salvadordf/CEF4Delphi';
  ConfigVersaoCompInvalida        = 'Sua versão do componente Tinject não é compatível com o novo JavaScript, por favor, atualize suas biblioteca em http://www.tinject.com.br/';

  //Usado no TInjectJS
  TInjectJS_JSUrlPadrao            = 'http://www.tinject.com.br/viewtopic.php?f=3&t=10&p=17&sid=84550ac7f5d0134a129eb73144943991#p17';
  TInjectJS_JSLinhasMInimas        = 1400;

  //Usados em FrmConsole
  FrmConsole_Browser_Created       = WM_APP + $100;
  FrmConsole_Browser_ChildDestroy  = WM_APP + $101;
  FrmConsole_Browser_Destroy       = WM_APP + $102;

  FrmConsole_JS_URL                = 'https://web.whatsapp.com/';
  FrmConsole_JS_GetAllContacts     = 'window.WAPI.getAllContacts();';
  FrmConsole_JS_GetBatteryLevel    = 'window.WAPI.getBatteryLevel();';
  FrmConsole_JS_GetMyNumber        = 'getMyNumber();';
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
  
  Function VerificaCompatibilidadeVersao(PVersaoExterna:String; PversaoInterna:String):Boolean;
  Function FrmConsole_JS_AlterVar(var PScript:String;  PNomeVar: String;  Const PValor:String):String;

implementation

uses
  System.JSON, System.Classes;


Function VerificaCompatibilidadeVersao(PVersaoExterna:String; PversaoInterna:String):Boolean;
Var
  Lob1 : TStringList;
  Lob2 : TStringList;
  I : Integer;
  lVersao1, Lversao2: String;
Begin
  Result := False;
  lVersao1       := StringReplace(PVersaoExterna, ',', '.',    [rfReplaceAll, rfIgnoreCase]);
  Lversao2       := StringReplace(PversaoInterna, ',', '.',    [rfReplaceAll, rfIgnoreCase]);

  Lob1 := TStringList.Create;
  Lob2 := TStringList.Create;
  try
    Lob1.Delimiter      := '.';
    Lob2.Delimiter      := '.';
    Lob1.DelimitedText  := lVersao1;
    Lob2.DelimitedText  := Lversao2;
    for I := 0 to Lob1.Count -1 do
    Begin
      try// 1     5
        if StrToIntDef(Lob1.Strings[i], 0) > StrToIntDef(Lob2.Strings[i], -2)  then
           Exit;
      Except
        Exit;
      end;
    End;
    Result := True;
  finally
    FreeAndNil(Lob1);
    FreeAndNil(Lob2);
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


end.


