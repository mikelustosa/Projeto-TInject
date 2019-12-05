unit UCtrGlobalCEFApp;

{
Criado por DANIEL RODRIGUES   - dor_poa@hotmail.com
04/12/2019

}

//{$I cef.inc}

interface

uses
  System.IniFiles,
  System.Classes,
  uCEFTypes,
  uCEFApplication,
  uCEFChromium,
  uCEFConstants, Winapi.Messages, Vcl.Forms;

Const
   NomeDefaultIni = 'TInject.ini';
   Errormsg       = 'Caminho inválido na configuração do CEF4';
   INI_SessaoPdr  = 'CEF PATH';
   INI_ChvUser    = 'USER DATA';
   INI_ChvWork    = 'WORK';
   INI_ChvLocale  = 'LOCALE';
   INI_ChvCache   = 'CACHE';
   INI_ChvJSAbr   = 'JS ABR';
   CEF_CHILDDESTROYED   = WM_APP + $A51;

Type
  TCefInject = class;

  TCefInject_Path = class
  Private
    FOwner       : TCefInject;
    FPathNatural : String;

    FCache       : String;
    FLocale      : String;
    FWork        : String;
    FUser        : String;
    FDeuErro     : Boolean;
    FInjectJS    : String;
    procedure SetCache(const Value: String);
    procedure SetLocale(const Value: String);
    procedure SetUser(const Value: String);
    procedure SetWork(const Value: String);
    Function  TestaDir(Const Pdir:String):String;
    procedure SetJSAbr(const Value: String);
  public
    constructor Create(Var Owner: TCefInject);

    //Alteração do PATH não pode ser executado imediatamente, Será utilizado na proxima abertura
    Property Work  : String read FWork        Write SetWork;
    Property User  : String read FUser        Write SetUser;
    Property Locale: String read FLocale      Write SetLocale;
    Property Cache : String read FCache       Write SetCache;
    Property InjectJS : String read FInjectJS Write SetJSAbr;
  end;



  TCefInject = class(TCefApplication)
  Private
    FIniFile     : TiniFile;
    FPathAPP     : String;
    FCEF4Path    : TCefInject_Path;
    FStart       : Boolean;
    FStartTimeOut: Cardinal;
    FChromium    : TChromium;
//    Function  CriarFormAguarde: Tform;
    procedure SetStart(const Value: Boolean);
    Procedure TentaExecutarObrigacoesCEF;
    procedure SetChromium(const Value: TChromium);
  public
    constructor Create(PAutoStart: Boolean);
    destructor  Destroy; override;
    Property    Chromium : TChromium       Read FChromium     Write SetChromium;
    Property    Start : Boolean            Read FStart        Write SetStart;
    Property    StartTimeOut : Cardinal    Read FStartTimeOut Write FStartTimeOut;  //Se alterar qualquer valor VIA o evento nao pode AUTO START = true;
    Property    CEF4Path: TCefInject_Path  Read FCEF4Path     Write FCEF4Path;
  end;

var
  GlobalCEFApp : TCefInject = nil;

implementation

uses
  System.SysUtils, Winapi.Windows, Vcl.Dialogs, Vcl.WinXCtrls, Vcl.StdCtrls,
  Vcl.Graphics;

{ TCefInject_Path }

