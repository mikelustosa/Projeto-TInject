unit uClasses;

interface

uses Generics.Collections, Rest.Json, u_view_qrcode;

type

//forware
TChatClass = class;   //forward
TLabelsClass = class; //forward
TSenderClass = class; //forward


{ResultQRCodeClass}
TResultQRCodeClass = class
private
  FAQrCode: String;
public
  property AQrCode: String read FAQrCode write FAQrCode;
  function ToJsonString: string;
  class function FromJsonString(AJsonString: string): TResultQRCodeClass;

end;

{QRCodeClass Root}
TQrCodeClass = class
private
  FName: String;
  FResult: TResultQRCodeClass;
public
  property name: String read FName write FName;
  property result: TResultQRCodeClass read FResult write FResult;
  constructor Create;
  destructor Destroy; override;
  function ToJsonString: string;
  class function FromJsonString(AJsonString: string): TQrCodeClass;
end;

TResponseConsoleMessage = class
private
  FName: String;
  FResult: String;
public
  property Name: String read FName;
  property Result: String read FResult;
  function ToJsonString: string;
  class function FromJsonString(AJsonString: string): TResponseConsoleMessage;
end;

TMediaDataClass = class
private
  //Teste: String;
public
  function ToJsonString: string;
  class function FromJsonString(AJsonString: string): TMediaDataClass;
end;

TChatstatesClass = class
private
  FTeste: String;
public
  property teste: String read FTeste write FTeste;
  function ToJsonString: string;
  class function FromJsonString(AJsonString: string): TChatstatesClass;
end;

TPresenceClass = class
private
  FChatstates: TArray<TChatstatesClass>;
  FId: String;
public
  property chatstates: TArray<TChatstatesClass> read FChatstates write FChatstates;
  property id: String read FId write FId;
  destructor Destroy; override;
  function ToJsonString: string;
  class function FromJsonString(AJsonString: string): TPresenceClass;
end;



TParticipantsClass = class
private
  FId: String;
  FIsAdmin: Boolean;
  FIsSuperAdmin: Boolean;
public
  property id: String read FId write FId;
  property isAdmin: Boolean read FIsAdmin write FIsAdmin;
  property isSuperAdmin: Boolean read FIsSuperAdmin write FIsSuperAdmin;
  function ToJsonString: string;
  class function FromJsonString(AJsonString: string): TParticipantsClass;
end;

TGroupMetadataClass = class
private
  FCreation: Extended;
  FDesc: String;
  FDescId: String;
  FDescOwner: String;
  FDescTime: Extended;
  FId: String;
  FOwner: String;
  FParticipants: TArray<TParticipantsClass>;
  FRestrict: Boolean;
public
  property creation: Extended read FCreation write FCreation;
  property desc: String read FDesc write FDesc;
  property descId: String read FDescId write FDescId;
  property descOwner: String read FDescOwner write FDescOwner;
  property descTime: Extended read FDescTime write FDescTime;
  property id: String read FId write FId;
  property owner: String read FOwner write FOwner;
  property participants: TArray<TParticipantsClass> read FParticipants write FParticipants;
  property restrict: Boolean read FRestrict write FRestrict;
  destructor Destroy; override;
  function ToJsonString: string;
  class function FromJsonString(AJsonString: string): TGroupMetadataClass;
end;

TProfilePicThumbObjClass = class
private
  FEurl: String;
  FId: String;
  FImg: String;
  FImgFull: String;
  FTag: String;
public
  property eurl: String read FEurl write FEurl;
  property id: String read FId write FId;
  property img: String read FImg write FImg;
  property imgFull: String read FImgFull write FImgFull;
  property tag: String read FTag write FTag;
  function ToJsonString: string;
  class function FromJsonString(AJsonString: string): TProfilePicThumbObjClass;
end;

TContactClass = class
private
  FFormattedName: String;
  FGlobal: String;
  FId: String;
  FIsBusiness: Boolean;
  FIsEnterprise: Boolean;
  FIsMe: Boolean;
  FIsMyContact: Boolean;
  FIsPSA: Boolean;
  FIsUser: Boolean;
  FIsWAContact: Boolean;
  FName: String;
  FProfilePicThumbObj: TProfilePicThumbObjClass;
  FStatusMute: Boolean;
  FLabels: TArray<TLabelsClass>;
  FType: String;
