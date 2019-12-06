//Recommended to set subfolders CEFLib other than root.
//Do this in your project's .DRP
//Exemple:
//program TInject-Demo;
//uses
//  Forms,
//  Windows,
//  uTInject.ConfigCEF;
//
//Begin
//  {$R *.res}
//  //Colocar arquivos CEFLib junto a pasta binária da aplicação (Nao definir ou passar vazio)
//  // GlobalCEFApp.PathFrameworkDirPath := '';
//  // GlobalCEFApp.PathResourcesDirPath := '';
//  // GlobalCEFApp.PathLocalesDirPath   := '';
//  // GlobalCEFApp.Pathcache            := '';
//  // GlobalCEFApp.PathUserDataPath     := '';
//  // GlobalCEFApp.PathLogFile          := '';
//  If not GlobalCEFApp.StartMainProcess then
//     Exit;
//  Application.Initialize;
//  {$IFDEF DELPHI11_UP}
//      Application.MainFormOnTaskbar := True;
//  {$ENDIF}
//  Application.CreateForm(TfrmPrincipal, frmPrincipal);
//  Application.Run;


///CEF DOCUMENTAÇÃO
//https://www.briskbard.com/index.php?lang=en&pageid=cef
unit uTInject.ConfigCEF;

interface

uses
  System.Classes,
  uCEFApplication,
  System.SysUtils,
  Winapi.Windows,
  uCEFConstants, uCEFChromium, Vcl.Forms, uTInject;

Const
  ConstLocalesDirPath   = 'locales';
  ConstCache            = 'cache';
  ConstUserDataPath     = 'User Data';

  ExceptNotFoundJS      = 'Arquivo JS.ABR não localizado';
  ExceptNotFoundPATH    = 'Não é possível realizar essa operação após a inicialização do componente';
  ExceptConnection      = 'Erro ao conectar com componente';

type

  TCEFConfig = class(TCefApplication)
  private
    FPathFrameworkDirPath: String;
    FPathResourcesDirPath: String;
    FPathLocalesDirPath  : String;
    FPathCache           : String;
    FPathUserDataPath    : String;
    FPathLogFile         : String;
    FPathInjectJS        : String;
    FSJFile              : String;
    FInject              : TInjectWhatsapp;
    FChromium: TChromium;
    FChromiumForm: TForm;
    FStartMainProcessTimeOut: Cardinal;
    procedure SetDefault;
    procedure SetPathInjectJS(const Value: String);
    procedure SetPathCache   (const Value: String);
    procedure SetPathFrameworkDirPath(const Value: String);
    procedure SetPathLocalesDirPath  (const Value: String);
    procedure SetPathLogFile         (const Value: String);
    procedure SetPathResourcesDirPath(const Value: String);
    procedure SetPathUserDataPath    (const Value: String);
    function  TestaOk                (const POldValue, PNewValue: String): Boolean;
    procedure SetChromium            (const Value: TChromium);
  public
    SetEnableGPU         : Boolean;
    SetDisableFeatures   : String;
    SetLogSeverity       : Boolean;
    Property InjectWhatsApp   : TInjectWhatsapp   Read FInject  Write FInject;
    property PathFrameworkDirPath : String  Read FPathFrameworkDirPath Write SetPathFrameworkDirPath;
    property PathResourcesDirPath : String  Read FPathResourcesDirPath Write SetPathResourcesDirPath;
    property PathLocalesDirPath   : String  Read FPathLocalesDirPath   Write SetPathLocalesDirPath;
    property PathCache            : String  Read FPathCache            Write SetPathCache;
    property PathUserDataPath     : String  Read FPathUserDataPath     Write SetPathUserDataPath;
    property PathLogFile          : String  Read FPathLogFile          Write SetPathLogFile;
    property PathInjectJS         : String  Read FPathInjectJS         Write SetPathInjectJS;

    Property StartMainProcessTimeOut : Cardinal    Read FStartMainProcessTimeOut Write FStartMainProcessTimeOut;

    Property    Chromium      : TChromium       Read FChromium         Write SetChromium;
    Property    ChromiumForm  : TForm           Read FChromiumForm;

    constructor Create;
    destructor  Destroy; override;
    function StartMainProcess : boolean;
    procedure FreeChromium;
  end;


