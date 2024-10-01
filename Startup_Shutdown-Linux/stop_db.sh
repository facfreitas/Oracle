# stop_db
#
# Parametros para o shutdown do banco oracle9i
#!/bin/sh
#
lsnrctl stop
# export ORACLE_SID=proton
# sqlplus "sys/dbanetra as sysdba" <<-EOF
#         shutdown abort
# EOF
export ORACLE_SID=NETRA01
sqlplus "sys/dbanetra as sysdba" <<-EOF
        shutdown abort
EOF
export ORACLE_SID=NOSSABBR
sqlplus "sys/dbanetra as sysdba" <<-EOF
        shutdown abort
EOF
exit 0


