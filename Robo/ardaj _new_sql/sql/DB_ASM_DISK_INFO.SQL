SELECT 	ltrim(rtrim(upper('%CUSTOMER_NAME%'))) CUSTOMER_NAME
	   	,ltrim(rtrim('%REGION%')) REGION
	   	,ltrim(rtrim('%HOSTNAME%')) HOSTNAME
	   	,ltrim(rtrim( '%INSTANCENAME%')) INSTANCE_NAME
	   	,GROUP_NUMBER
		,DISK_NUMBER        
		,COMPOUND_INDEX     
		,INCARNATION        
		,MOUNT_STATUS       
		,HEADER_STATUS      
		,MODE_STATUS        
		,STATE              
		,REDUNDANCY         
		,LIBRARY            
		,OS_MB              
		,TOTAL_MB           
		,FREE_MB            
		,HOT_USED_MB        
		,COLD_USED_MB       
		,NAME               
		,FAILGROUP          
		,LABEL              
		,PATH               
		,UDID               
		,PRODUCT            
		,to_char(CREATE_DATE,'dd-mon-yy') CREATE_DATE 
		,to_char(MOUNT_DATE,'dd-mon-yy') MOUNT_DATE 
		,REPAIR_TIMER       
		,READS              
		,WRITES             
		,READ_ERRS 		         
		,WRITE_ERRS         
		,READ_TIME          
		,WRITE_TIME         
		,BYTES_READ         
		,BYTES_WRITTEN      
		,PREFERRED_READ     
		,HASH_VALUE         
		,HOT_READS          
		,HOT_WRITES         
		,HOT_BYTES_READ     
		,HOT_BYTES_WRITTEN  
		,COLD_READS         
		,COLD_WRITES        
		,COLD_BYTES_READ    
		,COLD_BYTES_WRITTEN 
		,VOTING_FILE        
		,SECTOR_SIZE        
		,FAILGROUP_TYPE       
FROM v$asm_disk