SELECT ltrim(rtrim(upper('%CUSTOMER_NAME%'))) CUSTOMER_NAME
	   ,ltrim(rtrim('%REGION%')) REGION
	   ,ltrim(rtrim('%HOSTNAME%')) HOSTNAME
	   ,ltrim(rtrim('%INSTANCENAME%')) INSTANCE_NAME
	   ,to_char(begin_time,'dd-mon-yy') begin_time
	   ,avg(MAXVAL) AVG
  from sys.WRH$_SYSMETRIC_SUMMARY
 where (metric_id,group_id) in (select METRIC_ID, GROUP_ID
                                 from sys.WRH$_METRIC_NAME
                                where upper(METRIC_NAME) = 'HOST CPU UTILIZATION (%)'
                               )
 group by begin_time
 order by 1
