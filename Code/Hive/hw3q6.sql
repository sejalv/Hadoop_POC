use imdb;
-- loading movies
DROP TABLE IF EXISTS movies;
CREATE TABLE movies (movieId STRING, title STRING, genre STRING) ROW FORMAT DELIMITED FIELDS TERMINATED BY '\~';
LOAD DATA LOCAL INPATH '/home/notroot/lab/data/movies.dat' INTO TABLE movies;

-- loading ratings
DROP TABLE IF EXISTS ratings;
CREATE TABLE ratings(userId STRING, movieId STRING, rating INT, time STRING) ROW FORMAT DELIMITED FIELDS TERMINATED BY '\~';
LOAD DATA LOCAL INPATH '/home/notroot/lab/data/ratings_new.dat' INTO TABLE ratings;

-- loading users
DROP TABLE IF EXISTS users;
CREATE TABLE users(userId STRING, gender STRING, age STRING, occupation STRING, zip STRING) ROW FORMAT DELIMITED FIELDS TERMINATED BY '\~';
LOAD DATA LOCAL INPATH '/home/notroot/lab/data/users.dat' INTO TABLE users;

-- finding male users
DROP TABLE IF EXISTS male_users;
CREATE TABLE male_users (userId STRING, gender STRING, age STRING, occupation STRING, zip STRING);
INSERT OVERWRITE TABLE male_users
select * from users where gender='M';

-- finding ratings rated by male
DROP TABLE IF EXISTS male_ratings;
CREATE TABLE male_ratings (userId STRING, movieId STRING, rating INT, time STRING);
INSERT OVERWRITE TABLE male_ratings
select ratings.userId, ratings.movieId, ratings.rating, ratings.time from ratings JOIN male_users ON (ratings.userId == male_users.userId);

-- finding action or drama movies
DROP TABLE IF EXISTS action_drama_movies;
CREATE TABLE action_drama_movies (movieId STRING, title STRING, genre STRING);
INSERT OVERWRITE TABLE action_drama_movies
select * from movies where movies.genre like '%Action%' OR movies.genre like '%Drama%';

-- finding action or drama movies ratings rated by male 
DROP TABLE IF EXISTS male_rated_ad_movies;
CREATE TABLE male_rated_ad_movies (movieId STRING, title STRING, genre STRING, userId STRING, rating INT);
INSERT OVERWRITE TABLE male_rated_ad_movies
select A.movieId, A.title, A.genre, B.userId, B.rating from action_drama_movies A JOIN male_ratings B ON (A.movieId == B.movieId);

-- finding action or drama movies avg ratings rated by male 
DROP TABLE IF EXISTS male_rated_ad_movies_avg;
CREATE TABLE male_rated_ad_movies_avg (movieId STRING, title STRING, genre STRING, rating DOUBLE);
INSERT OVERWRITE TABLE male_rated_ad_movies_avg
select A.movieId, A.title, A.genre, avg(A.rating) from male_rated_ad_movies A group by A.movieId, A.title, A.genre;

INSERT OVERWRITE DIRECTORY '/user/hive/warehouse/imdb.db/out/6'
select * from male_rated_ad_movies_avg where rating>=4.4 AND rating<=4.7;
