SELECT 'DBMS_SNAPSHOT.REFRESH(' || '''' || OWNER || '.' || NAME || '''' || ',' || '''' || 'COMPLETE'|| '''' || ');'
from dba_snapshots
where owner = '<USER>'




