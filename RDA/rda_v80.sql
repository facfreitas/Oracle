REM rda_v80.sql
prompt <HR>
prompt <!--[ v80 | 8.0 Version Specific ]-->
prompt <a name="v80"></a>
prompt ~RDA_html_h31 Version Specific ~RDA_html_h32

----------------------------------------------------
prompt <!--[ rbs | Rollback Segments ]-->
prompt <A NAME="rbs"></a> 
prompt ~RDA_html_h31 Rollback Segments ~RDA_html_h32
prompt ~RDA_html_h31 v$rollstat ~RDA_html_h32

prompt ~RDA_html_tab1
prompt ~RDA_html_tdh1 Undo Segment Number   ~RDA_html_tdh2
prompt ~RDA_html_tdh1 Extents               ~RDA_html_tdh2
prompt ~RDA_html_tdh1 Segment Size          ~RDA_html_tdh2
prompt ~RDA_html_tdh1 Active Xacts          ~RDA_html_tdh2
prompt ~RDA_html_tdh1 Optimal               ~RDA_html_tdh2
prompt ~RDA_html_tdh1 High Water Mark       ~RDA_html_tdh2
prompt ~RDA_html_tdh1 Shrinks               ~RDA_html_tdh2
prompt ~RDA_html_tdh1 Wraps                 ~RDA_html_tdh2
prompt ~RDA_html_tdh1 Extends               ~RDA_html_tdh2
prompt ~RDA_html_tdh1 Status                ~RDA_html_tdh2
prompt ~RDA_html_tdh1 Current Extent        ~RDA_html_tdh2
prompt ~RDA_html_tdh1 Current Block         ~RDA_html_tdh2

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
FROM V$rollstat v;
prompt ~RDA_html_tab2


prompt ~RDA_html_h31 DBA_ROLLBACK_SEGS ~RDA_html_h32
prompt ~RDA_html_tab1
prompt ~RDA_html_tdh1 Segment Name     ~RDA_html_tdh2
prompt ~RDA_html_tdh1 Segment ID       ~RDA_html_tdh2
prompt ~RDA_html_tdh1 Owner            ~RDA_html_tdh2
prompt ~RDA_html_tdh1 Tablespace Name  ~RDA_html_tdh2
prompt ~RDA_html_tdh1 File ID          ~RDA_html_tdh2
prompt ~RDA_html_tdh1 Block ID         ~RDA_html_tdh2
prompt ~RDA_html_tdh1 Initial          ~RDA_html_tdh2
prompt ~RDA_html_tdh1 Next             ~RDA_html_tdh2
prompt ~RDA_html_tdh1 Min Extents      ~RDA_html_tdh2
prompt ~RDA_html_tdh1 Max Extents      ~RDA_html_tdh2
prompt ~RDA_html_tdh1 PCT Increase     ~RDA_html_tdh2
prompt ~RDA_html_tdh1 Status           ~RDA_html_tdh2
prompt ~RDA_html_tdh1 Instance Number  ~RDA_html_tdh2
prompt ~RDA_html_tdh1 Relative File#   ~RDA_html_tdh2

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
FROM dba_rollback_segs v;
prompt ~RDA_html_tab2

----------------------------------------------------
prompt <!--[ 80ts | Tablespaces ]-->
prompt <A NAME="80ts"></a> 

prompt ~RDA_html_h31 Tablespaces ~RDA_html_h32
prompt ~RDA_html_tab1
prompt ~RDA_html_tdh1 Status              ~RDA_html_tdh2
prompt ~RDA_html_tdh1 Name                ~RDA_html_tdh2
prompt ~RDA_html_tdh1 Type                ~RDA_html_tdh2
prompt ~RDA_html_tdh1 Size (M)            ~RDA_html_tdh2
prompt ~RDA_html_tdh1 Used (M)            ~RDA_html_tdh2
prompt ~RDA_html_tdh1 Used %              ~RDA_html_tdh2
prompt ~RDA_html_tdh1 Initial Extent      ~RDA_html_tdh2
prompt ~RDA_html_tdh1 Next Extent         ~RDA_html_tdh2
prompt ~RDA_html_tdh1 Largest Free Extent ~RDA_html_tdh2

