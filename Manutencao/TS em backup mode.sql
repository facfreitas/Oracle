SELECT   d.tablespace_name
    FROM v$backup b, dba_data_files d
   WHERE b.file# = d.file_id AND b.status = 'ACTIVE'
GROUP BY d.tablespace_name, b.status