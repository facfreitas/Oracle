SELECT ltrim(rtrim(upper('%CUSTOMER_NAME%'))) CUSTOMER_NAME
	   ,ltrim(rtrim('%REGION%')) REGION
	   ,ltrim(rtrim('%HOSTNAME%')) HOSTNAME
	   ,ltrim(rtrim( '%INSTANCENAME%')) INSTANCE_NAME
	,substr(name,0,512) name
	,NVL(SUBSTR(value,0,512) , 'null value') value 
  FROM  v$parameter
