------------------------------------------------------------------------------------------------ Task2 

/*
 * 

2. Cumulative table generation query: Write a query that populates the actors table one year at a time.

mostly day2 and some day1 labs concepts
 * 
 */

SELECT
	*
FROM
	actor_films af
ORDER BY
	YEAR;

SELECT
	count(DISTINCT actorid) AS "unique_actorid",
	count(DISTINCT actor) AS "unique_actor"
FROM
	actor_films af;

/*
"unique_actorid","unique_actor"
9447,9441
actorid is more than the no of actors
**/
-- COUNT OF ROWS in table
SELECT
	count(*) AS exact_count
FROM
	postgres.public.actor_films af ;
-- 169770.0
SELECT
	reltuples AS estimate
FROM
	pg_class
WHERE
	relname = 'actor_films';
-- 169770.0

SELECT min(year) FROM actor_films af;  -- 1970

-- checking the individual queries are good enough
SELECT * FROM actors 
 WHERE current_year = 1969;-- AS the min IS 1970, the DATA IS null
SELECT * FROM actor_films af 
	WHERE YEAR = 1970;

-- checking the joining is happening correctly
WITH yesteryear AS (
 SELECT * FROM actors 
 WHERE current_year = 1969
), 
	toyear AS (
	SELECT * FROM actor_films af 
	WHERE YEAR = 1970
	)
SELECT * FROM   
toyear t FULL OUTER JOIN 
yesteryear y ON
t.actorid = y.actorid;

/*
 * WITH yesteryear as (
 *		the table( actors ) into which you will insert the data 
 *		this will serve as the historical snapshot of data
 *  ),
 * 		toyear	as		(
 * 			for raw statistics from the current snapshot from the ground truth( actor_films table)
 * 		)
 * SELECT * 
 * Outer joing of the data
 * 
 */



-- ADDING THE REQUIRED CONDITIONS TO THE ABOVE QUERY;
-- first coalescing the values that are not changin from actors
WITH yesteryear AS (
SELECT
	*
FROM
	actors
WHERE
	current_year = 1969
), 
	toyear AS (
SELECT
	*
FROM
	actor_films af
WHERE
	YEAR = 1970
	)
SELECT
	COALESCE(t.actor,y.actor) as actor,
	COALESCE(t.actorid,y.actorid) as actorid -- till here it doesn't CHANGE ANY value BETWEEN yesteryear AND toyear
--	COALESCE(t.film_arr,y.film_arr) as film_arr,
--	COALESCE(t.quality_class,y.quality_class), as quality_class, THIS SHOULD HAVE CASE WHEN
--	COALESCE(t.current_year,y.current_year) as current_year
--	COALESCE(t.is_active,y.is_active) as is_active, -- case when if current year is null
FROM
	toyear t
FULL OUTER JOIN 
yesteryear y ON
	t.actorid = y.actorid;



-- adding the values that chnages with time and are different from the both the tables yesteryear and toyear
WITH yesteryear AS (
SELECT
	*
FROM
	actors
WHERE
	current_year = 1969  
), 
	toyear AS (
SELECT
	*
FROM
	actor_films af 
WHERE
	YEAR = 1970		-- the YEAR OF the film IN yesteryear AND toyear IS different
	)
SELECT
	COALESCE(t.actor,y.actor) as actor,
	COALESCE(t.actorid,y.actorid) as actorid,
	CASE WHEN y.film_stats IS NULL  -- when there is no value for yesterday wrt to current day, fill the curent day details
		THEN ARRAY[ROW(
			t.film,
			t.votes,
			t.rating,
			t.filmid
		)::film_stats] 
	WHEN t.year IS NOT NULL -- when the current year for the actor is not null 
		THEN y.film_stats || ARRAY[ROW(
			t.film,
			t.votes,
			t.rating,
			t.filmid
		)::film_stats]    -- then concat the previous film details and the present ones
	ELSE y.film_stats  -- retired actor
	END as film_stats,
--	COALESCE(t.quality_class,y.quality_class), as quality_class, THIS SHOULD HAVE CASE WHEN
	COALESCE(t.year,y.current_year+1) as current_year
	-- CASE WHEN t.current_year IS NOT NULL THEN t.current_year
	-- 	ELSE y.current_year+1
	-- END as  
--	COALESCE(t.is_active,y.is_active) as is_active, -- case when if current year is null
FROM
	toyear t
FULL OUTER JOIN 
yesteryear y ON
	t.actorid = y.actorid;


WITH yesteryear AS (
SELECT
	*
FROM
	actors
WHERE
	current_year = 1969  
), 
	toyear AS (
SELECT
	*
FROM
	actor_films af 
WHERE
	YEAR = 1970		-- the YEAR OF the film IN yesteryear AND toyear IS different
	)
