/* Formatted on 2003/10/06 18:05 (Formatter Plus v4.8.0) */
/*********************************************************************/
/** This Script shows the dependency tree for a given object. **/
/** For tables, it shows the FKs (Foreign Keys that reference **/
/** the table. **/
/** NOTE: the user must have grant select on: **/
/** sys.cdef$, sys.obj$, sys.con$, sys.dependecy$ **/
/** It may be necessary to reduce ARRAYSIZE or increase MAXDATA **/
/*********************************************************************/
UNDEF ObjName
ACCEPT ObjName prompt "Object Name ? "

COLUMN a heading "Object|Name" justify center format a35
COLUMN b heading "Constraint|Name" justify center format a35

SELECT LPAD (' ', (a.nivel - 1) * 2) || obj.NAME a,
       LPAD (' ', (a.nivel - 1) * 2) || cons.NAME b
  FROM SYS.obj$ obj,
       SYS.con$ cons,
       (SELECT     obj# obj#, con#, LEVEL nivel
              FROM SYS.cdef$
             WHERE rcon# IS NOT NULL AND robj# IS NOT NULL
        CONNECT BY robj# = PRIOR obj# AND robj# != obj#
                   AND PRIOR robj# != PRIOR obj#
        START WITH robj# =
                      (SELECT obj#
                         FROM SYS.obj$
                        WHERE              /name = upper('&&ObjName') AND 
                              TYPE = 2 AND owner# = USERENV ('SCHEMAID'))) a
 WHERE cons.con# = a.con# AND obj.obj# = a.obj# AND obj.TYPE = 2
UNION ALL
SELECT LPAD (' ', (a.nivel - 1) * 2) || obj.NAME a, TO_CHAR (NULL)
  FROM SYS.obj$ obj,
       (SELECT     d_obj# obj#, LEVEL nivel
              FROM SYS.dependency$
        CONNECT BY p_obj# = PRIOR d_obj#
        START WITH p_obj# =
                      (SELECT obj#
                         FROM SYS.obj$
                        WHERE              name = upper('&&ObjName') AND 
                              owner# = USERENV ('SCHEMAID'))) a
 WHERE obj.obj# = a.obj# AND obj.TYPE != 2