-- determine the average rating of all movies released in 2012
-- output a table with a single column and a single row (plus optional header) containing the average rating
-- 1 column and 1 row

-- returns 50 ids
-- SELECT id FROM movies WHERE year = 2012;

-- returns 43 ids
-- SELECT rating FROM ratings WHERE movie_id IN (SELECT id FROM movies WHERE year = 2012);

-- 6.27545924967655
-- SELECT AVG(ratings.rating) FROM movies JOIN ratings ON movies.id = ratings.movie_id WHERE year = 2012;

-- 6.27545924967655
SELECT AVG(rating) FROM ratings WHERE movie_id IN (SELECT id FROM movies WHERE year = 2012);