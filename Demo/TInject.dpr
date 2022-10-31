program TInject;

uses
  Vcl.Forms,
  Windows,
  uTInject.ConfigCEF,
  u_principal in 'u_principal.pas' {frmPrincipal};

{$R *.res}

//var arqIni: TInifile;

begin
  {##########################################################################################
  Colocar arquivos CEFLib junto a pasta binária da aplicação (Nao definir ou passar vazio)
  Caso deseja informar.. segue exemplo abaixo
  ##########################################################################################}

  {
  arqIni  := Tinifile.Create(ExtractFilePath(Application.ExeName)+ 'config.ini');

  GlobalCEFApp.PathLogFile          := '';
  GlobalCEFApp.PathFrameworkDirPath := arqIni.ReadString('CONFIG', 'FRAMEWORK', '');  //'C:\TInject\Projeto-TInject-master\Demo\BIN';
  GlobalCEFApp.PathResourcesDirPath := arqIni.ReadString('CONFIG', 'RESOURCES', ''); //'C:\TInject\Projeto-TInject-master\Demo\BIN';
  GlobalCEFApp.PathLocalesDirPath   := arqIni.ReadString('CONFIG', 'LOCALES', '');  //'C:\TInject\Projeto-TInject-master\Demo\BIN\locales';
  GlobalCEFApp.Pathcache            := arqIni.ReadString('CONFIG', 'CACHE', ''); //'C:\TInject\Projeto-TInject-master\Demo\BIN\Cache';
  GlobalCEFApp.PathUserDataPath     := arqIni.ReadString('CONFIG', 'USERDATA', ''); //'C:\TInject\Projeto-TInject-master\Demo\BIN\User Data';
 }

  //Forma 1 GlobalCEFApp.Pathxx       := '';                        //Irá procurar o Arquivo PADRAO no mesmo local do EXE
  //Forma 2 GlobalCEFApp.Pathxx       := 'C:\Componentes\demo\bin'; //<-  NOME do ARQUIVO INFORMADO
  //Forma 3 GlobalCEFApp.Pathxx       := 'BIN';                     //<-  NOME do ARQUIVO INFORMADO
  //Forma 4 GlobalCEFApp.Pathx         := '..\Source\;              //<-  NOME do ARQUIVO INFORMADO
  //Exemplo se aplica para todos os PATH


  If not GlobalCEFApp.StartMainProcess then
     Exit;

  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmPrincipal, frmPrincipal);
  Application.Run;

end.
