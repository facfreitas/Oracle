SELECT ltrim(rtrim(upper('%CUSTOMER_NAME%'))) CUSTOMER_NAME
	   ,ltrim(rtrim('%REGION%')) REGION
	   ,ltrim(rtrim('%HOSTNAME%')) HOSTNAME
	   ,ltrim(rtrim( '%INSTANCENAME%')) INSTANCE_NAME
	   ,wait_class
       ,event_name
       ,time_waited
       ,round(ratio_to_report(time_waited) over () * 100,2) as ratio_time_waited
from (
  select c.wait_class,
         c.event_name,
         (a.time_waited_micro - b.time_waited_micro)/1000000 as time_waited
  from sys.wrh$_system_event a,
       sys.wrh$_system_event b,
       sys.wrh$_event_name   c
  where a.dbid            = b.dbid
    and a.instance_number = b.instance_number   
    and a.snap_id = (select max(x.snap_id)
                     from sys.wrm$_snapshot x
                     where x.dbid = a.dbid
                       and x.instance_number = a.instance_number)
    and b.snap_id = (select min(y.snap_id)
                     from sys.wrm$_snapshot y
                     where y.dbid = b.dbid
                       and y.instance_number = b.instance_number
                       and begin_interval_time >= trunc(sysdate-7)) 
    and c.dbid        = a.dbid
    and c.dbid        = b.dbid
    and c.event_id    = a.event_id
    and a.event_id    = b.event_id
    and c.wait_class != 'Idle'
  order by 3 desc
) where rownum <= 5
