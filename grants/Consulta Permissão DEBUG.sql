/* Formatted on 2008/10/21 14:07 (Formatter Plus v4.8.8) */
SELECT   'REVOKE '||PRIVILEGE||' FROM '||GRANTEE||';'
    FROM dba_sys_privs
   WHERE (   PRIVILEGE LIKE '% ANY %'
          OR PRIVILEGE IN ('BECOME USER', 'UNLIMITED TABLESPACE')
          OR
          PRIVILEGE LIKE '% DEBUG %'
          OR admin_option = 'YES'
         )
     AND grantee NOT IN
            ('SYS', 'SYSTEM', 'DBA', 'AQ_ADMINISTRATOR_ROLE',
             'AURORA$JIS$UTILITY$', 'EXP_FULL_DATABASE', 'IMP_FULL_DATABASE',
             'JAVADEBUGPRIV', 'LNSTG', 'MIGCMC', 'OEM_MONITOR',
             'OSE$HTTP$ADMIN', 'OUTLN', 'SASMASTER', 'WMSYS', 'XDB', 'SPOT')
     AND grantee NOT LIKE 'DBA%'
ORDER BY grantee