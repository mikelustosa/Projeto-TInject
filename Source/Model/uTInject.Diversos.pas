{####################################################################################################################
                         TINJECT - Componente de comunica��o WhatsApp (N�o Oficial WhatsApp)
                                           www.tinject.com.br
                                            Novembro de 2019
####################################################################################################################
    Owner.....: Mike W. Lustosa            - mikelustosa@gmail.com   - +55 81 9.9630-2385
    Developer.: Joathan Theiller           - jtheiller@hotmail.com   -
                Daniel Oliveira Rodrigues  - Dor_poa@hotmail.com     - +55 51 9.9155-9228
####################################################################################################################
  Obs:
     - C�digo aberto a comunidade Delphi, desde que mantenha os dados dos autores;
     - Colocar na evolu��o as Modifica��o juntamente com as informa�oes do colaborador: Data, Nova Versao, Autor;
     - Mantenha sempre a versao mais atual acima das demais;
     - Todo Commit ao reposit�rio dever� ser declarado as mudan�a na UNIT e ainda o Incremento da Vers�o de
       compila��o (�ltimo digito);

####################################################################################################################
                                  Evolu��o do C�digo
####################################################################################################################
  Autor........:
  Email........:
  Modifica��o..:
####################################################################################################################
}

unit uTInject.Diversos;

interface

function PrettyJSON(JsonString: String):String;


implementation

uses
  System.JSON, REST.Json, Vcl.Imaging.GIFImg,   Vcl.Graphics, Vcl.ExtCtrls;


function PrettyJSON(JsonString: String):String;
var
  AObj: TJSONObject;
begin
    AObj   := TJSONObject.ParseJSONValue(JsonString) as TJSONObject;
    result := TJSON.Format(AObj);
    AObj.Free;
end;




end.
