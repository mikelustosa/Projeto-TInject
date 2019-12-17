unit uTInject.ControlSend;

interface

uses
  System.SysUtils, System.Classes, Vcl.Forms,
  Generics.Collections, uTInject.Classes;

Type
  TControlSend = Class;

  TlastSend = Class
  private
    FOwner: TComponent;
    FCommand: String;
    FTempo  : Cardinal;
    Function  TestEqual(const Value: String; Var PVencido: Boolean) :Boolean;
  Public
     constructor Create(POwner: TComponent; pValor:String);
     Function    Vencido: Boolean;
     Property    Command: String Read FCommand;
  end;


  TControlSend = class(TComponent)
  Private
    FListCommand : TObjectList<TlastSend>;
    Ftrabalhando : Boolean;
    FDelayRepeat : Integer;
    FDelayControl: Boolean;
    FOnErrorInternal: TOnErroInternal;
    procedure   SetDelayControl(const Value: Boolean);
  Public
    constructor Create(AOwner: TComponent);   override;
    destructor  Destroy; override;
    Property    DelayControl : Boolean Read FDelayControl Write SetDelayControl  Default True;
    Property    DelayRepeat  : Integer Read FDelayRepeat  Write FDelayRepeat     Default 5000;
    Function    CanSend(Const PCommand:String):Boolean;
    Procedure   Release;
  end;


implementation

uses
  Winapi.Windows, System.Types, uTInject.Console;

{ TControlSend }

function TControlSend.CanSend(const PCommand: String): Boolean;
var
  Lvencido, LEncontrado: Boolean;
  LItem: TlastSend;
begin
  Result := True;
  if (not FDelayControl) or (length(PCommand) > 1000) then
     Exit;

  Ftrabalhando := True;
  Try
    Try
      for LItem in FListCommand do
      begin
        LEncontrado := LItem.TestEqual(PCommand, Lvencido);
        if Lvencido then
           FListCommand.RemoveItem(LItem, FromBeginning);

        if LEncontrado Then
        Begin
          if not Lvencido then
             Result := false;
          Break
        End;
      End;
      if Result Then
        FListCommand.Add(TlastSend.Create(Self, PCommand));
    Except
    End;
  Finally
    Ftrabalhando := False;
  End;
end;



procedure TControlSend.Release;
var
  LItem: TlastSend;
begin
  if (not FDelayControl)  then
     Exit;

  Ftrabalhando := True;
  Try
    try
      for LItem in FListCommand do
      begin
        if LItem.Vencido Then
           FListCommand.RemoveItem(LItem, FromBeginning);
      End;
    Except
    end;
  Finally
    Ftrabalhando := False;
  End;
end;


constructor TControlSend.Create(AOwner: TComponent);
begin
  inherited;
  FDelayRepeat     := 5000;
  FDelayControl    := True;
  FOnErrorInternal := TFrmConsole(AOwner).OnErrorInternal;
  FListCommand     := TObjectList<TlastSend>.create;
end;

destructor TControlSend.Destroy;
begin
  FListCommand.Clear;
  FreeAndNil(FListCommand);
  inherited;
end;


procedure TControlSend.SetDelayControl(const Value: Boolean);
begin
  FListCommand.Clear;
end;

constructor TlastSend.Create(POwner: TComponent; pValor: String);
begin
  FOwner   := POwner;
  FCommand := UpperCase(pValor);
  FTempo   := GetTickCount;
end;

function TlastSend.testequal(const Value: String; Var PVencido: Boolean): Boolean;
var
  lDif   : Cardinal;
  Lcount : Integer;

begin
  PVencido := False;
  Result   := UpperCase(Value) = UpperCase(FCommand);
  if result then
  Begin
    lDif     := (GetTickCount - FTempo) ;
    Lcount   :=  TControlSend(FOwner).DelayRepeat;
    PVencido := (Integer(lDif) >=  Lcount);
  End;
end;

function TlastSend.Vencido: Boolean;
var
  lDif: Cardinal;
begin
  Result := False;
  lDif   := (GetTickCount - FTempo) ;
  try Result := Integer(lDif) >=  TControlSend(FOwner).DelayRepeat; Except End;
end;

end.
