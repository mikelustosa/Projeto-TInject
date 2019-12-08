unit uTInject.JS;

interface

uses
  System.Classes, uTInject.Classes, System.MaskUtils;

type

  TInjectJS  = class(TComponent)
  private
    FAutoUpdate   : Boolean;
    FInjectScript : TstringList;
    FInjectURL    : String;
    FInjectVersion: String;
    FInjectLocal  : String;

    FLastUpdate   : TdateTime;
    FReady        : Boolean;
    procedure  SetInjectScript(const Value: TstringList);
    Function   GetVersaoJS:String;
    function   PegarLocalJS_Designer: String;
    function   PegarLocalJS_Web: String;
    Function   AtualizarInternamente(PForma: TFormaUpdate):Boolean;
    Function   ValidaJs(Const TValor: Tstrings): Boolean;
    Procedure  LimpaConteudoSite(Var TValor: TStringList);
  protected
    procedure Loaded; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    Function    UpdateNow:Boolean;
    property    LastUpdate   : TdateTime      read FLastUpdate;
    Procedure   DelFileTemp;
  published
    property   Ready         : Boolean        read FReady;
    property   AutoUpdate    : Boolean        read FAutoUpdate      write FAutoUpdate  default True;
    property   InjectURL     : String         read FInjectURL;
    property   InjectVersion : String         read FInjectVersion;
    property   InjectScript  : TstringList    read FInjectScript    Write SetInjectScript;
  end;


implementation

uses uTInject.Constant, System.SysUtils, uTInject.ExePath, Vcl.Forms,
    IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, IdHTTP,
  Winapi.Windows, uTInject.ConfigCEF;


{ TInjectAutoUpdate }

function TInjectJS.AtualizarInternamente(PForma: TFormaUpdate): Boolean;
var
  Ltmp: String;
begin
  try
    case pforma  of
      Tup_Local:Begin
                  Ltmp := FInjectLocal;
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
      FInjectScript.LoadFromFile(Ltmp);
      if not ValidaJs(FInjectScript) then
      Begin
        FInjectScript.Clear;
      End else
      Begin
        FInjectVersion   := GetVersaoJS;
        if FInjectVersion = '' then
           FInjectScript.Clear;
      End;
    End;
  finally
    Result        := (FInjectScript.Count >= TInjectJS_JSLinhasMInimas);

    if Result then
    begin
      //Atualzia o arquivo interno
      FLastUpdate := Now;
      if UpperCase(FInjectLocal) <> UpperCase(Ltmp) then
         FInjectScript.SaveToFile(FInjectLocal, TEncoding.UTF8);
    end else
    begin
      FInjectScript.Clear;
      FInjectVersion := '';
    end;
  end;
end;

constructor TInjectJS.Create(AOwner: TComponent);
begin
  inherited;
  FInjectScript                  := TstringList.create;
  FAutoUpdate                    := True;
  FInjectURL                     := TInjectJS_JSUrlPadrao;
  FReady                         := False;
  FInjectLocal                   := IncludeTrailingPathDelimiter(ExtractFilePath(application.ExeName)) + NomeArquivoInject;
end;

procedure TInjectJS.DelFileTemp;
begin
  DeleteFile(PwideChar(IncludeTrailingPathDelimiter(GetEnvironmentVariable('Temp'))+'GetTInject.tmp'));
end;

destructor TInjectJS.Destroy;
begin
  DelFileTemp;
  FreeAndNil(FInjectScript);
  inherited;
end;

procedure TInjectJS.SetInjectScript(const Value: TstringList);
begin
  if (csDesigning in ComponentState) then
  Begin
    if Value.text <> FInjectScript.text then
       raise Exception.Create('Não é possível modificar em Modo Designer');
  End;

  FInjectScript := Value;
end;


function TInjectJS.UpdateNow: Boolean;
begin
  if FAutoUpdate  Then
  Begin
    //Atualiza pela Web  O retorno e o SUCESSO do que esta programado para trabalhar!!
    //Se nao obter sucesso da WEB.. ele vai usar o arquivo local..
    //Se estiver tudo ok.. ele esta PRONTO
    Result      := AtualizarInternamente(Tup_Web);
    If not Result Then
       AtualizarInternamente(Tup_Local);  //Se nao consegui ele pega o arquivo Local
  End else
  Begin
    //Usando via ARQUIVO
    Result      := AtualizarInternamente(Tup_Local);
  end;
  FReady        := (FInjectScript.Count >= TInjectJS_JSLinhasMInimas);
