SELECT ltrim(rtrim(upper('%CUSTOMER_NAME%'))) CUSTOMER_NAME
	   ,ltrim(rtrim('%REGION%')) REGION
	   ,ltrim(rtrim('%HOSTNAME%')) HOSTNAME
	   ,ltrim(rtrim( '%INSTANCENAME%')) INSTANCE_NAME
	,d.tablespace_name
	,d.status
	,d.contents PTYPE
	,d.extent_management EXTENT_MGMT
	,round(NVL(sum(df.bytes) / 1024 / 1024, 0),2) SIZE_MB
	,round(NVL(sum(df.bytes) - NVL(sum(f.bytes), 0), 0)/1024/1024,0) USED_MB
	,round(NVL((sum(df.bytes) - NVL(sum(f.bytes), 0)) / sum(df.bytes) * 100, 0),0) USED_PERCENT
	,d.initial_extent
	,NVL(d.next_extent, 0) NEXT_EXTENT
	,round(NVL(max(f.bytes) / 1024 / 1024, 0),0) LARGEST_FREE 
  FROM dba_tablespaces d
	,dba_data_files df
	,dba_free_space f 
 WHERE d.tablespace_name = df.tablespace_name  
   AND df.tablespace_name = f.tablespace_name  (+) 
   AND df.file_id  = f.file_id  (+) 
 GROUP BY d.tablespace_name, d.status, d.contents, d.extent_management
	  ,d.initial_extent, d.next_extent
 ORDER BY 1,2,3
