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



unit uTInject.Config;

interface

uses
  System.Classes;


Type
  TInjectConfig = class(TComponent)
  public
    FAutoStart      : Boolean;
    FAutoMonitor    : Boolean;
    FSecondsMonitor : Integer;
    FAutoDelete     : Boolean;
    FAutoDelay      : Integer;
    FSyncContacts   : Boolean;
    FShowRandom     : Boolean;
  private
    procedure SetAutoMonitor(const Value: Boolean);
    procedure SetSecondsMonitor(const Value: Integer);
  published
    property AutoStart    : Boolean  read FAutoStart      write FAutoStart default False;
    property AutoMonitor  : boolean  read FAutoMonitor    write SetAutoMonitor          default True;
    property SecondsMonitor: Integer read FSecondsMonitor write SetSecondsMonitor default 3;
    property AutoDelete   : Boolean  read FAutoDelete     write FAutoDelete;
    property AutoDelay    : integer  read FAutoDelay      write FAutoDelay  default 2500;
    property SyncContacts : Boolean  read FSyncContacts   write FSyncContacts;
    property ShowRandom   : Boolean  read FShowRandom     write FShowRandom;
  end;

implementation

{ TInjectConfig }

procedure TInjectConfig.SetAutoMonitor(const Value: boolean);
begin
  FAutoMonitor := Value;
  if SecondsMonitor < 1 then
     SecondsMonitor := 3; //Default Value;
end;

procedure TInjectConfig.SetSecondsMonitor(const Value: Integer);
begin
  FSecondsMonitor := Value;

  //N�o permitir que fique zero ou negativo.
  if Value < 1 then
     FSecondsMonitor := 3;
end;

end.
