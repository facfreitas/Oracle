select SUM(BYTES/1024/1024) mB
from dba_segments
where 1 = 1
and owner not in ('SYS','SYSTEM','OUTLN','WMSYS','SPOT')
and bytes/1024 BETWEEN 15360 AND 102400 
order by bytes desc
