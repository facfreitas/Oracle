Declare 

Cursor indices is 
-- cursor p/ listar todos os indices das tabelas de um determinado owner
	Select index_name, table_name 
	from dba_indexes
	where owner = 'GIFS';

Cursor indices_colunas is	
	select index_name, table_name, column_name, column_position
	from dba_ind_columns
	where index_owner = 'GIFS'
	and table_name = 'EUL_ACCESS_PRIVS'
	order by index_name, column_position; 

select distinct index_name  
from dba_ind_columns
where index_owner = 'GIFS'
and table_name = 'EUL_ACCESS_PRIVS'
and column_position = (select min(column_position) 
						from dba_ind_columns
						where index_owner = 'GIFS'
						and table_name = 'EUL_ACCESS_PRIVS')
order by index_name, column_position; 

select distinct index_name
from dba_ind_columns
where index_owner = 'GIFS'
and table_name = 'EUL_ACCESS_PRIVS' 
 