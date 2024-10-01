 select * from v$log
 
 alter system switch logfile;
 
 select * from v$logfile 
select * from v$dbfile

 alter database drop logfile group 2; 
 
 alter database add logfile group 4 ('D:\ORACLE\GEOP\ORIGLOGB\LOG4B.LOG',
 'D:\ORACLE\GEOP\MIRRLOGB\LOG4B.LOG') size 50M; 

 alter database add logfile member 'D:\ORACLE\GEOP\MIRRLOGB\REDO02.LOG' to group 2 


