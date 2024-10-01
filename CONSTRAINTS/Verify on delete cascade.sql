select  b.owner pri_owner, b.table_name pri_table,
a.owner for_owner, a.table_name for_table
from dba_constraints a, dba_constraints b
where  a.r_constraint_name = b.constraint_name
and    a.constraint_type = 'R'
and    a.delete_rule='CASCADE'
and    b.constraint_type = 'P'
and    a.r_owner=b.owner
and    b.owner not in ('SYS', 'SYSTEM')
and    b.table_name in (select table_name from dba_constraints
where constraint_type='P')
group by b.table_name, b.owner, a.table_name, a.owner
order by pri_owner