var
  GlobalCEFApp: TCEFConfig = nil;


implementation

uses
  uCEFTypes;

{ TCEFConfig }

constructor TCEFConfig.Create;
begin
  inherited;
  FSJFile                   := IncludeTrailingPathDelimiter(ExtractFilePath(Application.ExeName)) + 'js.abr';
  FStartMainProcessTimeOut  := 5000; //(+- 5 Segundos)
  SetDefault;
end;

procedure TCEFConfig.SetChromium(const Value: TChromium);
Var
  LObj: TCOmponent;
begin
  if FChromium = Value then
     Exit;
  FChromium := Value;
  if FChromium = Nil then
  Begin
    FChromiumForm := Nil;
    Exit;
  End;


  //Acha o FORM que esta o componente
  try
    LObj     := FChromium;
    Repeat
      if LObj.Owner is Tform then
         FChromiumForm := Tform(LObj.Owner) else    //Achou
         LObj          := LObj.Owner                //Nao Achou entao, continua procurando
    Until FChromiumForm <> Nil;
  Except
    //Esse erro nunca deve acontecer.. o TESTADOR nao conseguiu pelo menos..
    raise Exception.Create('Erro ao localizar FORM');
  end;
end;


Procedure TCEFConfig.SetDefault;
begin
  //Default Values
//  PATH_ROOT            := IncludeTrailingPathDelimiter(ExtractFilePath(Application.ExeName));
  SetEnableGPU            := True;
  SetDisableFeatures      := 'NetworkService,OutOfBlinkCors';
  SetLogSeverity          := False;
  PathFrameworkDirPath    := '';
  PathResourcesDirPath    := '';
  PathLocalesDirPath      := '';
  Pathcache               := '';
  PathUserDataPath        := '';
  PathLogFile             := '';

  Self.FrameworkDirPath   := '';
  Self.ResourcesDirPath   := '';
  Self.LocalesDirPath     := 'locales';
  Self.cache              := 'cache';
  Self.UserDataPath       := 'User Data';
end;

Function TCEFConfig.TestaOk(const POldValue, PNewValue: String):Boolean;
begin
  if AnsiLowerCase(POldValue) = AnsiLowerCase(PNewValue) Then
  Begin
    Result := False;
    Exit;
  End;

  if Self.status = asInitialized then
     raise Exception.Create(ExceptNotFoundPATH);

  if not DirectoryExists(ExtractFilePath(PNewValue)) then
     raise Exception.Create('O Path ' + PNewValue + ' inválido');

  Result := true;
end;

procedure TCEFConfig.SetPathFrameworkDirPath(const Value: String);
begin
  if not TestaOk(FPathFrameworkDirPath, Value) Then
     Exit;
  FPathFrameworkDirPath := Value;
end;

procedure TCEFConfig.SetPathResourcesDirPath(const Value: String);
begin
  if not TestaOk(FPathResourcesDirPath, Value) Then
     Exit;
  FPathResourcesDirPath := Value;
end;

procedure TCEFConfig.SetPathLocalesDirPath(const Value: String);
begin
  if not TestaOk(FPathLocalesDirPath, Value) Then
     Exit;
  FPathLocalesDirPath := Value;
end;

procedure TCEFConfig.SetPathCache(const Value: String);
begin
  if AnsiLowerCase(FPathCache) = AnsiLowerCase(Value) Then
     Exit;


  ForceDirectories(PWideChar(ExtractFilePath(Value)));

   if not TestaOk(FPathCache, Value) Then
     Exit;
  FPathCache := Value;
end;

procedure TCEFConfig.SetPathUserDataPath(const Value: String);
begin
  if not TestaOk(FPathUserDataPath, Value) Then
     Exit;
  FPathUserDataPath := Value;
end;

function TCEFConfig.StartMainProcess: boolean;
var
  Linicio: Cardinal;
