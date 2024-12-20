

/*
7. A monthly, reduced fact table DDL host_activity_reduced
    month
    host
    hit_array - think COUNT(1)
    unique_visitors array - think COUNT(DISTINCT user_id)
*/
DROP TABLE IF EXISTS host_activity_reduced;
CREATE TABLE host_activity_reduced (
    host TEXT, 
    month_start DATE, 
    hit_array INTEGER[], -- AS it IS a count it would be integer
    unique_visitors_array INTEGER[], -- AS it IS a count it would be integer
    PRIMARY KEY (host,month_start) 
);


/*
8. An incremental query that loads host_activity_reduced
    day-by-day
*/

INSERT INTO host_activity_reduced
WITH daily_aggregated AS (
	SELECT
		host,
		DATE(e.event_time) AS date,
		count(1) AS num_hit_times,
		count(DISTINCT user_id) AS num_unique_visitors
	FROM events e 
	WHERE DATE(e.event_time) = DATE('2023-01-01')
		AND user_id IS NOT NULL 
	GROUP BY 1,2
), yesterday_array AS (
	SELECT * 
	FROM host_activity_reduced
	WHERE month_start = DATE('2023-01-01') 
)
SELECT
	COALESCE(da.host,ya.host) AS host,
--		COALESCE(ya.month_start, da.date ) AS month_start,
	COALESCE(ya.month_start, DATE(DATE_TRUNC('month',da.date)) ) AS month_start,
	CASE
		WHEN ya.hit_array IS NULL
			THEN ARRAY_FILL(0, ARRAY[COALESCE(date - DATE(DATE_TRUNC('month',date)),0)]) || ARRAY[COALESCE(da.num_hit_times,0)]   
		WHEN ya.hit_array IS NOT NULL 
			THEN ya.hit_array || ARRAY[COALESCE(da.num_hit_times,0)]
	END AS num_hit_times,
	CASE
		WHEN ya.unique_visitors_array IS NULL
			THEN ARRAY_FILL(0, ARRAY[COALESCE(date - DATE(DATE_TRUNC('month',date)),0)]) || ARRAY[COALESCE(da.num_unique_visitors,0)]   
		WHEN ya.unique_visitors_array IS NOT NULL 
			THEN ya.unique_visitors_array || ARRAY[COALESCE(da.num_unique_visitors,0)]
	END AS num_unique_visitors	
FROM daily_aggregated da
	FULL OUTER JOIN yesterday_array ya 
ON da.host=ya.host;
