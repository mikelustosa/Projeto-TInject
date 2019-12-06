program TInject;

uses
  {$IFDEF DELPHI16_UP}
  Vcl.Forms,
  {$ELSE}
  Forms,
  Windows,
  {$ENDIF }
  u_principal        in 'u_principal.pas' {frmPrincipal},
  uTInject           in '..\Source\Services\uTInject.pas',
  uTInject.Console   in '..\Source\Services\uTInject.Console.pas' {FrmConsole},
  uTInject.ConfigCEF in '..\Source\Services\uTInject.ConfigCEF.pas',
  uTInject.FrmQRCode in '..\Source\View\uTInject.FrmQRCode.pas'   {FrmQRCode},
  UBase64            in '..\Source\Model\UBase64.pas',
  uTInject.Classes   in '..\Source\Model\uTInject.Classes.pas',
  uTInject.Emoticons in '..\Source\Model\uTInject.Emoticons.pas';

{$R *.res}

begin

  //Colocar arquivos CEFLib junto a pasta binária da aplicação (Nao definir ou passar vazio)
  //Caso deseja informar.. segue exemplo abaixo
 {
  GlobalCEFApp.PathFrameworkDirPath := 'C:\Componentes\WhatsApp\Comp\BIN';
  GlobalCEFApp.PathResourcesDirPath := 'C:\Componentes\WhatsApp\Comp\BIN';
  GlobalCEFApp.PathLocalesDirPath   := 'C:\Componentes\WhatsApp\Comp\BIN\locales';
  GlobalCEFApp.Pathcache            := 'C:\Componentes\WhatsApp\Comp\BIN\Cache';
  GlobalCEFApp.PathUserDataPath     := 'C:\Componentes\WhatsApp\Comp\BIN\User Data';
  GlobalCEFApp.PathInjectJS         := 'C:\Componentes\WhatsApp\Repositorio\Release\Demo\BIN\js.abr';
  GlobalCEFApp.PathLogFile          := '';
 }

  If not GlobalCEFApp.StartMainProcess then
     Exit;

  Application.Initialize;
  {$IFDEF DELPHI11_UP}
      Application.MainFormOnTaskbar := True;
  {$ENDIF}
  Application.CreateForm(TfrmPrincipal, frmPrincipal);
  Application.Run;
end.
