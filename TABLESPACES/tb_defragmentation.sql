--desfragmentacao das tablespaces
--valores aceitaveis acima de 30 p/ tables e acima de 60 p/ indices
--por Ricardo Guedes
select tablespace_name, sqrt(max(blocks)/sum(blocks))*(100/sqrt(sqrt(count(blocks)))) fsfi
from dba_free_space
group by tablespace_name
order by 1
