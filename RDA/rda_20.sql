-- rda_20.sql
--
--  Global settings
SET define ~
SET echo off
SET heading off
SET verify off
SET pagesize 20000
SET linesize 250
SET termout off 
SET feedback off
--? SET ttitle off

-- HTML Formatting settings
define RDA_html_font="<BR><FONT COLOR=""#336699"">"
define RDA_html_end_font="</FONT><BR>"

define RDA_html_h31="<H3><FONT COLOR=""#336699"">"
define RDA_html_h32="</FONT></H3>"

define RDA_html_h41="<H4> <FONT COLOR=""#336699"">"
define RDA_html_h42="</FONT></H4>"

define RDA_html_tab1="<TABLE BORDER CELLPADDING=2>"
define RDA_html_tab2="</TABLE>"

define RDA_html_tdh1="<TH BGCOLOR=""#cccc99""><B><FONT FACE=""ARIAL"" COLOR=""#336699"" SIZE=2>"
define RDA_html_tdh2="</B></FONT></TH>"

define RDA_html_td1="<TD BGCOLOR=""#f7f7e7""><FONT FACE=""ARIAL"" SIZE=2>"
define RDA_html_td2="</FONT></TD>"

define RDA_html_tdc1="<TD BGCOLOR=""#cccc99""><B><FONT FACE=""ARIAL"" COLOR=""#336699"" SIZE=2>"
define RDA_html_tdc2="</FONT></B></TD>"

-- Decide on the version specific SQL now
spool rda_v.sql
SELECT '@rda_v'||SUBSTR(version,1,1)||SUBSTR(version,3,1)||'.sql' FROM v$instance;
spool off

spool RDA_DB.htm

prompt <HTML><HEAD><TITLE>RDA_SQL.HTM ( Version 2.0 ) </TITLE></HEAD><BODY>

----------------------------------------------------
prompt <!--[   ProdVer | Product Versions ]-->
prompt <A NAME="ProdVer"></A>
prompt ~RDA_html_h31 Product Versions  ~RDA_html_h32 
prompt ~RDA_html_tab1
prompt ~RDA_html_tdh1 Banner ~RDA_html_tdh2
SELECT '<TR> ~RDA_html_td1' || banner || '~RDA_html_td2 </TR>'
FROM v$version;
prompt ~RDA_html_tab2
----------------------------------------------------
prompt <!--[   info | DB Info ]-->
prompt <A NAME="info"></A>
prompt ~RDA_html_h31 DB Info ~RDA_html_h32 
prompt ~RDA_html_tab1

SELECT  '<TR> ~RDA_html_tdc1' || 'DB Name' || '~RDA_html_tdc2' ,
             ' ~RDA_html_td1' || d.name  || '~RDA_html_td2 </TR>' ,
        '<TR> ~RDA_html_tdc1' || 'Global Name' || '~RDA_html_tdc2' ,
             ' ~RDA_html_td1' || g.global_name  || '~RDA_html_td2 </TR>' ,
        '<TR> ~RDA_html_tdc1' || 'Host Name' || '~RDA_html_tdc2' ,
             ' ~RDA_html_td1' || i.host_name  || '~RDA_html_td2 </TR>' ,
        '<TR> ~RDA_html_tdc1' || 'Instance Name' || '~RDA_html_tdc2',
             ' ~RDA_html_td1' || i.instance_name  || '~RDA_html_td2 </TR>' ,
        '<TR> ~RDA_html_tdc1' || 'Instance Start Time' || '~RDA_html_tdc2' ,
             ' ~RDA_html_td1' || to_char(i.startup_time,'DD-MON-YYYY HH24:MI')  || '~RDA_html_td2 </TR>' ,
        '<TR> ~RDA_html_tdc1' || 'Restricted Mode' || '~RDA_html_tdc2' ,
             ' ~RDA_html_td1' || decode(i.logins,'RESTRICTED','YES','NO')  || '~RDA_html_td2 </TR>' ,
        '<TR> ~RDA_html_tdc1' || 'Archive Log Mode' || '~RDA_html_tdc2' ,
             ' ~RDA_html_td1' || d.log_mode  || '~RDA_html_td2 </TR>' 
FROM v$database d, v$instance i,global_name g;
prompt ~RDA_html_tab2
------------------------------------------------------
prompt <!--[  options | Database Options ]-->
prompt <A NAME="options"></A>
prompt ~RDA_html_h31 Database Options ~RDA_html_h32
prompt ~RDA_html_tab1
prompt ~RDA_html_tdh1 Parameter ~RDA_html_tdh2
prompt ~RDA_html_tdh1 Value ~RDA_html_tdh2

SELECT '<TR> ~RDA_html_td1' || o.parameter || '~RDA_html_td2 ~RDA_html_td1' || o.value || '~RDA_html_td2 </TR>'
FROM v$option o order by o.parameter;
prompt ~RDA_html_tab2
----------------------------------------------------
prompt <!--[  sga | SGA Information ]-->
prompt <A NAME="sga"></a>
prompt ~RDA_html_h31 SGA Information ~RDA_html_h32

prompt <A HREF="#sga1">V$SGA</a>
prompt <A HREF="#sga2">V$SGASTAT</a>

prompt <A NAME="sga1"></a>
prompt ~RDA_html_h31 V$SGA ~RDA_html_h32
prompt ~RDA_html_tab1
prompt ~RDA_html_tdh1 Name # ~RDA_html_tdh2
prompt ~RDA_html_tdh1 Value  ~RDA_html_tdh2

SELECT '<TR> ~RDA_html_td1' || s.name  || '~RDA_html_td2' ,
            '~RDA_html_td1' || s.value || '~RDA_html_td2 </TR>'
FROM v$sga s;
prompt ~RDA_html_tab2

