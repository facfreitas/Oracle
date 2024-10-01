--* File Name    : Locked_Objects.sql
--* Author       : DR Timothy S Hall
--* Description  : Lists all locked objects.
--* Requirements : Access to the V$ views.
--* Call Syntax  : @Locked_Objects
--* Last Modified: 15/07/2000
SET LINESIZE 500
SET PAGESIZE 1000
SET VERIFY OFF

SELECT a.object_name,
       a.owner object_owner,
       Decode(b.locked_mode, 0, 'None',
                             1, 'Null (NULL)',
                             2, 'Row-S (SS)',
                             3, 'Row-X (SX)',
                             4, 'Share (S)',
                             5, 'S/Row-X (SSX)',
                             6, 'Exclusive (X)',
                             b.locked_mode) locked_mode,
       b.session_id sid,
       b.oracle_username,
       b.os_user_name
FROM   all_objects a,
       v$locked_object b
WHERE  a.object_id = b.object_id
ORDER BY 1;

SET PAGESIZE 14
SET VERIFY ON

