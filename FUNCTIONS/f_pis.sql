 create or replace function f_pis (dado in number)
 return varchar2 is
 wsoma   integer;
 Wm11    integer;
 Wdv     integer;
 wdigito integer;
 i       integer :=0;
begin
     wdv := substr(Dado,11,1);
     wsoma := 0;
     wm11 := 2;
 while i <  10 loop
       i:=i+1;
       wsoma := wsoma + (wm11 * substr(Dado,11 - I, 1));
      if wm11 < 9 then
          wm11 := wm11+1;
      else
          wm11 := 2;
      end if;
           wdigito := 11 - (wsoma MOD 11);
      if wdigito > 9 then
         wdigito := 0;
      end if;
 end loop;
      if wdv = wdigito then
         return('TRUE');
      else
         return('FALSE');
      end if;
end f_PIS;

/* para testar: 
      select f_pis(12131780311) from dual */

-- Dori� 10/2001 dsoutto@enetec.com.br 
/
