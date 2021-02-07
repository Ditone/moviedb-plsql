

--Purpose of this function is to create our own test case to see if the table already exists.
--To do so, we're going to look to see if when we call the function the data is NULL or not

--If there is no data, then we return 0, telling the procedure that there isn't already a table
--If there is data already, then we return any value greater than 0, telling the proceure that there is alerady a table and it needs to be dropped.
 
CREATE OR REPLACE FUNCTION table_exists (
	table_name VARCHAR)
	RETURN NUMBER AS 
	did_return_string VARCHAR (30);

BEGIN
	SELECT tname
	INTO did_return_string
	FROM TAB
	WHERE tname = UPPER(table_name);

	RETURN LENGTH(did_return_string);
EXCEPTION
	WHEN NO_DATA_FOUND THEN
		RETURN 0;
END;

--Dynamic SQL Procedure to create the three temporary tables that will be used to store the excel data
--Since these tables are temporary, there is no schema, and we will treat them as the raw data
--Will check to see if there already exists a table. But if there is, it will simply ignore the "table already exists" error
--This is to avoid multiple re-imports of the data.

CREATE OR REPLACE PROCEDURE create_temporary_tables AS

--create table string 1
create_table_exe_string_movies VARCHAR (1000) :=
	'CREATE TABLE temp_movie (
		movie_id NUMBER,
		movie_title VARCHAR (200),
		movie_genre VARCHAR (200))';
		
--create table string 2
--Importing the time in seconds variable from the data as just a number
--The procedure that finalizes the ratings table will convert it into a date variable
create_table_exe_string_ratings VARCHAR (1000) :=
	'CREATE TABLE temp_ratings (
		user_id NUMBER,
		movie_id NUMBER,
		ratings NUMBER,
		time_submitted NUMBER)';
		
--create table string 3
--zip has to be a VARCHAR since some of the data has hyphenated zipcodes
--Left it this way as arthihmetic is not practical for zipcodes
create_table_exe_string_user VARCHAR(1000) :=
	'CREATE TABLE temp_user (
		user_id NUMBER,
		gender VARCHAR (2),
		age NUMBER,
		occupation NUMBER,
		zip VARCHAR(20))';
		
BEGIN
	IF TABLE_EXISTS('temp_movie') = 0 THEN
		DBMS_OUTPUT.PUT_LINE('Creating table temp_movie.');
		EXECUTE IMMEDIATE create_table_exe_string_movies;
	ELSE
		DBMS_OUTPUT.PUT_LINE('Ignoring table creation, temp_movie table already exists.');
	END IF;
	
	IF TABLE_EXISTS('temp_ratings') = 0 THEN
		DBMS_OUTPUT.PUT_LINE('Creating table temp_ratings.');
		EXECUTE IMMEDIATE create_table_exe_string_ratings;
	ELSE
		DBMS_OUTPUT.PUT_LINE('Ignoring table creation, temp_ratings table already exists.');
	END IF;
	
	IF TABLE_EXISTS('temp_user') = 0 THEN
		DBMS_OUTPUT.PUT_LINE('Creating table temp_user.');
		EXECUTE IMMEDIATE create_table_exe_string_user;
	ELSE
		DBMS_OUTPUT.PUT_LINE('Ignoring table creation, temp_user table already exists.');
	END IF;
	
	DBMS_OUTPUT.PUT_LINE ('End of creating temporary tables.');
	DBMS_OUTPUT.PUT_LINE ('When you need to drop all the temporary tables, run the procedure drop_all_temp_tables.');
END;

--Dynamic SQL Procedure in order to create the age_key table. 
--In addition to creating the age_key table, this procedure will also populate it with its explicit values.
--Assumption is that the ranges defined in the readme attached to the data will not need to be changed

-->>IMPORTANT ASSUMPTION<<
-- WHEN USED: ANY POSITIVE VALUE NOT FOUND IN AGE_KEY.AGE_TRANSLATE CORRESPONDS TO AGE_KEY.AGE_CODE '56'.

--This procedure will also check to make sure that a table does not already exist with the same name.
--If there is, the procedure will drop the table before creating the new table.

