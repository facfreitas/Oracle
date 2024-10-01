select default_tablespace, count(username) USERS
from dba_users
where username not in ('PUBLIC','_NEXT_USER')
group by default_tablespace;

select temporary_tablespace, count(username)
from dba_users
where username not in ('PUBLIC','_NEXT_USER')
group by temporary_tablespace;