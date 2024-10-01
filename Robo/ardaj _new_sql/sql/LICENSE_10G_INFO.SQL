SELECT ltrim(rtrim(upper('%CUSTOMER_NAME%'))) CUSTOMER_NAME
	   ,ltrim(rtrim('%REGION%')) REGION
	   ,ltrim(rtrim('%HOSTNAME%')) HOSTNAME
	   ,ltrim(rtrim( '%INSTANCENAME%')) INSTANCE_NAME
	   ,cpu_socket_count_current
	   ,cpu_socket_count_highwater
	   ,cpu_core_count_current
	   ,cpu_core_count_highwater
	   ,cpu_count_current
  FROM v$license