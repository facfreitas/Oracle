select owner ow,sum(decode(object_type,'TABLE',1,0)) "TABLE" ,
	   sum(decode(object_type,'INDEX',1,0)) "INDEX" ,sum(decode(object_type,'SYNONYM',1,0)) "SYNONYM" ,
	   sum(decode(object_type,'SEQUENCE',1,0)) "SEQUENCE" , sum(decode(object_type,'VIEW',1,0)) "VIEW" ,
	   sum(decode(object_type,'CLUSTER',1,0)) "CLUSTER"  , sum(decode(object_type,'PROCEDURE',1,0)) "PROCEDURE",
  	   sum(decode(object_type,'FUNCTION',1,0)) "FUNCTION"  , sum(decode(object_type,'DATABASE LINK',1,0)) "DBLINK" 
from dba_objects
group by owner  