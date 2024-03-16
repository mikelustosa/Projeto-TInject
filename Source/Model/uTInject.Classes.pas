{####################################################################################################################
                              TINJECT - Componente de comunicação (Não Oficial)
                                            www.tinject.com.br
                                            Novembro de 2019
####################################################################################################################
    Owner.....: Mike W. Lustosa            - mikelustosa@gmail.com   - +55 81 9.9630-2385
    Developer.: Joathan Theiller           - jtheiller@hotmail.com   -
                Daniel Oliveira Rodrigues  - Dor_poa@hotmail.com     - +55 51 9.9155-9228
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
  Autor........: Luiz Alves
  Email........: cprmlao@gmail.com
  Data.........: 17/12/2019
  Identificador: @LuizAlvez
  Modificação..: Adicionadas novas propriedades das mensagens conforme verificação com o LOG
####################################################################################################################}

unit uTInject.Classes;

interface

{$I TInjectDiretiva.inc}

uses Generics.Collections, Rest.Json, uTInject.FrmQRCode, Vcl.Graphics, System.IOUtils,
  System.Classes, uTInject.Constant, IdHTTP, Vcl.ExtCtrls,
 {$IFDEF DELPHI25_UP}
    Vcl.IdAntiFreeze,
  {$ENDIF}
  IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, Vcl.Imaging.jpeg,
  IdSSLOpenSSL, UrlMon, system.JSON;

type

  TQrCodeRet   = (TQR_Http, TQR_Img, TQR_Data);
  TQrCodeRets  = set of TQrCodeRet;
  TChatClass   = class;   //forward
  TSenderClass = class;   //forward
  TTypeNumber  = (TypUndefined=0, TypContact=1, TypGroup=2, TypList=3);
  TFormaUpdate = (Tup_Local=0, Tup_Web=1);

  TNotificationCenter    = procedure(PTypeHeader: TTypeHeader; PValue: String; Const PReturnClass : TObject = nil) of object;
  TOnErroInternal        = procedure(Sender : TObject; Const PError: String; Const PInfoAdc:String)  of object;
  TDown_State            = (TDw_Wait=0, TDw_Start=1, TDw_CanceledErro=2,  TDw_CanceledUser=3,  TDw_Completed=4);


  TUrlIndy = class(TIdHTTP)
  Private
    FTImeOutIndy       : TTimer;
    FTimeOut           : Integer;
   {$IFDEF DELPHI25_UP}
      FIdAntiFreeze      : TIdAntiFreeze;
   {$ENDIF}
    FReturnUrl         : TMemoryStream;
    FShowException     : Boolean;
    SSIOHandler        : TIdSSLIOHandlerSocketOpenSSL;
    Procedure  OnTimeOutIndy(Sender: TObject);
    function DownLoadInternetFile(Source, Dest: String): Boolean;
  Public
    constructor Create;
    destructor  Destroy; override;
    Function    GetUrl(Const Purl:String):Boolean;

    Property    ReturnUrl  : TMemoryStream         Read FReturnUrl;


    Property    TimeOut : Integer         Read FTimeOut        Write FTimeOut;
    Property    ShowException: Boolean    Read FShowException  Write FShowException;
  end;


  TClassPadrao = class
  private
    FJsonString : String;
    FJsonOption : TJsonOptions;
    FName       : String;
    FTypeHeader : TTypeHeader;
    FInjectWorking: Boolean;
  public
    property InjectWorking : Boolean Read FInjectWorking  Write FInjectWorking;

    constructor Create(pAJsonString: string; PJsonOption: TJsonOptions = JsonOptionClassPadrao);
    destructor  Destroy; override;
    property Name        : String         read FName;
    Property TypeHeader  : TTypeHeader    Read FTypeHeader;
    Property JsonOption  : TJsonOptions   Read FJsonOption;
    Property JsonString  : String         Read FJsonString;
    function ToJsonString: string;
    procedure RemoveObjectsFromJson(var json: TJSONObject);
  end;

  TClassPadraoString = class(TClassPadrao)
  private
    FResult: String;
  public
    property Result: String           read FResult;
  end;


  TClassAllGroupContacts = class
  private
    FResult: String;
  public
    constructor Create(pAJsonString: string; PJsonOption: TJsonOptions = JsonOptionClassPadrao);
    property result: String read FResult write FResult;
    function ToJsonString: string;
    class function FromJsonString(AJsonString: string): TClassAllGroupContacts;
  end;


  TClassPadraoList<T> = class(TClassPadrao)
  private
    FResult: TArray<T>;
  public
    Procedure  ClearArray(PArray : TArray<T>);
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

  TResponseBattery = class(TClassPadrao)//class(TClassPadraoString)
  private
    FResult: string;
  Public
    Property Result : string  Read FResult  Write FResult;
  end;

  TResponseCheckIsValidNumber = class(TClassPadrao)
  private
    FResult: Boolean;
    fNumber: String;
  Public
    Property Result : Boolean  Read FResult  Write FResult;
    Property Number : String   Read fNumber  Write fNumber;
  end;

//  TResponseCheckDelivered = class(TClassPadrao) //Remover
//  private
//    FStatus: integer;
//    FStatusDelivered: String;
//  Public
//    Property status : integer  Read FStatus  Write FStatus;
//    Property StatusDelivered : string  Read FStatusDelivered  Write FStatusDelivered;
//  end;

  TResponseCheckIsConnected = class(TClassPadrao)
  private
    FResult: Boolean;
  Public
    Property Result : Boolean  Read FResult  Write FResult;
  end;


  TResponseGetProfilePicThumb = class(TClassPadrao)
  private
    fBase64: String;
  Public
    Property Base64 : String   Read fBase64  Write fBase64;
    constructor Create(pAJsonString: string);
    destructor  Destroy;       override;
  end;


  TOnChangeConnect = class(TClassPadrao)
  private
    FResult: Boolean;
  Public
    Property Result : Boolean  Read FResult  Write FResult;
  end;

  TMediaDataPreviewClass = class(TClassPadrao)
  Private
    F_retainCount      : Integer;
    F_inAutoreleasePool: Boolean;
    Freleased          : Boolean;
    Fbody              : String;
    F_b64              : String;
  public
    property _retainCount      : Integer   Read F_retainCount        Write F_retainCount;
    property _inAutoreleasePool: Boolean   Read F_inAutoreleasePool  Write F_inAutoreleasePool;
    property released          : Boolean   Read Freleased            Write Freleased;
    property body              : String    Read Fbody                Write Fbody;
    property _b64              : String    Read F_b64                Write F_b64;
  end;


  TMediaData_BlobClass = class(TClassPadrao)
  Private
    F_mimetype: String;
    F_url: String;
  Public
     property _url            : String        Read F_url                        Write F_url;
     property _mimetype       : String        Read F_mimetype                   Write F_mimetype;
  end;

  TMediaDataBlobClass = class(TClassPadrao)
  Private
    F_blob: TMediaData_BlobClass;
    F_retainCount: Integer;
    F_inAutoreleasePool: Boolean;
    Freleased: Boolean;
  Public
     constructor Create(pAJsonString: string);
     destructor  Destroy;       override;

     property _retainCount        : Integer              Read F_retainCount             Write F_retainCount;
     property _inAutoreleasePool  : Boolean              Read F_inAutoreleasePool       Write F_inAutoreleasePool;
     property released            : Boolean              Read Freleased                 Write Freleased;
     property _blob               : TMediaData_BlobClass Read F_blob                    Write F_blob;
  end;

  TMediaDataClass = class(TClassPadrao)
  Private
     Ftype                  : String;
     FmediaStage            : String;
     Fsize                  : Extended;
     Ffilehash              : String;
     Fmimetype              : String;
     FmediaBlob             : String;
     //FrenderableUrl         : String;
     FfullHeight            : Integer;
     FfullWidth             : Integer;
     FaspectRatio           : double;
     FanimationDuration     : Extended;
     FanimatedAsNewMsg      : Boolean;
     F_swStreamingSupported : Boolean;
     F_listeningToSwSupport : Boolean;
     Fpreview: TMediaDataPreviewClass;
  public
     constructor Create(pAJsonString: string);
     destructor  Destroy;       override;

     property &type                 : String        Read Ftype                        Write Ftype;
     property mediaStage            : String        Read FmediaStage                  Write FmediaStage;
     property size                  : Extended      Read Fsize                        Write Fsize;
     property filehash              : String        Read Ffilehash                    Write Ffilehash;
     property mimetype              : String        Read Fmimetype                    Write Fmimetype;
     property mediaBlob             : String        Read FmediaBlob                   Write FmediaBlob;
     property fullHeight            : Integer       Read FfullHeight                  Write FfullHeight;
     property fullWidth             : Integer       Read FfullWidth                   Write FfullWidth;
     property aspectRatio           : double        Read FaspectRatio                 Write FaspectRatio;
     property animationDuration     : Extended      Read FanimationDuration           Write FanimationDuration;
     property animatedAsNewMsg      : Boolean       Read FanimatedAsNewMsg            Write FanimatedAsNewMsg;
     property _swStreamingSupported : Boolean       Read F_swStreamingSupported       Write F_swStreamingSupported;
     property _listeningToSwSupport : Boolean       Read F_listeningToSwSupport       Write F_listeningToSwSupport;
     property preview     : TMediaDataPreviewClass  Read Fpreview                     Write Fpreview;
//     property renderableUrl         : String        Read FrenderableUrl               Write FrenderableUrl;
  end;

  TResponseMyNumber = class(TClassPadraoString)
  public
    constructor Create(pAJsonString: string);
  end;

  //Mike 29/12/2020
  TResponseIsDelivered = class(TClassPadraoString)
  public
    constructor Create(pAJsonString: string);
  end;


  TResponseIsConnected = class(TClassPadraoString) //mike
  public
    constructor Create(pAJsonString: string);
  end;

  TChatStatesClass = class(TClassPadrao)
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
    destructor Destroy; override;

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
    FPendingParticipants:TArray<TParticipantsClass>;  //@LuizAlvez
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
    property participants: TArray<TParticipantsClass>        read FParticipants        write FParticipants;
    property pendingParticipants: TArray<TParticipantsClass> read FPendingParticipants Write FPendingParticipants;  //@LuizAlvez
  end;


 TPhoneClass = class(TClassPadrao)
 private
    Fdevice_manufacturer: String;
    Fdevice_model: String;
    Fos_build_number: String;
    Fos_version: String;
    Fmnc: String;
    Fmcc: String;
    Fwa_version: String;
 public
  property device_manufacturer : String read Fdevice_manufacturer write Fdevice_manufacturer;
  property device_model        : String read Fdevice_model write Fdevice_model;
  property mcc                 : String read Fmcc write Fmcc;
  property mnc                 : String read Fmnc write Fmnc;
  property os_build_number     : String read Fos_build_number write Fos_build_number;
  property os_version          : String read Fos_version write Fos_version;
  property wa_version          : String read Fwa_version write Fwa_version;
 end;

  TResponseStatusMessage = class(TClassPadrao)
  private
   Fid : String;
   FStatus : String;
   public
    property id : String read Fid write Fid;
    property status : String read FStatus write FStatus;
  end;

  TReturnCheckNumber = class(TClassPadrao)
  private
   Fid : String;
   Fvalid : boolean;
   public
    property id : String read Fid write Fid;
    property valid : boolean  read Fvalid write Fvalid;
  end;

  TIncomingCall = class(TClassPadrao)
  private
    FID: String;
  public
    property ID : string read FID write FID;
  end;

  TReturnIncomingCall = class(TClassPadrao)
  private
   FContact : string;
  public
    constructor Create(pAJsonString: string);
    property contact : string read FContact write FContact;
  end;

 TGetMeClass = class(TClassPadrao)
   private
    Fbattery: integer;
    Flocate: String;
    Flc: String;
    FserverToken: String;
    Fplugged: boolean;
    Fpushname: String;
    Flg: String;
    Fme : String;
    Fphone : TPhoneClass;
    Fstatus : TResponseStatusMessage;
   public
    constructor Create(pAJsonString: string; PJsonOption: TJsonOptions = JsonOptionClassPadrao);
    destructor Destroy; override;
    property  battery     : integer read Fbattery write Fbattery;
    property  lc          : String read Flc write Flc;
    property  lg          : String read Flg write Flg;
    property  locate      : String read Flocate write Flocate;
    property  plugged     : boolean read Fplugged write Fplugged;
    property  pushname    : String read Fpushname write Fpushname;
    property  serverToken : String read FserverToken write FserverToken;
 // property   platform : String
    property  phone       : TPhoneClass read Fphone write Fphone;
    property  status      : TResponseStatusMessage read Fstatus write Fstatus;
    property  me          : String read Fme write Fme;
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
    FId           : String;
    FName         : String;
    Fpushname     : String;
    FType         : String;
    FverifiedName : String;
    Fmsgs         : String;
    FstatusMute   : Boolean;
    FsectionHeader : String;
    FLabels       : TArray<String>;
    FFormattedName: String;
//    FGlobal       : String;
    FIsMe         : Boolean;
    FIsMyContact  : Boolean;
    FIsPSA        : Boolean;
//    FIsBusiness   : Boolean;
//    FIsEnterprise : Boolean;
//    FisContactBlocked: Boolean;
    FIsUser       : Boolean;
    FIsWAContact  : Boolean;

    //Mike teste ok 16/02/2021 --
    FProfilePicThumb : string;
    //--

    FProfilePicThumbObj: TProfilePicThumbObjClass;
  public
    constructor Create(pAJsonString: string);
    destructor Destroy; override;

    property formattedName:  String          read FFormattedName      write FFormattedName;
//    property Global:         String          read FGlobal             write FGlobal;
    property sectionHeader:  String          read FsectionHeader      write FsectionHeader;
    property id:             String          read FId                 write FId;
    property name:           String          read FName               write FName;
    property pushname:       String          Read Fpushname           Write Fpushname;
    property verifiedName:   String          Read FverifiedName       Write FverifiedName;
//    property isBusiness:     Boolean         read FIsBusiness         write FIsBusiness;
//    property isEnterprise:   Boolean         read FIsEnterprise       write FIsEnterprise;
    property isUser:          Boolean         read FIsUser             write FIsUser;
//    property isContactBlocked: Boolean       read FisContactBlocked   write FisContactBlocked;
    property statusMute:      Boolean         read FStatusMute         write FStatusMute;
    property labels:          TArray<String>  read FLabels             write FLabels;
    property isMe:            Boolean         read FIsMe               write FIsMe;
    property isMyContact:     Boolean         read FIsMyContact        write FIsMyContact;
    property isPSA:           Boolean         read FIsPSA              write FIsPSA;
    property isWAContact:     Boolean         read FIsWAContact        write FIsWAContact;
    property profilePicThumb: string          read FProfilePicThumb    write FProfilePicThumb;


    property &type:          String          read FType               write FType;
    //property profilePicThumbObj: TProfilePicThumbObjClass read FProfilePicThumbObj write FProfilePicThumbObj;
    property Msgs:          String           read Fmsgs               write Fmsgs;
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

  //Experimental - Mike
  TButtonsClass = class(TClassPadrao)
  private
    FID            :string;
    FDisplayText   :string;
    FSubtype       :string;
    FSelectionId   :string;

  public
    property    ID          :string read FID          write FID;
    property    DisplayText :string read FDisplayText write FDisplayText;
    property    Subtype     :string read FSubtype     write FSubtype;
    property    SelectionId :string read FSelectionId write FSelectionId;
  end;

  TMessagesClass = class(TClassPadrao)
  private
    FId              : String;
    FBody            : String;
    FType            : String;
    FT               : Extended;
    FNotifyName      : String;
    FFrom            : String;
    FFromMe          : Boolean;
    FTo              : String;
    FSelf            : String;
    FAck             : Extended;
    FInvis           : Boolean;
    FIsNewMsg        : Boolean;
    FStar            : Boolean;
    FRecvFresh       : Boolean;

    FLat             : Extended;
    FLng             : Extended;

    FSubType         : String;

    FCaption         : String;

    //teste
    FdeprecatedMms3Url: string;

    FdirectPath      : String;
    Fmimetype        : String;
    Ffilehash        : String;
    Fuploadhash      : String;
    FSize            : Extended;
    Ffilename        : String;
    FmediaKey           : String;
    FmediaKeyTimestamp  : Extended;
    FpageCount          : Extended;

    FBroadcast       : Boolean;
    FMentionedJidList: TArray<String>;

    //Experimental - Mike
    FButtons          : TArray<TButtonsClass>;
    //Experimental - Mike

    FIsForwarded     : Boolean;
    FLabels          : TArray<String>;
    FSender          : TSenderClass;
    FTimestamp       : Extended;
    FContent         : String;
    FIsGroupMsg      : Boolean;
    FIsMMS           : Boolean;
    FIsMedia         : Boolean;
    FIsNotification  : Boolean;
    FIsPSA           : Boolean;
    FChat            : TChatClass;
    FChatId          : String;
    FquotedMsgObj    : String;
    FMediaData       : TMediaDataClass;
    FprofilePicThumb : string;
  public
    constructor Create(pAJsonString: string);
    destructor  Destroy;       override;

    property ack        : Extended            read FAck                write FAck;
    property body       : String              read FBody               write FBody;
    property broadcast  : Boolean             read FBroadcast          write FBroadcast;
    property chat       : TChatClass          read FChat               write FChat;
    property chatId     : String              read FChatId             write FChatId;
    property Caption    : String              Read FCaption            Write FCaption;
    property content    : String              read FContent            write FContent;
    property from       : String              read FFrom               write FFrom;
    property fromMe     : Boolean             read FFromMe             write FFromMe;
    property id         : String              read FId                 write FId;
    property invis      : Boolean             read FInvis              write FInvis;
    property isForwarded: Boolean             read FIsForwarded        write FIsForwarded;
    property isGroupMsg : Boolean             read FIsGroupMsg         write FIsGroupMsg;
    property isMMS      : Boolean             read FIsMMS              write FIsMMS;
    property isMedia    : Boolean             read FIsMedia            write FIsMedia;
    property isNewMsg   : Boolean             read FIsNewMsg           write FIsNewMsg;

    property lat        : Extended            read FLat                write FLat;
    property lng        : Extended            read FLng                write FLng;

    property subType    : String              read FSubType            write FSubType;

    property isNotification: Boolean          read FIsNotification     write FIsNotification;
    property isPSA      : Boolean             read FIsPSA              write FIsPSA;
    property labels     : TArray<String>      read FLabels             write FLabels;
    property mediaData  : TMediaDataClass     read FMediaData          write FMediaData;
    property mentionedJidList: TArray<String> read FMentionedJidList   write FMentionedJidList;

    //Experimental - Mike
    property buttons: TArray<TButtonsClass>    read FButtons             write FButtons;
    //Experimental - Mike

    property notifyName : String              read FNotifyName         write FNotifyName;
    property recvFresh  : Boolean             read FRecvFresh          write FRecvFresh;
    property self       : String              read FSelf               write FSelf;
    property mimetype   : String              read Fmimetype           Write Fmimetype;
    property filename   : String              read Ffilename           Write Ffilename;
    property deprecatedMms3Url  : String      read FdeprecatedMms3Url  Write FdeprecatedMms3Url;
    //property deprecatedMms3Url: String        read FdeprecatedMms3Url  Write FdeprecatedMms3Url;


    property directPath : String              read FdirectPath         Write FdirectPath;
    property filehash   : String              read Ffilehash           Write Ffilehash;
    property uploadhash : String              read Fuploadhash         Write Fuploadhash;
    property Size       : Extended            read FSize               Write FSize;
    property mediaKey   : String              read FmediaKey           Write FmediaKey;
    property mediaKeyTimestamp  : Extended    read FmediaKeyTimestamp  Write FmediaKeyTimestamp;
    property pageCount     : Extended         read FpageCount          Write FpageCount;
    property quotedMsgObj  : String           read FquotedMsgObj       Write FquotedMsgObj;
    property sender     : TSenderClass        read FSender             write FSender;
    property star       : Boolean             read FStar               write FStar;
    property t          : Extended            read FT                  write FT;
    property timestamp  : Extended            read FTimestamp          write FTimestamp;
    property &to        : String              read FTo                 write FTo;   //@LuizAlvez
    property &type      : String              read FType               write FType;
    property profilePicThumb       : String   read FprofilePicThumb    write FprofilePicThumb;
  end;

  TChatClass = class(TClassPadraoList<TMessagesClass>)
  private
    FId             : String;
    FPendingMsgs    : Boolean;
    FLastReceivedKey: TLastReceivedKeyClass;
    FT              : Extended;
    FUnreadCount    : Extended;
    FArchive        : Boolean;
    FIsReadOnly     : Boolean;
    FModifyTag      : Extended;
    FMuteExpiration : Extended;
    FNotSpam        : Boolean;
    FPin            : Extended;
    Fmsgs           : String;
    FKind           : String;
    FKindTypeNumber : TTypeNumber;
    FIsGroup        : Boolean;
    FContact        : TContactClass;
    FGroupMetadata  : TGroupMetadataClass;
    FPresence       : TPresenceClass;
    FMessages       : tArray<TMessagesClass>;
    FIsAnnounceGrpRestrict: Boolean;
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
    property kind           : String                      read FKind                  Write FKind;
    property KindTypeNumber : TTypeNumber                 read FKindTypeNumber;

    property lastReceivedKey: TLastReceivedKeyClass       read FLastReceivedKey       write FLastReceivedKey;
    property messages       : TArray<TMessagesClass>      read FMessages              write FMessages;
    property modifyTag      : Extended                    read FModifyTag             write FModifyTag;
    property muteExpiration : Extended                    read FMuteExpiration        write FMuteExpiration;
    property notSpam        : Boolean                     read FNotSpam               write FNotSpam;
    property pendingMsgs    : Boolean                     read FPendingMsgs           write FPendingMsgs;
    property msgs           : String                      Read Fmsgs                  Write Fmsgs ;
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

//Mike
//TRetornoAllGroups = class(TClassPadraoList<TContactClass>)
//Public
//  constructor Create(pAJsonString: string);
//end;

TRetornoAllGroups = class(TClassPadrao)
  private
    FNumbers: TStringList;
  public
    property    Numbers: TStringList   read FNumbers;
    constructor Create(pAJsonString: string);
    destructor Destroy; override;
end;


TRetornoAllGroupAdmins = class(TClassPadrao)
private
  FNumbers: TStringList;
public
  property    Numbers: TStringList   read FNumbers;
  constructor Create(pAJsonString: string);
  destructor Destroy; override;
end;

//TRetornoAllGroups = class(TClassPadraoList<TClassGetAllGroupContacts>)
//Public
//  constructor Create(pAJsonString: string);
//end;

TChatList = class(TClassPadraoList<TChatClass>)
end;


TChatList2 = class(TClassPadraoList<TChatClass>)
end;


TRetornoAllGroupContacts = class(TClassPadraoList<TChatClass>)
end;


TResultQRCodeClass = class(TClassPadrao)
private
  FAQrCode: String;
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
  FId           : String;
  FIsBusiness   : Boolean;
  FIsEnterprise : Boolean;
  //FIsMe         : Boolean; deprecated
  FFromMe       : Boolean;
  FIsMyContact  : Boolean;
  FIsPSA        : Boolean;
  FIsUser       : Boolean;
  FIsWAContact  : Boolean;
  FLabels            : TArray<String>;
  FProfilePicThumbObj: TProfilePicThumbObjClass;

  FProfilePicThumb   : string;

  FPushname     : String;
  FStatusMute   : Boolean;
  FType         : String;
  FName         : String;//@LuizAlvez
  FverifiedName : String;//@LuizAlvez
public
  destructor Destroy; override;
  constructor Create(pAJsonString: string);

  property profilePicThumbObj: TProfilePicThumbObjClass read FProfilePicThumbObj write FProfilePicThumbObj;
  property formattedName:   String         read FFormattedName    write FFormattedName;
  property id:              String         read FId               write FId;
  property isBusiness:      Boolean        read FIsBusiness       write FIsBusiness;
  property isEnterprise:    Boolean        read FIsEnterprise     write FIsEnterprise;
  //property isMe:            Boolean        read FIsMe             write FIsMe; deprecated
  property fromMe:          Boolean        read FFromMe           write FFromMe;
  property isMyContact:     Boolean        read FIsMyContact      write FIsMyContact;
  property isPSA:           Boolean        read FIsPSA            write FIsPSA;
  property isUser:          Boolean        read FIsUser           write FIsUser;
  property isWAContact:     Boolean        read FIsWAContact      write FIsWAContact;
  property labels:          TArray<String> read FLabels           write FLabels;
  property pushname:        String         read FPushname         write FPushname;
  property statusMute:      Boolean        read FStatusMute       write FStatusMute;
  property &type:           String         read FType             write FType;
  property name:            String         read FName             write FName;          //@LuizAlvez
  property verifiedName:    String         read FverifiedName     write FverifiedName;  //@LuizAlvez
  property profilePicThumb: String         read FProfilePicThumb  write FProfilePicThumb;  //@mikelustosa
end;


Procedure LogAdd(Pvalor:WideString; PCab:String = '');
Procedure ClearLastQrcodeCtr;


implementation


uses
  //System.JSON, System.SysUtils, Vcl.Dialogs, System.NetEncoding,
  System.SysUtils, Vcl.Dialogs, System.NetEncoding,
  Vcl.Imaging.pngimage, uTInject.ConfigCEF, Vcl.Forms, Winapi.Windows,
  uTInject.Diversos;

var
  FUltimoQrCode: String;

Procedure ClearLastQrcodeCtr;
Begin
  FUltimoQrCode:= '';
End;

Procedure LogAdd(Pvalor:WideString; PCab:String);
Var
  LTmp, LName:String;
Begin
  try
    if Assigned(GlobalCEFApp) then
    Begin
      //Garante um arquivo novo e limpo a cada hora
      LName := GlobalCEFApp.LogConsole+ 'ConsoleMessage'+FormatDateTime('yymmdd_HH', now) +'.log';

      if (not GlobalCEFApp.LogConsoleActive) or (GlobalCEFApp.LogConsole = '') Then
         Exit;

      if PCab = '' then
         LTmp:= '[' + FormatDateTime('dd/mm/yy hh:nn:ss', now) + ']  ' else
         if PCab= 'CONSOLE'  then
            LTmp:= '[' + FormatDateTime('dd/mm/yy hh:nn:ss', now) + ' - ' + PCab + ']  ' + slinebreak Else
            LTmp:= '[' + FormatDateTime('dd/mm/yy hh:nn:ss', now) + ' - ' + PCab + ']  ' + slinebreak;

      if PCab= 'CONSOLE'  then
        TFile.AppendAllText(LName, slinebreak, TEncoding.ASCII);
      TFile.AppendAllText(LName, slinebreak + LTmp + Pvalor, TEncoding.ASCII);
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

  inherited Create(pAJsonString);
end;

function TResultQRCodeClass.CreateImage: Boolean;
{$IF CompilerVersion >= 31}
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

   {$IF CompilerVersion >= 31}
      FAQrCodeImage.LoadFromStream(FAQrCodeImageStream);
      result := True;
   {$ENDIF}

   {$IF CompilerVersion < 31}
      PNG := TPngImage.Create;
      try
        Png.LoadFromStream(FAQrCodeImageStream);
        FAQrCodeImage.Graphic := PNG;
        result := True;
      finally
        PNG.Free;
      end;
   {$ENDIF}
  Except
  end;
end;

destructor TResultQRCodeClass.Destroy;
begin
  FreeAndNil(FAQrCodeImage);
  FAQrCodeImageStream.Free;
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
  FUltimoQrCode  := AQrCode;

  FAQrCodeImageStream.Free;
  FAQrCodeSucess        := False;
  LMem                  := TMemoryStream.Create;
  FAQrCodeImageStream   := TMemoryStream.Create;
  LConvert              := TStringList.Create;
  try
    try
      LConvert.Add(copy(aQrCode, 23, length(aQrCode)));
      LConvert.SaveToStream(LMem);
      if LMem.Size > 3000 Then //Tamanho minimo de uma imagem
      Begin
        LMem.Position := 0;
        TNetEncoding.Base64.Decode(LMem, FAQrCodeImageStream );
        FAQrCodeImageStream.Position := 0;

        FAQrCodeSucess := True;
        FAQrCodeSucess := CreateImage;
      End else
      Begin
        FAQrCodeSucess := False;
      end;
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
  lAJsonObj := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(pAJsonString),0); { TODO : mudei de ASCII para UTF8 aqui }
  try
    if not Assigned(lAJsonObj) then
       Exit;
   inherited Create(pAJsonString);
  finally
    FreeAndNil(lAJsonObj);
  end;
