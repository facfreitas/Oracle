DECLARE
  X NUMBER;
BEGIN
  SYS.DBMS_JOB.SUBMIT
  ( job       => X 
   ,what      => 'BEGIN
IF (TO_CHAR(SYSDATE, ''D'') IN (''2'',''3'',''4'',''5'',''6'')
AND
(TO_NUMBER(TO_CHAR(SYSDATE,''HH24''))>=8
OR TO_NUMBER(TO_CHAR(SYSDATE,''HH24''))<=18))
THEN
P_Analyze_Table;
END IF;
END;'
   ,next_date => TO_DATE('04/07/2005 10:48:28','dd/mm/yyyy hh24:mi:ss')
   ,INTERVAL  => 'SYSDATE+120/1440 '
   ,no_parse  => FALSE
  );
END;
/



