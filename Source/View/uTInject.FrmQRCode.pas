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
    Timg_QrCode: TImage;
    Timg_Animacao: TImage;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
  private
    FCaptionSucess: String;
    FCaptionWait: String;
    { Private declarations }
  public
    { Public declarations }
    Procedure  SetView(Const PImage: TImage);
    Property   CaptionWait   : String     Read  FCaptionWait    Write FCaptionWait;
    Property   CaptionSucess : String     Read  FCaptionSucess  Write FCaptionSucess;
  end;

var
  FrmQRCode: TFrmQRCode;

implementation

uses uTInject, System.NetEncoding, Vcl.Imaging.jpeg, Vcl.Imaging.pngimage,
  uTInject.ConfigCEF;

{$R *.dfm}

procedure TFrmQRCode.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  action    := cafree;
  FrmQRCode := nil;
end;

procedure TFrmQRCode.FormCreate(Sender: TObject);
begin
  CaptionWait           := 'Carregando QRCode...';
  CaptionSucess         := 'Aponte seu celular agora!';
  Timg_QrCode.Picture   := Nil;
  AutoSize              := False;
  Timg_Animacao.Visible := True;
  Timg_QrCode.Visible   := False;
  (Timg_Animacao.Picture.Graphic as TGIFImage).AnimationSpeed  := 500;
  (Timg_Animacao.Picture.Graphic as TGIFImage).Animate         := True;
  SetView(Timg_Animacao);
end;

procedure TFrmQRCode.SetView(const PImage: TImage);
var
  LImage : TImage;
begin
  AutoSize := False;
  try
    if AnsiUpperCase(PImage.Name) = AnsiUpperCase('Timg_Animacao') then
       Timg_Animacao.Visible := True else
       Timg_Animacao.Visible := False;
    Timg_QrCode.Visible := not Timg_Animacao.Visible;
  finally
    if not Timg_QrCode.Visible then
    begin
      LImage  := Timg_Animacao;
      Caption := CaptionWait;
      Timg_QrCode.Picture := Nil;
    end else
    begin
      LImage  := Timg_QrCode;
      Caption := CaptionSucess;
    end;

    LImage.Top       := Timg_QrCode.Margins.Top;
    LImage.Left      := Timg_QrCode.Margins.Left;
    LImage.AutoSize  := true;
    LImage.AutoSize  := False;
    LImage.Width     := LImage.Width  + Timg_QrCode.Margins.Left;
    LImage.Height    := LImage.Height + Timg_QrCode.Margins.Top;
    LImage.Center    := True;

//     (Timg_Animacao.Picture.Graphic as TGIFImage).Animate         := Timg_Animacao.Visible;
    AutoSize := True;
  end;
end;

end.
