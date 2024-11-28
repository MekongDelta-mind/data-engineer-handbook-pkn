/*For reference:
SQL used in the bootcamp>>> bootcamp/materials/1-dimensional-data-modeling/sql/load_players_table_day2.sql
Final SQLs in the repo >>>> 
for creating the table
bootcamp/materials/1-dimensional-data-modeling/lecture-lab/players_scd_table.sql
BACKFILL QUERY for generating the values 
bootcamp/materials/1-dimensional-data-modeling/lecture-lab/scd_generation_query.sql
INCREMENTAL QUERY for incremental query
bootcamp/materials/1-dimensional-data-modeling/lecture-lab/incremental_scd_query.sql
*/ 

SELECT min(DISTINCT(YEAR)) AS start_year, max(DISTINCT(YEAR)) AS end_year FROM actor_films af; 
/*
 *  
|start_year|end_year|
|----------|--------|
|1970|2021|

history time period is 1970 to 2020
current time period is 2020 to 2021
 * */

-- Check all the years from actors filled in task 1 and 2

SELECT DISTINCT(current_year) FROM actors a;

/*
 * 
|current_year|
|------------|
|1970|
|1972|
|1971|

*/

-- CHECKING WHETHER THE START AND END DATES ARE EQUAL OR NOT
WITH actor_info AS (
	SELECT min(DISTINCT(current_year)) AS start_year, max(DISTINCT(current_year)) AS end_year FROM actors a
), actor_films_info AS (
	SELECT min(DISTINCT(YEAR)) AS start_year, max(DISTINCT(YEAR)) AS end_year FROM actor_films af 
)
SELECT
ai.start_year AS history_start,
ai.end_year AS history_end,
afi.start_year AS current_start,
afi.end_year AS current_end,
    CASE
        WHEN ai.start_year = afi.start_year AND ai.end_year = afi.end_year THEN 'Start and end years match'
        ELSE 'Start and end years do not match'
    END AS year_comparison
FROM actor_info ai
JOIN actor_films_info afi ON 1=1;

/**
|year_comparison|
|---------------|
|Start and end years do not match|
 * the start and end date should not be equal because we are assuming

history time period is 1970 to 2020
current time period is 2020 to 2021 
 */


/*
 * Backfill query for actors_history_scd: Write a "backfill" query that can populate 
 * the entire actors_history_scd table in a single query.
 *  
history time period is 1970 to 2020
current time period is 2020 to 2021 - think as if this is not present and you would insert the same.

Backfilling query will happen for the period 1970 to 2020
incremental thing will happen for the period 2020 to 2021

That is why I have inserted upto 2020 in the previous query in the "day_1_homework_task2_Script.sql"
 * */

SELECT * FROM actors_history_scd;

SELECT actor, quality_class, is_active
FROM actors a; 

----- creating lag values

WITH streak_started AS (
	SELECT actor,
			current_year,
			quality_class,
			LAG(quality_class,1) OVER ( PARTITION BY actor ORDER BY current_year) AS previous_quality_class,
			is_active,
			LAG(is_active,1) OVER ( PARTITION BY actor ORDER BY current_year) AS previous_is_active-- this speaks about being retired
	FROM actors
)
SELECT * 
FROM streak_started;

--------------- checking if the row changed with respect to the previous row
WITH streak_started AS (
	SELECT actor,
			current_year,
			quality_class,
			is_active,
			LAG(quality_class,1) OVER ( PARTITION BY actor ORDER BY current_year) <> quality_class
			OR 
			LAG(is_active,1) OVER ( PARTITION BY actor ORDER BY current_year) IS NULL -- this speaks about being retired
			AS did_change
	FROM actors
)
SELECT *, 
	SUM( CASE WHEN did_change THEN 1 ELSE 0 END ) 
	OVER (PARTITION BY actor ORDER BY current_year) AS with_indicators
FROM streak_started;

-------------------------- gropuing the whole so as to see the cumulative values

WITH streak_started AS (
	SELECT actor,
			current_year,
			quality_class,
			is_active,
			LAG(quality_class,1) OVER ( PARTITION BY actor ORDER BY current_year) <> quality_class
			OR 
			LAG(is_active,1) OVER ( PARTITION BY actor ORDER BY current_year) IS NULL -- this speaks about being retired
			AS did_change
	FROM actors
), 
	with_indicators AS (
		SELECT
			*, 
			SUM( CASE WHEN did_change THEN 1 ELSE 0 END ) 
			OVER (PARTITION BY actor
		ORDER BY
			current_year) AS streak_identifier
		FROM
			streak_started
	)
SELECT 
	actor,
	streak_identifier, -- FROM the with_indicator CTE
	is_active,
	quality_class,
	MIN(current_year) AS start_date,
	MAX(current_year) AS end_date
FROM with_indicators
GROUP BY actor,streak_identifier, is_active, quality_class;


------------------------------------------ NOW SELECTING DATA TILL 2020 and assuming the 2020 as current_year

