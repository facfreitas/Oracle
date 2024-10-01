#!/bin/bash
PATH=$PATH:$HOME/bin
export PATH
# Oracle Settings
TMP=/tmp; export TMP
TMPDIR=$TMP; export TMPDIR
ORACLE_BASE=/u01/app/oracle; export ORACLE_BASE
export ORACLE_HOME=/u01/app/oracle/product/11.2.0/db_1
ORACLE_SID=CRP011; export ORACLE_SID
PATH=/usr/sbin:$PATH; export PATH
PATH=$ORACLE_HOME/bin:$PATH; export PATH
LD_LIBRARY_PATH=$ORACLE_HOME/lib:/lib:/usr/lib; export LD_LIBRARY_PATH
CLASSPATH=$ORACLE_HOME/jlib:$ORACLE_HOME/rdbms/jlib; export CLASSPATH
expdp "'/as sysdba'" DIRECTORY=DUMP_DIR dumpfile=bruele03_atua_homol.dmp LOGFILE=bruele03_atua_homol.log schemas=BRUELE03 reuse_dumpfiles=y
scp /u01/backup/logico/bruele03_atua_homol*.* 10.145.216.89:/u01/app/oracle/admin/CRP01HML/dpdump/
