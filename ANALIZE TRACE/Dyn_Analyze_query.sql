select 'analyze table '||owner||'."'||table_name||'" compute statistics;'
from dba_tables
where owner = 'SAPSR3';