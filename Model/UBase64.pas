{** Douglas Colombo
  * Classe de conversão de arquivos em texto
  * e de Texto em Arquivos, BASE64
**}

unit UBase64;

interface

uses System.Classes, System.netEncoding, System.SysUtils, FMX.Graphics;


//Type
  // tBase64 = class

   //public
     procedure Base64ToFile(Arquivo, caminhoSalvar : String);
     function Base64ToStream(imagem : String) : TMemoryStream;
     //function Base64ToBitmap(imagem : String) : TBitmap;
     function BitmapToBase64(imagem : TBitmap) : String;
     function FileToBase64(Arquivo : String) : String;
     function StreamToBase64(STream : TMemoryStream) : String;
//end;

implementation


//{ tBase64 }
//function tBase64.Base64ToBitmap(imagem: String): TBitmap;
//Var sTream : TMemoryStream;
//begin
//  if (trim(imagem) <> '') then
//  begin
//     Try
//        sTream := Base64ToStream(imagem);
//        result := TBitmap.CreateFromStream(sTream);
//     Finally
//        sTream.DisposeOf;
//        sTream := nil;
//     End;
//  end else
//  exit;
//end;

procedure Base64ToFile(Arquivo, caminhoSalvar : String);
Var sTream : TMemoryStream;
begin
  Try
    sTream := Base64ToStream(Arquivo);
    sTream.SaveToFile(caminhoSalvar);
  Finally
    sTream.free;
    sTream:=nil;
  End;
end;

function Base64ToStream(imagem: String): TMemoryStream;
var Base64 : TBase64Encoding;
    bytes : tBytes;
begin
  Try
    Base64 := TBase64Encoding.Create;
    bytes  := Base64.DecodeStringToBytes(imagem);
    result := TBytesStream.Create(bytes);
    result.Seek(0, 0);
  Finally
    Base64.Free;
    Base64:=nil;
    SetLength(bytes, 0);
  End;
end;

function BitmapToBase64(imagem: TBitmap): String;
Var sTream : TMemoryStream;
begin
  result := '';

  if not (imagem.IsEmpty) then
  begin
     Try
        sTream := TMemoryStream.Create;
        imagem.SaveToStream(sTream);
        result := StreamToBase64(sTream);
        sTream.DisposeOf;
        sTream := nil;
     Except End;
  end;
end;

function FileToBase64(Arquivo : String): String;
Var sTream : tMemoryStream;
begin
  sTream := TMemoryStream.Create;
  Try
    sTream.LoadFromFile(Arquivo);
    result := StreamToBase64(sTream);
  Finally
    Stream.Free;
    Stream:=nil;
  End;
end;

function StreamToBase64(STream: TMemoryStream): String;
Var Base64 : tBase64Encoding;
begin
  Try
    Stream.Seek(0, 0);
    Base64 := TBase64Encoding.Create;
    Result := Base64.EncodeBytesToString(sTream.Memory, sTream.Size);
  Finally
    Base64.Free;
    Base64:=nil;
  End;
end;

end.
