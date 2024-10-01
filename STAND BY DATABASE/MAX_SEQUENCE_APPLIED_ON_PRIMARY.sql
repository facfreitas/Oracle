SELECT max(sequence#), thread# FROM V$ARCHIVED_LOG
group by thread#

