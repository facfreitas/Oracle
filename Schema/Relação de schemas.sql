/* Formatted on 2008/08/04 11:32 (Formatter Plus v4.8.8) */
SELECT DISTINCT (owner)
           FROM dba_objects
          WHERE owner NOT IN
                   ('SYSTEM', 'SYS', 'OUTLN', 'WMSYS', 'PUBLIC',
                    'AURORA$JIS$UTILITY$', 'SPOT', 'XDB', 'OSE$HTTP$ADMIN','DBSNMP')