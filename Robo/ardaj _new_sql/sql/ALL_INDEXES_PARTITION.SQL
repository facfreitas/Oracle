SELECT ltrim(rtrim(upper('%CUSTOMER_NAME%'))) CUSTOMER_NAME
	   ,ltrim(rtrim('%REGION%')) REGION
	   ,ltrim(rtrim('%HOSTNAME%')) HOSTNAME
	   ,ltrim(rtrim( '%INSTANCENAME%')) INSTANCE_NAME
	,index_owner
	,index_name
	,tablespace_name
	,pct_free
	,ini_trans
	,max_trans
	,initial_extent
	,next_extent
	,max_extent
	,pct_increase
	,num_rows
	,compression
	,logging
	,to_char(last_analyzed ,'dd-mon-yy') last_analyzed 
  FROM dba_ind_partitions
 WHERE index_owner not in ('SYS', 'SYSTEM', 'CTXSYS', 'HR', 'MDSYS', 'ODM','ODM_MTR', 'OE'
		     ,'ORDPLUGINS', 'ORDSYS', 'OUTLN', 'PM'
		     ,'PUBLIC', 'QS','QS_ADM','QS_CBADM'
		     ,'QS_CS','QS_ES','QS_OS','QS_WS','RMAN','SH','WKSYS','WMSYS','XDB'
		     ,'DBSNMP','AURORA$JIS$UTILITY$','OSE$HTTP$ADMIN','AURORA$ORB'		
		     ,'$UNAUTHENTICATED','WFADMIN','OWF_MGR')