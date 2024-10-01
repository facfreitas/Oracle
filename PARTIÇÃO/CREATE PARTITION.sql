
CREATE TABLE LOAD_PROFILE
(
  ID                 NUMBER(9)                  NOT NULL,
  ID_MMCFG           NUMBER(9)                  NOT NULL,
  ID_PONTOMED        NUMBER(9)                  NOT NULL,
  DH                 DATE                       NOT NULL,
  GRANDEZA           NUMBER(3)                  NOT NULL,
  VALORKE            FLOAT(12)                  NOT NULL,
  DST                CHAR(1)                    NOT NULL,
  STATUS             NUMBER(5)                  NOT NULL,
  VALORPULSO         NUMBER(6)                  NOT NULL,
  VALORPRIMARIO      FLOAT(12)                  NOT NULL,
  VALORSECUNDARIO    FLOAT(12)                  NOT NULL,
  DEMANDAPRIMARIA    FLOAT(12)                  NOT NULL,
  DEMANDASECUNDARIA  FLOAT(12)                  NOT NULL
)
TABLESPACE TS$SLBLPD
PCTUSED    80
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          200M
            NEXT             20M
            MINEXTENTS       1
            MAXEXTENTS       2147483645
            PCTINCREASE      0
           )
LOGGING
PARTITION BY RANGE (DH) 
(  
  PARTITION DH200209 VALUES LESS THAN (TO_DATE(' 2002-10-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN'))
    LOGGING
    TABLESPACE TS$SLBLPD
    PCTUSED    80
    PCTFREE    10
    INITRANS   1
    MAXTRANS   255
    STORAGE    (
                INITIAL          200M
                NEXT             20M
                MINEXTENTS       1
                MAXEXTENTS       2147483645
                PCTINCREASE      0
                FREELISTS        1
                FREELIST GROUPS  1
                BUFFER_POOL      DEFAULT
               ),  
  PARTITION DH200210 VALUES LESS THAN (TO_DATE(' 2002-11-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN'))
    LOGGING
    TABLESPACE TS$SLBLPD
    PCTUSED    80
    PCTFREE    10
    INITRANS   1
    MAXTRANS   255
    STORAGE    (
                INITIAL          200M
                NEXT             20M
                MINEXTENTS       1
                MAXEXTENTS       2147483645
                PCTINCREASE      0
                FREELISTS        1
                FREELIST GROUPS  1
                BUFFER_POOL      DEFAULT
               ),  
  PARTITION DH200211 VALUES LESS THAN (TO_DATE(' 2002-12-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN'))
    LOGGING
    TABLESPACE TS$SLBLPD
    PCTUSED    80
    PCTFREE    10
    INITRANS   1
    MAXTRANS   255
    STORAGE    (
                INITIAL          200M
                NEXT             20M
                MINEXTENTS       1
                MAXEXTENTS       2147483645
                PCTINCREASE      0
                FREELISTS        1
                FREELIST GROUPS  1
                BUFFER_POOL      DEFAULT
               ),  
  PARTITION DH200212 VALUES LESS THAN (TO_DATE(' 2003-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN'))
    LOGGING
    TABLESPACE TS$SLBLPD
    PCTUSED    80
    PCTFREE    10
    INITRANS   1
    MAXTRANS   255
    STORAGE    (
                INITIAL          200M
                NEXT             20M
                MINEXTENTS       1
                MAXEXTENTS       2147483645
                PCTINCREASE      0
                FREELISTS        1
                FREELIST GROUPS  1
                BUFFER_POOL      DEFAULT
               ),  
  PARTITION DH200301 VALUES LESS THAN (TO_DATE(' 2003-02-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN'))
    LOGGING
    TABLESPACE TS$SLBLPD
    PCTUSED    80
    PCTFREE    10
    INITRANS   1
    MAXTRANS   255
    STORAGE    (
                INITIAL          200M
                NEXT             20M
                MINEXTENTS       1
                MAXEXTENTS       2147483645
                PCTINCREASE      0
                FREELISTS        1
                FREELIST GROUPS  1
                BUFFER_POOL      DEFAULT
               ),  
  PARTITION DH200302 VALUES LESS THAN (TO_DATE(' 2003-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN'))
    LOGGING
    TABLESPACE TS$SLBLPD
    PCTUSED    80
    PCTFREE    10
    INITRANS   1
    MAXTRANS   255
    STORAGE    (
                INITIAL          200M
                NEXT             20M
                MINEXTENTS       1
                MAXEXTENTS       2147483645
                PCTINCREASE      0
                FREELISTS        1
                FREELIST GROUPS  1
                BUFFER_POOL      DEFAULT
               ),  
  PARTITION DH200303 VALUES LESS THAN (TO_DATE(' 2003-04-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN'))
    LOGGING
    TABLESPACE TS$SLBLPD
    PCTUSED    80
    PCTFREE    10
    INITRANS   1
    MAXTRANS   255
    STORAGE    (
                INITIAL          200M
                NEXT             20M
                MINEXTENTS       1
                MAXEXTENTS       2147483645
                PCTINCREASE      0
                FREELISTS        1
                FREELIST GROUPS  1
                BUFFER_POOL      DEFAULT
               ),  
  PARTITION DH200304 VALUES LESS THAN (TO_DATE(' 2003-05-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN'))
    LOGGING
    TABLESPACE TS$SLBLPD
    PCTUSED    80
    PCTFREE    10
    INITRANS   1
    MAXTRANS   255
    STORAGE    (
                INITIAL          200M
                NEXT             20M
                MINEXTENTS       1
                MAXEXTENTS       2147483645
                PCTINCREASE      0
                FREELISTS        1
                FREELIST GROUPS  1
                BUFFER_POOL      DEFAULT
               ),  
  PARTITION DH200305 VALUES LESS THAN (TO_DATE(' 2003-06-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN'))
    LOGGING
    TABLESPACE TS$SLBLPD
    PCTUSED    80
    PCTFREE    10
    INITRANS   1
    MAXTRANS   255
    STORAGE    (
                INITIAL          200M
                NEXT             20M
                MINEXTENTS       1
                MAXEXTENTS       2147483645
                PCTINCREASE      0
                FREELISTS        1
                FREELIST GROUPS  1
                BUFFER_POOL      DEFAULT
               ),  
  PARTITION DH200306 VALUES LESS THAN (TO_DATE(' 2003-07-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN'))
    LOGGING
    TABLESPACE TS$SLBLPD
    PCTUSED    80
    PCTFREE    10
    INITRANS   1
    MAXTRANS   255
    STORAGE    (
                INITIAL          200M
                NEXT             20M
                MINEXTENTS       1
                MAXEXTENTS       2147483645
                PCTINCREASE      0
                FREELISTS        1
                FREELIST GROUPS  1
                BUFFER_POOL      DEFAULT
               ),  
  PARTITION DH200307 VALUES LESS THAN (TO_DATE(' 2003-08-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN'))
    LOGGING
    TABLESPACE TS$SLBLPD
    PCTUSED    80
    PCTFREE    10
    INITRANS   1
    MAXTRANS   255
    STORAGE    (
                INITIAL          200M
                NEXT             20M
                MINEXTENTS       1
                MAXEXTENTS       2147483645
                PCTINCREASE      0
                FREELISTS        1
                FREELIST GROUPS  1
                BUFFER_POOL      DEFAULT
               ),  
  PARTITION DH200308 VALUES LESS THAN (TO_DATE(' 2003-09-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN'))
    LOGGING
    TABLESPACE TS$SLBLPD
    PCTUSED    80
    PCTFREE    10
    INITRANS   1
    MAXTRANS   255
    STORAGE    (
                INITIAL          200M
                NEXT             20M
                MINEXTENTS       1
                MAXEXTENTS       2147483645
                PCTINCREASE      0
                FREELISTS        1
                FREELIST GROUPS  1
                BUFFER_POOL      DEFAULT
               ),  
  PARTITION DH200309 VALUES LESS THAN (TO_DATE(' 2003-10-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN'))
    LOGGING
    TABLESPACE TS$SLBLPD
    PCTUSED    80
    PCTFREE    10
    INITRANS   1
    MAXTRANS   255
    STORAGE    (
                INITIAL          200M
                NEXT             20M
                MINEXTENTS       1
                MAXEXTENTS       2147483645
                PCTINCREASE      0
                FREELISTS        1
                FREELIST GROUPS  1
                BUFFER_POOL      DEFAULT
               ),  
  PARTITION DH200310 VALUES LESS THAN (TO_DATE(' 2003-11-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN'))
    LOGGING
    TABLESPACE TS$SLBLPD
    PCTUSED    80
    PCTFREE    10
    INITRANS   1
    MAXTRANS   255
    STORAGE    (
                INITIAL          200M
                NEXT             20M
                MINEXTENTS       1
                MAXEXTENTS       2147483645
                PCTINCREASE      0
                FREELISTS        1
                FREELIST GROUPS  1
                BUFFER_POOL      DEFAULT
               ),  
  PARTITION DH200311 VALUES LESS THAN (TO_DATE(' 2003-12-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN'))
    LOGGING
    TABLESPACE TS$SLBLPD
    PCTUSED    80
    PCTFREE    10
    INITRANS   1
    MAXTRANS   255
    STORAGE    (
                INITIAL          200M
                NEXT             20M
                MINEXTENTS       1
                MAXEXTENTS       2147483645
                PCTINCREASE      0
                FREELISTS        1
                FREELIST GROUPS  1
                BUFFER_POOL      DEFAULT
               ),  
  PARTITION DH200312 VALUES LESS THAN (TO_DATE(' 2004-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN'))
    LOGGING
    TABLESPACE TS$SLBLPD
    PCTUSED    80
    PCTFREE    10
    INITRANS   1
    MAXTRANS   255
    STORAGE    (
                INITIAL          200M
                NEXT             20M
                MINEXTENTS       1
                MAXEXTENTS       2147483645
                PCTINCREASE      0
                FREELISTS        1
                FREELIST GROUPS  1
                BUFFER_POOL      DEFAULT
               ),  
  PARTITION DH200401 VALUES LESS THAN (maxvalue)
    LOGGING
    TABLESPACE TS$SLBLPD
    PCTUSED    80
    PCTFREE    10
    INITRANS   1
    MAXTRANS   255
    STORAGE    (
                INITIAL          200M
                NEXT             20M
                MINEXTENTS       1
                MAXEXTENTS       2147483645
                PCTINCREASE      0
                FREELISTS        1
                FREELIST GROUPS  1
                BUFFER_POOL      DEFAULT
               )
)
CACHE
NOPARALLEL;


