run {
SET NEWNAME FOR DATABASE TO '+dg_ecp_data/ecq/datafile/%U';
duplicate target database to ECQ from active database;
}
exit
