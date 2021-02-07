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