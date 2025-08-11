# 🖥️ Projeto Servidor Linux com Nginx

Olá! Este é um projeto de servidor Linux com hospedagem HTML, com script para criação de logs, verificação de erros e notificação para a plataforma de chat Slack.

Este projeto é supervisionado e coordenado pela equipe de Estágio de DevSecOps da Ai/R Learning.

![Servidor Web Nginx](/thumbnail.png)

## 📝 Índice
* [Instalação do Servidor Local](#instalação-do-servidor-local)
* [Instalação do serviço Nginx](#instalação-do-Serviço-Nginx)
* [Logs de servidor](#logs-de-servidor)
* [Notificação Webhook para Slack](#notificação-webhook-para-slack)

## ➡️ Passo a Passo:

## Instalação do Servidor Local

Neste projeto, utilizaremos uma VM com Ubuntu 24.04.2 instalado, em modo CLI, sem ambiente gráfico.

No software hipervisor de sua preferência, crie uma VM e instale a referida distro.

--- 

## Instalação do Serviço Nginx

Após a instalação da distro e realizadas as configurações iniciais, precede-se com a instalação e configuração do servidor HTTP Nginx.

__Passo 1:__ instalando o Nginx: logado no servidor como administrador (root), efetue o download do servidor Nginx:

    > apt update
    > apt install nginx

Você pode checar se o serviço Nginx está devidamente instalado e ativo, executando o seguinte comando:

    > service --service-all

Caso retorne *[+] nginx* dentre os serviços na tela, parabéns! O serviço está devidamente ativado.

Ps: Outra maneira de checar o *status* do serviço Nginx é através do comando:

    > systemclt status nginx

Caso digitar no navegador de outra VM, o IP da VM, e o servidor Nginx estiver devidamente ativado, a página inicial padrão do Nginx será exibida na tela.

__Passo 2:__ para editar a página inicial padrão do Nginx, a ser exibida ao digitar o IP do servidor, basta editar o arquivo *index.nginx-debian.html*:

    > nano index.nginx-debian.html

Assim, você pode editar o conteúdo da página em HTML.

__Passo 3:__ Testando o servidor: para verificar se o servidor está no ar, basta dar um ping no endereço de IP.

    > ip a //para verificar o IP local do servidor
    > ping //IP do servidor

![Snapshot da página html inicial](/snapshot_1.png)
---

## Logs de servidor

Agora, configuramos o arquivo .sh para monitorar o status do servidor web, atualizando arquivo .log a cada 1 (um) minuto.

__Passo 1:__ crie um arquivo .log para receber as informações de log:
    
    > touch /var/log/nginx_status.log

__Passo 2:__ defina a permissão adequada para escrita e leitura desse arquivo:

    > chmod 664 /var/log/nginx_status.log

__Passo 3:__ crie o arquivo .sh e programe o script que irá popular o arquivo de log criado.

    > touch /usr/local/bin/script_verify.sh

Ao programar esse script, atente-se em definir variáveis como o caminho para o arquivo de log, a data e a hora atuais, e um desvio condicional, ou seja, se o serviço Nginx estiver ativo, exibe mensagem de ATIVO; caso contrário, será exibida frase de alerta.

    # ARQUIVO DE LOG PARA VERIFICAR SERVIDOR DE WEB

    # Arquivo de log
    LOGFILE="/var/log/nginx_status.log"

    # Data e hora atuais
    DATA=$(date '+%Y-%m-%d %H:%M:%S')

    # Verificação de status , com desvio condicional   

    if systemctl is-active --quiet nginx; then
		echo "$DATA - NGINX está ativo." >> "$LOGFILE"
    else
		echo "$DATA - ATENÇÃO: o serviço NGINX está parado!!" >> "$LOGFILE"
 
    fi

__Passo 4:__ Agora, é necessário configurar o sistema para executar esse script em tempo real e automaticamente. Para isso, utilizamos o serviço *cron*.

    > crontab -e
    > * * * * * /usr/local/bin/script_verify.sh

Ps: cada asterisco (*) representa um parâmetro para a automação do script, com base em minuto, hora, dia do mês, mês e dia da semana. Na configuração acima, o script rodará a cada 1 (um) minuto, ou 60 segundos.    

__Passo 5:__ Por fim, ative o serviço Nginx (caso o mesmo não esteja ativo) e, depois de alguns minutos, verifique se o arquivo de log está sendo populado com as atualizações minuto a minuto.

    > service nginx start
    > cat /var/log/nginx_status.log

O arquivo deverá exibir uma saída semelhante a esta:

    2025-08-06 17:22:01 - NGINX está ativo.
    2025-08-06 17:23:01 - NGINX está ativo.
    2025-08-06 17:24:00 - NGINX está ativo.
    2025-08-06 17:25:00 - NGINX está ativo.
    2025-08-06 17:26:00 - NGINX está ativo.

![Snapshot dos logs de servidor](/snapshot_2.png)
---

## Notificação Webhook para Slack

Neste etapa, configuramos um bot para avisar em um servidor Slack quando o serviço web está fora do ar.

Para isso, é necessário ter uma conta e um workspace Slack ativos.

__Passo 1:__ Acesse o link *https://api.slack.com/apps* a partir do Workspace desejado.

__Passo 2:__ Crie e configure um app para servir as notificações, definindo em qual Workspace ele irá atuar;

__Passo 3:__ Adicione uma requisição do tipo Webhook, que será acrescentada ao script já configurado nos passos acima. O Slack fornecerá URL, cujo mesmo terá este formato:

    https://hooks.slack.com/services/T00000000/B00000000/XXXXXXXXXXXXXXXXXXXXXXXX

__Passo 4:__ Edite o arquivo de script */usr/local/bin/script_verify.sh*, declarando a variável WEBHOOK_URL e inserindo a instrução curl para enviar o alerta ao Slack, definindo mensagem a ser exibida na notificação.

    WEBHOOK_URL="https://hooks.slack.com/services/T00000000/B00000000/XXXXXXXXXXXXXXXXXXXXXXXX"

	# Enviando alerta para o SLACK
	curl -X POST -H 'Content-type: application/json' \
	--data '{"text":"ATENÇÃO - SISTEMA NGINX FORA DO AR em '"$DATA"'"}' \
	"$WEBHOOK_URL"

__Passo 5:__ Por fim, para testar se a mesnagem está sendo enviada, desligue o serviço Nginx através do comando *service nginx stop*. Caso as configurações surtam efeito, você verá as notificações sendo escritas no chat do servidor escolhido.

    18h05
    ATENÇÃO - SISTEMA NGINX FORA DO AR em 2025-08-06 18:05:00
    18h06
    ATENÇÃO - SISTEMA NGINX FORA DO AR em 2025-08-06 18:06:00
    18h07
    ATENÇÃO - SISTEMA NGINX FORA DO AR em 2025-08-06 18:07:01
    18h08
    ATENÇÃO - SISTEMA NGINX FORA DO AR em 2025-08-06 18:08:00
    18h09
    ATENÇÃO - SISTEMA NGINX FORA DO AR em 2025-08-06 18:09:00

![Snapshot das notificações de sistema fora do ar](/snapshot_3.png)
---

## ☑️ Conclusão

Ao final deste passo-a-passo, o desenvolvedor será capaz de instalar e configurar um servidor web local, definir uma página *index* html, configurar o monitoramento do serviço através do *shell script* e *cron*, e desenvolver um sistema de alerta Webhook para Slack.

Se você chegou até aqui, muito obrigada pela atenção. :D
