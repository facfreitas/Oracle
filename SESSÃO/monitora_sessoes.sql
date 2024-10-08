/* Checa usuarios ativos */
SELECT SID, SERIAL#, STATUS, USERNAME, TERMINAL, PROGRAM   FROM V$SESSION
WHERE STATUS = 'ACTIVE' AND SERIAL# > 1

/* Objeto Locado */
SELECT A.SESSION_ID, B.OWNER, B.OBJECT_NAME, B.OBJECT_TYPE,
       A.ORACLE_USERNAME, A.OS_USER_NAME
FROM   V$LOCKED_OBJECT A, ALL_OBJECTS B
WHERE  A.OBJECT_ID = B.OBJECT_ID

ALTER SYSTEM KILL SESSION '32,30949'

/* Execute como SYS*/
SELECT KSPPINM FROM X$KSPPI WHERE SUBSTR(KSPPINM, 1, 1) = '_' ORDER BY 1
