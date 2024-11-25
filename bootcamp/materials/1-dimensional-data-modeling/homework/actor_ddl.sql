--1. DDL for actors table: Create a DDL for an actors table with the following fields:

DROP TYPE IF EXISTS film_stats CASCADE ;
CREATE TYPE film_stats AS (
	film TEXT,
	votes INTEGER,
	rating FLOAT,
	filmid TEXT
);

DROP TYPE IF EXISTS quality_class CASCADE;
CREATE TYPE quality_class AS ENUM (
			'star',
			'good',
			'average',
			'bad'
			
);

DROP TABLE IF EXISTS actors;
CREATE TABLE actors (
	actor TEXT,
	actorid TEXT,
	film_stats film_stats[], -- create an array
	quality_class quality_class, -- creating an enum star, good average
	current_year integer,
	is_active boolean,
PRIMARY KEY (actorid,current_year)	
);
