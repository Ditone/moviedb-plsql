--This procedure creates a table in the database for movie_details
--This procedure does NOT populate the table, the fix_movie_year procedure does
--The design idea was that I did not want to bloat this procedure with the logic foudn in the fix_movie_year procedure.

--This procedure will also check to make sure that a table does not already exist with the same name.
--If there is, the procedure will drop the table before creating the new table.

--This procedure MUST be run BEFORE fix_movie_year to function properly.
--This procedure MUST be run AFTER create_movie_details to function properly.


CREATE OR REPLACE PROCEDURE create_movie_details_table AS 
	create_table_exe_string VARCHAR (1000) :=
		'CREATE TABLE movie_details (
			movie_id NUMBER (20),
			movie_title VARCHAR(100),
			movie_year VARCHAR (4),
			
			PRIMARY KEY (movie_id)
		)';
		
	drop_table_exe_string VARCHAR (1000) :=
		'DROP TABLE movie_details CASCADE CONSTRAINTS';
	
BEGIN
	--The defined TABLE_EXISTS function returns 0 if there isn't a table already and any other positive integer if it does. 
	IF TABLE_EXISTS('movie_details') = 0 THEN
		DBMS_OUTPUT.PUT_LINE('Creating table movie_details.');
		EXECUTE IMMEDIATE create_table_exe_string;
	
	ELSE
		DBMS_OUTPUT.PUT_LINE ('Detected table already exists.');
		EXECUTE IMMEDIATE drop_table_exe_string;
		DBMS_OUTPUT.PUT_LINE ('Dropping table movie_details.');
		
		--This should instead be a recursive call to the procedure, seeing as the functionality already exists earlier in the procedure
		--I am not doing it this way since I don't have a strong enough understanding of how PL/SQL handles recursive calls
		
		DBMS_OUTPUT.PUT_LINE('Creating table movie_details.');
		EXECUTE IMMEDIATE create_table_exe_string;
	END IF;
END;