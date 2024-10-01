select 'create synonym '||TABLE_name||' for EREINF.'||TABLE_name||';'
from all_TABLES
where owner = 'EREINF'