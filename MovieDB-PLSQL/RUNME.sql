--Run me
EXECUTE create_temporary_tables;
EXECUTE create_and_populate_age_key;
EXECUTE create_and_populate_job_key;
EXECUTE create_and_populate_user_details;
EXECUTE create_movie_details;
EXECUTE create_movie_catagory;
EXECUTE fix_movie_year;
EXECUTE fix_movie_catagory;
EXECUTE create_and_populate_ratings;

EXECUTE movies_most_reviewed_by_profession('doctor');
EXECUTE movies_most_reviewed_by_profession('farmer');

--When finished
EXECUTE drop_all_tables;