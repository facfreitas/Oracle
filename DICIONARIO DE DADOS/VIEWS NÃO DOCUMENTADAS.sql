select distinct table_name 
from V$INDEXED_FIXED_COLUMN 
where table_name like 'X$KSPPSV%';

