rem  =======================================================================
rem  Name    : Tuner.sql
rem  author  : R. Schierbeek, Bytelife bv Netherlands
rem  date    : 27-06-2000
rem  version : 1.3
rem  =======================================================================
rem  Modified: 
rem  01-may-02 - corrected an error in Buffer cache hit-rate.
rem  01-sep-02 - sh.pool Free memory improved.
rem  =======================================================================

clear columns
set feedback off heading off verify off
set lines 500 trimspool ON pages 0

prompt  spooling to file C:\temp\tuner.htm
set termout off
spool C:\temp\tuner.htm

prompt <html><body bgcolor=white>
prompt <table cellpadding=2 width=700 cellpadding=3 cellspacing=0 border=3>
prompt <tr bgcolor=#E8E8E8><td colspan=3 align=center>
prompt <font size=5 color=#333366> Tuning report </font>
prompt <tr bgcolor=#E8E8E8><td>
select '<font size=4 color=#333366>database: <b>'||name  from v$database ;
select '<td><font size=4> date: '||to_char(sysdate,'DD-mon-YYYY')  from dual;
select '<td><font size=4> time: '||to_char(sysdate,'HH:MI')  from dual;
prompt </table>

rem     ================================== 
prompt <H3><font color=#333366> SGA - System Global Area </font></H3> 
prompt <blockquote><font face=courier>
prompt <table  cellpadding=0 cellspacing=2 width=300> <tr bgcolor=#E8E8E8>
prompt <td><b>name <td align=right><b>value 

select '<tr><td>'||name||'<td align=right>'||value
from V$SGA
/
prompt <tr><td>
prompt <tr  align=right bgcolor=#E8E8E8><td> free memory <td> bytes

select '<tr align=right><td><i>'||pool||'<td>'||bytes
from   v$sgastat
where  name = 'free memory' 
/
prompt </table></font>
prompt <p><b>* free memory </b>is the part of the pool (Variable Size) which is not in use.


rem     ================================== 
prompt <H4>A] <font color=#333366>Data buffer Cache </font></H4> 

prompt <table  cellpadding=0 cellspacing=2 width=300> <tr bgcolor=#E8E8E8>
prompt <td align=right><b>data buffer hitratio  

select  '<tr>'||'<td align=right><b>'||round((1-(PR.value/
         (DB.value+CG.value) ))*100,2) 
from   v$sysstat PR
      ,v$sysstat DB
      ,v$sysstat CG
where  PR.name = 'physical reads'
and    DB.name = 'db block gets'
and    CG.name = 'consistent gets'
/

prompt </table><p>

prompt <table  cellpadding=0 cellspacing=2 width=300> 
prompt <tr align=right bgcolor=#E8E8E8><td> Name 
prompt <td><b> Value

select '<tr align=right>'||'<td>'||name||
	 '<td><font face=courier>'||value
from   V$SYSSTAT
where  name in ('physical reads','db block gets','consistent gets')
/
prompt </table>

rem     ================================== 
prompt <H4>B] <font color=#333366>Dictionary Cache (v$rowcache)  </font></H4> 

prompt <table  cellpadding=0 cellspacing=2 width=300> <tr bgcolor=#E8E8E8>
prompt <td><b>Gets 
prompt <td><b>Misses 
prompt <td align=right><b> Ratio 

select  '<tr>'||
        '<td>'||SUM(gets)||
	 '<td align=right>'||SUM(getmisses)||
	 '<td align=right><b> '||to_char(trunc(100 - (SUM(getmisses)/SUM(gets)*100))) 
from v$rowcache
/
prompt </table>

rem     ================================== 
prompt <H4>C] <font color=#333366>Library Cache </font></H4> 

prompt <table  cellpadding=0 cellspacing=2 width=300> <tr bgcolor=#E8E8E8>
prompt <td><b>Executions
prompt <td><b>Reloads
prompt <td align=right><b> Ratio

