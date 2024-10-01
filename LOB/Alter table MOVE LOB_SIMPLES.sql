select 'ALTER TABLE '||OWNER||'.'||TABLE_NAME||' MOVE LOB ('||COLUMN_NAME||') STORE AS ( TABLESPACE TS_EDADOS  );' 
    from dba_tab_columns
    where 1 = 1
    and owner in ('SISWEB')
    and data_type in ('BLOB','CLOB','LONG',
    'LONG RAW','RAW','SDD_ACC_PRIV_LIST','SDD_SYS_PRIV_LIST','UNDEFINED')
    
    
