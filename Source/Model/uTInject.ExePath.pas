unit uTInject.ExePath;

interface

{$WARN SYMBOL_PLATFORM OFF}
uses
  System.Classes,  SysUtils,
  {$IFDEF DESIGNER_COMP}
//     DesignIntf,
     ToolsAPI,
  {$ENDIF}

  Windows,
  uTInject.Constant;

{Para ativar a diretivar COMPONENTE_CRIACAO deve ser incluido as Libray o PATH
        $(DELPHI)\Source\ToolsAPI

        e ativar o -LUDesignIDE em
        Menu Project - Options - Delphi Compiler
           - Compiler
              -  Other Options
                 - Additional Options to pass to Compiler =  -LUDesignIDE

           OBS: ( o traço EXISTE....  tem que ficar -LUDesignIDE)
}


Type
  TDadosApp = Class
  Private
    FLocalEXE: String;
    FIniProc: Cardinal;
   {$IFDEF DESIGNER_COMP}
      function GetPathExe: IOTAProject;
   {$ENDIF}

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

{$IFDEF DESIGNER_COMP}
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
{$ENDIF}


procedure TDadosApp.TrazNomeJs;
var
  LpastaRaiz: String;
 {$IFDEF DESIGNER_COMP}
    LApp: IOTAProject;
 {$ENDIF}
begin
  {$IFDEF DESIGNER_COMP}
     LApp       := GetPathExe;
     LpastaRaiz := LApp.FileName;
  {$ELSE}
     LpastaRaiz := Application.ExeName;
  {$ENDIF}

  //Agora tem que varrer para achar!!
  FIniProc   := GetTickCount; //rotina de segurança de TIMEOUT
  FLocalEXE  := FindDirs(ExtractFilePath(LpastaRaiz));
end;

end.
