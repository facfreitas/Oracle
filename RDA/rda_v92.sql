REM rda_v92.sql
prompt <HR>
prompt <!--[ v92 | Version Specific ]-->
prompt <a name="v92"></a>
prompt ~RDA_html_h31 Version Specific ~RDA_html_h32

prompt <!--[ timezone | Time Zones ]-->
prompt <a name="timezone"></a>
prompt ~RDA_html_h31 Time Zones ~RDA_html_h32
prompt ~RDA_html_tab1
prompt ~RDA_html_tdh1 Session TimeZone  ~RDA_html_tdh2
prompt ~RDA_html_tdh1 Database TimeZone ~RDA_html_tdh2

SELECT '<TR> ~RDA_html_td1' || sessiontimezone || '~RDA_html_td2',
            '~RDA_html_td1' || dbtimezone      || '~RDA_html_td2 </TR>'
from dual;
prompt ~RDA_html_tab2
----------------------------------------------------
prompt <!--[ java | Java Objects ]-->
prompt <A NAME="java"></a>
prompt ~RDA_html_h31 Java Objects ~RDA_html_h32
prompt ~RDA_html_tab1
prompt ~RDA_html_tdh1 Owner           ~RDA_html_tdh2
prompt ~RDA_html_tdh1 Total Objects   ~RDA_html_tdh2
prompt ~RDA_html_tdh1 Invalid Objects ~RDA_html_tdh2

SELECT '<TR> ~RDA_html_td1' || o.owner           || '~RDA_html_td2',
            '~RDA_html_td1' || o.objects         || '~RDA_html_td2',
            '~RDA_html_td1' || nvl(i.invalids,0) || '~RDA_html_td2 </TR>'
FROM (SELECT owner, count(*) objects
         FROM dba_objects 
         WHERE object_type like 'JAVA%'
         GROUP by owner) o,
        (SELECT owner, count(*) invalids
         FROM dba_objects 
         WHERE object_type like 'JAVA%'
            and status = 'INVALID' 
         GROUP by owner) i
WHERE o.owner=i.owner(+);
prompt ~RDA_html_tab2

prompt ~RDA_html_h31 Java Roles ~RDA_html_h32
prompt ~RDA_html_tab1
prompt ~RDA_html_tdh1 Role Name ~RDA_html_tdh2

SELECT '<TR> ~RDA_html_td1' || r.role || '~RDA_html_td2 </TR>'
FROM dba_roles r
WHERE role like 'JAVA%';
prompt ~RDA_html_tab2

prompt ~RDA_html_h31 Oracle Supplied Java Users ~RDA_html_h32
prompt ~RDA_html_tab1
prompt ~RDA_html_tdh1 User Name     ~RDA_html_tdh2
prompt ~RDA_html_tdh1 User ID       ~RDA_html_tdh2
prompt ~RDA_html_tdh1 Creation Date ~RDA_html_tdh2

SELECT '<TR> ~RDA_html_td1' || u.username || '~RDA_html_td2',
            '~RDA_html_td1' || u.user_id  || '~RDA_html_td2',
            '~RDA_html_td1' || to_char(created, 'DD-MON-YYYY HH24:MI') || '~RDA_html_td2 </TR>'
FROM dba_users u
where username like 'OSE%'
or username like 'AURORA%';
prompt ~RDA_html_tab2
----------------------------------------------------

prompt <!--[ rbs | Rollback Segments ]-->
prompt <A NAME="rbs"></a> 
prompt ~RDA_html_h31 Rollback Segments ~RDA_html_h32

-- If AUM is not set
select '~RDA_html_h31 v$rollstat ~RDA_html_h32' ,
       '~RDA_html_tab1',
       '~RDA_html_tdh1 Undo Segment Number   ~RDA_html_tdh2',
       '~RDA_html_tdh1 Extents               ~RDA_html_tdh2',
       '~RDA_html_tdh1 Segment Size          ~RDA_html_tdh2',
       '~RDA_html_tdh1 Active Xacts          ~RDA_html_tdh2',
       '~RDA_html_tdh1 Optimal               ~RDA_html_tdh2',
       '~RDA_html_tdh1 High Water Mark       ~RDA_html_tdh2',
       '~RDA_html_tdh1 Shrinks               ~RDA_html_tdh2',
       '~RDA_html_tdh1 Wraps                 ~RDA_html_tdh2',
       '~RDA_html_tdh1 Extends               ~RDA_html_tdh2',
       '~RDA_html_tdh1 Status                ~RDA_html_tdh2',
       '~RDA_html_tdh1 Current Extent        ~RDA_html_tdh2',
       '~RDA_html_tdh1 Current Block         ~RDA_html_tdh2'
