SELECT ltrim(rtrim(upper('%CUSTOMER_NAME%'))) CUSTOMER_NAME
	   ,ltrim(rtrim('%REGION%')) REGION
	   ,ltrim(rtrim('%HOSTNAME%')) HOSTNAME
	   ,ltrim(rtrim( '%INSTANCENAME%')) INSTANCE_NAME
	,	to_char(sysdate,'DD-MON-YY') COLLECTION_DATE
	,version DATABASE_VERSION
	,archiver archive
	,ltrim(rtrim( '%STATUS%')) STATUS
	from v$instance