public
  property formattedName: String read FFormattedName write FFormattedName;
  property Global: String read FGlobal write FGlobal;
  property id: String read FId write FId;
  property isBusiness: Boolean read FIsBusiness write FIsBusiness;
  property isEnterprise: Boolean read FIsEnterprise write FIsEnterprise;
  property isMe: Boolean read FIsMe write FIsMe;
  property isMyContact: Boolean read FIsMyContact write FIsMyContact;
  property isPSA: Boolean read FIsPSA write FIsPSA;
  property isUser: Boolean read FIsUser write FIsUser;
  property isWAContact: Boolean read FIsWAContact write FIsWAContact;
  property name: String read FName write FName;
  property profilePicThumbObj: TProfilePicThumbObjClass read FProfilePicThumbObj write FProfilePicThumbObj;
  property statusMute: Boolean read FStatusMute write FStatusMute;
  property labels: TArray<TLabelsClass> read FLabels write FLabels;
  property &type: String read FType write FType;
  constructor Create;
  destructor Destroy; override;
  function ToJsonString: string;
  class function FromJsonString(AJsonString: string): TContactClass;
end;

TLastReceivedKeyClass = class
private
  F_serialized: String;
  FFromMe: Boolean;
  FId: String;
  FRemote: String;
public
  property _serialized: String read F_serialized write F_serialized;
  property fromMe: Boolean read FFromMe write FFromMe;
  property id: String read FId write FId;
  property remote: String read FRemote write FRemote;
  function ToJsonString: string;
  class function FromJsonString(AJsonString: string): TLastReceivedKeyClass;
end;

TMentionedJidListClass = class
private
  FTeste: String;
public
  property teste: String read FTeste write FTeste;
  function ToJsonString: string;
  class function FromJsonString(AJsonString: string): TMentionedJidListClass;
end;

TMessagesClass = class
private
  FAck: Extended;
  FBody: String;
  FBroadcast: Boolean;
  FChat: TChatClass;
  FChatId: String;
  FContent: String;
  FFrom: String;
  FId: String;
  FInvis: Boolean;
  FIsForwarded: Boolean;
  FIsGroupMsg: Boolean;
  FIsMMS: Boolean;
  FIsMedia: Boolean;
  FIsNewMsg: Boolean;
  FIsNotification: Boolean;
  FIsPSA: Boolean;
  FLabels: TArray<TLabelsClass>;
  FMediaData: TMediaDataClass;
  FMentionedJidList: TArray<TMentionedJidListClass>;
  FNotifyName: String;
  FRecvFresh: Boolean;
  FSelf: String;
  FSender: TSenderClass;
  FStar: Boolean;
  FT: Extended;
  FTimestamp: Extended;
  FTo: String;
  FType: String;
public
  property ack: Extended read FAck write FAck;
  property body: String read FBody write FBody;
  property broadcast: Boolean read FBroadcast write FBroadcast;
  property chat: TChatClass read FChat write FChat;
  property chatId: String read FChatId write FChatId;
  property content: String read FContent write FContent;
  property from: String read FFrom write FFrom;
  property id: String read FId write FId;
  property invis: Boolean read FInvis write FInvis;
  property isForwarded: Boolean read FIsForwarded write FIsForwarded;
  property isGroupMsg: Boolean read FIsGroupMsg write FIsGroupMsg;
  property isMMS: Boolean read FIsMMS write FIsMMS;
  property isMedia: Boolean read FIsMedia write FIsMedia;
  property isNewMsg: Boolean read FIsNewMsg write FIsNewMsg;
  property isNotification: Boolean read FIsNotification write FIsNotification;
  property isPSA: Boolean read FIsPSA write FIsPSA;
  property labels: TArray<TLabelsClass> read FLabels write FLabels;
  property mediaData: TMediaDataClass read FMediaData write FMediaData;
  property mentionedJidList: TArray<TMentionedJidListClass> read FMentionedJidList write FMentionedJidList;
  property notifyName: String read FNotifyName write FNotifyName;
  property recvFresh: Boolean read FRecvFresh write FRecvFresh;
  property self: String read FSelf write FSelf;
  property sender: TSenderClass read FSender write FSender;
  property star: Boolean read FStar write FStar;
  property t: Extended read FT write FT;
  property timestamp: Extended read FTimestamp write FTimestamp;
  property toMessage: String read FTo write FTo;
  property &type: String read FType write FType;
  constructor Create;
  destructor Destroy; override;
  function ToJsonString: string;
  class function FromJsonString(AJsonString: string): TMessagesClass;
end;