CREATE OR REPLACE PROCEDURE create_and_populate_age_key_table AS 
	--create table string
	create_table_exe_string VARCHAR (1000) :=
		'CREATE TABLE age_key 
			(age_code NUMBER (2), 
			age_translate NUMBER (2), 
			PRIMARY KEY (age_code, age_translate)
			)';
	
	--drop table string
	drop_table_exe_string VARCHAR (1000) :=
		'DROP TABLE age_key CASCADE CONSTRAINTS';
	
	--populate string
	populate_table_exe_string VARCHAR (1000);
	
	--loop variable
	age_tracker NUMBER := 1;
	insert_tracker NUMBER := 0;
	
BEGIN
	--The defined TABLE_EXISTS function returns 0 if there isn't a table already and any other positive integer if it does. 
	IF TABLE_EXISTS('age_key') = 0 THEN
		DBMS_OUTPUT.PUT_LINE('Creating table age_key.');
		EXECUTE IMMEDIATE create_table_exe_string;
	
	ELSE
		DBMS_OUTPUT.PUT_LINE ('Detected table already exists.');
		EXECUTE IMMEDIATE drop_table_exe_string;
		DBMS_OUTPUT.PUT_LINE ('Dropping table age_key.');
		
		--This should instead be a recursive call to the procedure, seeing as the functionality already exists earlier in the procedure
		--I am not doing it this way since I don't have a strong enough understanding of how PL/SQL handles recursive calls
		
		DBMS_OUTPUT.PUT_LINE('Creating table age_key.');
		EXECUTE IMMEDIATE create_table_exe_string;
	END IF;
	
	--after the schema is created, the values are inserted into the table
	--since this is a defined key from the readme attached to the data, this must be hardcoded
	
	populate_table_exe_string :=
		'INSERT INTO age_key VALUES (:ac, :at)';
	
	FOR age_tracker IN 1..17 LOOP
		EXECUTE IMMEDIATE populate_table_exe_string USING 1, age_tracker;
		insert_tracker := insert_tracker + SQL%ROWCOUNT;
	END LOOP;
	
	
	FOR age_tracker IN 18..24 LOOP
		EXECUTE IMMEDIATE populate_table_exe_string USING 18, age_tracker;
		insert_tracker := insert_tracker + SQL%ROWCOUNT;
	END LOOP;
	
	FOR age_tracker IN 25..34 LOOP
		EXECUTE IMMEDIATE populate_table_exe_string USING 25, age_tracker;
		insert_tracker := insert_tracker + SQL%ROWCOUNT;
	END LOOP;
	
	FOR age_tracker IN 35..44 LOOP
		EXECUTE IMMEDIATE populate_table_exe_string USING 35, age_tracker;
		insert_tracker := insert_tracker + SQL%ROWCOUNT;
	END LOOP;
	
	FOR age_tracker IN 45..49 LOOP
		EXECUTE IMMEDIATE populate_table_exe_string USING 45, age_tracker;
		insert_tracker := insert_tracker + SQL%ROWCOUNT;
	END LOOP;
	
	FOR age_tracker IN 50..55 LOOP
		EXECUTE IMMEDIATE populate_table_exe_string USING 50, age_tracker;
		insert_tracker := insert_tracker + SQL%ROWCOUNT;
	END LOOP;
	
	EXECUTE IMMEDIATE populate_table_exe_string USING 56, 56;
	insert_tracker := insert_tracker + SQL%ROWCOUNT;
	
	
	DBMS_OUTPUT.PUT_LINE ('Inserted ' || insert_tracker || ' rows into age_key');
	DBMS_OUTPUT.PUT_LINE('Finished inserting values into age_key.');
	
END;

--Dynamic SQL Procedure in order to create the job_key table. 
--In addition to creating the job_key table, this procedure will also populate it with its explicit values.
--Assumption is that the keys and their values defined in the readme attached to the data will not need to be changed

--This procedure will also check to make sure that a table does not already exist with the same name.
--If there is, the procedure will drop the table before creating the new table.

CREATE OR REPLACE PROCEDURE create_and_populate_job_key_table AS 
	--create table script
	create_table_exe_string VARCHAR (1000) :=
		'CREATE TABLE job_key (
			job_code NUMBER (2),
			job_translate VARCHAR (30),
			
			PRIMARY KEY (job_code)
		)';
		
	--drop table script
	drop_table_exe_string VARCHAR (1000) :=
		'DROP TABLE job_key CASCADE CONSTRAINTS';
	
	--populate table script
	populate_table_exe_string VARCHAR (1000);
	
	--count variable
	insert_count NUMBER;
	
