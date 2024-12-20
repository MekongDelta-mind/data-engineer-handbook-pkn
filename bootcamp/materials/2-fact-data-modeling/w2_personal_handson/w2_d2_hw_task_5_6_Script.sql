/*
 * 

5. A DDL for hosts_cumulated table

    a host_activity_datelist which logs to see which dates each host is experiencing any activity

6. The incremental query to generate host_activity_datelist

7. A monthly, reduced fact table DDL host_activity_reduced

    month
    host
    hit_array - think COUNT(1)
    unique_visitors array - think COUNT(DISTINCT user_id)

8. An incremental query that loads host_activity_reduced

    day-by-day


 */


-- SIMILAR TO the previous task in the tutorial 

SELECT *
FROM events e ; -- host present IN the events tabe TO be accessed


SELECT *
FROM devices d ; -- this won't be useful AS such

DROP TABLE IF EXISTS hosts_cumulated;
CREATE TABLE hosts_cumulated (
    host TEXT, 
    host_activity_datelist DATE[], 
    present_date DATE, 
    PRIMARY KEY (host,present_date) 
);


--- creating the yesterday and today ctes and related full outer joins
WITH yesterday AS (
	SELECT * FROM hosts_cumulated 
	WHERE present_date = DATE('2023-12-31')
),
	today AS (
		SELECT 
		host,
		DATE(CAST(e.event_time AS TIMESTAMP)) AS present_date
		FROM events e
		WHERE 
			DATE(CAST(e.event_time AS TIMESTAMP)) = DATE('2023-01-01')
			AND host IS NOT NULL 
		GROUP BY 1,2
	)
SELECT *
FROM  today t
FULL OUTER JOIN yesterday y
	ON t.host = y.host;


--- selcting specific columsn (except the activity datelist) according to the table

WITH yesterday AS (
	SELECT * FROM hosts_cumulated 
	WHERE present_date = DATE('2023-12-31')
),
	today AS (
		SELECT 
		host,
		DATE(CAST(e.event_time AS TIMESTAMP)) AS present_date
		FROM events e
		WHERE 
			DATE(CAST(e.event_time AS TIMESTAMP)) = DATE('2023-01-01')
			AND host IS NOT NULL 
		GROUP BY 1,2
	)
SELECT 
	COALESCE(t.host,y.host) AS host,
	NULL AS host_activity_datelist,
	COALESCE(t.present_date,y.present_date+ INTERVAL '1 day') AS present_date
FROM  today t
FULL OUTER JOIN yesterday y
	ON t.host = y.host;

-- wokring on the datelist for activity of the hosts
WITH yesterday AS (
	SELECT * FROM hosts_cumulated 
	WHERE present_date = DATE('2023-12-31')
),
	today AS (
		SELECT 
		host,
		DATE(CAST(e.event_time AS TIMESTAMP)) AS present_date -- AS we ARE considering FOR active means WITHIN 24 hours that's why we selected date
		FROM events e
		WHERE 
			DATE(CAST(e.event_time AS TIMESTAMP)) = DATE('2023-01-01')
			AND host IS NOT NULL 
		GROUP BY 1,2
	)
SELECT 
	COALESCE(t.host,y.host) AS host,
	CASE
		WHEN y.present_date IS NULL 
			THEN ARRAY[t.present_date]
		WHEN t.present_date IS NULL
			THEN  y.host_activity_datelist 
		ELSE ARRAY[t.present_date] || y.host_activity_datelist 
	END	AS host_activity_datelist,
	COALESCE(t.present_date,y.present_date+ INTERVAL '1 day') AS present_date
FROM  today t
FULL OUTER JOIN yesterday y
	ON t.host = y.host;


-- inserting query 

WITH yesterday AS (
	SELECT * FROM hosts_cumulated 
	WHERE present_date = DATE('2023-12-31')
),
	today AS (
		SELECT 
		host,
		DATE(CAST(e.event_time AS TIMESTAMP)) AS present_date -- AS we ARE considering FOR active means WITHIN 24 hours that's why we selected date
		FROM events e
		WHERE 
			DATE(CAST(e.event_time AS TIMESTAMP)) = DATE('2023-01-01')
			AND host IS NOT NULL 
		GROUP BY 1,2
	)
