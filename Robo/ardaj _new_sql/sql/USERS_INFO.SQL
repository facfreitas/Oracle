SELECT ltrim(rtrim(upper('%CUSTOMER_NAME%'))) CUSTOMER_NAME
	   ,ltrim(rtrim('%REGION%')) REGION
	   ,ltrim(rtrim('%HOSTNAME%')) HOSTNAME
	   ,ltrim(rtrim( '%INSTANCENAME%')) INSTANCE_NAME
	,username
	,u.password
	,account_status
	,to_char(lock_date,'dd-mon-yy') lock_date
	,default_tablespace
	,temporary_tablespace
	,to_char(created,'dd-mon-yy') created
	,profile 
  FROM  dba_users usr
	,sys.user$ u 
 WHERE usr.username = u.name