CREATE UNIQUE INDEX IDX$LOAD_PROFILE ON LOAD_PROFILE
(DH, DST, ID_PONTOMED, GRANDEZA, ID_MMCFG)
  TABLESPACE TS$SLBLPI
  INITRANS   2
  MAXTRANS   255
  STORAGE    (
              INITIAL          100M
              NEXT             20M
              MINEXTENTS       1
              MAXEXTENTS       2147483645
              PCTINCREASE      0
             )
LOCAL (  
  PARTITION DH200209
    LOGGING
    TABLESPACE TS$SLBLPI
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          100M
                NEXT             20M
                MINEXTENTS       1
                MAXEXTENTS       2147483645
                PCTINCREASE      0
                FREELISTS        1
                FREELIST GROUPS  1
                BUFFER_POOL      DEFAULT
               ),  
  PARTITION DH200210
    LOGGING
    TABLESPACE TS$SLBLPI
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          100M
                NEXT             20M
                MINEXTENTS       1
                MAXEXTENTS       2147483645
                PCTINCREASE      0
                FREELISTS        1
                FREELIST GROUPS  1
                BUFFER_POOL      DEFAULT
               ),  
  PARTITION DH200211
    LOGGING
    TABLESPACE TS$SLBLPI
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          100M
                NEXT             20M
                MINEXTENTS       1
                MAXEXTENTS       2147483645
                PCTINCREASE      0
                FREELISTS        1
                FREELIST GROUPS  1
                BUFFER_POOL      DEFAULT
               ),  
  PARTITION DH200212
    LOGGING
    TABLESPACE TS$SLBLPI
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          100M
                NEXT             20M
                MINEXTENTS       1
                MAXEXTENTS       2147483645
                PCTINCREASE      0
                FREELISTS        1
                FREELIST GROUPS  1
                BUFFER_POOL      DEFAULT
               ),  
  PARTITION DH200301
    LOGGING
    TABLESPACE TS$SLBLPI
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          100M
                NEXT             20M
                MINEXTENTS       1
                MAXEXTENTS       2147483645
                PCTINCREASE      0
                FREELISTS        1
                FREELIST GROUPS  1
                BUFFER_POOL      DEFAULT
               ),  
  PARTITION DH200302
    LOGGING
    TABLESPACE TS$SLBLPI
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          100M
                NEXT             20M
                MINEXTENTS       1
                MAXEXTENTS       2147483645
                PCTINCREASE      0
                FREELISTS        1
                FREELIST GROUPS  1
                BUFFER_POOL      DEFAULT
               ),  
  PARTITION DH200303
    LOGGING
    TABLESPACE TS$SLBLPI
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          100M
                NEXT             20M
                MINEXTENTS       1
                MAXEXTENTS       2147483645
                PCTINCREASE      0
                FREELISTS        1
                FREELIST GROUPS  1
                BUFFER_POOL      DEFAULT
               ),  
  PARTITION DH200304
    LOGGING
    TABLESPACE TS$SLBLPI
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          100M
                NEXT             20M
                MINEXTENTS       1
                MAXEXTENTS       2147483645
                PCTINCREASE      0
                FREELISTS        1
                FREELIST GROUPS  1
                BUFFER_POOL      DEFAULT
               ),  
  PARTITION DH200305
    LOGGING
    TABLESPACE TS$SLBLPI
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          100M
                NEXT             20M
                MINEXTENTS       1
                MAXEXTENTS       2147483645
                PCTINCREASE      0
                FREELISTS        1
                FREELIST GROUPS  1
                BUFFER_POOL      DEFAULT
               ),  
  PARTITION DH200306
    LOGGING
    TABLESPACE TS$SLBLPI
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          100M
                NEXT             20M
                MINEXTENTS       1
                MAXEXTENTS       2147483645
                PCTINCREASE      0
                FREELISTS        1
                FREELIST GROUPS  1
                BUFFER_POOL      DEFAULT
               ),  
  PARTITION DH200307
    LOGGING
    TABLESPACE TS$SLBLPI
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          100M
                NEXT             20M
                MINEXTENTS       1
                MAXEXTENTS       2147483645
                PCTINCREASE      0
                FREELISTS        1
                FREELIST GROUPS  1
                BUFFER_POOL      DEFAULT
               ),  
  PARTITION DH200308
    LOGGING
    TABLESPACE TS$SLBLPI
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          100M
                NEXT             20M
                MINEXTENTS       1
                MAXEXTENTS       2147483645
                PCTINCREASE      0
                FREELISTS        1
                FREELIST GROUPS  1
                BUFFER_POOL      DEFAULT
               ),  
  PARTITION DH200309
    LOGGING
    TABLESPACE TS$SLBLPI
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          100M
                NEXT             20M
                MINEXTENTS       1
                MAXEXTENTS       2147483645
                PCTINCREASE      0
                FREELISTS        1
                FREELIST GROUPS  1
                BUFFER_POOL      DEFAULT
               ),  
  PARTITION DH200310
    LOGGING
    TABLESPACE TS$SLBLPI
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          100M
                NEXT             20M
                MINEXTENTS       1
                MAXEXTENTS       2147483645
                PCTINCREASE      0
                FREELISTS        1
                FREELIST GROUPS  1
                BUFFER_POOL      DEFAULT
               ),  
  PARTITION DH200311
    LOGGING
    TABLESPACE TS$SLBLPI
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          100M
                NEXT             20M
                MINEXTENTS       1
                MAXEXTENTS       2147483645
                PCTINCREASE      0
                FREELISTS        1
                FREELIST GROUPS  1
                BUFFER_POOL      DEFAULT
               ),  
  PARTITION DH200312
    LOGGING
    TABLESPACE TS$SLBLPI
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          100M
                NEXT             20M
                MINEXTENTS       1
                MAXEXTENTS       2147483645
                PCTINCREASE      0
                FREELISTS        1
                FREELIST GROUPS  1
                BUFFER_POOL      DEFAULT
               ),  
  PARTITION DH200401
    LOGGING
    TABLESPACE TS$SLBLPI
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          100M
                NEXT             20M
                MINEXTENTS       1
                MAXEXTENTS       2147483645
                PCTINCREASE      0
                FREELISTS        1
                FREELIST GROUPS  1
                BUFFER_POOL      DEFAULT
               )
)
NOPARALLEL;


