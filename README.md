# Componente TInject
## Componente mais RECIFENSE da internet!<br>
Componente para criação de chatBots com delphi<br>
<i>Component for creating chatBots with delphi</i><br></br>

## INSTRUÇÕES PARA USO DO COMPONENTE<br></br>

Compatibilidade testada nas versões do Delphi: Seattle, Berlim, Tokyo, Rio, Sydney.<br></br>

### Tutorial de instalação no youtube:<br>
https://www.youtube.com/watch?v=EIxFdtenNxI&t=31s

<br>
Videos demo:
<br>
https://youtu.be/YEmwghSGoFA
<br>
https://youtu.be/07RoReOHaT4
<br>
https://youtu.be/cbWW7VNYwEo
<br><br>

### NOVO: Para usar com o delphi 10.4 Sydney, incluir no library path 32 bits a pasta <b>Compilados</b> e suas subpastas.<br><br>

### Recursos / Resources<br><br>
✔️  Login<br>
✔️  Logout<br>
✔️  Enviar mensagens de texto para números fora da agenda- Send text message<br>
✔️  Enviar mensagens para grupos - Send group messages<br>
❌  Enviar contatos - Send phone contacts<br>
✔️  Enviar MP3 - Send MP3<br>
✔️  Enviar MP4 - Send MP4<br>
✔️  Enviar IMG - Send IMG<br>
✔️  Enviar RAR - Send RAR<br>
✔️  Enviar Link com prévia - Sending and preview<br>
❌  Enviar localização - Location sending<br>
✔️  Listar contatos - Contact list<br>
✔️  Listar bate papos - Conversation list<br>
✔️  Status da bateria - Battery status<br>
✔️  Simular digitando - Typing simulation<br>
✔️  Recebimento de novas mensagem - Receiving new messages<br>
✔️  Configurações de DDI - International number configuration<br>
✔️  Validação de números - number validator<br>
✔️  Checagem de conexão - check connection<br>
✔️  Download de arquivos - Download files<br>
✔️  Download da foto de perfil - Download profile picture<br>
✔️  Criar grupo - Create group<br>
✔️  Sair do grupo - Leave the group<br>
✔️  Adicionar participante ao grupo - Add participant to the group<br>
✔️  Remover participante do grupo - Remove group member<br>
✔️  Promover participante adminstrador do grupo - Promote participant group administrator<br>
✔️  Despromover participanete adminstrador do grupo - Demote participating group administrator<br>
✔️  Listar todos os grupos - List all groups<br>
✔️  Listar participantes do grupo - List group participants<br>
❌  Obter link convite de grupos - Get Group invitation link<br>
✔️  Entrar em grupo via link convite - Join group via invitation link<br>

### Cursos do componente / Component lessions:<br>

[Clique aqui / Click where](http://mikelustosa.kpages.online/tinject)


Nota 1: O TInject é de código aberto desenvolvido em comunidade, e não possui *nenhum outro componente* de terceiro além do TChromium vinculado ao código.
<br><br>
Nota 2: Desenvolvido no rad studio 10.3.0 (RIO).<br><br> 

#### Doações via PIX / PIX Donations: comercial.softmais@gmail.com

<br><br>

### Official documentation:<br><br>

### Events that send messages<br>
| event           | Description                | Example                                                                              | return |
|-----------------|----------------------------|--------------------------------------------------------------------------------------|--------|
| send            | Send text message          | TInject1.send('55819999999@c.us', 'hello');                                          | -      |
| sendFile        | Send file and text message | TInject1.SendFile('558199999999@c.us', 'c:\myFile.pdf', 'hello');                    | -      |
| sendContact     | Send whatsapp contact      | TInject1.sendContact('destinationContact@c.us', 'contactToBeSent@c.us');             | -      |
| sendLinkPreview | Send preview link          | TInject1.sendLinkPreview('558199999999@c.us', 'https://youtube.com/video', 'hello'); | -      |
| sendLocation    | Send Location              | TInject1.sendLocation('55819999999@c.us', '-70.4078', '25.3789', 'my location');     |        |<br><br>

### Verifications events<br>
| event                 | Description                                             | example                                              | event return      | return                       |
|-----------------------|---------------------------------------------------------|------------------------------------------------------|-------------------|------------------------------|
| CheckIsConnected      | Checks the connection between the device and whatsapp   | TInject1.CheckIsConnected();                         | OnIsConnected     | boolean                      |
| NewCheckIsValidNumber | Checks whether one or more numbers are whatsapp numbers | TInject1.NewCheckIsValidNumber('558199999999@c.us'); | OnNewGetNumber    | TReturnCheckNumber           |
| GetBatteryStatus      | Checks the device's battery level                       | TInject1.GetBatteryStatus;                           | OnGetBatteryLevel | TInject(Sender).BatteryLevel |
