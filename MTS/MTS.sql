-- Conex�es via MTS
SELECT D.NETWORK, D.NAME, S.USERNAME, S.SID, S.SERIAL#, P.USERNAME OS_USER, P.TERMINAL, S.PROGRAM
FROM V$DISPATCHER D, V$CIRCUIT C, V$SESSION S, V$PROCESS P
WHERE D.PADDR = C.DISPATCHER(+)
AND   C.SADDR = S.SADDR(+)
AND   S.PADDR = P.ADDR(+)
ORDER BY D.NETWORK, D.NAME, S.USERNAME;

-- Conex�es por Dispatcher
SELECT DISPATCHER, COUNT(*) FROM V$CIRCUIT GROUP BY DISPATCHER;

SELECT * FROM V$DISPATCHER;

-- Outras Querys
SELECT * FROM V$MTS;
SELECT * FROM V$SHARED_SERVER;
SELECT * FROM V$QUEUE;