end;

constructor TGroupMetadataClass.Create(pAJsonString: string);
begin
  inherited Create(pAJsonString);
end;

constructor TContactClass.Create(pAJsonString: string);
begin
  //Deprecated
  FProfilePicThumbObj := TProfilePicThumbObjClass.Create(FJsonString);
  inherited Create(pAJsonString);
end;

destructor TContactClass.Destroy;
begin
  //Deprecated
  FreeAndNil(FProfilePicThumbObj);//.free;
  inherited;
end;

{TResultClass}
constructor TChatClass.Create(pAJsonString: string);
begin
  FLastReceivedKey := TLastReceivedKeyClass.Create(JsonString);
  FContact         := TContactClass.Create        (JsonString);
  FGroupMetadata   := TGroupMetadataClass.Create  (JsonString);
  FKindTypeNumber  := TypUndefined;
  inherited Create(pAJsonString);
  if LowerCase(FKind) =  LowerCase('chat') then
     FKindTypeNumber := TypContact else
     if LowerCase(FKind) =  LowerCase('group') then
        FKindTypeNumber := TypGroup else
        FKindTypeNumber := TypList;
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
 inherited Create(pAJsonString);
end;

{TSenderClass}
constructor TSenderClass.Create(pAJsonString: string);
begin
  //Deprecated
  FProfilePicThumbObj := TProfilePicThumbObjClass.Create(JsonString);
  inherited Create(pAJsonString);
