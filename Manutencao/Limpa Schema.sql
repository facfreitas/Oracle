SELECT 'DROP '||OBJECT_TYPE||' '||OWNER||'.'||OBJECT_NAME||';'
FROM DBA_OBJECTS
WHERE OWNER = 'IDE'
ORDER BY OBJECT_TYPE