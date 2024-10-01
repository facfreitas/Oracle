#!/bin/sh
# db_oracle: start, stop or restart the listener and databases in Oracle9i
# Salvador - Bahia
# 21/10/2002
# Autor:Edson Tanajura Vaz
# Alteracoes: Fernando de Freitas Jr.
# Netra Tecnologia LTDA
# Source function library.
. /etc/rc.d/init.d/functions
ECHO_N="echo -n"
ECHO_C=""

# See how we were called.
case "$1" in
        start)
                su - oracle -c "/home/oracle/startup_shutdown/start_db.sh"
        ;;

        stop)
                su - oracle -c "/home/oracle/startup_shutdown/stop_db.sh"
        ;;

        restart)
                su - oracle -c "/home/oracle/startup_shutdown/restart_db.sh"
        ;;

        *)
                echo $"Usage: $0 {start|stop|restart}"
                exit 1

        ;;
esac

exit 0


