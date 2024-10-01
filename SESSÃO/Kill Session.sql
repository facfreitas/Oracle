select 'alter system kill session '''||sid||','||serial#||''';'
from v$session
where program = 'dllhost.exe'

select *
from v$session
where program = 'dllhost.exe'

select 'orakill clbp'||pid
from v$process
where addr in
(select paddr
from v$session
where username is not null
and username != 'SYSTEM' )

alter system kill session '46,4308';