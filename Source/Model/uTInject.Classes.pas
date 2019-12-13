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

unit uTInject.Classes;

interface

uses Generics.Collections, Rest.Json, uTInject.FrmQRCode, Vcl.Graphics, System.IOUtils,
  System.Classes, uTInject.Constant;

type

  TQrCodeRet   = (TQR_Http, TQR_Img, TQR_Data);
  TQrCodeRets  = set of TQrCodeRet;
  TChatClass   = class;   //forward
  TSenderClass = class;   //forward
  TTypeNumber  = (TypUndefined=0, TypContact=1, TypGroup=2);
  TFormaUpdate = (Tup_Local=0, Tup_Web=1);

  TResulttMisc        = procedure(PTypeHeader: TTypeHeader; PValue: String) of object;
  TOnErroInternal     = procedure(Sender : TObject; Const PError: String; Const PInfoAdc:String)  of object;

  TClassPadrao = class
  private
    FJsonString : String;
    FJsonOption : TJsonOptions;
    FName       : String;
    FTypeHeader : TTypeHeader;
  public
    constructor Create(pAJsonString: string; PJsonOption: TJsonOptions = [joDateIsUTC, joDateFormatISO8601]);
    destructor  Destroy; override;
    property Name        : String         read FName;
    Property TypeHeader  : TTypeHeader    Read FTypeHeader;
    Property JsonOption  : TJsonOptions   Read FJsonOption;
    Property JsonString  : String         Read FJsonString;
    function ToJsonString: string;
  end;

  TClassPadraoString = class(TClassPadrao)
  private
    FResult: String;
  public  
    property Result: String           read FResult;
  end;

  TClassPadraoList<T> = class(TClassPadrao)
  private
    FResult: TArray<T>;
  public
    Procedure   ClearArray(PArray : TArray<T>);
    property   result: TArray<T> read FResult write FResult;
    destructor Destroy; override;
  end;



  {########################################################################################################################################}
  TResponseConsoleMessage = class(TClassPadraoString)
  private
    FResult: String;
  public
    property Result: String           read FResult;
    constructor Create(pAJsonString: string);
  end;

  TResponseBattery = class(TClassPadraoString)
  end;

  TMediaDataClass = class(TClassPadrao)
  end;

  TResponseMyNumber = class(TClassPadraoString)
  public
    constructor Create(pAJsonString: string);
  end;

  TChatstatesClass = class(TClassPadrao)
  private
    FTeste: String;
  public
    property teste: String read FTeste write FTeste;
  end;

  TPresenceClass = class(TClassPadraoList<TChatstatesClass>)
  private
    FChatstates: TArray<TChatstatesClass>;
    FId        : String;
  public
    constructor Create(pAJsonString: string);
    property   chatstates: TArray<TChatstatesClass> read FChatstates write FChatstates;
    property   id        : String                        read FId         write FId;
  end;

  TParticipantsClass = class(TClassPadrao)
  private
    FId          : String;
    FIsAdmin     : Boolean;
    FIsSuperAdmin: Boolean;
  public
    property id:           String   read   FId           write FId;
    property isAdmin:      Boolean  read   FIsAdmin      write FIsAdmin;
    property isSuperAdmin: Boolean  read   FIsSuperAdmin write FIsSuperAdmin;
  end;

  TGroupMetadataClass = class(TClassPadraoList<TParticipantsClass>)
  private
    FCreation : Extended;
    FDesc     : String;
    FDescId   : String;
    FDescOwner: String;
    FDescTime : Extended;
    FId       : String;
    FOwner    : String;
    FParticipants: TArray<TParticipantsClass>;
    FRestrict    : Boolean;
  public
    constructor Create(pAJsonString: string);
    destructor Destroy; override;

    property creation : Extended     read FCreation   write FCreation;
    property desc     : String       read FDesc       write FDesc;
    property descId   : String       read FDescId     write FDescId;
    property descOwner: String       read FDescOwner  write FDescOwner;
    property descTime : Extended     read FDescTime   write FDescTime;
    property id       : String       read FId         write FId;
    property owner    : String       read FOwner      write FOwner;
    property restrict : Boolean      read FRestrict   write FRestrict;
    property participants: TArray<TParticipantsClass> read FParticipants write FParticipants;
  end;

  TProfilePicThumbObjClass = class(TClassPadrao)
  private
    FEurl   : String;
    FId     : String;
    FImg    : String;
    FImgFull: String;
    FTag    : String;
  public
    property eurl:    String      read FEurl      write FEurl;
    property id:      String      read FId        write FId;
    property img:     String      read FImg       write FImg;
    property imgFull: String      read FImgFull   write FImgFull;
    property tag:     String      read FTag       write FTag;
  end;

  TContactClass = class(TClassPadrao)
  private
    FFormattedName: String;
    FGlobal       : String;
    FId           : String;
    FIsBusiness   : Boolean;
    FIsEnterprise : Boolean;
    FIsMe         : Boolean;
    FIsMyContact  : Boolean;
    FIsPSA        : Boolean;
    FIsUser       : Boolean;
    FIsWAContact  : Boolean;
    FName         : String;
    FProfilePicThumbObj: TProfilePicThumbObjClass;
    FStatusMute   : Boolean;
    FLabels       : TArray<String>;
    FType         : String;
  public
    constructor Create(pAJsonString: string);

    property formattedName:  String          read FFormattedName  write FFormattedName;
    property Global:         String          read FGlobal         write FGlobal;
    property id:             String          read FId             write FId;
    property isBusiness:     Boolean         read FIsBusiness     write FIsBusiness;
    property isEnterprise:   Boolean         read FIsEnterprise   write FIsEnterprise;
    property isMe:           Boolean         read FIsMe           write FIsMe;
    property isMyContact:    Boolean         read FIsMyContact    write FIsMyContact;
    property isPSA:          Boolean         read FIsPSA          write FIsPSA;
    property isUser:         Boolean         read FIsUser         write FIsUser;
    property isWAContact:    Boolean         read FIsWAContact    write FIsWAContact;
    property name:           String          read FName           write FName;
    property statusMute:     Boolean         read FStatusMute     write FStatusMute;
    property labels:         TArray<String>  read FLabels         write FLabels;
    property &type:          String          read FType           write FType;
    property profilePicThumbObj: TProfilePicThumbObjClass read FProfilePicThumbObj write FProfilePicThumbObj;
    destructor Destroy; override;
  end;

  TLastReceivedKeyClass = class(TClassPadrao)
  private
    F_serialized: String;
    FFromMe     : Boolean;
    FId         : String;
    FRemote     : String;
  public
    property _serialized: String   read F_serialized write F_serialized;
    property fromMe:      Boolean  read FFromMe      write FFromMe;
    property id:          String   read FId          write FId;
    property remote:      String   read FRemote      write FRemote;
  end;

  TMessagesClass = class(TClassPadrao)
  private
    FAck             : Extended;
    FBody            : String;
    FBroadcast       : Boolean;
    FChat            : TChatClass;
    FChatId          : String;
    FContent         : String;
    FFrom            : String;
    FId              : String;
    FInvis           : Boolean;
    FIsForwarded     : Boolean;
    FIsGroupMsg      : Boolean;
    FIsMMS           : Boolean;
    FIsMedia         : Boolean;
    FIsNewMsg        : Boolean;
    FIsNotification  : Boolean;
    FIsPSA           : Boolean;
    FLabels          : TArray<String>;
    FMediaData       : TMediaDataClass;
    FMentionedJidList: TArray<String>;
    FNotifyName      : String;
    FRecvFresh       : Boolean;
    FSelf            : String;
    FSender          : TSenderClass;
    FStar            : Boolean;
    FT               : Extended;
    FTimestamp       : Extended;
    FTo              : String;
    FType            : String;
  public
    constructor Create(pAJsonString: string);
    destructor Destroy; override;

    property ack        : Extended            read FAck              write FAck;
    property body       : String              read FBody             write FBody;
    property broadcast  : Boolean             read FBroadcast        write FBroadcast;
    property chat       : TChatClass          read FChat             write FChat;
    property chatId     : String              read FChatId           write FChatId;
    property content    : String              read FContent          write FContent;
    property from       : String              read FFrom             write FFrom;
    property id         : String              read FId               write FId;
    property invis      : Boolean             read FInvis            write FInvis;
    property isForwarded: Boolean             read FIsForwarded      write FIsForwarded;
    property isGroupMsg : Boolean             read FIsGroupMsg       write FIsGroupMsg;
    property isMMS      : Boolean             read FIsMMS            write FIsMMS;
    property isMedia    : Boolean             read FIsMedia          write FIsMedia;
    property isNewMsg   : Boolean             read FIsNewMsg         write FIsNewMsg;
    property isNotification: Boolean          read FIsNotification   write FIsNotification;
    property isPSA      : Boolean             read FIsPSA            write FIsPSA;
    property labels     : TArray<String>      read FLabels           write FLabels;
    property mediaData  : TMediaDataClass     read FMediaData        write FMediaData;
    property mentionedJidList: TArray<String> read FMentionedJidList write FMentionedJidList;
    property notifyName : String              read FNotifyName       write FNotifyName;
    property recvFresh  : Boolean             read FRecvFresh        write FRecvFresh;
    property self       : String              read FSelf             write FSelf;
    property sender     : TSenderClass        read FSender           write FSender;
    property star       : Boolean             read FStar             write FStar;
    property t          : Extended            read FT                write FT;
    property timestamp  : Extended            read FTimestamp        write FTimestamp;
    property toMessage  : String              read FTo               write FTo;
    property &type      : String              read FType             write FType;
  end;

  TChatClass = class(TClassPadraoList<TMessagesClass>)
  private
    FIsAnnounceGrpRestrict: Boolean;
    FArchive        : Boolean;
    FContact        : TContactClass;
    FGroupMetadata  : TGroupMetadataClass;
    FId             : String;
    FIsGroup        : Boolean;
    FIsReadOnly     : Boolean;
    FKind           : String;
    FLastReceivedKey: TLastReceivedKeyClass;
    FMessages       : tArray<TMessagesClass>;
    FModifyTag      : Extended;
    FMuteExpiration : Extended;
    FNotSpam        : Boolean;
    FPendingMsgs    : Boolean;
    FPin            : Extended;
    FPresence       : TPresenceClass;
    FT              : Extended;
    FUnreadCount    : Extended;
  public
    constructor Create(pAJsonString: string);
    destructor Destroy; override;

    property isAnnounceGrpRestrict: Boolean               read FIsAnnounceGrpRestrict write FIsAnnounceGrpRestrict;
    property groupMetadata  : TGroupMetadataClass         read FGroupMetadata         write FGroupMetadata;
    property archive        : Boolean                     read FArchive               write FArchive;
    property contact        : TContactClass               Read FContact               write FContact;
    property id             : String                      read FId                    write FId;
    property isGroup        : Boolean                     read FIsGroup               write FIsGroup;
    property isReadOnly     : Boolean                     read FIsReadOnly            write FIsReadOnly;
    property kind           : String                      read FKind                  write FKind;
    property lastReceivedKey: TLastReceivedKeyClass       read FLastReceivedKey       write FLastReceivedKey;
    property messages       : TArray<TMessagesClass>      read FMessages              write FMessages;
    property modifyTag      : Extended                    read FModifyTag             write FModifyTag;
    property muteExpiration : Extended                    read FMuteExpiration        write FMuteExpiration;
    property notSpam        : Boolean                     read FNotSpam               write FNotSpam;
    property pendingMsgs    : Boolean                     read FPendingMsgs           write FPendingMsgs;
    property pin            : Extended                    read FPin                   write FPin;
    property presence       : TPresenceClass              read FPresence              write FPresence;
    property t              : Extended                    read FT                     write FT;
    property unreadCount    : Extended                    read FUnreadCount           write FUnreadCount;
  end;

{##########################################################################################
                                RETORNOS AO CONSOLE
##########################################################################################}
TRetornoAllContacts = class(TClassPadraoList<TContactClass>)
Public
  constructor Create(pAJsonString: string);
end;

TChatList = class(TClassPadraoList<TChatClass>)
end;


TResultQRCodeClass = class(TClassPadrao)
private
  FAQrCode, FUltimoQrCode: String;
  FAQrCodeImage: TPicture;
  FAQrCodeImageStream: TMemoryStream;
  FAQrCodeSucess: Boolean;
  FAImageDif    : Boolean;
  procedure ProcessQRCodeImage;
  Function  CreateImage:Boolean;
public
  destructor  Destroy; override;
  constructor Create(pAJsonString: string);

  property  AQrCode: String                    read FAQrCode                      write FAQrCode;
  property  AQrCodeImageStream: TMemoryStream  Read FAQrCodeImageStream;
  property  AQrCodeImage: TPicture             read FAQrCodeImage;
  property  AQrCodeSucess: Boolean             read FAQrCodeSucess;
  property  AImageDif:  Boolean                read FAImageDif;
  Function  AQrCodeQuestion: Boolean;
end;

TQrCodeClass = class(TClassPadrao)
private
  FResult: TResultQRCodeClass;
  FTags: TQrCodeRets;
public
  constructor Create(pAJsonString: string; PJsonOption: TJsonOptions = [];  PTagRequired: TQrCodeRets=[]);
  destructor  Destroy; override;

  property    Tags  :  TQrCodeRets        read FTags;
  property    Result:  TResultQRCodeClass read FResult write FResult;
end;
{##########################################################################################}


TSenderClass = class(TClassPadrao)
private
  FFormattedName: String;
  FId: String;
  FIsBusiness: Boolean;
  FIsEnterprise: Boolean;
  FIsMe: Boolean;
  FIsMyContact: Boolean;
  FIsPSA: Boolean;
  FIsUser: Boolean;
  FIsWAContact: Boolean;
  FLabels: TArray<String>;
  FProfilePicThumbObj: TProfilePicThumbObjClass;
  FPushname: String;
  FStatusMute: Boolean;
  FType: String;
public
  destructor Destroy; override;
  constructor Create(pAJsonString: string);

  property profilePicThumbObj: TProfilePicThumbObjClass read FProfilePicThumbObj write FProfilePicThumbObj;
  property formattedName:   String         read FFormattedName write FFormattedName;
  property id:              String         read FId            write FId;
  property isBusiness:      Boolean        read FIsBusiness    write FIsBusiness;
  property isEnterprise:    Boolean        read FIsEnterprise  write FIsEnterprise;
  property isMe:            Boolean        read FIsMe          write FIsMe;
  property isMyContact:     Boolean        read FIsMyContact   write FIsMyContact;
  property isPSA:           Boolean        read FIsPSA         write FIsPSA;
  property isUser:          Boolean        read FIsUser        write FIsUser;
  property isWAContact:     Boolean        read FIsWAContact   write FIsWAContact;
  property labels:          TArray<String> read FLabels        write FLabels;
  property pushname:        String         read FPushname      write FPushname;
  property statusMute:      Boolean        read FStatusMute    write FStatusMute;
  property &type:           String         read FType          write FType;
end;


Procedure LogAdd(Pvalor:WideString; PCab:String = '');


implementation

uses
  System.JSON, System.SysUtils, Vcl.Dialogs, System.NetEncoding,
  Vcl.Imaging.pngimage, uTInject.ConfigCEF;

Procedure LogAdd(Pvalor:WideString; PCab:String);
Var
  LTmp:String;
Begin
  try
    if Assigned(GlobalCEFApp) then
    Begin
      if PCab = '' then
         LTmp:= '[' + FormatDateTime('dd/mm/yy hh:nn', now) + ']  ' else
         LTmp:= '[' + FormatDateTime('dd/mm/yy hh:nn', now) + ' - ' + PCab + ']  ' + slinebreak;
      TFile.AppendAllText(GlobalCEFApp.LogConsole+ 'ConsoleMessage.log', slinebreak + LTmp + Pvalor, TEncoding.ASCII);
    End;
  Except

  end;
End;


  {TResultQRCodeClass}
function TResultQRCodeClass.AQrCodeQuestion: Boolean;
begin
  //Se sucesso e a imagem for diferenre!!
  Result := (AQrCodeSucess and AImageDif);
end;

constructor TResultQRCodeClass.Create(pAJsonString: string);
begin
  FAQrCodeImage       := TPicture.Create;
  FAQrCodeImageStream := TMemoryStream.Create;
  FAQrCodeSucess      := False;
  FAImageDif          := False;

  inherited Create(pAJsonString, [joDateIsUTC, joDateFormatISO8601]);
end;

function TResultQRCodeClass.CreateImage: Boolean;
{$IFNDEF VER330}
var
    PNG: TpngImage;
{$ENDIF}
begin
  Result := False;
  try
    if FAQrCodeImageStream.Size <= 0 Then
       Exit;

    FreeAndNil(FAQrCodeImage);
    FAQrCodeImage  := TPicture.Create;       
    FAQrCodeImageStream.Position := 0;
    
    {$IFDEF VER330}
      FAQrCodeImage.LoadFromStream(FAQrCodeImageStream);
   {$ELSE}
      PNG := TPngImage.Create;
      try
        Png.LoadFromStream(FAQrCodeImageStream);
        FAQrCodeImage.Graphic := PNG;
      finally
        PNG.Free;
      end;
   {$ENDIF}
    result := True;
  Except
  end;
end;

destructor TResultQRCodeClass.Destroy;
begin
  FreeAndNil(FAQrCodeImage);
  FreeAndNil(FAQrCodeImageStream);//.free;
  inherited;
end;

procedure TResultQRCodeClass.ProcessQRCodeImage;
var
  LMem: TMemoryStream;
  LConvert: TStringList;
begin
  //Se a imagem for a mesma!! nao precisa fazer nada!
  if FUltimoQrCode = AQrCode then
  Begin
    FAImageDif     := False;
    Exit;
  End;

  FAQrCodeImageStream.Free;
  FAQrCodeSucess        := False;
  LMem                  := TMemoryStream.Create;
  FAQrCodeImageStream   := TMemoryStream.Create;
  LConvert              := TStringList.Create;
  try
    try
      LConvert.Add(copy(aQrCode, 23, length(aQrCode)));
      LConvert.SaveToStream(LMem);
      LMem.Position := 0;
      TNetEncoding.Base64.Decode(LMem, FAQrCodeImageStream );
      FAQrCodeImageStream.Position := 0;

      if FAQrCodeImageStream.Size > 0 Then
      Begin
        FUltimoQrCode  := AQrCode;
        FAQrCodeSucess := True;
        FAQrCodeSucess := CreateImage;
      End;
    Except
      FAQrCodeSucess := False;
    end;
  finally
    FAImageDif     := TRUE;
    FreeAndNil(LConvert);
    LMem.Free;
  end;
end;

{ TResponseConsoleMessage }
constructor TResponseConsoleMessage.Create(pAJsonString: string);
var
  lAJsonObj: TJSONValue;
begin
  lAJsonObj := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(pAJsonString),0);
  try
    if not Assigned(lAJsonObj) then
       Exit;

//    LogAdd('', ' PRE LEITURA - ' + SELF.ClassName);
   inherited Create(pAJsonString, [joDateIsUTC, joDateFormatISO8601]);
  finally
//    LogAdd(RESULT , ' PÓS LEITURA - ' + SELF.ClassName);

    FreeAndNil(lAJsonObj);
    //lAJsonObj.Free;
  end;
end;

constructor TGroupMetadataClass.Create(pAJsonString: string);
begin
  inherited Create(pAJsonString, [joDateIsUTC, joDateFormatISO8601]);
end;

constructor TContactClass.Create(pAJsonString: string);
begin
  FProfilePicThumbObj := TProfilePicThumbObjClass.Create(FJsonString, [TJsonOption.joIgnoreEmptyStrings]);
  inherited Create(pAJsonString, [TJsonOption.joIgnoreEmptyStrings]);
end;

destructor TContactClass.Destroy;
begin
  FreeAndNil(FProfilePicThumbObj);//.free;
  inherited;
end;

{TResultClass}
constructor TChatClass.Create(pAJsonString: string);
begin
  FLastReceivedKey := TLastReceivedKeyClass.Create(JsonString);
  FContact         := TContactClass.Create(JsonString);
  FGroupMetadata   := TGroupMetadataClass.Create(JsonString);
  inherited Create(pAJsonString, [joDateIsUTC, joDateFormatISO8601]);
end;

destructor TChatClass.Destroy;
begin
  ClearArray(FMessages);
  FreeAndNil(FPresence);
  FreeAndNil(FLastReceivedKey);//.free;
  FreeAndNil(FContact);//.free;
  FreeAndNil(FGroupMetadata);//.free;
  inherited;
end;

{TRetornoAllContacts}
constructor TRetornoAllContacts.Create(pAJsonString: string);
begin
 inherited Create(pAJsonString, [TJsonOption.joIgnoreEmptyStrings]);
end;

{TSenderClass}
constructor TSenderClass.Create(pAJsonString: string);
begin
  FProfilePicThumbObj := TProfilePicThumbObjClass.Create(JsonString, JsonOption);
  inherited Create(pAJsonString, [joDateIsUTC, joDateFormatISO8601]);
end;

destructor TSenderClass.Destroy;
begin
  FreeAndNil(FProfilePicThumbObj);//.free;
  inherited;
end;

{TMessagesClass}
constructor TMessagesClass.Create(pAJsonString: string);
begin
  FSender    := TSenderClass.Create(JsonString);
  FChat      := TChatClass.Create(JsonString);
  FMediaData := TMediaDataClass.Create(JsonString);
  inherited Create(pAJsonString, [joDateIsUTC, joDateFormatISO8601]);
end;

destructor TMessagesClass.Destroy;
begin
  FreeAndNil(FSender);//.free;
  FreeAndNil(FChat);//.free;
  FreeAndNil(FMediaData);//.free;
  inherited;
end;

{ TQrCodeClass }
constructor TQrCodeClass.Create(pAJsonString: string; PJsonOption: TJsonOptions; PTagRequired: TQrCodeRets);
var
  lCode : String;
  LAchou: Boolean;
begin
  lCode  := copy(pAJsonString, 42, 4);
  LAchou := False;
  FTags  := [];

  if PTagRequired <> [] Then
  Begin
    If PTagRequired = [TQR_Http]  Then
    Begin
      if (AnsiUpperCase(lCode) = AnsiUpperCase('http')) Then
         LAchou:= true;
    end;
    If PTagRequired = [TQR_Img]  Then
    Begin
      if (AnsiUpperCase(lCode) = AnsiUpperCase('/img')) Then
         LAchou:= true;
    end;
    If PTagRequired = [TQR_Data]  Then
    Begin
      if (AnsiUpperCase(lCode) = AnsiUpperCase('data')) Then
         LAchou:= true;
    end;
    if Not LAchou Then
        Abort;
  End else
  begin
    if (AnsiUpperCase(lCode) = AnsiUpperCase('http')) Then
       FTags := FTags + [TQR_Http];
    if (AnsiUpperCase(lCode) = AnsiUpperCase('/img')) Then
       FTags := FTags + [TQR_Img];
    if (AnsiUpperCase(lCode) = AnsiUpperCase('data')) Then
       FTags := FTags + [TQR_Data];
  end;
  inherited Create(pAJsonString, [joDateIsUTC, joDateFormatISO8601]);
  FResult.ProcessQRCodeImage;
end;

destructor TQrCodeClass.Destroy;
begin
  FreeandNil(FResult);

  inherited;
end;

{ TClassPadrao }
constructor TClassPadrao.Create(pAJsonString: string; PJsonOption: TJsonOptions = [joDateIsUTC, joDateFormatISO8601]);
var
  lAJsonObj: TJSONValue;
begin
//  LogAdd(pAJsonString , ' PRÉ PEDIDO - ' + SELF.ClassName);
  lAJsonObj := TJSONObject.ParseJSONValue(pAJsonString);
  try
   try
    if NOT Assigned(lAJsonObj) then
    Begin
//      LogAdd(pAJsonString , 'VAZIO');
      eXIT;
    End;

    TJson.JsonToObject(Self, TJSONObject(lAJsonObj) ,PJsonOption);
    FJsonString := pAJsonString;
//    LogAdd(pAJsonString , ' PÓS PEDIDO - ' + SELF.ClassName);

    FTypeHeader := StrToTypeHeader(name);
   Except
     on E : Exception do
       ShowMessage(e.Message);
   end;
  finally
    FreeAndNil(lAJsonObj);
  end;
end;

destructor TClassPadrao.Destroy;
begin
  inherited;
end;

function TClassPadrao.ToJsonString: string;
begin
  result := TJson.ObjectToJsonString(self);
end;

{ TClassPadraoList<T> }
procedure TClassPadraoList<T>.ClearArray(PArray: TArray<T>);
var
  I: Integer;
begin
   try
//     for I := 0 to Length(PArray) -1 do
      for i:= Length(PArray)-1 downto 0 do
          FreeAndNil(PArray[i]);
   finally
     SetLength(PArray, 0);
   end;
end;

destructor TClassPadraoList<T>.Destroy;
begin
  ClearArray(FResult);
  inherited;
end;

{ TPresenceClass }
constructor TPresenceClass.Create;
begin
  inherited Create(pAJsonString, [joDateIsUTC, joDateFormatISO8601]);
  FResult := FChatstates;
end;

{ TResponseMyNumber }
constructor TResponseMyNumber.Create(pAJsonString: string);
begin
  inherited Create(pAJsonString, [joDateIsUTC, joDateFormatISO8601]);
  FResult := Copy(FResult, 0 , Pos('@', FResult)-1);
end;

destructor TGroupMetadataClass.Destroy;
begin
  ClearArray(FParticipants);
  inherited;
end;

end.
