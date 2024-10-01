#!/bin/bash

PATH=$PATH:$HOME/bin

export PATH

# Oracle Settings
TMP=/tmp; export TMP
TMPDIR=$TMP; export TMPDIR

ORACLE_HOSTNAME=LDCDBDEV01.intranet.local; export ORACLE_HOSTNAME
ORACLE_BASE=/u01/app/oracle; export ORACLE_BASE
GRID_HOME=/u01/app/11.2.0/grid; export GRID_HOME
DB_HOME=$ORACLE_BASE/product/11.2.0/db_1; export DB_HOME
ORACLE_HOME=$DB_HOME; export ORACLE_HOME
ORACLE_TERM=xterm; export ORACLE_TERM
BASE_PATH=/usr/sbin:$PATH; export BASE_PATH
PATH=$ORACLE_HOME/bin:$BASE_PATH; export PATH

LD_LIBRARY_PATH=$ORACLE_HOME/lib:/lib:/usr/lib; export LD_LIBRARY_PATH
CLASSPATH=$ORACLE_HOME/JRE:$ORACLE_HOME/jlib:$ORACLE_HOME/rdbms/jlib; export CLASSPATH

ORACLE_SID=CRP01DEV; export ORACLE_SID

export NLS_LANG=AMERICAN_AMERICA.WE8MSWIN1252
export NLS_NCHAR=AL16UTF16
export LOGFILE=/home/oracle/scripts/log/refresh_sap_hr.log

echo "###################################" >> $LOGFILE
echo "Iniciando refresh do esquema BRUELE03" >> $LOGFILE
date >> $LOGFILE

ssh oracle@10.145.196.180 "/home/oracle/scripts/atualiza_ldcbddev01_saphr.sh"

sqlplus /nolog @/home/oracle/scripts/impdp_refresh_saphr.sql

echo "###################################" >> $LOGFILE
echo "Finalizado refresh do esquema BRUELE03" >> $LOGFILE
date >> $LOGFILE