prompt <A NAME="sga2"></a>
prompt ~RDA_html_h31 V$SGASTAT ~RDA_html_h32
prompt ~RDA_html_tab1
prompt ~RDA_html_tdh1 Pool  ~RDA_html_tdh2
prompt ~RDA_html_tdh1 Name  ~RDA_html_tdh2
prompt ~RDA_html_tdh1 Bytes ~RDA_html_tdh2
SELECT '<TR> ~RDA_html_td1' || nvl(v.pool,'<i>null value</i>') || '~RDA_html_td2' ,
       '~RDA_html_td1' || v.name  || '~RDA_html_td2' ,
       '~RDA_html_td1' || v.bytes || '~RDA_html_td2 </TR>'
FROM v$sgastat v;
prompt ~RDA_html_tab2
----------------------------------------------------
prompt <!--[  license | v$license ]-->
prompt <A NAME="license"></a>
prompt ~RDA_html_h31 V$License ~RDA_html_h32
prompt ~RDA_html_tab1
SELECT  '<TR> ~RDA_html_tdc1' || 'Max Sessions' || '~RDA_html_tdc2' ,
             ' ~RDA_html_td1' || l.sessions_max  || '~RDA_html_td2 </TR>' ,
        '<TR> ~RDA_html_tdc1' || 'Warning Sessions' || '~RDA_html_tdc2' ,
             ' ~RDA_html_td1' || l.sessions_warning  || '~RDA_html_td2 </TR>' ,
        '<TR> ~RDA_html_tdc1' || 'Current Sessions' || '~RDA_html_tdc2' ,
             ' ~RDA_html_td1' || l.sessions_current  || '~RDA_html_td2 </TR>' ,
        '<TR> ~RDA_html_tdc1' || 'Highwater Sessions' || '~RDA_html_tdc2' ,
             ' ~RDA_html_td1' || l.sessions_highwater  || '~RDA_html_td2 </TR>' ,
        '<TR> ~RDA_html_tdc1' || 'Max Users' || '~RDA_html_tdc2' ,
             ' ~RDA_html_td1' || l.users_max  || '~RDA_html_td2 </TR>'
FROM v$license l;
prompt ~RDA_html_tab2
----------------------------------------------------
prompt <!--[  compatibility | V$Compatibility ]-->
prompt <A NAME="compatibility"></a>
prompt ~RDA_html_h31 V$Compatibility ~RDA_html_h32
prompt ~RDA_html_tab1
prompt ~RDA_html_tdh1 Type ID ~RDA_html_tdh2
prompt ~RDA_html_tdh1 Release ~RDA_html_tdh2
prompt ~RDA_html_tdh1 Description ~RDA_html_tdh2

SELECT '<TR> ~RDA_html_td1' || c.type_id || '~RDA_html_td2' ,
       '~RDA_html_td1' || c.release     || '~RDA_html_td2' ,
       '~RDA_html_td1' || c.description || '~RDA_html_td2 </TR>'
FROM v$compatibility c 
ORDER BY c.type_id;
prompt ~RDA_html_tab2
----------------------------------------------------
prompt <!--[  logfile | Online Redo Log Files ]-->
prompt <A NAME="logfile"></a>
prompt ~RDA_html_h31 Online Redo Log Files ~RDA_html_h32

prompt <A HREF="#logfile1">v$logfile</a>
prompt <A HREF="#logfile2">v$log</a>

prompt <A NAME="logfile1"></a>
prompt ~RDA_html_h31 V$Logfile ~RDA_html_h32
prompt ~RDA_html_tab1
prompt ~RDA_html_tdh1 Group # ~RDA_html_tdh2
prompt ~RDA_html_tdh1 Status  ~RDA_html_tdh2
prompt ~RDA_html_tdh1 Member  ~RDA_html_tdh2

SELECT '<TR> ~RDA_html_td1' || l.group# || '~RDA_html_td2' ||
       '~RDA_html_td1'      || nvl(l.status,'<i>null value</i>') || '~RDA_html_td2' ||
       '~RDA_html_td1'      || l.member || '~RDA_html_td2 </TR>'
FROM v$logfile l 
ORDER BY l.group#,l.member;
prompt ~RDA_html_tab2

prompt <A NAME="logfile2"></a>
prompt ~RDA_html_h31 V$Log ~RDA_html_h32
prompt ~RDA_html_tab1
prompt ~RDA_html_tdh1 Group #  ~RDA_html_tdh2
prompt ~RDA_html_tdh1 Thread # ~RDA_html_tdh2
prompt ~RDA_html_tdh1 Sequence # ~RDA_html_tdh2
prompt ~RDA_html_tdh1 Bytes ~RDA_html_tdh2
prompt ~RDA_html_tdh1 Members ~RDA_html_tdh2
prompt ~RDA_html_tdh1 Archived ~RDA_html_tdh2
prompt ~RDA_html_tdh1 Status ~RDA_html_tdh2
prompt ~RDA_html_tdh1 First Change # ~RDA_html_tdh2
prompt ~RDA_html_tdh1 First Time ~RDA_html_tdh2
SELECT '<TR> ~RDA_html_td1' || l.group# || '~RDA_html_td2' ,
       '~RDA_html_td1' || l.thread# || '~RDA_html_td2' ,
       '~RDA_html_td1' || l.sequence# || '~RDA_html_td2' ,
       '~RDA_html_td1' || l.bytes || '~RDA_html_td2' ,
       '~RDA_html_td1' || l.members || '~RDA_html_td2' ,
       '~RDA_html_td1' || l.archived || '~RDA_html_td2' ,
       '~RDA_html_td1' || nvl(l.status,'<i>null value</i>') || '~RDA_html_td2' ,
       '~RDA_html_td1' || l.first_change# || '~RDA_html_td2',
       '~RDA_html_td1' || to_char(l.first_time,'DD-MON-YYYY HH24:MI') || '~RDA_html_td2 </TR>'
FROM  v$log l 
ORDER BY l.group#,l.thread#;
prompt ~RDA_html_tab2
----------------------------------------------------
prompt <!--[ system_event | System Event ]-->
prompt <A NAME="system_event"></a>
prompt ~RDA_html_h31 V$System_Event ~RDA_html_h32
prompt ~RDA_html_tab1
prompt ~RDA_html_tdh1 Wait Event   ~RDA_html_tdh2
prompt ~RDA_html_tdh1 Waits        ~RDA_html_tdh2
prompt ~RDA_html_tdh1 Timeouts     ~RDA_html_tdh2
prompt ~RDA_html_tdh1 Time Waited  ~RDA_html_tdh2
prompt ~RDA_html_tdh1 Average Wait ~RDA_html_tdh2

