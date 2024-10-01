set ORACLE_SID=clbp
d:\oracle\ora81\bin\oradim -new -sid CLBP -intpwd oracle -startmode manual -pfile "d:\oracle\admin\clbp\pfile\init.ora"
d:\oracle\ora81\bin\svrmgrl @D:\Oracle\clbp\create\clbprun.sql
d:\oracle\ora81\bin\svrmgrl @D:\Oracle\clbp\create\clbprun1.sql
d:\oracle\ora81\bin\svrmgrl @D:\Oracle\clbp\create\clbpordinst.sql
d:\oracle\ora81\bin\sqlplus system/manager @D:\Oracle\clbp\create\clbpsqlplus.sql
d:\oracle\ora81\bin\svrmgrl @D:\Oracle\clbp\create\clbptimeseries.sql
d:\oracle\ora81\bin\svrmgrl @D:\Oracle\clbp\create\clbpalterTablespace.sql
d:\oracle\ora81\bin\oradim -edit -sid clbp -startmode auto
