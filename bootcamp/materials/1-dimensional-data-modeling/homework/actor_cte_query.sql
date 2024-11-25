-- 2.Cumulative table generation query: Write a query that populates the actors table one year at a time.

INSERT INTO actors --- 
WITH yesteryear AS (
SELECT
	*
FROM
	actors
WHERE
	current_year = 1969  
), 
	toyear AS (
SELECT
    actorid,
    actor,
    year,
	case
	    when year is null then array[]::film_stats[]
	    else array_agg(row(film,rating,votes,filmid)::film_stats)
	end as film_stats,
	case
	    when year is not null then
	        case
	            when avg(rating) > 8 then 'star'
	            when avg(rating) > 7 and avg(rating) <= 8 then 'good'
	            when avg(rating) > 6 and avg(rating) <= 7 then 'average'
	            when avg(rating) <= 6 then 'bad'
	            else null
	        end
	end::quality_class as quality_class
   FROM actor_films
   WHERE year = 1970
   GROUP BY actorid, actor,YEAR		-- the YEAR OF the film IN yesteryear AND toyear IS different
	)
--INSERT INTO actors --- it IS mentioned IN lexture-lab folder OF the course
SELECT 
	COALESCE(t.actor,y.actor) as actor,
	COALESCE(t.actorid,y.actorid) as actorid,
    COALESCE(y.film_stats, ARRAY[]::film_stats[]) ||   -- AS we ARE already creating the struct IN the toyear SELECT itself, we don't need TO again use it here.
                     CASE WHEN t.year IS NOT NULL THEN t.film_stats
                     ELSE ARRAY[]::film_stats[]
            END as films,
	t.quality_class,
	COALESCE(t.year,y.current_year+1) as current_year,
	-- CASE WHEN t.current_year IS NOT NULL THEN t.current_year
	-- 	ELSE y.current_year+1
	-- END as  
	CASE 
		WHEN t.year IS NOT NULL THEN TRUE
		ELSE FALSE
	END as is_active
FROM
	toyear t
FULL OUTER JOIN 
yesteryear y ON
	t.actorid = y.actorid;