SELECT '<TR> ~RDA_html_td1' || s.event             || '~RDA_html_td2',
        '~RDA_html_td1' || s.total_waits           || '~RDA_html_td2',
        '~RDA_html_td1' || s.total_timeouts        || '~RDA_html_td2',
        '~RDA_html_td1' || s.time_waited           || '~RDA_html_td2',
        '~RDA_html_td1' || round(s.average_wait,2) || '~RDA_html_td2 </TR>'
FROM v$system_event s
order by s.time_waited desc,s.event;
prompt ~RDA_html_tab2
----------------------------------------------------
prompt <!--[ session_wait | Session Waits ]-->
prompt <A NAME="session_wait"></a>
prompt ~RDA_html_h31 Session Waits ~RDA_html_h32
prompt ~RDA_html_tab1
prompt ~RDA_html_tdh1 Wait Event             ~RDA_html_tdh2
prompt ~RDA_html_tdh1 Total Sessions Waiting ~RDA_html_tdh2

SELECT '<TR> ~RDA_html_td1' || w.event  || '~RDA_html_td2',
            '~RDA_html_td1' || count(*) || '~RDA_html_td2 </TR>' 
FROM v$session_wait w 
where wait_time=0
group by event
order by 2 desc;
prompt ~RDA_html_tab2
----------------------------------------------------
prompt <!--[ topsql | Top SQLs]-->
prompt <A NAME="topsql"></a>
prompt ~RDA_html_h31 Top SQLs ~RDA_html_h32

prompt <A HREF="#topsql1">SQLs with High Disk Reads</a>
prompt <A HREF="#topsql2">SQLs with High Buffer Gets</a>
prompt <A HREF="#topsql3">SQLs with more than 15 Loads</a>

prompt <A NAME="topsql1"></a>
prompt ~RDA_html_font SQL in Shared Pool with High Disk Reads to Executions Ratio ~RDA_html_end_font

prompt ~RDA_html_tab1
prompt ~RDA_html_tdh1 SQL Text ~RDA_html_tdh2
prompt ~RDA_html_tdh1 Executions ~RDA_html_tdh2
prompt ~RDA_html_tdh1 Expected Response Time (in sec) ~RDA_html_tdh2

SELECT '<TR> ~RDA_html_td1' || sql_text   || '~RDA_html_td2',
            '~RDA_html_td1' || executions || '~RDA_html_td2',
            '~RDA_html_td1' || disk_reads / decode(executions,0,1, executions) / 50|| '~RDA_html_td2 </TR>'
FROM V$sqlarea
where  disk_reads / decode(executions,0,1, executions) / 50 > 100
order  by executions desc;
prompt ~RDA_html_tab2

prompt <A NAME="topsql2"></a>
prompt ~RDA_html_font SQL in Shared Pool with High Buffer Gets to Executions Ratio ~RDA_html_end_font

prompt ~RDA_html_tab1
prompt ~RDA_html_tdh1 SQL Text    ~RDA_html_tdh2
prompt ~RDA_html_tdh1 Executions  ~RDA_html_tdh2
prompt ~RDA_html_tdh1 Expected Response Time (in sec) ~RDA_html_tdh2

SELECT '<TR> ~RDA_html_td1' || sql_text   || '~RDA_html_td2',
            '~RDA_html_td1' || executions || '~RDA_html_td2',
            '~RDA_html_td1' || buffer_gets / decode(executions,0,1, executions) / 500 || '~RDA_html_td2 </TR>'
FROM V$sqlarea
where  buffer_gets / decode(executions,0,1, executions) / 500 > 100
order  by executions desc;
prompt ~RDA_html_tab2

prompt <A NAME="topsql3"></a>
prompt ~RDA_html_font SQL in Shared Pool with > 15 Loads ~RDA_html_end_font
prompt ~RDA_html_tab1
prompt ~RDA_html_tdh1 SQL Text ~RDA_html_tdh2
prompt ~RDA_html_tdh1 Executions ~RDA_html_tdh2
prompt ~RDA_html_tdh1 Expected Response Time (in Seconds) ~RDA_html_tdh2

SELECT '<TR> ~RDA_html_td1' || sql_text   || '~RDA_html_td2',
            '~RDA_html_td1' || executions || '~RDA_html_td2',
            '~RDA_html_td1' || loads      || '~RDA_html_td2 </TR>'
FROM V$sqlarea
where  loads >15
order  by loads desc;
prompt ~RDA_html_tab2

----------------------------------------------------
prompt <!--[ latches | Latch Information ]-->
prompt <A NAME="latches"></a>
prompt ~RDA_html_h31 Latch Information ~RDA_html_h32

prompt <A HREF="#latches1">v$latch</a>
prompt <A HREF="#latches2">v$latchholder</a>

prompt <A NAME="latches1"></a>
prompt ~RDA_html_h31 V$Latch ~RDA_html_h32
prompt ~RDA_html_tab1
prompt ~RDA_html_tdh1 Latch #           ~RDA_html_tdh2
prompt ~RDA_html_tdh1 Name              ~RDA_html_tdh2
prompt ~RDA_html_tdh1 Gets              ~RDA_html_tdh2
prompt ~RDA_html_tdh1 Misses            ~RDA_html_tdh2
prompt ~RDA_html_tdh1 Sleeps            ~RDA_html_tdh2
prompt ~RDA_html_tdh1 Immediate Gets    ~RDA_html_tdh2
prompt ~RDA_html_tdh1 Immediate Misses  ~RDA_html_tdh2

