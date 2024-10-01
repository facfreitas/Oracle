# restart_db
#
# Parametros para o restartup do banco oracle9i
#!/bin/sh
#
lsnrctl stop
lsnrctl start
# export ORACLE_SID=proton
# sqlplus "sys/dbanetra as sysdba" <<-EOF
#         shutdown abort
#         startup
# EOF
export ORACLE_SID=NETRA01
sqlplus "sys/dbanetra as sysdba" <<-EOF
        shutdown abort
        startup
EOF
export ORACLE_SID=NOSSABBR
sqlplus "sys/dbanetra as sysdba" <<-EOF
        shutdown abort
        startup
EOF

exit 0

