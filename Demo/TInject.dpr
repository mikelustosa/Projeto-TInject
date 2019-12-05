program TInject;

uses
  {$IFDEF DELPHI16_UP}
    Vcl.Forms,
  {$ELSE}
    Forms,
    Windows,
  {$ENDIF }
  u_principal                   in 'u_principal.pas' {frmPrincipal},
  u_servicesWhats               in '..\..\Source\Services\u_servicesWhats.pas' {frm_servicesWhats},
  uTInject                      in '..\..\Source\Services\uTInject.pas',
  u_view_qrcode                 in '..\..\Source\View\u_view_qrcode.pas' {frm_view_qrcode},
  UBase64                       in '..\Source\Model\UBase64.pas',
  uClasses                      in '..\Source\Model\uClasses.pas',
  uTInject.Emoticons            in '..\Source\Model\uTInject.Emoticons.pas',
  uTInject.ConfigCEF            in '..\Source\Services\uTInject.ConfigCEF.pas';

{$R *.res}

begin

  //Colocar arquivos CEFLib junto a pasta binária da aplicação (Nao definir ou passar vazio)
  // GlobalCEFApp.PathFrameworkDirPath := '';
  // GlobalCEFApp.PathResourcesDirPath := '';
  // GlobalCEFApp.PathLocalesDirPath   := '';
  // GlobalCEFApp.Pathcache            := '';
  // GlobalCEFApp.PathUserDataPath     := '';
  // GlobalCEFApp.PathLogFile          := '';
  If not GlobalCEFApp.StartMainProcess then
     Exit;
  
  Application.Initialize;
  {$IFDEF DELPHI11_UP}
      Application.MainFormOnTaskbar := True;
  {$ENDIF}
  Application.CreateForm(TfrmPrincipal, frmPrincipal);
  Application.Run;
end.
