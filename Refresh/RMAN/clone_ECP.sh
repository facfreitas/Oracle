# =====================================================================================================
#
# Script# clone.sh
# Este script gera o ambiente de homologação a partir do banco de produção informado pelos seguintes parâmetros: 
# $1 - SID da instância de homologação (Auxiliar)
# $2 - SID da instância de produção (Target) 
#
# Desenvolvido por Fernando Freitas
# Data atualização: 03/11/2014
# =====================================================================================================


echo ################## Inicio da sessão de declaração de variáveis ####################################

export LOGFILE=LogClone$2.log   
export ORACLE_SID=$1 
export dbconnAuxiliar="/ as sysdba"
export dbconnTarget=sys/EEP2016#@$2  

echo ################## Final da sessão de declaração de variáveis ######################################


echo ################## Inicio da sessão de criação dinâmica de arquivos ################################
echo ################## Gera script  para iniciar a instância de Homologação ############################

echo STARTUP NOMOUNT	> start$1.sql
echo exit		>> start$1.sql

echo ################# Gera script  para Finalizar a instância de Homologação ###########################

echo SHUTDOWN immediate  > stop$1.sql
echo exit            	>> stop$1.sql

echo ################## Gera script  para Duplicar a base de produção para homologação 

echo "run {"                                                                                                                                            > dup$2.sql
echo "SET NEWNAME FOR DATABASE TO '+dg_ecp_data/ecq/datafile/%U';"											>> dup$2.sql
echo "duplicate target database to $1 from active database;"                                                                                            >> dup$2.sql
echo "}"                                                                                                                                                >> dup$2.sql
echo "exit"                                                                                                                                             >> dup$2.sql

echo ################## Final da sessão de criação dinâmica de arquivos ##################################


#######1#########2#########3 REGISTRO LOG DO INICIO ############4#########5#######6#########

echo "Inicio duplicação OnLine:  $(date)"	 						> $LOGFILE

								 				>> $LOGFILE
echo ------- Finalizando a instância Auxiliar - $1 -------------  				>> $LOGFILE	
sqlplus $dbconnAuxiliar @stop$1.sql 			          				>> $LOGFILE
								  				>> $LOGFILE
echo ------- Inicializando a instância Auxiliar - $1 ----------   				>> $LOGFILE	
sqlplus $dbconnAuxiliar @start$1.sql 			          				>> $LOGFILE	
	                                                                   			>> $LOGFILE
echo -------- conexão nas instâncias $1 e $2 --------------------  				>> $LOGFILE	
echo -------- Refresh do banco de Homologacao $1 ---------------- 				>> $LOGFILE
								  				>> $LOGFILE
rman TARGET sys/EEP2016#@$2 AUXILIARY sys/EEP2016#@$1 @dup$2.sql				>> $LOGFILE


echo ######################## Sessão pós duplicação  ####################################

echo #######1#########2#########3 COLOCANDO EM NOARCHIVELOG ############4#########5###########6##
echo "Alterando o banco $1 para NOARCHIVELOG"                                                   >> $LOGFILE

sqlplus $dbconnAuxiliar @noarchivelog$1.sql                                                     >> $LOGFILE

echo #######1#########2#########3 EXECUÇÃO DE SCRIPTS ############4#########5###########6##


echo -------- Execução de scripts no banco $1 ----------------	 				>> $LOGFILE

#sqlplus $dbconnAuxiliar @scriptTESTE$1.sql                                                     	>> $LOGFILE


#######1#########2#########3 REGISTRO LOG DO FIM ############4#########5#######6#########
echo "Fim da duplicação OnLine:  $(date)"                                               	>> $LOGFILE


