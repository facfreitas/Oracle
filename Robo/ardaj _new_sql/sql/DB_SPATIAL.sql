SELECT ltrim(rtrim(upper('%CUSTOMER_NAME%'))) CUSTOMER_NAME
	   ,ltrim(rtrim('%REGION%')) REGION
	   ,ltrim(rtrim('%HOSTNAME%')) HOSTNAME
	   ,ltrim(rtrim( '%INSTANCENAME%')) INSTANCE_NAME
     ,decode(count(*), 0, 'No', 'Yes') Spatial
from ( select 1
       from all_sdo_geom_metadata 
       where rownum = 1 )