CREATE OR REPLACE PROCEDURE dbainfra.PR_ANALYZE IS

CURSOR C_DATA IS SELECT TABLE_NAME,OWNER
                                                       FROM DBA_TABLES
                                             WHERE OWNER not in ('SYS','SYSTEM','OUTLN','DBSMNP','SPOT','WMSYS');

BEGIN
FOR I IN C_DATA LOOP
      EXECUTE IMMEDIATE  'ANALYZE TABLE '|| I.OWNER ||'.' || I.TABLE_NAME || ' COMPUTE STATISTICS For table for all indexes for all indexed columns';
END LOOP;
EXCEPTION
WHEN OTHERS THEN
     RAISE_APPLICATION_ERROR(-20000,'ERRO NO ANALYZE : ' || SQLERRM);
END;
/