begin
  Result  := (Self.status = asInitialized);
  if (Result) Then
  Begin
    //Ja iniciada!! cai fora!!
    Exit;
  end;

  Self.EnableGPU              := SetEnableGPU;
  Self.DisableFeatures        := SetDisableFeatures;

  If PathFrameworkDirPath <> '' then
     Self.FrameworkDirPath    := PathFrameworkDirPath;
  If PathResourcesDirPath <> '' then
     Self.ResourcesDirPath    := PathResourcesDirPath;
  If PathLocalesDirPath   <> '' Then
     Self.LocalesDirPath      := PathLocalesDirPath;
  If Pathcache            <> '' then
     Self.cache               := Pathcache;
  If PathUserDataPath     <> '' then
     Self.UserDataPath        := PathUserDataPath;
  If PathLogFile          <> '' then
     Self.LogFile             := PathLogFile;
  If SetLogSeverity then
     Self.LogSeverity := LOGSEVERITY_INFO;

  If PathInjectJS   = '' Then
  Begin
    //Se nao informado!! por padrao ficara na pasta da APP
    if not FileExists(FSJFile) then
       raise Exception.Create(ExceptNotFoundJS);
    FPathInjectJS            := FSJFile;
  End;

  //Chegou aqui, é porque os PATH são validos e pode continuar
  inherited;  //Dispara a THREAD la do objeto PAI


  if Self.status <> asInitialized then
  Begin
    //estado invalido!!!! pode trer dado erro acima
    Exit;
  End;


  Linicio := GetTickCount;
  try
   if Self.status <> asInitialized then
      Self.StartMainProcess;
    while  Self.status <> asInitialized do
    Begin
      Sleep(10);
      if (GetTickCount - Linicio) >= FStartMainProcessTimeOut then
         Break;
    End;
  finally
    Result  := (Self.status = asInitialized);
    if not Result then
       raise Exception.Create(ExceptConnection);
  end;
end;

procedure TCEFConfig.SetPathLogFile(const Value: String);
begin
  if not TestaOk(FPathLogFile, Value) Then
     Exit;
  FPathLogFile := Value;
end;

procedure TCEFConfig.SetPathInjectJS(const Value: String);
begin
  if not TestaOk(FPathInjectJS, Value) Then
     Exit;
  if not FileExists(Value) then
     raise Exception.Create(ExceptNotFoundJS);

  FPathInjectJS := Value;
end;

destructor TCEFConfig.Destroy;
begin
  FreeChromium;
  inherited;
end;


procedure TCEFConfig.FreeChromium;
var
  LVar        : Boolean;
  LaAction    : TCefCloseBrowserAction;
  LaActionForm: TCloseAction;
  I: Integer;
begin
  //Se nao excecutado o SHTDOWN natural.. ele processa
  if FChromium = nil then
     Exit;
  if not Assigned(FChromium) then
     Exit;

  if FChromiumForm = nil then
     Exit;
  if not Assigned(FChromiumForm) then
     Exit;

   //manda um CLOSEForm (caso tenham esquecido)
   try
     LVar        := True;
     LaAction    := cbaDelay;
     LaActionForm:= Cafree;
     if Assigned(FChromiumForm.OnCloseQuery) then
     Begin
       //Envia os comandos
       FChromium.StopLoad;
       //Gaarante a execução de códigos obrigatorios pelo CEF
       PostMessage(FChromiumForm.Handle, CEF_DESTROY, 0, 0);
       PostMessage(FChromiumForm.Handle, $0010      , 0, 0);
       FChromium.OnClose(FChromium, FChromium.Browser,  LaAction);
       FChromium.CloseBrowser(True);

       //Executa fecgamento FORM
       FChromiumForm.OnCloseQuery(FChromiumForm, LVar);
       FChromiumForm.OnClose     (FChromiumForm, LaActionForm);
     End;
   Except
   end;
end;

initialization
  if not Assigned(GlobalCEFApp) then
     GlobalCEFApp := TCEFConfig.Create;


finalization
  if Assigned(GlobalCEFApp) then
     GlobalCEFApp.Free;
end.