from dual 
where 'MANUAL' = ( select value from v$parameter where name ='undo_management') ;

SELECT '<TR> ~RDA_html_td1' || v.usn     || '~RDA_html_td2',
            '~RDA_html_td1' || v.extents || '~RDA_html_td2', 
            '~RDA_html_td1' || v.rssize  || '~RDA_html_td2', 
            '~RDA_html_td1' || v.xacts   || '~RDA_html_td2', 
            '~RDA_html_td1' || nvl(v.optsize,0)  || '~RDA_html_td2', 
            '~RDA_html_td1' || v.hwmsize || '~RDA_html_td2', 
            '~RDA_html_td1' || v.shrinks || '~RDA_html_td2', 
            '~RDA_html_td1' || v.wraps   || '~RDA_html_td2', 
            '~RDA_html_td1' || v.extends || '~RDA_html_td2', 
            '~RDA_html_td1' || v.status  || '~RDA_html_td2', 
            '~RDA_html_td1' || v.curext  || '~RDA_html_td2', 
            '~RDA_html_td1' || v.curblk  || '~RDA_html_td2 </TR>'
FROM V$rollstat v
WHERE 'MANUAL' = ( select value from v$parameter where name ='undo_management') ;

select '~RDA_html_tab2'
from dual 
where 'MANUAL' = ( select value from v$parameter where name ='undo_management');

select '~RDA_html_h31 DBA_ROLLBACK_SEGS ~RDA_html_h32',
       '~RDA_html_tab1',
       '~RDA_html_tdh1 Segment Name     ~RDA_html_tdh2',
       '~RDA_html_tdh1 Segment ID       ~RDA_html_tdh2',
       '~RDA_html_tdh1 Owner            ~RDA_html_tdh2',
       '~RDA_html_tdh1 Tablespace Name  ~RDA_html_tdh2',
       '~RDA_html_tdh1 File ID          ~RDA_html_tdh2',
       '~RDA_html_tdh1 Block ID         ~RDA_html_tdh2',
       '~RDA_html_tdh1 Initial          ~RDA_html_tdh2',
       '~RDA_html_tdh1 Next             ~RDA_html_tdh2',
       '~RDA_html_tdh1 Min Extents      ~RDA_html_tdh2',
       '~RDA_html_tdh1 Max Extents      ~RDA_html_tdh2',
       '~RDA_html_tdh1 PCT Increase     ~RDA_html_tdh2',
       '~RDA_html_tdh1 Status           ~RDA_html_tdh2',
       '~RDA_html_tdh1 Instance Number  ~RDA_html_tdh2',
       '~RDA_html_tdh1 Relative File#   ~RDA_html_tdh2'
from dual where 'MANUAL' = ( select value from v$parameter where name ='undo_management') ;

SELECT '<TR> ~RDA_html_td1' || v.segment_name    || '~RDA_html_td2',
            '~RDA_html_td1' || v.segment_id      || '~RDA_html_td2', 
            '~RDA_html_td1' || v.owner           || '~RDA_html_td2', 
            '~RDA_html_td1' || v.tablespace_name || '~RDA_html_td2', 
            '~RDA_html_td1' || v.file_id         || '~RDA_html_td2', 
            '~RDA_html_td1' || v.block_id        || '~RDA_html_td2', 
            '~RDA_html_td1' || v.initial_extent  || '~RDA_html_td2', 
            '~RDA_html_td1' || v.next_extent     || '~RDA_html_td2', 
            '~RDA_html_td1' || v.min_extents     || '~RDA_html_td2', 
            '~RDA_html_td1' || v.max_extents     || '~RDA_html_td2', 
            '~RDA_html_td1' || v.pct_increase    || '~RDA_html_td2', 
            '~RDA_html_td1' || v.status          || '~RDA_html_td2', 
            '~RDA_html_td1' || nvl(v.instance_num, '<i>null value</i>')  || '~RDA_html_td2', 
            '~RDA_html_td1' || v.relative_fno    || '~RDA_html_td2 </TR>'
