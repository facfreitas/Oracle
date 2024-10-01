SELECT ltrim(rtrim(upper('%CUSTOMER_NAME%'))) CUSTOMER_NAME
       ,ltrim(rtrim('%REGION%')) REGION
       ,ltrim(rtrim('%HOSTNAME%')) HOSTNAME
       ,ltrim(rtrim( '%INSTANCENAME%')) INSTANCE_NAME
       ,version, name, detected_usages, currently_used, first_usage_date, last_usage_date
  from DBA_FEATURE_USAGE_STATISTICS
 order by name