INSERT INTO hosts_cumulated
SELECT 
	COALESCE(t.host,y.host) AS host,
	CASE
		WHEN y.present_date IS NULL 
			THEN ARRAY[t.present_date]
		WHEN t.present_date IS NULL
			THEN  y.host_activity_datelist 
		ELSE ARRAY[t.present_date] || y.host_activity_datelist 
	END	AS host_activity_datelist,
	COALESCE(t.present_date,y.present_date+ INTERVAL '1 day') AS present_date
FROM  today t
FULL OUTER JOIN yesterday y
	ON t.host = y.host;


SELECT *
FROM hosts_cumulated
WHERE present_date = DATE('2023-01-01');

-- treating 2023-01-01 as YESTERDAY and 2023-01-02 as TODAY

WITH yesterday AS (
	SELECT * FROM hosts_cumulated 
	WHERE present_date = DATE('2023-01-01')
),
	today AS (
		SELECT 
		host,
		DATE(CAST(e.event_time AS TIMESTAMP)) AS present_date -- AS we ARE considering FOR active means WITHIN 24 hours that's why we selected date
		FROM events e
		WHERE 
			DATE(CAST(e.event_time AS TIMESTAMP)) = DATE('2023-01-02')
			AND host IS NOT NULL 
		GROUP BY 1,2
	)
INSERT INTO hosts_cumulated
SELECT 
	COALESCE(t.host,y.host) AS host,
	CASE
		WHEN y.present_date IS NULL 
			THEN ARRAY[t.present_date]
		WHEN t.present_date IS NULL
			THEN  y.host_activity_datelist 
		ELSE ARRAY[t.present_date] || y.host_activity_datelist 
	END	AS host_activity_datelist,
	COALESCE(t.present_date,y.present_date+ INTERVAL '1 day') AS present_date
FROM  today t
FULL OUTER JOIN yesterday y
	ON t.host = y.host;


SELECT *
FROM hosts_cumulated
WHERE present_date = DATE('2023-01-02');




---------------- looping to fill up all the values


DO $$
DECLARE
    start_date DATE := '2023-01-02';
    end_date DATE := '2023-01-30';
BEGIN
    -- Loop through the date range
    WHILE start_date <= end_date LOOP
        -- Construct the dynamic SQL query
        EXECUTE format(
            'WITH yesterday AS (
						SELECT * FROM hosts_cumulated 
						WHERE present_date = %L
					),
						today AS (
							SELECT 
							host,
							DATE(CAST(e.event_time AS TIMESTAMP)) AS present_date 
							FROM events e
							WHERE 
								DATE(CAST(e.event_time AS TIMESTAMP)) = %L
								AND host IS NOT NULL 
							GROUP BY 1,2
						)
					INSERT INTO hosts_cumulated
					SELECT 
						COALESCE(t.host,y.host) AS host,
						CASE
							WHEN y.present_date IS NULL 
								THEN ARRAY[t.present_date]
							WHEN t.present_date IS NULL
								THEN  y.host_activity_datelist 
							ELSE ARRAY[t.present_date] || y.host_activity_datelist 
						END	AS host_activity_datelist,
						COALESCE(t.present_date,y.present_date+ INTERVAL ''1 day'') AS present_date
					FROM  today t
					FULL OUTER JOIN yesterday y
						ON t.host = y.host;',
					            start_date,
					            start_date + INTERVAL '1 day'
					        );
        -- Increment the start_date for the next iteration
        start_date := start_date + INTERVAL '1 day';
    END LOOP;
END $$;

-- though after running the above loop, it says "Updated Rows "0" , check the table if all the values are present or not"
SELECT * 
FROM hosts_cumulated
WHERE present_date = DATE('2023-01-31');