end;

destructor TSenderClass.Destroy;
begin
  //Deprecated
  FreeAndNil(FProfilePicThumbObj);//.free;
  inherited;
end;

{TMessagesClass}
constructor TMessagesClass.Create(pAJsonString: string);
begin
  FSender    := TSenderClass.Create   (JsonString);
  FChat      := TChatClass.Create     (JsonString);
  FMediaData := TMediaDataClass.Create(JsonString);
  inherited Create(pAJsonString);
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
  inherited Create(pAJsonString);
  FResult.ProcessQRCodeImage;
end;

destructor TQrCodeClass.Destroy;
begin
  FreeandNil(FResult);

  inherited;
end;

{ TClassPadrao }
constructor TClassPadrao.Create(pAJsonString: string; PJsonOption: TJsonOptions);
var
  lAJsonObj: TJSONValue;

  //Autor: Daniel Valmir Serafim -->
  function IsResultArray(const jsonString: string): Boolean;
  var
    jsonObject: TJSONObject;
    resultValue: TJSONValue;
    resultArray: TJSONArray;
  begin
    Result := False;

    // Converte a string JSON para um objeto JSON
    jsonObject := TJSONObject.ParseJSONValue(jsonString) as TJSONObject;

    try
      // Verifica se o objeto JSON possui a chave "result"
      if Assigned(jsonObject) and jsonObject.TryGetValue<TJSONValue>('result', resultValue) then
      begin
        // Verifica se o valor associado à chave "result" é um array
        if Assigned(resultValue) and (resultValue is TJSONArray) then
          Result := True;
      end;
    finally
      jsonObject.Free;
    end;
  end;
  //Autor: Daniel Valmir Serafim <--