TChatClass = class
private
  FArchive: Boolean;
  FContact: TContactClass;
  FGroupMetadata: TGroupMetadataClass;
  FId: String;
  FIsAnnounceGrpRestrict: Boolean;
  FIsGroup: Boolean;
  FIsReadOnly: Boolean;
  FKind: String;
  FLastReceivedKey: TLastReceivedKeyClass;
  FMessages: TArray<TMessagesClass>;
  FModifyTag: Extended;
  FMuteExpiration: Extended;
  FName: String;
  FNotSpam: Boolean;
  FPendingMsgs: Boolean;
  FPin: Extended;
  FPresence: TPresenceClass;
  FT: Extended;
  FUnreadCount: Extended;
public
  property archive: Boolean read FArchive write FArchive;
  property contact: TContactClass read FContact write FContact;
  property groupMetadata: TGroupMetadataClass read FGroupMetadata write FGroupMetadata;
  property id: String read FId write FId;
  property isAnnounceGrpRestrict: Boolean read FIsAnnounceGrpRestrict write FIsAnnounceGrpRestrict;
  property isGroup: Boolean read FIsGroup write FIsGroup;
  property isReadOnly: Boolean read FIsReadOnly write FIsReadOnly;
  property kind: String read FKind write FKind;
  property lastReceivedKey: TLastReceivedKeyClass read FLastReceivedKey write FLastReceivedKey;
  property messages: TArray<TMessagesClass> read FMessages write FMessages;
  property modifyTag: Extended read FModifyTag write FModifyTag;
  property muteExpiration: Extended read FMuteExpiration write FMuteExpiration;
  property name: String read FName write FName;
  property notSpam: Boolean read FNotSpam write FNotSpam;
  property pendingMsgs: Boolean read FPendingMsgs write FPendingMsgs;
  property pin: Extended read FPin write FPin;
  property presence: TPresenceClass read FPresence write FPresence;
  property t: Extended read FT write FT;
  property unreadCount: Extended read FUnreadCount write FUnreadCount;
  constructor Create;
  destructor Destroy; override;
  function ToJsonString: string;
  class function FromJsonString(AJsonString: string): TChatClass;
end;

TChatList = class
private
  FResult: TArray<TChatClass>;
public
  property result: TArray<TChatClass> read FResult write FResult;
  destructor Destroy; override;
  function ToJsonString: string;
  class function FromJsonString(AJsonString: string): TChatList;
end;

TRetornoAllContacts = class
private
  FResult: TArray<TContactClass>;
public
  property result: TArray<TContactClass> read FResult write FResult;
  destructor Destroy; override;
  function ToJsonString: string;
  class function FromJsonString(AJsonString: string): TRetornoAllContacts;
end;

TLabelsClass = class
private
  FTeste: String;
public
  property teste: String read FTeste write FTeste;
  function ToJsonString: string;
  class function FromJsonString(AJsonString: string): TLabelsClass;
end;

TSenderClass = class
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
  FLabels: TArray<TLabelsClass>;
  FProfilePicThumbObj: TProfilePicThumbObjClass;
  FPushname: String;
  FStatusMute: Boolean;
  FType: String;
public
  property formattedName: String read FFormattedName write FFormattedName;
  property id: String read FId write FId;
  property isBusiness: Boolean read FIsBusiness write FIsBusiness;
  property isEnterprise: Boolean read FIsEnterprise write FIsEnterprise;
  property isMe: Boolean read FIsMe write FIsMe;
  property isMyContact: Boolean read FIsMyContact write FIsMyContact;
  property isPSA: Boolean read FIsPSA write FIsPSA;
  property isUser: Boolean read FIsUser write FIsUser;
  property isWAContact: Boolean read FIsWAContact write FIsWAContact;
  property labels: TArray<TLabelsClass> read FLabels write FLabels;
  property profilePicThumbObj: TProfilePicThumbObjClass read FProfilePicThumbObj write FProfilePicThumbObj;
  property pushname: String read FPushname write FPushname;
  property statusMute: Boolean read FStatusMute write FStatusMute;
  property &type: String read FType write FType;
  constructor Create;
  destructor Destroy; override;
  function ToJsonString: string;
  class function FromJsonString(AJsonString: string): TSenderClass;
end;


implementation

uses
  System.JSON, System.SysUtils, Vcl.Dialogs;

{TResultQRCodeClass}

function TResultQRCodeClass.ToJsonString: string;
begin
  result := TJson.ObjectToJsonString(self);
end;

