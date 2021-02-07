--This procedure creates the user_details table
--It then populates it by pulling from the users_temp table that was generated from importing the data using SQLDeveloper's import functionality.

--This procedure will check if there is already a user_details table, and will drop it if there is.
--Ideally this would also drop the temporary tables, however, the program must be able to run multiple times, and re importing the temporary tables takes time.

CREATE OR REPLACE PROCEDURE create_and_populate_user_details_table AS 
	--dynamic sql to create the table
	create_table_exe_string VARCHAR (1000) :=
		'CREATE TABLE user_details (
			user_id NUMBER (20),
			gender VARCHAR (1),
			age NUMBER (2),
			occupation NUMBER (2),
			zip VARCHAR (20),
			
			PRIMARY KEY (user_id),
			CONSTRAINT check_occupation_code CHECK (occupation BETWEEN 0 AND 20),
			CONSTRAINT check_age_code CHECK (age BETWEEN 1 AND 56)
		)';
		
	--dynamic sql to drop the table
	drop_table_exe_string VARCHAR (1000) :=
		'DROP TABLE user_details CASCADE CONSTRAINTS';
	
	--SQL string that will take the values of the each row and insert them into the table 
	insert_string VARCHAR (1000) := 'INSERT INTO user_details VALUES (:userid, :gender, :age, :occupation, :zip)';
	
	
	--Loop variables
	CURSOR insert_cur IS
		SELECT *
		FROM temp_user;
	found_row insert_cur%ROWTYPE;
	
	insert_count NUMBER;
	
BEGIN
	--The defined TABLE_EXISTS function returns 0 if there isn't a table already and any other positive integer if it does. 

	IF TABLE_EXISTS('user_details') = 0 THEN
		DBMS_OUTPUT.PUT_LINE('Creating table user_details.');
		EXECUTE IMMEDIATE create_table_exe_string;
		
	ELSE
		DBMS_OUTPUT.PUT_LINE ('Detected table already exists.');
		EXECUTE IMMEDIATE drop_table_exe_string;
		DBMS_OUTPUT.PUT_LINE ('Dropping table user_details.');
		
		--This should instead be a recursive call to the procedure, seeing as the functionality already exists earlier in the procedure.
		--I am not doing it this way since I don't have a strong enough understanding of how PL/SQL handles recursive calls.
		
		DBMS_OUTPUT.PUT_LINE('Creating table user_details.');
		EXECUTE IMMEDIATE create_table_exe_string;
	END IF;
		
	--Copy the data from the temporary table into the table with the constraints
	insert_count := 0;
	
	--Cursor goes through and takes all the data from each row
	FOR found_row IN insert_cur LOOP
		--found_row.[VARIABLE NAME] in the INSERT below are based on the names of the temporary table that was created for the import
		EXECUTE IMMEDIATE insert_string USING 
			found_row.user_id, found_row.gender, found_row.age, found_row.occupation, found_row.zip;
		insert_count := insert_count + SQL%ROWCOUNT;	
		
	END LOOP;
	--Cursor is closed for us from the for loop.
	
	DBMS_OUTPUT.PUT_LINE ('Successfully inserted ' || insert_count || ' rows into the user_details table.');
	DBMS_OUTPUT.PUT_LINE ('End of create_and_populate_user_details_table procedure.');
END;