select 'alter system kill session '''||substr(substr(sid,1,4)||','||SERIAL#,1,15)||''';' ABCD,
substr(username,1,8) username,status,osuser,program,machine from v$session
order by username