SELECT
	COALESCE(t.actor,y.actor) as actor,
	COALESCE(t.actorid,y.actorid) as actorid,
	CASE WHEN y.film_stats IS NULL  -- when there is no value for yesterday wrt to current day, fill the curent day details
		THEN ARRAY[ROW(
			t.film,
			t.votes,
			t.rating,
			t.filmid
		)::film_stats] 
	WHEN t.year IS NOT NULL -- when the current year for the actor is not null 
		THEN y.film_stats || ARRAY[ROW(
			t.film,
			t.votes,
			t.rating,
			t.filmid
		)::film_stats]    -- then concat the previous film details and the present ones
	ELSE y.film_stats  -- retired actor
	END as film_stats,
--	COALESCE(t.quality_class,y.quality_class), as quality_class, THIS SHOULD HAVE CASE WHEN
	COALESCE(t.year,y.current_year+1) as current_year
	-- CASE WHEN t.current_year IS NOT NULL THEN t.current_year
	-- 	ELSE y.current_year+1
	-- END as  
--	COALESCE(t.is_active,y.is_active) as is_active, -- case when if current year is null
FROM
	toyear t
FULL OUTER JOIN 
yesteryear y ON
	t.actorid = y.actorid;
-- insert is removed as the above will not work untill and unless you have vlaues for each of the 
--columns in the table(actors table here) you are trying to insert the valeus

-- trying to have null and insert the same
WITH yesteryear AS (
SELECT
	*
FROM
	actors
WHERE
	current_year = 1969  
), 
	toyear AS (
SELECT
	*
FROM
	actor_films af 
WHERE
	YEAR = 1970		-- the YEAR OF the film IN yesteryear AND toyear IS different
	)
SELECT
	COALESCE(t.actor,y.actor) as actor,
	COALESCE(t.actorid,y.actorid) as actorid,
	CASE WHEN y.film_stats IS NULL  -- when there is no value for yesterday wrt to current day, fill the curent day details
		THEN ARRAY[ROW(
			t.film,
			t.votes,
			t.rating,
			t.filmid
		)::film_stats] 
	WHEN t.year IS NOT NULL -- when the current year for the actor is not null 
		THEN y.film_stats || ARRAY[ROW(
			t.film,
			t.votes,
			t.rating,
			t.filmid
		)::film_stats]    -- then concat the previous film details and the present ones
	ELSE y.film_stats  -- retired actor
	END as film_stats,
--	COALESCE(t.quality_class,y.quality_class), as quality_class, THIS SHOULD HAVE CASE WHEN
	COALESCE(t.year,y.current_year+1) as current_year
	-- CASE WHEN t.current_year IS NOT NULL THEN t.current_year
	-- 	ELSE y.current_year+1
	-- END as  
--	COALESCE(t.is_active,y.is_active) as is_active, -- case when if current year is null
FROM
	toyear t
FULL OUTER JOIN 
yesteryear y ON
	t.actorid = y.actorid;


-- using the CASE WHEN for the quality class of the respective movies

WITH yesteryear AS (
SELECT
	*
FROM
	actors
WHERE
	current_year = 1969  
), 
	toyear AS (
SELECT
	*
FROM
	actor_films af 
WHERE
	YEAR = 1970		-- the YEAR OF the film IN yesteryear AND toyear IS different
	)
SELECT
	COALESCE(t.actor,y.actor) as actor,
	COALESCE(t.actorid,y.actorid) as actorid,
	CASE WHEN y.film_stats IS NULL  -- when there is no value for yesterday wrt to current day, fill the curent day details
		THEN ARRAY[ROW(
			t.film,
			t.votes,
			t.rating,
			t.filmid
		)::film_stats] 
	WHEN t.year IS NOT NULL -- when the current year for the actor is not null 
		THEN y.film_stats || ARRAY[ROW(
			t.film,
			t.votes,
			t.rating,
			t.filmid
		)::film_stats]    -- then concat the previous film details and the present ones
	ELSE y.film_stats  -- retired actor
	END as film_stats,
	CASE
			WHEN t.YEAR IS NOT NULL THEN
			CASE			
				WHEN t.rating > 8 THEN 'star'
				WHEN (t.rating >7 AND t.rating <= 8) THEN 'good'
				WHEN (t.rating >6 AND t.rating <= 7) THEN 'average'
				ELSE 'bad'
			END::quality_class
			ELSE y.quality_class --it should be y.quality_class 
		END	,
	COALESCE(t.year,y.current_year+1) as current_year
	-- CASE WHEN t.current_year IS NOT NULL THEN t.current_year
	-- 	ELSE y.current_year+1
	-- END as  
