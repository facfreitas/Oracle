CREATE TABLE A ( A NUMBER )

INSERT INTO A VALUES ( 13 )

BEGIN FOR I IN 1..3 LOOP INSERT INTO A SELECT * FROM  A; END LOOP; END;

INSERT INTO A SELECT * FROM  A

SELECT COUNT(*) FROM A
-- Linhas 1.048.576

create table b ( b number )

INSERT INTO b SELECT * FROM  A
--57s

INSERT INTO b nologging SELECT * FROM  A
--49s 

ALTER SESSION ENABLE PARALLEL DML

INSERT /*+ APPEND PARALLEL (b,2) */ INTO b
SELECT * FROM a
--9s

INSERT /*+ APPEND PARALLEL (b,2) */ INTO b nologging
SELECT * FROM a
--8,7s

truncate table b
