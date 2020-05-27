-- list the titles and release years of all Harry Potter movies, in chronological order
-- output a table with two columns, one for the title of each movie and one for the release year of each movie
-- assume that the title of all Harry Potter movies will begin with the words “Harry Potter”, and that if a movie title begins with the words “Harry Potter”, it is a Harry Potter movie
-- 2 columns and 10 rows

-- SELECT COUNT(title) FROM movies WHERE title LIKE "Harry Potter%";
SELECT title, year FROM movies WHERE title LIKE "Harry Potter%" ORDER BY year;