begin
  lAJsonObj      := TJSONObject.ParseJSONValue(pAJsonString);
  FInjectWorking := False;

  try
   try
    if NOT Assigned(lAJsonObj) then
       Exit;

    {$IFDEF VER360}
    if IsResultArray(pAJsonString) then
      RemoveObjectsFromJson(TJSONObject(lAJsonObj));
    {$ENDIF}

    TJson.JsonToObject(Self, TJSONObject(lAJsonObj) ,PJsonOption);

    FJsonString := pAJsonString;
          SleepNoFreeze(10);

    If LowerCase(SELF.ClassName) <> LowerCase('TResponseConsoleMessage') Then
       LogAdd(PrettyJSON(pAJsonString), SELF.ClassName);

    FTypeHeader := StrToTypeHeader(name);
   Except
     on E : Exception do
       LogAdd(e.Message, 'ERROR ' + SELF.ClassName);
   end;
  finally
    FreeAndNil(lAJsonObj);
  end;
end;

//Autor: Daniel Valmir Serafim -->
procedure TClassPadrao.RemoveObjectsFromJson(var json: TJSONObject);
var
  resultArray: TJsonArray;
  chatObject, messageObject: TJSONObject;
  messageArray: TJSONArray;
begin
  try
  // Verifica se o JSON contém a chave "result" e se é um array
  if json.TryGetValue<TJsonArray>('result', resultArray) then
  begin
    // Itera sobre os elementos do array
    for var i := 0 to resultArray.Count - 1 do
    begin
      // Obtém o objeto de chat
      chatObject := resultArray.Items[i] as TJSONObject;
      // Remove os objetos específicos do chat
      chatObject.RemovePair('tcToken');
