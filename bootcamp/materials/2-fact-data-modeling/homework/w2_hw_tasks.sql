
-- A query to deduplicate game_details from Day 1 so there's no duplicates

WITH deduped AS (
	SELECT 
		* ,
		ROW_NUMBER() OVER (PARTITION BY game_id ,team_id, player_id) AS row_num
	FROM game_details
)  
SELECT * 
FROM deduped
WHERE row_num=1;


-- A DDL for an user_devices_cumulated table that has:

