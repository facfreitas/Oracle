rem $DBA/alertlog.sql
rem
rem Analyzes the alert.log file for Redo Log statistics and errors.
rem Creates a report (alertlog.lis) describing the statistics and errors.
rem
rem Restrictions:
rem	1) Requires UTL_FILE package (available as of Oracle 7.3)
rem	2) The init.ora file must contain a utl_file_dir parameter, which allows
rem	   this script to read the alert.log file, such as one of the following:
rem		utl_file_dir="/u01/home/oracle/admin/sid/bdump"
rem		utl_file_dir=*
rem
rem Last Change 05/27/97 by Brian Lomasky
rem
set echo off
set feedback off
set pagesize 0
set pause off
set termout off
set verify off
drop table alertlog_temp;
set termout on
whenever sqlerror exit failure
create table alertlog_temp (lineno number, text varchar2(80));
declare
	cursor param_cursor is
		select b.value, d.value
		from v$parameter b, v$parameter d
		where b.name = 'background_dump_dest' and
			d.name = 'db_name';

	bdump_dest		varchar2(512);
	check_not_comp_ctr	number;
	check_not_comp_flag	boolean;
	curr_secs		number;
	file_handle		utl_file.file_type;
	file_line		varchar2(2000);
	file_spec		varchar2(132);
	first_date		boolean;
	full_date		date;
	lineno			number;
	log_switch_ctr		number;
	my_port			varchar2(132);
	pct_wait		char(9);
	prev_date		date;
	prev_secs		number;
	sid			varchar2(16);
	the_date		date;
	wait_time		number;

	procedure wri (my_txt in varchar2) is
	begin
		lineno := lineno + 1;
		insert into alertlog_temp values (lineno, my_txt);
	end wri;

	procedure store_totals is
	begin
		if log_switch_ctr + check_not_comp_ctr <> 0 then
			if wait_time != 0 then
				pct_wait := '    ' ||
					to_char(wait_time / 36, '999') || '%';
			else
				pct_wait := ' ';
			end if;
			wri(to_char(prev_date, 'MM/DD/YY HH24:MI:SS') ||
				to_char(log_switch_ctr, 'B999999999999') ||
				to_char(check_not_comp_ctr, 'B9999999999') ||
				to_char(wait_time, 'B9999999999') || pct_wait);
		end if;
	end store_totals;

begin
	lineno := 0;
	first_date := TRUE;
	open param_cursor;
	fetch param_cursor into bdump_dest, sid;
	if param_cursor%NOTFOUND then
		raise_application_error(-20001, 'Error - Can''t find' ||
			' background_dump_dest' || chr(10) ||
			'or db_name parameter - Aborting...');
	end if;
	close param_cursor;
	my_port := dbms_utility.port_string;
	if my_port = 'UNIX' or my_port = 'SVR4-be-7.0.0' then
		file_spec := bdump_dest || '/alert_' || sid || '.log';
		file_handle := utl_file.fopen(bdump_dest,
			'alert_' || sid || '.log', 'R');
	elsif my_port = 'IBMPC/WIN_NT-7.0.0' then
		file_spec := bdump_dest || '\alert_' || sid || '.log';
		file_handle := utl_file.fopen(bdump_dest,
			'alert_' || sid || '.log', 'R');
	else
		raise_application_error(-20002,
			'Error - Unsupported platform: ' || my_port ||
			chr(10) || 'Aborting...');
	end if;
	wri(substr('                             ',1,(68-length(file_spec))/2)
		|| 'Analysis of ' || file_spec);
	wri(' ');
	wri(' ');
	wri('                               Checkpoint            Pct Wait');
	wri('                    Number of     Not      Wait Time   per');
	wri('  Hourly Bucket   Log Switches  Complete   (seconds)  Bucket');
	wri('----------------- ------------ ---------- ---------- --------');
	loop
		utl_file.get_line(file_handle, file_line);
		/* See if a date is found */
		if substr(file_line,14,1) = ':' and substr(file_line,17,1) = ':'
		then
			the_date := to_date(
				substr(file_line,9,2) || '-' ||
				upper(substr(file_line,5,3)) || '-' ||
				substr(file_line,21,4) || ' ' ||
				substr(file_line,12,2) || ':00:00',
				'DD-MON-YYYY HH24:MI:SS');
			full_date := to_date(
				substr(file_line,9,2) || '-' ||
				upper(substr(file_line,5,3)) || '-' ||
				substr(file_line,21,4) || ' ' ||
				substr(file_line,12,8),
				'DD-MON-YYYY HH24:MI:SS');
			if first_date then
				first_date := FALSE;
				prev_date := the_date;
				log_switch_ctr := 0;
				wait_time := 0;
				check_not_comp_ctr := 0;
				check_not_comp_flag := FALSE;
			else
				if check_not_comp_flag then
					curr_secs := to_number(to_char(
						full_date, 'SSSSS'));
					if curr_secs >= prev_secs then
						wait_time := wait_time +
							curr_secs - prev_secs;
					else
						wait_time := wait_time +
							curr_secs - prev_secs
							+ 86400;
					end if;
					check_not_comp_flag := FALSE;
				end if;
				if the_date <> prev_date then
					store_totals;
					prev_date := the_date;
					log_switch_ctr := 0;
					wait_time := 0;
					check_not_comp_ctr := 0;
					check_not_comp_flag := FALSE;
				end if;
			end if;
		end if;
		if instr(file_line, 'advanced to log') <> 0 then
			log_switch_ctr := log_switch_ctr + 1;
			if check_not_comp_flag then
				check_not_comp_flag := FALSE;
			end if;
    		end if;
		if instr(file_line, 'Checkpoint not complete') <> 0 then
			check_not_comp_ctr := check_not_comp_ctr + 1;
			prev_secs := to_number(to_char(full_date,'SSSSS'));
			check_not_comp_flag := TRUE;
		end if;
	end loop;
exception
	when no_data_found then
		utl_file.fclose(file_handle);
		if not first_date then
			store_totals;
		end if;
		commit;
	when utl_file.invalid_operation then
		rollback;
		raise_application_error(-20000,
			'Error - Can''t read file: ' || file_spec || chr(10) ||
			'Aborting...');
	when utl_file.invalid_path then
		rollback;
		raise_application_error(-20000,
			'Error - Can''t find file: ' || file_spec || chr(10) ||
			'Aborting...');
end;
/
set termout off
spool alertlog.lis
select text from alertlog_temp order by lineno;
spool off
drop table alertlog_temp;
set termout on
select chr(10) ||
	'Created alertlog.lis report for your viewing pleasure...' || chr(10) ||
	chr(10)
from dual;
exit