CREATE INDEX IDX$LOAD_PROFILEM ON LOAD_PROFILE
(ID_PONTOMED, DH, DST, GRANDEZA, ID_MMCFG)
  TABLESPACE TS$SLBLPI
  INITRANS   2
  MAXTRANS   255
  STORAGE    (
              INITIAL          70M
              NEXT             20M
              MINEXTENTS       1
              MAXEXTENTS       2147483645
              PCTINCREASE      0
             )
LOCAL (  
  PARTITION DH200209
    LOGGING
    TABLESPACE TS$SLBLPI
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          70M
                NEXT             20M
                MINEXTENTS       1
                MAXEXTENTS       2147483645
                PCTINCREASE      0
                FREELISTS        1
                FREELIST GROUPS  1
                BUFFER_POOL      DEFAULT
               ),  
  PARTITION DH200210
    LOGGING
    TABLESPACE TS$SLBLPI
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          70M
                NEXT             20M
                MINEXTENTS       1
                MAXEXTENTS       2147483645
                PCTINCREASE      0
                FREELISTS        1
                FREELIST GROUPS  1
                BUFFER_POOL      DEFAULT
               ),  
  PARTITION DH200211
    LOGGING
    TABLESPACE TS$SLBLPI
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          70M
                NEXT             20M
                MINEXTENTS       1
                MAXEXTENTS       2147483645
                PCTINCREASE      0
                FREELISTS        1
                FREELIST GROUPS  1
                BUFFER_POOL      DEFAULT
               ),  
  PARTITION DH200212
    LOGGING
    TABLESPACE TS$SLBLPI
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          70M
                NEXT             20M
                MINEXTENTS       1
                MAXEXTENTS       2147483645
                PCTINCREASE      0
                FREELISTS        1
                FREELIST GROUPS  1
                BUFFER_POOL      DEFAULT
               ),  
  PARTITION DH200301
    LOGGING
    TABLESPACE TS$SLBLPI
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          70M
                NEXT             20M
                MINEXTENTS       1
                MAXEXTENTS       2147483645
                PCTINCREASE      0
                FREELISTS        1
                FREELIST GROUPS  1
                BUFFER_POOL      DEFAULT
               ),  
  PARTITION DH200302
    LOGGING
    TABLESPACE TS$SLBLPI
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          70M
                NEXT             20M
                MINEXTENTS       1
                MAXEXTENTS       2147483645
                PCTINCREASE      0
                FREELISTS        1
                FREELIST GROUPS  1
                BUFFER_POOL      DEFAULT
               ),  
  PARTITION DH200303
    LOGGING
    TABLESPACE TS$SLBLPI
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          70M
                NEXT             20M
                MINEXTENTS       1
                MAXEXTENTS       2147483645
                PCTINCREASE      0
                FREELISTS        1
                FREELIST GROUPS  1
                BUFFER_POOL      DEFAULT
               ),  
  PARTITION DH200304
    LOGGING
    TABLESPACE TS$SLBLPI
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          70M
                NEXT             20M
                MINEXTENTS       1
                MAXEXTENTS       2147483645
                PCTINCREASE      0
                FREELISTS        1
                FREELIST GROUPS  1
                BUFFER_POOL      DEFAULT
               ),  
  PARTITION DH200305
    LOGGING
    TABLESPACE TS$SLBLPI
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          70M
                NEXT             20M
                MINEXTENTS       1
                MAXEXTENTS       2147483645
                PCTINCREASE      0
                FREELISTS        1
                FREELIST GROUPS  1
                BUFFER_POOL      DEFAULT
               ),  
  PARTITION DH200306
    LOGGING
    TABLESPACE TS$SLBLPI
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          70M
                NEXT             20M
                MINEXTENTS       1
                MAXEXTENTS       2147483645
                PCTINCREASE      0
                FREELISTS        1
                FREELIST GROUPS  1
                BUFFER_POOL      DEFAULT
               ),  
  PARTITION DH200307
    LOGGING
    TABLESPACE TS$SLBLPI
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          70M
                NEXT             20M
                MINEXTENTS       1
                MAXEXTENTS       2147483645
                PCTINCREASE      0
                FREELISTS        1
                FREELIST GROUPS  1
                BUFFER_POOL      DEFAULT
               ),  
  PARTITION DH200308
    LOGGING
    TABLESPACE TS$SLBLPI
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          70M
                NEXT             20M
                MINEXTENTS       1
                MAXEXTENTS       2147483645
                PCTINCREASE      0
                FREELISTS        1
                FREELIST GROUPS  1
                BUFFER_POOL      DEFAULT
               ),  
  PARTITION DH200309
    LOGGING
    TABLESPACE TS$SLBLPI
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          70M
                NEXT             20M
                MINEXTENTS       1
                MAXEXTENTS       2147483645
                PCTINCREASE      0
                FREELISTS        1
                FREELIST GROUPS  1
                BUFFER_POOL      DEFAULT
               ),  
  PARTITION DH200310
    LOGGING
    TABLESPACE TS$SLBLPI
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          70M
                NEXT             20M
                MINEXTENTS       1
                MAXEXTENTS       2147483645
                PCTINCREASE      0
                FREELISTS        1
                FREELIST GROUPS  1
                BUFFER_POOL      DEFAULT
               ),  
  PARTITION DH200311
    LOGGING
    TABLESPACE TS$SLBLPI
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          70M
                NEXT             20M
                MINEXTENTS       1
                MAXEXTENTS       2147483645
                PCTINCREASE      0
                FREELISTS        1
                FREELIST GROUPS  1
                BUFFER_POOL      DEFAULT
               ),  
  PARTITION DH200312
    LOGGING
    TABLESPACE TS$SLBLPI
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          70M
                NEXT             20M
                MINEXTENTS       1
                MAXEXTENTS       2147483645
                PCTINCREASE      0
                FREELISTS        1
                FREELIST GROUPS  1
                BUFFER_POOL      DEFAULT
               ),  
  PARTITION DH200401
    LOGGING
    TABLESPACE TS$SLBLPI
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          70M
                NEXT             20M
                MINEXTENTS       1
                MAXEXTENTS       2147483645
                PCTINCREASE      0
                FREELISTS        1
                FREELIST GROUPS  1
                BUFFER_POOL      DEFAULT
               )
)
NOPARALLEL;


