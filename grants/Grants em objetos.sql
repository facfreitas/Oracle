select decode(object_type,
                'TABLE', 
                    'GRANT SELECT, INSERT, UPDATE, DELETE ON '||object_NAME||' TO TCA_USR;',
                'SEQUENCE', 
                    'GRANT SELECT ON '||object_NAME||' TO TCA_USR;',
		'FUNCTION', 
                    'GRANT EXECUTE ON '||object_NAME||' TO TCA_USR;',
		'PROCEDURE', 
                    'GRANT EXECUTE ON '||object_NAME||' TO TCA_USR;',
		'PACKAGE', 
                    'GRANT EXECUTE ON '||object_NAME||' TO TCA_USR;')
from dba_objects
where 1 = 1
and owner = 'TCA'
and object_type in ('TABLE','SEQUENCE','FUNCTION','PROCEDURE','PACKAGE')

-------------------------------------------------------------------------------------------

select decode(object_type,
                'TABLE', 
                    'GRANT SELECT, INSERT, UPDATE, DELETE ON '||OWNER||'.'||object_NAME||' TO RLNFSEDESENVOLVEDOR;',
                'SEQUENCE', 
                    'GRANT SELECT ON '||OWNER||'.'||object_NAME||' TO RLNFSEDESENVOLVEDOR;',
        'FUNCTION', 
                    'GRANT EXECUTE ON '||OWNER||'.'||object_NAME||' TO RLNFSEDESENVOLVEDOR;',
        'PROCEDURE', 
                    'GRANT EXECUTE ON '||OWNER||'.'||object_NAME||' TO RLNFSEDESENVOLVEDOR;',
        'PACKAGE', 
                    'GRANT EXECUTE ON '||OWNER||'.'||object_NAME||' TO RLNFSEDESENVOLVEDOR;')
from dba_objects
where 1 = 1
and owner = 'DBANFSE'
and object_type in ('TABLE','SEQUENCE','FUNCTION','PROCEDURE','PACKAGE')
