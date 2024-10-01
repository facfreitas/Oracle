-- Se as XACTS (Transações Ativas) regularmente acima de 1 aumente o n° de segmentos de Rollback
-- Se a espera (WAITS) for maior que zero aumente o n° de segmentos de Rollback

select a.name, b.extents, b.rssize, b.xacts, b.waits, b.gets, optsize, status
from v$rollname a, v$rollstat b
where a.usn = b.usn
