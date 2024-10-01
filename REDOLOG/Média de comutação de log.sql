SELECT b.recid,
       to_char(b.first_time,'dd-mon-yy hh:mi:ss') start_time, a.recid,
       to_char(a.first_time,'dd-mon-yy hh:mi:ss') end_time,
       round(((a.first_time-b.first_time)*24)*60,2) minutes
FROM v$log_history a, v$log_history b
WHERE a.recid = b.recid+1
ORDER BY a.first_time asc 