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

unit uTInject.ExePath;

interface

{$WARN SYMBOL_PLATFORM OFF}
uses
  System.Classes,  SysUtils,  Windows,
  uTInject.Constant;


Type
  TDadosApp = Class
  Private
    FLocalEXE: String;
    FIniProc: Cardinal;
    Function FindDirs(ADirRoot: String):String;
    Procedure TrazNomeJs;
  Public
    constructor Create(PModoDesigner: Boolean);
    Property LocalEXE: String   Read FLocalEXE;
  End;

implementation

uses
  Vcl.Forms,  Vcl.Dialogs;



{ TDadosApp }

Function TDadosApp.FindDirs(ADirRoot: String): String;
var
  LArquivos: TSearchRec;
begin
  //Segurança contra TRAVADAS se estiuver um um local com muitos arquivos!!
  if (FIniProc - GetTickCount) >= MsMaxFindJSinDesigner then
     Exit;

  ADirRoot := IncludeTrailingPathDelimiter(ADirRoot);
  if FindFirst(ADirRoot + '*.*', faDirectory + faArchive, LArquivos) = 0 then
  begin
    Try
      Repeat
        if (FIniProc - GetTickCount) >= MsMaxFindJSinDesigner then
           Exit;

        If (LArquivos.Name <> '.') and (LArquivos.Name <> '..') then
        begin
          If (LArquivos.Attr = fadirectory) or (LArquivos.Attr = 48) then
          begin
            result := FindDirs(ADirRoot + LArquivos.Name);
            if result <> '' then
               Exit;
          end;

          If (LArquivos.Attr in [faArchive, faNormal]) or (LArquivos.Attr = 8224)  then
          Begin
            if AnsiLowerCase(LArquivos.Name) = AnsiLowerCase(NomeArquivoInject) then
            begin
              Result := ADirRoot + LArquivos.Name;
              exit;
            end;
          end;
        end;
      until FindNext(LArquivos)  <> 0;
    finally
      SysUtils.FindClose(LArquivos)
    end;
  end;
end;


constructor TDadosApp.Create(PModoDesigner: Boolean);
begin
  //Se estiver em modo DESIGNER tem que catar o local
  //Esta rodando a APLICAção
  //Entao vai valer o que esta configurado no DPR...
  // LocalEXE := ExtractFilePath(Application.exename);
  FIniProc   := 0;
  if not PModoDesigner then
     Exit;

  TrazNomeJs;
end;

procedure TDadosApp.TrazNomeJs;
var
  LpastaRaiz: String;

begin
  //Agora tem que varrer para achar!!
  FIniProc   := GetTickCount; //rotina de segurança de TIMEOUT
  FLocalEXE  := FindDirs(ExtractFilePath(LpastaRaiz));
end;

end.
