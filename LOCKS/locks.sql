-- Run the "wait.sql" script and determine who is waiting for 
-- which holding process.

-- Run the "whatsql.sql" script to determine which SQL is being run
-- by the holding process.



-- Wait

SELECT substr(s1.username,1,12)    "WAITING User",
       substr(s1.osuser,1,8)            "OS User",
       substr(to_char(w.session_id),1,5)    "Sid",
       P1.spid                              "PID",
       substr(s2.username,1,12)    "HOLDING User",
       substr(s2.osuser,1,8)            "OS User",
       substr(to_char(h.session_id),1,5)    "Sid",
       P2.spid                              "PID"
FROM   sys.v_$process P1,   sys.v_$process P2,
       sys.v_$session S1,   sys.v_$session S2,
       dba_locks w,     dba_locks h
WHERE
  (((h.mode_held != 'None') and (h.mode_held != 'Null')
     and ((h.mode_requested = 'None') or (h.mode_requested = 'Null')))
   and  (((w.mode_held = 'None') or (w.mode_held = 'Null'))
     and ((w.mode_requested != 'None') and (w.mode_requested != 'Null'))))
  and  w.lock_type  =  h.lock_type
  and  w.lock_id1  =  h.lock_id1
  and  w.lock_id2        =  h.lock_id2
  and  w.session_id     !=  h.session_id
  and w.session_id       = S1.sid
  and h.session_id       = S2.sid
  AND    S1.paddr           = P1.addr
  AND    S2.paddr           = P2.addr;


-------------------------------------------------------------


-- Whatsql

SELECT /*+ ORDERED */
       s.sid, s.username, s.osuser, 
       nvl(s.machine, '?') machine, 
       nvl(s.program, '?') program,
       s.process F_Ground, p.spid B_Ground, 
       X.sql_text
FROM   sys.v_$session S,
       sys.v_$process P, 
       sys.v_$sqlarea X
WHERE  s.osuser      like lower(nvl('&OS_User','%'))
AND    s.username    like upper(nvl('&Oracle_User','%'))
AND    s.sid         like nvl('&SID','%')
AND    s.paddr          = p.addr 
AND    s.type          != 'BACKGROUND' 
AND    s.sql_address    = x.address
AND    s.sql_hash_value = x.hash_value
ORDER
    BY S.sid;

