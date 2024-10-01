SELECT   username, server, SUM (VALUE), NAME
    FROM v$sesstat s, v$statname n, v$session
   WHERE s.statistic# = n.statistic#
     AND v$session.SID = s.SID
     AND NAME LIKE '%memory'
     AND VALUE > 0
GROUP BY username, server, NAME