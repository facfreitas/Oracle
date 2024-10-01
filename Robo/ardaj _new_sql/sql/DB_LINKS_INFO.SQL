SELECT ltrim(rtrim(upper('%CUSTOMER_NAME%'))) CUSTOMER_NAME
	   ,ltrim(rtrim('%REGION%')) REGION
	   ,ltrim(rtrim('%HOSTNAME%')) HOSTNAME
	   ,ltrim(rtrim( '%INSTANCENAME%')) INSTANCE_NAME
	,owner
	,db_link
	,username
	,host
	,to_char(created,'dd-mon-yy') created 
  FROM dba_db_links
