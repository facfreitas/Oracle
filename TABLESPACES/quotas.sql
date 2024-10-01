select tablespace_name, round(bytes/1024/1024), max_bytes from user_ts_quotas -- dba_ts_quotas

alter user quota 10K       ON <tablespace>
                 20M
                 UNLIMITED
