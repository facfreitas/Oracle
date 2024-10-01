select *
from dba_users
where account_status = 'OPEN'
and username not in ('SYSTEM','SYS','DBSNMP','TOAD','ORDS_PUBLIC_USER','OE','HR')
and username not like 'APEX%' 
and username not like 'F_%'
order by username

SELECT LISTAGG(username, ',') WITHIN GROUP (ORDER BY username) AS resultado_concatenado
FROM dba_users

SELECT LISTAGG(username, ''',') WITHIN GROUP (ORDER BY username) AS resultado_concatenado
from dba_users
where account_status = 'OPEN'
and username not in ('SYSTEM','SYS','DBSNMP','TOAD','ORDS_PUBLIC_USER','OE','HR')
and username not like 'APEX%' 
and username not like 'F_%'
order by username