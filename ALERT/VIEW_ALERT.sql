/* Formatted on 16/11/2023 17:18:20 (QP5 v5.269.14213.34769) */
CREATE OR REPLACE FORCE VIEW SYS.VW_ALERT
(
   ORIGINATING_TIMESTAMP,
   MESSAGE_TEXT
)
AS
   SELECT "ORIGINATING_TIMESTAMP", "MESSAGE_TEXT"
     FROM (  SELECT ORIGINATING_TIMESTAMP,
                    SUBSTR (MESSAGE_TEXT, 1, 3000) MESSAGE_TEXT
               FROM X$DBGALERTEXT
              WHERE (   MESSAGE_TEXT LIKE '%ORA-%'
                     OR UPPER (MESSAGE_TEXT) LIKE '%ERROR%')
           --OR UPPER (MESSAGE_TEXT) NOT LIKE '%Tns error struct%')
           ORDER BY ORIGINATING_TIMESTAMP DESC)
    WHERE ROWNUM <= 50;


GRANT SELECT ON SYS.VW_ALERT TO F_GL_DBA;
