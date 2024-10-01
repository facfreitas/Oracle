# start_db
#
# Parametros para o startup do banco oracle9i
#!/bin/sh


# INICIALIZACAO DO LISTENER
lsnrctl start

# INIALIZANDO O ORACLE
export ORACLE_SID=ibametro
sqlplus "/ as sysdba" <<-EOF
startup
EOF

exit 0

