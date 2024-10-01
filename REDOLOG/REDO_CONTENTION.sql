SELECT ln.name, gets, misses, round((misses/gets)*100,3) "RATIO < 1% ", 
                immediate_gets, immediate_misses, 
				round((immediate_misses/decode(immediate_gets,0,1,immediate_gets))*100,3) "RATIO < 1% "
FROM v$latch l, v$latchname ln
WHERE ln.name IN ('redo allocation', 'redo copy')
AND ln.latch# = l.latch#;