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
		EXECUTE user_script;
		EXECUTE key_script;

    -- EXCEPT operator: http://www.postgresqltutorial.com/postgresql-tutorial/postgresql-except/
		IF EXISTS (TABLE temp1 EXCEPT TABLE temp2) THEN
			RETURN('False');
		ELSIF EXISTS (TABLE temp2 EXCEPT TABLE temp1) THEN
			RETURN ('False');
		ELSE
			RETURN('True');
		END IF;

    -- Delete temporary tables
		DISCARD TEMP;
	END;
	$$ LANGUAGE plpgsql;