class function TResultQRCodeClass.FromJsonString(AJsonString: string): TResultQRCodeClass;
begin
  result := TJson.JsonToObject<TResultQRCodeClass>(AJsonString)
end;


{TQrCodeClass}

constructor TQrCodeClass.Create;
begin
  inherited;
  FResult := TResultQRCodeClass.Create();
end;

destructor TQrCodeClass.Destroy;
begin
  FResult.free;
  inherited;
end;

function TQrCodeClass.ToJsonString: string;
begin
  result := TJson.ObjectToJsonString(self);
end;

{ TResponseConsoleMessage }

class function TResponseConsoleMessage.FromJsonString(
  AJsonString: string): TResponseConsoleMessage;
var
  AJsonObj: TJSONValue;
begin
  Result := nil;

  AJsonObj := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(AJsonString),0);
  try
    if Assigned( AJsonObj ) then
       Result := TJson.JsonToObject<TResponseConsoleMessage>(AJsonString);
  finally
    AJsonObj.Free;
  end;
end;

function TResponseConsoleMessage.ToJsonString: string;
begin
  result := TJson.ObjectToJsonString(self);
end;

{TMediaDataClass}


function TMediaDataClass.ToJsonString: string;
begin
  result := TJson.ObjectToJsonString(self);
end;

class function TMediaDataClass.FromJsonString(AJsonString: string): TMediaDataClass;
begin
  result := TJson.JsonToObject<TMediaDataClass>(AJsonString)
end;

{TChatstatesClass}


function TChatstatesClass.ToJsonString: string;
begin
  result := TJson.ObjectToJsonString(self);
end;

class function TChatstatesClass.FromJsonString(AJsonString: string): TChatstatesClass;
begin
  result := TJson.JsonToObject<TChatstatesClass>(AJsonString)
end;

{TPresenceClass}

destructor TPresenceClass.Destroy;
var
  LchatstatesItem: TChatstatesClass;
begin

 for LchatstatesItem in FChatstates do
   LchatstatesItem.free;

  inherited;
end;

function TPresenceClass.ToJsonString: string;
begin
  result := TJson.ObjectToJsonString(self);
end;

class function TPresenceClass.FromJsonString(AJsonString: string): TPresenceClass;
begin
  result := TJson.JsonToObject<TPresenceClass>(AJsonString)
end;

{TParticipantsClass}


function TParticipantsClass.ToJsonString: string;
begin
  result := TJson.ObjectToJsonString(self);
end;

class function TParticipantsClass.FromJsonString(AJsonString: string): TParticipantsClass;
begin
  result := TJson.JsonToObject<TParticipantsClass>(AJsonString)
end;

{TGroupMetadataClass}

destructor TGroupMetadataClass.Destroy;
var
  LparticipantsItem: TParticipantsClass;
begin

 for LparticipantsItem in FParticipants do
   LparticipantsItem.free;

  inherited;
end;

function TGroupMetadataClass.ToJsonString: string;
begin
  result := TJson.ObjectToJsonString(self);
end;

class function TGroupMetadataClass.FromJsonString(AJsonString: string): TGroupMetadataClass;
begin
  result := TJson.JsonToObject<TGroupMetadataClass>(AJsonString)
end;

{TProfilePicThumbObjClass}


function TProfilePicThumbObjClass.ToJsonString: string;
begin
  result := TJson.ObjectToJsonString(self);
end;

class function TProfilePicThumbObjClass.FromJsonString(AJsonString: string): TProfilePicThumbObjClass;
begin
  result := TJson.JsonToObject<TProfilePicThumbObjClass>(AJsonString)
end;

{TContactClass}

constructor TContactClass.Create;
begin
  inherited;
  FProfilePicThumbObj := TProfilePicThumbObjClass.Create();
end;

destructor TContactClass.Destroy;
begin
  FProfilePicThumbObj.free;
  inherited;
end;

function TContactClass.ToJsonString: string;
begin
  result := TJson.ObjectToJsonString(self);
end;

class function TContactClass.FromJsonString(AJsonString: string): TContactClass;
begin
  result := TJson.JsonToObject<TContactClass>(AJsonString)
end;

{TLastReceivedKeyClass}


function TLastReceivedKeyClass.ToJsonString: string;
begin
  result := TJson.ObjectToJsonString(self);
end;

class function TLastReceivedKeyClass.FromJsonString(AJsonString: string): TLastReceivedKeyClass;
begin
  result := TJson.JsonToObject<TLastReceivedKeyClass>(AJsonString)
end;

