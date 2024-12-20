/*
 * 
7. A monthly, reduced fact table DDL host_activity_reduced
    month
    host
    hit_array - think COUNT(1)
    unique_visitors array - think COUNT(DISTINCT user_id)

8. An incremental query that loads host_activity_reduced
    day-by-day
 */


DROP TABLE IF EXISTS host_activity_reduced;
CREATE TABLE host_activity_reduced (
    host TEXT, 
    month_start DATE, 
    hit_array INTEGER[], -- AS it IS a count it would be integer
    unique_visitors_array INTEGER[], -- AS it IS a count it would be integer
    PRIMARY KEY (host,month_start) 
);

SELECT *
FROM hosts_cumulated hc; -- this won't be feasible. we have TO use the events TABLE

SELECT * 
FROM events e;


WITH daily_aggregated AS (
	SELECT
		host,
		count(1) AS num_hit_times,
		count(DISTINCT user_id) AS num_unique_visitors
	FROM events e 
	WHERE DATE(e.event_time) = DATE('2023-01-01')
		AND user_id IS NOT NULL 
	GROUP BY 1
), yesterday_array AS (
	SELECT * 
	FROM host_activity_reduced
	WHERE month_start = DATE('2023-01-01') 
)
SELECT *
FROM daily_aggregated da
	FULL OUTER JOIN yesterday_array ya 
ON da.host=ya.host;



-- seelecting the specific columsn to align with the columns created

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
		COALESCE(ya.month_start, DATE_TRUNC('month',da.date) ) AS month_start,
	NULL  AS num_hit_times,
	NULL AS num_unique_visitors
FROM daily_aggregated da
	FULL OUTER JOIN yesterday_array ya 
ON da.host=ya.host;

SELECT DATE_TRUNC('day', TIMESTAMP '2024-07-27 15:30:45'); -- 2024-07-27 00:00:00.000
SELECT DATE_TRUNC('month', TIMESTAMP '2024-07-27 15:30:45'); -- 2024-07-01 00:00:00.000
SELECT DATE_TRUNC('year', TIMESTAMP '2024-07-27 15:30:45'); -- 2024-01-01 00:00:00.000



--- adding the case when logic for the arrya columns

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
		COALESCE(ya.month_start, DATE_TRUNC('month',da.date) ) AS month_start,
	CASE
		WHEN ya.hit_array IS NULL
			THEN ARRAY[COALESCE(da.num_hit_times,0)]  -- this WILL NOT HAVE UNIFORM length OF ARRAY 
		WHEN ya.hit_array IS NOT NULL 
			THEN ya.hit_array || ARRAY[COALESCE(da.num_hit_times,0)]
	END AS num_hit_times,
	NULL AS num_unique_visitors
FROM daily_aggregated da
	FULL OUTER JOIN yesterday_array ya 
ON da.host=ya.host;
--- ADD THE ON CONFLICT from the video @ 3:32:31 




---------------------------------------------------------------- MAKING THE ARRAY UNIFORM LENGTH

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
	COALESCE(ya.month_start, DATE_TRUNC('month',da.date) ) AS month_start,
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


--- insert query is not working properly as the month_start value is wrong

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























/*
The `DATE_TRUNC` function in PostgreSQL is used to truncate a timestamp or interval to a specific unit of time. Here are several examples demonstrating its usage:

**1. Truncating to the beginning of the day:**

```sql
SELECT DATE_TRUNC('day', TIMESTAMP '2024-07-27 15:30:45');
-- Output: 2024-07-27 00:00:00
```

This truncates the timestamp to the beginning of the day (midnight).

**2. Truncating to the beginning of the month:**

```sql
SELECT DATE_TRUNC('month', TIMESTAMP '2024-07-27 15:30:45');
-- Output: 2024-07-01 00:00:00
```

This truncates the timestamp to the first day of the month.

**3. Truncating to the beginning of the year:**

```sql
SELECT DATE_TRUNC('year', TIMESTAMP '2024-07-27 15:30:45');
-- Output: 2024-01-01 00:00:00
```

This truncates the timestamp to the first day of the year.

**4. Truncating to the beginning of the hour:**

```sql
SELECT DATE_TRUNC('hour', TIMESTAMP '2024-07-27 15:30:45');
-- Output: 2024-07-27 15:00:00
```

This truncates the timestamp to the beginning of the hour.

**5. Other Units:**

`DATE_TRUNC` supports various other units, including:

- `century`
- `decade`
- `millennium`
- `quarter`
- `week` (Sunday as the first day)
- `dow` (day of the week, Sunday is 0)
- `isodow` (ISO day of the week, Monday is 1)
- `week` (Sunday as the first day)
- `isoyear` (ISO year)
- `minute`
- `second`
- `milliseconds`
- `microseconds`

**Example with a table:**

Let's say you have a table named `orders` with a column `order_timestamp`:

```sql
CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    order_timestamp TIMESTAMP
);

INSERT INTO orders (order_timestamp) VALUES
('2024-07-27 10:00:00'),
('2024-07-27 12:30:00'),
('2024-07-28 09:00:00');
```

You can use `DATE_TRUNC` to group orders by day:

```sql
SELECT DATE_TRUNC('day', order_timestamp) AS order_date, COUNT(*) AS order_count
FROM orders
GROUP BY order_date;

-- Output:
-- 2024-07-27 00:00:00 | 2
-- 2024-07-28 00:00:00 | 1
```

This shows the number of orders placed on each day.

**Key takeaway:** The first argument to `DATE_TRUNC` is the unit to truncate to (e.g., 'day', 'month', 'year'), and the second argument is the timestamp or interval value.
 
 */
