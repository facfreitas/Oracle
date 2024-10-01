select v.name "TableSpace", t.name "Arquivo",
       trunc(t.bytes/1024/1024,2) "Tamanho", trunc(sum(x.bytes)/1024/1024,2) "Ocupado",
       trunc((t.bytes-sum(x.bytes))/t.bytes*100,2) "Percentual Livre"
from v$datafile t, v$tablespace v, dba_segments x
where v.name in (select name from v$tablespace)
and t.ts# = v.ts#
and x.tablespace_name = v.name
group by v.name, t.name, t.bytes
order by "Percentual Livre"
