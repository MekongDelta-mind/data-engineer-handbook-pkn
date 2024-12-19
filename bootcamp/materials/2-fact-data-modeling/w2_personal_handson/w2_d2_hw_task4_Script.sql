/*
 * A datelist_int generation query. Convert the device_activity_datelist column into a datelist_int column
 */



-- creating the table for adding the 
DROP TABLE IF EXISTS user_devices_datelist_int;
CREATE TABLE user_devices_datelist_int (
    user_id TEXT,
    datelist_int BIT(32),
    present_date DATE,
    PRIMARY KEY (user_id, present_date)
)



SELECT *
FROM user_devices_cumulated udc 
WHERE present_date = DATE('2023-01-31') ; 
--WHERE user_id = '10060569187331700000';

-- while calculating how many days the users was active we need to start from the present date, i.e. 2023-01-31

-- the date series to generate last 30 days from today (2023-01-31)
SELECT
	*
FROM
	generate_series(DATE('2023-01-02'),
	DATE('2023-01-31'),
	INTERVAL '1 day') ;


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
	)
SELECT *
--FROM user_devices;
FROM series;


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
	)
SELECT *
FROM user_devices 
	CROSS JOIN series  -- COMMENT the CROSS JOIN AND CHECK what IS it the difference BETWEEN both
WHERE user_id = '10060569187331700000';


-- adding th eis active flag and no of days; also adding the int -values logic

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
	)
SELECT 
	present_date - DATE(series_date) AS days_since,
	-- ONLY series_date gives the minutes diff too
	CASE 
		WHEN device_activity_datelist @> ARRAY[DATE(series_date)]
		THEN POW(2, 32 - (present_date - DATE(series_date)))
		ELSE 0
	END AS placeholder_int_value
	,*
FROM
	user_devices
CROSS JOIN series
	-- COMMENT the CROSS JOIN AND CHECK what IS it the difference BETWEEN both
WHERE
	user_id = '10060569187331700000';
	

-- convertinfg into bitvalue

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
			CAST(
				CASE 
					WHEN device_activity_datelist @> ARRAY[DATE(series_date)]
					THEN CAST(POW(2, 31 - (present_date - DATE(series_date))) AS BIGINT) 
						-- AS OUT CAST IS givine doublt PRECISION error
						-- Also it is 31 instead of 32 as mentioned in the tutorial
					ELSE 0
				END AS BIT(32) -- converting the int vlaues INTO BIT VALUES TO denote 1 ON the DAYs they WHERE active
				) AS placeholder_int_value
			,*
		FROM
			user_devices
		CROSS JOIN series
			-- COMMENT the CROSS JOIN AND CHECK what IS it the difference BETWEEN both
		WHERE
			user_id = '10060569187331700000'
	)
SELECT * 
FROM  place_holder_ints;


-- converting the active days  into the bit values propsely for single user

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
		WHERE
			user_id = '10060569187331700000'
	)
SELECT 
	user_id,
	CAST(CAST(sum(placeholder_int_value) AS BIGINT) AS BIT(32)) -- 11011011000001110111000001110100 FOR user_id = '10060569187331700000'
FROM  place_holder_ints
GROUP BY user_id;


-- for all the users in the above bits value format
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
SELECT 
	user_id,
	sum(placeholder_int_value),
	CAST(CAST(sum(placeholder_int_value) AS BIGINT) AS BIT(32)) 
FROM  place_holder_ints
GROUP BY user_id;


-- counting the number of days as active

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
SELECT 
	user_id,
	sum(placeholder_int_value),
	CAST(CAST(sum(placeholder_int_value) AS BIGINT) AS BIT(32)),
	bit_count(CAST(CAST(sum(placeholder_int_value) AS BIGINT) AS BIT(32))) -- count
FROM  place_holder_ints
GROUP BY user_id;


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
SELECT 
	user_id,
	sum(placeholder_int_value),
	CAST(CAST(sum(placeholder_int_value) AS BIGINT) AS BIT(32)) AS datelist_int,
	bit_count(CAST(CAST(sum(placeholder_int_value) AS BIGINT) AS BIT(32))) > 0 -- count
		AS dim_is_monthly_active,
	bit_count(CAST('1111110000000000000000000000000' AS BIT(32)) & 
		CAST(CAST(sum(placeholder_int_value) AS BIGINT) AS BIT(32))) > 0
		AS dim_is_weekly_active
FROM  place_holder_ints
GROUP BY user_id;

-- selecting specific data to be inserted itno the table user_devices_datelist_int

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
SELECT 
	user_id,
	CAST(CAST(sum(placeholder_int_value) AS BIGINT) AS BIT(32)) AS datelist_int,
	DATE('2023-03-31') as present_date
FROM  place_holder_ints
GROUP BY user_id;


-- INverting values into the table user_devices_datelist_int

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