--	COALESCE(t.is_active,y.is_active) as is_active, -- case when if current year is null
FROM
	toyear t
FULL OUTER JOIN 
yesteryear y ON
	t.actorid = y.actorid;

-- adding the case for is_active or not 

WITH yesteryear AS (
SELECT
	*
FROM
	actors
WHERE
	current_year = 1969  
), 
	toyear AS (
SELECT
	*
FROM
	actor_films af 
WHERE
	YEAR = 1970		-- the YEAR OF the film IN yesteryear AND toyear IS different
	)
SELECT
	COALESCE(t.actor,y.actor) as actor,
	COALESCE(t.actorid,y.actorid) as actorid,
	CASE WHEN y.film_stats IS NULL  -- when there is no value for yesterday wrt to current day, fill the curent day details
		THEN ARRAY[ROW(
			t.film,
			t.votes,
			t.rating,
			t.filmid
		)::film_stats] 
	WHEN t.year IS NOT NULL -- when the current year for the actor is not null 
		THEN y.film_stats || ARRAY[ROW(
			t.film,
			t.votes,
			t.rating,
			t.filmid
		)::film_stats]    -- then concat the previous film details and the present ones
	ELSE y.film_stats  -- retired actor
	END as film_stats,
	CASE
			WHEN t.YEAR IS NOT NULL THEN
			CASE			
				WHEN t.rating > 8 THEN 'star'
				WHEN (t.rating >7 AND t.rating <= 8) THEN 'good'
				WHEN (t.rating >6 AND t.rating <= 7) THEN 'average'
				ELSE 'bad'
			END::quality_class
			ELSE y.quality_class --it should be y.quality_class 
		END	,
	COALESCE(t.year,y.current_year+1) as current_year,
	-- CASE WHEN t.current_year IS NOT NULL THEN t.current_year
	-- 	ELSE y.current_year+1
	-- END as  
	CASE 
		WHEN t.year IS NOT NULL THEN TRUE
		ELSE FALSE
	END as is_active
FROM
	toyear t
FULL OUTER JOIN 
yesteryear y ON
	t.actorid = y.actorid;



--- after checking the claues are correct, we need to insert them into the new table actors
--- NOW Adding the values in to the table with the yesteryear = 1969 and toyear = 1970
SELECT * FROM actors WHERE 1=1 ;


INSERT INTO actors  -- does it WORK? it works IN the lab  video 
WITH yesteryear AS (
SELECT
	*
FROM
	actors
WHERE
	current_year = 1969  
), 
	toyear AS (
SELECT
	*
FROM
	actor_films af 
WHERE
	YEAR = 1970		-- the YEAR OF the film IN yesteryear AND toyear IS different
	)
--INSERT INTO actors --- it IS mentioned IN lexture-lab folder OF the course
SELECT
	COALESCE(t.actor,y.actor) as actor,
	COALESCE(t.actorid,y.actorid) as actorid,
	CASE WHEN y.film_stats IS NULL  -- when there is no value for yesterday wrt to current day, fill the curent day details
		THEN ARRAY[ROW(
			t.film,
			t.votes,
			t.rating,
			t.filmid
		)::film_stats] 
	WHEN t.year IS NOT NULL -- when the current year for the actor is not null 
		THEN y.film_stats || ARRAY[ROW(
			t.film,
			t.votes,
			t.rating,
			t.filmid
		)::film_stats]    -- then concat the previous film details and the present ones
	ELSE y.film_stats  -- retired actor
	END as film_stats,
	CASE
			WHEN t.YEAR IS NOT NULL THEN
			CASE			
				WHEN t.rating > 8 THEN 'star'
				WHEN (t.rating >7 AND t.rating <= 8) THEN 'good'
				WHEN (t.rating >6 AND t.rating <= 7) THEN 'average'
				ELSE 'bad'
			END::quality_class
			ELSE y.quality_class --it should be y.quality_class 
		END	,
	COALESCE(t.year,y.current_year+1) as current_year,
	-- CASE WHEN t.current_year IS NOT NULL THEN t.current_year
	-- 	ELSE y.current_year+1
	-- END as  
	CASE 
		WHEN t.year IS NOT NULL THEN TRUE
		ELSE FALSE
	END as is_active
FROM
	toyear t
FULL OUTER JOIN 
yesteryear y ON
	t.actorid = y.actorid;

