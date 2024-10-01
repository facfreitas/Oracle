# stop_db
#
# Parametros para o startup do banco oracle9i
#!/bin/sh

# PARANDO DO LISTENER
lsnrctl stop

# DERRUBANDO O ORACLE
export ORACLE_SID=ibametro
sqlplus "/ as sysdba" <<-EOF
shutdown immediate
EOF

exit 0

