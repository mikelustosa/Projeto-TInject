{####################################################################################################################
                              TINJECT - Componente de comunicação (Não Oficial)
                                           www.tinject.com.br
                                            Novembro de 2019
####################################################################################################################
    Owner.....: Joathan Theiller           - jtheiller@hotmail.com   -
    Developer.: Mike W. Lustosa            - mikelustosa@gmail.com   - +55 81 9.9630-2385
                Daniel Oliveira Rodrigues  - Dor_poa@hotmail.com     - +55 51 9.9155-9228
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
  uTInject.constant, Vcl.ExtCtrls, uTInject.Classes ;



type

  TCEFConfig = class(TCefApplication)
  private
    FChromium            : TChromium;
    FChromiumForm        : TForm;
    FIniFIle             : TIniFile;
    Falterdo             : Boolean;
    FInject              : TInject;

    FPathFrameworkDirPath: String;
    FPathResourcesDirPath: String;
    FPathLocalesDirPath  : String;
    FPathCache           : String;
    FPathUserDataPath    : String;
    FPathLogFile         : String;
    FPathJS              : String;
    FStartTimeOut        : Cardinal;
    FErrorInt            : Boolean;
    FPathJsUpdate        : TdateTime;
    FLogConsole          : String;
    FHandleFrm           : HWND;
    FInDesigner          : Boolean;
    FLogConsoleActive    : Boolean;
    FDirIni              : String;
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
    procedure SetLogConsole(const Value: String);
    procedure SetLogConsoleActive(const Value: Boolean);
  public
    SetEnableGPU         : Boolean;
    SetDisableFeatures   : String;
    SetLogSeverity       : Boolean;
    Procedure UpdateIniFile(Const PSection, PKey, PValue :String);

    Procedure  UpdateDateIniFile;
    function   StartMainProcess : boolean;
    Procedure  SetError;

    constructor Create;
    destructor  Destroy; override;

    Function   PathJsOverdue        : Boolean;
    property   PathJsUpdate         : TdateTime    Read FPathJsUpdate;
    property   IniFIle              : TIniFile     Read FIniFIle              Write FIniFIle;
    property   PathFrameworkDirPath : String       Read FPathFrameworkDirPath Write SetPathFrameworkDirPath;
    property   PathResourcesDirPath : String       Read FPathResourcesDirPath Write SetPathResourcesDirPath;
    property   PathLocalesDirPath   : String       Read FPathLocalesDirPath   Write SetPathLocalesDirPath;
    property   PathCache            : String       Read FPathCache            Write SetPathCache;
    property   PathUserDataPath     : String       Read FPathUserDataPath     Write SetPathUserDataPath;
    property   PathLogFile          : String       Read FPathLogFile          Write SetPathLogFile;
    property   PathJs               : String       Read FPathJS;
    property   LogConsole           : String       Read FLogConsole           Write SetLogConsole;
    property   LogConsoleActive     : Boolean      Read FLogConsoleActive     Write SetLogConsoleActive;
    Property   StartTimeOut         : Cardinal     Read FStartTimeOut         Write FStartTimeOut;
    Property   Chromium             : TChromium    Read FChromium             Write SetChromium;
    Property   ChromiumForm         : TForm        Read FChromiumForm;
    Property   ErrorInt             : Boolean      Read FErrorInt;
    Property   DirINI               : String       Read FDirINI               Write FDirINI;
  end;


   procedure DestroyGlobalCEFApp;

var
  GlobalCEFApp: TCEFConfig = nil;


implementation

uses
  uCEFTypes, Vcl.Dialogs, uTInject.Diversos;

{ TCEFConfig }

procedure DestroyGlobalCEFApp;
begin
  if (GlobalCEFApp <> nil) then
      FreeAndNil(GlobalCEFApp);
end;

procedure TCEFConfig.UpdateDateIniFile;
begin
  FPathJsUpdate := Now;
  UpdateIniFile('Tinject Comp', 'Ultima interação', FormatDateTime('dd/mm/yy hh:nn:ss', FPathJsUpdate));
end;

procedure TCEFConfig.UpdateIniFile(const PSection, PKey, PValue: String);
begin
  if FInDesigner then
     Exit;

  if (LowerCase(FIniFIle.ReadString(PSection, PKey, '')) <> LowerCase(PValue)) or
     (FIniFIle.ValueExists(PSection, PKey) = false) Then
   Begin
    FIniFIle.WriteString(PSection, PKey, PValue);
    Falterdo := true;
  End;
end;

constructor TCEFConfig.Create;
begin
  FInDesigner          := True;
  FDirIni := '';
  inherited;
end;

procedure TCEFConfig.SetChromium(const Value: TChromium);
Var
  LObj: TCOmponent;
begin
  //Acha o FORM que esta o componente
  try
    if FChromium = Value then
       Exit;

    FChromium := Value;
    if FChromium = Nil then
    Begin
      FChromiumForm := Nil;
      Exit;
    End;

    try
      LObj     := FChromium;
      Repeat
        if LObj.Owner is Tform then
        Begin
          FChromiumForm := Tform(LObj.Owner);
          FHandleFrm    := FChromiumForm.Handle;
          if FChromiumForm.Owner is TInject then
             FInject := TInject(FChromiumForm.Owner);
        end else    //Achou
        begin
          LObj          := LObj.Owner                //Nao Achou entao, continua procurando
        end;
      Until FChromiumForm <> Nil;
    Except
      raise Exception.Create(MSG_ExceptErrorLocateForm);
    end;
  Except
     //Esse erro nunca deve acontecer.. o TESTADOR nao conseguiu pelo menos..
  end;
end;


Procedure TCEFConfig.SetDefault;
begin
  if not FInDesigner then //padrão aqui é if not FInDesigner - Mike 28/12/2020
  Begin
    FIniFIle.WriteString ('Informacao', 'Aplicativo vinculado',    Application.ExeName);
    FIniFIle.WriteBool   ('Informacao', 'Valor True',    True);
    FIniFIle.WriteBool   ('Informacao', 'Valor False',   False);

    SetDisableFeatures      := 'NetworkService,OutOfBlinkCors';
    SetEnableGPU            := FIniFIle.ReadBool  ('Path Defines', 'GPU',                 True);
    SetLogSeverity          := FIniFIle.ReadBool  ('Path Defines', 'Log Severity',        False);
    LogConsoleActive        := FIniFIle.ReadBool  ('Path Defines', 'Log Console Active',  False);
    PathFrameworkDirPath    := FIniFIle.ReadString('Path Defines', 'FrameWork', '');
    PathResourcesDirPath    := FIniFIle.ReadString('Path Defines', 'Binary',    '');
    PathLocalesDirPath      := FIniFIle.ReadString('Path Defines', 'Locales',   '');
    Pathcache               := FIniFIle.ReadString('Path Defines', 'Cache',     '');
    PathUserDataPath        := FIniFIle.ReadString('Path Defines', 'Data User', '');
    PathLogFile             := FIniFIle.ReadString('Path Defines', 'Log File',  '');
    LogConsole              := FIniFIle.ReadString('Path Defines', 'Log Console',  '');
    if LogConsole = '' then
       LogConsole            := IncludeTrailingPathDelimiter(ExtractFilePath(Application.ExeName))+'LogTinject\';
  End;
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

procedure TCEFConfig.SetLogConsole(const Value: String);
begin
  if Value <> '' then
  Begin
    FLogConsole := IncludeTrailingPathDelimiter(ExtractFilePath(Value));
    ForceDirectories(FLogConsole);
  end else
  Begin
    FLogConsole := '';
  End;
end;

procedure TCEFConfig.SetLogConsoleActive(const Value: Boolean);
begin
  FLogConsoleActive := Value;
  if (LogConsoleActive) and (LogConsole <> '') then
     ForceDirectories(LogConsole);
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
     raise Exception.Create(MSG_ConfigCEF_ExceptNotFoundPATH);
  if not DirectoryExists(LDir) then
    raise Exception.Create(Format(MSG_ExceptPath, [LDir]));
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
  LVReque, LVerIdent: String;
  FDirApp, Lx: String;
begin
  //ta lento pq estou conectado em um tunel estou daki ao meu pc.;. do meu pc a
  Result  := (Self.status = asInitialized);
  if (Result) Then
  Begin
    //Ja iniciada!! cai fora!!
    Exit;
  end;

  FInDesigner          := False;
  FDirApp              := IncludeTrailingPathDelimiter(ExtractFilePath(Application.ExeName));

  if FDirIni = '' then
    FDirIni := FDirApp;

  FIniFIle             := TIniFile.create(FDirIni + NomeArquivoIni);
  Lx                   := FIniFIle.ReadString('Tinject Comp', 'Ultima interação', '01/01/1500 05:00:00');
  FPathJS              := FDirApp + NomeArquivoInject;
  FErrorInt            := False;
  FStartTimeOut        := 5000; //(+- 5 Segundos)
  FPathJsUpdate        := StrToDateTimeDef(Lx, StrTodateTime('01/01/1500 00:00'));
  SetDefault;

  if not VersaoCEF4Aceita then
  Begin
    FErrorInt := true;
    LVReque   := IntToStr(VersaoMinima_CF4_Major)      + '.' + IntToStr(VersaoMinima_CF4_Minor)      + '.' + IntToStr(VersaoMinima_CF4_Release);
    LVerIdent := IntToStr(CEF_SUPPORTED_VERSION_MAJOR) + '.' + IntToStr(CEF_SUPPORTED_VERSION_MINOR) + '.' + IntToStr(CEF_SUPPORTED_VERSION_BUILD);

    Application.MessageBox(PWideChar(Format(MSG_ConfigCEF_ExceptVersaoErrada, [LVReque, LVerIdent])),
                           PWideChar(Application.Title), MB_ICONERROR + mb_ok
                          );
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
  DestroyApplicationObject   := true;

  UpdateIniFile('Path Defines', 'FrameWork',     Self.FrameworkDirPath);
  UpdateIniFile('Path Defines', 'Binary',        Self.ResourcesDirPath);
  UpdateIniFile('Path Defines', 'Locales',       Self.LocalesDirPath);
  UpdateIniFile('Path Defines', 'Cache',         Self.cache);
  UpdateIniFile('Path Defines', 'Data User',     Self.UserDataPath);
  UpdateIniFile('Path Defines', 'Log File',      Self.LogFile);
  UpdateIniFile('Path Defines', 'Log Console',   LogConsole);

  FIniFIle.WriteBool('Path Defines', 'GPU',                  SetEnableGPU);
  FIniFIle.WriteBool('Path Defines', 'Log Severity',         SetLogSeverity);
  FIniFIle.WriteBool('Path Defines', 'Log Console Active',   LogConsoleActive);

  UpdateIniFile('Tinject Comp', 'TInject Versão',   TInjectVersion);
  UpdateIniFile('Tinject Comp', 'Caminho JS'    ,   TInjectJS_JSUrlPadrao);
  UpdateIniFile('Tinject Comp', 'CEF4 Versão'   ,   IntToStr(CEF_SUPPORTED_VERSION_MAJOR) +'.'+ IntToStr(CEF_SUPPORTED_VERSION_MINOR)  +'.'+ IntToStr(CEF_SUPPORTED_VERSION_RELEASE) +'.'+ IntToStr(CEF_SUPPORTED_VERSION_BUILD));
  UpdateIniFile('Tinject Comp', 'CHROME Versão' ,   IntToStr(CEF_CHROMEELF_VERSION_MAJOR) +'.'+ IntToStr(CEF_CHROMEELF_VERSION_MINOR)  +'.'+ IntToStr(CEF_CHROMEELF_VERSION_RELEASE) +'.'+ IntToStr(CEF_CHROMEELF_VERSION_BUILD));
  UpdateIniFile('Tinject Comp', 'Dlls'          ,   LIBCEF_DLL + ' / ' + CHROMEELF_DLL);
  if Falterdo then
    UpdateDateIniFile;


  //Chegou aqui, é porque os PATH são validos e pode continuar
  inherited;  //Dispara a THREAD la do objeto PAI

  if Self.status <> asInitialized then
    Exit; //estado invalido!!!! pode trer dado erro acima

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
       Application.MessageBox(PWideChar(MSG_ConfigCEF_ExceptConnection), PWideChar(Application.Title), MB_ICONERROR + mb_ok);
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
  if not FInDesigner then
     FreeandNil(FIniFIle);
  inherited;
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
