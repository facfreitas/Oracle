echo off

d:

cd \oracle\clbd\export

@exp export/coelba@clbd file=d:\oracle\clbd\export\clbd.dmp log=exp_clbd.log full=y compress=y consistent=y
@d:\oracle\ora81\bin\pkzip -a -m exp_clbd.zip *.dmp