FROM dba_rollback_segs v
WHERE 'MANUAL' = ( select value from v$parameter where name ='undo_management') ;

select '~RDA_html_tab2'
from dual where 'MANUAL' = ( select value from v$parameter where name ='undo_management') ;

-- If AUM is set
select '~RDA_html_h31 V$UNDOSTAT ~RDA_html_h32',
       '~RDA_html_tab1',
       '~RDA_html_tdh1 Begin Time             ~RDA_html_tdh2',
       '~RDA_html_tdh1 End Time               ~RDA_html_tdh2',
       '~RDA_html_tdh1 Undo Tablespace #      ~RDA_html_tdh2',
       '~RDA_html_tdh1 Undo Blocks Used       ~RDA_html_tdh2',
       '~RDA_html_tdh1 Xact Count             ~RDA_html_tdh2',
       '~RDA_html_tdh1 Max Query Length       ~RDA_html_tdh2',
       '~RDA_html_tdh1 Max Concurrency        ~RDA_html_tdh2',
       '~RDA_html_tdh1 Unexpired Steal Count  ~RDA_html_tdh2',
       '~RDA_html_tdh1 Unexpired Block Release Count ~RDA_html_tdh2',
       '~RDA_html_tdh1 Unexpired Block Reuse Count   ~RDA_html_tdh2',
       '~RDA_html_tdh1 Expired Steal Count           ~RDA_html_tdh2',
       '~RDA_html_tdh1 Expired Block Release Count   ~RDA_html_tdh2',
       '~RDA_html_tdh1 Expired Block Reuse Count     ~RDA_html_tdh2',
       '~RDA_html_tdh1 Snapshot Too Old Errors Count ~RDA_html_tdh2',
       '~RDA_html_tdh1 No Space Errors Count        ~RDA_html_tdh2'
from dual 
where 'AUTO' = ( select value from v$parameter where name ='undo_management') ;


SELECT '<TR> ~RDA_html_td1'|| to_char(v.begin_time,'DD-MON-YYYY HH24:MI:SS') || '~RDA_html_td2',
           '~RDA_html_td1' || to_char(v.end_time,'DD-MON-YYYY HH24:MI:SS') || '~RDA_html_td2', 
           '~RDA_html_td1' || v.undotsn        || '~RDA_html_td2', 
           '~RDA_html_td1' || v.undoblks       || '~RDA_html_td2', 
           '~RDA_html_td1' || v.txncount       || '~RDA_html_td2', 
           '~RDA_html_td1' || v.maxquerylen    || '~RDA_html_td2', 
           '~RDA_html_td1' || v.maxconcurrency || '~RDA_html_td2', 
           '~RDA_html_td1' || v.unxpstealcnt   || '~RDA_html_td2', 
           '~RDA_html_td1' || v.unxpblkrelcnt  || '~RDA_html_td2', 
           '~RDA_html_td1' || v.unxpblkreucnt  || '~RDA_html_td2', 
           '~RDA_html_td1' || v.expstealcnt    || '~RDA_html_td2', 
           '~RDA_html_td1' || v.expblkrelcnt   || '~RDA_html_td2', 
           '~RDA_html_td1' || v.expblkreucnt   || '~RDA_html_td2', 
           '~RDA_html_td1' || v.ssolderrcnt    || '~RDA_html_td2', 
           '~RDA_html_td1' || v.nospaceerrcnt  || '~RDA_html_td2 </TR>'
FROM V$undostat v
where 'AUTO' = ( select value from v$parameter where name ='undo_management') ;

select '~RDA_html_tab2'
from dual where 'AUTO' = ( select value from v$parameter where name ='undo_management') ;


select '~RDA_html_h31 DBA_UNDO_EXTENTS ~RDA_html_h32',
       '~RDA_html_tab1',
       '~RDA_html_tdh1 Owner           ~RDA_html_tdh2',
       '~RDA_html_tdh1 Segment Name    ~RDA_html_tdh2',
       '~RDA_html_tdh1 Tablespace Name ~RDA_html_tdh2',
       '~RDA_html_tdh1 Extent ID       ~RDA_html_tdh2',
       '~RDA_html_tdh1 File ID         ~RDA_html_tdh2',
       '~RDA_html_tdh1 Block ID        ~RDA_html_tdh2',
       '~RDA_html_tdh1 Bytes           ~RDA_html_tdh2',
       '~RDA_html_tdh1 Blocks          ~RDA_html_tdh2',
       '~RDA_html_tdh1 Relative File Number     ~RDA_html_tdh2',
       '~RDA_html_tdh1 Commit Time (Julian)     ~RDA_html_tdh2',
       '~RDA_html_tdh1 Commit Time (Wall Clock) ~RDA_html_tdh2',
       '~RDA_html_tdh1 Status                   ~RDA_html_tdh2'
