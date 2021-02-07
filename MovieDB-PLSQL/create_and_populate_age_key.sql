--Dynamic SQL Procedure in order to create the age_key_range table. 
--In addition to creating the age_key_range table, this procedure will also populate it with its explicit values.
--Assumption is that the ranges defined in the readme attached to the data will not need to be changed

--This procedure will also check to make sure that a table does not already exist with the same name.
--If there is, the procedure will drop the table before creating the new table.

CREATE OR REPLACE PROCEDURE create_and_populate_age_key_range_table AS 
	--create table string
	create_table_exe_string VARCHAR (1000) :=
		'CREATE TABLE age_key_range 
			(age_code NUMBER (2), 
			age_translate NUMBER (2), 
			PRIMARY KEY (age_code, age_translate)
			)';
	
	--drop table string
	drop_table_exe_string VARCHAR (1000) :=
		'DROP TABLE age_key_range CASCADE CONSTRAINTS';
	
	--populate string
	populate_table_exe_string VARCHAR (1000);
	
	--loop variable
	age_tracker NUMBER := 1;
	insert_tracker NUMBER := 0;
	
BEGIN
	--The defined TABLE_EXISTS function returns 0 if there isn't a table already and any other positive integer if it does. 
	IF TABLE_EXISTS('age_key_range') = 0 THEN
		DBMS_OUTPUT.PUT_LINE('Creating table age_key_range.');
		EXECUTE IMMEDIATE create_table_exe_string;
	
	ELSE
		DBMS_OUTPUT.PUT_LINE ('Detected table already exists.');
		EXECUTE IMMEDIATE drop_table_exe_string;
		DBMS_OUTPUT.PUT_LINE ('Dropping table age_key_range.');
		
		--This should instead be a recursive call to the procedure, seeing as the functionality already exists earlier in the procedure
		--I am not doing it this way since I don't have a strong enough understanding of how PL/SQL handles recursive calls
		
		DBMS_OUTPUT.PUT_LINE('Creating table age_key_range.');
		EXECUTE IMMEDIATE create_table_exe_string;
	END IF;
	
	--after the schema is created, the values are inserted into the table
	--since this is a defined key from the readme attached to the data, this must be hardcoded
	
	DBMS_OUTPUT.PUT_LINE ('Beginning inserts on age_key_range');
	
	populate_table_exe_string :=
		'INSERT INTO age_key_range VALUES (:ac, :at)';
	
	
	EXECUTE IMMEDIATE populate_table_exe_string USING 18, '18-24';
	insert_tracker := insert_tracker + SQL%ROWCOUNT;
	EXECUTE IMMEDIATE populate_table_exe_string USING 25, '25-34';
	insert_tracker := insert_tracker + SQL%ROWCOUNT;
	EXECUTE IMMEDIATE populate_table_exe_string USING 35, '35-44';
	insert_tracker := insert_tracker + SQL%ROWCOUNT;	
	EXECUTE IMMEDIATE populate_table_exe_string USING 45, '45-49';
	insert_tracker := insert_tracker + SQL%ROWCOUNT;
	EXECUTE IMMEDIATE populate_table_exe_string USING 50, '50-55';
	insert_tracker := insert_tracker + SQL%ROWCOUNT;
	EXECUTE IMMEDIATE populate_table_exe_string USING 56, '56+';
	insert_tracker := insert_tracker + SQL%ROWCOUNT;
	DBMS_OUTPUT.PUT_LINE ('Inserted ' || insert_tracker || ' rows into age_key_range');
	
	DBMS_OUTPUT.PUT_LINE('Finished inserting values into age_key_range.');
END;