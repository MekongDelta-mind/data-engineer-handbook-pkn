
/*

A DDL for an user_devices_cumulated table that has:

    a device_activity_datelist which tracks a users active days by browser_type
    data type here should look similar to MAP<STRING, ARRAY[DATE]>
        or you could have browser_type as a column with multiple rows for each user (either way works, just be consistent!)


*/

DROP TABLE IF EXISTS user_devices_cumulated;
CREATE TABLE user_devices_cumulated (
	user_id TEXT, -- converting FROM BIGINT TO TEXT AS getting OUT OF RANGE error
	device_activity_datelist DATE[], -- list OF dates IN the past WHERE the USER was active
	present_date DATE, -- `date` IN the tutorial query IS changed TO present_date
	browser_type TEXT,
	PRIMARY KEY (user_id, present_date, browser_type) -- should we ADD the browser TYPE OR NOT?
);


-- A cumulative query to generate device_activity_datelist from events

INSERT INTO user_devices_cumulated
WITH 
yesterday AS (
	SELECT 
	*
	FROM 
	user_devices_cumulated udc 
	WHERE present_date = DATE('2022-12-31')
),
today AS ( 
		SELECT
		CAST(e.user_id AS TEXT) AS user_id,
		d.browser_type,
		DATE(CAST(e.event_time AS TIMESTAMP)) AS curr_date
		FROM
				events e
			LEFT JOIN 
			devices d 
			ON
				d.device_id = e.device_id
		WHERE 
			DATE(CAST(e.event_time AS TIMESTAMP)) = DATE('2023-01-01')
			AND user_id IS NOT NULL 
			AND d.browser_type IS NOT NULL 
			GROUP BY 1,2,3
)
SELECT 
	COALESCE(t.user_id,y.user_id) AS user_id,
	CASE WHEN y.present_date IS NULL 
			THEN ARRAY[t.curr_date]
		WHEN t.curr_date IS NULL THEN y.device_activity_datelist  -- WHEN a today's DAY IS inactive THEN we SKIP it AND keep ALL the previous datelist
		ELSE ARRAY[t.curr_date] || y.present_date 
		END
	AS device_activity_datelist,
	COALESCE(t.curr_date, y.present_date + INTERVAL '1 day') AS present_date, -- present_date IS the date IN the user_devices_cumulated TABLE
	t.browser_type AS browser_type
FROM 
today t
FULL OUTER JOIN yesterday y 
ON t.user_id = y.user_id;