-- A query to deduplicate game_details from Day 1 so there's no duplicates

SELECT
	*
FROM game_details gd ;


/*
 * How to check if there are duplicates in the table
 * Counting the no of ids in the form of counts 
 */

SELECT 
	game_id ,team_id, player_id, count(1) AS count_num 
FROM  game_details gd 
GROUP BY 1,2,3
--ORDER BY 4 desc;
HAVING 
    count(1) > 1; 


/*how to dedupe the given table with duplicates
 *  * /
 */
 

-- duplicated and non duplicated rows with duplicated rows first
WITH deduped AS (
	SELECT 
		* ,
		ROW_NUMBER() OVER (PARTITION BY game_id ,team_id, player_id) AS row_num
	FROM game_details
)  
SELECT * 
FROM deduped 
ORDER BY row_num desc;


--select duplicated rows
WITH deduped AS (
	SELECT 
		* ,
		ROW_NUMBER() OVER (PARTITION BY game_id ,team_id, player_id) AS row_num
	FROM game_details
)  
SELECT count(*) 
FROM deduped 
WHERE  row_num!=1;


WITH deduped AS (
	SELECT 
		* ,
		ROW_NUMBER() OVER (PARTITION BY game_id ,team_id, player_id) AS row_num
	FROM game_details
)  
SELECT * 
FROM deduped
WHERE game_id = '22000001' AND team_id = '1610612744' AND player_id = '201939'; -- gives 2 duplicates FOR same gameid, team_id AND player_id


WITH deduped AS (
	SELECT 
		* ,
		ROW_NUMBER() OVER (PARTITION BY game_id ,team_id, player_id) AS row_num
	FROM game_details
)  
SELECT count(*) 
FROM deduped 
WHERE row_num=1; -- SELECT ONLY the single entry FOR EACH UNIQUE query OUT there. 
--246043 -> total rows
--245754 -> real entry
--289	 -> duplicates


WITH deduped AS (
	SELECT 
		* ,
		ROW_NUMBER() OVER (PARTITION BY game_id ,team_id, player_id) AS row_num
	FROM game_details
)  
SELECT * 
FROM deduped
WHERE row_num=1;