constructor TCefInject_Path.Create(Var Owner: TCefInject);
begin
  FOwner       := Owner;
  FDeuErro     := False;
  FPathNatural := IncludeTrailingPathDelimiter(ExtractFilePath(Application.ExeName));
  Work         := FOwner.FIniFile.ReadString(INI_SessaoPdr, INI_ChvWork,   FPathNatural);
  User         := FOwner.FIniFile.ReadString(INI_SessaoPdr, INI_ChvUser,   FPathNatural + 'User Data\');
  Locale       := FOwner.FIniFile.ReadString(INI_SessaoPdr, INI_ChvLocale, FPathNatural + 'locales\');
  Cache        := FOwner.FIniFile.ReadString(INI_SessaoPdr, INI_ChvCache,  FPathNatural + 'DATA\cache\');
  InjectJS     := FOwner.FIniFile.ReadString(INI_SessaoPdr, INI_ChvJSAbr,  FPathNatural + 'js.abr');

  if FDeuErro then
     raise Exception.Create(Errormsg);
end;



procedure TCefInject_Path.SetCache(const Value: String);
begin
  if (FCache = Value) then
     Exit;
  FCache := TestaDir(Value);

  if FOwner.FIniFile.ReadString(INI_SessaoPdr, INI_ChvCache,   '') <> FCache then
     FOwner.FIniFile.WriteString(INI_SessaoPdr, INI_ChvCache, FCache);
end;

procedure TCefInject_Path.SetJSAbr(const Value: String);
begin
  if FLocale = Value then
     Exit;
  if NOT FileExists(Value) then
     FDeuErro := True;

  if FOwner.FIniFile.ReadString(INI_SessaoPdr, INI_ChvJSAbr,   '') <> FInjectJS then
     FOwner.FIniFile.WriteString(INI_SessaoPdr, INI_ChvJSAbr, FInjectJS);
end;

procedure TCefInject_Path.SetLocale(const Value: String);
begin
  if FLocale = Value then
     Exit;
  FLocale := TestaDir(Value);
  if FOwner.FIniFile.ReadString(INI_SessaoPdr, INI_ChvWork,   '') <> FLocale then
     FOwner.FIniFile.WriteString(INI_SessaoPdr, INI_ChvLocale, FLocale);
end;

procedure TCefInject_Path.SetUser(const Value: String);
begin
  if FUser = Value then
     Exit;
  FUser := TestaDir(Value);

  if FOwner.FIniFile.ReadString(INI_SessaoPdr,  INI_ChvUser,   '') <> FUser then
     FOwner.FIniFile.WriteString(INI_SessaoPdr, INI_ChvUser , FUser);
end;

procedure TCefInject_Path.SetWork(const Value: String);
begin
  if FWork = Value then
     Exit;
  FWork := TestaDir(Value);
  if FOwner.FIniFile.ReadString(INI_SessaoPdr, INI_ChvWork,   '') <> FWork then
     FOwner.FIniFile.WriteString(INI_SessaoPdr, INI_ChvWork, FWork);
end;

function TCefInject_Path.TestaDir(const Pdir: String): String;
begin
  result := LowerCase(Trim(Pdir));
  try
    If Pdir <> '' then
    Begin
      if not DirectoryExists(ExtractFilePath(Pdir)) then
      Begin
        if Not DirectoryExists(FPathNatural) then
           FDeuErro := true Else
           result   := FPathNatural + 'BIN';
      End;
    End;
  finally
    result := LowerCase(Trim(result));
  end;
end;

{ TCefInject }



constructor TCefInject.Create(PAutoStart: Boolean);
begin
  inherited Create;
  FStart                     := False;
  FPathAPP                   := IncludeTrailingPathDelimiter(ExtractFilePath(Application.ExeName));
  FIniFile                   := TiniFile.Create(FPathAPP + NomeDefaultIni);
  FCEF4Path                  := TCefInject_Path.Create(Self);
  Self.EnableGPU             := True;
  Self.DisableFeatures       := 'NetworkService,OutOfBlinkCors';
  Self.cache                 := CEF4Path.Cache; // 'DATA\cache';
  Self.FrameworkDirPath      := CEF4Path.Work;
  Self.ResourcesDirPath      := CEF4Path.Work;
  Self.LocalesDirPath        := CEF4Path.Locale;
  Self.UserDataPath          := CEF4Path.User;
  FStartTimeOut              := 5000; //(5 segundos)
  Start                      := PAutoStart;
end;

{
function TCefInject.CriarFormAguarde: Tform;
var
  LIndicador : TActivityIndicator;
  LLabel     : TLabel;
begin
  Result                   := TForm.Create(Nil);
  Result.Height            := 150;
  Result.Width             := 300;
  Result.position          := poScreenCenter;
  Result.FormStyle         := fsStayOnTop;
  Result.BorderStyle       := bsDialog;
  Result.Caption           := 'Finalizando aplicação';
  Result.BorderIcons       := [];

  LIndicador               := TActivityIndicator.Create(Result);
  LIndicador.Parent        := Result;
  LIndicador.indicatorType := aitMomentumDots;
  LIndicador.indicatorSize := aisXLarge;
  LIndicador.left          := 10;
  LIndicador.top           := (Result.Height - LIndicador.Height) Div 2; //Centraliza o indicador

  LLabel                   := TLabel.Create(Result);
  LLabel.autoSize          := False;
  LLabel.Parent            := Result;
  LLabel.layout            := tlCenter;
  LLabel.top               := 2;
  LLabel.Height            := Result.Height - 4;
  LLabel.Left              := (LIndicador.left + LIndicador.Width) + 4;
  LLabel.Width             := Result.Width - ((LIndicador.left + LIndicador.Width) + 8);
  LLabel.Alignment         := taCenter;
  LLabel.Font.style        := [fsBold];
  LLabel.Font.size         := 12;
  LLabel.WordWrap          := true;
  LLabel.Caption           := 'Aguarde...' + slinebreak + 'Finalizando Thread com segurança';
  Result.visible           := true;
end;
}

destructor TCefInject.Destroy;
begin
  if Application.Handle > 0 Then
     TentaExecutarObrigacoesCEF;
  FreeandNil(FIniFile);
  FreeandNil(FCEF4Path);
  inherited Destroy;
end;

procedure TCefInject.SetChromium(const Value: TChromium);
begin
  if FChromium = Value then
     Exit;

  FChromium := Value;
end;

procedure TCefInject.SetStart(const Value: Boolean);
var
  Linicio: Cardinal;
begin
  if FStart = Value then
     Exit;

  try
    if Value = false then
       Exit;

    Linicio := GetTickCount;
    if Self.status <> asInitialized then
       Self.StartMainProcess;

    while  Self.status <> asInitialized do
    Begin
      Sleep(10);
      if (GetTickCount - Linicio) >= FStartTimeOut then
         Break;
    End;
  finally
    FStart  := (Self.status = asInitialized);
    if not FStart then
       raise Exception.Create('Erro ao conectar com componente');
  end;
end;

procedure TCefInject.TentaExecutarObrigacoesCEF;
var
  LFrm: Tform;
  LObj: TCOmponent;
  LVar: Boolean;
//  lAguarde : TForm;
begin
 ///Olha a merda!! trenho que marcar em vario lugar para ele ACHAR um ponto

  if FChromium = nil then
     Exit;
  if not Assigned(FChromium) then
     Exit;

//  lAguarde := CriarFormAguarde;
  try
    LFrm     := Nil;
    LObj     := FChromium;
    Repeat
      if LObj.Owner is Tform then
         LFrm := Tform(LObj.Owner) else
         LObj := LObj.Owner
    Until LFrm <> Nil;

    if (FChromium = nil) or (LFrm = nil) then
       Exit;

    if not Assigned(LFrm.OnCloseQuery) then
       Showmessage('O Formulário ' +  Lfrm.name + ' Não possui o evento ONCLOSEQUERY. Possivelmente teremos problemas ao finalizar a Aplicação') else
       LFrm.OnCloseQuery(LFrm, LVar);
  except
  end;
end;

end.
