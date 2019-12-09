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


unit uTInject.AdjustNumber;

interface

uses
  System.Classes, uTInject.Classes, System.MaskUtils;

type

  TInjectAdjusteNumber  = class(TComponent)
  private
    FLastAdjustDt: TDateTime;
    FLastAdjuste: String;
    FLastDDI: String;
    FLastDDD: String;
    FLastNumber: String;

    FAutoAdjust: Boolean;
    FDDIDefault: Integer;
    FLengthDDI: integer;
    FLengthDDD: Integer;
    FLengthPhone: Integer;
    FLastNumberFormat: String;
    FLastType: TTypeNumber;
    Procedure SetPhone(Const Pnumero:String);
  public
    constructor Create(AOwner: TComponent); override;

    Function  Format(PNum:String): String;
    property  LastType    : TTypeNumber     Read FLastType;
    property  LastAdjuste : String          Read FLastAdjuste;
    property  LastDDI     : String          Read FLastDDI;
    property  LastDDD     : String          Read FLastDDD;
    property  LastNumber  : String          Read FLastNumber;
    property  LastNumberFormat: String      Read FLastNumberFormat;
    property  LastAdjustDt: TDateTime       Read FLastAdjustDt;
  published
    property AutoAdjust : Boolean           read FAutoAdjust   write FAutoAdjust default True;
    property LengthDDI  : Integer           read FLengthDDI    write FLengthDDI   default 2;
    property LengthDDD  : Integer           read FLengthDDD    write FLengthDDD   default 2;
    property LengthPhone: Integer           read FLengthPhone  write FLengthPhone default 9;
    property DDIDefault : Integer           read FDDIDefault   write FDDIDefault  Default 2;
  end;


implementation

uses
  System.SysUtils, uTInject.Constant;

{ TAdjustNumber }


function TInjectAdjusteNumber.Format(PNum: String): String;
var
  LClearNum: String;
  i: Integer;
begin
  Result := Pnum;
  try
    if not AutoAdjust then
       Exit;

    //Garante valores LIMPOS (sem mascaras, letras, etc) apenas NUMEROS
    Result := PNum;
    for I := 1 to Length(PNum) do
    begin
//      if PNum[I] in ['0'..'9'] then
      if  (CharInSet(PNum[I] ,['0'..'9'])) Then
          LClearNum := LClearNum + PNum[I];
    end;

    //O requisito minimo é possuir DDD + NUMERO (Fone 8 ou 9 digitos)
    //  if Length(LClearNum) < 10 then
    if Length(LClearNum) < (LengthDDD + LengthPhone) then
    Begin
      Result := '';
      Exit;
    End;

    //Testa se é um grupo ou Lista Transmissao
    if Length(LClearNum) <=  (LengthDDI + LengthDDD + LengthPhone + 1) Then //14 then
    begin
      if (Length(LClearNum) <= (LengthDDD + LengthPhone)) or (Length(PNum) <= (LengthDDD + LengthPhone)) then
      begin
        if Copy(LClearNum, 0, LengthDDI) <> DDIDefault.ToString then
           LClearNum := DDIDefault.ToString + LClearNum;
        Result := LClearNum +  CardContact;
      end;
    end;
  finally
    if Result = '' then
       raise Exception.Create('Número inválido');
    SetPhone(Result);
  end;
end;


procedure TInjectAdjusteNumber.SetPhone(const Pnumero: String);
begin
  FLastType         := TypUndefined;
  FLastDDI          := '';
  FLastDDD          := '';
  FLastNumber       := '';
  FLastNumberFormat := '';
  FLastAdjustDt     := Now;
  FLastAdjuste      := Pnumero;
  FLastNumberFormat := Pnumero;
  if pos(CardGroup, Pnumero) > 0 then
  begin
    FLastType := TypGroup;
  end else
  Begin
    if Length(Pnumero) = (LengthDDI + LengthDDD + LengthPhone + Length(CardContact)) then
       FLastType := TypContact;
  end;

  if FLastType = TypContact then
  Begin
    FLastDDI :=  Copy(Pnumero, 0,           LengthDDI);
    FLastDDD :=  Copy(Pnumero, LengthDDI+1, LengthDDD);
    FLastNumber :=  Copy(Pnumero, LengthDDI+LengthDDD+1, LengthPhone);
    FLastNumberFormat := '+' + FLastDDI + ' (' + FLastDDD + ') ' + FormatMaskText('0\.0000\-0000;0;', FLastNumber)
  End;
end;

constructor TInjectAdjusteNumber.Create(AOwner: TComponent);
begin
  inherited;
  FLastAdjuste := '';
  FLastDDI     := '';
  FLastDDD     := '';
  FLastNumber  := '';

  FAutoAdjust  := True;
  FDDIDefault  := 55;
  FLengthDDI   := 2;
  FLengthDDD   := 2;
  FLengthPhone := 8;
end;

end.