from dual where 'AUTO' = ( select value from v$parameter where name ='undo_management') ;

SELECT '<TR> ~RDA_html_td1'|| v.owner           || '~RDA_html_td2',
           '~RDA_html_td1' || v.segment_name    || '~RDA_html_td2', 
           '~RDA_html_td1' || v.tablespace_name || '~RDA_html_td2', 
           '~RDA_html_td1' || v.extent_id       || '~RDA_html_td2', 
           '~RDA_html_td1' || v.file_id         || '~RDA_html_td2', 
           '~RDA_html_td1' || v.block_id        || '~RDA_html_td2', 
           '~RDA_html_td1' || v.bytes           || '~RDA_html_td2', 
           '~RDA_html_td1' || v.blocks          || '~RDA_html_td2', 
           '~RDA_html_td1' || v.relative_fno    || '~RDA_html_td2', 
           '~RDA_html_td1' || v.commit_jtime    || '~RDA_html_td2', 
           '~RDA_html_td1' || nvl(v.commit_wtime,'<i>null value</i>') || '~RDA_html_td2', 
           '~RDA_html_td1' || v.status          || '~RDA_html_td2 </TR>'
FROM dba_undo_extents v
where 'AUTO' = ( select value from v$parameter where name ='undo_management') ;

select '~RDA_html_tab2'
from dual where 'AUTO' = ( select value from v$parameter where name ='undo_management') ;

----------------------------------------------------
----------------------------------------------------
----------------------------------------------------
prompt <!--[ 92ts | Tablespaces ]-->
prompt <A NAME="92ts"></a>
prompt ~RDA_html_h31 Tablespaces ~RDA_html_h32
prompt ~RDA_html_tab1
prompt ~RDA_html_tdh1 Status         ~RDA_html_tdh2
prompt ~RDA_html_tdh1 Name           ~RDA_html_tdh2
prompt ~RDA_html_tdh1 Type           ~RDA_html_tdh2
prompt ~RDA_html_tdh1 Extent Management ~RDA_html_tdh2
prompt ~RDA_html_tdh1 Size (M)       ~RDA_html_tdh2
prompt ~RDA_html_tdh1 Used (M)       ~RDA_html_tdh2
prompt ~RDA_html_tdh1 Used %         ~RDA_html_tdh2
prompt ~RDA_html_tdh1 Initial Extent ~RDA_html_tdh2
prompt ~RDA_html_tdh1 Next Extent    ~RDA_html_tdh2
prompt ~RDA_html_tdh1 Largest Free Extent ~RDA_html_tdh2

SELECT '<TR> ~RDA_html_td1' || d.status              || '~RDA_html_td2',
            '~RDA_html_td1' || d.tablespace_name     || '~RDA_html_td2', 
            '~RDA_html_td1' || d.contents            || '~RDA_html_td2', 
            '~RDA_html_td1' || d.extent_management   || '~RDA_html_td2', 
            '~RDA_html_td1' || TO_CHAR(NVL(a.bytes / 1024 / 1024, 0),'99G999G990D900') || '~RDA_html_td2',
            '~RDA_html_td1' || TO_CHAR(NVL(a.bytes - NVL(f.bytes, 0), 0)/1024/1024 ,'99G999G990D900') || '~RDA_html_td2',
            '~RDA_html_td1' || TO_CHAR(NVL((a.bytes - NVL(f.bytes, 0)) / a.bytes * 100, 0), '990D00') || '~RDA_html_td2', 
            '~RDA_html_td1' || d.initial_extent      || '~RDA_html_td2', 
            '~RDA_html_td1' || NVL(d.next_extent, 0) || '~RDA_html_td2',
            '~RDA_html_td1' || TO_CHAR(NVL(f.largest_free / 1024 / 1024, 0),'99G999G990D900') || '~RDA_html_td2 </TR>'
FROM sys.dba_tablespaces d, 
           (select tablespace_name, sum(bytes) bytes from dba_data_files group by tablespace_name) a, 
           (select tablespace_name, sum(bytes) bytes, max(bytes) largest_free from dba_free_space group by tablespace_name) f 
