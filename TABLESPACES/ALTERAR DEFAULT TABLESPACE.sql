SELECT 'ALTER USER ' || USERNAME || ' DEFAULT TABLESPACE <NOME TS>;'
FROM DBA_USERS
WHERE DEFAULT_TABLESPACE NOT IN ('SYSTEM','TOOLS','USERS')
ORDER BY 1
