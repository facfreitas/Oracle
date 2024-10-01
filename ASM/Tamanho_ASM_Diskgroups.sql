SELECT
    name,
    state,
    total_mb,
    free_mb    
FROM
    v$asm_diskgroup
order by state;    
