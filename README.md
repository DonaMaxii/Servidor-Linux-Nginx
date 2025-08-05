# Projeto Servidor Linux com Nginx

Olá! Este é um projeto de servidor Linux com hospedagem HTML, com script para criação de logs, verificação de erros e notificação para a plataforma de chat Slack.

Este projeto é supervisionado e coordenado pela equipe de Estágio de DevSecOps da Ai/R Learning.

## Passo a Passo:

## Instalação do Servidor Local

Neste projeto, utilizaremos uma VM com Ubuntu 24.04.2 instalado, em modo CLI, sem ambiente gráfico.
No software hipervisor de sua preferência, crie uma VM e instale a referida distro.

Em seguida, configure o acesso ao root, definindo a senha para o mesmo:

    > sudo passwd root

## Instalação do serviço Ngnix

Após a instalação da distro e realizadas as configurações iniciais, precede-se com a instalação e configuração do servidor HTTP Ngnix;

### Passo 1: instalando o Nginx

Logado no servidor como administrador (root), efetue o download do servidor Nginx:

    > apt update
    > apt install nginx

Você pode checar se o serviço Nginx está devidamente instalado e ativo excutando o comando:

    > service --service-all

Caso retorne *[+] nginx* dentre os serviços na tela, parabéns! O serviço está devidamente ativado.

Ps: Outra maneira de checar o *status* do serviço Nginx é através do comando:

    > systemclt status nginx

Caso digitar no navegador de outra VM, o IP da VM, e o servidor Nginx estiver devidamente ativado, a página inicial padrão do Nginx será exibida na tela.

### Passo 2: Configurando a página inicial

Para editar a página padrão do Nginx, a ser exibida ao digitar o IP do servidor, basta editar o arquivo *index.nginx-debian.html*:

    > nano index.nginx-debian.html

Assim, você pode editar o conteúdo da página em HTML.

### Passo 3: Testando o servidor

Para verificar se o servidor está no ar, basta dar um ping no endereço de IP.

    > ip a //para verificar o IP local do servidor
    > ping //IP do servidor
