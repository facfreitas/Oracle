# start_db
#
# Parametros para o startup do banco oracle9i
#!/bin/sh
lsnrctl start
# export ORACLE_SID=proton
# sqlplus "sys/dbanetra as sysdba" <<-EOF
#         startup
# EOF
export ORACLE_SID=NETRA01
sqlplus "sys/dbanetra as sysdba" <<-EOF
        startup
EOF
export ORACLE_SID=NOSSABBR
sqlplus "sys/dbanetra as sysdba" <<-EOF
        startup
EOF

exit 0