WHERE d.tablespace_name = a.tablespace_name 
AND   d.tablespace_name = f.tablespace_name;
prompt ~RDA_html_tab2
----------------------------------------------------
prompt <!--[ 92lmts | LM Tablespaces ]-->
prompt <A NAME="92lmts"></a>
prompt ~RDA_html_h31 Locally Managed Temporary Tablespaces ~RDA_html_h32
prompt ~RDA_html_tab1
prompt ~RDA_html_tdh1 Status   ~RDA_html_tdh2
prompt ~RDA_html_tdh1 Name     ~RDA_html_tdh2
prompt ~RDA_html_tdh1 Size (M) ~RDA_html_tdh2

SELECT '<TR> ~RDA_html_td1' || d.status           || '~RDA_html_td2',
            '~RDA_html_td1' || d.tablespace_name  || '~RDA_html_td2', 
            '~RDA_html_td1' || TO_CHAR(NVL(a.bytes / 1024 / 1024, 0),'99G999G990D900') || '~RDA_html_td2 </TR>'
FROM sys.dba_tablespaces d, 
     (select tablespace_name, sum(bytes) bytes from dba_temp_files group by tablespace_name) a
WHERE d.tablespace_name = a.tablespace_name;
prompt ~RDA_html_tab2
----------------------------------------------------
prompt <!--[ 92dfs | Database Files ]-->
prompt <A NAME="92dfs"></a>
prompt ~RDA_html_h31 Database Files ~RDA_html_h32
prompt ~RDA_html_tab1
prompt ~RDA_html_tdh1 Status         ~RDA_html_tdh2
prompt ~RDA_html_tdh1 Name           ~RDA_html_tdh2
prompt ~RDA_html_tdh1 Tablespace     ~RDA_html_tdh2
prompt ~RDA_html_tdh1 File Number    ~RDA_html_tdh2
prompt ~RDA_html_tdh1 Relative File Number ~RDA_html_tdh2
prompt ~RDA_html_tdh1 Size           ~RDA_html_tdh2
prompt ~RDA_html_tdh1 Used (M)       ~RDA_html_tdh2
prompt ~RDA_html_tdh1 Used (%)       ~RDA_html_tdh2
prompt ~RDA_html_tdh1 Autoextensible ~RDA_html_tdh2

SELECT '<TR> ~RDA_html_td1' || v.status          || '~RDA_html_td2',
            '~RDA_html_td1' || d.file_name       || '~RDA_html_td2',
            '~RDA_html_td1' || d.tablespace_name || '~RDA_html_td2',
            '~RDA_html_td1' || d.file_id         || '~RDA_html_td2',
            '~RDA_html_td1' || d.relative_fno    || '~RDA_html_td2',
            '~RDA_html_td1' || TO_CHAR((d.bytes / 1024 / 1024), '99999990D000') || '~RDA_html_td2',
            '~RDA_html_td1' || TO_CHAR(NVL((d.bytes - NVL(s.bytes, 0))/1024/1024, 0), '99999990D000') || '~RDA_html_td2',
            '~RDA_html_td1' || TO_CHAR((NVL(d.bytes - s.bytes, d.bytes) / d.bytes * 100), '990D00') || '~RDA_html_td2',
            '~RDA_html_td1' || NVL(d.autoextensible, 'NO') || '~RDA_html_td2 </TR>'
FROM sys.dba_data_files d, v$datafile v,
     (SELECT file_id, SUM(bytes) bytes  FROM sys.dba_free_space  GROUP BY file_id) s 
WHERE (s.file_id (+)= d.file_id) 
AND   (d.file_name = v.name);
prompt ~RDA_html_tab2
----------------------------------------------------
prompt <!--[ 92tfs | Temporary Files ]-->
prompt <A NAME="92tfs"></a>
prompt ~RDA_html_h31 Temporary Files ~RDA_html_h32
prompt ~RDA_html_tab1
prompt ~RDA_html_tdh1 Status     ~RDA_html_tdh2
prompt ~RDA_html_tdh1 Name       ~RDA_html_tdh2
prompt ~RDA_html_tdh1 Tablespace ~RDA_html_tdh2
prompt ~RDA_html_tdh1 File Number    ~RDA_html_tdh2
prompt ~RDA_html_tdh1 Relative File Number ~RDA_html_tdh2
prompt ~RDA_html_tdh1 Size (M)   ~RDA_html_tdh2

