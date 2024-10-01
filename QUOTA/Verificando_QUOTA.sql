  SELECT username,
         tablespace_name,
         bytes / 1024 / 1024 usado_MB,
         max_bytes / 1024 / 1024 quota_Mb
    FROM dba_ts_quotas
    WHERE username like 'E%'
ORDER BY username;

ALTER USER ESCV QUOTA 5m ON TS_EDADOS;