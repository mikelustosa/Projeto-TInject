{####################################################################################################################
    Owner.....: Daniel Oliveira Rodrigues  - Dor_poa@hotmail.com     - +55 51 9.9155-9228
####################################################################################################################
  Obs:
     - Código aberto a comunidade Delphi, desde que mantenha os dados dos autores;
       DANIEL OLIVEIRA RODRIGUES
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



unit UCSV.Import;

interface

uses
  System.Classes, Vcl.ExtCtrls, System.SysUtils,
  Data.DB,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client;

Const
  TamPdr = 100;

Type
  TCSVImport = Class
  Private
    FStringList: TStringList;
    FRegistros       : TFDMemTable;
    FSeparador : Char;
    Procedure ZerarTudo;
    Function  CriarCampos: Boolean;
    Function  CriarValor(PLinha:WideString): Boolean;
    Function  ProcessarCriacaoCSV:Boolean;
  Public
    constructor Create;
    destructor  Destroy; OverRide;

    Function  ImportarCSV_viaArquivo  (PArquivo:String):Boolean;
    Function  ImportarCSV_viaTexto    (PConteudo:WideString):Boolean;

    Property  Registros:  TFDMemTable Read FRegistros;
    Property  Separador : Char        Read FSeparador               Write FSeparador;
  End;


implementation

uses
  Vcl.Dialogs;

{ TCSVImport }

constructor TCSVImport.Create;
begin
  FSeparador := ';';
  ZerarTudo;
end;

function TCSVImport.CriarCampos: Boolean;
Var
  Lok    : Integer;
  Linha0 : PwideChar;
  LCampo : String;
  LRetorno: TStringList;
  I: Integer;
begin
  Result := False;
  LRetorno := TStringList.Create;
  FRegistros.FieldOptions.AutoCreateMode := acCombineComputed;
  try
    Linha0 := PwideChar(FStringList.Strings[0]);
    Lok    := ExtractStrings([FSeparador],[' '], Linha0, LRetorno);
    try
      if Lok > 0 then
      Begin
        for I := 0 to LRetorno.Count -1 do
        Begin
          LCampo := LRetorno.Strings[i];
          FRegistros.FieldDefs.Add(LCampo,     ftString,      TamPdr, False);
        End;
        FRegistros.CreateDataSet;
        Result := True;
      End;
    Except
      Result := False;
    end;
  finally
    FreeAndNil(LRetorno);
  end;
end;

function TCSVImport.CriarValor(PLinha: WideString): Boolean;
Var
  Lok    : Integer;
  Linha  : PwideChar;
  LConteudoCampo: WideString;
  LRetorno: TStringList;
  I: Integer;
begin
  Result := False;
  LRetorno := TStringList.Create;
  try
    while ( Pos((FSeparador + FSeparador), String(Plinha))> 0) do
    Begin
      PLinha  := StringReplace(PLinha, (FSeparador + FSeparador), (FSeparador + ' ' + FSeparador), [rfReplaceAll, rfIgnoreCase]);
    End;

    Linha   := PwideChar(PLinha);
    Lok     := ExtractStrings([FSeparador],[], Linha, LRetorno);
    try
      if Lok > 0 then
      Begin
        FRegistros.Append;
        for I := 0 to LRetorno.Count -1 do
        Begin
          LConteudoCampo:= Trim(LRetorno.Strings[i]);
          if i <= FRegistros.Fields.Count -1 then
             FRegistros.Fields[i].AsString := LConteudoCampo;
        End;
        FRegistros.post;
        Result := True;
      End;
    Except
     on E : Exception do
     Begin
       LConteudoCampo := e.Message;
       if FRegistros.State = dsInsert then
           FRegistros.Cancel;
        Result := False;
     End;
    end;
  finally
    FreeAndNil(LRetorno);
  end;

end;

destructor TCSVImport.Destroy;
begin
  FreeAndNil(FStringList);
  FreeAndNil(FRegistros);
  inherited;
end;

function TCSVImport.ImportarCSV_viaArquivo(PArquivo: String): Boolean;
begin
  ZerarTudo;
  Result := False;
  if not FileExists(PArquivo) then
    Exit;

  FStringList.LoadFromFile(PArquivo);
  Result := ProcessarCriacaoCSV;
end;

function TCSVImport.ImportarCSV_viaTexto(PConteudo: WideString): Boolean;
begin
  ZerarTudo;
  FStringList.Text := PConteudo;
  Result           := ProcessarCriacaoCSV;
end;

function TCSVImport.ProcessarCriacaoCSV: Boolean;
var
  I: Integer;
begin
  Result := False;
  if FStringList.Count < 1 then
     Exit;

  if not CriarCampos then
     Exit;

  for I := 1 to FStringList.Count - 1 do
  Begin
    if not CriarValor(FStringList.Strings[i]) then
    Begin
      ZerarTudo;
      Exit;
    End;
  End;
  Result := True;
end;

procedure TCSVImport.ZerarTudo;
begin
  FreeAndNil(FStringList);
  FreeAndNil(FRegistros);

  FStringList      := TStringList.Create;
  FRegistros       := TFDMemTable.Create(nil);
end;

end.
