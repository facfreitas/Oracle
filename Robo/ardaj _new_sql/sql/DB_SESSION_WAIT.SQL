SELECT ltrim(rtrim(upper('%CUSTOMER_NAME%'))) CUSTOMER_NAME
	   ,ltrim(rtrim('%REGION%')) REGION
	   ,ltrim(rtrim('%HOSTNAME%')) HOSTNAME
	   ,ltrim(rtrim( '%INSTANCENAME%')) INSTANCE_NAME
	   ,event
	   ,p1text
	   ,p1
	   ,p2text
	   ,p2
	   ,p3text
	   ,p3
	   ,wait_class
	   ,wait_time
	   ,state
  FROM v$session_wait 