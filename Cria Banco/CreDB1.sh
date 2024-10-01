spool /oracle/admin/sac/create/crdb1.log
startup nomount pfile = "/oracle/admin/sac/pfile/initsac.ora"
CREATE DATABASE "sac"
   maxdatafiles 254
   maxinstances 8
   maxlogfiles 32
   character set WE8ISO8859P1
   national character set WE8ISO8859P1
DATAFILE '/oracle/oradata/sac/system01.dbf' SIZE 150M AUTOEXTEND ON NEXT 10240K
logfile '/oracle/oradata/sac/redo01.log' SIZE 10240K,
    '/oracle/oradata/sac/redo02.log' SIZE 10240K,
    '/oracle/oradata/sac/redo03.log' SIZE 10240K,
    '/oracle/oradata/sac/redo04.log' SIZE 10240K,
    '/oracle/oradata/sac/redo05.log' SIZE 10240K;
spool off

