# Instructions to run the file

1. Run the docker compose command below to start the flink cluster
    ```shell
    docker compose --env-file flink-env.env up --build --remove-orphans  -d
    ```

1. Run the start job to start the job to collcet the data from the pipeline:
    ```shell
    docker compose exec jobmanager ./bin/flink run -py /opt/src/job/hw_start_job.py --pyFiles /opt/src -d
    ```

1. Check whther the job is started in the flink UI at localhost/8081 .

1. Execute the below command to start the sessionised 5 mins streaming with the below command:
    ```shell
    docker compose exec jobmanager ./bin/flink run -py /opt/src/job/hw_aggregation_job.py --pyFiles /opt/src -d
    ```
1. after executing check whether the aggregation job started or not. 

1. After 5 mins, query the db in postgress to answer the questions in the homework.

NOTE: the `hw_start_job.py` and the `hw_aggregation_job.py` present in the homework notebook should be present in the proper pasth `src/job` so that the command could look for the files to execute in the respective commands.


# Answers Qs in the homework.md
  - What is the average number of web events of a session from a user on Tech Creator?
    - Ans. 
  - Compare results between different hosts (zachwilson.techcreator.io, zachwilson.tech, lulu.techcreator.io)
    - Ans. 


The problem was that the second job( hw_aggregation_job) is not working. and we can't see any values in the table.


The SQL written while dealing with the kafka related things

```SQL
DROP TABLE IF EXISTS processed_events;
CREATE TABLE IF NOT EXISTS processed_events (
    ip VARCHAR,
    event_timestamp TIMESTAMP(3),
    referrer VARCHAR,
    host VARCHAR,
    url VARCHAR,
    geodata VARCHAR
);

-- below table collects general data
DROP TABLE IF EXISTS processed_events_aggregated;
CREATE TABLE processed_events_aggregated (
    event_hour TIMESTAMP(3),
    ip VARCHAR,
    host VARCHAR,
    num_hits BIGINT
);

-- below talbe collects data if the user was redirected from anywhere
DROP TABLE IF EXISTS processed_events_aggregated_source;
CREATE TABLE processed_events_aggregated_source (
    event_hour TIMESTAMP(3),
    ip VARCHAR,
    host VARCHAR,
    referrer VARCHAR,
    num_hits BIGINT
);

TRUNCATE processed_events;
SELECT * FROM 
processed_events 
ORDER BY event_timestamp desc;


SELECT * FROM 
processed_events_aggregated;

SELECT * FROM 
processed_events_aggregated_source;


```