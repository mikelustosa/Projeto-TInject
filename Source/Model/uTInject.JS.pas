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


unit uTInject.JS;
//https://htmlformatter.com/

interface

uses
  System.Classes, uTInject.Classes, System.MaskUtils, Data.DB, uCSV.Import,
  FireDAC.Comp.Client, Vcl.ExtCtrls, IdHTTP;

type
    TInjectJSDefine  = class
    private
      FVersion_JS: String;
      FVersion_TInjectMin: String;
      FVersion_CEF4Min: String;
    public
      property   Version_JS         : String   read FVersion_JS;
      property   Version_TInjectMin : String   read FVersion_TInjectMin;
      property   Version_CEF4Min    : String   read FVersion_CEF4Min;
    end;



  TInjectJS  = class(TComponent)
  private
    FAutoUpdate     : Boolean;
    FJSScript       : TstringList;
    FJSURL          : String;
    FJSVersion      : String;
    FReady          : Boolean;
    FOnUpdateJS     : TNotifyEvent;
    FInjectJSDefine : TInjectJSDefine;
    FTImeOutIndy    : TTimer;
    FTimeOutGetJS   : Integer;
    _Indy           : TIdHTTP;

    Function   ReadCSV(Const PLineCab, PLineValues: String): Boolean;
    procedure  SetInjectScript(const Value: TstringList);
    function   PegarLocalJS_Designer: String;
    function   PegarLocalJS_Web: String;
    Function   AtualizarInternamente(PForma: TFormaUpdate):Boolean;
    Function   ValidaJs(Const TValor: Tstrings): Boolean;
    Procedure  LimpaConteudoSite(Var TValor: TStringList);
    Procedure  OnTimeOutIndy(Sender: TObject);

    procedure SetTimeOutGetJS(const Value: Integer);  protected
    procedure Loaded; override;
  public
    constructor Create(AOwner: TComponent); override;
    property    InjectJSDefine : TInjectJSDefine Read FInjectJSDefine;

    destructor  Destroy; override;
    Function    UpdateNow:Boolean;
    Procedure   DelFileTemp;
  published
    property   TimeOutGetJS  : Integer        Read FTimeOutGetJS    Write SetTimeOutGetJS Default 4;

    property   OnUpdateJS    : TNotifyEvent   Read FOnUpdateJS      Write FOnUpdateJS;
    property   Ready         : Boolean        read FReady;
    property   AutoUpdate    : Boolean        read FAutoUpdate      write FAutoUpdate  default True;
    property   JSURL         : String         read FJSURL;
    property   JSVersion     : String         read FJSVersion;
    property   JSScript      : TstringList    read FJSScript        Write SetInjectScript;
  end;


implementation

uses uTInject.Constant, System.SysUtils, uTInject.ExePath, Vcl.Forms,
    IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient,
  Winapi.Windows, uTInject.ConfigCEF, Vcl.IdAntiFreeze;


{ TInjectAutoUpdate }

function TInjectJS.AtualizarInternamente(PForma: TFormaUpdate): Boolean;
var
  Ltmp: String;
begin
  try
    case pforma  of
      Tup_Local:Begin
                  Ltmp := GlobalCEFApp.PathJs;
                End;

      Tup_Web:  Begin
                  if (csDesigning in ComponentState) then
                     Ltmp := PegarLocalJS_Designer  Else   //Em modo Desenvolvimento
                     Ltmp := PegarLocalJS_Web;             //Rodando.. Pega na WEB
                end;
    end;

    if Ltmp = '' then
       Exit;

    if FileExists(Ltmp) then
    Begin
      //Valida a versao
      FJSScript.LoadFromFile(Ltmp);
      if not ValidaJs(FJSScript) then
      Begin
        FJSScript.Clear;
      End else
      Begin
        FJSVersion   := FInjectJSDefine.FVersion_JS;
        if FJSVersion = '' then
           FJSScript.Clear;
      End;
    End;
  finally
    Result        := (FJSScript.Count >= TInjectJS_JSLinhasMInimas);

    if Result then
    begin
      //Atualzia o arquivo interno
      GlobalCEFApp.UpdateDateIniFile;
      if UpperCase(GlobalCEFApp.PathJs) <> UpperCase(GlobalCEFApp.PathJs) then
         FJSScript.SaveToFile(GlobalCEFApp.PathJs, TEncoding.UTF8);
      if Assigned(FOnUpdateJS) Then
         FOnUpdateJS(Self);
    end else
    begin
      FJSScript.Clear;
      FJSVersion := '';
    end;
  end;
end;

constructor TInjectJS.Create(AOwner: TComponent);
begin
  inherited;
  FTimeOutGetJS              := 4;
  FTImeOutIndy               := TTimer.Create(Nil);
  FTImeOutIndy.OnTimer       := OnTimeOutIndy;
  FTImeOutIndy.Interval      := FTimeOutGetJS * 1000;
  FTImeOutIndy.Enabled       := False;
  FJSScript                  := TstringList.create;
  FAutoUpdate                := True;
  FJSURL                     := TInjectJS_JSUrlPadrao;
  FInjectJSDefine            := TInjectJSDefine.Create;
  FReady                     := False;
