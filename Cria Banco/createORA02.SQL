spool %ORACLE_BASE%\admin\%ORACLE_SID%\create\createdb
set echo on
startup nomount pfile="%ORACLE_BASE%\admin\%ORACLE_SID%\pfile\initORA02.ora"

set verify off
create database &1
  controlfile reuse 
  undo tablespace undo
  datafile '%ORACLE_BASE%\oradata\%ORACLE_SID%\rbs01.dbf' size 32M reuse
  logfile  '%ORACLE_BASE%\oradata\%ORACLE_SID%\REDOA\redo_log02a.log' size 4M reuse,
           '%ORACLE_BASE%\oradata\%ORACLE_SID%\REDOA\redo_log01a.log' size 4M reuse
  datafile '%ORACLE_BASE%\oradata\%ORACLE_SID%\system01.dbf' size 250M reuse;


create temporary tablespace TEMP
  tempfile '%ORACLE_BASE%\oradata\%ORACLE_SID%\temp01.dbf' size 32 M reuse
  extent management local uniform size 64k;
create tablespace TOOLS
  datafile '%ORACLE_BASE%\oradata\%ORACLE_SID%\tools01.dbf' size 32 M reuse
  logging
  extent management local uniform size 64k;
create tablespace USER_DATA
  datafile '%ORACLE_BASE%\oradata\%ORACLE_SID%\udata01.dbf' size 32 M reuse
  logging
  extent management local uniform size 64k;
create tablespace USER_INDEX
  datafile '%ORACLE_BASE%\oradata\%ORACLE_SID%\uindex01.dbf' size 32 M reuse
  logging
  extent management local uniform size 64k;

alter user sys    temporary tablespace TEMP;
alter user system temporary tablespace TEMP;

grant sysdba to sys;
grant sysdba to system;

@"E:\oracle\ora92\rdbms\admin\catalog.sql"
@"E:\oracle\ora92\rdbms\admin\catproc.sql"

@"E:\oracle\ora92\sqlplus\admin\pupbld.sql"


@"E:\oracle\ora92\javavm\install\initjvm.sql";
@"E:\oracle\ora92\rdbms\admin\initplsj.sql";
@"E:\oracle\ora92\rdbms\admin\initaqjms.sql";
@"E:\oracle\ora92\rdbms\admin\initrepapi.sql";


shutdown

spool off
