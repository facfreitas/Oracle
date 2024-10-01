set heading off
set feedback off
set pagesize 0
set echo off
set termout off

var dia 	char(8)
var strs1	char(20)
var strs2 	char(10)
var dire  	CHAR(52)

begin  
	select to_char(trunc(sysdate-1),'DDMMYYYY') into :dia from dual;
	:strs1:= '"str X'||''''||'0D0A'||''''||'"';
	:strs2:='X'||''''||'23'||'''';
	:dire:='"\\adm_nt55\enviados\';
end;
/

spool d:\sgsiw.ctl
select 'load data' from dual;
select 'infile '|| :dire || :dia || '.txt" ' from dual;
select  '' || :strs1 from dual;
select 'into table INTERFACE_INTERRUPCAO' from dual;
select 'TRUNCATE' from dual;
select 'fields terminated by ' || :strs2 from dual;
select 'TRAILING NULLCOLS' from dual;
select '(' FROM DUAL;
select ' NUM_SI  CHAR(11),' from dual;
select ' DAT_SI DATE "DD/MM/YYYY",' from dual;   
select ' HOR_INI char(19),' from dual;
select ' HOR_TER char(19),' from dual;
select ' DES_CIDA CHAR(500) "TRIM(:DES_CIDA)",' from dual;
select ' DES_BAIR CHAR(500) "TRIM(:DES_BAIR)",' from dual;
select ' DES_STAT CHAR(20) "TRIM(:DES_STAT)",' from dual;
select ' DES_LOC_ATNG CHAR(4000) ' from dual;
select ')' from dual;
spool off
exit