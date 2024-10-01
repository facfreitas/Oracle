select OWNER,SEGMENT_NAME,SEGMENT_TYPE,TABLESPACE_NAME,BYTES/1024 KB,BLOCKS,EXTENTS,INITIAL_EXTENT/1024 INITIAL_KB
from dba_segments
where 1 = 1
and owner not in ('SYSTEM','SYS','OUTLN','WMSYS')
--and bytes/1024 between 5000 and 50000 
and segment_type not in ('INDEX PARTITION', 'TABLE PARTITION', 'INDEX','AURORA$JIS$UTILITY$')  
order by extents desc
