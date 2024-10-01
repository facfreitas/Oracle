select distinct 'EXEC DBMS_UTILITY.ANALYZE_SCHEMA('''|| username ||''','''||'COMPUTE'||''');'
from dba_users
where username not in ('SYS','OUTLN','SYSTEM','MDSYS','XDB','EXFSYS','WMSYS','CTXSYS','OLAPSYS','DBSNMP','APPQOSSYS','SYSMAN','USER_SPOT')
