PROCEDURE analyze_financials (year_in IN NUMBER)
IS
	labor NUMBER;
	costs NUMBER;
	revenue NUMBER;

	pipe_status INTEGER;
BEGIN
	/*
	|| For each of the calculations, pack the year in the buffer and
	|| then send the message. 
	*/
	DBMS_PIPE.PACK_MESSAGE (year_in);
	pipe_status := DBMS_PIPE.SEND_MESSAGE ('admin_costs');

	DBMS_PIPE.PACK_MESSAGE (year_in);
	pipe_status := DBMS_PIPE.SEND_MESSAGE ('labor');

	DBMS_PIPE.PACK_MESSAGE (year_in);
	pipe_status := DBMS_PIPE.SEND_MESSAGE ('revenue');
	/* 
	|| Theoretically, listerner processes have now picked up the
	|| year number and have started their calculations. Call the
	|| RECEIVE_MESSAGE function to wait for a message back on the
	|| same pipe. Then unpack the calculated values.
	 */
	pipe_status := DBMS_PIPE.RECEIVE_MESSAGE ('admin_costs');
	DBMS_PIPE.UNPACK_MESSAGE (costs);

	pipe_status := DBMS_PIPE.RECEIVE_MESSAGE ('labor');
	DBMS_PIPE.UNPACK_MESSAGE (labor);

	pipe_status := DBMS_PIPE.RECEIVE_MESSAGE ('revenue');
	DBMS_PIPE.UNPACK_MESSAGE (revenue);
	/*
	|| This data is now available to the rest of the analysis
	|| which must be performed in the program.
	*/
	... complete analysis ...
END;

/*
 The listener loop which kicks off a calculation of labor costs
*/

DECLARE
	pipe_status INTEGER;
	the_year INTEGER;
	labor NUMBER := 0;
BEGIN
	LOOP
		/*
		|| Receive a message from analyze_financials. I will not wait
		|| for a message. Instead, I will return immedidately, but
		|| only process the data if the receive was successful.
		 */
		pipe_status := DBMS_PIPE.RECEIVE_MESSAGE ('labor');

		IF pipe_status = 0
		THEN
			/* Unpack the message into the year variable */
			DBMS_PIPE.UNPACK_MESSAGE (the_year);
	
			/* Calculate the labor costs */
			calc_labor (the_year);
		
			/* Pack the calculated value back into the message buffer. */
			DBMS_PIPE.PACK_MESSAGE (labor);
	
			/* Send the information back to analyze_financials. */
			pipe_status := DBMS_PIPE.SEND_MESSAGE ('labor');
		END IF;
	END LOOP;
END;	
