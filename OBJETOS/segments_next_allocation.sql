--Script que retorna os segmentos que n�o poder�o alocar sua
--pr�xima extens�o  RICARDO GUEDES

select s.owner, s.segment_name, s.segment_type, s.tablespace_name, s.next_extent
from dba_segments s
where s.next_extent > 
	  				(select MAX(f.bytes) 
					from dba_free_space f
					where f.tablespace_name = s.tablespace_name) 
					
					
-- rodar um coalesce p/ ver se melhora