SELECT '<TR> ~RDA_html_td1' || l.latch#    || '~RDA_html_td2',
            '~RDA_html_td1' || l.name      || '~RDA_html_td2',
            '~RDA_html_td1' || l.gets      || '~RDA_html_td2',
            '~RDA_html_td1' || l.misses    || '~RDA_html_td2',
            '~RDA_html_td1' || l.sleeps    || '~RDA_html_td2',
            '~RDA_html_td1' || l.immediate_gets || '~RDA_html_td2',
            '~RDA_html_td1' || l.immediate_misses || '~RDA_html_td2 </TR>'
FROM v$latch l
order by sleeps desc;
prompt ~RDA_html_tab2

prompt <A NAME="latches2"></a>
prompt ~RDA_html_h31   V$LatchHolder ~RDA_html_h32
prompt ~RDA_html_tab1
prompt ~RDA_html_tdh1 PID #          ~RDA_html_tdh2
prompt ~RDA_html_tdh1 SID            ~RDA_html_tdh2
prompt ~RDA_html_tdh1 Latch Address  ~RDA_html_tdh2
prompt ~RDA_html_tdh1 Name           ~RDA_html_tdh2

SELECT '<TR> ~RDA_html_td1' || l.pid   || '~RDA_html_td2',
            '~RDA_html_td1' || l.sid   || '~RDA_html_td2',
            '~RDA_html_td1' || l.laddr || '~RDA_html_td2',
            '~RDA_html_td1' || l.name  || '~RDA_html_td2 </TR>' 
FROM v$latchholder l; 
prompt ~RDA_html_tab2

----------------------------------------------------
prompt <!--[ controlfile | Control Files ]-->
prompt <A NAME="controlfile"></a>
prompt ~RDA_html_h31 Control Files ~RDA_html_h32
prompt ~RDA_html_tab1
prompt ~RDA_html_tdh1 Name    ~RDA_html_tdh2
prompt ~RDA_html_tdh1 Status  ~RDA_html_tdh2

SELECT '<TR> ~RDA_html_td1' || v.name || '~RDA_html_td2',
            '~RDA_html_td1' || nvl(v.status,'<i>null value</i>') || '~RDA_html_td2 </TR>'
FROM V$controlfile v;
prompt ~RDA_html_tab2
----------------------------------------------------
prompt <!--[ nls | NLS Settings ]-->
prompt <A NAME="nls"></a>
prompt ~RDA_html_h31 NLS Settings ~RDA_html_h32

prompt <A HREF="#nls1">NLS Database Parameters</a>
prompt <A HREF="#nls2">NLS Instance Parameters</a>
prompt <A HREF="#nls3">NLS Session Parameters</a>

prompt <A NAME="nls1"></a>
prompt ~RDA_html_h31 NLS Database Parameters ~RDA_html_h32
prompt ~RDA_html_tab1
prompt ~RDA_html_tdh1 Parameter Name ~RDA_html_tdh2
prompt ~RDA_html_tdh1 Value          ~RDA_html_tdh2

SELECT '<TR> ~RDA_html_td1' || n.parameter || '~RDA_html_td2' ,
            '~RDA_html_td1' || n.value     || '~RDA_html_td2 </TR>'
FROM nls_database_parameters n  
order by n.parameter;
prompt ~RDA_html_tab2

prompt <A NAME="nls2"></a>
prompt ~RDA_html_h31 NLS Instance Parameters ~RDA_html_h32
prompt ~RDA_html_tab1
prompt ~RDA_html_tdh1 Parameter Name ~RDA_html_tdh2
prompt ~RDA_html_tdh1 Value          ~RDA_html_tdh2

SELECT '<TR> ~RDA_html_td1' || n.parameter || '~RDA_html_td2' ,
            '~RDA_html_td1' || nvl(n.value,'<i>null value</i>') || '~RDA_html_td2 </TR>'
FROM nls_instance_parameters n  
order by n.parameter;
prompt ~RDA_html_tab2

prompt <A NAME="nls3"></a>
prompt ~RDA_html_h31 NLS Session Parameters ~RDA_html_h32
prompt ~RDA_html_tab1
prompt ~RDA_html_tdh1 Parameter Name ~RDA_html_tdh2
prompt ~RDA_html_tdh1 Value          ~RDA_html_tdh2

SELECT '<TR> ~RDA_html_td1' || n.parameter || '~RDA_html_td2' ,
            '~RDA_html_td1' || n.value     || '~RDA_html_td2 </TR>'
FROM nls_session_parameters n  
order by n.parameter;
prompt ~RDA_html_tab2
----------------------------------------------------
prompt <!--[ params | Database Parameters ]-->
prompt <A NAME="params"></a>
prompt ~RDA_html_h31 Database Parameters ~RDA_html_h32

prompt <A HREF="#params1">Non-Default Parameters</a>
prompt <A HREF="#params2">All Parameters</a>
-- prompt <A HREF="#params3">Undocumented Parameters</a>

prompt <A NAME="params1"></a>
prompt ~RDA_html_h31 Non-Default Parameters ~RDA_html_h32
prompt ~RDA_html_tab1
prompt ~RDA_html_tdh1 Parameter Name ~RDA_html_tdh2
prompt ~RDA_html_tdh1 Value          ~RDA_html_tdh2
prompt ~RDA_html_tdh1 IsModified     ~RDA_html_tdh2

SELECT '<TR> ~RDA_html_td1' || substr(name,0,512) || '~RDA_html_td2',
            '~RDA_html_td1' || NVL(SUBSTR(value,0,512), '<i>null value</i>') || '~RDA_html_td2' ,  
            '~RDA_html_td1' || ismodified || '~RDA_html_td2 </TR>' 
FROM v$parameter 
WHERE isDefault ='FALSE'
ORDER BY name;
prompt ~RDA_html_tab2

prompt <A NAME="params2"></a>
prompt ~RDA_html_h31 All parameters ~RDA_html_h32

prompt ~RDA_html_tab1
prompt ~RDA_html_tdh1 Parameter Name ~RDA_html_tdh2
prompt ~RDA_html_tdh1 Value          ~RDA_html_tdh2
prompt ~RDA_html_tdh1 Default        ~RDA_html_tdh2
prompt ~RDA_html_tdh1 Modified       ~RDA_html_tdh2