select  '<tr>'||
        '<td>'||SUM(pins)||
	 '<td align=right>'||SUM(reloads)||
	 '<td align=right><b> '||to_char(trunc(100 - (SUM(reloads)/SUM(pins)*100))) 
from v$librarycache
/
prompt </table>


prompt <OL type=A>
prompt <LI>Buffer cache hit-rate, should be > 95%
prompt <br>Buffer cache is the amount of memory allocated for the data: tables and indexes.
prompt <LI>Dictionary cache hit-rate, should be > 95%
prompt <br>Dictionary cache is the amount of memory allocated for the dictionary.
prompt <LI>Library cache reloads, should be 99 - 100%
prompt <br>Library cache reloads is the percentage of SQL statements that don´t need to be reloaded.

prompt </blockquote><p>
prompt <hr size=3 noshade=ON>

rem     ================================== 
rem     == license Sessions
rem     ==================================

prompt <H3><font color=#333366>Licensed sessions - v$license  </font></H3> 
prompt <blockquote>
prompt <table  cellpadding=0 cellspacing=2> <tr bgcolor=#E8E8E8>
prompt <td><b>Current Sessions 
prompt <td><b>Highwater Sessions 

select '<tr>'||
       '<td>'||sessions_current||
	 '<td align=right>'||sessions_highwater 
from   v$license
/
prompt </table></blockquote>


rem     ================================== 
rem     == User Sessions
rem     ==================================
prompt <H3><font color=#333366> Sessions (physical reads>1000)  </font></H3> 

prompt <blockquote>
prompt <table  cellpadding=0 cellspacing=2 width=550> <tr bgcolor=#E8E8E8>
prompt <td><b>User 
prompt <td><b> Osuser 
prompt <td align=right><b>Changes 
prompt <td align=right><b>Reads 
prompt <td align=right><b>Physical reads 
prompt <td align=right><b>Hit Ratio

select '<tr>'||
       '<td>'||substr(username,1,14)||
	 '<td>'||substr(osuser,1,16)||
	'<td align=right>'||to_char(block_changes+consistent_changes)||
	'<td align=right>'||to_char(consistent_gets+block_gets)||
	'<td align=right>'||to_char(physical_reads)||
	'<td align=right>'||to_char(round(1- (physical_reads/(block_gets+consistent_gets+1) ),2)*100) 
from  v$sess_io i
    , v$session s
where i.sid          = s.sid
and   physical_reads > 5000 
order by physical_reads desc
/
prompt </table></blockquote>


rem     ================================== 
rem     == Rollback Segments
rem     ==================================

prompt <hr size=3 noshade=ON>

prompt <H3><font color=#333366>Rollback Segments </font></H3> 
prompt <blockquote>
prompt <table cellpadding=2 cellspacing=2 width=550><tr align=right bgcolor=#E8E8E8>
prompt <td align=left><b> Name 
prompt <td><b>Extents 
prompt <td><b>Optsize 
prompt <td><b>hwmsize 
prompt <td><b>rssize 
prompt <td><b>shrinks 
prompt <td><b>waits 
prompt <td><b>Transactions 
prompt <td><b>writes 

select '<tr>'||
       '<td>'||name||
	'<td align=right>'||extents   ||
	'<td align=right>'||optsize   ||
	'<td align=right>'||hwmsize   ||
	'<td align=right>'||rssize    ||
	'<td align=right>'||shrinks   ||
	'<td align=right>'||waits     ||
	'<td align=right><b>'||Xacts  ||
	'<td align=right>'||writes    
from v$rollstat a, v$rollname b
where a.usn = b.usn
/
prompt </table></blockquote>




rem     ================================== 
rem     == Buffer Contention
rem     ==================================

prompt <H3><font color=#333366>Buffer Contention </font></H3> 
prompt <blockquote>
prompt <table cellpadding=0 cellspacing=2 width=300><tr bgcolor=#E8E8E8>
prompt <td><b>Class 
prompt <td align=right><b>Count 
prompt <td align=right><b>Time 