end;

procedure TInjectJS.DelFileTemp;
begin
  DeleteFile(PwideChar(IncludeTrailingPathDelimiter(GetEnvironmentVariable('Temp'))+'GetTInject.tmp'));
end;

destructor TInjectJS.Destroy;
begin
  DelFileTemp;
  FreeAndNil(FTImeOutIndy);
  FreeAndNil(FInjectJSDefine);
  FreeAndNil(FJSScript);
  inherited;
end;

procedure TInjectJS.SetInjectScript(const Value: TstringList);
begin
  if (csDesigning in ComponentState) then
  Begin
    if Value.text <> FJSScript.text then
       raise Exception.Create('Não é possível modificar em Modo Designer');
  End;

  FJSScript := Value;
end;


procedure TInjectJS.SetTimeOutGetJS(const Value: Integer);
begin
  FTimeOutGetJS         := Value;
  FTImeOutIndy.Interval := FTimeOutGetJS * 1000;
end;

function TInjectJS.UpdateNow: Boolean;
begin
  if FAutoUpdate  Then
  Begin
    //Atualiza pela Web  O retorno e o SUCESSO do que esta programado para trabalhar!!
    //Se nao obter sucesso da WEB.. ele vai usar o arquivo local..
    //Se estiver tudo ok.. ele esta PRONTO
    if ( GlobalCEFApp.PathJsOverdue = False) and (FileExists(GlobalCEFApp.PathJs)) Then
    Begin
      Result      := AtualizarInternamente(Tup_Local);
    End else
    Begin
      Result      := AtualizarInternamente(Tup_Web);
      If not Result Then
         Result      := AtualizarInternamente(Tup_Local);  //Se nao consegui ele pega o arquivo Local
    end;
  End else
  Begin
    //Usando via ARQUIVO
    Result      := AtualizarInternamente(Tup_Local);
  end;
  FReady        := (FJSScript.Count >= TInjectJS_JSLinhasMInimas);
end;

function TInjectJS.ValidaJs(const TValor: Tstrings): Boolean;
var
  LVersaoCefFull:String;
begin
  Result := False;
  if Assigned(GlobalCEFApp) then
  Begin
    if GlobalCEFApp.ErrorInt Then
       Exit;
  end;

  if (TValor.Count < TInjectJS_JSLinhasMInimas) then    //nao tem linhas suficiente
     Exit;

  If Pos(AnsiUpperCase(';'),  AnsiUpperCase(TValor.Strings[0])) <= 0 then   //Nao tem a variavel
     Exit;

  If not ReadCSV(TValor.Strings[0], TValor.Strings[1]) Then
     Exit;

  If (Pos(AnsiUpperCase('!window.Store'),       AnsiUpperCase(TValor.text))     <= 0) or
     (Pos(AnsiUpperCase('window.WAPI'),         AnsiUpperCase(TValor.text))     <= 0) or
     (Pos(AnsiUpperCase('window.Store.Chat.'),  AnsiUpperCase(TValor.text))     <= 0)  then
  Begin
     Exit;
  End Else
  Begin
    if not VerificaCompatibilidadeVersao(InjectJSDefine.FVersion_TInjectMin, TInjectVersion) then
    Begin
      if Assigned(GlobalCEFApp) then
         GlobalCEFApp.SetError;
      Application.MessageBox(PWideChar(ConfigVersaoCompInvalida), PWideChar(Application.Title), MB_ICONERROR + mb_ok);
      exit;
    End;

    LVersaoCefFull :=  VersaoMinima_CF4_Major.ToString + '.' + VersaoMinima_CF4_Minor.ToString + '.' + VersaoMinima_CF4_Release.ToString;
    if not VerificaCompatibilidadeVersao(InjectJSDefine.FVersion_CEF4Min, LVersaoCefFull) then
    Begin
      if Assigned(GlobalCEFApp) then
         GlobalCEFApp.SetError;
      Application.MessageBox(PWideChar(ConfigCEF_ExceptVersaoErrada), PWideChar(Application.Title), MB_ICONERROR + mb_ok);
      exit;
    End;
    Result := true;
  End;
end;

function TInjectJS.PegarLocalJS_Designer: String;
var
  LDados: TDadosApp;
begin
  try
    LDados  := TDadosApp.Create(True);
    try
      Result  := LDados.LocalEXE;
    finally
      FreeAndNil(LDados);
    end;
  Except
    Result  := '';
  end;
end;


function TInjectJS.PegarLocalJS_Web: String;
var
  LHttp        : TIdHTTP;
  LSalvamento  : String;
  LRet         : TStringList;
  IdAntiFreeze1: TIdAntiFreeze;
