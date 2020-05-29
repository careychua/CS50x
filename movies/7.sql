-- list all movies released in 2010 and their ratings, in descending order by rating
-- For movies with the same rating, order them alphabetically by title.
-- output a table with two columns, one for the title of each movie and one for the rating of each movie
-- Movies that do not have ratings should not be included in the result
-- 2 columns and 6,835 rows

-- SELECT COUNT(title) FROM movies JOIN ratings ON movies.id = movie_id WHERE movies.year = 2010 ORDER BY rating DESC, title ASC;
SELECT title, rating FROM movies JOIN ratings ON movies.id = movie_id WHERE movies.year = 2010 ORDER BY rating DESC, title ASC;