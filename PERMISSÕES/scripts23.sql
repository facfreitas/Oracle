SELECT * FROM DBA_SYS_PRIVS
WHERE  GRANTEE = '&USUARIO'

SELECT * FROM DBA_ROLE_PRIVS
WHERE  GRANTEE = '&USUARIO'

SELECT * FROM DBA_ROLES

SELECT GRANTOR      "Cededor do Acesso",
       TABLE_SCHEMA "Propriet�rio",
       TABLE_NAME   "Tabela",
       GRANTEE      "Cede Acesso para",
       PRIVILEGE    "Privil�gio",
       GRANTABLE    "Transf?"
FROM ALL_TAB_PRIVS
ORDER BY 1,2,3
