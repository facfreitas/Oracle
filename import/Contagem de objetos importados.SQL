select object_type, count(*)
from dba_objects
where owner = 'SAPSR3'
group by object_type;

select status, count(*)
from dba_constraints
where owner = 'SAPSR3'
group by status;

select count(*)
from dba_tables
where owner = 'SAPSR3'
and last_analyzed is null