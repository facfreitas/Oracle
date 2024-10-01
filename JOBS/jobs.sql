rem #####################################################################
rem 
rem Name:	jobs.sql
rem Author:	Bernard van Aalst
rem Date:	24 Jan 2000
rem Purpose:	Show job parameters and jobs in queue, including SID if
rem             running
rem 
rem #####################################################################

SET NUMW 6 PAGES 25 LIN 80
SET ARRAY 5
COL name FOR A40
COL value FOR A20
PROMPT v$parameter
SELECT name
, value
FROM v$parameter
WHERE name like 'job%';

COL log_user FOR A8 HEA "Username"
COL what FOR A38 HEA "PL/SQL Text"
COL broken FOR A3 HEA "Bro|ken"
COL next HEA "Sec|until|next" 
COL failures HEA "Err|count"
PROMPT Database jobs
SELECT j.job "Job"
, j.broken
, r.sid "Sid"
, j.log_user
, j.what
, j.failures
, (j.next_date - SYSDATE) * 24 * 60 * 60 next
FROM dba_jobs j
, dba_jobs_running r
WHERE j.job = r.job(+)
/

CL COL
SET NUMW 9
