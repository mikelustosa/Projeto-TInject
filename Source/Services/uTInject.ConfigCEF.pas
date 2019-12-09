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
  System.SysUtils,
  Winapi.Windows,
  Vcl.Forms,
  DateUtils,
  IniFiles,
  uCEFApplication, uCEFConstants,
  uCEFChromium, 

  uTInject,
  uTInject.constant ;



type

  TCEFConfig = class(TCefApplication)
  private
    FInject              : TInjectWhatsapp;
    FChromium            : TChromium;
    FChromiumForm        : TForm;
    FDefPathLocais       : TIniFile;
    Falterdo             : Boolean;


    FPathFrameworkDirPath: String;
    FPathResourcesDirPath: String;
    FPathLocalesDirPath  : String;
    FPathCache           : String;
    FPathUserDataPath    : String;
    FPathLogFile         : String;
    FPathJS              : String;
    FStartTimeOut: Cardinal;
    FErrorInt: Boolean;
    FPathJsUpdate: TdateTime;
    procedure SetDefault;
    procedure SetPathCache   (const Value: String);
    procedure SetPathFrameworkDirPath(const Value: String);
    procedure SetPathLocalesDirPath  (const Value: String);
    procedure SetPathLogFile         (const Value: String);
    procedure SetPathResourcesDirPath(const Value: String);
    procedure SetPathUserDataPath    (const Value: String);
    function  TestaOk                (POldValue, PNewValue: String): Boolean;
    procedure SetChromium            (const Value: TChromium);
    Function  VersaoCEF4Aceita: Boolean;
    Procedure  UpdateIniFile(Const PSection, PKey, PValue :String);
  public
    SetEnableGPU         : Boolean;
    SetDisableFeatures   : String;
    SetLogSeverity       : Boolean;
    Procedure  UpdateDateIniFile;
    function   StartMainProcess : boolean;
    procedure  FreeChromium;
    Procedure  SetError;

    constructor Create;
    destructor  Destroy; override;

    Function   PathJsOverdue        : Boolean;
    property   PathJsUpdate         : TdateTime         Read FPathJsUpdate;
    Property   InjectWhatsApp       : TInjectWhatsapp   Read FInject         Write FInject;
    property   PathFrameworkDirPath : String       Read FPathFrameworkDirPath Write SetPathFrameworkDirPath;
    property   PathResourcesDirPath : String       Read FPathResourcesDirPath Write SetPathResourcesDirPath;
    property   PathLocalesDirPath   : String       Read FPathLocalesDirPath   Write SetPathLocalesDirPath;
    property   PathCache            : String       Read FPathCache            Write SetPathCache;
    property   PathUserDataPath     : String       Read FPathUserDataPath     Write SetPathUserDataPath;
    property   PathLogFile          : String       Read FPathLogFile          Write SetPathLogFile;
    property   PathJs               : String       Read FPathJS;
    Property   StartTimeOut         : Cardinal     Read FStartTimeOut         Write FStartTimeOut;
    Property   Chromium             : TChromium    Read FChromium             Write SetChromium;
    Property   ChromiumForm         : TForm        Read FChromiumForm;
    Property   ErrorInt             : Boolean      Read FErrorInt;
  end;


var
  GlobalCEFApp: TCEFConfig = nil;


implementation

uses
  uCEFTypes, Vcl.Dialogs;

{ TCEFConfig }

procedure TCEFConfig.UpdateDateIniFile;
begin
  FPathJsUpdate := Now;
  UpdateIniFile('Tinject Comp', 'Ultima interação', FormatDateTime('dd/mm/yy hh:nn:ss', FPathJsUpdate));
end;

procedure TCEFConfig.UpdateIniFile(const PSection, PKey, PValue: String);
begin
  if LowerCase(FDefPathLocais.ReadString(PSection, PKey, '')) <> LowerCase(PValue) then
  Begin
    FDefPathLocais.WriteString(PSection, PKey, PValue);
    Falterdo := true;
  End;
