select 'ALTER DATABASE DATAFILE '''||FILE_NAME||''' AUTOEXTEND OFF;'
from dba_data_files
where autoextensible = 'YES'