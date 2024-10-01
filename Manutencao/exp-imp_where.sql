exp logwatch@tlmh file=c:\logweb.dmp,logweb2.dmp log=c:\logweb.log tables=(logweb:p10) QUERY=\"where datetime > trunc(sysdate - 30)\" FEEDBACK=100000 filesize=2000m statistics=none

imp logwatch@tlmh file=c:\logweb.dmp log=c:\implogweb.log touser=logwatch full=y FEEDBACK=100000 filesize=2000m ignore=y