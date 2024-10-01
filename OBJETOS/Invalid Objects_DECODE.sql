select decode(object_type,
                'PACKAGE', 
                    'alter ' ||object_type||' '|| OWNER || '.' ||object_name||' compile;',
                'PACKAGE BODY', 
                    'alter PACKAGE '|| OWNER || '.' || object_name||' compile BODY;',
                'VIEW', 
                    'alter ' ||object_type||' '|| OWNER || '.' ||object_name||' compile;',
                'PROCEDURE', 
                    'alter ' ||object_type||' '|| OWNER || '.' ||object_name||' compile;',
                'FUNCTION', 
                    'alter ' ||object_type||' '|| OWNER || '.' ||object_name||' compile;',
                'MATERIALIZED VIEW',   
                    'alter ' ||object_type||' '|| OWNER || '.' ||object_name||' compile;',                
                'TRIGGER', 
                    'alter ' ||object_type||' '|| OWNER || '.' ||object_name||' compile;'
            )
from all_objects
where status <> 'VALID'

