-- -----------------------------------------------------------------------------
--                 WWW.PETEFINNIGAN.COM LIMITED
-- -----------------------------------------------------------------------------
-- Script Name : find_all_privs.sql
-- Author      : Pete Finnigan
-- Date        : June 2003
-- -----------------------------------------------------------------------------
-- Description : Use this script to find which privileges have been granted to a
--               particular user. This scripts lists ROLES, SYSTEM privileges
--               and object privileges granted to a user. If a ROLE is found
--               then it is checked recursively.
--      
--               The output can be directed to either the screen via dbms_output
--               or to a file via utl_file. The method is decided at run time 
--               by choosing either 'S' for screen or 'F' for File. If File is
--               chosen then a filename and output directory are needed. The 
--               output directory needs to be enabled via utl_file_dir prior to
--               9iR2 and a directory object after.
-- -----------------------------------------------------------------------------
-- Maintainer  : Pete Finnigan (http://www.petefinnigan.com)
-- Copyright   : Copyright (C) 2003 PeteFinnigan.com Limited. All rights
--               reserved. All registered trademarks are the property of their
--               respective owners and are hereby acknowledged.
-- -----------------------------------------------------------------------------
-- Version History
-- ===============
--
-- Who         version     Date      Description
-- ===         =======     ======    ======================
-- P.Finnigan  1.0         Jun 2003  First Issue.
-- P.Finnigan  1.1         Jun 2003  Output to file added.
-- -----------------------------------------------------------------------------

whenever sqlerror exist rollback
set feed on
set head on
set arraysize 1
set space 1
set verify on
set pages 25
set lines 80
set termout on
clear screen
set serveroutput on size 1000000

spool find_all_privs.lis
undefine user_to_find
undefine output_method
undefine file_name
undefine output_dir

prompt 
prompt get user input
prompt
accept user_to_find char prompt 'NAME OF USER TO CHECK   [ORCL]: ' default orcl
accept output_method char prompt 'OUTPUT METHOD           [S/F]: ' default S
accept file_name char prompt 'FILE NAME FOR OUTPUT   [priv.lst]: ' default priv.lst
accept output_dir char prompt 'OUTPUT DIRECTORY          [/tmp]: ' default /tmp
prompt 
declare
	--
	lv_tabs number:=0;
	lg_fptr utl_file.file_type;
	lv_file_or_screen varchar2(1):='S';
	--
	procedure open_file (pv_file_name in varchar2,
			pv_dir_name in varchar2) is 
	begin
		lg_fptr:=utl_file.fopen(pv_dir_name,pv_file_name,'A');
	exception
		when utl_file.invalid_path  then
			dbms_output.put_line('invalid path');
		when utl_file.invalid_mode  then
			dbms_output.put_line('invalid mode');
		when utl_file.invalid_filehandle  then
			dbms_output.put_line('invalid filehandle');
		when utl_file.invalid_operation  then
			dbms_output.put_line('invalid operation');
		when utl_file.read_error  then
			dbms_output.put_line('read error');
		when utl_file.write_error  then
			dbms_output.put_line('write error');
		when utl_file.internal_error  then
			dbms_output.put_line('internal error');
		when others then
			dbms_output.put_line('ERROR (open_file) => '||sqlcode);
			dbms_output.put_line('MSG (open_file) => '||sqlerrm);

	end open_file;
	--
	procedure close_file is
	begin
		utl_file.fclose(lg_fptr);
	exception
		when utl_file.invalid_path  then
			dbms_output.put_line('invalid path');
		when utl_file.invalid_mode  then
			dbms_output.put_line('invalid mode');
		when utl_file.invalid_filehandle  then
			dbms_output.put_line('invalid filehandle');
		when utl_file.invalid_operation  then
			dbms_output.put_line('invalid operation');
		when utl_file.read_error  then
			dbms_output.put_line('read error');
		when utl_file.write_error  then
			dbms_output.put_line('write error');
		when utl_file.internal_error  then
			dbms_output.put_line('internal error');
		when others then
			dbms_output.put_line('ERROR (close_file) => '||sqlcode);
			dbms_output.put_line('MSG (close_file) => '||sqlerrm);

	end close_file;
	--
	procedure write_op (pv_str in varchar2) is
	begin
		if lv_file_or_screen='S' then
			dbms_output.put_line(pv_str);
		else
			utl_file.put_line(lg_fptr,pv_str);
		end if;
	exception
		when utl_file.invalid_path  then
			dbms_output.put_line('invalid path');
		when utl_file.invalid_mode  then
			dbms_output.put_line('invalid mode');
		when utl_file.invalid_filehandle  then
			dbms_output.put_line('invalid filehandle');
		when utl_file.invalid_operation  then
			dbms_output.put_line('invalid operation');
		when utl_file.read_error  then
			dbms_output.put_line('read error');
		when utl_file.write_error  then
			dbms_output.put_line('write error');
		when utl_file.internal_error  then
			dbms_output.put_line('internal error');
		when others then
			dbms_output.put_line('ERROR (write_op) => '||sqlcode);
			dbms_output.put_line('MSG (write_op) => '||sqlerrm);

	end write_op;
	--
	procedure get_privs (pv_grantee in varchar2,lv_tabstop in out number) is
		--
		lv_tab varchar2(50):='';
		lv_loop number;
		--
		cursor c_main (cp_grantee in varchar2) is
		select	'ROLE' typ,
			grantee grantee,
			granted_role priv,
			admin_option ad,
			'--' tabnm,
			'--' colnm
		from	dba_role_privs
		where	grantee=cp_grantee
		union
		select	'SYSTEM' typ,
			grantee grantee,
			privilege priv,
			admin_option ad,
			'--' tabnm,
			'--' colnm
		from	dba_sys_privs
		where	grantee=cp_grantee
		union
		select	'TABLE' typ,
			grantee grantee,
			privilege priv,
			grantable ad,
			table_name tabnm,
			'--' colnm
		from	dba_tab_privs
		where	grantee=cp_grantee
		union
		select	'COLUMN' typ,
			grantee grantee,
			privilege priv,
			grantable ad,
			table_name tabnm,
			column_name colnm
		from	dba_col_privs
		where	grantee=cp_grantee
		order by 1;
	begin
		lv_tabstop:=lv_tabstop+1;
		for lv_loop in 1..lv_tabstop loop
			lv_tab:=lv_tab||'...';
		end loop;
		for lv_main in c_main(pv_grantee) loop
			if lv_main.typ='ROLE' then
				write_op(lv_tab||'USER => '
				||lv_main.grantee||' has ROLE '
				||lv_main.priv||' which contains =>'); 
				get_privs(lv_main.priv,lv_tabstop);
			elsif lv_main.typ='SYSTEM' then
				write_op(lv_tab||'SYS PRIV =>'
					||lv_main.priv
				  	||' grantable => '||lv_main.ad);
			elsif lv_main.typ='TABLE' then
				write_op(lv_tab||'TABLE PRIV =>'
					||lv_main.priv
				  	||' table_name => '||lv_main.tabnm
				  	||' grantable => '||lv_main.ad);
			elsif lv_main.typ='COLUMN' then
				write_op(lv_tab||'COL PRIV =>'
					||lv_main.priv
				  	||' table_name => '||lv_main.tabnm
				  	||' column_name => '||lv_main.colnm
				  	||' grantable => '||lv_main.ad);
			end if;
		end loop;
		lv_tabstop:=lv_tabstop-1;
		lv_tab:='';
	exception
		when others then
			dbms_output.put_line('ERROR (get_privs) => '||sqlcode);
			dbms_output.put_line('MSG (get_privs) => '||sqlerrm);
	end get_privs;
begin
	lv_file_or_screen:='&&output_method';
	if lv_file_or_screen='F' then
		open_file('&&file_name','&&output_dir');
	end if;
	get_privs('&&user_to_find',lv_tabs);
	if lv_file_or_screen='F' then
		close_file;
	end if;
exception
	when others then
		dbms_output.put_line('ERROR => '||sqlcode);
		dbms_output.put_line('MSG => '||sqlerrm);

end;
/
spool off
