#!/bin/bash 

# Links
SITE="IP_localhost"
MONITORAR="/var/log/monitoramento.log"
WEBHOOK="link_webhook"

# Função que salva os logs
monitorar() {
	mensagem_monitoramento="$1"
	echo "$(date '+%H:%M:%S %d-%m-%Y') - $mensagem_monitoramento" >> "$MONITORAR"
}

# Função para enviar notificação ao Webhook do Discord
webhook() {
	mensagem_Webhook="$1"
	curl -H "Content-Type: application/json" -X POST -d "{\"content\": \"$mensagem_Webhook\"}" "$WEBHOOK"
}

# Verifica a disponibilidade do site
	resposta=$(curl -o /dev/null -s -w "%{http_code}" "$SITE")

if [[ "$resposta" -eq 200 ]]; then
	monitorar "O site $SITE está disponível! Resposta HTTP: $resposta"
else
	monitorar "O site $SITE está indisponível! Resposta HTTP: $resposta"
	webhook "O site $SITE está fora do ar! Resposta HTTP: $resposta"
fi