//      chatObject.RemovePair('chat');
      // Verifica se o chat contém mensagens
      if chatObject.TryGetValue<TJsonArray>('messages', messageArray) then
      begin
        // Itera sobre as mensagens do chat
        for var j := 0 to messageArray.Count - 1 do
        begin
          // Obtém o objeto de mensagem
          messageObject := messageArray.Items[j] as TJSONObject;
          // Remove o objeto de mediaData da mensagem
          messageObject.RemovePair('mediaData');
          messageObject.RemovePair('chat');
        end;
      end;
    end;
  end;
  Except
     on E : Exception do
       LogAdd(e.Message, 'ERROR ' + SELF.ClassName);
   end;
end;
//Autor: Daniel Valmir Serafim <--

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
    for i:= Length(PArray)-1 downto 0 do
        {$IFDEF VER300}
          freeAndNil(PArray[i]);
        {$ENDIF}

        {$IFDEF VER330}
          freeAndNil(PArray[i]);
        {$ENDIF}

        {$IFDEF VER340}
          freeAndNil(TArray<TClassPadrao>(PArray)[i]);
        {$ENDIF}

        {$IFDEF VER350}
          freeAndNil(TArray<TClassPadrao>(PArray)[i]);
        {$ENDIF}

        {$IFDEF VER360}
          freeAndNil(TArray<TClassPadrao>(PArray)[i]);
        {$ENDIF}
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
  inherited Create(pAJsonString);
  FResult := FChatstates;
