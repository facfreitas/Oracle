spool /u01/app/oracle/oradata/mydb/createdb/createmydb.log
set echo on
startup nomount pfile="/u01/app/oracle/oradata/mydb/pfile/initmydb.ora"

set verify off
create database mydb
 user sys identified by gerentemydb
 user system identified by gerentemydb
 logfile group 1 ('/u01/app/oracle/oradata/mydb/redo/redo01') size 512k,
         group 2 ('/u01/app/oracle/oradata/mydb/redo/redo02') size 512k,
         group 3 ('/u01/app/oracle/oradata/mydb/redo/redo03') size 512k
 maxlogfiles 5
 maxlogmembers 5
 maxloghistory 1
 maxdatafiles 100
 maxinstances 3
 archivelog
 force logging
 character set WE8ISO8859P1
 national character set AL16UTF16
 datafile '/u01/app/oracle/oradata/mydb/data/system01.dbf' size 250M

spool off
