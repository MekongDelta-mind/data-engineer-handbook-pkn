
-- creating the table to insert the values

DROP TABLE IF EXISTS user_devices_datelist_int;
CREATE TABLE user_devices_datelist_int (
    user_id TEXT,
    datelist_int BIT(32),
    present_date DATE,
    PRIMARY KEY (user_id, present_date)
)



--- datelist_int generation query 
WITH user_devices AS (
	SELECT * FROM
		user_devices_cumulated udc
	WHERE
		present_date = DATE('2023-01-31') 
),
	series AS (
		SELECT * FROM
		generate_series(DATE('2023-01-02'),	DATE('2023-01-31'),INTERVAL '1 day') 
		AS series_date
	),
	place_holder_ints AS (
				SELECT 
			present_date - DATE(series_date) AS days_since,
			-- ONLY series_date gives the minutes diff too
			CASE 
				WHEN device_activity_datelist @> ARRAY[DATE(series_date)]
				THEN CAST(POW(2, 31 - (present_date - DATE(series_date))) AS BIGINT) 
					-- AS OUT CAST IS givine doublt PRECISION error
				ELSE 0
			END
			AS placeholder_int_value
			,*
		FROM
			user_devices
		CROSS JOIN series
			-- COMMENT the CROSS JOIN AND CHECK what IS it the difference BETWEEN both
--		WHERE user_id = '10060569187331700000'
	)
INSERT INTO user_devices_datelist_int
SELECT 
	user_id,
	CAST(CAST(sum(placeholder_int_value) AS BIGINT) AS BIT(32)) AS datelist_int,
	DATE('2023-03-31') as present_date
FROM  place_holder_ints
GROUP BY user_id;

SELECT *
FROM user_devices_datelist_int;