SELECT * FROM DBA_SYS_PRIVS
WHERE  GRANTEE = '&USUARIO'

SELECT * FROM DBA_ROLE_PRIVS
WHERE  GRANTEE = '&USUARIO'

SELECT * FROM DBA_ROLES

SELECT GRANTOR      "Cededor do Acesso",
       TABLE_SCHEMA "Proprietário",
       TABLE_NAME   "Tabela",
       GRANTEE      "Cede Acesso para",
       PRIVILEGE    "Privilégio",
       GRANTABLE    "Transf?"
FROM ALL_TAB_PRIVS
ORDER BY 1,2,3
