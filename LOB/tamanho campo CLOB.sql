select sum(bytes)/1024/1024/1024 "Tamanho GB CLOB" 
from dba_segments
where segment_name in (select segment_name
                       from dba_lobs
                       where table_name = 'CSPROCLINHAARQUIVOSRF')