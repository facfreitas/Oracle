begin
sys.DBMS_LOGMNR_D.BUILD
( DICTIONARY_FILENAME => 'orcldict.ora',DICTIONARY_LOCATION => 'd:\');
end;

alter system switch logfile

select * from v$log

select * from v$logfile

Begin
sys.DBMS_LOGMNR.ADD_LOGFILE(OPTIONS => sys.dbms_logmnr.NEW, LOGFILENAME => 
'f:\oracle\clbp\archive\clbp210617.arc');
end;

Begin
sys.DBMS_LOGMNR.ADD_LOGFILE(OPTIONS => sys.dbms_logmnr.NEW, LOGFILENAME => 
'f:\oracle\clbp\archive\clbp210617.arc');
sys.DBMS_LOGMNR.ADD_LOGFILE(OPTIONS => sys.dbms_logmnr.ADDFILE, LOGFILENAME => 
'f:\oracle\clbp\archive\clbp210618.arc');
sys.DBMS_LOGMNR.ADD_LOGFILE(OPTIONS => sys.dbms_logmnr.ADDFILE, LOGFILENAME => 
'f:\oracle\clbp\archive\clbp210619.arc');
sys.DBMS_LOGMNR.ADD_LOGFILE(OPTIONS => sys.dbms_logmnr.ADDFILE, LOGFILENAME => 
'f:\oracle\clbp\archive\clbp210620.arc');
sys.DBMS_LOGMNR.ADD_LOGFILE(OPTIONS => sys.dbms_logmnr.ADDFILE, LOGFILENAME => 
'f:\oracle\clbp\archive\clbp210621.arc');
sys.DBMS_LOGMNR.ADD_LOGFILE(OPTIONS => sys.dbms_logmnr.ADDFILE, LOGFILENAME => 
'f:\oracle\clbp\archive\clbp210622.arc');
end;

Begin
sys.DBMS_LOGMNR.START_LOGMNR(
DICTFILENAME => 'd:\orcldict.ora',
STARTTIME => to_date('18-Ago-2003 09:37:00', 'DD-MON-YYYY HH:MI:SS'),
ENDTIME => to_date('18-Ago-2003 09:38:00', 'DD-MON-YYYY HH:MI:SS'));
end; 


Begin
sys.DBMS_LOGMNR.END_LOGMNR;
end; 

SELECT timestamp, sql_redo, sql_undo 
FROM v$logmnr_contents 
WHERE seg_owner = 'EMA' AND seg_name = 'MOVIMENTACAO_EQUIP_MEDICAO'

select * FROM v$logmnr_contents 



create table logmgr 
tablespace lgmr storage (initial 2000M  pctincrease 0) as
select scn, timestamp, log_id, seg_owner, seg_name,
	   table_space, username, operation
from v$logmnr_contents	   
where 1 = 2


 select * from dba_data_files
 where file_name like '%LGMR%'
