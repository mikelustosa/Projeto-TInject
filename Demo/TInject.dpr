program TInject;

uses
  Vcl.Forms,
  Windows,
  uTInject.ConfigCEF,
  u_principal               in 'u_principal.pas' {frmPrincipal};
//  UBase64                   in '..\Source\Model\UBase64.pas',
//  uCSV.Import               in '..\Source\Model\uCSV.Import.pas',
//  uTInject.AdjustNumber     in '..\Source\Model\uTInject.AdjustNumber.pas',
//  uTInject.Classes          in '..\Source\model\uTInject.Classes.pas',
//  uTInject.Config           in '..\Source\Model\uTInject.Config.pas',
//  uTInject.Constant         in '..\Source\model\uTInject.Constant.pas',
//  uTInject.Diversos         in '..\Source\Model\uTInject.Diversos.pas',
//  uTInject.Emoticons        in '..\Source\Model\uTInject.Emoticons.pas',
//  uTInject.ExePath          in '..\Source\Model\uTInject.ExePath.pas',
//  uTInject.JS               in '..\Source\Model\uTInject.JS.pas',
//  uTInject.Phonebook        in '..\Source\Model\uTInject.Phonebook.pas',
//  uTInject.FrmQRCode        in '..\Source\View\uTInject.FrmQRCode.pas' {FrmQRCode},
//  uTInject.FrmConfigNetWork in '..\Source\View\uTInject.FrmConfigNetWork.pas' {FrmConfigNetWork},
//  uTInject.Console          in '..\Source\View\uTInject.Console.pas' {FrmConsole},
//  uTInject.ControlSend      in '..\Source\Services\uTInject.ControlSend.pas',
//  uTInject.languages        in '..\Source\Services\uTInject.languages.pas',
//  uTInject                  in '..\Source\Services\uTInject.pas',
//  uTInject.IA.RecentList    in '..\Source\Services\uTInject.IA.RecentList.pas',
//  uTInject.DbConnect        in '..\Source\Services\uTInject.DbConnect.pas',
//  uTInject.IA               in '..\Source\Services\uTInject.IA.pas';

{$R *.res}

begin
  {##########################################################################################
  Colocar arquivos CEFLib junto a pasta binária da aplicação (Nao definir ou passar vazio)
  Caso deseja informar.. segue exemplo abaixo
  ##########################################################################################}
  {
  GlobalCEFApp.PathLogFile          := '';
  GlobalCEFApp.PathFrameworkDirPath := 'C:\Componentes\WhatsApp\Comp\BIN';
  GlobalCEFApp.PathResourcesDirPath := 'C:\Componentes\WhatsApp\Comp\BIN';
  GlobalCEFApp.PathLocalesDirPath   := 'C:\Componentes\WhatsApp\Comp\BIN\locales';
  GlobalCEFApp.Pathcache            := 'C:\Componentes\WhatsApp\Comp\BIN\Cache';
  GlobalCEFApp.PathUserDataPath     := 'C:\Componentes\WhatsApp\Comp\BIN\User Data';
  //Forma 1 GlobalCEFApp.Pathxx       := '';                      //Irá procura procurar o Arquivo PADRAO no mesmo local do EXE
  //Forma 2 GlobalCEFApp.Pathxx       := 'C:\Componentes\demo\bin'; //<-  NOME do ARQUIVO INFORMADO
  //Forma 3 GlobalCEFApp.Pathxx       := 'BIN';                     //<-  NOME do ARQUIVO INFORMADO
  //Forma 4 GlobalCEFApp.Pathx         := '..\Source\;              //<-  NOME do ARQUIVO INFORMADO
  //Exemplo se aplica para todos os PATH
  }

  If not GlobalCEFApp.StartMainProcess then
     Exit;

  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmPrincipal, frmPrincipal);
  Application.Run;

end.
