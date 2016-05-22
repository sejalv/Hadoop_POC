-- loading data
A = LOAD '/input/movies.dat' using PigStorage('~') as (MOVIEID: chararray, TITLE: chararray, GENRE: chararray);
B = LOAD '/input/ratings_new.dat' using PigStorage('~') as (UserID: chararray, RatingMovieID: chararray, Rating: int, Timestamp: chararray);

-- applying cogroup
C = cogroup  B by RatingMovieID, A by MOVIEID;
Q3 = foreach C generate flatten(B), flatten(A);
store Q3 into '/user/hive/warehouse/imdb.db/out/3';
