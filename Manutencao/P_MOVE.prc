CREATE OR REPLACE PROCEDURE SYS.P_move IS

CURSOR C_DATA IS SELECT USERNAME
			     FROM sys.dba_users
 				 WHERE username not in ('SYS', 'SYSTEM')
 				 AND DEFAULT_TABLESPACE = 'SYSTEM';

BEGIN
FOR I IN C_DATA LOOP
 	 EXECUTE IMMEDIATE  'ALTER USER '||I.USERNAME|| ' DEFAULT TABLESPACE USERS;' ;
END LOOP;
EXCEPTION
WHEN OTHERS THEN
RAISE;
END;
/

