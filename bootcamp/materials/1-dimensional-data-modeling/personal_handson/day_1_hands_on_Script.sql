--DAY 1 - Dimensional Data Modelling
SELECT
	*
FROM
	postgres.public.player_seasons ps
ORDER BY
	player_name ;
--- creating a array for season containing all the values over hte season for a particular player
--- creting array type; what it actual does?
CREATE TYPE season_stats AS ( -- CREATE TYPE — define a new data type 
				season INTEGER,
				gp INTEGER ,
				pts REAL ,
				reb REAL ,
				ast REAL 
				);
-- present under the data types in Dbeaver

CREATE TABLE players(
		player_name TEXT,
		height TEXT,
		college TEXT,
		country TEXT,
		draft_year TEXT,
		draft_round TEXT,
		draft_number TEXT,
-- above this vlaues doesn't chnage
season_stats season_stats[],
-- creating an array of season stats
current_season integer,
--- the latest season from the whole season_stats arr
		PRIMARY KEY (player_name,
current_season)
-- unique identifier from the table
);

SELECT
	*
FROM
	players;

SELECT
	min(season)
	FROM postgres.public.player_seasons ps;

SELECT
	*
FROM
	players
WHERE
	current_season = 1995;
-- chekcing if the query is returning the correct results
WITH yesterday AS (
SELECT
	*
FROM
	players
WHERE
	current_season = 1995
),
	today AS (
SELECT
	*
FROM
	player_seasons ps
WHERE
	ps.season = 1996
	)
SELECT
	*
FROM
	today t
FULL OUTER JOIN yesterday y
ON
	t.player_name = y.player_name;
-- adding the coalesce to the terms
WITH yesterday AS (
SELECT
	*
FROM
	players
WHERE
	current_season = 1995
),
	today AS (
SELECT
	*
FROM
	player_seasons ps
WHERE
	ps.season = 1996
	)
