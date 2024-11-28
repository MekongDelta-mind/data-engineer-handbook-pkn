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
