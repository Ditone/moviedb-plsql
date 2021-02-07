# moviedb-plsql

**Relational Database Work**
**PLSQL**
**Reidy**


*Overview*

The objective of this project was to create a 3NF database and populate it using the 3 .DAT files provided.
All code must be run from stored procedures, and must be re-executable. 
The tables must store the values in the following columns:

	Movies : MovieID | MovieTitle | Year | Category
	
	User : UserID | Gender | AgeCode | Occupation | Zipcode

	Ratings : UserID | MovieID | Rating | Timestamp

	Movie-Category: Movie | Category

To showcase the working database, an “interesting” query about the data is included.

*NOTE: Code will not properly execute due to the fact that it currently requires you to connect to the DePaul Student Linux server. 
In the near future, the code will be updated to connect to my own server.*

In this folder there are two files, as well as an Eclipse java project.

>hw6-eclipse folder is the Eclipse java project, and contains two classes
> HW6Final.java should be run first. It sets up all the tables, and populates them from the files found in the project folder
> RunQueries.java should be run afterwards. It runs the query, and requires user input to complete.

> Reidy_Code is a Word document of all the code found in the eclipse Eclipse Project. 
>>The first part is the code to set up the database, and the second part runs the query.

> Reidy_Output.pdf is a PDF of all the outputs from setting up the database, the query output, as well as the query analysis.
