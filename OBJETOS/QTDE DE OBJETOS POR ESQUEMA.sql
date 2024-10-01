select OBJECT_TYPE,count(*) 
from dba_OBJECTS
where owner='GESPLAN'
GROUP BY OBJECT_TYPE