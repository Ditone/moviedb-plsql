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