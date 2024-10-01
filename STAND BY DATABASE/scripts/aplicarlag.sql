alter database recover managed standby database cancel;
alter database recover managed standby database nodelay disconnect from session through last switchover;