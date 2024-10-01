select *
from dba_objects
where status <> 'VALID'
/


select 'alter ' ||object_type||' '|| OWNER || '.' ||object_name||' compile;'
from DBA_objects
where status = 'INVALID'
and object_type <> 'PACKAGE BODY'
/

select 'alter PACKAGE '|| OWNER || '.' || object_name||' compile BODY;'
from DBA_objects
where status = 'INVALID'
and object_type = 'PACKAGE BODY'
/