SELECT DISTINCT tablespace_name FROM dba_data_files
WHERE file_id IN (SELECT FILE# FROM v$backup
WHERE status = 'ACTIVE');
