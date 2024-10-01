SELECT ltrim(rtrim(upper('%CUSTOMER_NAME%'))) CUSTOMER_NAME
	   ,ltrim(rtrim('%REGION%')) REGION
	   ,ltrim(rtrim('%HOSTNAME%')) HOSTNAME
	   ,ltrim(rtrim( '%INSTANCENAME%')) INSTANCE_NAME
	,grantee
	,granted_role
	,admin_option
	,default_role 
  FROM dba_role_privs
