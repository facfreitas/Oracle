@echo off

echo Definindo horario de inicio da exportacao...
echo # >> C:\DMP\expdp_eepboltondev.log
date /t >> C:\DMP\expdp_eepboltondev.log
time /t >> C:\DMP\expdp_eepboltondev.log
echo.
echo Criacao do Dump...
echo.
echo Executando rodizio de backups...

SET data=%date%
SET data=%data:/=_%
SET data=%data:-=_%


echo Iniciando exportacao dos dados...

FORFILES /p C:\DMP\ /s /m *.dmp /d -1 /c "CMD /C del /Q /F @FILE"
FORFILES /p C:\DMP\ /s /m *.log /d -1 /c "CMD /C del /Q /F @FILE"


expdp F_GL_EXPORT/backupBANCO@EEPBOLTONDEV directory=EXPDP_DIR dumpfile=expdp_eepboltondev_%data%.dmp logfile=expdp_eepboltondev_%data%.log full=y 

expdp F_GL_EXPORT/backupBANCO@EEPBOLTONDEV directory=EXPDP_DIR dumpfile=expdp_eepboltondev_DEF_%data%.dmp logfile=expdp_eepboltondev_DEF_%data%.log full=y content=metadata_only


echo Definindo horario de fim da exportacao...
date /t >> C:\DMP\expdp_eepboltondev.log
time /t >> C:\DMP\expdp_eepboltondev.log

copy /y C:\DMP\expdp_eepboltondev_%data%.dmp  \\wssabkp01\bkp-sap$\EEPBOLTONDEV
copy /y C:\DMP\expdp_eepboltondev_DEF_%data%.dmp  \\wssabkp01\bkp-sap$\EEPBOLTONDEV
copy /y C:\DMP\expdp_eepboltondev_%data%.log  \\wssabkp01\bkp-sap$\EEPBOLTONDEV
copy /y C:\DMP\expdp_eepboltondev_DEF_%data%.log  \\wssabkp01\bkp-sap$\EEPBOLTONDEV

