-- list the titles of all movies released in 2008
-- output a table with a single column for the title of each movie
-- 1 column, 9480 rows

-- SELECT COUNT(title) from movies WHERE year = 2008;
SELECT title from movies WHERE year = 2008;