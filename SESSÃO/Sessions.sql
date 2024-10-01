--* File Name    : Sessions.sql
--* Author       : DR Timothy S Hall
--* Description  : Displays information on all database sessions.
--* Requirements : Access to the V$ views.
--* Call Syntax  : @Sessions
--* Last Modified: 15/07/2000
SET LINESIZE 500
SET PAGESIZE 1000
SET FEEDBACK OFF

SELECT Substr(a.username,1,15) "Username",
       a.osuser "OS User",
       a.sid "Session ID",
       a.serial# "Serial No",
       d.spid "Process ID",
       a.lockwait "LockWait",
       a.status "Status",
       Trunc(b.value/1024) "PGA (Kb)",
       Trunc(e.value/1024) "UGA (Kb)",
       a.module "Module",
       Substr(a.machine,1,15) "Machine",
       a.program "Program",
       Substr(To_Char(a.logon_Time,'DD-Mon-YYYY HH24:MI:SS'),1,20) "Time"
FROM   v$session a,
       v$sesstat b,
       v$statname c,
       v$process d,
       v$sesstat e,
       v$statname f
WHERE  a.paddr      = d.addr
AND    a.sid        = b.sid
AND    b.statistic# = c.statistic#
AND    c.name       = 'session pga memory'
AND    a.sid        = e.sid
AND    e.statistic# = f.statistic#
AND    f.name       = 'session uga memory'
ORDER BY 1,2;

SET PAGESIZE 14
SET FEEDBACK ON

