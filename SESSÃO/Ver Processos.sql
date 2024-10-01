select t2.spid, t1.sid, t1.serial#, t1.audsid, t1.username, t1.osuser,
       t1.machine, t1.terminal, t1.program,
       to_char(t1.logon_time, 'day hh24:mi'), t1.status, t1.process
from v$session t1, v$process t2
where t2.addr = t1.paddr
order by spid desc