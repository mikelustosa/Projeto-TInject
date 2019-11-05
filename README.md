# Componente TInject
Componente para criação de chatBots com delphi e o whatsapp<br></br><br></br>

INSTRUÇÕES PARA USO DO COMPONENTE--><br></br>

Compatibilidade testada nas versões do Delphi: Seattle, Berlim, Tokyo e Rio.<br></br>

Tutorial de instalação no youtube:<br>
https://youtu.be/iJAKU8A8fmc


1-Clonar o repositório Projeto-TInject
<br></br>
2-Baixar e instalar o CEF4Delphi em: https://drive.google.com/file/d/11cjHyJ9JYjnbQQI-gufJfDVLjJDHKhv3/view?usp=sharing
<br></br>
3-Baixar a pasta BIN em: https://drive.google.com/open?id=1bNh7kRfj8xSMkMibuAqFjx1V7l3y3r6b
<br></br>
4-Copiar todo o conteúdo baixado da pasta BIN no passo 3 para a pasta BIN na raiz do projeto (Caso não exista a pasta BIN em seu projeto Crie)
<br></br>
5-Adicione ao libary path do Delphi a pasta TInject-whatsapp-delphi e todas as subpastas
<br><br>
6-Clique no menu *Component* > *Install component*. Selecione a unit uTinject pasta(service) e selecionar a opção *install into a new package*. Por fim, digite o nome TInject em *Package name*.
<br><br>
7-Dê um Compile e depois dê um build
<br><br>
8-Abra o arquivo demo Tinject.dproj
<br></br><br></br>

O componente está 80% concluído. <br><br>Recurso que falta: Capturar o *log do console* do componente TChromium e gerar um *JSON* para tratamento das mensagens recebidas pelo WhatsApp.
<br><br>

*Nota 1: O TInject é de código aberto, e não possui *nenhum outro componente* de terceiro além do TChromium vinculado ao código, nem muito menos utilização de *licenças* ou afins de outros componentes. Baixem os *fontes* para comprovar.
<br><br>
*Nota 2: O projeto não usa API oficial do whatsapp, e foi desenvolvido no rad studio 10.3.0 (RIO)* use com consciência. 
