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


//Remover do componente principal controles e comportamentos
//de textos. Uso do Record evita ter que instanciar objeto
//devido utilização simples dessa necessidade;


unit uTInject.Emoticons;

interface

type
  TInjectEmoticons = record
    const Sorridente       = '😄';
    const SorridenteLingua = '😝';
    const Impressionado    = '😱';
    const Irritado         = '😤';
    const Triste           = '😢';
    const Apaixonado       = '😍';
    const PapaiNoel        = '🎅';
    const Violao           = '🎸';
    const Chegada          = '🏁';
    const Futebol          = '⚽';
    const NaMosca          = '🎯';
    const Dinheiro         = '💵';
    const EnviarCel        = '📲';
    const Enviar           = '📩';
    const Fone             = '📞';
    const Onibus           = '🚍';
    const Aviao            = '✈';
    const Legal            = '👍🏻';
    const ApertoDeMao      = '🤝🏻';
    const PazEAmor         = '✌🏻';
    const Sono             = '😴';
    const Palmas           = '👏🏻';
    const LoiraFazerOq     = '🤷‍♀' ;
    const LoiraMaoNoRosto  = '🤦‍♀' ;
    const Macarrao         = '🍜';
    const AtendenteH       = '👨🏼‍💼';
    const AtendenteM       = '👩🏼‍💼';
    const Pizza            = '🍕';
    const Bebida           = '🥃';
    const Restaurante      = '🍽';
    const Joystick         = '🎮';
    const Moto             = '🏍';
    const Carro            = '🚘';
    const ABarco           = '🚢';
    const Hospital         = '🏥';
    const Igreja           = '⛪';
    const Cartao           = '💳';
    const TuboEnsaio       = '🧪';
    const Pilula           = '💊';
    const SacolaCompras    = '🛍';
    const CarrinhoCompras  = '🛒';
    const Ampulheta        = '⏳';
    const Presente         = '🎁';
    const Email            = '📧';
    const AgendaAzul       = '📘';
    const AgendaVerde      = '📗';
    const AgendaVermelha   = '📕';
    const ClipPapel        = '📎';
    const CanetaAzul       = '🖊';
    const Lapis            = '✏';
    const LapisEPapel      = '📝';
    const CadeadoEChave    = '🔐';
    const Lupa             = '🔎';
    const Corarao          = '❤';
    const Check            = '✅';
    const Check2           = '✔';
    const Atencao          = '⚠';
    const Zero             = '0⃣';
    const Um               = '1⃣';
    const Dois             = '2⃣';
    const Tres             = '3⃣';
    const Quatro           = '4⃣';
    const Cinco            = '5⃣';
    const Seis             = '6⃣';
    const Sete             = '7⃣';
    const Oito             = '8⃣';
    const Nove             = '9⃣';
    const Dez              = '🔟';
    const Aterisco         = '*⃣';
    const SetaDireita      = '➡';
    const SetaEsquerda     = '⬅';
    const Relogio          = '🕒';
    const Conversa         = '💬';
    const ApontaCima       = '👆🏻';
    const ApontaBaixo      = '👇🏻';
    const PanelaComComida  = '🥘';
  end;

//function EmoticonToUTF8Encode(Value: WideString): WideString;

implementation

//function EmoticonToUTF8Encode(Value: WideString): WideString;
//begin
//  Result := UTF8Encode(Value);
//end;

end.
