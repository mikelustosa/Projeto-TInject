program TInject;

uses
  {$IFDEF DELPHI16_UP}
  Vcl.Forms,
  {$ELSE}
  Forms,
  Windows,
  {$ENDIF }
  UCtrGlobalCEFApp,
  u_principal      in 'u_principal.pas' {frmPrincipal};

{$R *.res}

begin
  GlobalCEFApp := TCefInject.Create(True);

  Application.Initialize;
  {$IFDEF DELPHI11_UP}
     Application.MainFormOnTaskbar := True;
  {$ENDIF}
  Application.CreateForm(TfrmPrincipal, frmPrincipal);
  Application.Run;

  GlobalCEFApp.Free;
end.