begin
  LSalvamento   := IncludeTrailingPathDelimiter(GetEnvironmentVariable('Temp'))+'GetTInject.tmp';
  LRet          := TStringList.Create;
  IdAntiFreeze1 := TIdAntiFreeze.Create(nil);
  Try
    DeleteFile(PwideChar(LSalvamento));
    try
      LHttp       := TIdHTTP.Create(nil);
      _Indy       := LHttp;
      FTImeOutIndy.Enabled := True;
      LRet.text   := LHttp.Get(TInjectJS_JSUrlPadrao);
      LimpaConteudoSite(LRet);
      if not ValidaJs(LRet) Then
         LRet.Clear;
    Except
      LRet.Clear
    end;
  Finally
    FreeAndNil(IdAntiFreeze1);
    FTImeOutIndy.Enabled := False;
    if LRet.Count > 1 then
    Begin
      if not FileExists(LSalvamento) then
      Begin
        LRet.SaveToFile(LSalvamento, TEncoding.UTF8);
        Result := LSalvamento;
      End;
    End;
    FreeAndNil(LRet);
    FreeAndNil(LHttp);
  End;
end;

function TInjectJS.ReadCSV(const PLineCab, PLineValues: String): Boolean;
var
  lCab,
  LIte: String;
  LCsv : TCSVImport;
begin
  Result := False;
  LCsv   := TCSVImport.Create;
  try
    lCab := Copy(PLineCab,    3, 5000);
    LIte := Copy(PLineValues, 3, 5000);
    try
      LCsv.ImportarCSV_viaTexto(lCab + slinebreak + LIte);
      if LCsv.Registros.RecordCount > 0 Then
      begin
        InjectJSDefine.FVersion_JS         := LCsv.Registros.FieldByName('Version_JS').AsString;
        InjectJSDefine.FVersion_TInjectMin := LCsv.Registros.FieldByName('Version_TInjectMin').AsString;
        InjectJSDefine.FVersion_CEF4Min    := LCsv.Registros.FieldByName('Version_CEF4Min').AsString;
        Result := true;
      end;
    Except
    end;
  finally
    FreeAndNil(LCsv);
  end;
end;


procedure TInjectJS.LimpaConteudoSite(var TValor: TStringList);
var
  i, A : Integer;
  LAchouIni : Boolean;
begin
  LAchouIni := False;
  if Pos(AnsiLowerCase('<!DOCTYPE html>'), AnsiLowerCase(TValor.Strings[0])) > 0 Then
  Begin
    //Se veio de um site.. vai vir em HTML no CAB
    for I := 0 to TValor.Count -1 do
    Begin
      if pos(AnsiLowerCase('<div class="content">'), AnsiLowerCase(TValor.Strings[i])) > 0 then
      Begin
        // Achou o Inicio do container
        LAchouIni := True;
        for A:= i -1 downto 0 do
          TValor.Delete(A);
        Break;
      End;
    End;
  End;

  if not LAchouIni then
     Exit;

  for I := 0 to TValor.Count -1 do
  Begin
    if pos(AnsiLowerCase('</div>'), AnsiLowerCase(TValor.Strings[i])) > 0 then
    Begin
      // Achou o Inicio do container
      for A := TValor.Count -1 downto i +1 do
         TValor.Delete(A);
      Break;
    End;
  End;

  TValor.Text   := StringReplace(TValor.Text, #9,                        '    ',  [rfReplaceAll, rfIgnoreCase]);  //TAB
  TValor.Text   := StringReplace(TValor.Text, '<br>',                          '',  [rfReplaceAll, rfIgnoreCase]);
  TValor.Text   := StringReplace(TValor.Text, '</em>',                         '',  [rfReplaceAll, rfIgnoreCase]);
  TValor.Text   := StringReplace(TValor.Text, '</div>',                        '',  [rfReplaceAll, rfIgnoreCase]);
  TValor.Text   := StringReplace(TValor.Text, '<div class="content">',         '',  [rfReplaceAll, rfIgnoreCase]);
  TValor.Text   := StringReplace(TValor.Text, '&gt;',                         '>',  [rfReplaceAll, rfIgnoreCase]);
  TValor.Text   := StringReplace(TValor.Text, '&lt;',                         '<',  [rfReplaceAll, rfIgnoreCase]);
  TValor.Text   := StringReplace(TValor.Text, '&amp;',                        '&',  [rfReplaceAll, rfIgnoreCase]);
  TValor.Text   := StringReplace(TValor.Text, '<em class="text-italics">',    'i',  [rfReplaceAll, rfIgnoreCase]);

  for I := 0 to 2 do  //Linhas de comunicação com o sistemas
     TValor.Strings[i] := Trim(TValor.Strings[i]);
end;

procedure TInjectJS.Loaded;
begin
  inherited;
  UpdateNow;
end;

procedure TInjectJS.OnTimeOutIndy(Sender: TObject);
begin
  FTImeOutIndy.Enabled   := False;
  try
    if Assigned(_Indy) then
      _Indy.Disconnect(true);
  Except
  end;
end;

end.

