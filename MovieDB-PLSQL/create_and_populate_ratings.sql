--Assume that we have imported data with the schema:
--	temp_ratings (UserID, MovieID, ratings, time_submitted)
--  SCHEMA for the created table must be as follows
--  The value from the temporary ratings table for date_submitted is in seconds
--  This procedure will need to make sure that that gets converted into a date
/*
		CREATE TABLE ratings(
			user_id			NUMBER,
			movie_id		NUMBER,
			stars			NUMBER,
			date_submitted	DATE,
			
			PRIMARY KEY (user_id, movie_id),
			FOREIGN KEY (user_id) REFERENCES user_details(user_id),
			FOREIGN KEY (movie_id) REFERENCES movie_details(movie_id);
		)
		
*/

--This function will take a while, seeing as it's doing ~200,000 inserts with the current data
--That being said, I can't find any other logic that improves this scenerio, as even MERGE uses inserts

CREATE OR REPLACE PROCEDURE create_and_populate_ratings_table AS
	--create table script
	create_table_exe_string VARCHAR (1000) :=
		'CREATE TABLE ratings(
			user_id			NUMBER,
			movie_id		NUMBER,
			stars			NUMBER,
			date_submitted	DATE,
			
			PRIMARY KEY (user_id, movie_id),
			FOREIGN KEY (user_id) REFERENCES user_details(user_id),
			FOREIGN KEY (movie_id) REFERENCES movie_details(movie_id)
		)';
	
	--Drop table script
	drop_table_exe_string VARCHAR (1000) :=
		'DROP TABLE ratings CASCADE CONSTRAINTS';
	
    --Insert script
    insert_string VARCHAR (200) := 
        'INSERT INTO ratings VALUES (:ui, :mi, :st, :ts)';
    
	--Loop variables
	CURSOR insert_cur IS
		SELECT *
		FROM temp_ratings;
	found_row insert_cur%ROWTYPE;
	
	date_conversion DATE;
	
BEGIN 
	--The defined TABLE_EXISTS function returns 0 if there isn't a table already and any other positive integer if it does. 
	IF TABLE_EXISTS('ratings') = 0 THEN
		DBMS_OUTPUT.PUT_LINE('Creating table ratings.');
		EXECUTE IMMEDIATE create_table_exe_string;
		
	ELSE
		DBMS_OUTPUT.PUT_LINE ('Detected table already exists.');
		EXECUTE IMMEDIATE drop_table_exe_string;
		DBMS_OUTPUT.PUT_LINE ('Dropping table ratings.');
		
		--This should instead be a recursive call to the procedure, seeing as the functionality already exists earlier in the procedure.
		--I am not doing it this way since I don't have a strong enough understanding of how PL/SQL handles recursive calls.
		
		DBMS_OUTPUT.PUT_LINE('Creating table ratings.');
		EXECUTE IMMEDIATE create_table_exe_string;
	END IF;
		
		
	--THIS LOOP WILL TAKE A WHILE
	--That being said, I can't figure out another way to improve this. Would love some insight if possible.
	DBMS_OUTPUT.PUT_LINE ('Entering insert loop.');
    
    FOR found_row IN insert_cur LOOP
		--found_row.[VARIABLE NAME] in the INSERT below are based on the names of the temporary table that was created for the import
		
		date_conversion := TO_DATE('19700101', 'yyyymmdd') + (found_row.time_submitted/24/60/60);
        
        EXECUTE IMMEDIATE insert_string USING 
			found_row.user_id, found_row.movie_id, found_row.ratings, date_conversion;
        
	END LOOP;
	
	--There is no insert_count for this procedure since SQL%ROWCOUNT was not returning anything despite the rest of the updates to the table
	--My guess is that the compiler is doing something funky behind the scenes to improve the runtime- aka idiot proofing my code for me
	--Compiler is probably pattern matching on "GIANT CHUNK OF INSERT STATEMENTS". 
	
    DBMS_OUTPUT.PUT_LINE ('Exiting insert loop.');
    DBMS_OUTPUT.PUT_LINE ('');
    DBMS_OUTPUT.PUT_LINE ('End of create/populate ratings table.');

END;