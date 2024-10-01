create or replace procedure kill_locked_usr
(time in integer) as
my_cursor integer;
my_statement varchar2(80);
result integer;
cursor c1 is 
select 'alter system kill session ' ||

||to_char(a.sid)||','||to_char(a.serial#)||


from v$session a, v$lock b
where a.sid = b.sid
and b.lmode = 6 and
a.username like 'THE_BOREING_USER' and
b.ctime > time;
begin
open c1;
loop
fetch c1 into my_statement;
exit when c1%notfound;
my_cursor := dbms_sql.open_cursor;
dbms_sql.parse(my_cursor,my_statement,dbms_sql.v7);
result :=dbms_sql.execute(my_cursor);
dbms_sql.close_cursor(my_cursor);
end loop;
close c1;
end;
/

-- then, you must submit the job 
VARIABLE JOBNO NUMBER;
EXECUTE DBMS_JOB.SUBMIT(:JOBNO,'KILL_LOCKED_USR(90);',SYSDATE,'SYSDATE+((1/86400)*30)',NULL);
COMMIT;
-- in this case, if the user has a 90 seconds row
-- exclusive lock, will be killed
