begin 
  for i in (select 'CREATE SYNONYM "everton.buzu".'||object_name||' FOR '||owner||'.'||object_name stm
              from all_objects 
             where object_type in ('VIEW', 'TABLE')
              and owner = 'EPCCQ') loop
    begin
      execute immediate i.stm;
    --exception    when others then null;
    end;              
  end loop;
end;
