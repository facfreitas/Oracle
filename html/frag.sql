rem  name    : Frag.sql
rem  date    : 25-apr-2000
rem  author  : R. Schierbeek, Bytelife bv Netherlands
rem  desc    : Creates a HTML file which shows all extents for 1 datafile. 
rem  This script is suitable for Locally Managed Tablespaces (8i+)
rem            
rem  version : 1.2
rem =========================================================================
rem  Modified: 
rem  25-aug-2001 - Layout better
rem  15-nov-2001 - Important: C2 >= 24 wide.
rem =========================================================================

clear columns breaks
col name for A50
select tablespace_name from dba_tablespaces
order by tablespace_name ;

 
set pages 0 feed off wrap off verify off head off trimspool ON colsep '<td>'
set  linesize 300 scan on

 
prompt
prompt spooling to C:\temp\frag&&Tablsp..htm, please wait one minute ...
spool C:\temp\&&Tablsp..htm

set term Off
prompt <html><head>
prompt <html><head><meta name="description" content="Datafile fragmention">
select '<title>Datafile fragmention of '||name||'</title>' from v$database;
prompt </head><body bgcolor="white">

select 'Database: <b>'||name||'</b> date: '||to_char(sysdate,'DD-MON-YY HH24:MI')
from v$database ;

prompt <blockquote>
prompt <table width="550" cellpadding="1" cellspacing="0" border="0">
prompt <tr align=right bgcolor="#C1CDCD"><td>fileID 
prompt <td>segment name <td>partition name <td>extentID
prompt <td> block ID <td>Kbyte

/* Important: C2 >= 24 */
col C2          for A24 
col extent_ID   for 9999 head xid
col block_id    for 99,999,999
col blocks      for 99,999,999
col name        for A30 trunc
col kbyte       for A70

select '<tr align=right>' 
      ,file_ID
      ,segment_name name
      ,PARTITION_NAME
      ,EXTENT_ID
      ,BLOCK_ID 
      ,'<b>'||lpad((bytes/1024),9,' ') KByte
from  dba_extents
where TABLESPACE_NAME  =upper('&&Tablsp')
UNION
select '<tr align=right bgcolor="E8E8E8">' 
      ,file_ID
      ,'<b>free space</b>'
      ,'<b>free space</b>'
      ,0
      ,BLOCK_ID 
      ,'<b>'||lpad((bytes/1024),9,' ') KByte
from  dba_free_space
where TABLESPACE_NAME  =upper('&&Tablsp')
and rownum < 1000
order by 2,6
/
prompt <tr align=right bgcolor="#C1CDCD"><td>fileID 
prompt <td>segment name <td>partition name <td>extentID
prompt <td> block ID <td>Kbyte
prompt </table>
prompt </blockquote>

prompt <hr>

col file_name for A60
col Kbyte for 9999999999

select '<br><b>'||F.tablespace_name||'</b>'
      ,F.file_name
      ,'Kbyte : '
      ,F.bytes/1024   KBYTE
from   sys.DBA_DATA_FILES F
where TABLESPACE_NAME  =upper('&&Tablsp')
/


prompt </body></html>
spool off
set colsep ' '
set feed ON head ON pages 100 term ON
set lines 100
undefine Tablsp
