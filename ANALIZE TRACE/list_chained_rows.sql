-- Script p/ listagem da linhas migradas das tabelas
-- deve-se primeiro criar a tabela chained_rows_sysdesign 

/*
create table CHAINED_ROWS (
  owner_name         varchar2(30),
  table_name         varchar2(30),
  cluster_name       varchar2(30),
  partition_name     varchar2(30),
  subpartition_name  varchar2(30),
  head_rowid         rowid,
  analyze_timestamp  date
);

*/


Declare 

V_CURSOR NUMBER;
V_RETURN NUMBER;
V_SQL    varchar2(100);
r		 number(5);

Cursor c_lista_tables is
  Select owner, table_name
  from dba_tables
  where owner not in ('SYS','SYSTEM','OUTLN','TESTE_MDB');

BEGIN
  r := 1;
 For r_lista_tables in c_lista_tables loop
 
 v_sql := 'ANALYZE TABLE '||r_lista_tables.owner||'.'||r_lista_tables.table_name||' LIST CHAINED ROWS';
 --dbms_output.put_line(v_sql);
-- insert into teste values (r, v_sql);
-- r := r + 1;
 V_CURSOR:=DBMS_SQL.OPEN_CURSOR;
 DBMS_SQL.PARSE(V_CURSOR,V_SQL,DBMS_SQL.NATIVE);
 V_RETURN := DBMS_SQL.EXECUTE(V_CURSOR);
 DBMS_SQL.CLOSE_CURSOR(V_CURSOR);
 
 end loop;
END;

  
  
  /*
  select t.owner_name, t.table_name, tt.num_rows, tt.last_analyzed, count(t.table_name) 
from chained_rows t, dba_tables tt
where t.owner_name = tt.owner
and t.table_name = tt.table_name
group by t.owner_name, t.table_name, tt.num_rows, tt.last_analyzed

*/