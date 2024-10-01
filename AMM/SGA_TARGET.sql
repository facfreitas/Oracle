 select sum(value/1024/1024/1024) GB 
 from v$sga;
 
select name, value, description
from v$parameter
where name in ('sga_target','sga_max_size','memory_target','memory_max_target', 'db_cache_size','shared_pool_size','large_pool_size','java_pool_size','pga_aggregate_target')


alter system set sga_target=40G scope=spfile sid='CRP012'; -- Configurando o ASMM

alter system set pga_aggregate_target=10G scope=spfile sid='CRP012';


alter system set memory_target=0 scope=spfile sid='CRP012'; -- Removendo o AMM
alter system set memory_max_target=0 scope=spfile sid='CRP012'; -- Removendo o AMM