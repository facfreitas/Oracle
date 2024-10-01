SELECT ltrim(rtrim(upper('%CUSTOMER_NAME%'))) CUSTOMER_NAME
	   ,ltrim(rtrim('%REGION%')) REGION
	   ,ltrim(rtrim('%HOSTNAME%')) HOSTNAME
	   ,ltrim(rtrim( '%INSTANCENAME%')) INSTANCE_NAME
	,owner
	,object_type
	,count(object_type) object_count 
  FROM dba_objects  
 WHERE owner not in ('SYS', 'SYSTEM', 'CTXSYS', 'HR', 'MDSYS', 'ODM','ODM_MTR', 'OE' 			     ,'ORDPLUGINS', 'ORDSYS', 'OUTLN','PM'
  		     ,'QS','QS_ADM','QS_CBADM','QS_CS','QS_ES','QS_OS','QS_WS'
		     ,'RMAN','SH','WKSYS','WMSYS','XDB', 'DBSNMP','AURORA$JIS$UTILITY$','OSE$HTTP'
		     ,'$ADMIN','AURORA$ORB$UNAUTHENTICATED','WFADMIN','OWF_MGR') 
 GROUP BY owner, object_type
