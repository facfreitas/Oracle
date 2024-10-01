#################################################################
#                Rotina de Exportacao Logica                    #
#                                                               #
# Desenvolvida por:  Polo-IT                                    #
# Tipo de Backup:    Expdp                                      #
# Versao Compativel: 10g, 11g                                   #
#                                                               #
# Ultima revisao:    27/11/2013 por Robson Dias
#                                                               #
# Adaptado por Fernando Freitas para esta instancia             #
#                                                               #
#################################################################


PATH=$PATH:$HOME/bin

export PATH

export ORACLE_BASE=/u01/app/oracle
export ORACLE_SID=RMN

export ORACLE_HOME=$ORACLE_BASE/product/11.2.0/db_1
export PATH=$PATH:$ORACLE_HOME/bin:/home/oracle:/home/oracle/scripts
export LD_LIBRARY_PATH=$ORACLE_HOME/lib

export NOMEARQ=`date +%Y%m%d%H%M`

export DEST=/u01/backup/logico/RMN
export LOGFILE=/home/oracle/scripts/log/backup_logico_RMN.log

echo "########################" >> /home/oracle/scripts/log/backup_logico_RMN.log
echo "Limpeza" >> $LOGFILE
date >> $LOGFILE

find /u01/backup/logico/RMN -name "expdp*" -daystart -mtime +1 -exec rm '{}' ';'

date >> $LOGFILE

echo "Exportacao" >> $LOGFILE
date >> $LOGFILE

expdp fullbkp/fullbkp directory=DUMP_DIR dumpfile=expdp-RMN-$NOMEARQ.dmp logfile=expdp-RMN-$NOMEARQ.log full=Y

expdp fullbkp/fullbkp directory=DUMP_DIR dumpfile=expdp-DEF-RMN-$NOMEARQ.dmp logfile=expdp-DEF-RMN-$NOMEARQ.log full=Y content=metadata_only

date >> $LOGFILE

echo "Compactacao" >> $LOGFILE
date >> $LOGFILE

gzip -f $DEST/*.dmp

date >> $LOGFILE

# Enviando e-mail ao final
#-------------------------------------
cat /home/oracle/scripts/log/backup_logico_RMN.log | mailx -s "DATA PUMP FULL RMN FINALIZADO $DATA" fernando.freitas@enseda.com -- -f operacao@enseada.com

