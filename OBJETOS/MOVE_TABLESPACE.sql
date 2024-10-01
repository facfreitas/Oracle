select decode(segment_type,
                'INDEX', 
                    'alter index '||owner||'.'||segment_name||
                    ' rebuild tablespace TS_EINDEX;',
                'TABLE', 
                    'alter table '||owner||'.'||segment_name||
                    ' move tablespace TS_EDADOS;'
)
from dba_segments
where owner like 'SAP_%'
AND OWNER <> 'EXFSYS'
and tablespace_name not in ('TS_EDADOS', 'TS_EINDEX');