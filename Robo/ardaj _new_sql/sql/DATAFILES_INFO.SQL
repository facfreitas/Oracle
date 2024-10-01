SELECT ltrim(rtrim(upper('%CUSTOMER_NAME%'))) CUSTOMER_NAME
	   ,ltrim(rtrim('%REGION%')) REGION
	   ,ltrim(rtrim('%HOSTNAME%')) HOSTNAME
	   ,ltrim(rtrim( '%INSTANCENAME%')) INSTANCE_NAME
	,df.tablespace_name
	,df.file_name FILENAME
	,df.file_id
	,df.status
	,round(NVL(df.bytes / 1024 / 1024, 0),0) SIZE_MB
	,round(NVL(df.bytes - NVL(sum(f.bytes), 0), 0)/1024/1024,0) USED_MB	
	,round(NVL((df.bytes - sum(nvl(f.bytes,0))) / df.bytes * 100, 0),0) USED_PERCENT
  FROM dba_data_files df
       ,dba_free_space f	
 WHERE df.tablespace_name = f.tablespace_name  (+) 
   AND df.file_id   = f.file_id  (+)
 group by df.tablespace_name, df.file_name, df.file_id, df.status, df.bytes 
 order by 1,2,3