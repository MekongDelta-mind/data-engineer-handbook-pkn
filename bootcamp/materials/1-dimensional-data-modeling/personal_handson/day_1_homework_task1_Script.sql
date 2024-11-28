/*
 * bootcamp/materials/1-dimensional-data-modeling/homework/homework.md
 * https://github.com/MekongDelta-mind/data-engineer-handbook-pkn/blob/main/bootcamp/materials/1-dimensional-data-modeling/homework/homework.md#assignment-tasks
 * 
 * Dimensional Data Modeling - Week 1
 * This week's assignment involves working with the actor_films dataset. Your task is to construct 
 * a series of SQL queries and table definitions that will allow us to model the actor_films dataset 
 * in a way that facilitates efficient analysis. This involves creating new tables, defining data types, 
 * and writing queries to populate these tables with data from the actor_films dataset
 * 
*/

/*
 * Dataset Overview
 * The actor_films dataset contains the following fields:

    actor: The name of the actor.
    actorid: A unique identifier for each actor.
    film: The name of the film.
    year: The year the film was released.
    votes: The number of votes the film received.
    rating: The rating of the film.
    filmid: A unique identifier for each film.

The primary key for this dataset is (actor_id, film_id).
 */

SELECT
	*
FROM
	postgres.public.actor_films af ;

/*
 * Q1 ->> DDL for actors table: Create a DDL for an actors table with the following fields:
 * 

    films: An array of struct with the following fields:
        film: The name of the film.
        votes: The number of votes the film received.
        rating: The rating of the film.
        filmid: A unique identifier for each film.

    quality_class: This field represents an actor's performance quality, determined by the average rating 
    of movies of their most recent year. It's categorized as follows:
        star: Average rating > 8.
        good: Average rating > 7 and ≤ 8.
        average: Average rating > 6 and ≤ 7.
        bad: Average rating ≤ 6.

    is_active: A BOOLEAN field that indicates whether an actor is currently active in the film industry 
    (i.e., making films this year).

Additional notes while solving the problem
* DDL or Data Definition Language actually consists of the SQL commands that can be used for defining, altering,
	and deleting database structures such as tables, indexes, and schemas.
	* CREATE, DROP, ALTER,[used fequently] 
	* TRUNCATE, COMMENT, RENAME [used very rarely]  
* for `is_active` first extract the current_year and then try to check if the actor is present or not

 *
 * creating the table  before creating the film types give hte error as
 * SQL Error [42704]: ERROR: type "films[]" does not exist
  Position: 30 
 */
 
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


--------------------------------- Checking the tables if created are correct enough
SELECT
	*
FROM
	actors ;
-- checking the table on the fly
SELECT
	column_name,
	data_type,
	character_maximum_length,
	column_default,
	is_nullable
FROM
	information_schema.columns
WHERE
	table_name = 'actors';
-- additional info about the information_schema AT the END 

------------------------------------------------------------------------------------------------ Task1 completed



