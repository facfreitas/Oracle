-- Lista as tablespaces + Total + Free + Ocupado + Maior extent Disponível
select free.tablespace_name, total "Total", round(free,2) "Free", round((total-free),2) "Ocupado", Max.Max "Maior Extent" 
from 
	 (select tablespace_name,sum(bytes)/1024/1024 free from dba_free_space group by tablespace_name) free,
	 (select tablespace_name, sum(bytes)/1024/1024 total from dba_data_files group by tablespace_name) total,
	 (select tablespace_name, round(max(bytes)/1024/1024,2)||' Mb' Max from dba_extents group by tablespace_name) max
where free.tablespace_name = total.tablespace_name
   and free.tablespace_name = max.tablespace_name	 

   
-- Lista os objetos que terão chance de estouro nas tablespaces (PCT_INCREASE >0) 
select ds.owner,ds.segment_name,ds.segment_type,ds.tablespace_name,ds.next_extent,ds.pct_increase,max.max from dba_segments ds,
(select tablespace_name, max(bytes) max from dba_extents group by tablespace_name) max
where 1.5*ds.next_extent > =  max.max
and ds.tablespace_name = max.tablespace_name
and owner not in ('SYS','CTXSYS') 
and pct_increase > 0

-- Lista os objetos que terão chance de estouro nas tablespaces (PCT_INCREASE >0) 
select ds.owner,ds.segment_name,ds.segment_type,ds.tablespace_name,ds.next_extent,ds.pct_increase,max.max from dba_segments ds,
(select tablespace_name, max(bytes) max from dba_extents group by tablespace_name) max
where ds.next_extent > =  max.max
and ds.tablespace_name = max.tablespace_name
and owner not in ('SYS','CTXSYS') 
and pct_increase = 0

