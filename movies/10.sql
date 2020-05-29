-- list the names of all people who have directed a movie that received a rating of at least 9.0
-- output a table with a single column for the name of each person
-- 1 column and 1,841 rows

-- SELECT movie_id FROM ratings WHERE rating >= 9;
-- SELECT person_id FROM directors WHERE movie_id IN (SELECT movie_id FROM ratings WHERE rating >= 9);
-- SELECT COUNT(name) FROM people WHERE id IN (SELECT person_id FROM directors WHERE movie_id IN (SELECT movie_id FROM ratings WHERE rating >= 9));
SELECT name FROM people WHERE id IN (SELECT person_id FROM directors WHERE movie_id IN (SELECT movie_id FROM ratings WHERE rating >= 9));