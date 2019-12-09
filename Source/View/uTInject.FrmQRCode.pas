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
unit uTInject.FrmQRCode;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.Imaging.GIFImg;

type
  TFrmQRCode = class(TForm)
    Image1: TImage;
    Timer1: TTimer;
    Image2: TImage;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }

  public
    { Public declarations }
    qrCode: string;
    procedure loadQRCode(st: string);

  end;

var
  FrmQRCode: TFrmQRCode;

implementation

uses uTInject, System.NetEncoding, Vcl.Imaging.jpeg, Vcl.Imaging.pngimage;

{$R *.dfm}

procedure TFrmQRCode.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  action    := cafree;
  FrmQRCode := nil;
end;

procedure TFrmQRCode.FormCreate(Sender: TObject);
begin
  (Image2.Picture.Graphic as TGIFImage ).Animate       := True;
  (Image2.Picture.Graphic as TGIFImage ).AnimationSpeed:= 500;
end;

procedure TFrmQRCode.FormShow(Sender: TObject);
begin
  timer1.enabled := true;
end;

procedure TFrmQRCode.loadQRCode(st: string);
var
  LInput: TMemoryStream;
  LOutput: TMemoryStream;
  stl: TStringList;
 {$IFNDEF VER330}
  PNG: TpngImage;
 {$ENDIF}
begin
  //by Aurino Inovatechi 19/11/2019 review Mike
  LInput  := TMemoryStream.Create;
  LOutput := TMemoryStream.Create;
  stl     := TStringList.Create;
  try
    stl.Add(copy(st, 23, length(st)));
    stl.SaveToStream(LInput);

    LInput.Position := 0;
    TNetEncoding.Base64.Decode( LInput, LOutput );
    LOutput.Position := 0;

    //Delphi 10.3
    {$IFDEF VER330}
      if LOutput.size > 0 then
        Image1.Picture.LoadFromStream(LOutput);
    {$ELSE}

    PNG := TPngImage.Create;
    try
      //Delphi 10.1,2 ....
      if LOutput.size > 0 then
         PNG.LoadFromStream(LOutput);
      image1.Picture.Graphic := PNG;
    finally
      PNG.Free;
    end;
    {$ENDIF}

  finally
    LInput.Free;
    LOutput.Free;
    FreeAndNil(stl);
  end;
end;

procedure TFrmQRCode.Timer1Timer(Sender: TObject);
var
  _inject : TInjectWhatsapp;
begin
  if assigned( _inject ) then
     _inject.monitorQrCode;

  if Image1.Picture.Graphic <> nil    then
     FrmQRCode.Caption := 'TInject - Aponte seu celular agora!';
 end;

end.
