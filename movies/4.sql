-- number of movies with an IMDb rating of 10.0
-- output a table with a single column and a single row (plus optional header) containing the number of movies with a 10.0 rating
-- 1 column and 1 row

-- SELECT rating FROM ratings ORDER BY rating DESC;
SELECT COUNT(rating) FROM ratings WHERE rating = 10;