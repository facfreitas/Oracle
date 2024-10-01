BEGIN
DBMS_NETWORK_ACL_ADMIN.ADD_PRIVILEGE(acl => 'power_users.xml',
principal => 'GOLIATH',
is_grant => true,
privilege => 'connect');
END;