BEGIN
	--The defined TABLE_EXISTS function returns 0 if there isn't a table already and any other positive integer if it does. 
	IF TABLE_EXISTS('job_key') = 0 THEN
		DBMS_OUTPUT.PUT_LINE('Creating table job_key.');
		EXECUTE IMMEDIATE create_table_exe_string;
	
	ELSE
		DBMS_OUTPUT.PUT_LINE ('Detected table already exists.');
		EXECUTE IMMEDIATE drop_table_exe_string;
		DBMS_OUTPUT.PUT_LINE ('Dropping table job_key.');
		
		--This should instead be a recursive call to the procedure, seeing as the functionality already exists earlier in the procedure
		--I am not doing it this way since I don't have a strong enough understanding of how PL/SQL handles recursive calls
		
		DBMS_OUTPUT.PUT_LINE('Creating table job_key.');
		EXECUTE IMMEDIATE create_table_exe_string;
	END IF;
	
	--after the schema is created, the values are inserted into the table
	--since this is a defined key from the readme attached to the data, this must be hardcoded
	--given time, will attempt to convert this into a read file, so that more jobs can be added 
	
	DBMS_OUTPUT.PUT_LINE ('Beginning inserts on job_key');
	insert_count := 0;
	
	populate_table_exe_string :=
		'INSERT INTO job_key VALUES (:ac, :at)'
		
	EXECUTE IMMEDIATE populate_table_exe_string USING 0, 'Other or not specified';
	insert_count := insert_count + SQL%ROWCOUNT;
	EXECUTE IMMEDIATE populate_table_exe_string USING 1, 'Academic/Educator';
	insert_count := insert_count + SQL%ROWCOUNT;
	EXECUTE IMMEDIATE populate_table_exe_string USING 2, 'Artist';
	insert_count := insert_count + SQL%ROWCOUNT;
	EXECUTE IMMEDIATE populate_table_exe_string USING 3, 'Clerical/Admin';
	insert_count := insert_count + SQL%ROWCOUNT;
	EXECUTE IMMEDIATE populate_table_exe_string USING 4, 'College/Grad Student';
	insert_count := insert_count + SQL%ROWCOUNT;
	EXECUTE IMMEDIATE populate_table_exe_string USING 5, 'Customer Service';
	insert_count := insert_count + SQL%ROWCOUNT;
	EXECUTE IMMEDIATE populate_table_exe_string USING 6, 'Doctor/Health Care';
	insert_count := insert_count + SQL%ROWCOUNT;
	EXECUTE IMMEDIATE populate_table_exe_string USING 7, 'Executive/Managerial';
	insert_count := insert_count + SQL%ROWCOUNT;
	EXECUTE IMMEDIATE populate_table_exe_string USING 8, 'Farmer';
	insert_count := insert_count + SQL%ROWCOUNT;
	EXECUTE IMMEDIATE populate_table_exe_string USING 9, 'Homemaker';
	insert_count := insert_count + SQL%ROWCOUNT;
	EXECUTE IMMEDIATE populate_table_exe_string USING 10, 'K-12 Student';
	insert_count := insert_count + SQL%ROWCOUNT;
	EXECUTE IMMEDIATE populate_table_exe_string USING 11, 'Lawyer';
	insert_count := insert_count + SQL%ROWCOUNT;
	EXECUTE IMMEDIATE populate_table_exe_string USING 12, 'Programmer';
	insert_count := insert_count + SQL%ROWCOUNT;
	EXECUTE IMMEDIATE populate_table_exe_string USING 13, 'Retired';
	insert_count := insert_count + SQL%ROWCOUNT;
	EXECUTE IMMEDIATE populate_table_exe_string USING 14, 'Sales/Marketing';
	insert_count := insert_count + SQL%ROWCOUNT;
	EXECUTE IMMEDIATE populate_table_exe_string USING 15, 'Scientist';
	insert_count := insert_count + SQL%ROWCOUNT;
	EXECUTE IMMEDIATE populate_table_exe_string USING 16, 'Self-Employed';
	insert_count := insert_count + SQL%ROWCOUNT;
	EXECUTE IMMEDIATE populate_table_exe_string USING 17, 'Technician/Engineer';
	insert_count := insert_count + SQL%ROWCOUNT;
	EXECUTE IMMEDIATE populate_table_exe_string USING 18, 'Tradesman/Craftsman';
	insert_count := insert_count + SQL%ROWCOUNT;
	EXECUTE IMMEDIATE populate_table_exe_string USING 19, 'Unemployed';
	insert_count := insert_count + SQL%ROWCOUNT;
	EXECUTE IMMEDIATE populate_table_exe_string USING 20, 'Writer';
	insert_count := insert_count + SQL%ROWCOUNT;
	
	DBMS_OUTPUT.PUT_LINE('Inserted ' || insert_count || ' rows into job_key');
	DBMS_OUTPUT.PUT_LINE('Finished inserting values into job_key.');
	
