/* Criar as TS antes */

alter table slb.load_profile move partition DH200212 tablespace SLBTS0301D storage (initial 55M);                                                             
alter table slb.load_profile move partition DH200303 tablespace SLBTS0301D storage (initial 473M);                                                            
alter table slb.load_profile move partition DH200306 tablespace SLBTS0301D storage (initial 561M);                                                            
alter table slb.load_profile move partition DH200309 tablespace SLBTS0301D storage (initial 423M);                                                            
alter table slb.load_profile move partition DH200312 tablespace SLBTS0301D storage (initial 1590M);                                                           


alter table slb.load_profile move partition DH200301 tablespace SLBTS0302D storage (initial 401M);                                                            
alter table slb.load_profile move partition DH200304 tablespace SLBTS0302D storage (initial 830M);                                                            
alter table slb.load_profile move partition DH200307 tablespace SLBTS0302D storage (initial 594M);                                                            
alter table slb.load_profile move partition DH200310 tablespace SLBTS0302D storage (initial 891M);                                                            
