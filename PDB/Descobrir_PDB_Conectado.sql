
 select sys_context('USERENV','CON_NAME') CON_NAME,
            sys_context('USERENV','CON_ID') CON_ID,
            sys_context('USERENV','DB_NAME') DB_NAME from DUAL;