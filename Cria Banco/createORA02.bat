@echo off

set ORACLE_SID=ORA02
set ORACLE_BASE=E:\oracle\ora92
set ORACLE_HOME=E:\oracle\ora92

echo.
echo Running Make Database Script ...
echo.
echo ORACLE_SID  = %ORACLE_SID%
echo ORACLE_BASE = %ORACLE_BASE%
echo ORACLE_HOME = %ORACLE_HOME%
echo.

if not exist "%ORACLE_BASE%\admin\%ORACLE_SID%\create" mkdir %ORACLE_BASE%\admin\%ORACLE_SID%\create
if not exist "%ORACLE_BASE%\admin\%ORACLE_SID%\pfile" mkdir %ORACLE_BASE%\admin\%ORACLE_SID%\pfile
if not exist "%ORACLE_BASE%\oradata\%ORACLE_SID%" mkdir %ORACLE_BASE%\oradata\%ORACLE_SID%
if not exist "%ORACLE_BASE%\admin\%ORACLE_SID%\bdump" mkdir %ORACLE_BASE%\admin\%ORACLE_SID%\bdump
if not exist "%ORACLE_BASE%\admin\%ORACLE_SID%\cdump" mkdir %ORACLE_BASE%\admin\%ORACLE_SID%\cdump
if not exist "%ORACLE_BASE%\admin\%ORACLE_SID%\udump" mkdir %ORACLE_BASE%\admin\%ORACLE_SID%\udump
if not exist "%ORACLE_BASE%\oradata\%ORACLE_SID%" mkdir %ORACLE_BASE%\oradata\%ORACLE_SID%
mkdir %ORACLE_BASE%\oradata\%ORACLE_SID%\REDOA

copy E:\oracle\ora92\admin\ORA02\create\initORA02.ora %ORACLE_BASE%\admin\%ORACLE_SID%\pfile
copy E:\oracle\ora92\admin\ORA02\create\initORA02.ora %ORACLE_BASE%\admin\%ORACLE_SID%\create
copy E:\oracle\ora92\admin\ORA02\create\createORA02.bat %ORACLE_BASE%\admin\%ORACLE_SID%\create
copy E:\oracle\ora92\admin\ORA02\create\createORA02.SQL %ORACLE_BASE%\admin\%ORACLE_SID%\create

%ORACLE_HOME%\bin\orapwd FILE=%ORACLE_BASE%\admin\%ORACLE_SID%\pfile\%ORACLE_SID% PASSWORD=ORACLE ENTRIES=10
%ORACLE_HOME%\bin\oradim -new -sid %ORACLE_SID% -intpwd oracle -startmode manual -pfile "%ORACLE_BASE%\admin\%ORACLE_SID%\pfile\init%ORACLE_SID%.ora"
%ORACLE_HOME%\bin\sqlplus "sys/oracle as sysdba" @%ORACLE_BASE%\admin\%ORACLE_SID%\create\createORA02.SQL %ORACLE_SID%
%ORACLE_HOME%\bin\oradim -edit -sid %ORACLE_SID% -startmode auto

echo %ORACLE_SID% =  >> %ORACLE_HOME%\network\admin\tnsnames.ora
echo  (DESCRIPTION =  >> %ORACLE_HOME%\network\admin\tnsnames.ora
echo    (ADDRESS_LIST =  >> %ORACLE_HOME%\network\admin\tnsnames.ora
echo      (ADDRESS = (PROTOCOL = TCP)(HOST = 127.0.0.1)(PORT = 1521)) >> %ORACLE_HOME%\network\admin\tnsnames.ora
echo    ) >> %ORACLE_HOME%\network\admin\tnsnames.ora
echo    (CONNECT_DATA = >> %ORACLE_HOME%\network\admin\tnsnames.ora
echo      (SERVICE_NAME = %ORACLE_SID%) >> %ORACLE_HOME%\network\admin\tnsnames.ora
echo    ) >> %ORACLE_HOME%\network\admin\tnsnames.ora
echo  ) >> %ORACLE_HOME%\network\admin\tnsnames.ora
