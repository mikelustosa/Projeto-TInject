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
    procedure SetInjectScript(const Value: TstringList);
    Function  GetVersaoJS:String;
    function  PegarLocalJS_Designer: String;
    function  PegarLocalJS_Web: String;
    Function  AtualizarInternamente(PForma: TFormaUpdate):Boolean;
  protected
    procedure Loaded; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;

    Function    UpdateNow:Boolean;
    property    LastUpdate   : TdateTime      read FLastUpdate;
  published
    property   Ready         : Boolean        read FReady;
    property   AutoUpdate    : Boolean        read FAutoUpdate      write FAutoUpdate  default True;
    property   InjectURL     : String         read FInjectURL;
    property   InjectVersion : String         read FInjectVersion;
    property   InjectScript  : TstringList    read FInjectScript    Write SetInjectScript;
  end;


implementation

uses uTInject.Constant, System.SysUtils, uTInject.ExePath, Vcl.Forms;


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
      FInjectVersion   := GetVersaoJS;
      if FInjectVersion = '' then
         FInjectScript.Clear;
    End;
  finally
    Result        := (FInjectScript.Count >= TInjectJS_JSLinhasMInimas);

    if Result then
    begin
      //Atualzia o arquivo interno
      FLastUpdate := Now;
      if UpperCase(FInjectLocal) <> UpperCase(Ltmp) then
         FInjectScript.SaveToFile(FInjectLocal);
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

destructor TInjectJS.Destroy;
begin
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

function TInjectJS.PegarLocalJS_Designer: String;
var
  LDados: TDadosApp;
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
begin
//
end;

Function TInjectJS.GetVersaoJS:String;
var
  LLinha0: String;
begin
  try
    try
      if FInjectScript.Count < TInjectJS_JSLinhasMInimas then
         exit;
    except
    end
  finally
    if FInjectScript.Count > TInjectJS_JSLinhasMInimas then
    Begin
     //permite que os fontes tenha comentarios sem interferir na descoberta da versao
      LLinha0   := FInjectScript.Strings[0];
      if pos('//', LLinha0) > 0 then
         LLinha0   := Copy(LLinha0, 0, pos('//', LLinha0)-1);

      //Limpa tudo que nao faz parte da versao!!
      LLinha0   := StringReplace(LLinha0, ' ',      '',  [rfReplaceAll, rfIgnoreCase]);
      LLinha0   := StringReplace(LLinha0, 'var',    '',  [rfReplaceAll, rfIgnoreCase]);
      LLinha0   := StringReplace(LLinha0, 'Versao', '',  [rfReplaceAll, rfIgnoreCase]);
      LLinha0   := StringReplace(LLinha0, '=', '',  [rfReplaceAll, rfIgnoreCase]);
      LLinha0   := StringReplace(LLinha0, ';', '',  [rfReplaceAll, rfIgnoreCase]);
      LLinha0   := StringReplace(LLinha0, '"', '',  [rfReplaceAll, rfIgnoreCase]);
      LLinha0   := StringReplace(LLinha0, Chr(39) , '',  [rfReplaceAll, rfIgnoreCase]);
    End;
    Result := LLinha0;
  end;
end;


procedure TInjectJS.Loaded;
begin
  inherited;
  UpdateNow;
end;

end.