/*
 * INFORMATION_SCHEMA
 * 
 * information_schema is not a database. It's a special schema in PostgreSQL that provides a standardized way to access metadata about the database. This includes information about tables, columns, data types, constraints, users, and more.

Key Points about information_schema:

    Read-Only: You cannot modify the data within information_schema. It's designed for querying information about the database.
    Standardized: It adheres to the SQL standard, making it portable across different database systems.
    Accessible to All Users: Any user can query the information_schema to get information about the database.

Common Tables in information_schema:

Here are some of the most commonly used tables within the information_schema:

    tables: Provides information about tables in the database, including their names, schemas, and types (table, view, etc.).
    columns: Provides information about columns in tables, including their names, data types, nullability, and default values.
    routines: Provides information about stored procedures and functions, including their names, parameters, and return types.
    schemata: Provides information about schemas in the database, including their names and owners.
    views: Provides information about views, including their names, defining queries, and schemas.
    triggers: Provides information about triggers, including their names, event objects, and actions.
    constraints: Provides information about constraints, including their names, types, and related tables and columns.
    users: Provides information about users, including their names, roles, and privileges.

By querying these tables, you can get a comprehensive overview of your database's structure and metadata. This information is often 
used for database administration, application development, and data analysis tasks.


-- pg_cATALOG

pg_catalog

 is a special schema in PostgreSQL that contains the system catalogs. These catalogs store metadata about the database itself, such as information about tables, columns, indexes, functions, operators, types, and other database objects.

Key Points about pg_catalog:

    System-Managed: It's primarily managed by the PostgreSQL system itself.
    Read-Only (Usually): While it's technically possible to modify these tables, it's strongly discouraged as it can lead to database corruption.
    Complex Structure: The pg_catalog schema is quite complex and contains a large number of tables, each with specific purposes.
    Used for Internal Operations: PostgreSQL uses this schema to manage its internal operations and enforce data integrity.

While you can query pg_catalog tables to gain insights into your database's structure, it's generally not recommended for everyday tasks. Instead, you should rely on the information_schema schema, which provides a more user-friendly and standardized view of the database metadata.

Caution:

    Direct Modification: Avoid directly modifying tables in pg_catalog. This can lead to serious database issues.
    Complex Queries: Queries against pg_catalog can be complex and require a deep understanding of PostgreSQL's internal workings.

If you need to perform advanced database administration tasks, it's recommended to consult the PostgreSQL documentation or seek expert advice.


The 

pg_catalog schema contains a large number of tables, each serving specific purposes in managing the database's internal structure and metadata. Here are some of the key tables and their functions:

Core Tables:

    pg_class: Stores information about all relations (tables, indexes, views, sequences, etc.) in the database.
    pg_attribute: Contains information about the columns of a relation, including their data types, default values, and constraints.
    pg_type: Stores information about data types in the database.
    pg_namespace: Stores information about schemas.
    pg_proc: Stores information about functions and procedures.
    pg_index: Stores information about indexes.
    pg_constraint: Stores information about constraints, such as primary keys, foreign keys, unique constraints, and check constraints.

Additional Tables:

    pg_roles: Stores information about database roles and users.
    pg_database: Stores information about databases.
    pg_tablespace: Stores information about tablespaces.
    pg_authid: Stores information about authentication identities.
    pg_largeobject: Stores information about large objects (LOBs).
    pg_aggregate: Stores information about aggregate functions.
    pg_operator: Stores information about operators.
    pg_opclass: Stores information about operator classes.
    pg_am: Stores information about access methods (e.g., B-tree, hash).

Note:

    The exact list of tables in pg_catalog may vary slightly between different PostgreSQL versions.
    Directly querying and modifying these tables can be risky and should only be done with caution and a deep understanding of PostgreSQL's internal workings.

Recommended Approach:

For most database administration tasks, it's recommended to use the information_schema schema, which provides a more user-friendly and standardized view of the database metadata.


DATABASE, SCHEMA AND TABLES

**Database, Schema, and Table in PostgreSQL**

In PostgreSQL, these terms represent hierarchical levels of data organization:

**Database:**

* A **container** for one or more schemas.
* It's the **highest level** of organization within a PostgreSQL instance.
* Think of it as a physical storage location for your data.

**Schema:**

* A **logical grouping** of database objects like tables, views, functions, etc.
* It's a way to **organize** related objects within a database.
* Multiple schemas can exist within a single database.
* Think of it as a folder within a database.

**Table:**

* A **collection of rows and columns** that stores data.
* The **basic unit** of data storage.
* Each row represents a record, and each column represents a field within that record.
* Tables reside within schemas.

**Analogy:**

Imagine a library:

* **Database:** The entire library building.
* **Schema:** A specific section of the library (e.g., fiction, non-fiction, reference).
* **Table:** A specific book within that section.

**Why Use Schemas?**

* **Organization:** Group related objects together for better management.
* **Access Control:** Implement fine-grained access control at the schema level.
* **Namespace Management:** Avoid naming conflicts between objects in different schemas.

By understanding these concepts, you can effectively organize and manage your data in PostgreSQL.