end;

function TInjectJS.ValidaJs(const TValor: Tstrings): Boolean;
var
   Linha1: String;
begin
  Result := False;
  if Assigned(GlobalCEFApp) then
  Begin
    if GlobalCEFApp.ErrorInt Then
       Exit;
  end;

  if (TValor.Count < TInjectJS_JSLinhasMInimas) then    //nao tem linhas suficiente
     Exit;

  If Pos(AnsiUpperCase('var Versao'),  AnsiUpperCase(TValor.Strings[0])) <= 0 then   //Nao tem a variavel
     Exit;
  If Pos(AnsiUpperCase('var TinjectVMinima'),  AnsiUpperCase(TValor.Strings[1])) <= 0 then   //Nao tem a variavel
     Exit;

  If (Pos(AnsiUpperCase('!window.Store'),       AnsiUpperCase(TValor.text))     <= 0) or
     (Pos(AnsiUpperCase('window.WAPI'),         AnsiUpperCase(TValor.text))     <= 0) or
     (Pos(AnsiUpperCase('window.Store.Chat.'),  AnsiUpperCase(TValor.text))     <= 0)  then
  Begin
     Exit;
  End Else
  Begin
   //Chegou até aki!!
   //Entao ta OK!
   //testa se a versao minima esta dentro do programa atual
    Linha1            := Copy(TValor.Strings[1], 19, 20);


    if not VerificaCompatibilidadeVersao(Linha1) then
    Begin
      if Assigned(GlobalCEFApp) then
         GlobalCEFApp.SetError;
      Application.MessageBox(PWideChar(ConfigVersaoCompInvalida), PWideChar(Application.Title), MB_ICONERROR + mb_ok);
    End;
    Result := true;
  End;
end;

function TInjectJS.PegarLocalJS_Designer: String;
//var
//  LDados: TDadosApp;
begin
  try
//    LDados  := TDadosApp.Create(True);
    try
//      Result  := LDados.LocalEXE;
    finally
//      FreeAndNil(LDados);
    end;
  Except
    Result  := '';
  end;
end;


function TInjectJS.PegarLocalJS_Web: String;
var
  LHttp  : TIdHTTP;
  LSalvamento: String;
  LRet   : TStringList;
begin
   LRet          := TStringList.Create;
  Try
    try
      LHttp        := TIdHTTP.Create(nil);
      LRet.text    := LHttp.Get(TInjectJS_JSUrlPadrao);
      LimpaConteudoSite(LRet);
      if not ValidaJs(LRet) Then
         LRet.Clear;
    Except
      LRet.Clear
    end;
  Finally
    if LRet.Count > 1 then
    Begin
      LSalvamento := IncludeTrailingPathDelimiter(GetEnvironmentVariable('Temp'))+'GetTInject.tmp';
      DeleteFile(PwideChar(LSalvamento));
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

Function TInjectJS.GetVersaoJS:String;
var
  LLinha0: String;
begin
  Result := '';
  if  ValidaJs(FInjectScript) Then
  Begin
   //permite que os fontes tenha comentarios sem interferir na descoberta da versao
    LLinha0   := FInjectScript.Strings[0];
    if pos('//', LLinha0) > 0 then
       LLinha0   := Copy(LLinha0, 0, pos('//', LLinha0)-1);

    //Limpa tudo que nao faz parte da versao!!
    LLinha0   := StringReplace(LLinha0, ' ',      '',  [rfReplaceAll, rfIgnoreCase]);
    LLinha0   := StringReplace(LLinha0, 'var',    '',  [rfReplaceAll, rfIgnoreCase]);
    LLinha0   := StringReplace(LLinha0, 'Versao', '',  [rfReplaceAll, rfIgnoreCase]);
    LLinha0   := StringReplace(LLinha0, '=',      '',  [rfReplaceAll, rfIgnoreCase]);
    LLinha0   := StringReplace(LLinha0, ';',      '',  [rfReplaceAll, rfIgnoreCase]);
    LLinha0   := StringReplace(LLinha0, '"',      '',  [rfReplaceAll, rfIgnoreCase]);
    LLinha0   := StringReplace(LLinha0, Chr(39) , '',  [rfReplaceAll, rfIgnoreCase]);
  End;
  Result := LLinha0;
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

  for I := 0 to 10 do  //Linhas de comunicação com o sistemas
     TValor.Strings[1] := Trim(TValor.Strings[1]);


end;

procedure TInjectJS.Loaded;
begin
  inherited;
  UpdateNow;
end;

end.