WITH streak_started AS (
	SELECT actor,
			current_year,
			quality_class,
			is_active,
			LAG(quality_class,1) OVER ( PARTITION BY actor ORDER BY current_year) <> quality_class
			OR 
			LAG(is_active,1) OVER ( PARTITION BY actor ORDER BY current_year) IS NULL -- this speaks about being retired
			AS did_change
	FROM actors
	WHERE current_year <= 2020
), 
	with_indicators AS (
		SELECT
			*, 
			SUM( CASE WHEN did_change THEN 1 ELSE 0 END ) 
			OVER (PARTITION BY actor
		ORDER BY
			current_year) AS streak_identifier
		FROM
			streak_started
	)
SELECT 
	actor,
	quality_class,
	is_active,
	MIN(current_year) AS start_date,
	MAX(current_year) AS end_date,
	2020 AS current_year
FROM with_indicators
GROUP BY actor,streak_identifier, is_active, quality_class;

------------------------------------------- Inserting into the table "actors_history_scd"

INSERT INTO actors_history_scd 
WITH streak_started AS (
	SELECT actor,
			current_year,
			quality_class,
			is_active,
			LAG(quality_class,1) OVER ( PARTITION BY actor ORDER BY current_year) <> quality_class
			OR 
			LAG(is_active,1) OVER ( PARTITION BY actor ORDER BY current_year) IS NULL -- this speaks about being retired
			AS did_change
	FROM actors
	WHERE current_year <= 2020
), 
	with_indicators AS (
		SELECT
			*, 
			SUM( CASE WHEN did_change THEN 1 ELSE 0 END ) 
			OVER (PARTITION BY actor
		ORDER BY
			current_year) AS streak_identifier
		FROM
			streak_started
	)
SELECT 
	actor,
	quality_class,
	is_active,
	MIN(current_year) AS start_date,
	MAX(current_year) AS end_date,
	2020 AS current_year
FROM with_indicators
GROUP BY actor,streak_identifier, is_active, quality_class;


/*
 * For the above query we are getting the below error
 * SQL Error [23505]: ERROR: duplicate key value violates unique constraint "actors_history_scd_pkey"
  Detail: Key (actor, start_date, end_date)=(Jake Ryan, 2018, 2018) already exists.

Error position:
 * */


WITH streak_started AS (
	SELECT actor,
			current_year,
			quality_class,
			is_active,
			LAG(quality_class,1) OVER ( PARTITION BY actor ORDER BY current_year) <> quality_class
			OR 
			LAG(is_active,1) OVER ( PARTITION BY actor ORDER BY current_year) IS NULL -- this speaks about being retired
			AS did_change
	FROM actors
	WHERE current_year <= 2020
), streak_identified AS (
         SELECT
            actor,
                quality_class,
				is_active,
                current_year,
            SUM(CASE WHEN did_change THEN 1 ELSE 0 END)
                OVER (PARTITION BY actor ORDER BY current_year) as streak_identifier
         FROM streak_started
     )
SELECT * 
FROM streak_identified;

SELECT * 
	FROM actors
	WHERE current_year <= 2020
ORDER BY actor ;

WITH streak_started AS (
	SELECT actor,
			current_year,
			quality_class,
			is_active,
			LAG(quality_class,1) OVER ( PARTITION BY actor ORDER BY current_year) <> quality_class
			OR 
			LAG(is_active,1) OVER ( PARTITION BY actor ORDER BY current_year) IS NULL -- this speaks about being retired
			AS did_change
	FROM actors
	WHERE current_year <= 2020
), streak_identified AS (
         SELECT
            actor,
                quality_class,
				is_active,
                current_year,
            SUM(CASE WHEN did_change THEN 1 ELSE 0 END)
                OVER (PARTITION BY actor ORDER BY current_year) as streak_identifier
         FROM streak_started
     ),
aggregated AS (
	SELECT 
		actor,
		quality_class,
		streak_identifier,
		is_active,
		MIN(current_year) AS start_date,
		MAX(current_year) AS end_date,
		2020 AS current_year
	FROM streak_identified
	GROUP BY 1,2,3,4
)
SELECT * 
FROM aggregated;

------------------------------------------------- Final Select before inserting the values
INSERT INTO actors_history_scd 
WITH streak_started AS (
	SELECT actor,
			current_year,
			quality_class,
			is_active,
			LAG(quality_class,1) OVER ( PARTITION BY actor ORDER BY current_year) <> quality_class
			OR 
			LAG(is_active,1) OVER ( PARTITION BY actor ORDER BY current_year) IS NULL -- this speaks about being retired
			AS did_change
	FROM actors
	WHERE current_year <= 2020
), streak_identified AS (
         SELECT
            actor,
                quality_class,
				is_active,
                current_year,
            SUM(CASE WHEN did_change THEN 1 ELSE 0 END)
                OVER (PARTITION BY actor ORDER BY current_year) as streak_identifier
         FROM streak_started
     ),
aggregated AS (
	SELECT 
		actor,
		quality_class,
		streak_identifier,
		is_active,
		MIN(current_year) AS start_date,
		MAX(current_year) AS end_date,
		2020 AS current_year
	FROM streak_identified
	GROUP BY 1,2,3,4
)
SELECT actor, quality_class, is_active, start_date, end_date, current_year
FROM aggregated; 




------- INSERTING Into the table

INSERT INTO actors_history_scd 
--- all aggregation
SELECT actor, quality_class, is_active, start_date, end_date, current_year
FROM aggregated; 
