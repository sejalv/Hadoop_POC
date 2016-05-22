USE imdb;

-- loading movies data
DROP TABLE IF EXISTS movies;
CREATE TABLE movies (movieId STRING, title STRING, genre STRING) ROW FORMAT DELIMITED FIELDS TERMINATED BY '\~';
LOAD DATA LOCAL INPATH '/home/notroot/lab/data/movies.dat' INTO TABLE movies;

-- loading ratings data
DROP TABLE IF EXISTS ratings;
CREATE TABLE ratings(userId STRING, movieId STRING, rating INT, time STRING) ROW FORMAT DELIMITED FIELDS TERMINATED BY '\~';
LOAD DATA LOCAL INPATH '/home/notroot/lab/data/ratings_new.dat' INTO TABLE ratings;

-- finding action movies rating, add user id too
DROP TABLE IF EXISTS action_movies_ratings;
CREATE TABLE action_movies_ratings (movieId STRING, title STRING, genre STRING, userId STRING, rating INT);
INSERT OVERWRITE TABLE action_movies_ratings
select movies.movieId, movies.title, movies.genre, ratings.userId ,ratings.rating from movies JOIN ratings ON (movies.movieId == ratings.movieId) where movies.genre like '%Action%';

-- calculating action movies average rating
DROP TABLE IF EXISTS action_movies_ratings_avg;
CREATE TABLE action_movies_ratings_avg (movieId STRING, title STRING, genre STRING, rating DOUBLE);
INSERT OVERWRITE TABLE action_movies_ratings_avg
select A.movieId, A.title, A.genre, avg(A.rating) from action_movies_ratings A GROUP BY A.movieId, A.title, A.genre;

INSERT OVERWRITE DIRECTORY '/user/hive/warehouse/imdb.db/out/5'
select * from action_movies_ratings_avg order by rating desc limit 10;