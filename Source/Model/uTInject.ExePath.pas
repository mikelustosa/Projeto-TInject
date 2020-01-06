{####################################################################################################################
                         TINJECT - Componente de comunicação WhatsApp (Não Oficial WhatsApp)
                                           www.tinject.com.br
                                            Novembro de 2019
####################################################################################################################
    Owner.....: Daniel Oliveira Rodrigues  - Dor_poa@hotmail.com     - +55 51 9.9155-9228
    Developer.: Joathan Theiller           - jtheiller@hotmail.com   -
                Mike W. Lustosa            - mikelustosa@gmail.com   - +55 81 9.9630-2385
                Robson André de Morais     - robinhodemorais@gmail.com

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

unit uTInject.ExePath;

interface

{$WARN SYMBOL_PLATFORM OFF}
uses
  System.Classes,  SysUtils,  Windows,
  {$IFDEF DESIGNER_COMP}
    ToolsAPI,
  {$ENDIF}
  uTInject.Constant;


Type
  TDadosApp = Class(TComponent)
  Private
    FLocalEXE: String;
    FIniProc: Cardinal;
    FLocalProject: String;
    Procedure TrazNomeJs;
    {$IFDEF DESIGNER_COMP}
      function GetPathProject: IOTAProject;
    {$ENDIF}
     Function FindInterno(ADirRoot: String; PFile:String):String;

  Public
    constructor Create(Owner: TComponent); override;
    Function FindDirs(ADirRoot: String; PFile:String):String;
    Property LocalEXE: String       Read FLocalEXE;
    Property LocalProject: String   Read FLocalProject;

  End;

implementation

uses
  Vcl.Forms,  Vcl.Dialogs, uTInject.Diversos;



{ TDadosApp }

function TDadosApp.FindDirs(ADirRoot, PFile: String): String;
begin
  FIniProc   := GetTickCount;
  Result     := FindInterno(ADirRoot, PFile);
end;

Function TDadosApp.FindInterno(ADirRoot: String; PFile:String): String;
var
  LArquivos: TSearchRec;
begin
  Result := '';
  ADirRoot := IncludeTrailingPathDelimiter(ADirRoot);
  if FindFirst(ADirRoot + '*.*', faDirectory + faArchive, LArquivos) = 0 then
  begin
    Try
      Repeat
        //Segurança contra TRAVADAS se estiuver um um local com muitos arquivos!!
        if (FIniProc - GetTickCount) >= MsMaxFindJSinDesigner then
        Begin
          if (csDesigning in Owner.ComponentState) then
          Begin
            if (FIniProc - GetTickCount) < MsMaxFindJSinDesigner * 10 then
               WarningDesenv(PFile + ' -> Timeout do Search IDE atingido (' + IntToStr(MsMaxFindJSinDesigner) + ') / ' + IntToStr(FIniProc - GetTickCount));
          End;
          Exit;
        End;

        If (LArquivos.Name <> '.') and (LArquivos.Name <> '..') then
        begin
          If (LArquivos.Attr = fadirectory) or (LArquivos.Attr = 48) then
          begin
            result := FindInterno(ADirRoot + LArquivos.Name, PFile);
            if result <> '' then
               Exit;
          end;

          If (LArquivos.Attr in [faArchive, faNormal]) or (LArquivos.Attr = 8224)  then
          Begin
            if AnsiLowerCase(LArquivos.Name) = AnsiLowerCase(PFile) then
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


constructor TDadosApp.Create;
begin
  //Se estiver em modo DESIGNER tem que catar o local
  //Esta rodando a APLICAção
  //Entao vai valer o que esta configurado no DPR...
  // LocalEXE := ExtractFilePath(Application.exename);
  FIniProc   := GetTickCount;
  Inherited Create(Owner);
  TrazNomeJs;
end;

procedure TDadosApp.TrazNomeJs;
var
  LpastaRaiz: String;
begin
//Agora tem que varrer para achar!!
  LpastaRaiz    := ExtractFilePath(Application.exename);
  FIniProc      := GetTickCount; //rotina de segurança de TIMEOUT
  FLocalEXE     := FindDirs(ExtractFilePath(LpastaRaiz), NomeArquivoInject);
  {$IFDEF DESIGNER_COMP}
    LpastaRaiz    := ExtractFilePath(GetPathProject.FileName);
  {$ENDIF}
  FLocalProject := LpastaRaiz;
end;


{$IFDEF DESIGNER_COMP}

function TDadosApp.GetPathProject: IOTAProject;
var
  LServico: IOTAModuleServices;
  LModulo: IOTAModule;
  LProjeto: IOTAProject;
  LGrupo: IOTAProjectGroup;
  i: Integer;
begin
  Result := nil;
  try
    LServico := BorlandIDEServices as IOTAModuleServices;
    for i := 0 to LServico.ModuleCount - 1 do
    begin
      LModulo := LServico.Modules[i];
      if Supports(LModulo, IOTAProjectGroup, LGrupo) then
      begin
        Result := LGrupo.ActiveProject;
        Exit;
      end else
      Begin
        if Supports(LModulo, IOTAProject, LProjeto) then
        begin
          if Result = nil then
             Result := LProjeto;
        end;
      End;
    end;
  finally
    FIniProc   := GetTickCount;
  end;
end;
{$ENDIF}


end.
