select 'EXECUTE dbms_refresh.refresh('''||'"'||owner||'"."'||object_name||'"'');' 
from dba_objects
where object_type like '%MATERIALIZED%'