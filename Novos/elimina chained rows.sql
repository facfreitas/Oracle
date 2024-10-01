-- ********************************************
-- Description: This script eliminates chained 
-- rows for any given tables.
-- Author: Sam H. Afyouni
-- Date: November 28, 2001
-- Limitations: Can only be run on Oracle8i
-- ********************************************
SET ECHO off
SET VERIFY off
SET FEEDBACK off
SET SERVEROUTPUT ON SIZE 1000000
ACCEPT owner PROMPT 'Enter Table Owner: '
ACCEPT table_name PROMPT 'Enter Table Name: '

DECLARE

v_owner VARCHAR2(30) := UPPER('&owner');
v_table_name VARCHAR2(30) := UPPER('&table_name');
v_chain_cnt NUMBER := 0;
v_count NUMBER := 0;

BEGIN

EXECUTE IMMEDIATE 'ANALYZE TABLE ' || v_owner || '.' || v_table_name || 
' ESTIMATE STATISTICS SAMPLE 20 PERCENT';

SELECT CHAIN_CNT INTO v_chain_cnt
FROM DBA_TABLES
WHERE OWNER = v_owner
AND TABLE_NAME = v_table_name;

IF v_chain_cnt > 0 THEN
SELECT COUNT(*) into v_count
FROM USER_TABLES
WHERE TABLE_NAME = 'CHOCHO_CHAINED_ROWS';

IF v_count > 0 THEN
EXECUTE IMMEDIATE 'DROP TABLE chocho_chained_rows';
END IF;

EXECUTE IMMEDIATE 'CREATE TABLE chocho_chained_rows ( ' ||
'owner_name VARCHAR2(30), ' ||
'table_name VARCHAR2(30), ' ||
'cluster_name VARCHAR2(30), ' ||
'partition_name VARCHAR2(30), ' ||
'subpartition_name VARCHAR2(30), ' ||
'head_rowid ROWID, ' ||
'analyze_timestamp DATE )';

DBMS_OUTPUT.PUT_LINE('Number of chained rows for <'||v_owner||'.'||v_table_name||
'> = '|| TO_CHAR(v_chain_cnt));

EXECUTE IMMEDIATE 'ANALYZE TABLE ' || v_owner || '.' || v_table_name || 
' LIST CHAINED ROWS INTO chocho_chained_rows';

EXECUTE IMMEDIATE 'CREATE TABLE chocho_chained_temp AS SELECT * FROM ' || 
v_owner || '.' || v_table_name || ' WHERE rowid IN '||
'(SELECT head_rowid FROM chocho_chained_rows)';

EXECUTE IMMEDIATE 'DELETE FROM ' || v_owner || '.' || v_table_name || 
' WHERE rowid IN ' || '(SELECT head_rowid FROM chocho_chained_rows)';

EXECUTE IMMEDIATE 'INSERT INTO ' || v_owner || '.' || v_table_name ||
' SELECT * FROM chocho_chained_temp';

EXECUTE IMMEDIATE 'DROP TABLE chocho_chained_rows';

EXECUTE IMMEDIATE 'DROP TABLE chocho_chained_temp';

DBMS_OUTPUT.PUT_LINE('Chained rows eliminated');

ELSE
DBMS_OUTPUT.PUT_LINE('There are no chained rows for <'||v_owner||'.'||v_table_name||'>');
END IF;

EXCEPTION
WHEN OTHERS THEN
DBMS_OUTPUT.PUT_LINE('ERROR: '||SQLERRM);
END; 
/
