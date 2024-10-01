BEGIN
-- Only uncomment the following line if ACL "network_services.xml" hasalready been created
--DBMS_NETWORK_ACL_ADMIN.DROP_ACL('network_services.xml');

DBMS_NETWORK_ACL_ADMIN.CREATE_ACL(
acl => 'power_users.xml',
description => 'POWER ACL',
principal => 'APEX_PUBLIC_USER',
is_grant => true,
privilege => 'connect');

DBMS_NETWORK_ACL_ADMIN.ADD_PRIVILEGE(
acl => 'power_users.xml',
principal => 'EEP_TEST',
is_grant => true,
privilege => 'connect');

-- Assign an ACL to a Network

DBMS_NETWORK_ACL_ADMIN.ASSIGN_ACL(
acl => 'power_users.xml',
host => '*');
COMMIT;
END;
/

-- DROP ACL
begin
  dbms_network_acl_admin.drop_acl(
    'local-access-users.xml'
  );
end;

-- DELETE_PRIVILEGE

BEGIN
  DBMS_NETWORK_ACL_ADMIN.delete_privilege ( 
    acl         => 'local-access-users.xml', 
    principal   => 'EEP_TEST',
    is_grant    => FALSE, 
    privilege   => 'resolve');
commit;    
END;
/

-- SELECT
SELECT DECODE(
         DBMS_NETWORK_ACL_ADMIN.check_privilege('NETWORK_ACL_4700D2108291557EE05387E5E50A8899', 'GOLIATH', 'connect'),
         1, 'GRANTED', 0, 'DENIED', NULL) privilege 
FROM dual;