SELECT '<TR> ~RDA_html_td1' || d.status              || '~RDA_html_td2',
            '~RDA_html_td1' || d.tablespace_name     || '~RDA_html_td2', 
            '~RDA_html_td1' || d.contents            || '~RDA_html_td2', 
            '~RDA_html_td1' || TO_CHAR(NVL(a.bytes / 1024 / 1024, 0),'99G999G990D900') || '~RDA_html_td2',
            '~RDA_html_td1' || TO_CHAR(NVL(a.bytes - NVL(f.bytes, 0), 0)/1024/1024 ,'99G999G990D900') || '~RDA_html_td2',
            '~RDA_html_td1' || TO_CHAR(NVL((a.bytes - NVL(f.bytes, 0)) / a.bytes * 100, 0), '990D00') || '~RDA_html_td2', 
            '~RDA_html_td1' || d.initial_extent      || '~RDA_html_td2', 
            '~RDA_html_td1' || NVL(d.next_extent, 0) || '~RDA_html_td2',
            '~RDA_html_td1' || TO_CHAR(NVL(f.largest_free / 1024 / 1024, 0),'99G999G990D900') || '~RDA_html_td2 </TR>'
FROM sys.dba_tablespaces d, 
           (select tablespace_name, sum(bytes) bytes 
            from dba_data_files 
            group by tablespace_name) a, 
           (select tablespace_name, sum(bytes) bytes, max(bytes) largest_free 
            from dba_free_space 
            group by tablespace_name) f 
WHERE d.tablespace_name = a.tablespace_name 
AND   d.tablespace_name = f.tablespace_name;
prompt ~RDA_html_tab2

prompt <!--[ 80dfs | Database Files ]-->
prompt <A NAME="80dfs"></a> 
-- Bug 2988905 / Bug 2956490 : FKOBYLAN / OSARIOGL

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
            '~RDA_html_td1' || NVL(d.autoextensible, 'NO') || '~$RDA_html_td2 </TR>'
FROM sys.dba_data_files d, v$datafile v,
     (SELECT file_id, SUM(bytes) bytes  FROM sys.dba_free_space  GROUP BY file_id) s 
WHERE (s.file_id (+)= d.file_id) 
AND   (d.file_name = v.name);
prompt ~RDA_html_tab2
----------------------------------------------------
prompt <!--[ 80dbasao | DBA Stmt Audit Options ]-->
prompt <A NAME="80dbasao"></a> 

prompt ~RDA_html_h31 DBA_Stmt_Audit_Opts ~RDA_html_h32
prompt ~RDA_html_tab1
prompt ~RDA_html_tdh1 User Name     ~RDA_html_tdh2
prompt ~RDA_html_tdh1 Audit Option  ~RDA_html_tdh2
prompt ~RDA_html_tdh1 Success       ~RDA_html_tdh2
prompt ~RDA_html_tdh1 Failure       ~RDA_html_tdh2

SELECT '<TR> ~RDA_html_td1' || nvl(s.user_name,'<i>null value</i>') || '~RDA_html_td2', 
            '~RDA_html_td1' || s.audit_option                       || '~RDA_html_td2',
            '~RDA_html_td1' || nvl(s.success,'<i>null value</i>')   || '~RDA_html_td2', 
            '~RDA_html_td1' || nvl(s.failure,'<i>null value</i>')   || '~RDA_html_td2 </TR>' 
FROM sys.dba_stmt_audit_opts s;
prompt ~RDA_html_tab2
----------------------------------------------------

prompt <!--[ 80dbapao | DBA_Priv Audit Options ]-->
prompt <A NAME="80dbapao"></a> 

prompt ~RDA_html_h31 DBA_Priv_Audit_Opts ~RDA_html_h32
prompt ~RDA_html_tab1
prompt ~RDA_html_tdh1 User Name   ~RDA_html_tdh2
prompt ~RDA_html_tdh1 Privilege   ~RDA_html_tdh2
prompt ~RDA_html_tdh1 Success     ~RDA_html_tdh2
prompt ~RDA_html_tdh1 Failure     ~RDA_html_tdh2

SELECT '<TR> ~RDA_html_td1' || nvl(p.user_name,'<i>null value</i>') || '~RDA_html_td2', 
            '~RDA_html_td1' || p.privilege                          || '~RDA_html_td2',
            '~RDA_html_td1' || nvl(p.success,'<i>null value</i>')   || '~RDA_html_td2', 
            '~RDA_html_td1' || nvl(p.failure,'<i>null value</i>')   || '~RDA_html_td2 </TR>' 
FROM sys.dba_priv_audit_opts p;
prompt ~RDA_html_tab2
----------------------------------------------------
----------------------------------------------------
----------------------------------------------------
----------------------------------------------------
----------------------------------------------------
