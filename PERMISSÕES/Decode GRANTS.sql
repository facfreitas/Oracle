select decode(object_type,
                'TABLE', 
                    'grant select on '||owner||'.'||object_name||' to RLQUERY_EEP_FINANCE_TCG',
                'PROCEDURE', 
                    'grant execute on '||owner||'.'||object_name||' to RLEXECUTE_EEP_FINANCE_TCG',
                'PACKAGE', 
                    'grant execute on '||owner||'.'||object_name||' to RLEXECUTE_EEP_FINANCE_TCG',
                'VIEW', 
                    'grant select on '||owner||'.'||object_name||' to RLQUERY_EEP_FINANCE_TCG',
                'FUNCTION', 
                    'grant execute on '||owner||'.'||object_name||' to RLEXECUTE_EEP_FINANCE_TCG')
from dba_objects
where 1 = 1
AND  owner = 'EEP_FINANCE_TCG_HML'
and object_type in ('TABLE','PROCEDURE','PACKAGE','TRIGGER','VIEW','FUNCTION')


select decode(object_type,
                'TABLE', 
                    'grant select,INSERT,UPDATE,DELETE on '||owner||'.'||object_name||' to RLMANIPULATE_EEP_FINANCE_TCG;',
                'PROCEDURE', 
                    'grant execute on '||owner||'.'||object_name||' to RLEXECUTE_EEP_FINANCE_TCG;',
                'PACKAGE', 
                    'grant execute on '||owner||'.'||object_name||' to RLEXECUTE_EEP_FINANCE_TCG;',
                'PACKAGE BODY', 
                    'grant execute on '||owner||'.'||object_name||' to RLEXECUTE_EEP_FINANCE_TCG;',
                'SEQUENCE', 
                    'grant select on '||owner||'.'||object_name||' to RLMANIPULATE_EEP_FINANCE_TCG;',                                        
                'VIEW', 
                    'grant select on '||owner||'.'||object_name||' to RLMANIPULATE_EEP_FINANCE_TCG;',
                'FUNCTION', 
                    'grant execute on '||owner||'.'||object_name||' to RLEXECUTE_EEP_FINANCE_TCG;')
from dba_objects
where 1 = 1
AND  owner = 'EEP_FINANCE_TCG_HML'

select *
from dba_objects
where 1 = 1
AND  owner = 'EEP_FINANCE_TCG_HML'