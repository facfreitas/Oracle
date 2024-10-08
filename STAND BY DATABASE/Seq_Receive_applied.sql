-- Verify that the last sequence# received and the last sequence# applied to standby 
-- database.
select al.thrd "Thread", almax "Last Seq Received", lhmax "Last Seq Applied"
from (select thread# thrd, max(sequence#) almax
      from v$archived_log
      where resetlogs_change#=(select resetlogs_change# from v$database)
      group by thread#) al,
     (select thread# thrd, max(sequence#) lhmax
      from v$log_history
      where first_time=(select max(first_time) from v$log_history)
      group by thread#) lh
where al.thrd = lh.thrd;