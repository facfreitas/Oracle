SELECT OWNER,
	   NAME,
	   referenced_name, 
	   TYPE,
	   referenced_type, 
	   referenced_owner, 
	   referenced_link_name 
  FROM DBA_dependencies
