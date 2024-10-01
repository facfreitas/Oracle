select OWNER,COUNT(*)
from dba_objects
where created >= to_date('23/02/2005 01:10:00','dd/mm/yyyy hh24:mi:ss')
GROUP BY OWNER 