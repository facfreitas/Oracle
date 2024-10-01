SELECT distinct ' EXEC DBMS_UTILITY.analyze_schema(' || '''' || OWNER || '''' || ',' || '''' || 'COMPUTE' || '''' ||');'
from dba_objects
where owner not in ('SYS','SYSTEM','SYSDESIGN')