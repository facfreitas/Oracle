select decode(object_type,
                'TABLE', 
                    'grant select,insert,update,delete on '||owner||'.'||object_name||' to F_APP_RONDA;',
                'VIEW', 
                    'grant select on '||owner||'.'||object_name||' to F_APP_RONDA;')
from dba_objects
where 1 = 1
AND  owner in ('VETORH_D','TELEMAT')
and object_type in ('TABLE','VIEW')

select decode(object_type,
                'TABLE', 
                    'grant select,insert,update,delete on '||owner||'.'||object_name||' to F_APP_RONDA',
                'PROCEDURE', 
                    'grant execute on '||owner||'.'||object_name||' to F_APP_RONDA',
                'PACKAGE', 
                    'grant execute on '||owner||'.'||object_name||' to F_APP_RONDA',
                'VIEW', 
                    'grant select on '||owner||'.'||object_name||' to F_APP_RONDA',
                'FUNCTION', 
                    'grant execute on '||owner||'.'||object_name||' to F_APP_RONDA')
from dba_objects
where 1 = 1
AND  owner in ('VETORH_D','TELEMAT')
and object_type in ('TABLE','PROCEDURE','PACKAGE','TRIGGER','VIEW','FUNCTION')