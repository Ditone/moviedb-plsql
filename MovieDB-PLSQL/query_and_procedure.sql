--This first query will prompt the user for input on what profession they would like to search for
--Assumption is that the input for job title is a profession in the job_code table, and there will only be 1 input per execution
--The query will then return the name, and the number of times reviewed for the top 10 most reviewed movies based on that profession

--movie_most_reviewed_by_profession_query
SELECT movie_details.movie_title, COUNT(ratings.movie_id)
	FROM  movie_details INNER JOIN (ratings INNER JOIN user_details 
			ON ratings.user_id = user_details.user_id)
		ON movie_details.movie_id = ratings.movie_id
	WHERE occupation = ( 
		SELECT job_code
		FROM job_key
		WHERE UPPER(job_translate) LIKE UPPER("%&job_name%"))
	GROUP BY movie_details.movie_title
	ORDER BY COUNT(ratings.movie_id) DESC
    FIRST 10 ROWS ONLY;

--This is a procedure version of the above query
--Instead of prompting the user for input, it passes in the profession title through its parameter
--Instead of a query result, this prints out to STDOUT
--In fringe cases, this will be more accurate than the query above since it does all its searching through movie_id instead of movie_title
--Same assumptions as above.

CREATE OR REPLACE PROCEDURE movies_most_reviewed_by_profession (job_title VARCHAR) AS
	
	--cursor to retrieve the movie ids with the most entries 
    CURSOR find_the_movie_ids IS
        SELECT ratings.movie_id
        FROM  ratings INNER JOIN user_details ON ratings.user_id = user_details.user_id
        WHERE occupation = ( 
            SELECT job_code
            FROM job_key
            WHERE UPPER(job_translate) LIKE UPPER('%'||job_title||'%'))
        GROUP BY ratings.movie_id
        ORDER BY COUNT(ratings.movie_id) DESC
        FETCH FIRST 10 ROWS ONLY; 

	--goes row by row taking the movie ids from the cursor, and the associated row in movie_details
    temp_id find_the_movie_ids%ROWTYPE;
	
	--the details are stored and returned
    return_var movie_details%ROWTYPE;
	
	--loop counter
    tracker NUMBER := 0;
    
BEGIN
    FOR temp_id IN find_the_movie_ids LOOP
        tracker := tracker + 1;
        
        SELECT *
        INTO return_var
        FROM movie_details
        WHERE movie_details.movie_id = temp_id.movie_id;
        
        DBMS_OUTPUT.PUT_LINE (tracker || ': Title: ' || return_var.movie_title 
            || ', ' || return_var.movie_year);
    END LOOP;
END;
	