/* Script para determinar quando um �ndice deve ser "rebuild" 
quando o valor de BLEVEL for maior que 4 devemos executar um rebuild no �ndice
esse valor � o n�mero de vezes que o ORACLE procura no �ndice para encontrar um determinado registro
por Ricardo Guedes */

select owner, index_name, blevel, 
	   decode(blevel,0,'OK BLEVEL',1,'OK BLEVEL',2,'OK BLEVEL',3,'OK BLEVEL',4,'OK BLEVEL','BLEVEL HIGH') OK
from dba_indexes 
where owner not in ('SYS','SYSTEM')


