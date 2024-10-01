SELECT job, what, last_date, last_sec, next_date, next_sec, failures, broken
FROM   dba_jobs
WHERE  broken = 'Y'
ORDER BY job