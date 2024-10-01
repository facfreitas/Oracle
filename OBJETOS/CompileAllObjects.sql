set echo on
set feedback on

/**********************************************************************************************************/
/*                                                                                                        */
/* Procedure:   CompileAllObjects                                                                         */
/* Description: This procedure compiles all invalid objects in a given schema or a complete database.     */
/*              This process only takes place in the server and therefore is usually is mutch faster      */
/*              then other spooling based scripts.                                                        */
/*                                                                                                        */
/*              The following parameter can be used:                                                      */
/*                 1. theSchema:      if not null given schema will be used, else to complete database.   */
/*                 2. theIncludeJava: if set to 1 also compiles java objects.                             */
/*                 3. theMaxPasses:   the maximal number of compilation passed used for dependencies.     */
/*                 4. theDebugFlag:   if set to one debug messages are send using pipe messages in a pipe */
/*                                    called 'plsql_debug'. Use the Meterial Dreams tool PlSqlTrace to    */
/*                                    retrieve the debug messages.                                        */
/*                                                                                                        */
/* Version:    	1.0.0                                                                                     */
/*                                                                                                        */
/* Required:	Oracle Server Version 7.3 or higher, this script should be executed as user SYS or SYSTEM */
/*              or with full DBA rights granted.                                                          */
/*              If you want to use the debugging features you should laso use the PL/SQL-Trace utility    */
/*              that can be found on the Material Dreams web site.                                        */
/*                                                                                                        */
/* Written by: 	Material Dreams                                                                           */
/* EMail:       info@materialdreams.com                                                                   */
/* WWW:         http://www.materialdreams.com/oracle                                                      */
/*                                                                                                        */
/* License:     This script can be freely distributed as long as this header will not be removed and      */
/*              improvements and changes to this script will be reported to the author.                   */
/*                                                                                                        */
/*              Copyright (c) 1995-2004 by Material Dreams. All Rights Reserved.                          */
/*                                                                                                        */
/**********************************************************************************************************/

CREATE OR REPLACE
PROCEDURE CompileAllObjects	(
				theSchema	IN	VARCHAR2	DEFAULT NULL,
				theIncludeJava	IN	INTEGER		DEFAULT 0,
				theMaxPasses	IN	INTEGER		DEFAULT 10,
				theDebugFlag	IN	INTEGER		DEFAULT 0
				)
IS
	aSqlCmd			VARCHAR2(4000);
	aCursor			INTEGER;
	aRetCode		INTEGER;
	aObjectCount	INTEGER;
	aPass			INTEGER;
	aMessage		VARCHAR2(8000);
	aStatus			NUMBER;

	CURSOR cObjects(cSchema IN VARCHAR2) IS
		SELECT		owner, object_type, object_name, DECODE(object_type, 'TYPE', 1, 'OPERATOR', 2, 'PACKAGE', 3, 4) ord
		FROM  		all_objects
		WHERE  		(status <> 'VALID')
			AND	(cSchema IS NULL OR owner = upper(cSchema))
			AND 	object_type IN (	'DIMENSION',
							'FUNCTION',
							'INDEXTYPE',
							'JAVA CLASS',
							'JAVA SOURCE',
							'MATERIALIZED VIEW',
							'OPERATOR',
							'PACKAGE',
							'PACKAGE BODY',
							'PROCEDURE',
							'TRIGGER',
							'TYPE',
							'TYPE BODY',
							'VIEW'
						)
		ORDER BY	ord;

BEGIN

	aCursor := sys.dbms_sql.open_cursor;
	aPass   := 1;

	LOOP
		aObjectCount := 0;

		FOR aRec IN cObjects(theSchema) LOOP

			IF (aRec.object_type = 'PACKAGE') THEN
				aSqlCmd := 'ALTER PACKAGE "' || aRec.owner || '"."' || aRec.object_name || '" COMPILE PACKAGE';
			ELSIF (aRec.object_type = 'PACKAGE BODY') THEN
				aSqlCmd := 'ALTER PACKAGE "' || aRec.owner || '"."' || aRec.object_name || '" COMPILE BODY';
			ELSIF (aRec.object_type = 'TYPE') THEN
				aSqlCmd := 'ALTER TYPE "' || aRec.owner || '"."' || aRec.object_name || '" COMPILE SPECIFICATION';
			ELSIF (aRec.object_type = 'TYPE BODY') THEN
				aSqlCmd := 'ALTER TYPE "' || aRec.owner || '"."' || aRec.object_name || '" COMPILE BODY';
			ELSE
				aSqlCmd := 'ALTER ' || aRec.object_type || ' "' || aRec.owner || '"."' || aRec.object_name || '" COMPILE';
			END IF;

			IF (theIncludeJava <> 1 AND aRec.object_type LIKE '%JAVA%') THEN
				aSqlCmd := NULL;
			END IF;

			IF (aSqlCmd IS NOT NULL) THEN

				aObjectCount := aObjectCount + 1;

				aMessage := 'CompileAllObjects pass ' || TO_CHAR(aPass, '99999') || ' processing object ' || TO_CHAR(aObjectCount, '99999')

|| ' [' || aSqlCmd || ']';

				BEGIN
					dbms_sql.parse(aCursor, aSqlCmd, DBMS_SQL.NATIVE);
					aRetCode := dbms_sql.execute(aCursor);
				EXCEPTION WHEN OTHERS THEN
					aMessage := aMessage || ' => ERROR # ' || SQLCODE || ' - ' || SQLERRM;
					NULL;
				END;

				IF (theDebugFlag <> 0) THEN
					dbms_pipe.pack_message(LENGTH(aMessage));
					dbms_pipe.pack_message(aMessage);
					aStatus := dbms_pipe.send_message('plsql_debug', dbms_pipe.maxwait, 1024*1024);
				END IF;

			END IF;

		END LOOP;

		EXIT WHEN aObjectCount = 0 OR aPass >= theMaxPasses;

		aPass := aPass + 1;

	END LOOP;

	dbms_sql.close_cursor(aCursor);

	IF theDebugFlag <> 0 THEN
		aMessage := '*** The procedure CompileAllObjects has compiled ' || TO_CHAR(aObjectCount) || ' objects in ' || aPass || ' passes ***';
		dbms_pipe.pack_message(LENGTH(aMessage));
		dbms_pipe.pack_message(aMessage);
		aStatus := dbms_pipe.send_message('plsql_debug', dbms_pipe.maxwait, 1024*1024);
	END IF;

END CompileAllObjects;
/
