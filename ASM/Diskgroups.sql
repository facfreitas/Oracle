SELECT
    substr(dg.name, 1, 16)     AS diskgroup,
    substr(d.name, 1, 16)      AS asmdisk,
    d.mount_status,
    d.state,
    substr(d.failgroup, 1, 16) AS failgroup
FROM
    v$asm_diskgroup dg,
    v$asm_disk      d
WHERE
    dg.group_number = d.group_number
ORDER BY
    diskgroup


    
     