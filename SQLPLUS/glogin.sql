set termout off
set echo off
define X=NotConnected
define Y=DBNAME

Column Usr New_Value X
Column DBName New_Value Y

Select SYS_CONTEXT('USERENV','SESSION_USER' ) Usr From Dual;

set termout on
set sqlprompt '&X@&Y> '

set pagesize 10000
set linesize 200

-- Used by Trusted Oracle
column ROWLABEL format A15

-- Used for the SHOW ERRORS command
column LINE/COL format A8
column ERROR    format A65  WORD_WRAPPED


-- Used for the SHOW SGA command
column name_col_plus_show_sga format a24


-- Defaults for SHOW PARAMETERS
column name_col_plus_show_param format a36 heading NAME
column value_col_plus_show_param format a30 heading VALUE

-- Defaults for SET AUTOTRACE EXPLAIN report
column id_plus_exp format 990 heading i
column parent_id_plus_exp format 990 heading p
column plan_plus_exp format a60
column object_node_plus_exp format a8
column other_tag_plus_exp format a29
column other_plus_exp format a44
