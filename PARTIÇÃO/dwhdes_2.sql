drop table dbauditeste.satauditoria;

CREATE TABLE dbauditeste.satauditoria
(
  SQSATAUDITORIA  NUMBER(18)                    NOT NULL,
  IDTABELA        NUMBER(5)                     NOT NULL,
  IDMAQUINA       CHAR(10 BYTE),
  CDUSUARIO       NUMBER(10),
  CDSISTEMA       NUMBER(3),
  CDFORM          NUMBER(3),
  CDFUNCAO        NUMBER(3),
  DTLOGAUDIT      DATE                          NOT NULL,
  IDOPERACAO      CHAR(1 BYTE)                  NOT NULL,
  DBLOGIN         VARCHAR2(30 BYTE),
  OSLOGIN         VARCHAR2(30 BYTE),
  DSPROGRAMA      VARCHAR2(64 BYTE),
  DSMAQUINA       VARCHAR2(64 BYTE),
  DSURL           VARCHAR2(500 BYTE)
)
TABLESPACE ts1mdl_aud_dwh
PCTUSED    80
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          1 m
            NEXT             1 m
            MINEXTENTS       1
            MAXEXTENTS       2147483645
            PCTINCREASE      0
           )
LOGGING
PARTITION BY RANGE (dtlogaudit)
(
  PARTITION p2000 VALUES LESS THAN (TO_DATE('01-01-2001 00:00:00', 'DD-MM-YYYY HH24:MI:SS'))
    LOGGING
    TABLESPACE ts1mdl_aud_dwh_p2000
    PCTUSED    80
    PCTFREE    10
    INITRANS   1
    MAXTRANS   255
    STORAGE    (
                INITIAL          1 m
                NEXT             1 m
                MINEXTENTS       1
                MAXEXTENTS       2147483645
                PCTINCREASE      0
                FREELISTS        1
                FREELIST GROUPS  1
                BUFFER_POOL      DEFAULT
               ),
  PARTITION p2001 VALUES LESS THAN (TO_DATE('01-01-2002 00:00:00', 'DD-MM-YYYY HH24:MI:SS'))
    LOGGING
    TABLESPACE ts1mdl_aud_dwh_p2001
    PCTUSED    80
    PCTFREE    10
    INITRANS   1
    MAXTRANS   255
    STORAGE    (
                INITIAL          1 m
                NEXT             1 m
                MINEXTENTS       1
                MAXEXTENTS       2147483645
                PCTINCREASE      0
                FREELISTS        1
                FREELIST GROUPS  1
                BUFFER_POOL      DEFAULT
               ),
  PARTITION p2002 VALUES LESS THAN (TO_DATE('01-01-2003 00:00:00', 'DD-MM-YYYY HH24:MI:SS'))
    LOGGING
    TABLESPACE ts1mdl_aud_dwh_p2002
    PCTUSED    80
    PCTFREE    10
    INITRANS   1
    MAXTRANS   255
    STORAGE    (
                INITIAL          1 m
                NEXT             1 m
                MINEXTENTS       1
                MAXEXTENTS       2147483645
                PCTINCREASE      0
                FREELISTS        1
                FREELIST GROUPS  1
                BUFFER_POOL      DEFAULT
               ),
  PARTITION p2003 VALUES LESS THAN (TO_DATE('01-01-2004 00:00:00', 'DD-MM-YYYY HH24:MI:SS'))
    LOGGING
    TABLESPACE ts1mdl_aud_dwh_p2003
    PCTUSED    80
    PCTFREE    10
    INITRANS   1
    MAXTRANS   255
    STORAGE    (
                INITIAL          1 m
                NEXT             1 m
                MINEXTENTS       1
                MAXEXTENTS       2147483645
                PCTINCREASE      0
                FREELISTS        1
                FREELIST GROUPS  1
                BUFFER_POOL      DEFAULT
               ),
  PARTITION p2004 VALUES LESS THAN (TO_DATE('01-01-2005 00:00:00', 'DD-MM-YYYY HH24:MI:SS'))
    LOGGING
    TABLESPACE ts1mdl_aud_dwh_p2004
    PCTUSED    80
    PCTFREE    10
    INITRANS   1
    MAXTRANS   255
    STORAGE    (
                INITIAL          1 m
                NEXT             1 m
                MINEXTENTS       1
                MAXEXTENTS       2147483645
                PCTINCREASE      0
                FREELISTS        1
                FREELIST GROUPS  1
                BUFFER_POOL      DEFAULT
               ),
  PARTITION p2005 VALUES LESS THAN (TO_DATE('01-01-2006 00:00:00', 'DD-MM-YYYY HH24:MI:SS'))
    LOGGING
    TABLESPACE ts1mdl_aud_dwh_p2005
    PCTUSED    80
    PCTFREE    10
    INITRANS   1
    MAXTRANS   255
    STORAGE    (
                INITIAL          1 m
                NEXT             1 m
                MINEXTENTS       1
                MAXEXTENTS       2147483645
                PCTINCREASE      0
                FREELISTS        1
                FREELIST GROUPS  1
                BUFFER_POOL      DEFAULT
               ),
  PARTITION p2006 VALUES LESS THAN (TO_DATE('01-01-2007 00:00:00', 'DD-MM-YYYY HH24:MI:SS'))
    LOGGING
    TABLESPACE ts1mdl_aud_dwh_p2006
    PCTUSED    80
    PCTFREE    10
    INITRANS   1
    MAXTRANS   255
    STORAGE    (
                INITIAL          1 m
                NEXT             1 m
                MINEXTENTS       1
                MAXEXTENTS       2147483645
                PCTINCREASE      0
                FREELISTS        1
                FREELIST GROUPS  1
                BUFFER_POOL      DEFAULT
               ),
  PARTITION p2007 VALUES LESS THAN (TO_DATE('01-01-2008 00:00:00', 'DD-MM-YYYY HH24:MI:SS'))
    LOGGING
    TABLESPACE ts1mdl_aud_dwh_p2007
    PCTUSED    80
    PCTFREE    10
    INITRANS   1
    MAXTRANS   255
    STORAGE    (
                INITIAL          1 m
                NEXT             1 m
                MINEXTENTS       1
                MAXEXTENTS       2147483645
                PCTINCREASE      0
                FREELISTS        1
                FREELIST GROUPS  1
                BUFFER_POOL      DEFAULT
               ),
  PARTITION p2008 VALUES LESS THAN (TO_DATE('01-01-2009 00:00:00', 'DD-MM-YYYY HH24:MI:SS'))
    LOGGING
    TABLESPACE ts1mdl_aud_dwh_p2008
    PCTUSED    80
    PCTFREE    10
    INITRANS   1
    MAXTRANS   255
    STORAGE    (
                INITIAL          1 m
                NEXT             1 m
                MINEXTENTS       1
                MAXEXTENTS       2147483645
                PCTINCREASE      0
                FREELISTS        1
                FREELIST GROUPS  1
                BUFFER_POOL      DEFAULT
               ),
  PARTITION p2009 VALUES LESS THAN (MAXVALUE)
    LOGGING
    TABLESPACE ts1mdl_aud_dwh_p2009
    PCTUSED    80
    PCTFREE    10
    INITRANS   1
    MAXTRANS   255
    STORAGE    (
                INITIAL          1 m
                NEXT             1 m
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

/* Formatted on 2009/11/12 10:16 (Formatter Plus v4.8.8) */
CREATE INDEX dbauditeste.ixsatauditoria04 ON dbauditeste.satauditoria
(idtabela)
  TABLESPACE ts1mil_aud_dwh
  INITRANS   2
  MAXTRANS   255
  STORAGE    (
              INITIAL          1 m
              NEXT             1 m
              MINEXTENTS       1
              MAXEXTENTS       2147483645
              PCTINCREASE      0
             )
LOCAL (
  PARTITION p2000
    LOGGING
    TABLESPACE ts1mil_aud_dwh_p2000
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          1 m
                NEXT             1 m
                MINEXTENTS       1
                MAXEXTENTS       2147483645
                PCTINCREASE      0
                FREELISTS        1
                FREELIST GROUPS  1
                BUFFER_POOL      DEFAULT
               ),
  PARTITION p2001
    LOGGING
    TABLESPACE ts1mil_aud_dwh_p2001
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          1 m
                NEXT             1 m
                MINEXTENTS       1
                MAXEXTENTS       2147483645
                PCTINCREASE      0
                FREELISTS        1
                FREELIST GROUPS  1
                BUFFER_POOL      DEFAULT
               ),
  PARTITION p2002
    LOGGING
    TABLESPACE ts1mil_aud_dwh_p2002
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          1 m
                NEXT             1 m
                MINEXTENTS       1
                MAXEXTENTS       2147483645
                PCTINCREASE      0
                FREELISTS        1
                FREELIST GROUPS  1
                BUFFER_POOL      DEFAULT
               ),
  PARTITION p2003
    LOGGING
    TABLESPACE ts1mil_aud_dwh_p2003
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          1 m
                NEXT             1 m
                MINEXTENTS       1
                MAXEXTENTS       2147483645
                PCTINCREASE      0
                FREELISTS        1
                FREELIST GROUPS  1
                BUFFER_POOL      DEFAULT
               ),
  PARTITION p2004
    LOGGING
    TABLESPACE ts1mil_aud_dwh_p2004
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          1 m
                NEXT             1 m
                MINEXTENTS       1
                MAXEXTENTS       2147483645
                PCTINCREASE      0
                FREELISTS        1
                FREELIST GROUPS  1
                BUFFER_POOL      DEFAULT
               ),
  PARTITION p2005
    LOGGING
    TABLESPACE ts1mil_aud_dwh_p2005
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          1 m
                NEXT             1 m
                MINEXTENTS       1
                MAXEXTENTS       2147483645
                PCTINCREASE      0
                FREELISTS        1
                FREELIST GROUPS  1
                BUFFER_POOL      DEFAULT
               ),
  PARTITION p2006
    LOGGING
    TABLESPACE ts1mil_aud_dwh_p2006
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          1 m
                NEXT             1 m
                MINEXTENTS       1
                MAXEXTENTS       2147483645
                PCTINCREASE      0
                FREELISTS        1
                FREELIST GROUPS  1
                BUFFER_POOL      DEFAULT
               ),
  PARTITION p2007
    LOGGING
    TABLESPACE ts1mil_aud_dwh_p2007
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          1 m
                NEXT             1 m
                MINEXTENTS       1
                MAXEXTENTS       2147483645
                PCTINCREASE      0
                FREELISTS        1
                FREELIST GROUPS  1
                BUFFER_POOL      DEFAULT
               ),
  PARTITION p2008
    LOGGING
    TABLESPACE ts1mil_aud_dwh_p2008
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          1 m
                NEXT             1 m
                MINEXTENTS       1
                MAXEXTENTS       2147483645
                PCTINCREASE      0
                FREELISTS        1
                FREELIST GROUPS  1
                BUFFER_POOL      DEFAULT
               ),
  PARTITION p2009
    LOGGING
    TABLESPACE ts1mil_aud_dwh_p2009
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          1 m
                NEXT             1 m
                MINEXTENTS       1
                MAXEXTENTS       2147483645
                PCTINCREASE      0
                FREELISTS        1
                FREELIST GROUPS  1
                BUFFER_POOL      DEFAULT
               )
)
NOPARALLEL;

