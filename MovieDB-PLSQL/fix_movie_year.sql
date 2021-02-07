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