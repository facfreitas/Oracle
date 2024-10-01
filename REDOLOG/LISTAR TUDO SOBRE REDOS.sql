select group#, 
	   sequence#, 
	   bytes/1024/1024 "Tamanho em MB",
       Archived, 
	   Status, 
	   First_change#, 
	   to_char(first_time,'dd/mm   -  hh24:mi:ss') "Data Archived"
from v$log
order by first_time