CREATE INDEX dbauditeste.ixsatauditoria03 ON dbauditeste.satauditoria
(dtlogaudit)
  TABLESPACE ts1mil_aud_dwh
  INITRANS   2
  MAXTRANS   255
  STORAGE    (
              INITIAL          1 m
              NEXT             1 m
              MINEXTENTS       1
              MAXEXTENTS       2147483645
              PCTINCREASE      0
             )
LOCAL (
  PARTITION p2000
    LOGGING
    TABLESPACE ts1mil_aud_dwh_p2000
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          1 m
                NEXT             1 m
                MINEXTENTS       1
                MAXEXTENTS       2147483645
                PCTINCREASE      0
                FREELISTS        1
                FREELIST GROUPS  1
                BUFFER_POOL      DEFAULT
               ),
  PARTITION p2001
    LOGGING
    TABLESPACE ts1mil_aud_dwh_p2001
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          1 m
                NEXT             1 m
                MINEXTENTS       1
                MAXEXTENTS       2147483645
                PCTINCREASE      0
                FREELISTS        1
                FREELIST GROUPS  1
                BUFFER_POOL      DEFAULT
               ),
  PARTITION p2002
    LOGGING
    TABLESPACE ts1mil_aud_dwh_p2002
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          1 m
                NEXT             1 m
                MINEXTENTS       1
                MAXEXTENTS       2147483645
                PCTINCREASE      0
                FREELISTS        1
                FREELIST GROUPS  1
                BUFFER_POOL      DEFAULT
               ),
  PARTITION p2003
    LOGGING
    TABLESPACE ts1mil_aud_dwh_p2003
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          1 m
                NEXT             1 m
                MINEXTENTS       1
                MAXEXTENTS       2147483645
                PCTINCREASE      0
                FREELISTS        1
                FREELIST GROUPS  1
                BUFFER_POOL      DEFAULT
               ),
  PARTITION p2004
    LOGGING
    TABLESPACE ts1mil_aud_dwh_p2004
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          1 m
                NEXT             1 m
                MINEXTENTS       1
                MAXEXTENTS       2147483645
                PCTINCREASE      0
                FREELISTS        1
                FREELIST GROUPS  1
                BUFFER_POOL      DEFAULT
               ),
  PARTITION p2005
    LOGGING
    TABLESPACE ts1mil_aud_dwh_p2005
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          1 m
                NEXT             1 m
                MINEXTENTS       1
                MAXEXTENTS       2147483645
                PCTINCREASE      0
                FREELISTS        1
                FREELIST GROUPS  1
                BUFFER_POOL      DEFAULT
               ),
  PARTITION p2006
    LOGGING
    TABLESPACE ts1mil_aud_dwh_p2006
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          1 m
                NEXT             1 m
                MINEXTENTS       1
                MAXEXTENTS       2147483645
                PCTINCREASE      0
                FREELISTS        1
                FREELIST GROUPS  1
                BUFFER_POOL      DEFAULT
               ),
  PARTITION p2007
    LOGGING
    TABLESPACE ts1mil_aud_dwh_p2007
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          1 m
                NEXT             1 m
                MINEXTENTS       1
                MAXEXTENTS       2147483645
                PCTINCREASE      0
                FREELISTS        1
                FREELIST GROUPS  1
                BUFFER_POOL      DEFAULT
               ),
  PARTITION p2008
    LOGGING
    TABLESPACE ts1mil_aud_dwh_p2008
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          1 m
                NEXT             1 m
                MINEXTENTS       1
                MAXEXTENTS       2147483645
                PCTINCREASE      0
                FREELISTS        1
                FREELIST GROUPS  1
                BUFFER_POOL      DEFAULT
               ),
  PARTITION p2009
    LOGGING
    TABLESPACE ts1mil_aud_dwh_p2009
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          1 m
                NEXT             1 m
                MINEXTENTS       1
                MAXEXTENTS       2147483645
                PCTINCREASE      0
                FREELISTS        1
                FREELIST GROUPS  1
                BUFFER_POOL      DEFAULT
               )
)
NOPARALLEL;

