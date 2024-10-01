/* Formatted on 21/03/2022 16:17:34 (QP5 v5.269.14213.34769) */
ALTER SESSION SET SQL_TRACE = TRUE;

BEGIN
   FOR i IN (SELECT sid, serial#
               FROM v$session
              WHERE username = 'LF')
   LOOP
      DBMS_MONITOR.session_trace_enable (i.sid, i.serial#);
   END LOOP;
END;
/

--ALTER SESSION SET SQL_TRACE = FALSE;
--SELECT VALUE FROM V$DIAG_INFO WHERE NAME = 'Default Trace File';