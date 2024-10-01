select * 
from sys.v_$segment_statistics
where owner not in ('SYS','SYSTEM','OUTLN')
order by value desc