select 
 ltrim(rtrim(upper('%CUSTOMER_NAME%'))) CUSTOMER_NAME
           ,ltrim(rtrim('%REGION%')) REGION
           ,ltrim(rtrim('%HOSTNAME%')) HOSTNAME
           ,ltrim(rtrim( '%INSTANCENAME%')) INSTANCE_NAME
,group# "GROUP"
,members "MEMBERS"
,bytes "SIZE" from v$log