SELECT '<TR> ~RDA_html_td1' || substr(name,0,512) || '~RDA_html_td2',
            '~RDA_html_td1' || NVL(SUBSTR(value,0,512), '<i>null value</i>') || '~RDA_html_td2' ,  
            '~RDA_html_td1' || isdefault  || '~RDA_html_td2' , 
            '~RDA_html_td1' || ismodified || '~RDA_html_td2 </TR>' 
FROM v$parameter 
ORDER BY name;
prompt ~RDA_html_tab2

-- prompt <A NAME="params3"></a>
-- prompt ~RDA_html_h31 Undocumented Parameters ( only SYS user can see ) ~RDA_html_h32
-- prompt ~RDA_html_tab1
-- prompt ~RDA_html_tdh1 Parameter Name  ~RDA_html_tdh2
-- prompt ~RDA_html_tdh1 Session Value   ~RDA_html_tdh2
-- prompt ~RDA_html_tdh1 System Value    ~RDA_html_tdh2
-- 
-- SELECT '<TR> ~RDA_html_td1' || substr(a.ksppinm,0,512) || '~RDA_html_td2',
-- '~RDA_html_td1' || NVL(SUBSTR(b.ksppstvl,0,512), '<i>null value</i>') || '~RDA_html_td2' ,  
-- '~RDA_html_td1' || NVL(SUBSTR(c.ksppstvl,0,512), '<i>null value</i>') || '~RDA_html_td2 </TR>' 
-- FROM x$ksppi a, x$ksppcv b, x$ksppsv c 
-- where a.indx = b.indx
-- and   a.indx = c.indx
-- and   substr(a.ksppinm,1,1) = '_' 
-- ORDER BY a.ksppinm;
-- 
-- prompt ~RDA_html_tab2
----------------------------------------------------
prompt <!--[ repinfo |  Replication Information ]-->
prompt <A NAME="repinfo"></a>
prompt ~RDA_html_h31 Replication Information ~RDA_html_h32

prompt <A HREF="#repinfo1">DBA_RepSites</a>
prompt <A HREF="#repinfo2">DBA_RepGroup</a>
prompt <A HREF="#repinfo3">DBA_RepObject</a>
prompt <A HREF="#repinfo4">DBA_RepCatLog</a>
prompt <A HREF="#repinfo4">Transaction Counts</a>

prompt <A NAME="repinfo1"></a>
prompt ~RDA_html_h31 DBA_RepSites ~RDA_html_h32
prompt ~RDA_html_tab1
prompt ~RDA_html_tdh1 Group Name                ~RDA_html_tdh2
prompt ~RDA_html_tdh1 DB Link                   ~RDA_html_tdh2
prompt ~RDA_html_tdh1 Master Site (Y/N)         ~RDA_html_tdh2
prompt ~RDA_html_tdh1 Master Definition DB Link ~RDA_html_tdh2

SELECT '<TR> ~RDA_html_td1'|| r.gname     || '~RDA_html_td2', 
           '~RDA_html_td1' || r.dblink    || '~RDA_html_td2', 
           '~RDA_html_td1' || r.master    || '~RDA_html_td2', 
           '~RDA_html_td1' || r.masterdef || '~RDA_html_td2 </TR>' 
FROM sys.dba_repsites r;
prompt ~RDA_html_tab2

prompt <A NAME="repinfo2"></a>
prompt ~RDA_html_h31 DBA_RepGroup ~RDA_html_h32
prompt ~RDA_html_tab1
prompt ~RDA_html_tdh1 Schema Name ~RDA_html_tdh2
prompt ~RDA_html_tdh1 Status      ~RDA_html_tdh2
prompt ~RDA_html_tdh1 Group Name  ~RDA_html_tdh2

SELECT '<TR> ~RDA_html_td1'|| r.sname  || '~RDA_html_td2', 
           '~RDA_html_td1' || r.master || '~RDA_html_td2', 
           '~RDA_html_td1' || r.status || '~RDA_html_td2', 
           '~RDA_html_td1' || r.gname  || '~RDA_html_td2 </TR>' 
FROM sys.dba_repgroup r;
prompt ~RDA_html_tab2

prompt <A NAME="repinfo3"></a>
prompt ~RDA_html_h31 DBA_RepObject ~RDA_html_h32
prompt ~RDA_html_tab1
prompt ~RDA_html_tdh1 Schema Name       ~RDA_html_tdh2
prompt ~RDA_html_tdh1 Object Name       ~RDA_html_tdh2
prompt ~RDA_html_tdh1 Status            ~RDA_html_tdh2
prompt ~RDA_html_tdh1 Generation Status ~RDA_html_tdh2
prompt ~RDA_html_tdh1 Group Name        ~RDA_html_tdh2

SELECT '<TR> ~RDA_html_td1'|| r.sname  || '~RDA_html_td2', 
           '~RDA_html_td1' || r.oname  || '~RDA_html_td2', 
           '~RDA_html_td1' || r.status || '~RDA_html_td2', 
           '~RDA_html_td1' || r.generation_status || '~RDA_html_td2', 
           '~RDA_html_td1' || r.gname  || '~RDA_html_td2 </TR>' 
FROM sys.dba_repobject r;
prompt ~RDA_html_tab2

prompt <A NAME="repinfo4"></a>
prompt ~RDA_html_h31 DBA_RepCatlog ~RDA_html_h32
prompt ~RDA_html_tab1
prompt ~RDA_html_tdh1 Status       ~RDA_html_tdh2
prompt ~RDA_html_tdh1 ID           ~RDA_html_tdh2
prompt ~RDA_html_tdh1 Object Name  ~RDA_html_tdh2
prompt ~RDA_html_tdh1 Object Type Status ~RDA_html_tdh2
prompt ~RDA_html_tdh1 Error Number ~RDA_html_tdh2

SELECT '<TR> ~RDA_html_td1'|| r.status  || '~RDA_html_td2', 
           '~RDA_html_td1' || r.id      || '~RDA_html_td2', 
           '~RDA_html_td1' || r.oname   || '~RDA_html_td2', 
           '~RDA_html_td1' || r.type    || '~RDA_html_td2', 
           '~RDA_html_td1' || r.errnum  || '~RDA_html_td2 </TR>' 