end;

constructor TCEFConfig.Create;
Var
  FDirApp, Lx: String;
begin
  FDirApp := IncludeTrailingPathDelimiter(ExtractFilePath(Application.ExeName));
  inherited;
  FDefPathLocais       := TIniFile.create(FDirApp + NomeArquivoIni);
  FPathJS              := FDirApp + NomeArquivoInject;
  FErrorInt            := False;
  FStartTimeOut        := 5000; //(+- 5 Segundos)
  Lx                   := FDefPathLocais.ReadString('Tinject Comp', 'Ultima interação', FormatDateTime('dd/mm/yy hh:nn:ss', Now));
  FPathJsUpdate        := StrToDateTimeDef(Lx, StrTodateTime('01/01/1500 00:00'));
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
  SetDisableFeatures      := 'NetworkService,OutOfBlinkCors';
  SetEnableGPU            := FDefPathLocais.ReadBool  ('Path Defines', 'GPU',           True);
  SetLogSeverity          := FDefPathLocais.ReadBool  ('Path Defines', 'Log Severity',  False);
  PathFrameworkDirPath    := FDefPathLocais.ReadString('Path Defines', 'FrameWork', '');
  PathResourcesDirPath    := FDefPathLocais.ReadString('Path Defines', 'Binary',    '');
  PathLocalesDirPath      := FDefPathLocais.ReadString('Path Defines', 'Locales',   '');
  Pathcache               := FDefPathLocais.ReadString('Path Defines', 'Cache',     '');
  PathUserDataPath        := FDefPathLocais.ReadString('Path Defines', 'Data User', '');
  PathLogFile             := FDefPathLocais.ReadString('Path Defines', 'Log File',  '');

  Self.FrameworkDirPath   := '';
  Self.ResourcesDirPath   := '';
  Self.LocalesDirPath     := 'locales';
  Self.cache              := 'cache';
  Self.UserDataPath       := 'User Data';
end;


procedure TCEFConfig.SetError;
begin
  FErrorInt := True;
end;

function TCEFConfig.TestaOk(POldValue, PNewValue: String):Boolean;
var
  LDir : String;
begin
  if AnsiLowerCase(POldValue) = AnsiLowerCase(PNewValue) Then
  Begin
    Result := False;
    Exit;
  End;

  LDir := ExtractFilePath(PNewValue);

  if Self.status = asInitialized then
     raise Exception.Create(ConfigCEF_ExceptNotFoundPATH);

  if not DirectoryExists(LDir) then
    raise Exception.Create('O Path ' + LDir + ' inválido');

  Result := true;
end;


function TCEFConfig.VersaoCEF4Aceita: Boolean;
begin
  if CEF_SUPPORTED_VERSION_MAJOR > VersaoMinima_CF4_Major then
  Begin
    //Versao e maior!!! entaoo pode1
    Result := True;
    Exit;
  End;

  //Se chegou aki!! a versao e MENOR ou IGUAL
  //Continuar a testar!
  if (CEF_SUPPORTED_VERSION_MAJOR   < VersaoMinima_CF4_Major) or
     (CEF_SUPPORTED_VERSION_MINOR   < VersaoMinima_CF4_Minor) or
     (CEF_SUPPORTED_VERSION_BUILD   < VersaoMinima_CF4_Release) Then
    Result := False else
    Result := True;
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
  FPathLocalesDirPath   := Value;
end;

procedure TCEFConfig.SetPathCache(const Value: String);
begin
  if AnsiLowerCase(FPathCache) = AnsiLowerCase(Value) Then
     Exit;

  ForceDirectories(PWideChar(ExtractFilePath(Value)));
  if not TestaOk(FPathCache, Value) Then
     Exit;
  FPathCache            := Value;
end;

