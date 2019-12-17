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

unit uTInject.Diversos;

interface

function PrettyJSON(JsonString: String):String;
function caractersWhats(vText: string): string;
function ConvertBase64(vFile: string): string;
function removeCaracter(texto : String) : String;
procedure loadWEBQRCode(st: string);

implementation

uses
  System.JSON, REST.Json, Vcl.Imaging.GIFImg,   Vcl.Graphics, Vcl.ExtCtrls,
  System.Classes, System.NetEncoding, System.SysUtils;


function PrettyJSON(JsonString: String):String;
var
  AObj: TJSONObject;
begin
    AObj   := TJSONObject.ParseJSONValue(JsonString) as TJSONObject;
    result := TJSON.Format(AObj);
    AObj.Free;
end;

procedure loadWEBQRCode(st: string);
var
  LInput : TMemoryStream;
  LOutput: TMemoryStream;
  stl    : TStringList;
begin
  LInput  := TMemoryStream.Create;
  LOutput := TMemoryStream.Create;
  try
    stl := TStringList.Create;
    stl.Add(copy(st, 23, length(st)));
    stl.SaveToStream(LInput);

    LInput.Position  := 0;
    TNetEncoding.Base64.Decode( LInput, LOutput );
    LOutput.Position := 0;
  finally
    FreeAndNil(stl);
    FreeAndNil(LInput);
    FreeAndNil(LOutput);
  end;
end;

function ConvertBase64(vFile: string): string;
var
  vFilestream: TMemoryStream;
  vBase64File: TBase64Encoding;
begin
  vBase64File := TBase64Encoding.Create;
  vFilestream := TMemoryStream.Create;
  try
    vFilestream.LoadFromFile(vFile);
    result :=  vBase64File.EncodeBytesToString(vFilestream.Memory, vFilestream.Size);
  finally
    FreeAndNil(vBase64File);
    FreeAndNil(vFilestream);
  end;
end;


function removeCaracter(texto : String) : String;
Begin
  While pos('-', Texto) <> 0 Do
    delete(Texto,pos('-', Texto),1);
  While pos('/', Texto) <> 0 Do
    delete(Texto,pos('/', Texto),1);
  While pos(',', Texto) <> 0 Do
    delete(Texto,pos(',', Texto),1);
  Result := Texto;
end;

function caractersWhats(vText: string): string;
begin
  vText  := StringReplace(vText, sLineBreak,'\n' , [rfReplaceAll] );
  vText  := StringReplace(vText, #13       ,''   , [rfReplaceAll] );
  vText  := StringReplace(vText, '"'       ,'\"' , [rfReplaceAll] );
  vText  := StringReplace(vText, #$A       ,''   , [rfReplaceAll] );
  Result := vText;
end;




end.
