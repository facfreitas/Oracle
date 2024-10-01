--* File Name    : File_IO.sql
--* Author       : DR Timothy S Hall
--* Description  : Displays the amount of IO for each datafile.
--* Requirements : Access to the v$ views.
--* Call Syntax  : @File_IO
--* Last Modified: 15/07/2000
SET PAGESIZE 1000

SELECT Substr(d.name,1,50) "File Name",
       f.phyblkrd "Blocks Read",
       f.phyblkwrt "Blocks Writen",
       f.phyblkrd + f.phyblkwrt "Total I/O"
FROM   v$filestat f,
       v$datafile d
WHERE  d.file# = f.file#
ORDER BY f.phyblkrd + f.phyblkwrt DESC;

SET PAGESIZE 18