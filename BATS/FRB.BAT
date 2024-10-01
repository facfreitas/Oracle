@Echo off
@Echo Aguarde executando o script .....

if not exist z:\ NET USE z: \\LABS-NT\usuarios
if not exist y:\ NET USE y: \\LABS-NT\DISCIPLINAS

if exist c:\trabal~1\*.* deltree /y c:\trabal~1\
if exist c:\winnt\Tempor~1\*.* deltree /y c:\winnt\Tempor~1\
if exist c:\temp\*.* deltree /y c:\temp\

copy \\labs-nt\script\sim.txt c:\
CACLS C:\Program Files\Netscape\Users /t /p "Alunos FRB":C "Domain Admins":F <sim.txt
deltree /y c:\sim.txt
pause