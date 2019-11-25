CREATE OR REPLACE FUNCTION verifySQLQuery(IN user_stmt text, IN key_stmt text)
	RETURNS text AS
	$$
	DECLARE
      -- Student's script
			user_script VARCHAR(255):= CONCAT('CREATE TEMPORARY TABLE temp1 AS ', user_stmt);
      -- Professor's script
			key_script VARCHAR(255):= CONCAT('CREATE TEMPORARY TABLE temp2 AS ', key_stmt);
	BEGIN
    -- Temporary tables with the same name must be deleted in order to prevent conflicts
		DISCARD TEMP;

    -- Create temporary tables
		-- EXCEPTION: https://www.postgresql.org/docs/9.1/plpgsql-control-structures.html
		-- Error codes: https://www.postgresql.org/docs/10/errcodes-appendix.html
		BEGIN
			EXECUTE user_script;
		EXCEPTION
	    WHEN undefined_table THEN
	      RAISE NOTICE 'The table appointed by the student does not exist';
				RAISE INFO '%', user_stmt;
	      RETURN('False');
			/* WHEN OTHERS THEN */
				/* RAISE NOTICE 'The query written by the student is not valid'; */
				/* RETURN('False'). */
    END;
		BEGIN
			EXECUTE key_script;
		EXCEPTION
	    WHEN undefined_table THEN
        RAISE NOTICE 'The table appointed by the professor does not exist';
				RAISE INFO '%', key_stmt;
        RETURN ('False');
			/* WHEN OTHERS THEN */
				/* RAISE NOTICE 'The query written by the professor is not valid'; */
				/* RETURN('False'); */
    END;
    -- EXCEPT operator: http://www.postgresqltutorial.com/postgresql-tutorial/postgresql-except/
		IF EXISTS (TABLE temp1 EXCEPT TABLE temp2) THEN
			RETURN('False');
		ELSIF EXISTS (TABLE temp2 EXCEPT TABLE temp1) THEN
			RETURN('False');
		ELSE
			RETURN('True');
		END IF;

    -- Delete temporary tables
		DISCARD TEMP;
	END;
	$$ LANGUAGE plpgsql;
