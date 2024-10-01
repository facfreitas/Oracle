SELECT ltrim(rtrim(upper('%CUSTOMER_NAME%'))) CUSTOMER_NAME
	   ,ltrim(rtrim('%REGION%')) REGION
	   ,ltrim(rtrim('%HOSTNAME%')) HOSTNAME
	   ,ltrim(rtrim( '%INSTANCENAME%')) INSTANCE_NAME
     ,decode(count(*), 0, 'No', 'Yes') Compression
from ( select 1 
       from dba_tables
       where compression = 'ENABLED'
         and compress_for = 'OLTP'
         and rownum = 1 )