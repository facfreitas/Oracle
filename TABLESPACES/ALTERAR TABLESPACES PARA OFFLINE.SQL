select 'alter tablespace '||tablespace_name||' offline;' from dba_tablespaces
Where tablespace_name not in ('SYSTEM','OUTLN') and status = 'ONLINE';