FROM sys.dba_repcatlog r;
prompt ~RDA_html_tab2

prompt <A NAME="repinfo5"></a>
prompt ~RDA_html_h31 Transaction Counts ~RDA_html_h32
prompt ~RDA_html_tab1

SELECT '<TR> ~RDA_html_tdc1 DefCall Count ~RDA_html_tdc2'  , 
            '~RDA_html_td1' || count(*) || '~RDA_html_td2 </TR>'
FROM sys.defcall
UNION
SELECT '<TR> ~RDA_html_tdc1 DefTran Count ~RDA_html_tdc2' ,
            '~RDA_html_td1' || count(*) || '~RDA_html_td2 </TR>'
FROM sys.deftran
UNION
SELECT '<TR> ~RDA_html_tdc1 DefCallDest Count ~RDA_html_tdc2' , 
            '~RDA_html_td1' || count(*) || '~RDA_html_td2 </TR>'
FROM sys.defcalldest
UNION
SELECT '<TR> ~RDA_html_tdc1 DefTranDest Count ~RDA_html_tdc2' ,
            '~RDA_html_td1' || count(*) || '~RDA_html_td2 </TR>'
FROM sys.deftrandest
UNION
SELECT '<TR> ~RDA_html_tdc1 DefError Count ~RDA_html_tdc2' , 
            '~RDA_html_td1' || count(*) || '~RDA_html_td2 </TR>'
FROM sys.deferror; 
prompt ~RDA_html_tab2
----------------------------------------------------
prompt <!--[ dbjobs |  DBA Jobs ]-->
prompt <A NAME="dbjobs"></a>

prompt ~RDA_html_h31 DBA Jobs ~RDA_html_h32
prompt ~RDA_html_tab1
prompt ~RDA_html_tdh1 Job Number      ~RDA_html_tdh2
prompt ~RDA_html_tdh1 Logged In User  ~RDA_html_tdh2
prompt ~RDA_html_tdh1 Privilege User  ~RDA_html_tdh2
prompt ~RDA_html_tdh1 Schema User     ~RDA_html_tdh2
prompt ~RDA_html_tdh1 Date Last Run   ~RDA_html_tdh2
prompt ~RDA_html_tdh1 Date Next Run   ~RDA_html_tdh2
prompt ~RDA_html_tdh1 Broken(Y/N)     ~RDA_html_tdh2
prompt ~RDA_html_tdh1 Failures        ~RDA_html_tdh2
prompt ~RDA_html_tdh1 Interval        ~RDA_html_tdh2

SELECT '<TR> ~RDA_html_td1' || j.job         || '~RDA_html_td2', 
            '~RDA_html_td1' || j.log_user    || '~RDA_html_td2', 
            '~RDA_html_td1' || j.priv_user   || '~RDA_html_td2', 
            '~RDA_html_td1' || j.schema_user || '~RDA_html_td2', 
            '~RDA_html_td1' || to_char(j.last_date,'DD-MON-YYYY HH24:MI:SS') || '~RDA_html_td2', 
            '~RDA_html_td1' || to_char(j.next_date,'DD-MON-YYYY HH24:MI:SS') || '~RDA_html_td2', 
            '~RDA_html_td1' || j.broken      || '~RDA_html_td2', 
            '~RDA_html_td1' || j.failures    || '~RDA_html_td2', 
            '~RDA_html_td1' || to_char(j.interval, 'DD-MON-YYYY HH24:MI:SS') || '~RDA_html_td2 </TR>' 
FROM sys.dba_jobs j;
prompt ~RDA_html_tab2
----------------------------------------------------
prompt <!--[ pwdusers | Password File Users ]-->
prompt <A NAME="pwdusers"></a> 

prompt ~RDA_html_h31 V$PWFile_Users ~RDA_html_h32
prompt ~RDA_html_tab1
prompt ~RDA_html_tdh1 User Name           ~RDA_html_tdh2
prompt ~RDA_html_tdh1 SYSDBA Privs        ~RDA_html_tdh2
prompt ~RDA_html_tdh1 SYSOPER Privs (Y/N) ~RDA_html_tdh2

SELECT '<TR> ~RDA_html_td1' || p.username || '~RDA_html_td2', 
            '~RDA_html_td1' || nvl(p.sysdba,'<i>null value</i>')  || '~RDA_html_td2', 
            '~RDA_html_td1' || nvl(p.sysoper,'<i>null value</i>') || '~RDA_html_td2 </TR>' 
FROM v$pwfile_users p;
prompt ~RDA_html_tab2
----------------------------------------------------
prompt <!--[ objaudit | DBA Object Audit Options ]-->
prompt <A NAME="objaudit"></a> 

prompt ~RDA_html_h31 DBA Object Audit Options ~RDA_html_h32
prompt ~RDA_html_tab1
prompt ~RDA_html_tdh1 Owner       ~RDA_html_tdh2
prompt ~RDA_html_tdh1 Object Name ~RDA_html_tdh2
prompt ~RDA_html_tdh1 Object Type ~RDA_html_tdh2
prompt ~RDA_html_tdh1 Alter       ~RDA_html_tdh2
prompt ~RDA_html_tdh1 Audit       ~RDA_html_tdh2
prompt ~RDA_html_tdh1 Comment     ~RDA_html_tdh2
prompt ~RDA_html_tdh1 Delete      ~RDA_html_tdh2
prompt ~RDA_html_tdh1 Grant       ~RDA_html_tdh2
prompt ~RDA_html_tdh1 Index       ~RDA_html_tdh2
prompt ~RDA_html_tdh1 Insert      ~RDA_html_tdh2
prompt ~RDA_html_tdh1 Lock        ~RDA_html_tdh2
prompt ~RDA_html_tdh1 Rename      ~RDA_html_tdh2
prompt ~RDA_html_tdh1 Select      ~RDA_html_tdh2
prompt ~RDA_html_tdh1 Update      ~RDA_html_tdh2
prompt ~RDA_html_tdh1 Reference   ~RDA_html_tdh2
prompt ~RDA_html_tdh1 Create Name ~RDA_html_tdh2
prompt ~RDA_html_tdh1 Read Name   ~RDA_html_tdh2
prompt ~RDA_html_tdh1 Write Name  ~RDA_html_tdh2
prompt ~RDA_html_tdh1 Execute     ~RDA_html_tdh2

