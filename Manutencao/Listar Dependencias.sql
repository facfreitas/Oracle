SELECT owner,NAME,TYPE,referenced_name
FROM   DBA_dependencies
WHERE referenced_owner = 'STAB'
AND    referenced_name IN ('V_SETORES','CODIGO_SETORES','HISTORICO_SETORES')
ORDER BY 1,3,4,2
