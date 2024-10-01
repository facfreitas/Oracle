set oracle_sid=clbd
sqlplus system/seinao @d:\backonline\scripts\bk_dia.sql /nolog
exp system/seinao parfile=d:\backonline\scripts\bk_dia.par
exit