END;

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

--This procedure creates a table in the database for movie_details
--This procedure does NOT populate the table, the fix_movie_year procedure does
--The design idea was that I did not want to bloat this procedure with the logic foudn in the fix_movie_year procedure.

--This procedure will also check to make sure that a table does not already exist with the same name.
--If there is, the procedure will drop the table before creating the new table.

--This procedure MUST be run BEFORE fix_movie_year to function properly.



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

--This procedure creates a table in the database for movie_catagory
--This procedure does NOT populate the table, the fix_movie_catagory procedure does
--The design idea was that I did not want to bloat this procedure with the logic foudn in the fix_movie_catagory procedure.

--This procedure will also check to make sure that a table does not already exist with the same name.
--If there is, the procedure will drop the table before creating the new table.

--This procedure MUST be run BEFORE fix_movie_catagory to function properly.
--This procedure MUST be run AFTER create_movie_details to function properly.


CREATE OR REPLACE PROCEDURE create_movie_catagory_table AS 
	create_table_exe_string VARCHAR (1000) :=
		'CREATE TABLE movie_catagory (
			movie_id NUMBER (20),
			movie_catagory VARCHAR (15),
			
			PRIMARY KEY (movie_id, movie_catagory),
			FOREIGN KEY (movie_id) REFERENCES movie_details(movie_id)
		)';
		
	drop_table_exe_string VARCHAR (1000) :=
		'DROP TABLE movie_catagory CASCADE CONSTRAINTS';
	
BEGIN
	--The defined TABLE_EXISTS function returns 0 if there isn't a table already and any other positive integer if it does. 
	IF TABLE_EXISTS('movie_catagory') = 0 THEN
		DBMS_OUTPUT.PUT_LINE('Creating table movie_catagory.');
		EXECUTE IMMEDIATE create_table_exe_string;
	
	ELSE
		DBMS_OUTPUT.PUT_LINE ('Detected table already exists.');
		EXECUTE IMMEDIATE drop_table_exe_string;
		DBMS_OUTPUT.PUT_LINE ('Dropping table movie_catagory.');
		
		--This should instead be a recursive call to the procedure, seeing as the functionality already exists earlier in the procedure
		--I am not doing it this way since I don't have a strong enough understanding of how PL/SQL handles recursive calls
		
		DBMS_OUTPUT.PUT_LINE('Creating table movie_catagory.');
		EXECUTE IMMEDIATE create_table_exe_string;
	END IF;
END;

CREATE OR REPLACE PROCEDURE fix_movie_catagory AS
	--Basic cursor to loop through the temporary table
	--Movie_Genre table only has fields of movie_id and movie_genre
	CURSOR catagory_snatcher IS
		SELECT movie_id, movie_genre
		FROM temp_movie;
		--WHERE movie_id = 160;
		--Test case with most annoying catagory of Sci-Fi
		--Initially tried the match case '(\w+|\w+|/-w+)(/||$)'
		--(one+ words, or one+words followed by the literal '-' followed by one+words) followed by the literal '|' or the end of line character. 

	--Necessary Dynamic SQL for insert
	insert_string VARCHAR (100) := 
		'INSERT INTO movie_catagory VALUES (:mid, :mg)'; 

	--Loop Variables
	temp_snatched catagory_snatcher%ROWTYPE;
	temp_catagory VARCHAR (100);

	--Return Variable
	return_catagory VARCHAR (100);
	insert_count NUMBER (20) := 0;

