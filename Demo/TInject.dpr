program TInject;
{$I cef.inc}
uses
  {$IFDEF DELPHI16_UP}
  Vcl.Forms,
  {$ELSE}
  Forms,
  Windows,
  {$ENDIF }
  uTInject.ConfigCEF,
  u_principal in 'u_principal.pas' {frmPrincipal};

{$R *.res}

begin
  //Colocar arquivos CEFLib junto a pasta binária da aplicação (Nao definir ou passar vazio)
  CEFConfig.PATH_ROOT := '';

  //Colocar arquivos CEFLib em subpasta CEF na raiz da demo
  //CEFConfig.PATH_ROOT := 'CEF\'

  //Colocar arquivos CEFLib em pasta fixa especifica (unica autenciacao)
  //CEFConfig.PATH_ROOT := 'C:\CEF\'

  if CEFConfig.StartMainProcess then
  begin
    Application.Initialize;
    {$IFDEF DELPHI11_UP}
    Application.MainFormOnTaskbar := True;
    {$ENDIF}
    Application.CreateForm(TfrmPrincipal, frmPrincipal);
    Application.Run;
  end;
end.
