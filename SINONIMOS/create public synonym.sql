select 'create public synonym '||SYNONYM_name||' for '||TABLE_OWNER||'.'||TABLE_name||';'
from dba_synonyms
where table_owner not in ('SYS','SYSTEM','WMSYS','AURORA$JIS$UTILITY$')
AND OWNER = 'PUBLIC'
ORDER BY TABLE_OWNER