/*ERROR FOR THE ABOVE query
 * SQL Error [23505]: ERROR: duplicate key value violates unique constraint "actors_pkey"
  Detail: Key (actorid)=(nm0000003) already exists.

Error position:

for same actor name and actorid which are ht primary key for the actors's table is same for some of the rows
SELECT
	*
FROM
	actor_films af 
WHERE
	YEAR = 1970	;
actor 	actorid 	film 	year 	votes 	rating 	filmid
Brigitte Bardot 	nm0000003 	The Bear and the Doll 	1970 	431 	6.4 	tt0064779
Brigitte Bardot 	nm0000003 	Les novices 	1970 	219 	5.1 	tt0066164
Ingrid Bergman 	nm0000006 	A Walk in the Spring Rain 	1970 	696 	6.2 	tt0066542
Bette Davis 	nm0000012 	Connecting Rooms 	1970 	585 	6.9 	tt0066943
Olivia de Havilland 	nm0000014 	The Adventurers 	1970 	656 	5.5 	tt0065374
Kirk Douglas 	nm0000018 	There Was a Crooked Man... 	1970 	4138 	7.0 	tt0066448
Henry Fonda 	nm0000020 	There Was a Crooked Man... 	1970 	4138 	7.0 	tt0066448
Henry Fonda 	nm0000020 	The Cheyenne Social Club 	1970 	4085 	6.9 	tt0065542

for example (Brigitte Bardot,nm0000003) is the primary key for both. 
SOLUTION: 
THE yesterday and today values should be unique to be used for the info given.
one of the way is to use the ARRAY_AGG even before querying it into the Common Table Eexpression like below
 * 
 */

SELECT
    actorid,
    actor,
    year,
    CASE WHEN year IS NULL THEN ARRAY[]::film_stats[]
         ELSE ARRAY_AGG(ROW(film, votes, rating, filmid)::film_stats)
    END AS film_stats
   FROM actor_films
   WHERE year = 1970
   GROUP BY actorid, actor,YEAR;



--- adding the unique query for toyear vlaues into the CTE as below:
  
WITH yesteryear AS (
SELECT
	*
FROM
	actors
WHERE
	current_year = 1969  
), 
	toyear AS (
SELECT
    actorid,
    actor,
    year,
    CASE WHEN year IS NULL THEN ARRAY[]::film_stats[]
         ELSE ARRAY_AGG(ROW(film, votes, rating, filmid)::film_stats)
    END AS film_stats
   FROM actor_films
   WHERE year = 1970
   GROUP BY actorid, actor,YEAR		-- the YEAR OF the film IN yesteryear AND toyear IS different
	)
--INSERT INTO actors --- it IS mentioned IN lexture-lab folder OF the course
SELECT 
	COALESCE(t.actor,y.actor) as actor,
	COALESCE(t.actorid,y.actorid) as actorid,
--	CASE WHEN y.film_stats IS NULL  -- when there is no value for yesterday wrt to current day, fill the curent day details
--		THEN ARRAY[ROW(
--			t.film,
--			t.votes,
--			t.rating,
--			t.filmid
--		)::film_stats] 
--	WHEN t.year IS NOT NULL -- when the current year for the actor is not null 
--		THEN y.film_stats || ARRAY[ROW(
--			t.film,
--			t.votes,
--			t.rating,
--			t.filmid
--		)::film_stats]    -- then concat the previous film details and the present ones
--	ELSE y.film_stats  -- retired actor
--	END as film_stats,
	CASE
			WHEN t.YEAR IS NOT NULL THEN
			CASE			
				WHEN t.rating > 8 THEN 'star'
				WHEN (t.rating >7 AND t.rating <= 8) THEN 'good'
				WHEN (t.rating >6 AND t.rating <= 7) THEN 'average'
				ELSE 'bad'
			END::quality_class
			ELSE y.quality_class --it should be y.quality_class 
		END	,
	COALESCE(t.year,y.current_year+1) as current_year,
	-- CASE WHEN t.current_year IS NOT NULL THEN t.current_year
	-- 	ELSE y.current_year+1
	-- END as  
	CASE 
		WHEN t.year IS NOT NULL THEN TRUE
		ELSE FALSE
	END as is_active
FROM
	toyear t
FULL OUTER JOIN 
yesteryear y ON
	t.actorid = y.actorid;












-- single queries to test conditions and methods indiependently
SELECT 100/2 ;
SELECT
	af.rating
	,CASE
		WHEN af.YEAR IS NOT NULL THEN
		CASE			
			WHEN af.rating > 8 THEN 'star'
			WHEN (af.rating >7 AND af.rating <= 8) THEN 'good'
			WHEN (af.rating >6 AND af.rating <= 7) THEN 'average'
			ELSE 'bad'
		END::quality_class
		ELSE 'bad' --it should be y.quality_class 
	END
	FROM
		actor_films af;

SELECT TRUE;








------------------------------------------------------------------------------------------------ Task2 completed

/*
 * The ARRAY_AGG function in PostgreSQL is an aggregate function that combines values from multiple rows into an array. 
 * It is especially useful when we need to return multiple values in a single row or group values from related records.
 */
