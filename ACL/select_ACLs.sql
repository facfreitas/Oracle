select acl , host , lower_port , upper_port from DBA_NETWORK_ACLS;

select acl , principal , privilege , is_grant from DBA_NETWORK_ACL_PRIVILEGES;