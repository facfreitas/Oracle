SELECT ltrim(rtrim(upper('%CUSTOMER_NAME%'))) CUSTOMER_NAME
	   ,ltrim(rtrim('%REGION%')) REGION
	   ,ltrim(rtrim('%HOSTNAME%')) HOSTNAME
	   ,ltrim(rtrim( '%INSTANCENAME%')) INSTANCE_NAME
	,owner
	,synonym_name
	,table_owner
	,table_name
	,db_link 
  FROM dba_synonyms 
 WHERE owner = 'PUBLIC' 
   AND table_owner not in ( 'SYS', 'SYSTEM', 'CTXSYS', 'HR', 'MDSYS', 'ODM','ODM_MTR', 'OE'
			   ,'ORDPLUGINS', 'ORDSYS', 'OUTLN','PM', 'QS','QS_ADM','QS_CBADM'
			   ,'QS_CS','QS_ES','QS_OS','QS_WS','RMAN','SH','WKSYS','WMSYS'
			   ,'XDB','DBSNMP','AURORA$JIS$UTILITY$','OSE$HTTP$ADMIN','AURORA$ORB'
			   ,'$UNAUTHENTICATED','WFADMIN','OWF_MGR')
