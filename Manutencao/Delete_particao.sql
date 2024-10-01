delete from logwatch.logweb partition (p15)
where trunc(datetime) = to_date('15/02/2005', 'DD/MM/YYYY')