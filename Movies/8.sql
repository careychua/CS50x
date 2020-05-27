-- list the names of all people who starred in Toy Story
-- output a table with a single column for the name of each person
-- assume that there is only one movie in the database with the title Toy Story
-- 1 column and 4 rows

-- SELECT id FROM movies WHERE title = "Toy Story";
-- SELECT person_id FROM stars WHERE movie_id IN (SELECT id FROM movies WHERE title = "Toy Story");
SELECT name from people WHERE id IN (SELECT person_id FROM stars WHERE movie_id IN (SELECT id FROM movies WHERE title = "Toy Story"));