end;

destructor TPresenceClass.Destroy;
begin
  ClearArray(FChatstates);
  inherited;
end;

{ TResponseMyNumber }
constructor TResponseMyNumber.Create(pAJsonString: string);
begin
  inherited Create(pAJsonString);
  FResult := Copy(FResult, 0 , Pos('@', FResult)-1);
end;

destructor TGroupMetadataClass.Destroy;
begin
  ClearArray(FParticipants);
  ClearArray(FPendingParticipants);     //@LuizAlvez
  inherited;
end;

{ TUrlIndy }

constructor TUrlIndy.Create;
begin
  {$IFDEF DELPHI25_UP}
    inherited;
  {$ELSE}
    inherited create;
  {$ENDIF}

  FTimeOut                := 10;
  FTImeOutIndy            := TTimer.Create(Nil);
  FTImeOutIndy.OnTimer    := OnTimeOutIndy;
  FTImeOutIndy.Interval   := FTimeOut * 1000;
  FTImeOutIndy.Enabled    := False;
  FShowException          := True;

  {$IFDEF DELPHI25_UP}
    FIdAntiFreeze           := TIdAntiFreeze.Create(nil);
  {$ENDIF}
  FReturnUrl              := TMemoryStream.Create;

  HandleRedirects         := True;
  ProtocolVersion         := pv1_1;

  Request.UserAgent       := 'Mozilla/5.0 (compatible; Test)';
  //Request.UserAgent       := 'Mozilla/3.0 (compatible; Indy Library)';

  SSIOHandler := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
  Self.IOHandler := SSIOHandler;

  with IOHandler as TIdSSLIOHandlerSocketOpenSSL do
  begin
    SSLOptions.method := sslvTLSv1_1;
    SSLOptions.SSLVersions := [sslvTLSv1_1];
    SSLOptions.Mode := sslmUnassigned;
  end;

