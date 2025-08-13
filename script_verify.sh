# ARQUIVO DE LOG PARA VERIFICAR SERVIDOR DE WEB

# Arquivo de log
LOGFILE="/var/log/nginx_status.log"

# Data e hora atuais
DATA=$(date '+%Y-%m-%d %H:%M:%S')
WEBHOOK_URL="https://hooks.slack.com/services/T00000000/B00000000/XXXXXXXXXXXXXXXXXXXXXXXX"

# Verificação de status , com desvio condicional
# se o NGINX está ativo:
if systemctl is-active --quiet nginx; then
	echo "$DATA - NGINX está ativo." >> "$LOGFILE"
#Se o NGINX NÃO estiver ativo, ou desativado:
else
	echo "$DATA - ATENÇÃO: o serviço NGINX está parado!!" >> "$LOGFILE"

	# Enviando alerta para o SLACK
	curl -X POST -H 'Content-type: application/json' \
		--data '{"text":"ATENÇÃO - SISTEMA NGINX FORA DO AR em '"$DATA"'"}' \
		"$WEBHOOK_URL"
  	#Reiniciando o serviço imediata e automaticamente
   	systemctl start nginx
   
fi