CREATE UNIQUE INDEX dbauditeste.pk_satauditoria ON dbauditeste.satauditoria
(sqsatauditoria)
  TABLESPACE ts1mil_aud_dwh
  INITRANS   2
  MAXTRANS   255
  STORAGE    (
              INITIAL          1 m
              NEXT             1 m
              MINEXTENTS       1
              MAXEXTENTS       2147483645
              PCTINCREASE      0
             )
LOCAL (
  PARTITION p2000
    LOGGING
    TABLESPACE ts1mil_aud_dwh_p2000
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          1 m
                NEXT             1 m
                MINEXTENTS       1
                MAXEXTENTS       2147483645
                PCTINCREASE      0
                FREELISTS        1
                FREELIST GROUPS  1
                BUFFER_POOL      DEFAULT
               ),
  PARTITION p2001
    LOGGING
    TABLESPACE ts1mil_aud_dwh_p2001
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          1 m
                NEXT             1 m
                MINEXTENTS       1
                MAXEXTENTS       2147483645
                PCTINCREASE      0
                FREELISTS        1
                FREELIST GROUPS  1
                BUFFER_POOL      DEFAULT
               ),
  PARTITION p2002
    LOGGING
    TABLESPACE ts1mil_aud_dwh_p2002
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          1 m
                NEXT             1 m
                MINEXTENTS       1
                MAXEXTENTS       2147483645
                PCTINCREASE      0
                FREELISTS        1
                FREELIST GROUPS  1
                BUFFER_POOL      DEFAULT
               ),
  PARTITION p2003
    LOGGING
    TABLESPACE ts1mil_aud_dwh_p2003
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          1 m
                NEXT             1 m
                MINEXTENTS       1
                MAXEXTENTS       2147483645
                PCTINCREASE      0
                FREELISTS        1
                FREELIST GROUPS  1
                BUFFER_POOL      DEFAULT
               ),
  PARTITION p2004
    LOGGING
    TABLESPACE ts1mil_aud_dwh_p2004
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          1 m
                NEXT             1 m
                MINEXTENTS       1
                MAXEXTENTS       2147483645
                PCTINCREASE      0
                FREELISTS        1
                FREELIST GROUPS  1
                BUFFER_POOL      DEFAULT
               ),
  PARTITION p2005
    LOGGING
    TABLESPACE ts1mil_aud_dwh_p2005
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          1 m
                NEXT             1 m
                MINEXTENTS       1
                MAXEXTENTS       2147483645
                PCTINCREASE      0
                FREELISTS        1
                FREELIST GROUPS  1
                BUFFER_POOL      DEFAULT
               ),
  PARTITION p2006
    LOGGING
    TABLESPACE ts1mil_aud_dwh_p2006
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          1 m
                NEXT             1 m
                MINEXTENTS       1
                MAXEXTENTS       2147483645
                PCTINCREASE      0
                FREELISTS        1
                FREELIST GROUPS  1
                BUFFER_POOL      DEFAULT
               ),
  PARTITION p2007
    LOGGING
    TABLESPACE ts1mil_aud_dwh_p2007
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          1 m
                NEXT             1 m
                MINEXTENTS       1
                MAXEXTENTS       2147483645
                PCTINCREASE      0
                FREELISTS        1
                FREELIST GROUPS  1
                BUFFER_POOL      DEFAULT
               ),
  PARTITION p2008
    LOGGING
    TABLESPACE ts1mil_aud_dwh_p2008
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          1 m
                NEXT             1 m
                MINEXTENTS       1
                MAXEXTENTS       2147483645
                PCTINCREASE      0
                FREELISTS        1
                FREELIST GROUPS  1
                BUFFER_POOL      DEFAULT
               ),
  PARTITION p2009
    LOGGING
    TABLESPACE ts1mil_aud_dwh_p2009
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          1 m
                NEXT             1 m
                MINEXTENTS       1
                MAXEXTENTS       2147483645
                PCTINCREASE      0
                FREELISTS        1
                FREELIST GROUPS  1
                BUFFER_POOL      DEFAULT
               )
)
NOPARALLEL;

ALTER TABLE dbauditeste.satauditoria ADD (
  CONSTRAINT pk_satauditoria
 PRIMARY KEY
 (sqsatauditoria)
    USING INDEX
    TABLESPACE ts1mil_aud_dwh
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          1 m
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
                FREELISTS        1
                FREELIST GROUPS  1
               ));