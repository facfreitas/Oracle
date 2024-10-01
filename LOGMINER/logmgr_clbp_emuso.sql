Begin
sys.DBMS_LOGMNR.ADD_LOGFILE(OPTIONS => sys.dbms_logmnr.NEW, LOGFILENAME => 
'f:\oracle\clbp\archive\clbp210730.arc');
sys.DBMS_LOGMNR.ADD_LOGFILE(OPTIONS => sys.dbms_logmnr.ADDFILE, LOGFILENAME => 
'f:\oracle\clbp\archive\clbp210731.arc');
sys.DBMS_LOGMNR.ADD_LOGFILE(OPTIONS => sys.dbms_logmnr.ADDFILE, LOGFILENAME => 
'f:\oracle\clbp\archive\clbp210732.arc');
sys.DBMS_LOGMNR.ADD_LOGFILE(OPTIONS => sys.dbms_logmnr.ADDFILE, LOGFILENAME => 
'f:\oracle\clbp\archive\clbp210733.arc');
sys.DBMS_LOGMNR.ADD_LOGFILE(OPTIONS => sys.dbms_logmnr.ADDFILE, LOGFILENAME => 
'f:\oracle\clbp\archive\clbp210734.arc');
sys.DBMS_LOGMNR.ADD_LOGFILE(OPTIONS => sys.dbms_logmnr.ADDFILE, LOGFILENAME => 
'f:\oracle\clbp\archive\clbp210735.arc');
sys.DBMS_LOGMNR.ADD_LOGFILE(OPTIONS => sys.dbms_logmnr.ADDFILE, LOGFILENAME => 
'f:\oracle\clbp\archive\clbp210736.arc');
sys.DBMS_LOGMNR.ADD_LOGFILE(OPTIONS => sys.dbms_logmnr.ADDFILE, LOGFILENAME => 
'f:\oracle\clbp\archive\clbp210737.arc');
sys.DBMS_LOGMNR.ADD_LOGFILE(OPTIONS => sys.dbms_logmnr.ADDFILE, LOGFILENAME => 
'f:\oracle\clbp\archive\clbp210738.arc');
sys.DBMS_LOGMNR.ADD_LOGFILE(OPTIONS => sys.dbms_logmnr.ADDFILE, LOGFILENAME => 
'f:\oracle\clbp\archive\clbp210739.arc');
end;

Begin
sys.DBMS_LOGMNR.START_LOGMNR(
DICTFILENAME => 'd:\orcldict.ora');
end; 

Begin
sys.DBMS_LOGMNR.START_LOGMNR(
DICTFILENAME => 'd:\orcldict.ora',
STARTTIME => to_date('18-Ago-2003 09:38:00', 'DD-MON-YYYY HH:MI:SS'),
ENDTIME => to_date('18-Ago-2003 09:40:00', 'DD-MON-YYYY HH:MI:SS'));
end; 


Begin
sys.DBMS_LOGMNR.END_LOGMNR;
end; 

SELECT count(*)
FROM v$logmnr_contents 
WHERE seg_owner = 'EMA' AND seg_name = 'MOVIMENTACAO_EQUIP_MEDICAO'

select count(*)
from logmgr

select max(timestamp) from logmgr

select * FROM v$logmnr_contents 

grant select on logmgr to pot594139

select * from logmgr where operation = 'DELETE'

select scn, timestamp, log_id, seg_owner, seg_name,
	   table_space, username, operation
from v$logmnr_contents	   
WHERE seg_owner = 'EMA' AND seg_name = 'MOVIMENTACAO_EQUIP_MEDICAO' 