SELECT '<TR> ~RDA_html_td1' || nvl(o.owner,'<i>null value</i>') || '~RDA_html_td2', 
            '~RDA_html_td1' || nvl(o.object_name,'<i>null value</i>') || '~RDA_html_td2', 
            '~RDA_html_td1' || nvl(o.object_type,'<i>null value</i>') || '~RDA_html_td2', 
            '~RDA_html_td1' || nvl(o.alt,'<i>null value</i>') || '~RDA_html_td2', 
            '~RDA_html_td1' || nvl(o.aud,'<i>null value</i>') || '~RDA_html_td2', 
            '~RDA_html_td1' || nvl(o.com,'<i>null value</i>') || '~RDA_html_td2', 
            '~RDA_html_td1' || nvl(o.del,'<i>null value</i>') || '~RDA_html_td2', 
            '~RDA_html_td1' || nvl(o.gra,'<i>null value</i>') || '~RDA_html_td2', 
            '~RDA_html_td1' || nvl(o.ind,'<i>null value</i>') || '~RDA_html_td2', 
            '~RDA_html_td1' || nvl(o.ins,'<i>null value</i>') || '~RDA_html_td2', 
            '~RDA_html_td1' || nvl(o.loc,'<i>null value</i>') || '~RDA_html_td2', 
            '~RDA_html_td1' || nvl(o.ren,'<i>null value</i>') || '~RDA_html_td2', 
            '~RDA_html_td1' || nvl(o.sel,'<i>null value</i>') || '~RDA_html_td2', 
            '~RDA_html_td1' || nvl(o.upd,'<i>null value</i>') || '~RDA_html_td2', 
            '~RDA_html_td1' || nvl(o.ref,'<i>null value</i>') || '~RDA_html_td2', 
            '~RDA_html_td1' || nvl(o.cre,'<i>null value</i>') || '~RDA_html_td2',
            '~RDA_html_td1' || nvl(o.rea,'<i>null value</i>') || '~RDA_html_td2',
            '~RDA_html_td1' || nvl(o.wri,'<i>null value</i>') || '~RDA_html_td2',
            '~RDA_html_td1' || nvl(o.exe,'<i>null value</i>') || '~RDA_html_td2 </TR>'
FROM sys.dba_obj_audit_opts o
WHERE (o.alt not in ('-/-','/  ')
   OR  o.aud not in ('-/-','/  ')
   OR  o.com not in ('-/-','/  ')
   OR  o.del not in ('-/-','/  ')
   OR  o.gra not in ('-/-','/  ')
   OR  o.ind not in ('-/-','/  ')
   OR  o.ins not in ('-/-','/  ')
   OR  o.loc not in ('-/-','/  ')
   OR  o.ren not in ('-/-','/  ')
   OR  o.sel not in ('-/-','/  ')
   OR  o.upd not in ('-/-','/  ')
   OR  o.ref not in ('-/-','/  ')
   OR  o.cre not in ('-/-','/  ')
   OR  o.rea not in ('-/-','/  ')
   OR  o.wri not in ('-/-','/  ')
   OR  o.exe not in ('-/-','/  '))
   AND object_name not like 'SYS_IOT_OVER%';
prompt ~RDA_html_tab2
----------------------------------------------------
prompt <!--[ alldefaudopt | All_Def_Audit_Opts ]-->
prompt <A NAME="alldefaudopt"></a> 

prompt ~RDA_html_h31 All_Def_Audit_Opts ~RDA_html_h32
prompt ~RDA_html_tab1
prompt ~RDA_html_tdh1 Alter     ~RDA_html_tdh2
prompt ~RDA_html_tdh1 Audit     ~RDA_html_tdh2
prompt ~RDA_html_tdh1 Comment   ~RDA_html_tdh2
prompt ~RDA_html_tdh1 Delete    ~RDA_html_tdh2
prompt ~RDA_html_tdh1 Grant     ~RDA_html_tdh2
prompt ~RDA_html_tdh1 Index     ~RDA_html_tdh2
prompt ~RDA_html_tdh1 Insert    ~RDA_html_tdh2
prompt ~RDA_html_tdh1 Lock      ~RDA_html_tdh2
prompt ~RDA_html_tdh1 Rename    ~RDA_html_tdh2
prompt ~RDA_html_tdh1 Select    ~RDA_html_tdh2
prompt ~RDA_html_tdh1 Update    ~RDA_html_tdh2
prompt ~RDA_html_tdh1 Reference ~RDA_html_tdh2
prompt ~RDA_html_tdh1 Execute   ~RDA_html_tdh2

SELECT '<TR> ~RDA_html_td1' || nvl(a.alt,'<i>null value</i>') || '~RDA_html_td2', 
            '~RDA_html_td1' || nvl(a.aud,'<i>null value</i>') || '~RDA_html_td2', 
            '~RDA_html_td1' || nvl(a.com,'<i>null value</i>') || '~RDA_html_td2', 
            '~RDA_html_td1' || nvl(a.del,'<i>null value</i>') || '~RDA_html_td2', 
            '~RDA_html_td1' || nvl(a.gra,'<i>null value</i>') || '~RDA_html_td2', 
            '~RDA_html_td1' || nvl(a.ind,'<i>null value</i>') || '~RDA_html_td2', 
            '~RDA_html_td1' || nvl(a.ins,'<i>null value</i>') || '~RDA_html_td2', 
            '~RDA_html_td1' || nvl(a.loc,'<i>null value</i>') || '~RDA_html_td2', 
            '~RDA_html_td1' || nvl(a.ren,'<i>null value</i>') || '~RDA_html_td2', 
            '~RDA_html_td1' || nvl(a.sel,'<i>null value</i>') || '~RDA_html_td2', 
            '~RDA_html_td1' || nvl(a.upd,'<i>null value</i>') || '~RDA_html_td2', 
            '~RDA_html_td1' || nvl(a.ref,'<i>null value</i>') || '~RDA_html_td2', 
            '~RDA_html_td1' || nvl(a.exe,'<i>null value</i>') || '~RDA_html_td2 </TR>' 