end;

destructor TUrlIndy.Destroy;
begin
  FTImeOutIndy.Enabled       := False;
  FreeandNil(FReturnUrl);
  FreeandNil(FTImeOutIndy);
  FreeandNil(SSIOHandler);
  {$IFDEF DELPHI25_UP}
     FreeandNil(FIdAntiFreeze);
  {$ENDIF}
  inherited;
end;

function TUrlIndy.DownLoadInternetFile(Source, Dest: String): Boolean;
begin
  try
    Result := URLDownloadToFile(nil, PChar(Source), PChar(Dest), 0, nil) = 0
  except
    Result := False;
  end;
end;

function TUrlIndy.GetUrl(const Purl: String): Boolean;
begin
  FTImeOutIndy.Interval      := FTimeOut * 1000;
  FTImeOutIndy.Enabled       := False;
  try
    FReturnUrl.Free;
    FReturnUrl               := TMemoryStream.Create;
    FTImeOutIndy.Enabled     := True;
    try
      //Get(Purl, FReturnUrl);

      DownLoadInternetFile(TInjectJS_JSUrlPadrao, 'js.abr');


    Except
      on E : Exception do
      Begin
        if FShowException then
        Begin
          if pos(AnsiUpperCase('Cold not load SSL'), AnsiUpperCase(e.Message)) > 0 then
             Application.MessageBox(PWideChar(MSG_Exceptlibeay32dll), PWideChar(Application.Title), MB_ICONERROR + mb_ok) else
             Application.MessageBox(Pwidechar('Erro HTTP GET (js.abr) ' + e.Message), PWideChar(Application.Title), MB_ICONWARNING + mb_ok);
        End;
      End;
    end;
  finally
    FTImeOutIndy.Enabled  := False;
    FReturnUrl.position   := 0;
    Result                := FReturnUrl.size > 0;
  end;

end;

procedure TUrlIndy.OnTimeOutIndy(Sender: TObject);
begin
  FTImeOutIndy.Enabled   := False;
  try
    Disconnect(true);
  Except
    //Nao mostrar erro.. essa rotina e exatamente para isso!
  end;
end;


{ TMediaDataClass }

constructor TMediaDataClass.Create(pAJsonString: string);
begin
  Fpreview := TMediaDataPreviewClass.Create(JsonString);
end;

destructor TMediaDataClass.Destroy;
begin
  FreeAndNil(Fpreview);
  inherited;
