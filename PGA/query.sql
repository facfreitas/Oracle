select low_optimal_size/1024 as low_kb,
	   (high_optimal_size+1)/1024 as high_kb,
	   round(100*optimal_executions/total_executions) as optimal,
	   round(100*onepass_executions/total_executions) as onepass,
	   round(100*multipasses_executions/total_executions) as multipass
from v$sql_workarea_histogram
where total_executions != 0
order by low_kb;