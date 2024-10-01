select sum(pins) "Executions", sum(reloads) "Cache misses", sum(reloads)/sum(pins)
from v$librarycache;