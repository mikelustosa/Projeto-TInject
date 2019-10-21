unit uClasses;

interface

uses Generics.Collections, Rest.Json;

type

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

TResultUnReadMessages = class
private
  FArchive: Boolean;
  FContact: TContactClass;
  FGroupMetadata: TGroupMetadataClass;
  FId: String;
  FIsGroup: Boolean;
  FIsReadOnly: Boolean;
  FKind: String;
  FLastReceivedKey: TLastReceivedKeyClass;
  FModifyTag: Extended;
  FMuteExpiration: Extended;
  FName: String;
  FNotSpam: Boolean;
  FPendingMsgs: Boolean;
  FPin: Extended;
  FT: Extended;
  FUnreadCount: Extended;
public
  property archive: Boolean read FArchive write FArchive;
  property contact: TContactClass read FContact write FContact;
  property groupMetadata: TGroupMetadataClass read FGroupMetadata write FGroupMetadata;
  property id: String read FId write FId;
  property isGroup: Boolean read FIsGroup write FIsGroup;
  property isReadOnly: Boolean read FIsReadOnly write FIsReadOnly;
  property kind: String read FKind write FKind;
  property lastReceivedKey: TLastReceivedKeyClass read FLastReceivedKey write FLastReceivedKey;
  property modifyTag: Extended read FModifyTag write FModifyTag;
  property muteExpiration: Extended read FMuteExpiration write FMuteExpiration;
  property name: String read FName write FName;
  property notSpam: Boolean read FNotSpam write FNotSpam;
  property pendingMsgs: Boolean read FPendingMsgs write FPendingMsgs;
  property pin: Extended read FPin write FPin;
  property t: Extended read FT write FT;
  property unreadCount: Extended read FUnreadCount write FUnreadCount;
  constructor Create;
  destructor Destroy; override;
  function ToJsonString: string;
  class function FromJsonString(AJsonString: string): TResultUnReadMessages;
end;

TRetornoUnReadMessages = class
private
  FResult: TArray<TResultUnReadMessages>;
public
  property result: TArray<TResultUnReadMessages> read FResult write FResult;
  destructor Destroy; override;
  function ToJsonString: string;
  class function FromJsonString(AJsonString: string): TRetornoUnReadMessages;
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

implementation

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

constructor TResultUnReadMessages.Create;
begin
  inherited;
  FLastReceivedKey := TLastReceivedKeyClass.Create();
  FContact := TContactClass.Create();
  FGroupMetadata := TGroupMetadataClass.Create();
end;

destructor TResultUnReadMessages.Destroy;
begin
  FLastReceivedKey.free;
  FContact.free;
  FGroupMetadata.free;
  inherited;
end;

function TResultUnReadMessages.ToJsonString: string;
begin
  result := TJson.ObjectToJsonString(self);
end;

class function TResultUnReadMessages.FromJsonString(AJsonString: string): TResultUnReadMessages;
begin
  result := TJson.JsonToObject<TResultUnReadMessages>(AJsonString)
end;

{TRetornoClass}

destructor TRetornoUnReadMessages.Destroy;
var
  LresultItem: TResultUnReadMessages;
begin

 for LresultItem in FResult do
   LresultItem.free;

  inherited;
end;

function TRetornoUnReadMessages.ToJsonString: string;
begin
  result := TJson.ObjectToJsonString(self);
end;

class function TRetornoUnReadMessages.FromJsonString(AJsonString: string): TRetornoUnReadMessages;
begin
  result := TJson.JsonToObject<TRetornoUnReadMessages>(AJsonString)
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

end.

