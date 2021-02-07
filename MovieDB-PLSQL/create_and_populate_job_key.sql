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