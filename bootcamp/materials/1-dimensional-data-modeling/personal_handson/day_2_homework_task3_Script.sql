--- homework_task3_day2_Script.sql
--- homework_<task from the homework.md>_<day from which the concepts are from>_Script.sql


SELECT * FROM actors a; 


/*
 * The actor_films dataset contains the following fields:

    actor: The name of the actor.
    actorid: A unique identifier for each actor.
    film: The name of the film.
    year: The year the film was released.
    votes: The number of votes the film received.
    rating: The rating of the film.
    filmid: A unique identifier for each film.

The primary key for this dataset is (actor_id, film_id).

DROP TABLE IF EXISTS actors;
CREATE TABLE actors (
	actor TEXT,
	actorid TEXT,
	film_stats film_stats[], -- create an array
	quality_class quality_class, -- creating an enum star, good average
	current_year integer,
	is_active boolean,
PRIMARY KEY (actorid,current_year)	

 * DDL for actors_history_scd table: Create a DDL for an actors_history_scd table with the following features:
 	* Implements type 2 dimension modeling (i.e., includes start_date and end_date fields).
    * Tracks quality_class and is_active status for each actor in the actors table.

*/

--- The below depends on the previous table actors and it's film_stats[], quality class and is_active values
DROP TABLE IF EXISTS actors_history_scd;
CREATE TABLE actors_history_scd(
	actor TEXT,
	actorid TEXT,
	film_stats film_stats[],
	quality_class quality_class, -- creating an enum star, good average
	is_active boolean,
	start_date integer,
	end_date integer,
	current_year integer
--	PRIMARY KEY (actorid,current_year) 	
);
-- Primary key removed as the table from which the values are going to be 
-- retrieved is populated with uniques values from the keys

SELECT * FROM actors_history_scd;


