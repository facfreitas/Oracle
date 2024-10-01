REM *********************************************************
REM *
REM * ALERT_LOG_MANAGER
REM *
REM *  Allows viewing of the current alert log file as well
REM *  as selected trace files. All code is provided on an
REM *  "as is/where is" basis and no warranty is provided
REM *  explcitly or implied
REM *
REM * 15-MAY-2002 - focus on trace files
REM * DD-MON-YYYY - whatever you want to add
REM
REM ***********************************************************
 
CLEAR COLUMNS
CLEAR BREAKS
CLEAR COMPUTES

REM Load the background dump directory
COLUMN bdump_dir NOPRINT NEW_VALUE bdump_dir
SELECT trim(value) bdump_dir
  FROM v$parameter
 WHERE name = 'background_dump_dest';

REM Load the user dump directory
COLUMN udump_dir NOPRINT NEW_VALUE udump_dir
SELECT trim(value) udump_dir
  FROM v$parameter
 WHERE name = 'user_dump_dest';

REM Create directories
CREATE OR REPLACE DIRECTORY log_dir AS '&&bdump_dir';
CREATE OR REPLACE DIRECTORY trace_dir AS '&&udump_dir';

REM Drop existing alert log table
DROP TABLE alert_log;

REM Create a table for the alert log
CREATE TABLE alert_log
(detail_line     VARCHAR2(2000)
 ) ORGANIZATION EXTERNAL
 (TYPE oracle_loader
  DEFAULT DIRECTORY log_dir
  ACCESS PARAMETERS
 (  RECORDS DELIMITED BY NEWLINE
    NOBADFILE
    NOLOGFILE
    NODISCARDFILE
    FIELDS TERMINATED by '   '
    MISSING FIELD VALUES ARE NULL
    (detail_line ) 
)
 LOCATION('&alert_log_file_name') )
 PARALLEL 5
 REJECT LIMIT UNLIMITED;

CREATE OR REPLACE PACKAGE alert_log_manager AS

  /*
    ||
    || ALERT_LOG_MANAGER
    ||
    || Processes lines from the alert log to provide
    || information. Also loads trace files for viewing.
    ||
    || Requires : SELECT ANY DICTIONARY
    ||            CREATE ANY TABLE
    ||
    || list_traces  => lists trace file info including the
    ||                date of creation
    || show_trace   => show contents of a chosen trace file
    || toggle_stack => toggle display of stack details in trace
    ||                 file
    || add_keyword  => add a keyword to list trace files for
    || rem_keyword  => remove a keyword from list
    ||
    || 02-MAY-2002 Darryl Hurley    Initial version
    || 09-MAY-2002                  Added trace file loading and keywords
    || 15-MAY-2002                  Commenting and cleanup
    ||                              Fixed bug in flag reliance causing
    ||                              lines to display if keyword but not
    ||                              trace
    ||
  */

  PROCEDURE list_traces;
  PROCEDURE show_trace ( p_id NUMBER );

  PROCEDURE toggle_stack;

  PROCEDURE add_keyword ( p_keyword VARCHAR2 );
  PROCEDURE rem_keyword ( p_keyword VARCHAR2 := NULL );

END alert_log_manager;
/

