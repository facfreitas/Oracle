select 'create synonym '||object_name||' for '||owner||'.'||object_name||';'
from all_objects
where owner = 'TCA'