procedure TCEFConfig.SetPathUserDataPath(const Value: String);
begin
  if not TestaOk(FPathUserDataPath, Value) Then
     Exit;
  FPathUserDataPath   := Value;
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

  if not VersaoCEF4Aceita then
  Begin
    FErrorInt := true;
    Application.MessageBox(PWideChar(ConfigCEF_ExceptVersaoErrada + Chr(13) +
                           '   Requerida: ' + VersaoMinima_CF4_Major.ToString + '.' + VersaoMinima_CF4_Minor.ToString + '.' + VersaoMinima_CF4_Release.ToString + Chr(13) +
                           '            Atual: ' + CEF_SUPPORTED_VERSION_MAJOR.ToString + '.' + CEF_SUPPORTED_VERSION_MINOR.ToString + '.' + CEF_SUPPORTED_VERSION_BUILD.ToString),
    PWideChar(Application.Title), MB_ICONERROR + mb_ok);
    result := False;
    Exit;
  End;

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

  UpdateIniFile('Path Defines', 'FrameWork',     Self.FrameworkDirPath);
  UpdateIniFile('Path Defines', 'Binary',        Self.ResourcesDirPath);
  UpdateIniFile('Path Defines', 'Locales',       Self.LocalesDirPath);
  UpdateIniFile('Path Defines', 'Cache',         Self.cache);
  UpdateIniFile('Path Defines', 'Data User',     Self.UserDataPath);
  UpdateIniFile('Path Defines', 'Log File',      Self.LogFile);
  UpdateIniFile('Path Defines', 'GPU',           SetEnableGPU.ToString);
  UpdateIniFile('Path Defines', 'Log Severity',  SetLogSeverity.ToString);


  UpdateIniFile('Tinject Comp', 'TInject Versão',   TInjectVersion);
  UpdateIniFile('Tinject Comp', 'Caminho JS'    ,   TInjectJS_JSUrlPadrao);
  UpdateIniFile('Tinject Comp', 'CEF4 Versão'   ,   CEF_SUPPORTED_VERSION_MAJOR.ToString +'.'+ CEF_SUPPORTED_VERSION_MINOR.ToString +'.'+ CEF_SUPPORTED_VERSION_RELEASE.ToString +'.'+ CEF_SUPPORTED_VERSION_BUILD.ToString );
  UpdateIniFile('Tinject Comp', 'CHROME Versão' ,   CEF_CHROMEELF_VERSION_MAJOR.ToString +'.'+ CEF_CHROMEELF_VERSION_MINOR.ToString +'.'+ CEF_CHROMEELF_VERSION_RELEASE.ToString +'.'+ CEF_CHROMEELF_VERSION_BUILD.ToString );
  UpdateIniFile('Tinject Comp', 'Dlls'          ,   LIBCEF_DLL + ' / ' + CHROMEELF_DLL);
  if Falterdo then
    UpdateDateIniFile;


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
      if (GetTickCount - Linicio) >= FStartTimeOut then
         Break;
    End;
  finally
    Result  := (Self.status = asInitialized);
    if not Result then
    Begin
      Application.MessageBox(ConfigCEF_ExceptConnection, PWideChar(Application.Title), MB_ICONERROR + mb_ok);
    End;
  end;
end;

procedure TCEFConfig.SetPathLogFile(const Value: String);
begin
  if not TestaOk(FPathLogFile, Value) Then
     Exit;
  FPathLogFile := Value;
end;


destructor TCEFConfig.Destroy;
begin
  FreeandNil(FDefPathLocais);
  FreeChromium;

  inherited;
end;


procedure TCEFConfig.FreeChromium;
var
  LVar        : Boolean;
  LaAction    : TCefCloseBrowserAction;
  LaActionForm: TCloseAction;
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

function TCEFConfig.PathJsOverdue: Boolean;
begin
  Result := (MinutesBetween(Now, FPathJsUpdate) > MinutosCOnsideradoObsoletooJS)
end;

initialization
  if not Assigned(GlobalCEFApp) then
     GlobalCEFApp := TCEFConfig.Create;


finalization
  if Assigned(GlobalCEFApp) then
     GlobalCEFApp.Free;
end.
