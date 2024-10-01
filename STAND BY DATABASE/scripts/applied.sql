select sequence#, applied
from v$archived_log
where applied = 'NO'
order by sequence#;