
SELECT oracle_username, object_name, sid, serial#, sql_address, t1.sql_text
FROM sys.v_$locked_object, all_objects, v$session, v$sqlarea t1
WHERE sys.v_$locked_object.object_id=all_objects.object_id
AND sys.v_$locked_object.oracle_username=v$session.username
and t1.address = sql_address;