FROM sys.all_def_audit_opts a;
prompt ~RDA_html_tab2
----------------------------------------------------
prompt <!--[ dbaprofiles | DBA Profiles ]-->
prompt <A NAME="dbaprofiles"></a> 

prompt ~RDA_html_h31 DBA Profiles ~RDA_html_h32
prompt ~RDA_html_tab1
prompt ~RDA_html_tdh1 Profile       ~RDA_html_tdh2
prompt ~RDA_html_tdh1 Resource Name ~RDA_html_tdh2
prompt ~RDA_html_tdh1 Limit         ~RDA_html_tdh2

SELECT '<TR> ~RDA_html_td1' || p.profile       || '~RDA_html_td2', 
            '~RDA_html_td1' || p.resource_name || '~RDA_html_td2', 
            '~RDA_html_td1' || nvl(p.limit,'<i>null value</i>') || '~RDA_html_td2 </TR>' 
FROM sys.dba_profiles p
WHERE p.resource_type = 'PASSWORD'
ORDER BY p.profile;
prompt ~RDA_html_tab2
----------------------------------------------------
prompt <!--[ dbausers | DBA Users ]-->
prompt <A NAME="dbausers"></a> 

prompt ~RDA_html_h31 DBA Users ~RDA_html_h32
prompt ~RDA_html_h41 NOTE: Only display users who have expiration date set. ~RDA_html_h42

prompt ~RDA_html_tab1
prompt ~RDA_html_tdh1 User Name   ~RDA_html_tdh2
prompt ~RDA_html_tdh1 Lock Date   ~RDA_html_tdh2
prompt ~RDA_html_tdh1 Expiry Date ~RDA_html_tdh2
prompt ~RDA_html_tdh1 Profile     ~RDA_html_tdh2
SELECT '<TR> ~RDA_html_td1' || u.username || '~RDA_html_td2', 
            '~RDA_html_td1' || nvl(to_char(u.lock_date  ,'DD-MON-YYYY HH24:MI:SS'),'<i>null value</i>') || '~RDA_html_td2', 
            '~RDA_html_td1' || nvl(to_char(u.expiry_date,'DD-MON-YYYY HH24:MI:SS'),'<i>null value</i>') || '~RDA_html_td2', 
            '~RDA_html_td1' || u.profile || '~RDA_html_td2 </TR>' 
FROM sys.dba_users u
WHERE u.lock_date   is not null
OR    u.expiry_date is not null
ORDER BY u.username;
prompt ~RDA_html_tab2
----------------------------------------------------
prompt <!--[ invalid | Invalid Objects ]-->
prompt <A NAME="invalid"></a> 

prompt ~RDA_html_h31 Invalid Objects ~RDA_html_h32
prompt ~RDA_html_tab1
prompt ~RDA_html_tdh1 Owner         ~RDA_html_tdh2
prompt ~RDA_html_tdh1 Object Name   ~RDA_html_tdh2
prompt ~RDA_html_tdh1 Object Type   ~RDA_html_tdh2
prompt ~RDA_html_tdh1 Created       ~RDA_html_tdh2
prompt ~RDA_html_tdh1 Last DDL Time ~RDA_html_tdh2

SELECT '<TR> ~RDA_html_td1' || o.owner       || '~RDA_html_td2',
            '~RDA_html_td1' || o.object_name || '~RDA_html_td2', 
            '~RDA_html_td1' || o.object_type || '~RDA_html_td2', 
            '~RDA_html_td1' || to_char(o.created,'DD-MON-YYYY HH24:MI') || '~RDA_html_td2', 
            '~RDA_html_td1' || to_char(o.last_ddl_time,'DD-MON-YYYY HH24:MI')|| '~RDA_html_td2 </TR>'
FROM sys.dba_objects o
WHERE status !='VALID'
ORDER BY o.owner, o.object_name;
prompt ~RDA_html_tab2
----------------------------------------------------
prompt <!--[ dbaerrors | DBA Errors ]-->
prompt <A NAME="dbaerrors"></a> 

prompt ~RDA_html_h31 DBA Errors ~RDA_html_h32
prompt ~RDA_html_tab1
prompt ~RDA_html_tdh1 Owner            ~RDA_html_tdh2
prompt ~RDA_html_tdh1 Name             ~RDA_html_tdh2
prompt ~RDA_html_tdh1 Line / Position  ~RDA_html_tdh2
prompt ~RDA_html_tdh1 Text             ~RDA_html_tdh2

SELECT '<TR> ~RDA_html_td1' || e.owner || '~RDA_html_td2',
            '~RDA_html_td1' || e.name  || '~RDA_html_td2',
            '~RDA_html_td1' || to_char(e.line) || '/' || to_char(e.position) || '~RDA_html_td2', 
            '~RDA_html_td1' || e.text  || '~RDA_html_td2 </TR>'
FROM dba_errors e
ORDER BY e.owner, e.name, e.sequence;
prompt ~RDA_html_tab2

----------------------------------------------------
-- Now run Version specific SQLs :
Start rda_v.sql

prompt </BODY></HTML>

spool off 
-- rda_db.htm



-- Location of the trace files, this will be used later :
spool traces.txt
 select 'UDUMP|'|| value from v$parameter where lower(name) = 'user_dump_dest'
union
 select 'BDUMP|'|| value from v$parameter where lower(name) = 'background_dump_dest'
union
 select 'CDUMP|'|| value from v$parameter where lower(name) = 'core_dump_dest'
union
 select 'INSTANCE|' || instance_name from v$instance
union
 select 'VERSION|' || version from v$instance;

spool off

exit
