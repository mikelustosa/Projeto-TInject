//Recommended to set subfolders CEFLib other than root.
//Do this in your project's .DRP
//Exemple:
//program TInject-Demo;
//uses
//  Forms,
//  Windows,
//  uTInject.ConfigCEF;
//
//  {$R *.res}
//
//  CEFConfig.PATH_ROOT = 'CEF\';
//  if PATH_ROOT.StartMainProcess then
//  begin
//    Application.Initialize;
//    {$IFDEF DELPHI11_UP}
//    Application.MainFormOnTaskbar := True;
//    {$ENDIF}
//    Application.CreateForm(TfrmPrincipal, frmPrincipal);
//    Application.Run;
//  end;

unit uTInject.ConfigCEF;

interface

uses
  System.Classes,
  uCEFApplication,
  uCEFConstants;

type
  TCEFConfig = class
  private
    procedure SetDefault;
  public
  PATH_ROOT        : String;
    EnableGPU        : Boolean;
    DisableFeatures  : String;
    FrameworkDirPath : String;
    ResourcesDirPath : String;
    LocalesDirPath   : String;
    cache            : String;
    UserDataPath     : String;
    LogFile          : String;
    LogSeverity      : Boolean;
    constructor Create;
    function StartMainProcess: Boolean;
    procedure Terninate;
  end;


var
  CEFConfig: TCEFConfig;

implementation

{ TCEFConfig }

constructor TCEFConfig.Create;
begin
  SetDefault;
end;

procedure TCEFConfig.SetDefault;
begin
  //Default Values
  PATH_ROOT        := ''; //CEF\
  EnableGPU        := True;
  DisableFeatures  := 'NetworkService,OutOfBlinkCors';
  FrameworkDirPath := '';
  ResourcesDirPath := '';
  LocalesDirPath   := 'locales';
  cache            := 'cache';
  UserDataPath     := 'User Data';
  LogFile          := '';
  LogSeverity      := False;
end;

function TCEFConfig.StartMainProcess: Boolean;
begin
  GlobalCEFApp := TCefApplication.Create;
  GlobalCEFApp.EnableGPU            := EnableGPU;
  GlobalCEFApp.DisableFeatures      := DisableFeatures;
  GlobalCEFApp.FrameworkDirPath     := PATH_ROOT + FrameworkDirPath;
  GlobalCEFApp.ResourcesDirPath     := PATH_ROOT + ResourcesDirPath;
  GlobalCEFApp.LocalesDirPath       := PATH_ROOT + LocalesDirPath;
  GlobalCEFApp.cache                := PATH_ROOT + cache;
  GlobalCEFApp.UserDataPath         := PATH_ROOT + UserDataPath;

  if LogFile <> '' then
     GlobalCEFApp.LogFile           := PATH_ROOT + LogFile;

  if LogSeverity then
     GlobalCEFApp.LogSeverity       := LOGSEVERITY_INFO;

  Result := GlobalCEFApp.StartMainProcess;
end;

procedure TCEFConfig.Terninate;
begin
  if Assigned(GlobalCEFApp) then
  begin
    GlobalCEFApp.Free;
    GlobalCEFApp := nil;
  end;
end;

initialization
  if not Assigned(CEFConfig) then
     CEFConfig := TCEFConfig.Create;

finalization
  if Assigned(CEFConfig) then
     CEFConfig.Free;

end.
