SELECT v$datafile.NAME "NOME DO ARQUIVO", v$filestat.phyrds "LEITURAS",
       v$filestat.phywrts "ESCRITAS"
  FROM v$filestat, v$datafile
 WHERE v$filestat.file# = v$datafile.file#