CREATE INDEX IDX$LOAD_PROFILEMMCFG ON LOAD_PROFILE
(ID_MMCFG)
LOGGING
TABLESPACE TS$SLBLPI
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          1000M
            NEXT             200M
            MINEXTENTS       1
            MAXEXTENTS       2147483645
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


CREATE UNIQUE INDEX PK$LOAD_PROFILE ON LOAD_PROFILE
(ID)
LOGGING
TABLESPACE TS$SLB
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          16K
            NEXT             16K
            MINEXTENTS       1
            MAXEXTENTS       2147483645
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


ALTER TABLE LOAD_PROFILE ADD (
  CONSTRAINT PK$LOAD_PROFILE PRIMARY KEY (ID)
    USING INDEX 
    TABLESPACE TS$SLB
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          16K
                NEXT             16K
                MINEXTENTS       1
                MAXEXTENTS       2147483645
                PCTINCREASE      0
                FREELISTS        1
                FREELIST GROUPS  1
               ));


ALTER TABLE LOAD_PROFILE ADD (
  CONSTRAINT FK$MMCFG_LP FOREIGN KEY (ID_MMCFG) 
    REFERENCES MMCFG (ID));

ALTER TABLE LOAD_PROFILE ADD (
  CONSTRAINT FK$PMED_LP FOREIGN KEY (ID_PONTOMED) 
    REFERENCES PONTOMED (ID));


GRANT ALTER, DELETE, INDEX, INSERT, REFERENCES, SELECT, UPDATE ON  LOAD_PROFILE TO SLB_USR;

