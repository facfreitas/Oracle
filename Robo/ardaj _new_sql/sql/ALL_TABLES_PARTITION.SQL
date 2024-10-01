SELECT ltrim(rtrim(upper('%CUSTOMER_NAME%'))) CUSTOMER_NAME
	   ,ltrim(rtrim('%REGION%')) REGION
	   ,ltrim(rtrim('%HOSTNAME%')) HOSTNAME
	   ,ltrim(rtrim( '%INSTANCENAME%')) INSTANCE_NAME
	,table_owner
	,table_name
	,tablespace_name
	,pct_free
	,pct_used
	,ini_trans
	,max_trans
	,initial_extent
	,next_extent
	,num_rows
	,blocks
	,empty_blocks
	,avg_row_len
	,chain_cnt
	,compression
	,to_char(last_analyzed,'dd-mon-yy') last_analyzed 
  FROM dba_tab_partitions
 WHERE table_owner not in ('SYS', 'SYSTEM', 'CTXSYS', 'HR', 'MDSYS', 'ODM','ODM_MTR', 'OE'
		     ,'ORDPLUGINS', 'ORDSYS', 'OUTLN', 'PM'
		     ,'PUBLIC', 'QS','QS_ADM','QS_CBADM'
		     ,'QS_CS','QS_ES','QS_OS','QS_WS','RMAN','SH','WKSYS','WMSYS','XDB'
		     ,'DBSNMP','AURORA$JIS$UTILITY$','OSE$HTTP$ADMIN','AURORA$ORB'		
		     ,'$UNAUTHENTICATED','WFADMIN','OWF_MGR')