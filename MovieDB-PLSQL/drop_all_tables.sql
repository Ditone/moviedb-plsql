--Drops all of the temporary tables
--Only suggest using this procedure if you need to free up space

CREATE OR REPLACE drop_all_temp_tables AS

drop_table_exe_string_movie VARCHAR (1000) :=
	'DROP TABLE temp_movie CASCADE CONSTRAINTS';
	
drop_table_exe_string_ratings VARCHAR (1000) :=
	'DROP TABLE temp_ratings CASCADE CONSTRAINTS';
	
drop_table_exe_string_user VARCHAR (1000) :=
	'DROP TABLE temp_user CASCADE CONSTRAINTS';
	
BEGIN 

DBMS_OUTPUT.PUT_LINE ('Dropping the temp_movie table');
EXECUTE IMMEDIATE drop_table_exe_string_movie;

DBMS_OUTPUT.PUT_LINE ('Dropping the temp_ratings table');
EXECUTE IMMEDIATE drop_table_exe_string_ratings;

DBMS_OUTPUT.PUT_LINE ('Dropping the temp_user table');
EXECUTE IMMEDIATE drop_table_exe_string_user;

DBMS_OUTPUT.PUT_LINE ('All temporary tables dropped.');
DBMS_OUTPUT.PUT_LINE ('If you  need the temporary tables again, run create_temporary_tables and re-import the data using SQL Developer into the appropriate tables.');

END; 