select  '<tr>'||
        '<td>'||class||
	'<td align=right>'||count||
	'<td align=right>'||time 
from v$waitstat
/
prompt </table></blockquote>

rem     ================================== 
rem     ==  enqueue 
rem     ==================================


prompt <H3><font color=#333366> Enqueue waits </font></H3> 
prompt <blockquote>
prompt <table cellpadding=0 cellspacing=2 width=300><tr bgcolor=#E8E8E8>
prompt <td><b> enqueue  
prompt <td align=right><b>Count 

col value for 999,999,999

select  '<tr><td>'||name||
	'<td align=right>'||value
from   v$sysstat
where  name in ('enqueue waits', 'enqueue timeouts','enqueue deadlocks')
/
prompt </table></blockquote>


 
rem     ================================== 
rem     == Redo Log
rem     ==================================

prompt <H3><font color=#333366>Redo Log </font></H3> 

prompt <blockquote>
prompt <table cellpadding=0 cellspacing=2 width=500> 
prompt <tr align=right bgcolor=#E8E8E8><td align=left><b> Name 
prompt <td><b>Value 

select  '<tr>'||
        '<td>'||name||
	'<td align=right>'||value 
from v$sysstat
where name = 'redo log space requests'
/
prompt </table></blockquote>


prompt <blockquote>
prompt <table cellpadding=0 cellspacing=2 width=500>
prompt <tr align=right bgcolor=#E8E8E8><td align=left><b> Name 
prompt <td><b>Gets 
prompt <td><b>Misses 
prompt <td><b>Immediate gets 
prompt <td><b>Immediate misses 

select  '<tr>'||
        '<td>'||n.name||
	'<td align=right>'||gets||'</td>' ||
	'<td align=right>'||misses||'</td>' ||
	'<td align=right>'||immediate_gets||'</td>' ||
	'<td align=right>'||immediate_misses 
from   v$latch l
      ,v$latchname n
where  n.name IN ('redo allocation', 'redo copy')
AND n.latch# = l.latch#
/
prompt </table></blockquote>


prompt <hr size=3 noshade=ON>

rem    ================================== 
rem    MTS: Multi Threaded Server
rem    ================================== 

prompt <H3><font color=#333366>Multi Threaded Server: Dispatchers  </font></H3> 
prompt <blockquote>
prompt <table cellpadding=0 cellspacing=2 width=500><tr bgcolor=#E8E8E8>
prompt <td><b>Name 
prompt <td><b>Protocol 
prompt <td><b>Owned 
prompt <td><b>Status 
prompt <td><b>Busy rate 

select  '<tr>'||
        '<td>'||name||
	'<td align=right>'||network||
	'<td align=right>'||owned||
	'<td align=right>'||status||
	'<td align=right>'||busy/(busy+idle) 
from   v$dispatcher
/
prompt </table></blockquote>

prompt <blockquote>
prompt <table cellpadding=0 cellspacing=2 width=500><tr bgcolor=#E8E8E8>
prompt <td><b>Name 
prompt <td><b>Type 
prompt <td><b>Queues 
prompt <td><b>Wait 
prompt <td><b>Totalq 
prompt <td><b>Avg Wait 

select  '<tr>'||
        '<td>'||d.name||
	'<td align=right>'||type||
	'<td align=right>'||queued||
	'<td align=right>'||wait||
	'<td align=right>'||totalq||
	'<td align=right>'||decode(totalq,0,0,wait/totalq)
from v$queue q,v$dispatcher d
where q.paddr = d.paddr(+)
/

prompt </table></blockquote>


prompt <blockquote>
prompt <table cellpadding=0 cellspacing=2 width=500><tr bgcolor=#E8E8E8>
prompt <td><b>Protocol 
prompt <td><b>Avg Wait Time per responce 

select '<tr>'||
       '<td>'||network||
       '<td align=right>'||DECODE( SUM(totalq), 0, 'No Responces',
	       SUM(wait)/SUM(totalq)||' hundredths of seconds')
