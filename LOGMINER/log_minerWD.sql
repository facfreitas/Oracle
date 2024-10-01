LogMiner
LogMiner allows you to analyze the contents of archived redo logs. It can be used to provide a historical view of the database without the need for point-in-time recovery. It can also be used to undo operations allowing repair of logical corruption.


Create Dictionary File 
Adding Logs 
Starting LogMiner 
Querying Log Information 
Create Dictionary File
Without a dictionary file LogMiner displays all tables and columns using their internal object IDs and all values as hex data. The dictionary file is used to translate this data into a more meaningful format. For the dictionary file to be created the following init.ora parameter must be set and the instance must be mounted/open:

UTL_FILE_DIR=C:\Oracle\Oradata\TSH1\Archive
The dictionary file can then be created by issuing the following startement:

EXECUTE Dbms_Logmnr_D.Build( -
dictionary_filename =>'TSH1dict.ora', -
dictionary_location => 'C:\Oracle\Oradata\TSH1\Archive');
Adding Logs
A new list of logs to be analyzed must be added to logminer. Subsequent logs are added to this list:

EXECUTE Dbms_Logmnr.Add_Logfile( -
options => Dbms_Logmnr.New, -
logfilename => 'C:\Oracle\Oradata\TSH1\Archive\TSH1T001S00006.ARC');

EXECUTE Dbms_Logmnr.Add_Logfile( -
options => Dbms_Logmnr.AddFile, -
logfilename => 'C:\Oracle\Oradata\TSH1\Archive\TSH1T001S00007.ARC');
Starting LogMiner
At this point LogMiner can be started. The analysis range can be narrowed using time or SCN:

-- Start using all logs
EXECUTE Dbms_Logmnr.Start_Logmnr( -
dictfilename =>'C:\Oracle\Oradata\TSH1\Archive\TSH1dict.ora');

-- Specifiy time range
EXECUTE Dbms_Logmnr.Start_Logmnr( -
dictfilename =>'C:\Oracle\Oradata\TSH1\Archive\TSH1dict.ora', -
starttime => to_date('01-Jan-2001 00:00:00', 'DD-MON-YYYY HH:MI:SS') -
endtime => to_date('01-Jan-2001 10:00:00', 'DD-MON-YYYY HH:MI:SS'));

-- Specifiy SCN range
EXECUTE Dbms_Logmnr.Start_Logmnr( -
dictfilename =>'C:\Oracle\Oradata\TSH1\Archive\TSH1dict.ora', -
startscn => 100, -
endscn => 150);
Querying Log Information
Once LogMiner has started you can query the following views to gather information:

V$LOGMNR_DICTIONARY - The dictionary file in use. 
V$LOGMNR_PARAMETERS - Current parameter settings for LogMiner. 
V$LOGMNR_LOGS - Which redo log files are being analyzed. 
V$LOGMNR_CONTENTS - The contents of the redo log files being analyzed. 
To see what SQL has been issued and the undo to reverse it you could use the following:

SELECT scn, operation, sql_redo, sql_undo
FROM v$logmnr_contents;
To check the number of hits for each object during the analyzed period try:

SELECT seg_owner, seg_name, count(*) AS Hits
FROM v$logmnr_contents
WHERE seg_name NOT LIKE '%$'
GROUP BY seg_owner, seg_name;
Hope this helps. Regards Tim...


-------------------------------
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
--------------------------------------------------------------------------
