# Guia do Projeto Linux de Monitoramento de Servidor

## Etapa 1: Configuração do Ambiente

### 1. Criar uma VPC na AWS com:

- 2 sub-redes públicas
- 2 sub-redes privadas
- 1 Internet Gateway conectada às sub-redes públicas.

![Criação VPC](/imgs/criaçãoVPC.png)

![Seleção do número de sub-redes](/imgs/Subnet.png)

### 2. Criar uma instância EC2 na AWS:

#### Crie uma chave PEM para aumentar sua segurança:

- Dentro da instância é possível criá-la

![Criação da chave PEM](/imgs/Chave.png)

- Escolha uma AMI baseada em Linux (Ubuntu/Debian/Amazon Linux)

![Criação da instância com base na AMI](/imgs/AMI.png)

### Configurações de rede da VPC: 

- Instalar na sub-rede pública criada anteriormente
- Selecione a VPC criada
- Selecione uma sub-rede pública
- Deixe enable a auto associação pública de IP

![Seleção da VPC e da sub-rede pública na instância](/imgs/NetworkSettings.png)

### 3. Acessar a instância via SSH para realizar configurações futuras

- Com a instância já criada, clique em Security Groups na parte de Security

![Instância criada](/imgs/Instância.png)

![Seleção de Security Groups dentro da aba Security na instância criada](/imgs/SecurityGroups.png)

#### Associar um Security Group com regras InBound e OutBound

- Selecione edit InBound rules para criar a regra de entrada na instância

![Criação das regras de entrada](/imgs/InboundRules.png)

#### As configurações das regras InBound são:

- HTTP: Anywhere Ipv4
- SSH: My IP

![Edição das regras InBound](/imgs/EditInbound.png)

#### Seguindo os mesmos passos no OutBound

- Selecione edit OutBound rules para criar a regra de saída na instância

![Criação das regras OutBound](/imgs/InboundRules.png)

#### As configurações das regras OutBound são:

- HTTP: Anywhere Ipv4
- HTTPS: Anywhere Ipv4

![Edição das regras OutBound](/imgs/EditOutBound.png)

### Configurando ambiente WSL para acessar a Instância

#### No microsoft store é possível instalar um sub-sistema Linux na sua máquina Windows

- Com as configurações de Security Group feitas, agora é hora de acessar a instância.

- Para isso, basta pesquisar a mesma AMI selecionada na criação da EC2 e o WSL.

![Instalando Debian](/imgs/Debian.png)

![Instalando WSL](/imgs/WSL.png)

#### Instalando o WSL

- Para instalar o WSL, basta entrar no Windows Powershell e digitar:
```bash
wsl --install -d Debian
```

![Baixando o Debian](/imgs/BaixandoDebian.png)

#### Conectando-se a instância 

- Mova o local da sua chave (se não foi alterado é em Downloads)
```bash
sudo mv /mnt/c/Users/"seu_usuário"/Downloads/"nome_chave.pem" /home/"usuário_linux"/
```
- Edite a permissão da chave:
```bash
sudo chmod 400 "nome_chave.pem"
```

- Para se conectar a instância digite o seguinte comando:
```bash
ssh -i "nome_chave.pem" admin@IP_da_EC2
```

## Etapa 2: Configuração do Servidor Web

### 1. Instalar o servidor Nginx na EC2 com os seguintes comandos:
``` bash
 sudo apt update && sudo apt upgrade
 sudo apt install nginx
 sudo systemctl status nginx
```

![Nginx executando com sucesso!](/imgs/NginxStatus.png)

### 2. Criar uma página HTML simples para ser exibida pelo servidor

- Com o comando cd /var/www/html você acessa o diretório para editar o html da página
- Com o comando nano index.html você consegue editar a página html

![Página HTML](/imgs/HTML.png)

## Etapa 3: Monitoramento e Notificações

### 1. Criar um script em Bash ou Python para monitorar a disponibilidade do site

- Para utilizar o script crie um arquivo .sh
- Edite a sua permissão para executar com:
```bash
 sudo chmod +x nome_script.sh
```

![Exemplo de Script](/imgs/ScriptExemplo.png)

### Caso queira copiar o Script não esqueça de editar os seguintes campos:

- SITE: Substitua pelo IP da sua máquina criada
- MONITORAR: Lembre-se de criar um arquivo em branco monitoramento.log dentro de /var/log
- WEBHOOK: Crie um webhook no Telegram, Discord ou Slack para receber as notificações e copie o link

### Criação do Webhook no discord

- Dentro de um canal no discord, clique em editar canal

![Selecionando editar canal dentro de um canal](/imgs/EditarCanal.png)

- Na parte de integração selecione Webhooks

![Selecionando webhook na aba de integração](/imgs/Webhook.png)

- Basta copiar a URL e colar no script

![Copiando link do webhook](/imgs/Bot.png)

### 2. O script deve conter os seguintes campos: 

- Verificar se o site responde corretamente a uma requisição HTTP
- Criar logs das verificações em /var/log/monitoramento.log

![Execução do Script](/imgs/SemCron.png)

- Enviar uma notificação via Discord, Telegram ou Slack se detectar indisponibilidade

![Notificação do discord](/imgs/NotDiscord.png)

### 3. Configurar o script para rodar automaticamente a cada 1 minuto usando cron ou systemd timers

- Para configurar a automatização do script, use o comando:
```bash
 crontab -e
```
- Recomenda-se utilizar o editor nano por ser mais fácil

![Escolha do editor do Cron](/imgs/EditorCron.png)

- Após selecionar o editor adicione o seguinte comando:

```bash
* * * * * /var/www/html/nome_script.sh
```

![Configuração do Cron](/imgs/ConfigCron.png)

## Etapa 4: Automação e Testes

### 1. Testar a Implementação: 

- Não esqueça de dar permissão ao script:
```bash
sudo chmod +x nome_script
```
- Dado a permissão basta executar com o seguinte comando
```bash
  ./nome_script.sh
```

![Script em execução com o Cron configurado](/imgs/Cront.png)