from v$queue q, v$dispatcher d
where q.type = 'DISPATCHER'
AND   q.paddr = d.paddr
GROUP BY network
/
prompt </table></blockquote>

rem    ================================== 
prompt <H3><font color=#333366>MTS: Shared Server </font></H3> 
prompt <blockquote>
prompt <table cellpadding=0 cellspacing=2 width=500><tr align=right bgcolor=#E8E8E8>
prompt <td><b>Name 
prompt <td><b>Request 
prompt <td><b>Busy 
prompt <td><b>Idle 
prompt <td><b>Busy rate 
prompt <td><b>Status 

select  '<tr align=right>'||
        '<td>'||name||
	'<td align=right>'||requests||
	'<td align=right>'||busy ||
	'<td align=right>'||idle ||
	'<td align=right>'||(busy/(busy + idle)) * 100 ||
	'<td align=right>'||status 
from 	v$shared_server
/

prompt </table></blockquote>


prompt <blockquote>
prompt <table cellpadding=0 cellspacing=2 width=500><tr align=right bgcolor=#E8E8E8>
prompt <td><b>Max Conn 
prompt <td><b>Started 
prompt <td><b>Terminated 
prompt <td><b>Highwater 

select  '<tr align=right>'||
	'<td>'||maximum_connections||
	'<td align=right>'||servers_started||
	'<td align=right>'||servers_terminated||
	'<td align=right>'||servers_highwater
from v$mts
/
prompt </table></blockquote>


prompt <hr size=3 noshade=ON>

rem    ================================== 
prompt <H3><font color=#333366> Statistics  </font></H3>

prompt <blockquote>
prompt <table width=500 border=0 cellspacing=1><tr bgcolor=#E8E8E8>
prompt <td><b>Class <td><b>Name <td  align=right><b>Value 

select '<tr bgcolor=#EFEFEF><td>'||n.class||	
        '<td>'||n.name||
        '<td align=right><font face=courier>'||value  
from   V$STATNAME N,
       V$SYSSTAT  S
where  n.statistic# = s.statistic#
and n.name like '% memo%'
/
select '<tr bgcolor=#C1CDCD><td>'||n.class||	
        '<td>'||n.name||
        '<td align=right><font face=courier>'||value 
from   V$STATNAME N,
       V$SYSSTAT  S
where  n.statistic# = s.statistic#
and    n.name like '%table %'
/
select '<tr bgcolor=#E3E4FA><td>'||n.class||	
        '<td>'||n.name||
        '<td align=right><font face=courier>'||value  
from   V$STATNAME N,
       V$SYSSTAT  S
where  n.statistic# = s.statistic#
and    n.name like '%sort%'
/
select '<tr  bgcolor=#E8E8E8><td>'||n.class||	
        '<td>'||n.name||
        '<td align=right><font face=courier>'||value  
from   V$STATNAME N,
       V$SYSSTAT  S
where  n.statistic# = s.statistic#
and n.name like '%cpu%'
/
prompt </table></blockquote>


rem     ================================== 
rem     == INIT.ORA
rem     ==================================
prompt <H3><font color=#333366>Init.ora </font></H3> 

prompt <blockquote>
prompt <table border=0 cellspacing=1 width=500><tr bgcolor=#E8E8E8>
prompt <td><b>Type 
prompt <td><b>Name 
prompt <td><b>Value 
select '<tr bgcolor='||decode(type,1,'EFEFEF'
                                  ,2,'C1CDCD'
                                  ,3,'E8E8E8','d8d0c8')||'>'||
       '<td>'||type||
       '<td>'||name||
	 '<td>'||substr(value,1,40) 
from   v$parameter
where  name not like 'gc%'
and    type =3
or  name in ('compatible','hash_join_enabled','hash_area_size','optimizer_mode')
order by type,name
/
prompt </table></blockquote>
prompt <hr size=4 noshade=ON>End of file

prompt </body></html>
spool off;
set termout ON define ON head ON feed ON verify ON
set lines 80 pages 100

