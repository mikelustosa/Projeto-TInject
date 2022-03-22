{####################################################################################################################
                              TINJECT - Componente de comunicação (Não Oficial)
                                           www.tinject.com.br
                                            Novembro de 2019
####################################################################################################################
    Owner.....: Daniel Oliveira Rodrigues  - Dor_poa@hotmail.com     - +55 51 9.9155-9228
    Developer.: Joathan Theiller           - jtheiller@hotmail.com   -
                Mike W. Lustosa            - mikelustosa@gmail.com   - +55 81 9.9630-2385
                Robson André de Morais     - robinhodemorais@gmail.com

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
unit uTInject.languages;

interface

uses uTInject.Constant, Winapi.Windows, System.Classes;

Type

  TTranslatorInject = Class(TPersistent)
  Private
     Procedure LanguageDefault;
     procedure LanguageEnglish;

     class procedure SetResourceString(xOldResourceString: PResStringRec; xValueChanged: PChar);
    procedure LanguageFarsi;
    procedure LanguageEspanol;
  Public
    Procedure SetTranslator(Const PLanguage: TLanguageInject);
  End;


implementation
{ LTranslatorInject }


class procedure TTranslatorInject.SetResourceString(
  xOldResourceString: PResStringRec; xValueChanged: PChar);
var
  POldProtect: DWORD;
begin
  VirtualProtect(xOldResourceString, SizeOf(xOldResourceString^), PAGE_EXECUTE_READWRITE, @POldProtect);
  xOldResourceString^.Identifier := Integer(xValueChanged);
  VirtualProtect(xOldResourceString,SizeOf(xOldResourceString^),POldProtect, @POldProtect);
end;

procedure TTranslatorInject.LanguageDefault;
begin
  SetResourceString(@MSG_ConfigCEF_ExceptNotFoundPATH     , 'Não é possível realizar essa operação após a inicialização do componente');
  SetResourceString(@MSG_ConfigCEF_ExceptConnection       , 'Erro ao conectar com componente');
  SetResourceString(@MSG_ConfigCEF_ExceptBrowse           , 'Erro ao criar browser no CEF');
  SetResourceString(@MSG_ConfigCEF_ExceptConnetServ       , 'Você não está conectado ao Servidor de serviço');
  SetResourceString(@MSG_ConfigCEF_ExceptConsoleNaoPronto , 'Console ainda não obteve os comandos de INJECT JS');
  SetResourceString(@MSG_ConfigCEF_ExceptVersaoErrada     , 'Sua versão do CEF4 não é compatível, por favor, atualize suas biblioteca em https://github.com/salvadordf/CEF4Delphi' + slinebreak + 'Versão requerida: %s' + slinebreak + 'Versão identificada: %s');
  SetResourceString(@MSG_ExceptSetBatteryLow              , 'O valor deve estar entre 5 e 90');
  SetResourceString(@MSG_ExceptOnAlterQrCodeStyle         , 'Não é possível realizar essa operação após a inicialização do componente');
  SetResourceString(@MSG_ExceptConfigVersaoCompInvalida   , 'Sua versão do componente TInject não é compatível com o novo JavaScript, por favor, atualize suas biblioteca em http://www.TInject.com.br/');
  SetResourceString(@MSG_ExceptUpdate                     , 'Erro de servidor WEB. Não foi possível receber a atualização do JS.ABR');
  SetResourceString(@MSG_WarningDuplicityDetected         , 'Enviando o mesmo comando em um intervalo pequeno');
  SetResourceString(@MSG_ExceptJS_ABRUnknown              , 'Retorno JS.ABR não conhecido');
  SetResourceString(@MSG_ExceptNotAssignedOnGetQrCode     , 'OnGetQrCode não foi definido');
  SetResourceString(@Text_FrmClose_Caption                , 'Aguarde.. Finalizando o serviço..');
  SetResourceString(@Text_FrmClose_Label                  , 'Finalizando todas as threads com segurança');
  SetResourceString(@Text_FrmClose_WarningClose           , 'Deseja Finalizar a aplicação?');
  SetResourceString(@Text_FrmQRCode_CaptionStart          , 'Carregando QR Code...');
  SetResourceString(@Text_FrmQRCode_CaptionSucess         , 'Aponte seu celular agora!');
  SetResourceString(@Text_FrmQRCode_OnCLose               , 'Cancelar entrada ao Servidor de serviço?');
  SetResourceString(@MSG_ExceptPhoneNumberError           , 'Número inválido');
  SetResourceString(@MSG_ExceptAlterDesigner              , 'Não é possível modificar em Modo Designer');
  SetResourceString(@MSG_ExceptAlterInicialized           , 'Método não pode ser modificado após TInject Inicializado');
  SetResourceString(@MSG_ExceptCOntactNotFound            , 'Não existem contatos a serem exportados');
  SetResourceString(@MSG_ExceptCOntactSaveFile            , 'Não foi possivel salvar os contatos em %s');
  SetResourceString(@MSG_ExceptErrorLocateForm            , 'Erro ao localizar FORM');
  SetResourceString(@MSG_ExceptPath                       , 'O caminho %s é inválido');
  SetResourceString(@MSG_ExceptGlobalCef                  , 'Classe GLOBALCEF não definida no DPR');
  SetResourceString(@MSG_WarningClosing                   , 'Aguarde... Finalizando aplicação');
  SetResourceString(@MSG_WarningErrorFile                 , 'Erro no arquivo repassado (%s)');
  SetResourceString(@MSG_ExceptMisc                       , 'Erro Desconhecido');
  SetResourceString(@Text_FrmConsole_Caption              , 'Componente TInject Brasil');
  SetResourceString(@Text_FrmConsole_LblMsg               , 'Aguarde.. Inicializando comunicação');
  SetResourceString(@MSG_WarningClassUnknown              , 'Classe Desconhecida');
  SetResourceString(@MSG_Exceptlibeay32dll                , 'Seu computador não possui as DLLs "libeay32.dll" e "ssleay32.dll". Para continuar coloque as DLL na pasta system ou dentro do diretório da aplicação.');
  SetResourceString(@Text_Vcard_Comments1                 , 'Exportado do Componente TInject em' );
  SetResourceString(@Text_Vcard_Comments2                 , 'Contato Silenciado');
  SetResourceString(@Text_Vcard_Comments3                 , 'Capturado em:');
  SetResourceString(@MSG_WarningQrCodeStart1              , 'A sessão anterior ainda está sendo finalizada, tente novamente mais tarde');
  SetResourceString(@Text_Status_Serv_Initialized         , 'Conectado com sucesso ao Servidor de serviço');
  SetResourceString(@Text_Status_Serv_Initializing        , 'Inicializando Servidor de serviço');
  SetResourceString(@Text_Status_Serv_Disconnected        , 'Não Conectado ao Servidor de serviço e TInject');
  SetResourceString(@Text_Status_Serv_Disconnecting       , 'Desconectado do Servidor de serviço e TInject ');
  SetResourceString(@Text_Status_Serv_Connected           , 'Servidor de serviço Conectado');
  SetResourceString(@Text_Status_Serv_ConnectedDown       , 'Sessão finalizada via Celular');
  SetResourceString(@Text_Status_Serv_Connecting          , 'Aguarde, Conectando ao Servidor de serviço');
  SetResourceString(@Text_Status_Serv_ConnectingNoPhone   , 'Erro ao conectar, Telefone desligado');
  SetResourceString(@Text_Status_Serv_ConnectingReaderQR  , 'Aguardando leitura QR Code');
  SetResourceString(@Text_Status_Serv_TimeOut             , 'Erro ao conectar (TimeOut)');
  SetResourceString(@Text_Status_Serv_Destroying          , 'Destruindo e fechando Tinject');
  SetResourceString(@Text_Status_Serv_Destroy             , 'TInject finalizado');
  SetResourceString(@MSG_WarningNothingtoSend             , 'Não existe nenhum conteúdo a ser enviado na mensagem');

  SetResourceString(@MSG_Except_Data_TypeObj              , 'Tipo de objeto não é compatível');
  SetResourceString(@MSG_Except_DATA_ConnectRepass        , 'Tipo de DataSet não possui Conexão com Banco de dados');
  SetResourceString(@MSG_Except_DATA_ConnectionNull       , 'Conexão Nao vinculada');
  SetResourceString(@MSG_Except_AtribuicaoInvalida        , 'Atribuição Inválida(já esta em uso por outro objeto)');
  SetResourceString(@MSG_WarningDeveloper                 , 'Aviso ao Desenvolvedor VIA IDE');
  SetResourceString(@Text_DefaultPathDown                 , 'TInjectAnexos');
  SetResourceString(@Text_DefaultError                    , 'Erro ao criar diretório em ');
  SetResourceString(@MSG_Except_SaveAttached              , 'Erro ao salvar arquivo em anexo à mensagem');
  SetResourceString(@MSG_Except_CefNull                   , 'Componente GlobalCEFApp não foi inicializado em seu .DPR (Verifique o .DPR da aplicação DEMO para melhor entendimento)');
  SetResourceString(@Text_System_memUse                   , 'Memória usada pela Aplicação: ');
  SetResourceString(@Text_System_memTot                   , 'Memória total: ');
  SetResourceString(@Text_System_memFree                  , 'Memória física disponível: ');
  SetResourceString(@Text_System_memLoad                  , 'Mémoria Carregada: ');
  SetResourceString(@Text_FrmConfigNetWork_Caption        , 'Configuração de LAN');
  SetResourceString(@Text_FrmConfigNetWork_ProxyTypeLbl   , 'Tipo:');
  SetResourceString(@Text_FrmConfigNetWork_PrtocolLbl     , 'Protocolo:');
  SetResourceString(@Text_FrmConfigNetWork_ProxyServerLbl , 'Servidor:');
  SetResourceString(@Text_FrmConfigNetWork_ProxyPortLbl   , 'Porta:');
  SetResourceString(@Text_FrmConfigNetWork_ProxyUsernameLbl           , 'Usuário:');
  SetResourceString(@Text_FrmConfigNetWork_ProxyPasswordLbl           , 'Senha:');
  SetResourceString(@Text_FrmConfigNetWork_ProxyScriptURLLbl          , 'Script de Configuração Automática:');
  SetResourceString(@Text_FrmConfigNetWork_ProxyByPassListLbl         , 'Não usar proxy nos endereços: (use ponto-e-vírgula para separar entradas)');
  SetResourceString(@Text_FrmConfigNetWork_MaxConnectionsPerProxyLbl  , 'Número máximo de conexões por proxy:');
  SetResourceString(@Text_FrmConfigNetWork_GroupBox2                  , 'Personalização de Cabeçalhos:');
  SetResourceString(@Text_FrmConfigNetWork_HeaderNameLbl              , 'Nome "Variável":');
  SetResourceString(@Text_FrmConfigNetWork_HeaderValueLbl             , 'Valor "Variável":');
  SetResourceString(@Text_FrmConfigNetWork_BntOK                      , 'Salvar');
  SetResourceString(@Text_FrmConfigNetWork_BntCancel                  , 'Cancelar');
  SetResourceString(@Text_FrmConfigNetWork_QuestionSave               , 'Deseja realmente aplicar essas configurações?');
//  SetResourceString(@Text_FrmClose_WarningClose           , '');
//  SetResourceString(@Text_FrmClose_WarningClose           , '');
//  SetResourceString(@Text_FrmClose_WarningClose           , '');
//  SetResourceString(@Text_FrmClose_WarningClose           , '');
//  SetResourceString(@Text_FrmClose_WarningClose           , '');
//  SetResourceString(@Text_FrmClose_WarningClose           , '');
//  SetResourceString(@Text_FrmClose_WarningClose           , '');
//  SetResourceString(@Text_FrmClose_WarningClose           , '');
//  SetResourceString(@Text_FrmClose_WarningClose           , '');
//  SetResourceString(@Text_FrmClose_WarningClose           , '');
//  SetResourceString(@Text_FrmClose_WarningClose           , '');
//  SetResourceString(@Text_FrmClose_WarningClose           , '');
//  SetResourceString(@Text_FrmClose_WarningClose           , '');
//  SetResourceString(@Text_FrmClose_WarningClose           , '');
//  SetResourceString(@Text_FrmClose_WarningClose           , '');
//  SetResourceString(@Text_FrmClose_WarningClose           , '');
//  SetResourceString(@Text_FrmClose_WarningClose           , '');
//  SetResourceString(@Text_FrmClose_WarningClose           , '');
//  SetResourceString(@Text_FrmClose_WarningClose           , '');
//  SetResourceString(@Text_FrmClose_WarningClose           , '');
//  SetResourceString(@Text_FrmClose_WarningClose           , '');
//  SetResourceString(@Text_FrmClose_WarningClose           , '');
//  SetResourceString(@Text_FrmClose_WarningClose           , '');
//  SetResourceString(@Text_FrmClose_WarningClose           , '');
//  SetResourceString(@Text_FrmClose_WarningClose           , '');
//  SetResourceString(@Text_FrmClose_WarningClose           , '');
//  SetResourceString(@Text_FrmClose_WarningClose           , '');
//  SetResourceString(@Text_FrmClose_WarningClose           , '');
//  SetResourceString(@Text_FrmClose_WarningClose           , '');
//  SetResourceString(@Text_FrmClose_WarningClose           , '');
//  SetResourceString(@Text_FrmClose_WarningClose           , '');
//  SetResourceString(@Text_FrmClose_WarningClose           , '');
//  SetResourceString(@Text_FrmClose_WarningClose           , '');
//  SetResourceString(@Text_FrmClose_WarningClose           , '');
end;



procedure TTranslatorInject.LanguageEnglish;
begin
  SetResourceString(@MSG_ConfigCEF_ExceptNotFoundPATH     , 'It is not possible to perform this operation after the component has been initialized');
  SetResourceString(@MSG_ConfigCEF_ExceptConnection       , 'Error connecting with component');
  SetResourceString(@MSG_ConfigCEF_ExceptBrowse           , 'Error creating browser in CEF');
  SetResourceString(@MSG_ConfigCEF_ExceptConnetServ       , 'You are not connected to the service server');
  SetResourceString(@MSG_ConfigCEF_ExceptConsoleNaoPronto , 'Console has not yet obtained the commands for INJECT JS');
  SetResourceString(@MSG_ConfigCEF_ExceptVersaoErrada     , 'Your CEF4 version is not compatible, please update your library at https://github.com/salvadordf/CEF4Delphi' + slinebreak + 'Required version: %s' + slinebreak + 'Identified version: %s');
  SetResourceString(@MSG_ExceptSetBatteryLow              , 'Value must be between 5 and 90');
  SetResourceString(@MSG_ExceptOnAlterQrCodeStyle         , 'It is not possible to perform this operation after the component has been initialized');
  SetResourceString(@MSG_ExceptConfigVersaoCompInvalida   , 'Your version of TInject component is not compatible with the latest JavaScript version, please update your library at http://www.TInject.com.br/');
  SetResourceString(@MSG_ExceptUpdate                     , 'WEB server error. Unable to receive JS.ABR update');
  SetResourceString(@MSG_WarningDuplicityDetected         , 'Sending the same command within a short interval');
  SetResourceString(@MSG_ExceptJS_ABRUnknown              , 'Unknown JS.ABR return');
  SetResourceString(@MSG_ExceptNotAssignedOnGetQrCode     , 'OnGetQrCode has not been defined');
  SetResourceString(@Text_FrmClose_Caption                , 'Wait.. TInject is Terminating..');
  SetResourceString(@Text_FrmClose_Label                  , 'Terminating all threads safely');
  SetResourceString(@Text_FrmClose_WarningClose           , 'Do you want to close the application?');
  SetResourceString(@Text_FrmQRCode_CaptionStart          , 'Loading QRCode...');
  SetResourceString(@Text_FrmQRCode_CaptionSucess         , 'Point your phone now!');
  SetResourceString(@Text_FrmQRCode_OnCLose               , 'Cancel service server? connection');
  SetResourceString(@MSG_ExceptPhoneNumberError           , 'Invalid Number');
  SetResourceString(@MSG_ExceptAlterDesigner              , 'It is not possible to modify in Designer Mode');
  SetResourceString(@MSG_ExceptAlterInicialized           , 'Method Cannot Be Modified After TInject has been Initialized');
  SetResourceString(@MSG_ExceptCOntactNotFound            , 'There are no contacts to export');
  SetResourceString(@MSG_ExceptCOntactSaveFile            , 'Unable to save contacts to %s');
  SetResourceString(@MSG_ExceptErrorLocateForm            , 'Error locating FORM');
  SetResourceString(@MSG_ExceptPath                       , 'The path %s is invalid');
  SetResourceString(@MSG_ExceptGlobalCef                  , 'GLOBALCEF class has not been defined in DPR');
  SetResourceString(@MSG_WarningClosing                   , 'Wait... closing application');
  SetResourceString(@MSG_WarningErrorFile                 , 'Error on selected file (%s)');
  SetResourceString(@MSG_ExceptMisc                       , 'Unknown error');
  SetResourceString(@Text_FrmConsole_Caption              , 'Brazil TInject Component');
  SetResourceString(@Text_FrmConsole_LblMsg               , 'Wait .. Initializing TInject');
  SetResourceString(@MSG_WarningClassUnknown              , 'Unknown class');
  SetResourceString(@MSG_Exceptlibeay32dll                , 'Your computer does not have the "libeay32.dll" and "ssleay32.dll" DLLs. To continue place the DLLs in the system folder or in the application directory.');
  SetResourceString(@Text_Vcard_Comments1                 , 'Exported from TInject Component in: ' );
  SetResourceString(@Text_Vcard_Comments2                 , 'Contact has been silenced');
  SetResourceString(@Text_Vcard_Comments3                 , 'Captured in: ');
  SetResourceString(@MSG_WarningQrCodeStart1              , 'A previous session is still running, please try again later');
  SetResourceString(@Text_Status_Serv_Initialized         , 'TInject connected successfully to the service server');
  SetResourceString(@Text_Status_Serv_Initializing        , 'Initializing TInject to service server');
  SetResourceString(@Text_Status_Serv_Disconnected        , 'Not connected to service server and TInject');
  SetResourceString(@Text_Status_Serv_Disconnecting       , 'Disconnected from service server and TInject ');
  SetResourceString(@Text_Status_Serv_Connected           , 'Connected to service server');
  SetResourceString(@Text_Status_Serv_ConnectedDown       , 'Session terminated via Mobile');
  SetResourceString(@Text_Status_Serv_Connecting          , 'Wait, connecting to service server');
  SetResourceString(@Text_Status_Serv_ConnectingNoPhone   , 'Error connecting, phone is turned off');
  SetResourceString(@Text_Status_Serv_ConnectingReaderQR  , 'Waiting QR code scan');
  SetResourceString(@Text_Status_Serv_TimeOut             , 'Unabke to connect (TimeOut)');
  SetResourceString(@Text_Status_Serv_Destroying          , 'Destroying and closing the TInject');
  SetResourceString(@Text_Status_Serv_Destroy             , 'TInject has been terminated');
  SetResourceString(@MSG_WarningNothingtoSend             , 'There is no content to send in this message');
  SetResourceString(@MSG_Except_Data_TypeObj              , 'Object type is not compatible');
  SetResourceString(@MSG_Except_DATA_ConnectRepass        , 'DataSet Type Does Not Have Database Connection');
  SetResourceString(@MSG_Except_DATA_ConnectionNull       , 'Unlinked connection');
  SetResourceString(@MSG_Except_AtribuicaoInvalida        , 'Invalid attribution (already in use by another object)');

  SetResourceString(@MSG_WarningDeveloper                 , 'Developer notice (IDE)');
  SetResourceString(@Text_DefaultPathDown                 , 'TInjectAttachment');
  SetResourceString(@Text_DefaultError                    , 'Error creating directory in ');
  SetResourceString(@MSG_Except_SaveAttached              , 'Error saving file attached to message');
  SetResourceString(@MSG_Except_CefNull                   , 'Component GlobalCEFApp has not been initialized in your application (Check DPR of DEMO app)');
  SetResourceString(@Text_System_memUse                   , 'Total memory used by this application: ');
  SetResourceString(@Text_System_memTot                   , 'Total system memory: ');
  SetResourceString(@Text_System_memFree                  , 'Available physical memory: ');
  SetResourceString(@Text_System_memLoad                  , 'Memory load: ');
  SetResourceString(@Text_FrmConfigNetWork_Caption        , 'LAN configuration');
  SetResourceString(@Text_FrmConfigNetWork_ProxyTypeLbl   , 'Type:');
  SetResourceString(@Text_FrmConfigNetWork_ProxyServerLbl , 'Server:');
  SetResourceString(@Text_FrmConfigNetWork_PrtocolLbl     , 'Protocol:');
  SetResourceString(@Text_FrmConfigNetWork_ProxyPortLbl   , 'Port:');
  SetResourceString(@Text_FrmConfigNetWork_ProxyUsernameLbl           , 'Username:');
  SetResourceString(@Text_FrmConfigNetWork_ProxyPasswordLbl           , 'Password:');
  SetResourceString(@Text_FrmConfigNetWork_ProxyScriptURLLbl          , 'Automatic Configuration Script:');
  SetResourceString(@Text_FrmConfigNetWork_ProxyByPassListLbl         , 'Do not proxy addresses: (use semicolons to separate entries)');
  SetResourceString(@Text_FrmConfigNetWork_MaxConnectionsPerProxyLbl  , 'Maximum connections per proxy:');
  SetResourceString(@Text_FrmConfigNetWork_GroupBox2                  , ' Custom header: ');
  SetResourceString(@Text_FrmConfigNetWork_HeaderNameLbl              , 'Name "Variable":');
  SetResourceString(@Text_FrmConfigNetWork_HeaderValueLbl             , 'Value "Variable":');
  SetResourceString(@Text_FrmConfigNetWork_BntOK                      , 'Save');
  SetResourceString(@Text_FrmConfigNetWork_BntCancel                  , 'Cancel');
  SetResourceString(@Text_FrmConfigNetWork_QuestionSave               , 'Do you really want to apply these settings?');

end;


procedure TTranslatorInject.LanguageEspanol;
begin
  //Revisado por:
  // Daniel Serrano  - darnaldo2005@gmail.com - Quito / Ecuador - 03/01/2020
  SetResourceString(@MSG_ConfigCEF_ExceptNotFoundPATH     , 'No se puede realizar esta operación después de la inicialización del componente');
  SetResourceString(@MSG_ConfigCEF_ExceptConnection       , 'Error al conectar con el componente');
  SetResourceString(@MSG_ConfigCEF_ExceptBrowse           , 'Error al crear el navegador en CEF');
  SetResourceString(@MSG_ConfigCEF_ExceptConnetServ       , 'No estás conectado al servidor de servicio');
  SetResourceString(@MSG_ConfigCEF_ExceptConsoleNaoPronto , 'La consola aún no ha obtenido los comandos para INJECT JS');
  SetResourceString(@MSG_ConfigCEF_ExceptVersaoErrada     , 'Su versión de CEF4 no es compatible, actualice su biblioteca en https://github.com/salvadordf/CEF4Delphi' + slinebreak + 'Versión requerida: %s' + slinebreak + 'Versión  identificada: %s');
  SetResourceString(@MSG_ExceptSetBatteryLow              , 'El valor debe estar entre 5 y 90');
  SetResourceString(@MSG_ExceptOnAlterQrCodeStyle         , 'No se puede realizar esta operación después de la inicialización del componente');
  SetResourceString(@MSG_ExceptConfigVersaoCompInvalida   , 'Su versión del componente TInject no es compatible con el nuevo JavaScript, actualice sus bibliotecas en http://www.TInject.com.br/');
  SetResourceString(@MSG_ExceptUpdate                     , 'Error del servidor web. No se puede recibir la actualización JS.ABR');
  SetResourceString(@MSG_WarningDuplicityDetected         , 'Enviar el mismo comando en un intervalo pequeño');
  SetResourceString(@MSG_ExceptJS_ABRUnknown              , 'Devuelve JS.ABR desconocido');
  SetResourceString(@MSG_ExceptNotAssignedOnGetQrCode     , 'OnGetQrCode no se ha establecido');
  SetResourceString(@Text_FrmClose_Caption                , 'Espere... Terminando TInject..');
  SetResourceString(@Text_FrmClose_Label                  , 'Terminar todos los threads de forma segura');
  SetResourceString(@Text_FrmClose_WarningClose           , '¿Quieres terminar la aplicación?');
  SetResourceString(@Text_FrmQRCode_CaptionStart          , 'Capturando QRCode...');
  SetResourceString(@Text_FrmQRCode_CaptionSucess         , '¡Apunte su teléfono ahora!');
  SetResourceString(@Text_FrmQRCode_OnCLose               , '¿Darse de baja del servidor de servicio?');
  SetResourceString(@MSG_ExceptPhoneNumberError           , 'Número inválido');
  SetResourceString(@MSG_ExceptAlterDesigner              , 'No se puede modificar en modo de desarrollo');
  SetResourceString(@MSG_ExceptAlterInicialized           , 'El método no se puede modificar después de que TInject se haya inicializado');
  SetResourceString(@MSG_ExceptCOntactNotFound            , 'No hay contactos para exportar');
  SetResourceString(@MSG_ExceptCOntactSaveFile            , 'No se pueden guardar contactos en %s');
  SetResourceString(@MSG_ExceptErrorLocateForm            , 'Error al localizar FORM');
  SetResourceString(@MSG_ExceptPath                       , 'La ruta %s no es válida');
  SetResourceString(@MSG_ExceptGlobalCef                  , 'Clase GLOBALCEF no definida en .DPR');
  SetResourceString(@MSG_WarningClosing                   , 'Por favor espere... Finalizando la aplicación');
  SetResourceString(@MSG_WarningErrorFile                 , 'Error de archivo aprobado (%s)');
  SetResourceString(@MSG_ExceptMisc                       , 'Error desconocido');
  SetResourceString(@Text_FrmConsole_Caption              , 'Componente TInject Brasil');
  SetResourceString(@Text_FrmConsole_LblMsg               , 'Espera ... Inicializando TInject');
  SetResourceString(@MSG_WarningClassUnknown              , 'Clase desconocida');
  SetResourceString(@MSG_Exceptlibeay32dll                , 'Su computadora no tiene los archivos DLL "libeay32.dll" y "ssleay32.dll". Para continuar, coloque las DLL en la carpeta del sistema o dentro del directorio de la aplicación.');
  SetResourceString(@Text_Vcard_Comments1                 , 'Exportado desde TInject Component en' );
  SetResourceString(@Text_Vcard_Comments2                 , 'Contacto silenciado');
  SetResourceString(@Text_Vcard_Comments3                 , 'Capturado en:');
  SetResourceString(@MSG_WarningQrCodeStart1              , 'La sesión anterior aún está terminando, intente nuevamente más tarde.');
  SetResourceString(@Text_Status_Serv_Initialized         , 'TInject se conectó correctamente al servidor de servicio');
  SetResourceString(@Text_Status_Serv_Initializing        , 'Inicializando TInject al servidor de servicio');
  SetResourceString(@Text_Status_Serv_Disconnected        , 'No conectado al servicio y al servidor TInject');
  SetResourceString(@Text_Status_Serv_Disconnecting       , 'Desconectado del servidor de servicio y TInject ');
  SetResourceString(@Text_Status_Serv_Connected           , 'Servidor de servicio conectado');
  SetResourceString(@Text_Status_Serv_ConnectedDown       , 'Sesión finalizada a través del teléfono');
  SetResourceString(@Text_Status_Serv_Connecting          , 'Espera, conectando al servidor de servicio');
  SetResourceString(@Text_Status_Serv_ConnectingNoPhone   , 'Error al conectar, teléfono apagado');
  SetResourceString(@Text_Status_Serv_ConnectingReaderQR  , 'En espera a leer el código QR');
  SetResourceString(@Text_Status_Serv_TimeOut             , 'Error al conectar (TimeOut)');
  SetResourceString(@Text_Status_Serv_Destroying          , 'Destruyendo y cerrando la aplicación');
  SetResourceString(@Text_Status_Serv_Destroy             , 'TInject terminado');
  SetResourceString(@MSG_WarningNothingtoSend             , 'No hay contenido para enviar en el mensaje');
  SetResourceString(@MSG_Except_Data_TypeObj              , 'El tipo de objeto no es compatible');
  SetResourceString(@MSG_Except_DATA_ConnectRepass        , 'El tipo de conjunto de datos no tiene conexión de base de datos');
  SetResourceString(@MSG_Except_DATA_ConnectionNull       , 'Conexión no transmitida');
  SetResourceString(@MSG_Except_AtribuicaoInvalida        , 'Atribución inválida (ya está en uso por otro objeto)');
  SetResourceString(@MSG_WarningDeveloper                 , 'Aviso del desarrollador através de IDE');
  SetResourceString(@Text_System_memUse                   , 'Memoria total utilizada por esta aplicación: ');
  SetResourceString(@Text_System_memTot                   , 'Memoria total del sistema: ');
  SetResourceString(@Text_System_memFree                  , 'Memoria física disponible: ');
  SetResourceString(@Text_System_memLoad                  , 'Carga de memoria: ');
  SetResourceString(@Text_FrmConfigNetWork_Caption        , 'Configuración LAN');
  SetResourceString(@Text_FrmConfigNetWork_ProxyTypeLbl   , 'Tipo:');
  SetResourceString(@Text_FrmConfigNetWork_ProxyServerLbl , 'Servidor:');
  SetResourceString(@Text_FrmConfigNetWork_PrtocolLbl     , 'Protocolo:');
  SetResourceString(@Text_FrmConfigNetWork_ProxyPortLbl   , 'Port:');
  SetResourceString(@Text_FrmConfigNetWork_ProxyUsernameLbl           , 'Nombre usuario:');
  SetResourceString(@Text_FrmConfigNetWork_ProxyPasswordLbl           , 'Contraseña:');
  SetResourceString(@Text_FrmConfigNetWork_ProxyScriptURLLbl          , 'Script de configuración automática:');
  SetResourceString(@Text_FrmConfigNetWork_ProxyByPassListLbl         , 'No proxy direcciones: (use punto y coma para separar las entradas)');
  SetResourceString(@Text_FrmConfigNetWork_MaxConnectionsPerProxyLbl  , 'Conexiones máximas por proxy:');
  SetResourceString(@Text_FrmConfigNetWork_GroupBox2                  , ' Cabeceras personalizadas: ');
  SetResourceString(@Text_FrmConfigNetWork_HeaderNameLbl              , 'Nombre "variable":');
  SetResourceString(@Text_FrmConfigNetWork_HeaderValueLbl             , 'Valor "Variable":');
  SetResourceString(@Text_FrmConfigNetWork_BntOK                      , 'Guardar');
  SetResourceString(@Text_FrmConfigNetWork_BntCancel                  , 'Cancelar');
  SetResourceString(@Text_FrmConfigNetWork_QuestionSave               , '¿Realmente quieres aplicar esta configuración?');
end;

procedure TTranslatorInject.LanguageFarsi;
begin
//
end;

{
procedure TTranslatorInject.LanguageAfrikaans;
begin
end;
}

procedure TTranslatorInject.SetTranslator(Const PLanguage: TLanguageInject);
begin
  LanguageDefault;
  case PLanguage of
     Tl_English     : LanguageEnglish;
     TL_Farsi       : LanguageFarsi;
     Tl_Espanol     : LanguageEspanol;
  end;
end;

end.
