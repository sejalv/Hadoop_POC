-- loading data
A = LOAD '/input/movies.dat' using PigStorage('~') as (MOVIEID: chararray, TITLE: chararray, GENRE: chararray);
B = LOAD '/input/ratings_new.dat' using PigStorage('~') as (UserID: chararray, RatingMovieID: chararray, Rating: int, Timestamp: chararray);

-- applying cogroup
Q2 = cogroup  B by RatingMovieID, A by MOVIEID;
store Q2 into '/user/hive/warehouse/imdb.db/out/2';