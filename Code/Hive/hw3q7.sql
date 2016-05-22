use imdb;
-- creating tables with partitions
DROP TABLE IF EXISTS movies_partition;
CREATE TABLE movies_partition (movieId STRING, title STRING) 
PARTITIONED BY (genre STRING)  ROW FORMAT DELIMITED  FIELDS TERMINATED BY '\~';

set hive.exec.dynamic.partition.mode=nonstrict;
set hive.exec.dynamic.partition=true;
set hive.enforce.bucketing=true;

-- loading data
FROM movies INSERT OVERWRITE TABLE movies_partition PARTITION (genre) 
SELECT movieid, title, genre WHERE genre not like '%|%' DISTRIBUTE BY genre;

INSERT OVERWRITE DIRECTORY '/user/hive/warehouse/imdb.db/out/7'
select * from movies_partition where genre = '(no genres listed)';
