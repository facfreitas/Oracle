# restart_db
#
# Parametros para o restartup do banco oracle9i
#!/bin/sh
#

# REINICIALIZACAO DO LISTENER
lsnrctl stop
lsnrctl start

# DERRUBANDO O ORACLE
export ORACLE_SID=ibametro
sqlplus "/ as sysdba" <<-EOF
shutdown immediate
EOF

# INIALIZANDO O ORACLE
export ORACLE_SID=ibametro
sqlplus "/ as sysdba" <<-EOF
startup
EOF

exit 0

