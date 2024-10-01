/* Descricao  : Verifica transacoes ativas nos Segmentos de Rollback       */
/* Modulo     : Performance&Tuning - Monitoracao                           */

def g_Script   = 'rbstrans.sql'
def g_Titulo   = 'Transacoes ativas nos Segmentos de Rollback'
 
start 'rpt_cab.sql'

set linesize 80
set verify off
set message off
set echo off
set feedback off

col c1 format a8  heading 'O/S|User'
col c2 format a10 heading 'Oracle|User-id'
col c3 format a12 heading 'Nome|RBS'
col c4 format a45 heading 'SQL Corrente' word

select osuser       c1,
       username     c2,
       segment_name c3,
       sa.sql_text  c4
from   v$session s,
       v$transaction t,
       dba_rollback_segs r,
       v$sqlarea sa
where  s.taddr = t.addr
and    t.xidusn = r.segment_id(+)
and    s.sql_address = sa.address(+)
/

set verify on
set message on
undef g_Script
undef g_Titulo
ttitle off
clear column
clear breaks
 
/*********GSF********GSF********GSF********GSF********GSF********GSF********/
/***************************************************************************/
