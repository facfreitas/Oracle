#!/bin/sh
# db_oracle: start, stop or restart the listener and databases in Oracle9i
# Salvador - Bahia
# 21/10/2002
# Edson Tanajura Vaz
# Netra Tecnologia LTDA
# Source function library.
. /etc/rc.d/init.d/functions
ECHO_N="echo -n"
ECHO_C=""

# See how we were called.
case "$1" in
        start)
                su - oracle9i -c "/home/oracle9i/start_db.sh"
        ;;

        stop)
                su - oracle9i -c "/home/oracle9i/stop_db.sh"
        ;;

        restart)
                su - oracle9i -c "/home/oracle9i/restart_db.sh"
        ;;

        *)
                echo $"Usage: $0 {start|stop|restart}"
                exit 1

        ;;
esac

exit 0


