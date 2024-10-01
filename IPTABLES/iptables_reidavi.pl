#================================================================
# Script de firewall utilizando IPTABLES
#================================================================
# NETRA TECNOLOGIA à serviço do IBAMETRO
# Autor: Fernando Freitas(fernando.freitas@netra.com.br)

# ********************* #
# Variaveis de trabalho
# ********************* #
IPTABLES=/sbin/iptables
INTERNET=0/0
LOCALHOST=127.0.0.1

# ********************************* #
# Limpa todas as regras do IPTABLES
# ********************************* #
$IPTABLES -F

# ****************** #
# Primeiro nega tudo
# ****************** #
$IPTABLES -P FORWARD DROP
$IPTABLES -P INPUT   DROP
$IPTABLES -P OUTPUT  DROP

#-------------------
# Regras do firewall
#-------------------

# Pode sair para qualquer lugar
$IPTABLES -A OUTPUT -j ACCEPT

# Aceita qualquer trafego local
$IPTABLES -A INPUT -s $LOCALHOST -d $LOCALHOST -j ACCEPT

# Aceita ping
$IPTABLES -A INPUT -p icmp -j ACCEPT

# Logon rápido
$IPTABLES -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

# ************ #
# Porta do SSH #
# ************ #
$IPTABLES -A INPUT -s $INTERNET -p tcp --dport 6677 -j ACCEPT
$IPTABLES -A INPUT -s $INTERNET -p udp --dport 6677 -j ACCEPT

# ************* #
# Porta do OC4J #
# ************* #
$IPTABLES -A INPUT -s $INTERNET -p tcp --dport 23791 -j ACCEPT
$IPTABLES -A INPUT -s $INTERNET -p udp --dport 23791 -j ACCEPT
$IPTABLES -A INPUT -s $INTERNET -p tcp --dport 23943 -j ACCEPT
$IPTABLES -A INPUT -s $INTERNET -p udp --dport 23943 -j ACCEPT
$IPTABLES -A INPUT -s $INTERNET -p tcp --dport 6622 -j ACCEPT
$IPTABLES -A INPUT -s $INTERNET -p udp --dport 6622 -j ACCEPT
$IPTABLES -A INPUT -s $INTERNET -p tcp --dport 33050 -j ACCEPT
$IPTABLES -A INPUT -s $INTERNET -p udp --dport 33050 -j ACCEPT

# ************* #
# Porta do VNC  #
# ************* #
$IPTABLES -A INPUT -s $INTERNET -p tcp --dport 5800 -j ACCEPT
$IPTABLES -A INPUT -s $INTERNET -p udp --dport 5800 -j ACCEPT
$IPTABLES -A INPUT -s $INTERNET -p tcp --dport 5900 -j ACCEPT
$IPTABLES -A INPUT -s $INTERNET -p udp --dport 5900 -j ACCEPT
$IPTABLES -A INPUT -s $INTERNET -p tcp --dport 5933 -j ACCEPT

# **************** #
# Porta do ORACLE  #
# **************** #
$IPTABLES -A INPUT -s $INTERNET -p tcp --dport 1521 -j ACCEPT
$IPTABLES -A INPUT -s $INTERNET -p udp --dport 1521 -j ACCEPT

# ************** #
# Porta do SSL   #
# ************** #
$IPTABLES -A INPUT -s $INTERNET -p tcp --dport 443 -j ACCEPT
$IPTABLES -A INPUT -s $INTERNET -p tcp --dport 4443 -j ACCEPT
$IPTABLES -A INPUT -s $INTERNET -p udp --dport 443 -j ACCEPT
$IPTABLES -A INPUT -s $INTERNET -p udp --dport 4443 -j ACCEPT

# ************* #
# Porta do EM   #
# ************* #
$IPTABLES -A INPUT -s $INTERNET -p tcp --dport 1810 -j ACCEPT
$IPTABLES -A INPUT -s $INTERNET -p tcp --dport 1810 -j ACCEPT

# ************** #
# Porta do JMS   #
# ************** #
$IPTABLES -A INPUT -s $INTERNET -p tcp --dport 9127 -j ACCEPT
$IPTABLES -A INPUT -s $INTERNET -p tcp --dport 9127 -j ACCEPT

# ******************** #
# Contra PING OF DEATH
# ******************** #
$IPTABLES -A FORWARD -p icmp --icmp-type echo-request -m limit --limit 1/s -j ACCEPT