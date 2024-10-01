select decode(segment_type,
                'INDEX', 
                    'alter index '||owner||'.'||segment_name||
                    ' rebuild tablespace xxxx storage (initial '||bytes/1024||
                    'k next <ts uniformsize> pctincrease 0);',
                'INDEX PARTITION', 
                    'alter index '||owner||'.'||segment_name||
                    ' partition '||partition_name||
                    ' rebuild tablespace xxxx storage (initial '||bytes/1024||
                    'k next <ts uniformsize> pctincrease 0);',
                'TABLE', 
                    'alter table '||owner||'.'||segment_name||
                    ' move tablespace xxxx storage (initial '||bytes/1024||
                    'k next <ts uniformsize> pctincrease 0);',
                'TABLE PARTITION', 
                    'alter table '||owner||'.'||segment_name||
                    ' partition '||partition_name||
                    ' move tablespace xxxx storage (initial '||bytes/1024||
                    'k next <ts uniformsize> pctincrease 0);')
from dba_segments
where 1 = 1
and owner not in ('SYS','SYSTEM')
and bytes/1024 < 200 -- p/ ts128K
--and 200 < bytes/1024 < 1000 -- p/ ts512K
--and 1000 < bytes/1024 < 5000 -- p/ ts2M
--and 5000 < bytes/1024 < 50000 -- p/ ts10M
--and 50000 < bytes/1024 -- p/ ts100M
order by bytes desc

-------------------------------------------------------------------------------------------

select 'alter table '||owner||'.'||segment_name||
                    ' move tablespace LOGWATCHTS03D storage (initial '||bytes/1024||
                    'k next 10M pctincrease 0);'
from dba_segments
where 1 = 1
and owner = 'LOGWATCH'
and bytes/1024 between 5000 and 50000 
and segment_type not in ('INDEX PARTITION', 'TABLE PARTITION', 'INDEX')  
order by bytes desc