end;

{ TMediaDataBlobClass }

constructor TMediaDataBlobClass.Create(pAJsonString: string);
begin
  F_blob := TMediaData_BlobClass.Create(JsonString);
end;

destructor TMediaDataBlobClass.Destroy;
begin
  FreeAndNil(F_blob);
  inherited;
end;


{ TResponseIsConnected }

constructor TResponseIsConnected.Create(pAJsonString: string);
begin
  inherited Create(pAJsonString);
  //FResult := FResult;//Copy(FResult, 0 , Pos('@', FResult)-1);
end;

{ TResponseGetProfilePicThumb }

constructor TResponseGetProfilePicThumb.Create(pAJsonString: string);
begin
  Base64 :=  copy(pAJsonString, 34, length(pAJsonString) - 35);
  //Base64 := pAJsonString;
end;

destructor TResponseGetProfilePicThumb.Destroy;
begin
  //Deprecated
  inherited;
end;

{ TRetornoAllGroups }

constructor TRetornoAllGroups.Create(pAJsonString: string);
begin
  inherited Create(pAJsonString);
  FNumbers      := TStringList.create;
  FNumbers.Text := FJsonString;
  //Quebrar linhas de acordo com cada valor separado por virgula
  FNumbers.Text := StringReplace(FNumbers.Text, '",', Enter, [rfReplaceAll]);
  FNumbers.Text := StringReplace(FNumbers.Text, '"' , '',    [rfReplaceAll]);
  FNumbers.Text := StringReplace(FNumbers.Text, '{result:[' , '',    [rfReplaceAll]);
  FNumbers.Text := StringReplace(FNumbers.Text, ']}' , '',    [rfReplaceAll]);
end;

destructor TRetornoAllGroups.Destroy;
begin
  inherited;
  Freeandnil(FNumbers);
end;

{ TClassGetAllGroupContacts }

constructor TClassAllGroupContacts.Create(pAJsonString: string;
  PJsonOption: TJsonOptions);
var
  lAJsonObj: TJSONValue;
begin
  lAJsonObj      := TJSONObject.ParseJSONValue(pAJsonString);

  try
   try
    if NOT Assigned(lAJsonObj) then
       Exit;

    TJson.JsonToObject(Self, TJSONObject(lAJsonObj) ,PJsonOption);

          SleepNoFreeze(10);

    If LowerCase(SELF.ClassName) <> LowerCase('TResponseConsoleMessage') Then
       LogAdd(PrettyJSON(pAJsonString), SELF.ClassName);


   Except
     on E : Exception do
       LogAdd(e.Message, 'ERROR ' + SELF.ClassName);
   end;
  finally
    FreeAndNil(lAJsonObj);
  end;

end;

class function TClassAllGroupContacts.FromJsonString(
  AJsonString: string): TClassAllGroupContacts;
begin
  result := TJson.JsonToObject<TClassAllGroupContacts>(AJsonString)
end;

function TClassAllGroupContacts.ToJsonString: string;
begin
  result := TJson.ObjectToJsonString(self);
end;

{ TRetornoAllGroupAdmins }

constructor TRetornoAllGroupAdmins.Create(pAJsonString: string);
begin
  inherited Create(pAJsonString);
  FNumbers      := TStringList.create;
  FNumbers.Text := FJsonString;
  //Quebrar linhas de acordo com cada valor separado por virgula
  FNumbers.Text := StringReplace(FNumbers.Text, '",', Enter, [rfReplaceAll]);
  FNumbers.Text := StringReplace(FNumbers.Text, '"' , '',    [rfReplaceAll]);
  FNumbers.Text := StringReplace(FNumbers.Text, '{result:[' , '',    [rfReplaceAll]);
  FNumbers.Text := StringReplace(FNumbers.Text, '[' , '',    [rfReplaceAll]);
  FNumbers.Text := StringReplace(FNumbers.Text, ']' , '',    [rfReplaceAll]);
  FNumbers.Text := StringReplace(FNumbers.Text, '}' , '',    [rfReplaceAll]);

end;

destructor TRetornoAllGroupAdmins.Destroy;
begin
  inherited;
  Freeandnil(FNumbers);
end;

{ TGetMeClass }

constructor TGetMeClass.Create(pAJsonString: string; PJsonOption: TJsonOptions = JsonOptionClassPadrao);
begin
 Fphone    := TPhoneClass.Create(JsonString);
 Fstatus   := TResponseStatusMessage.Create(JsonString);
 inherited Create(pAJsonString);
end;

destructor TGetMeClass.Destroy;
begin
  FreeAndNil(Fphone);
  FreeAndNil(Fstatus);
  inherited;
end;

{ TResponseIsDelivered }

constructor TResponseIsDelivered.Create(pAJsonString: string);
begin
  inherited Create(pAJsonString);
  //FResult := (Copy (FResult, Pos ('@c.us_', FResult) + 2, Length (FResult)));
end;

{ TReturnIncomingCall }

constructor TReturnIncomingCall.Create(pAJsonString: string);
var
  lAJsonObj: TJSONValue;
  aJson: TJSONObject;
begin
  lAJsonObj      := TJSONObject.ParseJSONValue(pAJsonString);

  if NOT Assigned(lAJsonObj) then
    Exit;

  {$IF COMPILERVERSION > 31}
  try
    FContact := lAJsonObj.FindValue('result').Value;
  finally
    freeAndNil(lAJsonObj);
  end;
  {$ELSE}
  try
    aJson := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(pAJsonString), 0) as TJSONObject;
    FContact := aJson.GetValue('result').Value;
  finally
    freeAndNil(aJson)
  end;
  {$ENDIF}

end;

end.
