CREATE OR REPLACE PROCEDURE kill (
   session_id   IN   VARCHAR2,
   serial_num   IN   VARCHAR2
)
AS
   cur      INTEGER;
   ret      INTEGER;
   STRING   VARCHAR2 (100);
BEGIN
   STRING :=    'alter system kill session '
             || ''''
             || session_id
             || ','
             || serial_num
             || '''';
   cur := DBMS_SQL.open_cursor;
   DBMS_SQL.parse (cur, STRING, DBMS_SQL.NATIVE);
   ret := DBMS_SQL.EXECUTE (cur);
   DBMS_SQL.close_cursor (cur);
EXCEPTION
   WHEN OTHERS
   THEN
      raise_application_error (-20001, 'Error in execution', TRUE);

      IF DBMS_SQL.is_open (cur)
      THEN
         DBMS_SQL.close_cursor (cur);
      END IF;
END;
/
