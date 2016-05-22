-- filtering action and war movies
A = LOAD '/input/movies.dat' using PigStorage('~') as (MOVIEID: chararray, TITLE: chararray, GENRE: chararray);
B = filter A by ((GENRE matches '.*Action.*') AND (GENRE matches '.*War.*')); 

-- finding action and war movie ratings
C = LOAD '/input/ratings_new.dat' using PigStorage('~') as (UserID: chararray, MovieID: chararray, Rating: int, Timestamp: chararray);
D = JOIN B by $0, C by MovieID;

-- calculating avg
E = group D by $0;
F = foreach E generate group as mvId,  AVG(D.Rating) as avgRating; 

-- finding max avg-rating
G = group F ALL;
H = FOREACH G GENERATE MAX(F.$1) AS avgMax;

-- finding max avg-rated movie
I = FILTER F BY (float)avgRating == (float)H.avgMax;

-- filtering female users age between 20-30
J = LOAD '/input/users.dat' using PigStorage('~') as (UserID: chararray, Gender: chararray, Age: int, Occupation: chararray, Zip: chararray);
K = filter J by ((Gender == 'F') AND (Age >= 20 AND Age <= 30)); 
L = foreach K generate UserID;

-- finding filtered female users rated movies
M = JOIN L by $0, C by UserID;

-- finding filtered female users who rated highest rated action and war movies
N = JOIN I by $0, M by $2;

-- finding distinct female users
O = foreach N generate $2 as User;
Q1 = Distinct O;
store Q1 into '/user/hive/warehouse/imdb.db/out/1';
