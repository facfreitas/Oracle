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
expdp "'/as sysdba'" DIRECTORY=DUMP_DIR dumpfile=saphr_atua_dev.dmp LOGFILE=saphr_atua_dev.log schemas=SAP_HR reuse_dumpfiles=y
scp /u01/backup/logico/saphr_atua_dev*.* 10.145.216.4:/u01/app/oracle/admin/CRP01DEV/dpdump/