SELECT '<TR> ~RDA_html_td1' || v.status          || '~RDA_html_td2', 
            '~RDA_html_td1' || d.file_name       || '~RDA_html_td2', 
            '~RDA_html_td1' || d.tablespace_name || '~RDA_html_td2', 
            '~RDA_html_td1' || d.file_id         || '~RDA_html_td2',
            '~RDA_html_td1' || d.relative_fno    || '~RDA_html_td2',
            '~RDA_html_td1' || TO_CHAR((d.bytes / 1024 / 1024), '99999990D000') || '~RDA_html_td2 </TR>' 
FROM sys.dba_temp_files d, v$tempfile v
WHERE (d.file_name = v.name);
prompt ~RDA_html_tab2
----------------------------------------------------
prompt <!--[ 92dbasao | DBA Stmt Audit Options ]-->
prompt <A NAME="92dbasao"></a> 

prompt ~RDA_html_h31 DBA_Stmt_Audit_Opts ~RDA_html_h32
prompt ~RDA_html_tab1
prompt ~RDA_html_tdh1 User Name     ~RDA_html_tdh2
prompt ~RDA_html_tdh1 Proxy Name    ~RDA_html_tdh2
prompt ~RDA_html_tdh1 Audit Option  ~RDA_html_tdh2
prompt ~RDA_html_tdh1 Success       ~RDA_html_tdh2
prompt ~RDA_html_tdh1 Failure       ~RDA_html_tdh2

SELECT '<TR> ~RDA_html_td1' || nvl(s.user_name,'<i>null value</i>') || '~RDA_html_td2', 
            '~RDA_html_td1' || nvl(s.proxy_name,'<i>null value</i>')|| '~RDA_html_td2',
            '~RDA_html_td1' || s.audit_option                       || '~RDA_html_td2',
            '~RDA_html_td1' || nvl(s.success,'<i>null value</i>')   || '~RDA_html_td2', 
            '~RDA_html_td1' || nvl(s.failure,'<i>null value</i>')   || '~RDA_html_td2 </TR>' 
FROM sys.dba_stmt_audit_opts s;
prompt ~RDA_html_tab2

----------------------------------------------------
prompt <!--[ 92dbapao | DBA_Priv Audit Options ]-->
prompt <A NAME="92dbapao"></a> 

prompt ~RDA_html_h31 DBA_Priv_Audit_Opts ~RDA_html_h32
prompt ~RDA_html_tab1
prompt ~RDA_html_tdh1 User Name   ~RDA_html_tdh2
prompt ~RDA_html_tdh1 Proxy Name  ~RDA_html_tdh2
prompt ~RDA_html_tdh1 Privilege   ~RDA_html_tdh2
prompt ~RDA_html_tdh1 Success     ~RDA_html_tdh2
prompt ~RDA_html_tdh1 Failure     ~RDA_html_tdh2

SELECT '<TR> ~RDA_html_td1' || nvl(p.user_name,'<i>null value</i>') || '~RDA_html_td2', 
            '~RDA_html_td1' || nvl(p.proxy_name,'<i>null value</i>')|| '~RDA_html_td2',
            '~RDA_html_td1' || p.privilege                          || '~RDA_html_td2',
            '~RDA_html_td1' || nvl(p.success,'<i>null value</i>')   || '~RDA_html_td2', 
            '~RDA_html_td1' || nvl(p.failure,'<i>null value</i>')   || '~RDA_html_td2 </TR>' 
FROM sys.dba_priv_audit_opts p;
prompt ~RDA_html_tab2
----------------------------------------------------
prompt <!--[ 81spatial | Spatial Information ]-->
prompt <A NAME="81spatial"></a> 

prompt ~RDA_html_h31 Spatial Information ~RDA_html_h32

prompt ~RDA_html_h31 Spatial-Version ~RDA_html_h32 
prompt ~RDA_html_tab1 
prompt ~RDA_html_tdh1 SDO_VERSION ~RDA_html_tdh2 

SELECT '<TR> ~RDA_html_td1' || sdo_admin.sdo_version || '~RDA_html_td2 </TR>' 
FROM dual; 
prompt ~RDA_html_tab2

