SELECT OWNER, TABLE_NAME, TRIGGER_NAME, TRIGGERING_EVENT, STATUS 
FROM ALL_TRIGGERS
WHERE OWNER NOT IN ('SYS','SYSTEM','OUTLN','DBSNMP')
ORDER BY OWNER, TABLE_NAME, TRIGGER_NAME