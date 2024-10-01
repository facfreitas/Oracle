select destination, status, error, archived_thread#, archived_seq#
from v$archive_dest_status
where status <> 'DEFERRED' and status <> 'INACTIVE';

