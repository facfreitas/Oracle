select  t1.owner, t1.table_name, t2.bytes, t2.extents,
        t1.num_rows, t1.tablespace_name, t1.pct_free,
        t1.pct_increase, t1.last_analyzed
from dba_tables t1, dba_segments t2
where t2.owner = t1.owner
and t2.segment_name = t1.table_name
and t2.tablespace_name = t1.tablespace_name
and t2.segment_type = 'TABLE'
and t1.owner not in ('SYS','SYSTEM','AURORA$JIS$UTILITY$','OUTLN',
                    'OSE$HTTP$ADMIN','ORDSYS','MDSYS')
-- condicao p/ so trazer as tabelas com problemas
and
(t2.extents > 50
or t1.pct_increase  > 0
or t1.last_analyzed < (sysdate - 30)
or t1.last_analyzed is null
or t1.tablespace_name = 'SYSTEM')
order by owner, table_name
