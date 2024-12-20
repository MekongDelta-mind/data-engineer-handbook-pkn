
/*
5. A DDL for hosts_cumulated table

    a host_activity_datelist which logs to see which dates each host is experiencing any activity

6. The incremental query to generate host_activity_datelist
*/


DROP TABLE IF EXISTS hosts_cumulated;
CREATE TABLE hosts_cumulated (
    host TEXT, 
    host_activity_datelist DATE[], 
    present_date DATE, 
    PRIMARY KEY (host,present_date) 
);

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




---- looping to fill up whole table
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