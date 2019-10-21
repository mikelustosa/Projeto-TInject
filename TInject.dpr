program TInject;
{$I cef.inc}
uses
  {$IFDEF DELPHI16_UP}
  Vcl.Forms,
  {$ELSE}
  Forms,
  Windows,
  {$ENDIF }
  uCEFApplication,
  uCEFConstants,
  u_principal in 'u_principal.pas' {frm_principal},
  UnitCEFHandlerSessionChromium in 'Services\UnitCEFHandlerSessionChromium.pas',
  UnitCEFLoadHandlerChromium in 'Services\UnitCEFLoadHandlerChromium.pas';

{$R *.res}

begin
  GlobalCEFApp := TCefApplication.Create;


  // In case you want to use custom directories for the CEF3 binaries, cache and user data.
  // If you don't set a cache directory the browser will use in-memory cache.

  //GlobalCEFApp.FrameworkDirPath     := 'BIN';
  //GlobalCEFApp.ResourcesDirPath     := 'BIN';
  //GlobalCEFApp.LocalesDirPath       := 'BIN\locales';

  // Enable hardware acceleration
  GlobalCEFApp.EnableGPU            := True;
  GlobalCEFApp.cache                := 'DATA\cache';


  //Ativa log de depuração
  //GlobalCEFApp.LogFile              := 'DATA\log';
  //GlobalCEFApp.LogSeverity          := LOGSEVERITY_VERBOSE; // use LOGSEVERITY_VERBOSE if you want more details


  //GlobalCEFApp.UserDataPath         := 'BIN\User Data';


  //Ativa escuta http na porta 8077 ex: localhost:8077
  //GlobalCEFApp.RemoteDebuggingPort := 8077;

  // Disabling some features to improve stability
  GlobalCEFApp.DisableFeatures  := 'NetworkService,OutOfBlinkCors';

  // You *MUST* call GlobalCEFApp.StartMainProcess in a if..then clause
  // with the Application initialization inside the begin..end.
  // Read this https://www.briskbard.com/index.php?lang=en&pageid=cef
  if GlobalCEFApp.StartMainProcess then
    begin
      Application.Initialize;
      {$IFDEF DELPHI11_UP}
      Application.MainFormOnTaskbar := True;
      {$ENDIF}
      Application.CreateForm(Tfrm_principal, frm_principal);
  Application.Run;
    end;

  GlobalCEFApp.Free;
  GlobalCEFApp := nil;
end.
