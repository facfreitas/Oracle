/* Arquivo    : SEGFRAG.SQL                                                */
/* Descricao  : Verifica Segmentos com mais de 5 extensões                 */
/* Modulo     : Performance&Tuning - Monitoracao                           */

def g_Script     = 'segfrag.sql'
def g_Titulo     = 'Segmentos com mais de 5 extensões'
 
start 'rpt_cab.sql'

col c1  format a26
col c2  format a12
col c3  format a12
col c4  format a14
col c5  format 999,999,999
break on c2 on c3

select owner c2,
       tablespace_name c3,
       segment_name||
         decode(segment_type,'TABLE','[T]', 'INDEX', '[I]', 
                           'ROLLBACK','[R]', '[O]') c1
       , sum(bytes) c5, 
   decode(count(*),1,to_char(count(*)),
		   2,to_char(count(*)),
		   3,to_char(count(*)),
		   4,to_char(count(*)),
		   5,to_char(count(*)),
                   to_char(count(*))||' Recriar') c4 
from dba_extents group by owner, tablespace_name,
segment_name|| 
decode(segment_type,'TABLE','[T]', 'INDEX', '[I]', 'ROLLBACK','[R]', '[O]') 
having count(*)> 5;
break on c3
/

undef g_Script
undef g_Titulo
ttitle off
clear column
clear breaks