SELECT
	COALESCE(t.player_name,
	y.player_name) AS player_name,
	COALESCE(t.height,
	y.height) AS height,
	COALESCE(t.college,
	y.college) AS college,
	COALESCE(t.draft_year,
	y.draft_year) AS draft_year,
	COALESCE(t.draft_round,
	y.draft_round) AS draft_round,
	COALESCE(t.draft_number,
	y.draft_number) AS draft_number,
	CASE
		WHEN y.season_stats IS NULL 
		THEN ARRAY[ROW(
				t.season,
				t.gp,
				t.pts,
				t.reb,
				t.ast
			)::season_stats]
		-- ::season_stats] -- casts the row into hte said type
		ELSE y.season_stats || ARRAY[ROW(
		-- || array[row(  -- concatenating  the next row
		t.season,
				t.gp,
				t.pts,
				t.reb,
				t.ast
			)::season_stats]
	END
FROM
	today t
FULL OUTER JOIN yesterday y
ON
	t.player_name = y.player_name;
--- adding another condition when the player is retired 
WITH yesterday AS (
SELECT
	*
FROM
	players
WHERE
	current_season = 1995
),
	today AS (
SELECT
	*
FROM
	player_seasons ps
WHERE
	ps.season = 1996
	)
SELECT
	COALESCE(t.player_name,
	y.player_name) AS player_name,
	COALESCE(t.height,
	y.height) AS height,
	COALESCE(t.college,
	y.college) AS college,
	COALESCE(t.country,
	y.country) AS country,
	COALESCE(t.draft_year,
	y.draft_year) AS draft_year,
	COALESCE(t.draft_round,
	y.draft_round) AS draft_round,
	COALESCE(t.draft_number,
	y.draft_number) AS draft_number,
	CASE
		WHEN y.season_stats IS NULL 
		THEN ARRAY[ROW(
				t.season,
				t.gp,
				t.pts,
				t.reb,
				t.ast
			)::season_stats]
		WHEN t.season IS NOT NULL 
		THEN y.season_stats || ARRAY[ROW(
		-- concatenating  the next row
		t.season,
				t.gp,
				t.pts,
				t.reb,
				t.ast
			)::season_stats]
		ELSE y.season_stats
	END AS season_stats,
	COALESCE(t.season,
	y.current_season + 1) AS current_season
	-- case
	--  	when t.season is not null then t.season
	--  	else y.current_season + 1
	--  end	
FROM
	today t
FULL OUTER JOIN yesterday y
ON
	t.player_name = y.player_name;
-- above is the final query which gives you the correct data and 
-- now you can start inserting the values in the players table
-- this is flow of creating and inserting the values.
-- when yesteryear = 1995(nulls) and toyear = 1996
INSERT
	INTO
	players
WITH yesterday AS (
	SELECT
		*
	FROM
		players
	WHERE
		current_season = 1995
),
	today AS (
	SELECT
		*
	FROM
		player_seasons ps
	WHERE
		ps.season = 1996
	)
SELECT
	COALESCE(t.player_name,
	y.player_name) AS player_name,
	COALESCE(t.height,
	y.height) AS height,
	COALESCE(t.college,
	y.college) AS college,
	COALESCE(t.country,
	y.country) AS country,
	COALESCE(t.draft_year,
	y.draft_year) AS draft_year,
	COALESCE(t.draft_round,
	y.draft_round) AS draft_round,
	COALESCE(t.draft_number,
	y.draft_number) AS draft_number,
	CASE
		WHEN y.season_stats IS NULL 
		THEN ARRAY[ROW(
				t.season,
				t.gp,
				t.pts,
				t.reb,
				t.ast
			)::season_stats]
		WHEN t.season IS NOT NULL 
		THEN y.season_stats || ARRAY[ROW(
		-- concatenating  the next row
		t.season,
				t.gp,
				t.pts,
				t.reb,
				t.ast
			)::season_stats]
		ELSE y.season_stats
	END AS season_stats,
	COALESCE(t.season,
	y.current_season + 1) AS current_season
	-- case
	--  	when t.season is not null then t.season
	--  	else y.current_season + 1
	--  end	
FROM
	today t
FULL OUTER JOIN yesterday y
ON
	t.player_name = y.player_name;
-- when yesteryear = 1996 and toyear = 1997
INSERT
	INTO
	players
WITH yesterday AS (
	SELECT
		*
	FROM
		players
	WHERE
		current_season = 1996
),
	today AS (
	SELECT
		*
	FROM
		player_seasons ps
	WHERE
		ps.season = 1997
	)
SELECT
	COALESCE(t.player_name,
	y.player_name) AS player_name,
	COALESCE(t.height,
	y.height) AS height,
	COALESCE(t.college,
	y.college) AS college,
	COALESCE(t.country,
	y.country) AS country,
	COALESCE(t.draft_year,
	y.draft_year) AS draft_year,
	COALESCE(t.draft_round,
	y.draft_round) AS draft_round,
	COALESCE(t.draft_number,
	y.draft_number) AS draft_number,
	CASE
		WHEN y.season_stats IS NULL 
		THEN ARRAY[ROW(
				t.season,
				t.gp,
				t.pts,
				t.reb,
				t.ast
			)::season_stats]
		WHEN t.season IS NOT NULL 
		THEN y.season_stats || ARRAY[ROW(
		-- concatenating  the next row
		t.season,
				t.gp,
				t.pts,
				t.reb,
				t.ast
			)::season_stats]
		ELSE y.season_stats
	END AS season_stats,
	COALESCE(t.season,
	y.current_season + 1) AS current_season
	-- case
	--  	when t.season is not null then t.season
	--  	else y.current_season + 1
	--  end	
FROM
	today t
FULL OUTER JOIN yesterday y
ON
	t.player_name = y.player_name;
-- first chekcing the with ..... slq part and then
-- addint the insert into players just above to be 
-- sure that the inserted data would be cirrect	

SELECT
	*
FROM
	players;
-- for today.season = 1996
SELECT
	count(*)
FROM
	players
WHERE
	current_season = 1996;
-- for today.season = 1996


SELECT
	*
FROM
	players
WHERE
	current_season = 1997;

SELECT
	count(*)
FROM
	players
WHERE
	current_season = 1997;

/*
 * in datagrip we get 
{'(1996,83,7.2,7.9,0.8)','(1997,82,7.3,8.1,1.5)'}
in dbeaver we get a bit different like
1996(+1),83(+1),7.2(+1),7.9(+1),0.8(+1) in the viwer below.
But when you do an advanced copy and paste the values then below is the results
season
{'(1996,83,7.2,7.9,0.8)','(1997,82,7.3,8.1,1.5)'}

*/