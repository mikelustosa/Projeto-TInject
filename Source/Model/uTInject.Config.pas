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



unit uTInject.Config;

interface

uses
  System.Classes, uTInject.Classes;


Type
  TInjectConfig = class(TComponent)
  private
    FControlSend    : Boolean;
    FAutoStart      : Boolean;
    FSecondsMonitor : Integer;
    FAutoDelete     : Boolean;
    FAutoDelay      : Integer;
    FSyncContacts   : Boolean;
    FShowRandom     : Boolean;
    FLowBattery: SmallInt;
    FControlSendTimeSec: SmallInt;
    procedure SetSecondsMonitor(const Value: Integer);
    procedure SetLowBattery(const Value: SmallInt);
    procedure SetControlSendTimeSec(const Value: SmallInt);
  published
    property ControlSend          : Boolean   read FControlSend           write FControlSend               default True;
    property ControlSendTimeSec   : SmallInt  read FControlSendTimeSec    write SetControlSendTimeSec      default 8;
    property AutoStart     : Boolean  read FAutoStart      write FAutoStart        default False;
    property AutoDelete    : Boolean  read FAutoDelete     write FAutoDelete;
    property AutoDelay     : integer  read FAutoDelay      write FAutoDelay        default 2500;

    property LowBatteryIs  : SmallInt read FLowBattery     write SetLowBattery     default 30;
    property SecondsMonitor: Integer  read FSecondsMonitor write SetSecondsMonitor default 3;
    property SyncContacts  : Boolean  read FSyncContacts   write FSyncContacts;
    property ShowRandom    : Boolean  read FShowRandom     write FShowRandom;
  end;

implementation

uses
  System.SysUtils, uTInject.Constant;

{ TInjectConfig }

procedure TInjectConfig.SetControlSendTimeSec(const Value: SmallInt);
begin
  FControlSendTimeSec := Value;
  if FControlSendTimeSec < 3 then
     FControlSendTimeSec := 3;
end;

procedure TInjectConfig.SetLowBattery(const Value: SmallInt);
begin
  if Not Value in [5..90] then
    raise Exception.Create(Config_ExceptSetBatteryLow);
  FLowBattery := Value;
end;


Procedure TInjectConfig.SetSecondsMonitor(const Value: Integer);
begin
  FSecondsMonitor := Value;
  //Não permitir que fique zero ou negativo.
  if Value < 1 then
     FSecondsMonitor := 3;
end;

end.
