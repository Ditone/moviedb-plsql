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