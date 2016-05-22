use imdb;
DROP TABLE IF EXISTS movies_SciFi;
CREATE TABLE movies_SciFi (movieId STRING, title STRING, genre STRING) ROW FORMAT DELIMITED FIELDS TERMINATED BY '\~';

DROP TABLE IF EXISTS movies_Fantasy;
CREATE TABLE movies_Fantasy (movieId STRING, title STRING, genre STRING) ROW FORMAT DELIMITED FIELDS TERMINATED BY '\~';

DROP TABLE IF EXISTS movies_Thriller;
CREATE TABLE movies_Thriller (movieId STRING, title STRING, genre STRING) ROW FORMAT DELIMITED FIELDS TERMINATED BY '\~';

-- multi table insert
FROM movies_partition mp
  INSERT OVERWRITE TABLE movies_SciFi SELECT mp.movieId, mp.title, mp.genre WHERE mp.genre = 'Sci-Fi'
  INSERT OVERWRITE TABLE movies_Fantasy SELECT mp.movieId, mp.title, mp.genre WHERE mp.genre = 'Fantasy'
  INSERT OVERWRITE TABLE movies_Thriller SELECT mp.movieId, mp.title, mp.genre WHERE mp.genre = 'Thriller';
  
