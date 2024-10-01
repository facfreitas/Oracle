select 'alter table '||table_name||' enable constraint '||constraint_name||';'
from user_constraints
where constraint_type = 'R'