CREATE OR REPLACE PACKAGE BODY alert_log_manager AS

  -- get entries from the alert log
  CURSOR curs_get_alert IS
  SELECT *
    FROM alert_log;

  -- hold current entry from the alert log including the
  -- time and full text description
  TYPE v_line_type IS TABLE OF VARCHAR2(2000)
    INDEX BY BINARY_INTEGER;
  v_current_entry v_line_type;

  -- hold log of trace files for future loading
  v_trace_table v_line_type;

  -- hold keywords
  v_keyword_table v_line_type;

  v_show_trace BOOLEAN := TRUE;   -- show particular trace file
  v_show_stack BOOLEAN := FALSE;  -- show call stack from trace file

  /*------------------------------------------------------------------------*/
  PROCEDURE output_trace IS
  /*------------------------------------------------------------------------*/
  BEGIN

    -- trace file separation line
    DBMS_OUTPUT.PUT_LINE(RPAD('-',50,'-'));

    -- for every alert log line related to the trace file
    FOR counter IN 1..v_current_entry.COUNT LOOP

      -- if this is the first line the output the trace file
      -- identifier
      IF counter = 1 THEN
        DBMS_OUTPUT.PUT('(' || v_trace_table.COUNT || ') ');
      END IF;

      DBMS_OUTPUT.PUT_LINE(v_current_entry(counter));

    END LOOP;

  END output_trace;

  /*------------------------------------------------------------------------*/
  FUNCTION its_a_date( p_line VARCHAR2 ) RETURN BOOLEAN IS
  /*------------------------------------------------------------------------*/
    v_date DATE;
  BEGIN
    v_date := TO_DATE(SUBSTR(p_line,1,24),'Dy Mon DD HH24:MI:SS YYYY');
    RETURN(TRUE);
  EXCEPTION
    WHEN OTHERS THEN
      RETURN(FALSE);
  END its_a_date;

  /*------------------------------------------------------------------------*/
  FUNCTION line_contains_keyword ( p_line VARCHAR2 ) RETURN BOOLEAN IS
  /*------------------------------------------------------------------------*/

    v_element PLS_INTEGER;
    v_ret_val BOOLEAN := FALSE;

  BEGIN

    -- determine if line contains any of the keywords
    v_element := v_keyword_table.FIRST;

    LOOP

      EXIT WHEN v_element IS NULL;

      IF INSTR(p_line,v_keyword_table(v_element)) > 0 THEN
        v_ret_val := TRUE;
        v_show_trace := TRUE;
        EXIT;
      END IF;

      v_element := v_keyword_table.NEXT(v_element);

    END LOOP;

    RETURN(v_ret_val);

  END line_contains_keyword;

  /*------------------------------------------------------------------------*/
  PROCEDURE list_traces IS
  /*------------------------------------------------------------------------*/

    /*
      ||
      || Find trace file entries with this algorithm:
      || 1) Query the alert log line by line
      || 2) If the line is a date then:
      || 3) If we were handling a trace file entry then
      ||    output it.
      || 4) If the line contains the UDUMP directory (where
      ||    trace files go) then flag as start of trace file
      ||    and save
      ||
    */

    v_its_a_trace BOOLEAN := FALSE;    -- flag denoting trace file entry
    v_trace_name  VARCHAR2(1000);      -- trace file name

  BEGIN

    -- init index by tables
    v_trace_table.DELETE;

    -- for every line in the alert log...
    FOR v_alert_rec IN curs_get_alert LOOP

      -- is this line a date?
      IF its_a_date(v_alert_rec.detail_line) THEN

        -- if we were on a trace before we hit this date
        -- then output the index by table now
        IF v_its_a_trace THEN

          -- if this trace flagged as showable
          -- then do so, otherwise remove it from
          -- the trace file list
          IF v_show_trace THEN
            output_trace;
          ELSE
            v_trace_table.DELETE(v_trace_table.LAST);
          END IF;

          -- reset flags to show nothing
          v_its_a_trace := FALSE;
          v_show_trace := FALSE;

        END IF;

        -- clean out the index by table
        v_current_entry.DELETE;

        -- if there are any keywords then default to
        -- not showing the trace, otheriwse assume it
        -- will be shown
        IF NVL(v_keyword_table.COUNT,0) > 0 THEN
          v_show_trace := FALSE;
        ELSE
          v_show_trace := TRUE;
        END IF;

      END IF;  -- is this line a date?

      -- check if the line contains any keywords
      IF line_contains_keyword(v_alert_rec.detail_line) THEN
        v_show_trace := TRUE;
      END IF;

      -- add the current line to the current list for potential output later
      v_current_entry(NVL(v_current_entry.LAST,0) + 1) := v_alert_rec.detail_line;

      -- if the UDUMP directory is contained in the line then we are in the midst
      -- of a trace entry, dont forget to save the name of the trace file as well
      IF INSTR(v_alert_rec.detail_line,'&&udump_dir') > 0 THEN

        v_its_a_trace := TRUE;

        -- parse out the trace file name removing the final colon and the directory
        v_trace_name := TRIM(SUBSTR(v_alert_rec.detail_line,INSTR(v_alert_rec.detail_line,'&&udump_dir'),200));
        v_trace_name := SUBSTR(v_trace_name,1,LENGTH(v_trace_name) - 1);
        v_trace_name := TRIM(SUBSTR(v_trace_name,LENGTH('&&udump_dir') + 2,200));
        v_trace_table(NVL(v_trace_table.LAST,0) + 1) := v_trace_name;

      END IF;

    END LOOP;  -- every line in the alert log

  END list_traces;

  /*------------------------------------------------------------------------*/
  PROCEDURE load_trace ( p_id NUMBER ) IS
  /*------------------------------------------------------------------------*/

    v_sql        VARCHAR2(2000);
    v_trace_name VARCHAR2(200);

  BEGIN

    -- drop the existing trace file table
    BEGIN
      EXECUTE IMMEDIATE 'DROP TABLE trace_file';
    EXCEPTION
      WHEN OTHERS THEN
        IF SQLCODE = -942 THEN
          NULL;
        ELSE
          RAISE;
        END IF;
    END;

    v_trace_name := v_trace_table(p_id);

    -- create a new trace file table
    v_sql := 'CREATE TABLE trace_file ' ||
             '(detail_line VARCHAR2(2000)) ' ||
             'ORGANIZATION EXTERNAL ' ||
             '(TYPE oracle_loader ' ||
             'DEFAULT DIRECTORY trace_dir ' ||
             'ACCESS PARAMETERS ' ||
             '(RECORDS DELIMITED BY NEWLINE ' ||
             'NOBADFILE ' ||
             'NOLOGFILE ' ||
             'NODISCARDFILE ' ||
             'FIELDS TERMINATED by ''  ''' ||
             'MISSING FIELD VALUES ARE NULL ' ||
             '(detail_line )) ' ||
             'LOCATION(''' || v_trace_name || ''')) ' ||
             'REJECT LIMIT UNLIMITED';

    EXECUTE IMMEDIATE v_sql;

  END load_trace;

  /*------------------------------------------------------------------------*/
  PROCEDURE output_line ( p_line VARCHAR2 ) IS
  /*------------------------------------------------------------------------*/

    v_start_at NUMBER;

  BEGIN

    v_start_at := 1;
    WHILE v_start_at <= LENGTH(p_line) LOOP
      DBMS_OUTPUT.PUT_LINE(SUBSTR(p_line,v_start_at,255));
      v_start_at := v_start_at + 255;
    END LOOP;

  END output_line;

  /*------------------------------------------------------------------------*/
  PROCEDURE show_trace ( p_id NUMBER ) IS
  /*------------------------------------------------------------------------*/

    TYPE v_ref_cursor_type IS REF CURSOR;
    v_ref_cursor v_ref_cursor_type;
    v_detail VARCHAR2(2000);

  BEGIN

    -- load the trace file
    load_trace(p_id);

    -- use a ref cursor to loop through the newly created
    -- table containing the trace file
    OPEN v_ref_cursor FOR 'SELECT * FROM trace_file';

    LOOP

      FETCH v_ref_cursor INTO v_detail;

      EXIT WHEN v_ref_cursor%NOTFOUND;
      EXIT WHEN NOT v_show_stack AND TRIM(v_detail) IN ('----- Call Stack Trace -----',
                                                        '----- PL/SQL Call Stack -----');

      output_line(v_detail);

    END LOOP;

    CLOSE v_ref_cursor;

  END show_trace;

  /*------------------------------------------------------------------------*/
  PROCEDURE toggle_stack IS
  /*------------------------------------------------------------------------*/
  BEGIN
    v_show_stack := NOT v_show_stack;
  END toggle_stack;

  /*------------------------------------------------------------------------*/
  PROCEDURE add_keyword ( p_keyword VARCHAR2 ) IS
  /*------------------------------------------------------------------------*/
  BEGIN
    v_keyword_table(NVL(v_keyword_table.LAST,0) + 1) := p_keyword;
  END add_keyword;

  /*------------------------------------------------------------------------*/
  PROCEDURE rem_keyword ( p_keyword VARCHAR2 := NULL ) IS
  /*------------------------------------------------------------------------*/

    v_element PLS_INTEGER;

  BEGIN

    -- if no keyword then remove them all
    IF p_keyword IS NULL THEN

      v_keyword_table.DELETE;

    ELSE  -- remove specific keyword

      v_element := v_keyword_table.FIRST;

      -- for every keyword entered...
      LOOP

        EXIT WHEN v_element IS NULL;

        IF v_keyword_table(v_element) = p_keyword THEN
          v_keyword_table.DELETE(v_element);
          EXIT;
        END IF;

        v_element := v_keyword_table.NEXT(v_element);

      END LOOP;  -- every keyword

    END IF;  -- keyword passed?

  END rem_keyword;

END alert_log_manager;
/
