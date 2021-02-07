|*-*-*-*-*-*-*-*-|
|----------------|
|****<README>****|
|----------------|
|_*_*_*_*_*_*_*_*|

>>> Movie Review Organization
>>> Written by Quin Reidy
>>> Starting Assignment Date: 2.7.2019
>>> Finalized Assignment Date: 2.21.2019

>>> OVERVIEW:
	
	This is a database designed to store the reviews of ~200,000 movie reviews from users whom have accounts on the site where the data is pulled.
	I do not have the origin of where the data has been pulled from, or from what site(s).
	There is an assumption that the raw data has already been uploaded to the DBMS through some means, and that the procedures included will access the temporary tables, for which the variable names have been defined.
	The list of procedures can be run multiple times, and should not fail. However, it may take a bit of time with each execution. 
	
>>> PROOF THAT IT WORKS (QUERY/PROCEDURE EXPLAINATION)

	In the file 'query_and_procedure' there is a query with a comment above: movie_most_reviewed_by_profession_query
	>This query prompts the user for an VARCHAR input for a job title, then returns the ten most reviewed movies within that profession, as well as how many times they were reviewed
	
	Included in a procedure called 'movies_most_reviewed_by_profession(job_name VARCHAR)'.
	>This procedure looks at all users whose occupation is listed as the parameter, and finds the ten most reviewed movies within that profession.
	
Below is a key that will help you decipher the schema for the tables found in this database, as well as the throughts/assumptions that went into the schema.
>>> KEY: 
		
		Variable_names in '()' are the PRIMARY KEY/KEYS
		DATA_TYPE followed by the pattern '->[TABLE.variable_name]' are FOREIGN KEY/KEYS referencing [TABLE.variable_name]
		
		Formatting for table schema is:
			table_name
				variable_name DATA_TYPE
			...
			>> Assumptions, or additional information
			...
			
>>> TABLES IN THE DATABASE:
		
		movie_details
			(movie_id) 	NUMBER
			movie_title VARCHAR
			movie_year 	VARCHAR
		>> Assumption is that movie_id is the only primary key since a movie with the same title can come out in the same year.
			
		movie_catagory
			(movie_id) 			NUMBER 	->[movie_details.movie_id]
			(movie_catagory) 	VARCHAR
		>> Assumption is that the same movie can (but not must) have multiple genres.
		>> The id/catagory must be in it's own table so that there are not multiple values in the catagory collumn
		>> Did consider using arrays to solve this problem, but did not preserve 3NF and also made it too difficult to query the data effectively
		
		user
			(user_id)	NUMBER
			gender		VARCHAR
			age			NUMBER
			occupation	NUMBER
			zip			NUMBER
		>>Assumption is that all infomration besides user_id can (but not must) be NULL, as the reviewer may have submitted the review as a unique 'GUEST'
		>>The values of age and occupation are constrained in the data to fit the key values in age_key and job_key
		>>Can assume that constraints are successful through a TRIGGER ON INSERT
		>>The constraint values are NOT dynamic, so if more values get added into job_key, they'll need to be updated in the TRIGGER as well.
		>>This is one of the first things to fix if given additional time.
			
		ratings
			(user_id)		NUMBER	->[user.user_id]
			(movie_id)		NUMBER	->[movie_details.movie_id]
			stars			NUMBER
			date_submitted	TIMESTAMP
		>>Assumption is that all ratings are done in number of 'stars' which range from 1-5
		>>Assumption is that all ratings are integers - no half stars.
		>>The date_submitted variable is recorded in seconds. This is annoying, and the output should have the format: 'MIN:HR MM/DD/YYYY'. 
			
		age_key_range
			(age_code)		NUMBER
			age_translate	VARCHAR
		>>Assumption is that the values that each age_code represents will NOT change.
		>>This assumption seems reasonable since the people aren't getting younger than the lowest range (0-18 years old), and 18 is the age where 'R' rated movies become accessable.
			
		>>EXTRA, was mainly for testing some potentially interesting queries
		age_key
			(age_code)	NUMBER
			(age_translate) NUMBER
		>>This table is different from the age_key_range table in that this makes both values a primary key
		>>This allows for queries to perform more percise searches. EX: You're able to query for people who are in the demographic that 19 year olds are in, without having to know the explicit ranges
		>>Not used in the runme since I didn't go with any of those queries
			
		job_key
			(job_code)		NUMBER
			job_translate	VARCHAR
		>>Assumption is that the values that each job_code represents will NOT change.
		>>May be in the best interest in the long term to add an additional procedure that will allow one to add/remove possible job_codes.	