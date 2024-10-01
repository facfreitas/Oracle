rem Generate DDL to drop phantom synonyms in your database.
rem Exludes SYS and SYSTEM users
rem
spool dr_ph_syn.sql
set pages 0 feed off
select 'drop '||decode(owner,'PUBLIC',' public ',null)||' synonym
'||decode(owner,'PUBLIC',null,owner||'.')||synonym_name||';'
from dba_synonyms s where owner not in('SYSTEM','SYS') and db_link is null
and not exists
(select 1 from all_objects o
where object_type in('TABLE','VIEW','SYNONYM',
'SEQUENCE','PROCEDURE',
'PACKAGE','FUNCTION')
and s.table_owner=o.owner
and s.table_name=o.object_name);
spool off
