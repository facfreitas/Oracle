begin
dbms_network_acl_admin.create_acl (
acl => 'grant_acl_envio_email.xml',
description => 'Envio de e-mail pelo Oracle',
principal => 'EEP_DBA', 
is_grant => TRUE,
privilege => 'connect'
);
commit;
end;

--E depois:

begin
dbms_network_acl_admin.assign_acl(
acl => 'grant_acl_envio_email.xml',
host => 'smtp.enseada.com' 
);
commit;