{TResultClass}

constructor TChatClass.Create;
begin
  inherited;
  FLastReceivedKey := TLastReceivedKeyClass.Create();
  FContact := TContactClass.Create();
  FGroupMetadata := TGroupMetadataClass.Create();
end;

destructor TChatClass.Destroy;
var
  LmessagesItem: TMessagesClass;
begin
  FreeAndNil(FPresence);
  for LmessagesItem in FMessages do
      LmessagesItem.free;

  FLastReceivedKey.free;
  FContact.free;
  FGroupMetadata.free;
  inherited;
end;

function TChatClass.ToJsonString: string;
begin
  result := TJson.ObjectToJsonString(self);
end;

class function TChatClass.FromJsonString(AJsonString: string): TChatClass;
begin
  result := TJson.JsonToObject<TChatClass>(AJsonString)
end;

{TRetornoClass}

destructor TChatList.Destroy;
var
  LresultItem: TChatClass;
begin

 for LresultItem in FResult do
   LresultItem.free;

  inherited;
end;

function TChatList.ToJsonString: string;
begin
  result := TJson.ObjectToJsonString(self);
end;

class function TChatList.FromJsonString(AJsonString: string): TChatList;
begin
  result := TJson.JsonToObject<TChatList>(AJsonString)
end;

{TRetornoAllContacts}

destructor TRetornoAllContacts.Destroy;
var
  LresultItem: TContactClass;
begin

 for LresultItem in FResult do
   LresultItem.free;

  inherited;
end;

function TRetornoAllContacts.ToJsonString: string;
begin
  result := TJson.ObjectToJsonString(self);
end;

class function TRetornoAllContacts.FromJsonString(AJsonString: string): TRetornoAllContacts;
begin
  result := TJson.JsonToObject<TRetornoAllContacts>(AJsonString, [TJsonOption.joIgnoreEmptyStrings])
end;

{TLabelsClass}

function TLabelsClass.ToJsonString: string;
begin
  result := TJson.ObjectToJsonString(self);
end;

class function TLabelsClass.FromJsonString(AJsonString: string): TLabelsClass;
begin
  result := TJson.JsonToObject<TLabelsClass>(AJsonString)
end;

{TSenderClass}

constructor TSenderClass.Create;
begin
  inherited;
  FProfilePicThumbObj := TProfilePicThumbObjClass.Create();
end;

destructor TSenderClass.Destroy;
var
  LlabelsItem: TLabelsClass;
begin

 for LlabelsItem in FLabels do
   LlabelsItem.free;

  FProfilePicThumbObj.free;
  inherited;
end;

function TSenderClass.ToJsonString: string;
begin
  result := TJson.ObjectToJsonString(self);
end;

class function TSenderClass.FromJsonString(AJsonString: string): TSenderClass;
begin
  result := TJson.JsonToObject<TSenderClass>(AJsonString)
end;

{TMentionedJidListClass}


function TMentionedJidListClass.ToJsonString: string;
begin
  result := TJson.ObjectToJsonString(self);
end;

class function TMentionedJidListClass.FromJsonString(AJsonString: string): TMentionedJidListClass;
begin
  result := TJson.JsonToObject<TMentionedJidListClass>(AJsonString)
end;

{TMessagesClass}

constructor TMessagesClass.Create;
begin
  inherited;
  FSender := TSenderClass.Create();
  FChat := TChatClass.Create();
  FMediaData := TMediaDataClass.Create();
end;

destructor TMessagesClass.Destroy;
var
  LmentionedJidListItem: TMentionedJidListClass;
  LlabelsItem: TLabelsClass;
begin

 for LmentionedJidListItem in FMentionedJidList do
   LmentionedJidListItem.free;
 for LlabelsItem in FLabels do
   LlabelsItem.free;

  FSender.free;
  FChat.free;
  FMediaData.free;
  inherited;
end;

function TMessagesClass.ToJsonString: string;
begin
  result := TJson.ObjectToJsonString(self);
end;

class function TMessagesClass.FromJsonString(AJsonString: string): TMessagesClass;
begin
  result := TJson.JsonToObject<TMessagesClass>(AJsonString)

  //After.... Value to Property Alter Name reserved ("to" -> "toMessage")
  //result.toMessage := GetValue("to")
end;



{ TQrCodeClass }

class function TQrCodeClass.FromJsonString(AJsonString: string): TQrCodeClass;
begin
  result := TJson.JsonToObject<TQrCodeClass>(AJsonString)
end;


end.