prompt ~RDA_html_h31 List and Status of installed Spatial Objects  ~RDA_html_h32 
prompt ~RDA_html_tab1 
prompt ~RDA_html_tdh1 Object_Name ~RDA_html_tdh2 
prompt ~RDA_html_tdh1 Object_Type ~RDA_html_tdh2 
prompt ~RDA_html_tdh1 Status      ~RDA_html_tdh2 

SELECT '<TR> ~RDA_html_td1' || object_name || '~RDA_html_td2',
            '~RDA_html_td1' || object_type || '~RDA_html_td2',
            '~RDA_html_td1' || status      || '~RDA_html_td2 </TR>' 
from dba_objects 
where owner='MDSYS' 
order by object_name; 
prompt ~RDA_html_tab2

prompt ~RDA_html_h31 Privileges on Spatial Objects ~RDA_html_h32 
prompt ~RDA_html_tab1 
prompt ~RDA_html_tdh1 Grantor    ~RDA_html_tdh2 
prompt ~RDA_html_tdh1 Grantee    ~RDA_html_tdh2 
prompt ~RDA_html_tdh1 Table_name ~RDA_html_tdh2 
prompt ~RDA_html_tdh1 Privilege  ~RDA_html_tdh2 
prompt ~RDA_html_tdh1 Grantable  ~RDA_html_tdh2 

SELECT '<TR> ~RDA_html_td1' || Grantor    || '~RDA_html_td2',
            '~RDA_html_td1' || Grantee    || '~RDA_html_td2',               
            '~RDA_html_td1' || Table_name || '~RDA_html_td2',
            '~RDA_html_td1' || Privilege  || '~RDA_html_td2',       
            '~RDA_html_td1' || Grantable  || '~RDA_html_td2 </TR>' 
from all_tab_privs  
where table_schema = 'MDSYS' 
order by table_name, privilege;  
prompt ~RDA_html_tab2


prompt ~RDA_html_h31 Privileges owned by MDSYS ~RDA_html_h32 
prompt ~RDA_html_tab1 
prompt ~RDA_html_tdh1 Privilege    ~RDA_html_tdh2 
prompt ~RDA_html_tdh1 Admin_option ~RDA_html_tdh2 

SELECT '<TR> ~RDA_html_td1' || Privilege    || '~RDA_html_td2',
            '~RDA_html_td1' || Admin_option || '~RDA_html_td2 </TR>' 
from  dba_sys_privs 
where grantee='MDSYS' 
order by privilege;
prompt ~RDA_html_tab2


prompt ~RDA_html_h31 All Spatial Table Metadata ~RDA_html_h32 
prompt ~RDA_html_tab1 
prompt ~RDA_html_tdh1 Owner       ~RDA_html_tdh2 
prompt ~RDA_html_tdh1 Table_Name  ~RDA_html_tdh2 
prompt ~RDA_html_tdh1 Column_Name ~RDA_html_tdh2 
prompt ~RDA_html_tdh1 SRID        ~RDA_html_tdh2 

SELECT '<TR> ~RDA_html_td1' || Owner       || '~RDA_html_td2',
            '~RDA_html_td1' || Table_Name  || '~RDA_html_td2',
            '~RDA_html_td1' || Column_Name || '~RDA_html_td2',
            '~RDA_html_td1' || SRID        || '~RDA_html_td2 </TR>' 
from all_sdo_geom_metadata;  
prompt ~RDA_html_tab2


prompt ~RDA_html_h31 All Spatial Index Metadata ~RDA_html_h32 
prompt ~RDA_html_tab1 
prompt ~RDA_html_tdh1 Sdo_index_owner ~RDA_html_tdh2 
prompt ~RDA_html_tdh1 Sdo_index_name  ~RDA_html_tdh2 
prompt ~RDA_html_tdh1 Sdo_column_name ~RDA_html_tdh2 
prompt ~RDA_html_tdh1 Sdo_index_type  ~RDA_html_tdh2 

SELECT '<TR> ~RDA_html_td1' || Sdo_index_owner || '~RDA_html_td2',
            '~RDA_html_td1' || Sdo_index_name  || '~RDA_html_td2',
            '~RDA_html_td1' || Sdo_column_name || '~RDA_html_td2',
            '~RDA_html_td1' || Sdo_index_type  || '~RDA_html_td2 </TR>' 
from all_sdo_index_metadata ; 
prompt ~RDA_html_tab2
----------------------------------------------------
----------------------------------------------------
