--* File Name    : Open_Cursors.sql
--* Author       : DR Timothy S Hall
--* Description  : Displays a list of all cursors currently open.
--* Requirements : Access to the V$ views.
--* Call Syntax  : @Open_Cursors
--* Last Modified: 15/07/2000
SELECT a.user_name,
       a.sid,
       a.sql_text
FROM   v$open_cursor a
ORDER BY 1,2
/
