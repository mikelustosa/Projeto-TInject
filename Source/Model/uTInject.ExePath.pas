unit uTInject.ExePath;

interface

{$WARN SYMBOL_PLATFORM OFF}
uses
  System.Classes,  SysUtils, DesignIntf, ToolsAPI,  Windows,
  uTInject.Constant;

Type
  TDadosApp = Class
  Private
    FLocalEXE: String;
    FIniProc: Cardinal;
    function GetPathExe: IOTAProject;
    Function FindDirs(ADirRoot: String):String;
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
var
  LApp: IOTAProject;
  LpastaRaiz: String;
begin
  //Se estiver em modo DESIGNER tem que catar o local
  //Esta rodando a APLICAção
  //Entao vai valer o que esta configurado no DPR...
  // LocalEXE := ExtractFilePath(Application.exename);
  FIniProc   := 0;
  if not PModoDesigner then
     Exit;

  LApp       := GetPathExe;
  LpastaRaiz :=  LApp.FileName;


  //Agora tem que varrer para achar!!
  FIniProc   := GetTickCount; //rotina de segurança de TIMEOUT
  FLocalEXE  := FindDirs(ExtractFilePath(LpastaRaiz));
end;

function TDadosApp.GetPathExe: IOTAProject;
var
  LServico: IOTAModuleServices;
  LModulo: IOTAModule;
  LProjeto: IOTAProject;
  LGrupo: IOTAProjectGroup;
  i: Integer;
begin
  Result := nil;
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
end;

end.
