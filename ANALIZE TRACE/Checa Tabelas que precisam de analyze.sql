
rem Script Description: This script identifies tables with stale statistics. The identifying criteria are size and 
rem                     percentage of change. This is for versions 7.3 and higher.
rem
rem Output file:        stalestats.lis
rem
rem Prepared By:        TheOracleResourceStop
rem                     www.orsweb.com
rem
rem Usage Information:  SQLPLUS SYS/pswd
rem                     @stalestats.sql
rem

--set pagesize 45;
--set verify off echo off;

--prompt Enter the schema to assess accept schema; 

--ttitle center "Stale Statistics for &&schema "

--col table_name heading 'Table Name' format a30 ;
--col analyzedsize heading 'Analyzed|Size' format 999,999.99 ;
--col currsize heading 'Current|Size' format 999,999.99 ;
--col pctchg heading '% of|Change'  format 999 ;

--spool stalestats.lis

select  rtrim(s.owner) ||'.'|| rtrim(table_name)  table_name,1 + s.freelist_groups + t.blocks + t.empty_blocks analyzedsize,
  s.blocks  currsize, substr(to_char(100 * (s.blocks - 1 - s.freelist_groups - t.blocks - t.empty_blocks) /
            (1 + s.freelist_groups + t.blocks + t.empty_blocks),'999.00'),2) ||'%'  pctchg
from dba_segments s, dba_tables t
where s.owner not in ('SYS','SYSTEM','OUTLN','DBSMNP','SPOT','WMSYS','DBSFWUSER',
                                       'DBSNMP','APPQOSSYS','GSMADMIN_INTERNAL','XDB','OJVMSYS',
                                        'CTXSYS','ORDSYS','ORDDATA','MDSYS','OLAPSYS','LBACSYS',
                                        'DVSYS','FLOWS_FILES','AUDSYS','ORDS_METADATA')
  and s.owner = t.owner
  and s.segment_name = t.table_name
  and abs(s.blocks - 1 - s.freelist_groups - t.blocks - t.empty_blocks) > 4
order by 1;

--spool off;

--undefine schema;
--clear columns;
--ttitle off;

