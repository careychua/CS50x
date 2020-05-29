-- titles of the five highest rated movies (in order) that Chadwick Boseman starred in, starting with the highest rated
-- output a table with a single column for the title of each movie
-- assume that there is only one person in the database with the name Chadwick Boseman
-- 1 column and 5 rows

-- SELECT id from people WHERE name = "Chadwick Boseman";
-- SELECT movie_id FROM stars WHERE person_id IN (SELECT id from people WHERE name = "Chadwick Boseman");
SELECT title from movies JOIN ratings ON movies.id = ratings.movie_id WHERE ratings.movie_id IN (SELECT movie_id FROM stars WHERE person_id IN (SELECT id from people WHERE name = "Chadwick Boseman")) ORDER BY rating DESC LIMIT 5;