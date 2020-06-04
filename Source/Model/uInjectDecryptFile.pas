unit uInjectDecryptFile;

interface

uses System.Classes, Vcl.ExtCtrls, System.Generics.Collections,
  shellapi, Winapi.UrlMon, IdHTTP, Winapi.Windows;

type
  TInjectDecryptFile = class(TComponent)
  private
    function DownLoadInternetFile(Source, Dest: string): Boolean;
    procedure DownloadFile(Source, Dest: string);
    function shell(program_path:  string):  string;
    function idUnique: string;
   public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function download(clientUrl,mediaKey,tipo:string) :string;
  end;

implementation

uses
  System.StrUtils, System.SysUtils, Vcl.Forms;

{ TImagem }

constructor TInjectDecryptFile.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TInjectDecryptFile.Destroy;
begin
  inherited;
end;

procedure TInjectDecryptFile.DownloadFile(Source, Dest: String);
var
  IdHTTP1 : TIdHTTP;
  Stream  : TMemoryStream;
  Url, FileName: String;
begin
  IdHTTP1 := TIdHTTP.Create(nil);
  Stream  := TMemoryStream.Create;
  try
    IdHTTP1.Get(Source, Stream);
    Stream.SaveToFile(Dest);
  finally
    Stream.Free;
    IdHTTP1.Free;
  end;
end;

function TInjectDecryptFile.DownLoadInternetFile(Source, Dest: String): Boolean;
var ret:integer;
begin
  try
    ret:=URLDownloadToFile(nil, PChar(Source), PChar(Dest), 0, nil);
    if ret <> 0 then
    begin
      DownloadFile(Source, Dest) ;
      if FileExists(dest) then
        ret :=  0;
    end;

    Result := ret = 0
  except
    Result := False;
  end;
end;

function TInjectDecryptFile.idUnique: String;
var
  gID: TGuid;
begin
  CreateGUID(gID);
  result := copy(gID.ToString, 2, length(gID.ToString)  - 2);
end;

function TInjectDecryptFile.download(clientUrl, mediaKey,tipo: string): string;
var form,imagem,diretorio,arq:string;
begin
  Result    :=  '';
  diretorio := ExtractFilePath(ParamStr(0)) + 'temp\';
  Sleep(1);

  if not DirectoryExists(diretorio) then
    CreateDir(diretorio);

  arq     :=  idUnique;
  imagem  :=  diretorio + arq;
  Sleep(1);

  if DownLoadInternetFile(clientUrl, imagem + '.enc') then
  if FileExists(imagem  + '.enc') then
  begin
    form  :=  format('--in %s.enc --out %s.%s --key %s',  [imagem,  imagem, tipo, mediakey]);
    shell(form);
    Sleep(10);
    Result:= imagem + '.' + tipo;

    if fileExists(imagem + '.' + tipo) then
      deleteFile(imagem + '.enc');
  end;
end;

function TInjectDecryptFile.shell(program_path: string): string;
var
  s1: string;
begin
  s1 := ExtractFilePath(Application.ExeName)+'decryptFile.dll ';
  ShellExecute(0, nil, 'cmd.exe', PChar('/c '+ s1 + program_path ), PChar(s1 + program_path), SW_HIDE);
end;

end.
