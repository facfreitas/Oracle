SELECT ltrim(rtrim(upper('%CUSTOMER_NAME%'))) CUSTOMER_NAME
	   ,ltrim(rtrim('%REGION%')) REGION
	   ,ltrim(rtrim('%HOSTNAME%')) HOSTNAME
	   ,ltrim(rtrim( '%INSTANCENAME%')) INSTANCE_NAME
     ,decode(count(*), 0, 'No', 'Yes') Partitioning
  from ( select 1 
           from dba_part_tables
          where owner not in ('SYSMAN', 'SH', 'SYS', 'SYSTEM')
            and rownum = 1 )