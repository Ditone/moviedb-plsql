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