BEGIN
	--Cursor 'catagory_snatcher' visits every row in the temporary table, takes the movie_genre value(s), and reads them into the temporary catagory
	DBMS_OUTPUT.PUT_LINE ('Beginning loop on temp_move table.');
	FOR temp_snatched IN catagory_snatcher LOOP
		temp_catagory := temp_snatched.movie_genre;

		--Don't enjoy nesting loops
		--However in this case it seems to be the only way to extract all values from the unknown length list of catagories from each collumn in the temporary table 
		--Loop condition relies on temp_catagory getting smaller after every loop. Tested on empty movie_genre collumns, as well as longest movie_genre collumns and didn't break
		--Need to do insert inside of the while loop, as it's the only time that both movie_id and return_catagory are unique, and each return_catagory is recorded

		WHILE LENGTH(temp_catagory) > 0 LOOP
			--Test: DBMS_OUTPUT.PUT_LINE ('Working catagory: ' || temp_catagory);

			--return catagory pattern matches on the logic: one or more non matching lists of everything but the bar character, followed by the bar character
			return_catagory := REGEXP_SUBSTR(temp_catagory, '[^|]+|');
			EXECUTE IMMEDIATE insert_string USING temp_snatched.movie_id, return_catagory;


			--Increments for every successful insert
			insert_count := insert_count + SQL%ROWCOUNT;

			--Test: DBMS_OUTPUT.PUT_LINE ('Harvested catagory ' || return_catagory);

			--the loop then returns the substring of the remaining catagories following the most recently added catagory
			temp_catagory := SUBSTR (temp_catagory, LENGTH (return_catagory) +2) ;
		END LOOP;
	--FOR loop closes cursor for us
	END LOOP;
	
		--Output for number of rows inserted into the finalized table.
	DBMS_OUTPUT.PUT_LINE ('Number of rows added to the table: ' || insert_count);
	DBMS_OUTPUT.PUT_LINE ('Ending fix_movie_catagory.');
END;

--the purpose of this procedure is to strip the year from the movie name on the temporary
--table and update the new table with the fixed movie name

--this must be run after the procedure that 

CREATE OR REPLACE PROCEDURE fix_movie_year AS 
	--set up a cursor that will cycle through the temporary table getting the movie title
	--origionally put the substring call here, but had a difficult time getting a usable return
	CURSOR year_strip IS
		SELECT *
		FROM temp_move;
		
	--catch all type just incase I change the schema later	
	m_year year_strip%ROWTYPE;
	insert_count NUMBER (20) := 0;
	
	--Necessary Dynamic SQL to do the insert_count
	insert_string VARCHAR (1000) := 
		'INSERT INTO movie_details VALUES (:mid, :mt, :my)';
	
BEGIN
	-- loops through the temporary table
	-- according to the data, the year is the last 6 characters of every title including parentheses
	-- the first substring call returns all the characters leading up to the open parens of the year
	-- the second substring call with grab the inner 4 characters (excluding parens)
	-- (initially tried to pattern match on '/(.*\)', but some titles had parentheses)
	
	DBMS_OUTPUT.PUT_LINE ('The fix_movie_year procedure is beginning the loop on temp_movie.');
	FOR m_year IN year_strip LOOP
		EXECUTE IMMEDIATE insert_string USING 
			(m_year.movie_id, 
			SUBSTR(m_year.movie_title, 1, LENGTH(m_year.movie_title)-6),
			SUBSTR (m_year.movie_title, -5, 4) 
			); 
	
		insert_count := insert_count + SQL%ROWCOUNT; 
	
		--mainly a test to make sure that it was working accordingly, will remove
		--DBMS_OUTPUT.PUT_LINE('The stripped title is '|| SUBSTR(m_year.movie_title, 1, LENGTH(m_year.movie_title)-6); 
		--DBMS_OUTPUT.PUT_LINE('The stripped year is ' || SUBSTR (m_year.movie_title,-5,4));
	
	END LOOP;
	--prints out the finalized number of updated rows (hopefully)
	DBMS_OUTPUT.PUT_LINE ('Number of updated rows: ' || insert_count);
	DBMS_OUTPUT.PUT_LINE ('End of the fix_movie_year procedure.');
END;

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