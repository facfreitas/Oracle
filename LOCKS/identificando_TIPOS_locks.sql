Select distinct s.sid,s.serial#,
s.username,
s.status,
s.osuser,
p.spid "OS Pid",
o.object_name,
decode(l.locked_mode,
0, 'None',
1, 'Null',
2, 'Row-S',
3, 'Row-X',
4, 'Share',
5, 'S/Row-X',
6, 'Exclusive',
to_char(l.locked_mode)) "LockMode",
s.lockwait,
s.program,s.taddr
from dba_objects o ,
v$locked_object l,
v$session s,
v$process p,
v$sqltext t
where l.object_id=o.object_id
and l.session_id = s.sid
and s.paddr = p.addr
and t.address = s.sql_address
and t.hash_value = s.sql_hash_value
order by sid,serial#;