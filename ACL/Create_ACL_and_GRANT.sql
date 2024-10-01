BEGIN
  DBMS_NETWORK_ACL_ADMIN.CREATE_ACL (
    acl => 'power_users.xml',
    description => 'Network Access Control for EMAIL',
    principal => 'APEX_PUBLIC_USER',
    is_grant => TRUE,
    privilege => 'connect');
END;


BEGIN
DBMS_NETWORK_ACL_ADMIN.ADD_PRIVILEGE(acl => 'power_users.xml',
principal => 'EPCCQ',
is_grant => true,
privilege => 'connect');
END;
