SELECT ltrim(rtrim(upper('%CUSTOMER_NAME%'))) CUSTOMER_NAME
	   ,ltrim(rtrim('%REGION%')) REGION
	   ,ltrim(rtrim('%HOSTNAME%')) HOSTNAME
	   ,ltrim(rtrim( '%INSTANCENAME%')) INSTANCE_NAME
	,owner
	,index_name
	,Index_type
	,table_owner
	,table_name
	,tablespace_name
	,pct_increase
	,pct_free
	,ini_trans
	,max_trans
	,initial_extent
	,next_extent
	,distinct_keys
	,logging
	,num_rows
	,degree
	,partitioned
	,compression
	,to_char(last_analyzed ,'dd-mon-yy') last_analyzed 
  FROM dba_indexes 
 WHERE owner not in ('SYS', 'SYSTEM', 'CTXSYS', 'HR', 'MDSYS', 'ODM','ODM_MTR', 'OE'
		     ,'ORDPLUGINS', 'ORDSYS', 'OUTLN', 'PM'
		     ,'PUBLIC', 'QS','QS_ADM','QS_CBADM'
		     ,'QS_CS','QS_ES','QS_OS','QS_WS','RMAN','SH','WKSYS','WMSYS','XDB'
		     ,'DBSNMP','AURORA$JIS$UTILITY$','OSE$HTTP$ADMIN','AURORA$ORB'		
		     ,'$UNAUTHENTICATED','WFADMIN','OWF_MGR')
