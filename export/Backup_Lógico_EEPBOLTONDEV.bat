## Cria o diretório abaixo:
## CREATE OR REPLACE DIRECTORY 
## EXPDP_DIR AS 
## 'C:\DMP\';
## GRANT READ, WRITE ON DIRECTORY EXPDP_DIR TO PUBLIC;

## Cria o usuário abaixo:
## CREATE USER F_GL_EXPORT
## IDENTIFIED BY "backupBANCO"
## default tablespace users
## temporary tablespace temp;
## grant create session to f_gl_export;
## grant exp_full_database to f_gl_export;
## GRANT UNLIMITED TABLESPACE TO F_GL_EXPORT


@echo off

call C:\app\Scripts\expdp_eepboltondev.bat

net use S: \\wssabkp01\bkp-sap$\EEPBOLTONDEV /persistent:yes

FORFILES /p S: /s /m *.* /d -5 /c "CMD /C del /Q /F @FILE"

net use S: /delete /yes