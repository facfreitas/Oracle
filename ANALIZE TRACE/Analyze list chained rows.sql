select 'ANALYZE TABLE '||OWNER||'.'||TABLE_NAME||' LIST CHAINED ROWS INTO chained_rows;'
from dba_tables
where owner = 'LOGWATCH'