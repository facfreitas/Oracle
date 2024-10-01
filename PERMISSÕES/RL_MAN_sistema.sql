select decode(object_type,
                'TABLE', 
                    'grant select,INSERT,UPDATE,DELETE,REFERENCES on '||owner||'.'||object_name||' to RL_MAN_TELEMAT;',
                'PROCEDURE', 
                    'grant execute on '||owner||'.'||object_name||' to RL_MAN_TELEMAT;',
                'PACKAGE', 
                    'grant execute on '||owner||'.'||object_name||' to RL_MAN_TELEMAT;',
                'PACKAGE BODY', 
                    'grant execute on '||owner||'.'||object_name||' to RL_MAN_TELEMAT;',
                'SEQUENCE', 
                    'grant select on '||owner||'.'||object_name||' to RL_MAN_TELEMAT;',                                        
                'VIEW', 
                    'grant select on '||owner||'.'||object_name||' to RL_MAN_TELEMAT;',
                'FUNCTION', 
                    'grant execute on '||owner||'.'||object_name||' to RL_MAN_TELEMAT;')
from dba_objects
where 1 = 1
AND  owner = 'TELEMAT'