F:

cd F:\backup\BACKUP


if exist prototipos1.zip del prototipos1.zip 
if exist prototipos.zip move prototipos.zip prototipos1.zip

if exist paginas1.zip del paginas1.zip
if exist paginas.zip move paginas.zip paginas1.zip

if exist javaapp1.zip del javaapp1.zip
if exist javaapp.zip move javaapp.zip javaapp1.zip

if exist serverapp1.zip del serverapps1.zip
if exist serverapp.zip move serverapp.zip serverapp1.zip

if exist mssqldata1.zip del mssqldata1.zip
if exist mssqldata.zip move mssqldata.zip mssqldata1.zip

c:


cd "c:\program files\7-Zip"

7z a -tzip F:\backup\BACKUP\prototipos.zip C:\Prototipos

7z a -tzip F:\backup\BACKUP\paginas.zip D:\paginas

7z a -tzip F:\backup\BACKUP\javaapp.zip D:\java-app

7z a -tzip F:\backup\BACKUP\serverapp.zip D:\server-app

net stop "MSSQLSERVER" /y

7z a -tzip F:\backup\BACKUP\mssqldata.zip D:\MSSQL\Data
net start "MSSQLSERVER"


