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
  Autor........:
  Email........:
  Data.........:
  Identificador:
  Modificação..:
####################################################################################################################
}

unit uTInject.Diversos;

interface

uses
  System.Classes, Vcl.ExtCtrls, System.UITypes;

function PrettyJSON(JsonString: String):String;
function CaractersWeb(vText: string): string;
function Convert_StrToBase64(vFile: string): string;
function Convert_StrToBase64Stream(Var vMemo: TMemoryStream): string;

function AjustNameFile(texto : String) : String;
Function Convert_Base64ToFile(Const PInBase64, FileSaveName: string):Boolean;
Procedure WarningDesenv(Pvalor:String);
Function  TrazApenasNumeros(PValor:String):String;


implementation

uses
  System.JSON, REST.Json, Vcl.Imaging.GIFImg,   Vcl.Graphics, System.NetEncoding, System.SysUtils,
  Vcl.Imaging.pngimage, Vcl.Dialogs, uTInject.Constant;

Procedure WarningDesenv(Pvalor:String);
begin
  MessageDlg(PwideChar(MSG_WarningDeveloper + Chr(13) + Pvalor), mtWarning, [mbOk], 0);
end;

function PrettyJSON(JsonString: String):String;
var
  AObj: TJSONObject;
begin
  AObj   := TJSONObject.ParseJSONValue(JsonString) as TJSONObject;
  try
    result := TJSON.Format(AObj);
  finally
    AObj.Free;
  end;
end;

Function Convert_Base64ToFile(Const PInBase64, FileSaveName: string): Boolean;
var
  LInput : TMemoryStream;
  LOutput: TMemoryStream;
  stl    : TStringList;
begin
  LInput  := TMemoryStream.Create;
  LOutput := TMemoryStream.Create;
  stl     := TStringList.Create;
  Result  := False;
  try
    try
      stl.Add(PInBase64);
      stl.SaveToStream(LInput);

      LInput.Position  := 0;
      if LInput.Size < 1 then
        Exit;

      TNetEncoding.Base64.Decode( LInput, LOutput );
      if LOutput.Size < 1 then
         Exit;

      if FileSaveName <> '' then
      Begin
        DeleteFile(FileSaveName);
        If FileExists(FileSaveName) Then
           Exit; //nao conseguiu papagar!

        LOutput.Position := 0;
        LOutput.SaveToFile(FileSaveName);
      End;
    Except
    end;
  finally
    FreeAndNil(stl);
    FreeAndNil(LInput);
    FreeAndNil(LOutput);
    if FileSaveName <> '' then

    Result := FileExists(FileSaveName);
  end;
end;

function Convert_StrToBase64(vFile: string): string;
var
  vFilestream: TMemoryStream;
  vBase64File: TBase64Encoding;
begin
  vBase64File := TBase64Encoding.Create;
  vFilestream := TMemoryStream.Create;
  try
    vFilestream.LoadFromFile(vFile);
    result :=  vBase64File.EncodeBytesToString(vFilestream.Memory, vFilestream.Size);
  finally
    FreeAndNil(vBase64File);
    FreeAndNil(vFilestream);
  end;
end;

function Convert_StrToBase64Stream(Var vMemo: TMemoryStream): string;
var
  vBase64File: TBase64Encoding;
begin
  Result := '';
  try
    if vMemo.size = 0 then
       Exit;

    vMemo.Position := 0;
    vBase64File := TBase64Encoding.Create;
    try
      result :=  vBase64File.EncodeBytesToString(vMemo.Memory, vMemo.Size);
    finally
      FreeAndNil(vBase64File);
    end;
  Except
  end;
end;


function AjustNameFile(texto : String) : String;
Begin
  While pos('-', Texto) <> 0 Do
    delete(Texto,pos('-', Texto),1);
  While pos('+', Texto) <> 0 Do
    delete(Texto,pos('+', Texto),1);

  While pos('/', Texto) <> 0 Do
    delete(Texto,pos('/', Texto),1);
  While pos(',', Texto) <> 0 Do
    delete(Texto,pos(',', Texto),1);
  Result := Texto;
end;

Function  TrazApenasNumeros(PValor:String):String;
var
  LClearNum: String;
  i: Integer;
Begin
  Result := '';
  for I := 1 to Length(PValor) do
  begin
    if  (CharInSet(PValor[I] ,['0'..'9'])) Then
        LClearNum := LClearNum + PValor[I];
  end;
  Result := LClearNum;
End;

function CaractersWeb(vText: string): string;
begin
  vText  := StringReplace(vText, sLineBreak,'\n' , [rfReplaceAll] );
  vText  := StringReplace(vText, #13       ,''   , [rfReplaceAll] );
  vText  := StringReplace(vText, '"'       ,'\"' , [rfReplaceAll] );
  vText  := StringReplace(vText, #$A       ,'<br>'   , [rfReplaceAll] );
  vText  := StringReplace(vText, #$A#$A    ,'<br>'   , [rfReplaceAll] );
  vText  := StringReplace(vText, '\r'      ,''    , [rfReplaceAll] );
  vText  := StringReplace(vText, '<br>'    ,' \n' , [rfReplaceAll] );
  vText  := StringReplace(vText, '<br />'  ,' \n' , [rfReplaceAll] );
  vText  := StringReplace(vText, '<br/>'   ,' \n' , [rfReplaceAll] );
  Result := vText;
end;




end.
