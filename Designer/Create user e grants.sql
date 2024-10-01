create user des6i identified by des6i
default tablespace TSDES
temporary tablespace temp;

grant connect, resource to des6i;

grant create public synonym to des6i

grant execute on sys.dbms_rls to des6i

grant select on sys.v_$parameter to des6i

grant execute on sys.dbms_lock to des6i

grant execute on sys.dbms_pipe to des6i