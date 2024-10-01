-- Log Miner
-- So para o Oracle 8.0.x em diante
-- 
-- Se estiver executando Oracle8, execute dbmslogmnrd.sql como SYS
-- O diretorio especificado tem que ser visivel via UTL_FILE_DIR

-- Cria o arquivo de DICIONARIO DE DADOS usado pelo Log Miner.
-- Parametro 1: arquivo / Parametro 2: diretorio 
BEGIN sys.dbms_logmnr_d.build('CLBP1DICT.ORA','C:\TEMP'); END;
 

-- Informando os logs a serem analisados. O primeiro log deve ser iniciado com:
BEGIN sys.dbms_logmnr.add_logfile('E:\CLBPArch\CLBP00279.ARC',sys.dbms_logmnr.new); END;

-- Adicionando os logs
BEGIN sys.dbms_logmnr.add_logfile('E:\CLBPArch\CLBP00280.ARC',dbms_logmnr.addfile); END;

-- Analisando os logs
/* Assinatura da Procedure
PROCEDURE start_logmnr(
     startScn           IN NUMBER default 0 ,
     endScn 		    IN NUMBER default 0,
     startTime      	IN DATE default TO_DATE('01-jan-1988','DD-MON-YYYY'),
     endTime        	IN DATE default TO_DATE('01-jan-2988','DD-MON-YYYY'),
     DictFileName    	IN VARCHAR2 default '',
     Options		    IN BINARY_INTEGER default 0 );
*/

BEGIN sys.dbms_logmnr.start_logmnr(DictFileName=>'C:\TEMP\CLBP1DICT.ORA'); END;

-- Consulta os dados extraidos
-- SESSION_INFO - Informacoes de que fez a Operacao
-- SQL_REDO - Operacao realizada
-- SQL_UNDO - Como desfazer a Operacao realizada

-- SELECT * FROM V$LOGMNR_CONTENTS
SELECT TIMESTAMP, USERNAME, SQL_REDO FROM V$LOGMNR_CONTENTS

-- Libera os recursos
BEGIN sys.dbms_logmnr.end_logmnr; END;
