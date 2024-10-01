SELECT ltrim(rtrim(upper('%CUSTOMER_NAME%'))) CUSTOMER_NAME
	   ,ltrim(rtrim('%REGION%')) REGION
	   ,ltrim(rtrim('%HOSTNAME%')) HOSTNAME
	   ,ltrim(rtrim( '%INSTANCENAME%')) INSTANCE_NAME
,OWNER
,CONSTRAINT_NAME
,case 
when CONSTRAINT_TYPE='C' then 'Check Constraint on a Table'
when CONSTRAINT_TYPE='P' then 'Primary Key'
when CONSTRAINT_TYPE='U' then 'Unique key'
when CONSTRAINT_TYPE='R' then 'Referential Integrity'
when CONSTRAINT_TYPE='V' then 'With check option, on a View'
when CONSTRAINT_TYPE='O' then 'With read only, on a View'
when CONSTRAINT_TYPE='H' then 'Hash Expression'
when CONSTRAINT_TYPE='F' then 'Constraint that involves a REF column'
when CONSTRAINT_TYPE='S' then 'Supplemental Logging'
ELSE CONSTRAINT_TYPE END AS "CONSTRAINT_TYPE"
,TABLE_NAME
,SEARCH_CONDITION
,R_OWNER
,R_CONSTRAINT_NAME
,DELETE_RULE
,STATUS
,DEFERRABLE
,DEFERRED
,VALIDATED
,GENERATED
,BAD
,RELY
,LAST_CHANGE
,INDEX_OWNER
,INDEX_NAME
,INVALID
FROM DBA_CONSTRAINTS
 WHERE owner not in ('SYS', 'SYSTEM', 'CTXSYS', 'HR', 'MDSYS', 'ODM','ODM_MTR', 'OE'
		    ,'ORDPLUGINS', 'ORDSYS', 'OUTLN', 'PM'
		    ,'PUBLIC', 'QS','QS_ADM','QS_CBADM'
		    ,'QS_CS','QS_ES','QS_OS','QS_WS','RMAN','SH','WKSYS','WMSYS','XDB'
		    ,'DBSNMP','AURORA$JIS$UTILITY$','OSE$HTTP$ADMIN','AURORA$ORB$UNAUTHENTICATED'
		    ,'WFADMIN','OWF_MGR') order by 1,4,3,2
      