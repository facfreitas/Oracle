SELECT    'ALTER USER '
       || username
       || CHR (10)
       || CHR (09)
       || ' DEFAULT TABLESPACE USERS'
       || CHR (10)
       || CHR (09)
       || 'TEMPORARY TABLESPACE TEMPUSER;'
  FROM dba_users
 WHERE default_tablespace = 'SYSTEM' AND username NOT IN ('SYS', 'SYSTEM')